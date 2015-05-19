From: akpm@linux-foundation.org
Subject: + cxgb4-use-kvfree-in-t4_free_mem.patch added to -mm tree
Date: Tue, 19 May 2015 15:25:37 -0700
Message-ID: <555bb861.3YyFMhyDIxktrsKA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbESWZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 18:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, hariprasad@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cxgb4: use kvfree() in t4_free_mem()
has been added to the -mm tree.  Its filename is
     cxgb4-use-kvfree-in-t4_free_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cxgb4-use-kvfree-in-t4_free_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cxgb4-use-kvfree-in-t4_free_mem.patch

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
Subject: cxgb4: use kvfree() in t4_free_mem()

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: Hariprasad S <hariprasad@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-use-kvfree-in-t4_free_mem drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~cxgb4-use-kvfree-in-t4_free_mem
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1143,10 +1143,7 @@ void *t4_alloc_mem(size_t size)
  */
 void t4_free_mem(void *addr)
 {
-	if (is_vmalloc_addr(addr))
-		vfree(addr);
-	else
-		kfree(addr);
+	kvfree(addr);
 }
 
 /* Send a Work Request to write the filter at a specified index.  We construct
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

