From: akpm@linux-foundation.org
Subject: [merged] ntfs-use-kvfree-in-ntfs_free.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:21 -0700
Message-ID: <5591ac45.+kI2CrAf6QCubtWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbbF2UgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, anton@tuxera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: NTFS: use kvfree() in ntfs_free()
has been removed from the -mm tree.  Its filename was
     ntfs-use-kvfree-in-ntfs_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: NTFS: use kvfree() in ntfs_free()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/malloc.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/ntfs/malloc.h~ntfs-use-kvfree-in-ntfs_free fs/ntfs/malloc.h
--- a/fs/ntfs/malloc.h~ntfs-use-kvfree-in-ntfs_free
+++ a/fs/ntfs/malloc.h
@@ -85,12 +85,7 @@ static inline void *ntfs_malloc_nofs_nof
 
 static inline void ntfs_free(void *addr)
 {
-	if (!is_vmalloc_addr(addr)) {
-		kfree(addr);
-		/* free_page((unsigned long)addr); */
-		return;
-	}
-	vfree(addr);
+	kvfree(addr);
 }
 
 #endif /* _LINUX_NTFS_MALLOC_H */
_

Patches currently in -mm which might be from penberg@kernel.org are

origin.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
ipc-utilc-use-kvfree-in-ipc_rcu_free.patch
kernel-relayc-use-kvfree-in-relay_free_page_array.patch
cxgb3-use-kvfree-in-cxgb_free_mem.patch
cxgb4-use-kvfree-in-t4_free_mem.patch
drm-use-kvfree-in-drm_free_large.patch
drm-nouveau-gem-use-kvfree-in-u_free.patch
ib-ehca-use-kvfree-in-ipz_queue_cdtor.patch
target-use-kvfree-in-session-alloc-and-free.patch
libcxgbi-use-kvfree-in-cxgbi_free_big_mem.patch
bcache-use-kvfree-in-various-places.patch

