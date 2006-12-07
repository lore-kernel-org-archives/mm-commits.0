From: akpm@osdl.org
Subject: - slab-remove-slab_nofs.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:09 -0800
Message-ID: <200612072258.kB7Mw9gg029368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163596AbWLGW6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_NOFS
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_nofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_NOFS
From: Christoph Lameter <clameter@sgi.com>

SLAB_NOFS is an alias of GFP_NOFS.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/cifs/misc.c       |    4 ++--
 fs/cifs/transport.c  |    2 +-
 fs/dquot.c           |    2 +-
 fs/ext3/super.c      |    2 +-
 fs/ext4/super.c      |    2 +-
 fs/hpfs/super.c      |    2 +-
 fs/nfs/read.c        |    2 +-
 fs/nfs/write.c       |    4 ++--
 fs/ntfs/attrib.c     |    2 +-
 fs/ntfs/index.c      |    2 +-
 fs/ntfs/inode.c      |    4 ++--
 fs/ntfs/unistr.c     |    2 +-
 fs/ocfs2/dlm/dlmfs.c |    2 +-
 fs/ocfs2/super.c     |    2 +-
 include/linux/slab.h |    1 -
 15 files changed, 17 insertions(+), 18 deletions(-)

diff -puN fs/cifs/misc.c~slab-remove-slab_nofs fs/cifs/misc.c
--- a/fs/cifs/misc.c~slab-remove-slab_nofs
+++ a/fs/cifs/misc.c
@@ -153,7 +153,7 @@ cifs_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize 
    defaults to this and can not be bigger */
 	ret_buf =
-	    (struct smb_hdr *) mempool_alloc(cifs_req_poolp, SLAB_KERNEL | SLAB_NOFS);
+	    (struct smb_hdr *) mempool_alloc(cifs_req_poolp, SLAB_KERNEL | GFP_NOFS);
 
 	/* clear the first few header bytes */
 	/* for most paths, more is cleared in header_assemble */
@@ -192,7 +192,7 @@ cifs_small_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize 
    defaults to this and can not be bigger */
 	ret_buf =
