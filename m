From: akpm@osdl.org
Subject: - slab-remove-slab_user.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:11 -0800
Message-ID: <200612072258.kB7MwBll029371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163635AbWLGW6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_USER
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_USER
From: Christoph Lameter <clameter@sgi.com>

SLAB_USER is an alias of GFP_USER

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/crypto.c |    4 ++--
 fs/ecryptfs/inode.c  |    2 +-
 include/linux/slab.h |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~slab-remove-slab_user fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~slab-remove-slab_user
+++ a/fs/ecryptfs/crypto.c
@@ -1334,7 +1334,7 @@ int ecryptfs_write_headers(struct dentry
 		goto out;
 	}
 	/* Released in this function */
-	page_virt = kmem_cache_alloc(ecryptfs_header_cache_0, SLAB_USER);
+	page_virt = kmem_cache_alloc(ecryptfs_header_cache_0, GFP_USER);
 	if (!page_virt) {
 		ecryptfs_printk(KERN_ERR, "Out of memory\n");
 		rc = -ENOMEM;
@@ -1493,7 +1493,7 @@ int ecryptfs_read_headers(struct dentry 
 	    &ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
 
 	/* Read the first page from the underlying file */
-	page_virt = kmem_cache_alloc(ecryptfs_header_cache_1, SLAB_USER);
+	page_virt = kmem_cache_alloc(ecryptfs_header_cache_1, GFP_USER);
 	if (!page_virt) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Unable to allocate page_virt\n");
diff -puN fs/ecryptfs/inode.c~slab-remove-slab_user fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~slab-remove-slab_user
+++ a/fs/ecryptfs/inode.c
@@ -404,7 +404,7 @@ static struct dentry *ecryptfs_lookup(st
 	/* Released in this function */
 	page_virt =
 	    (char *)kmem_cache_alloc(ecryptfs_header_cache_2,
-				     SLAB_USER);
+				     GFP_USER);
 	if (!page_virt) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR,
diff -puN include/linux/slab.h~slab-remove-slab_user include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_user
+++ a/include/linux/slab.h
@@ -20,7 +20,6 @@ typedef struct kmem_cache kmem_cache_t;
 
 /* flags for kmem_cache_alloc() */
 #define	SLAB_ATOMIC		GFP_ATOMIC
-#define	SLAB_USER		GFP_USER
 #define	SLAB_KERNEL		GFP_KERNEL
 #define	SLAB_DMA		GFP_DMA
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
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
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

