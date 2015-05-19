From: akpm@linux-foundation.org
Subject: + target-use-kvfree-in-session-alloc-and-free.patch added to -mm
 tree
Date: Tue, 19 May 2015 15:25:45 -0700
Message-ID: <555bb869.tiMIqd6NcDeAx6Bx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbESWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 18:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@kernel.org, nab@linux-iscsi.org, mm-commits@vger.kernel.org


The patch titled
     Subject: target: use kvfree() in session alloc and free
has been added to the -mm tree.  Its filename is
     target-use-kvfree-in-session-alloc-and-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/target-use-kvfree-in-session-alloc-and-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/target-use-kvfree-in-session-alloc-and-free.patch

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
Subject: target: use kvfree() in session alloc and free

Use kvfree() instead of open-coding it.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/target/target_core_transport.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/target/target_core_transport.c~target-use-kvfree-in-session-alloc-and-free drivers/target/target_core_transport.c
--- a/drivers/target/target_core_transport.c~target-use-kvfree-in-session-alloc-and-free
+++ a/drivers/target/target_core_transport.c
@@ -279,10 +279,7 @@ int transport_alloc_session_tags(struct
 	if (rc < 0) {
 		pr_err("Unable to init se_sess->sess_tag_pool,"
 			" tag_num: %u\n", tag_num);
-		if (is_vmalloc_addr(se_sess->sess_cmd_map))
-			vfree(se_sess->sess_cmd_map);
-		else
-			kfree(se_sess->sess_cmd_map);
+		kvfree(se_sess->sess_cmd_map);
 		se_sess->sess_cmd_map = NULL;
 		return -ENOMEM;
 	}
@@ -483,10 +480,7 @@ void transport_free_session(struct se_se
 {
 	if (se_sess->sess_cmd_map) {
 		percpu_ida_destroy(&se_sess->sess_tag_pool);
-		if (is_vmalloc_addr(se_sess->sess_cmd_map))
-			vfree(se_sess->sess_cmd_map);
-		else
-			kfree(se_sess->sess_cmd_map);
+		kvfree(se_sess->sess_cmd_map);
 	}
 	kmem_cache_free(se_sess_cache, se_sess);
 }
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

