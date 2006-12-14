From: akpm@osdl.org
Subject: + slab-fix-kmem_ptr_validate-prototype.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:43:16 -0800
Message-ID: <200612142143.kBELhGE6029321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32833 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949AbWLNVnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slab: fix kmem_ptr_validate definition
has been added to the -mm tree.  Its filename is
     slab-fix-kmem_ptr_validate-prototype.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: fix kmem_ptr_validate definition
From: Christoph Lameter <clameter@sgi.com>

The declaration of kmem_ptr_validate in slab.h does not match the
one in slab.c. Remove the fastcall attribute (this is the only use in
slab.c).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-kmem_ptr_validate-prototype mm/slab.c
--- a/mm/slab.c~slab-fix-kmem_ptr_validate-prototype
+++ a/mm/slab.c
@@ -3553,7 +3553,7 @@ EXPORT_SYMBOL(kmem_cache_zalloc);
  *
  * Currently only used for dentry validation.
  */
-int fastcall kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr)
+int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr)
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long min_addr = PAGE_OFFSET;
_

Patches currently in -mm which might be from clameter@sgi.com are

config_vm_event_counter-comment-decrustify.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
slab-fix-kmem_ptr_validate-prototype.patch

