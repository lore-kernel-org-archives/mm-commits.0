Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B48DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjEPWWm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjEPWWi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:22:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A5459FB
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35EC4633C2
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9015AC433EF;
        Tue, 16 May 2023 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275755;
        bh=TPMbHHV2wf8lhgawt+ax9xqamKg9Ssx/ECAG044ooxc=;
        h=Date:To:From:Subject:From;
        b=Zd5MWlr15ENZr1LQENESgu3ZllnAfbTNLJBf22yLD1yooexWLu+zRe3IM3ssVXb6j
         dgoWmneGpB6p85vAXKIIZZA6ZSFXloOybqA1eDZFZ6qgJq2DXuYQZWLcW+kJRmfyTE
         0oxiZIZ3ho7ooB4I6k2/ekgtZqSPzupma2887gQ4=
Date:   Tue, 16 May 2023 15:22:35 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch added to mm-unstable branch
Message-Id: <20230516222235.9015AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move set_zone_contiguous() into mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: move set_zone_contiguous() into mm_init.c
Date: Tue, 16 May 2023 14:38:11 +0800

set_zone_contiguous() is only used in mm init/hotplug, and
clear_zone_contiguous() only used in hotplug, move them from page_alloc.c
to the more appropriate file.

Link: https://lkml.kernel.org/r/20230516063821.121844-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 ---
 mm/internal.h                  |    7 +++++++
 mm/mm_init.c                   |   22 ++++++++++++++++++++++
 mm/page_alloc.c                |   27 ---------------------------
 4 files changed, 29 insertions(+), 30 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/include/linux/memory_hotplug.h
@@ -326,9 +326,6 @@ static inline int remove_memory(u64 star
 static inline void __remove_memory(u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-extern void set_zone_contiguous(struct zone *zone);
-extern void clear_zone_contiguous(struct zone *zone);
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
--- a/mm/internal.h~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/mm/internal.h
@@ -371,6 +371,13 @@ static inline struct page *pageblock_pfn
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
 }
 
+void set_zone_contiguous(struct zone *zone);
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
--- a/mm/mm_init.c~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/mm/mm_init.c
@@ -2330,6 +2330,28 @@ void __init init_cma_reserved_pageblock(
 }
 #endif
 
+void set_zone_contiguous(struct zone *zone)
+{
+	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long block_end_pfn;
+
+	block_end_pfn = pageblock_end_pfn(block_start_pfn);
+	for (; block_start_pfn < zone_end_pfn(zone);
+			block_start_pfn = block_end_pfn,
+			 block_end_pfn += pageblock_nr_pages) {
+
+		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+
+		if (!__pageblock_pfn_to_page(block_start_pfn,
+					     block_end_pfn, zone))
+			return;
+		cond_resched();
+	}
+
+	/* We confirm that there is no hole */
+	zone->contiguous = true;
+}
+
 void __init page_alloc_init_late(void)
 {
 	struct zone *zone;
--- a/mm/page_alloc.c~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/mm/page_alloc.c
@@ -1532,33 +1532,6 @@ struct page *__pageblock_pfn_to_page(uns
 	return start_page;
 }
 
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-
-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
-			block_start_pfn = block_end_pfn,
-			 block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					     block_end_pfn, zone))
-			return;
-		cond_resched();
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
-void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 /*
  * The order of subdivision here is critical for the IO subsystem.
  * Please do not alter this order without good reasons and regression
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch
mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch
mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch
mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch
mm-page_alloc-collect-mem-statistic-into-show_memc.patch
mm-page_alloc-squash-page_is_consistent.patch
mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch
mm-page_alloc-split-out-fail_page_alloc.patch
mm-page_alloc-split-out-debug_pagealloc.patch
mm-page_alloc-move-mark_free_page-into-snapshotc.patch
mm-page_alloc-move-pm_-function-into-power.patch
mm-vmscan-use-gfp_has_io_fs.patch
mm-page_alloc-move-sysctls-into-it-own-fils.patch
mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

