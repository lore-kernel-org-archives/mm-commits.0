Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EEAC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF9664F8B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCKUaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhCKUaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 15:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104F164F8E;
        Thu, 11 Mar 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615494604;
        bh=68nQQuT6CWoqmTrwtQEJtvU59dTM/49Ex9O1d7B9FpE=;
        h=Date:From:To:Subject:From;
        b=rz6UhvdNVFuixrwHK/8rPROFo+tQUYqaLxUYo2TRD951jIbWoFQLOXlOyjdyaCjN/
         7ntwr/yKUQC5Mb0F84aUiy4d2iM0Z83wpr8ww66vAAlS9GjdnW0UAP445bRy/u6Qlt
         DRrpQYSGSuTAUVjNMBBN1Uzh7MGmnanhH7j0cdg4=
Date:   Thu, 11 Mar 2021 12:30:03 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, jbaron@akamai.com, joaodias@google.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-page_alloc-dump-migrate-failed-pages.patch added to
 -mm tree
Message-ID: <20210311203003.tvyFdw80N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: dump migrate-failed pages
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dump-migrate-failed-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dump-migrate-failed-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dump-migrate-failed-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -8473,6 +8473,27 @@ static unsigned long pfn_max_align_up(un
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
@@ -8516,6 +8537,7 @@ static int __alloc_contig_migrate_range(
 				NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE);
 	}
 	if (ret < 0) {
+		alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
 		return ret;
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-vmstat-add-cma-statistics.patch

