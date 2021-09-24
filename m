Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163A1C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED92C6125F
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345228AbhIXWpb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345479AbhIXWp2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A7B361260;
        Fri, 24 Sep 2021 22:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523434;
        bh=sE8CPBkZHP3RfzSPxnIzjhaUGKIMli0dMYDYZte4y84=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oKxee1FHUqdM0CFGqdMcIj7BjcDadvRbDBlMxyB8wJnLrRyj2vZej3fHh0Ra/nyMw
         nYgkli6nWq2OTuuJGl1aS2lx/c0ii5YRm5yxLwub3KxH2U4+iXNXfQuYbzaVKPHAOl
         S7JBP2DqYQwhAYwpuVCEL3d5h5b6/VPIcjHzSQ3s=
Date:   Fri, 24 Sep 2021 15:43:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        dave.hansen@linux.intel.com, jhubbard@nvidia.com,
        khandual@linux.vnet.ibm.com, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        o451686892@gmail.com, osalvador@suse.de, pasha.tatashin@soleen.com,
        torvalds@linux-foundation.org, weixugc@google.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 12/16] mm/debug: sync up latest migrate_reason to
 migrate_reason_names
Message-ID: <20210924224353.M5QtsjROk%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Weizhao Ouyang <o451686892@gmail.com>
Subject: mm/debug: sync up latest migrate_reason to migrate_reason_names

Sync up MR_DEMOTION to migrate_reason_names and add a synch prompt.

Link: https://lkml.kernel.org/r/20210921064553.293905-3-o451686892@gmail.com
Fixes: 26aa2d199d6f ("mm/migrate: demote pages during reclaim")
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
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
