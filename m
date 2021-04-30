Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FEEC43470
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D1A761405
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhD3GCT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhD3GCS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF7AA61481;
        Fri, 30 Apr 2021 06:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762491;
        bh=Ya4a6Iko/an1dk5kYdNkgitnzARaKdvLMcFSsovVqU0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nU6LLkYaJw1M6iyBjcrw0JZGi5CEx67ELG3X3xgfEbENoARPMz/VA7Mm5dDzZODGP
         s+WV23F0GFccfEQ/zILhREFeB89MWrpSBG6+B7i+WfifSoHVT027Q19hDoCpOi/mGY
         kYbX4tWxuNRq6onFEj5inNDAeuR7UxdO0wJOTVx8=
Date:   Thu, 29 Apr 2021 23:01:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, jbaron@akamai.com,
        joaodias@google.com, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 162/178] mm: page_alloc: dump migrate-failed pages
Message-ID: <20210430060130.NUadzonOe%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: page_alloc: dump migrate-failed pages

Currently, debugging CMA allocation failures is quite limited.  The most
common source of these failures seems to be page migration which doesn't
provide any useful information on the reason of the failure by itself. 
alloc_contig_range can report those failures as it holds a list of
migrate-failed pages.

The information logged by dump_page() has already proven helpful for
debugging allocation issues, like identifying long-term pinnings on
ZONE_MOVABLE or MIGRATE_CMA.

Let's use the dynamic debugging infrastructure, such that we avoid
flooding the logs and creating a lot of noise on frequent
alloc_contig_range() calls.  This information is helpful for debugging
only.

There are two ifdefery conditions to support common dyndbg options:

- CONFIG_DYNAMIC_DEBUG_CORE && DYNAMIC_DEBUG_MODULE
  It aims for supporting the feature with only specific file with
  adding ccflags.

- CONFIG_DYNAMIC_DEBUG
  It aims for supporting the feature with system wide globally.

A simple example to enable the feature:

Admin could enable the dump like this(by default, disabled)

	echo "func alloc_contig_dump_pages +p" > control

Admin could disable it.

	echo "func alloc_contig_dump_pages =_" > control

Detail goes Documentation/admin-guide/dynamic-debug-howto.rst

A concern is utility functions in dump_page use inconsistent
loglevels. In the future, we might want to make the loglevels
used inside dump_page() consistent and eventually rework the way
we log the information here. See [1].

[1] https://lore.kernel.org/linux-mm/YEh4doXvyuRl5BDB@google.com/

Link: https://lkml.kernel.org/r/20210311194042.825152-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: John Dias <joaodias@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-dump-migrate-failed-pages
+++ a/mm/page_alloc.c
@@ -8497,6 +8497,27 @@ static unsigned long pfn_max_align_up(un
 				pageblock_nr_pages));
 }
 
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
+/* Usage: See admin-guide/dynamic-debug-howto.rst */
+static void alloc_contig_dump_pages(struct list_head *page_list)
+{
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, "migrate failure");
+
+	if (DYNAMIC_DEBUG_BRANCH(descriptor)) {
+		struct page *page;
+
+		dump_stack();
+		list_for_each_entry(page, page_list, lru)
+			dump_page(page, "migration failure");
+	}
+}
+#else
+static inline void alloc_contig_dump_pages(struct list_head *page_list)
+{
+}
+#endif
+
 /* [start, end) must belong to a single zone. */
 static int __alloc_contig_migrate_range(struct compact_control *cc,
 					unsigned long start, unsigned long end)
@@ -8540,6 +8561,7 @@ static int __alloc_contig_migrate_range(
 				NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE);
 	}
 	if (ret < 0) {
+		alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
 		return ret;
 	}
_