-	    (struct smb_hdr *) mempool_alloc(cifs_sm_req_poolp, SLAB_KERNEL | SLAB_NOFS);
+	    (struct smb_hdr *) mempool_alloc(cifs_sm_req_poolp, SLAB_KERNEL | GFP_NOFS);
 	if (ret_buf) {
 	/* No need to clear memory here, cleared in header assemble */
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
diff -puN fs/cifs/transport.c~slab-remove-slab_nofs fs/cifs/transport.c
--- a/fs/cifs/transport.c~slab-remove-slab_nofs
+++ a/fs/cifs/transport.c
@@ -51,7 +51,7 @@ AllocMidQEntry(const struct smb_hdr *smb
 	}
 	
 	temp = (struct mid_q_entry *) mempool_alloc(cifs_mid_poolp,
-						    SLAB_KERNEL | SLAB_NOFS);
+						    SLAB_KERNEL | GFP_NOFS);
 	if (temp == NULL)
 		return temp;
 	else {
diff -puN fs/dquot.c~slab-remove-slab_nofs fs/dquot.c
--- a/fs/dquot.c~slab-remove-slab_nofs
+++ a/fs/dquot.c
@@ -600,7 +600,7 @@ static struct dquot *get_empty_dquot(str
 {
 	struct dquot *dquot;
 
-	dquot = kmem_cache_alloc(dquot_cachep, SLAB_NOFS);
+	dquot = kmem_cache_alloc(dquot_cachep, GFP_NOFS);
 	if(!dquot)
 		return NODQUOT;
 
diff -puN fs/ext3/super.c~slab-remove-slab_nofs fs/ext3/super.c
--- a/fs/ext3/super.c~slab-remove-slab_nofs
+++ a/fs/ext3/super.c
@@ -445,7 +445,7 @@ static struct inode *ext3_alloc_inode(st
 {
 	struct ext3_inode_info *ei;
 
-	ei = kmem_cache_alloc(ext3_inode_cachep, SLAB_NOFS);
+	ei = kmem_cache_alloc(ext3_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
diff -puN fs/ext4/super.c~slab-remove-slab_nofs fs/ext4/super.c
--- a/fs/ext4/super.c~slab-remove-slab_nofs
+++ a/fs/ext4/super.c
@@ -495,7 +495,7 @@ static struct inode *ext4_alloc_inode(st
 {
 	struct ext4_inode_info *ei;
 
-	ei = kmem_cache_alloc(ext4_inode_cachep, SLAB_NOFS);
+	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
diff -puN fs/hpfs/super.c~slab-remove-slab_nofs fs/hpfs/super.c
--- a/fs/hpfs/super.c~slab-remove-slab_nofs
+++ a/fs/hpfs/super.c
@@ -165,7 +165,7 @@ static kmem_cache_t * hpfs_inode_cachep;
 static struct inode *hpfs_alloc_inode(struct super_block *sb)
 {
 	struct hpfs_inode_info *ei;
-	ei = (struct hpfs_inode_info *)kmem_cache_alloc(hpfs_inode_cachep, SLAB_NOFS);
+	ei = (struct hpfs_inode_info *)kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
diff -puN fs/nfs/read.c~slab-remove-slab_nofs fs/nfs/read.c
--- a/fs/nfs/read.c~slab-remove-slab_nofs
+++ a/fs/nfs/read.c
@@ -46,7 +46,7 @@ static mempool_t *nfs_rdata_mempool;
 struct nfs_read_data *nfs_readdata_alloc(size_t len)
 {
 	unsigned int pagecount = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	struct nfs_read_data *p = mempool_alloc(nfs_rdata_mempool, SLAB_NOFS);
+	struct nfs_read_data *p = mempool_alloc(nfs_rdata_mempool, GFP_NOFS);
 
 	if (p) {
 		memset(p, 0, sizeof(*p));
diff -puN fs/nfs/write.c~slab-remove-slab_nofs fs/nfs/write.c
--- a/fs/nfs/write.c~slab-remove-slab_nofs
+++ a/fs/nfs/write.c
@@ -93,7 +93,7 @@ static DECLARE_WAIT_QUEUE_HEAD(nfs_write
 
 struct nfs_write_data *nfs_commit_alloc(void)
 {
-	struct nfs_write_data *p = mempool_alloc(nfs_commit_mempool, SLAB_NOFS);
+	struct nfs_write_data *p = mempool_alloc(nfs_commit_mempool, GFP_NOFS);
 
 	if (p) {
 		memset(p, 0, sizeof(*p));
@@ -112,7 +112,7 @@ void nfs_commit_free(struct nfs_write_da
 struct nfs_write_data *nfs_writedata_alloc(size_t len)
 {
 	unsigned int pagecount = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	struct nfs_write_data *p = mempool_alloc(nfs_wdata_mempool, SLAB_NOFS);
+	struct nfs_write_data *p = mempool_alloc(nfs_wdata_mempool, GFP_NOFS);
 
 	if (p) {
 		memset(p, 0, sizeof(*p));
diff -puN fs/ntfs/attrib.c~slab-remove-slab_nofs fs/ntfs/attrib.c
--- a/fs/ntfs/attrib.c~slab-remove-slab_nofs
+++ a/fs/ntfs/attrib.c
@@ -1272,7 +1272,7 @@ ntfs_attr_search_ctx *ntfs_attr_get_sear
 {
 	ntfs_attr_search_ctx *ctx;
 
-	ctx = kmem_cache_alloc(ntfs_attr_ctx_cache, SLAB_NOFS);
+	ctx = kmem_cache_alloc(ntfs_attr_ctx_cache, GFP_NOFS);
 	if (ctx)
 		ntfs_attr_init_search_ctx(ctx, ni, mrec);
 	return ctx;
diff -puN fs/ntfs/index.c~slab-remove-slab_nofs fs/ntfs/index.c
--- a/fs/ntfs/index.c~slab-remove-slab_nofs
+++ a/fs/ntfs/index.c
@@ -38,7 +38,7 @@ ntfs_index_context *ntfs_index_ctx_get(n
 {
 	ntfs_index_context *ictx;
 
-	ictx = kmem_cache_alloc(ntfs_index_ctx_cache, SLAB_NOFS);
+	ictx = kmem_cache_alloc(ntfs_index_ctx_cache, GFP_NOFS);
 	if (ictx)
 		*ictx = (ntfs_index_context){ .idx_ni = idx_ni };
 	return ictx;
diff -puN fs/ntfs/inode.c~slab-remove-slab_nofs fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~slab-remove-slab_nofs
+++ a/fs/ntfs/inode.c
@@ -324,7 +324,7 @@ struct inode *ntfs_alloc_big_inode(struc
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_big_inode_cache, SLAB_NOFS);
+	ni = kmem_cache_alloc(ntfs_big_inode_cache, GFP_NOFS);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return VFS_I(ni);
@@ -349,7 +349,7 @@ static inline ntfs_inode *ntfs_alloc_ext
 	ntfs_inode *ni;
 
 	ntfs_debug("Entering.");
-	ni = kmem_cache_alloc(ntfs_inode_cache, SLAB_NOFS);
+	ni = kmem_cache_alloc(ntfs_inode_cache, GFP_NOFS);
 	if (likely(ni != NULL)) {
 		ni->state = 0;
 		return ni;
diff -puN fs/ntfs/unistr.c~slab-remove-slab_nofs fs/ntfs/unistr.c
--- a/fs/ntfs/unistr.c~slab-remove-slab_nofs
+++ a/fs/ntfs/unistr.c
@@ -266,7 +266,7 @@ int ntfs_nlstoucs(const ntfs_volume *vol
 
 	/* We do not trust outside sources. */
 	if (likely(ins)) {
-		ucs = kmem_cache_alloc(ntfs_name_cache, SLAB_NOFS);
+		ucs = kmem_cache_alloc(ntfs_name_cache, GFP_NOFS);
 		if (likely(ucs)) {
 			for (i = o = 0; i < ins_len; i += wc_len) {
 				wc_len = nls->char2uni(ins + i, ins_len - i,
diff -puN fs/ocfs2/dlm/dlmfs.c~slab-remove-slab_nofs fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~slab-remove-slab_nofs
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -276,7 +276,7 @@ static struct inode *dlmfs_alloc_inode(s
 {
 	struct dlmfs_inode_private *ip;
 
-	ip = kmem_cache_alloc(dlmfs_inode_cache, SLAB_NOFS);
+	ip = kmem_cache_alloc(dlmfs_inode_cache, GFP_NOFS);
 	if (!ip)
 		return NULL;
 
diff -puN fs/ocfs2/super.c~slab-remove-slab_nofs fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~slab-remove-slab_nofs
+++ a/fs/ocfs2/super.c
@@ -303,7 +303,7 @@ static struct inode *ocfs2_alloc_inode(s
 {
 	struct ocfs2_inode_info *oi;
 
-	oi = kmem_cache_alloc(ocfs2_inode_cachep, SLAB_NOFS);
+	oi = kmem_cache_alloc(ocfs2_inode_cachep, GFP_NOFS);
 	if (!oi)
 		return NULL;
 
diff -puN include/linux/slab.h~slab-remove-slab_nofs include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_nofs
+++ a/include/linux/slab.h
@@ -19,7 +19,6 @@ typedef struct kmem_cache kmem_cache_t;
 #include	<asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 
 /* flags for kmem_cache_alloc() */
-#define	SLAB_NOFS		GFP_NOFS
 #define	SLAB_ATOMIC		GFP_ATOMIC
 #define	SLAB_USER		GFP_USER
 #define	SLAB_KERNEL		GFP_KERNEL
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

