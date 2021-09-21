Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9217DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 22:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7F861156
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 22:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhIUWx6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 18:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhIUWxz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 18:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7FCB6115A;
        Tue, 21 Sep 2021 22:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632264746;
        bh=HUjlFJWeq7U79dioiLYRCjfTWvhJEzJFfN73UV9miqg=;
        h=Date:From:To:Subject:From;
        b=Jv9EhHdBsf95DAaHzZbVemwGOnMhs4RpwTbSUar0HdOUp+vkdkdRUTJx2mgxxKgXg
         s+haHPTfv3lhjq2lZZHB/7Fm0Q1QahJA7o41f5mbrKNaEom8S4Y2E+d3Er7N53RjqV
         b99IXi/EIJLhNJPOrzKmvLsz0OkNNvpIY4/1yCzI=
Date:   Tue, 21 Sep 2021 15:52:25 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, dave.hansen@linux.intel.com,
        jhubbard@nvidia.com, khandual@linux.vnet.ibm.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        o451686892@gmail.com, osalvador@suse.de, pasha.tatashin@soleen.com,
        weixugc@google.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  +
 mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names.patch added
 to -mm tree
Message-ID: <20210921225225.W-XxW8CCB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: sync up latest migrate_reason to migrate_reason_names
has been added to the -mm tree.  Its filename is
     mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weizhao Ouyang <o451686892@gmail.com>
Subject: mm/debug: sync up latest migrate_reason to migrate_reason_names

Sync up MR_DEMOTION to migrate_reason_names and add a synch prompt.

Link: https://lkml.kernel.org/r/20210921064553.293905-3-o451686892@gmail.com
Fixes: 26aa2d199d6f ("mm/migrate: demote pages during reclaim")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    6 +++++-
 mm/debug.c              |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/migrate.h~mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names
+++ a/include/linux/migrate.h
@@ -19,6 +19,11 @@ struct migration_target_control;
  */
 #define MIGRATEPAGE_SUCCESS		0
 
+/*
+ * Keep sync with:
+ * - macro MIGRATE_REASON in include/trace/events/migrate.h
+ * - migrate_reason_names[MR_TYPES] in mm/debug.c
+ */
 enum migrate_reason {
 	MR_COMPACTION,
 	MR_MEMORY_FAILURE,
@@ -32,7 +37,6 @@ enum migrate_reason {
 	MR_TYPES
 };
 
-/* In mm/debug.c; also keep sync with include/trace/events/migrate.h */
 extern const char *migrate_reason_names[MR_TYPES];
 
 #ifdef CONFIG_MIGRATION
--- a/mm/debug.c~mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names
+++ a/mm/debug.c
@@ -26,6 +26,7 @@ const char *migrate_reason_names[MR_TYPE
 	"numa_misplaced",
 	"contig_range",
 	"longterm_pin",
+	"demotion",
 };
 
 const struct trace_print_flags pageflag_names[] = {
_

Patches currently in -mm which might be from o451686892@gmail.com are

mm-debug-sync-up-mr_contig_range-and-mr_longterm_pin.patch
mm-debug-sync-up-latest-migrate_reason-to-migrate_reason_names.patch

