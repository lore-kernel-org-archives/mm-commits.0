From: akpm@linux-foundation.org
Subject: + drm-nouveau-gem-use-kvfree-in-u_free.patch added to -mm tree
Date: Tue, 19 May 2015 15:25:41 -0700
Message-ID: <555bb865.kul3BgKmLBnuMiEM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbbESWZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 18:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/nouveau/gem: use kvfree() in u_free()
has been added to the -mm tree.  Its filename is
     drm-nouveau-gem-use-kvfree-in-u_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-nouveau-gem-use-kvfree-in-u_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-nouveau-gem-use-kvfree-in-u_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: drm/nouveau/gem: use kvfree() in u_free()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_gem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nouveau_gem.c~drm-nouveau-gem-use-kvfree-in-u_free drivers/gpu/drm/nouveau/nouveau_gem.c
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c~drm-nouveau-gem-use-kvfree-in-u_free
+++ a/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -555,10 +555,7 @@ nouveau_gem_pushbuf_validate(struct nouv
 static inline void
 u_free(void *addr)
 {
-	if (!is_vmalloc_addr(addr))
-		kfree(addr);
-	else
-		vfree(addr);
+	kvfree(addr);
 }
 
 static inline void *
_

Patches currently in -mm which might be from penberg@kernel.org are

ntfs-use-kvfree-in-ntfs_free.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slab-correct-size_index-table-before-replacing-the-bootstrap-kmem_cache_node.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
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
linux-next.patch
kernel-relayc-use-kvfree-in-relay_free_page_array.patch
cxgb3-use-kvfree-in-cxgb_free_mem.patch
cxgb4-use-kvfree-in-t4_free_mem.patch
drm-use-kvfree-in-drm_free_large.patch
drm-nouveau-gem-use-kvfree-in-u_free.patch
ib-ehca-use-kvfree-in-ipz_queue_cdtor.patch
target-use-kvfree-in-session-alloc-and-free.patch
libcxgbi-use-kvfree-in-cxgbi_free_big_mem.patch
bcache-use-kvfree-in-various-places.patch

