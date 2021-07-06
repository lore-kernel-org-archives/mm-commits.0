Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BDEC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB69061CA2
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhGFTX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhGFTX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FAEF61C9C;
        Tue,  6 Jul 2021 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599248;
        bh=DJKaK4Imr3Jzwk3xjzh0ru6lk3WmUZJcHG3MtWd8iiY=;
        h=Date:From:To:Subject:From;
        b=nBPxYeAv+iNYY+/S6bfQrLf9zYUJPyNAmnOkrcY3lj6+dLK2bQDSvitvkp8X4ajdW
         L1bjum4oUJijVgy9hHoYQLgTNSjtEbHoqUGOnpG4pqzRLmHckCzyfmMapScxnRdUMr
         QpS6CIggqT1F3p0mSLe9Uedky98WPwaf6kuddvQo=
Date:   Tue, 06 Jul 2021 12:20:48 -0700
From:   akpm@linux-foundation.org
To:     jrdr.linux@gmail.com, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com
Subject:  [merged] mm-clear-spelling-mistakes.patch removed from
 -mm tree
Message-ID: <20210706192048.6hoIuUSw6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix spelling mistakes
has been removed from the -mm tree.  Its filename was
     mm-clear-spelling-mistakes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm: fix spelling mistakes

Fix some spelling mistakes in comments:
each having differents usage ==> each has a different usage
statments ==> statements
adresses ==> addresses
aggresive ==> aggressive
datas ==> data
posion ==> poison
higer ==> higher
precisly ==> precisely
wont ==> won't
We moves tha ==> We move the
endianess ==> endianness

Link: https://lkml.kernel.org/r/20210519065853.7723-2-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 +-
 include/linux/mm_types.h |    2 +-
 include/linux/mmzone.h   |    2 +-
 mm/memory-failure.c      |    2 +-
 mm/memory_hotplug.c      |    4 ++--
 mm/page_alloc.c          |    2 +-
 mm/swapfile.c            |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/memremap.h~mm-clear-spelling-mistakes
+++ a/include/linux/memremap.h
@@ -26,7 +26,7 @@ struct vmem_altmap {
 };
 
 /*
- * Specialize ZONE_DEVICE memory into multiple types each having differents
+ * Specialize ZONE_DEVICE memory into multiple types each has a different
  * usage.
  *
  * MEMORY_DEVICE_PRIVATE:
--- a/include/linux/mm_types.h~mm-clear-spelling-mistakes
+++ a/include/linux/mm_types.h
@@ -397,7 +397,7 @@ struct mm_struct {
 		unsigned long mmap_base;	/* base of mmap area */
 		unsigned long mmap_legacy_base;	/* base of mmap area in bottom-up allocations */
 #ifdef CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES
-		/* Base adresses for compatible mmap() */
+		/* Base addresses for compatible mmap() */
 		unsigned long mmap_compat_base;
 		unsigned long mmap_compat_legacy_base;
 #endif
--- a/include/linux/mmzone.h~mm-clear-spelling-mistakes
+++ a/include/linux/mmzone.h
@@ -114,7 +114,7 @@ static inline bool free_area_empty(struc
 struct pglist_data;
 
 /*
- * Add a wild amount of padding here to ensure datas fall into separate
+ * Add a wild amount of padding here to ensure data fall into separate
  * cachelines.  There are very few zone structures in the machine, so space
  * consumption is not a concern here.
  */
--- a/mm/memory-failure.c~mm-clear-spelling-mistakes
+++ a/mm/memory-failure.c
@@ -1340,7 +1340,7 @@ static bool hwpoison_user_mappings(struc
 			 * could potentially call huge_pmd_unshare.  Because of
 			 * this, take semaphore in write mode here and set
 			 * TTU_RMAP_LOCKED to indicate we have taken the lock
-			 * at this higer level.
+			 * at this higher level.
 			 */
 			mapping = hugetlb_page_mapping_lock_write(hpage);
 			if (mapping) {
--- a/mm/memory_hotplug.c~mm-clear-spelling-mistakes
+++ a/mm/memory_hotplug.c
@@ -783,7 +783,7 @@ int __ref online_pages(unsigned long pfn
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
-	 * precisly to memory blocks from the user space POV).
+	 * precisely to memory blocks from the user space POV).
 	 * memmap_on_memory is an exception because it reserves initial part
 	 * of the physical memory space for vmemmaps. That space is pageblock
 	 * aligned.
@@ -1580,7 +1580,7 @@ int __ref offline_pages(unsigned long st
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
-	 * precisly to memory blocks from the user space POV).
+	 * precisely to memory blocks from the user space POV).
 	 * memmap_on_memory is an exception because it reserves initial part
 	 * of the physical memory space for vmemmaps. That space is pageblock
 	 * aligned.
--- a/mm/page_alloc.c~mm-clear-spelling-mistakes
+++ a/mm/page_alloc.c
@@ -3180,7 +3180,7 @@ static void __drain_all_pages(struct zon
 	int cpu;
 
 	/*
-	 * Allocate in the BSS so we wont require allocation in
+	 * Allocate in the BSS so we won't require allocation in
 	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
 	 */
 	static cpumask_t cpus_with_pcps;
--- a/mm/swapfile.c~mm-clear-spelling-mistakes
+++ a/mm/swapfile.c
@@ -2967,7 +2967,7 @@ static unsigned long read_swap_header(st
 		return 0;
 	}
 
-	/* swap partition endianess hack... */
+	/* swap partition endianness hack... */
 	if (swab32(swap_header->info.version) == 1) {
 		swab32s(&swap_header->info.version);
 		swab32s(&swap_header->info.last_page);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

lib-test-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes-in-header-files.patch
mm-fix-spelling-mistakes-in-header-files.patch

