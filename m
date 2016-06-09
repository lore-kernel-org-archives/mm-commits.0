From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix.patch removed from -mm tree
Date: Thu, 09 Jun 2016 15:42:56 -0700
Message-ID: <5759f0f0.r65/ZgJZH9rmjmLV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbcFIWm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2016 18:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix.patch

This patch was dropped because it was folded into mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix

fix warnings, clean up 80-col tricks

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Alexander Potapenko <glider@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix
+++ a/mm/kasan/kasan.c
@@ -371,14 +371,15 @@ static size_t optimal_redzone(size_t obj
 void kasan_cache_create(struct kmem_cache *cache, size_t *size,
 			unsigned long *flags)
 {
-	int redzone_adjust, orig_size = *size;
+	int redzone_adjust;
 
 #ifdef CONFIG_SLAB
+	int orig_size = *size;
+
 	/*
 	 * Make sure the adjusted size is still less than
 	 * KMALLOC_MAX_CACHE_SIZE, i.e. we don't use the page allocator.
 	 */
-
 	if (*size > KMALLOC_MAX_CACHE_SIZE -
 	    sizeof(struct kasan_alloc_meta) -
 	    sizeof(struct kasan_free_meta))
@@ -551,14 +552,16 @@ bool kasan_slab_free(struct kmem_cache *
 		return false;
 
 	if (likely(cache->flags & SLAB_KASAN)) {
-		struct kasan_alloc_meta *alloc_info =
-			get_alloc_info(cache, object);
-		struct kasan_free_meta *free_info =
-			get_free_info(cache, object);
+		struct kasan_alloc_meta *alloc_info;
+		struct kasan_free_meta *free_info;
+
+		alloc_info = get_alloc_info(cache, object);
+		free_info = get_free_info(cache, object);
 		WARN_ON(!alloc_info);
 		WARN_ON(!free_info);
 		if (!alloc_info || !free_info)
-			return;
+			return false;
+
 		switch (alloc_info->state) {
 		case KASAN_STATE_ALLOC:
 			alloc_info->state = KASAN_STATE_QUARANTINE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

