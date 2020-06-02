From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 109/128] mm: remove the pgprot argument to
 __vmalloc
Date: Mon, 01 Jun 2020 21:51:40 -0700
Message-ID: <20200602045140.-q7WC4s1i%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgFBEvo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:51:44 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, daniel.vetter@ffwll.ch, daniel@ffwll.ch, gor@linux.ibm.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, hannes@cmpxchg.org, hch@lst.de, heiko.carstens@de.ibm.com, kys@microsoft.com, labbott@redhat.com, linux-mm@kvack.org, mark.rutland@arm.com, mikelley@microsoft.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, paulus@ozlabs.org, peterz@infradead.org, robin.murphy@arm.com, sakari.ailus@linux.intel.com, sthemmin@microsoft.com, sumit.semwal@linaro.org, torvalds@linux-foundation.org, wei.liu@kernel.org, will@kernel.org, xiang@kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove the pgprot argument to __vmalloc

The pgprot argument to __vmalloc is always PAGE_KERNEL now, so remove it.

Link: http://lkml.kernel.org/r/20200414131348.444715-22-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Michael Kelley <mikelley@microsoft.com> [hyperv]
Acked-by: Gao Xiang <xiang@kernel.org> [erofs]
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Wei Liu <wei.liu@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/hyperv/hv_init.c              |    3 +--
 arch/x86/include/asm/kvm_host.h        |    3 +--
 arch/x86/kvm/svm/sev.c                 |    3 +--
 drivers/block/drbd/drbd_bitmap.c       |    4 +---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c |    4 ++--
 drivers/lightnvm/pblk-init.c           |    5 ++---
 drivers/md/dm-bufio.c                  |    4 ++--
 drivers/mtd/ubi/io.c                   |    4 ++--
 drivers/scsi/sd_zbc.c                  |    3 +--
 fs/gfs2/dir.c                          |    9 ++++-----
 fs/gfs2/quota.c                        |    2 +-
 fs/nfs/blocklayout/extent_tree.c       |    2 +-
 fs/ntfs/malloc.h                       |    2 +-
 fs/ubifs/debug.c                       |    2 +-
 fs/ubifs/lprops.c                      |    2 +-
 fs/ubifs/lpt_commit.c                  |    4 ++--
 fs/ubifs/orphan.c                      |    2 +-
 fs/xfs/kmem.c                          |    2 +-
 include/linux/vmalloc.h                |    2 +-
 kernel/bpf/core.c                      |    6 +++---
 kernel/groups.c                        |    2 +-
 kernel/module.c                        |    3 +--
 mm/nommu.c                             |   15 +++++++--------
 mm/page_alloc.c                        |    2 +-
 mm/percpu.c                            |    2 +-
 mm/vmalloc.c                           |    4 ++--
 net/bridge/netfilter/ebtables.c        |    6 ++----
 sound/core/memalloc.c                  |    2 +-
 sound/core/pcm_memory.c                |    2 +-
 29 files changed, 47 insertions(+), 59 deletions(-)

--- a/arch/x86/hyperv/hv_init.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/arch/x86/hyperv/hv_init.c
@@ -97,8 +97,7 @@ static int hv_cpu_init(unsigned int cpu)
 	 * not be stopped in the case of CPU offlining and the VM will hang.
 	 */
 	if (!*hvp) {
-		*hvp = __vmalloc(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO,
-				 PAGE_KERNEL);
+		*hvp = __vmalloc(PAGE_SIZE, GFP_KERNEL | __GFP_ZERO);
 	}
 
 	if (*hvp) {
--- a/arch/x86/include/asm/kvm_host.h~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/arch/x86/include/asm/kvm_host.h
@@ -1279,8 +1279,7 @@ extern struct kmem_cache *x86_fpu_cache;
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return __vmalloc(kvm_x86_ops.vm_size,
-			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
+	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 void kvm_arch_free_vm(struct kvm *kvm);
 
--- a/arch/x86/kvm/svm/sev.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/arch/x86/kvm/svm/sev.c
@@ -336,8 +336,7 @@ static struct page **sev_pin_memory(stru
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)
-		pages = __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO,
-				  PAGE_KERNEL);
+		pages = __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
 		pages = kmalloc(size, GFP_KERNEL_ACCOUNT);
 
--- a/drivers/block/drbd/drbd_bitmap.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -396,9 +396,7 @@ static struct page **bm_realloc_pages(st
 	bytes = sizeof(struct page *)*want;
 	new_pages = kzalloc(bytes, GFP_NOIO | __GFP_NOWARN);
 	if (!new_pages) {
-		new_pages = __vmalloc(bytes,
-				GFP_NOIO | __GFP_ZERO,
-				PAGE_KERNEL);
+		new_pages = __vmalloc(bytes, GFP_NOIO | __GFP_ZERO);
 		if (!new_pages)
 			return NULL;
 	}
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -154,8 +154,8 @@ void etnaviv_core_dump(struct etnaviv_ge
 	file_size += sizeof(*iter.hdr) * n_obj;
 
 	/* Allocate the file in vmalloc memory, it's likely to be big */
-	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
-			       PAGE_KERNEL);
+	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_NOWARN |
+			__GFP_NORETRY);
 	if (!iter.start) {
 		mutex_unlock(&gpu->mmu_context->lock);
 		dev_warn(gpu->dev, "failed to allocate devcoredump file\n");
--- a/drivers/lightnvm/pblk-init.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/drivers/lightnvm/pblk-init.c
@@ -145,9 +145,8 @@ static int pblk_l2p_init(struct pblk *pb
 	int ret = 0;
 
 	map_size = pblk_trans_map_size(pblk);
-	pblk->trans_map = __vmalloc(map_size, GFP_KERNEL | __GFP_NOWARN
-					| __GFP_RETRY_MAYFAIL | __GFP_HIGHMEM,
-					PAGE_KERNEL);
+	pblk->trans_map = __vmalloc(map_size, GFP_KERNEL | __GFP_NOWARN |
+				    __GFP_RETRY_MAYFAIL | __GFP_HIGHMEM);
 	if (!pblk->trans_map) {
 		pblk_err(pblk, "failed to allocate L2P (need %zu of memory)\n",
 				map_size);
--- a/drivers/md/dm-bufio.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/drivers/md/dm-bufio.c
@@ -400,13 +400,13 @@ static void *alloc_buffer_data(struct dm
 	 */
 	if (gfp_mask & __GFP_NORETRY) {
 		unsigned noio_flag = memalloc_noio_save();
-		void *ptr = __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+		void *ptr = __vmalloc(c->block_size, gfp_mask);
 
 		memalloc_noio_restore(noio_flag);
 		return ptr;
 	}
 
-	return __vmalloc(c->block_size, gfp_mask, PAGE_KERNEL);
+	return __vmalloc(c->block_size, gfp_mask);
 }
 
 /*
--- a/drivers/mtd/ubi/io.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/drivers/mtd/ubi/io.c
@@ -1297,7 +1297,7 @@ static int self_check_write(struct ubi_d
 	if (!ubi_dbg_chk_io(ubi))
 		return 0;
 
-	buf1 = __vmalloc(len, GFP_NOFS, PAGE_KERNEL);
+	buf1 = __vmalloc(len, GFP_NOFS);
 	if (!buf1) {
 		ubi_err(ubi, "cannot allocate memory to check writes");
 		return 0;
@@ -1361,7 +1361,7 @@ int ubi_self_check_all_ff(struct ubi_dev
 	if (!ubi_dbg_chk_io(ubi))
 		return 0;
 
-	buf = __vmalloc(len, GFP_NOFS, PAGE_KERNEL);
+	buf = __vmalloc(len, GFP_NOFS);
 	if (!buf) {
 		ubi_err(ubi, "cannot allocate memory to check for 0xFFs");
 		return 0;
--- a/drivers/scsi/sd_zbc.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/drivers/scsi/sd_zbc.c
@@ -136,8 +136,7 @@ static void *sd_zbc_alloc_report_buffer(
 
 	while (bufsize >= SECTOR_SIZE) {
 		buf = __vmalloc(bufsize,
-				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY,
-				PAGE_KERNEL);
+				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY);
 		if (buf) {
 			*buflen = bufsize;
 			return buf;
--- a/fs/gfs2/dir.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/gfs2/dir.c
@@ -354,7 +354,7 @@ static __be64 *gfs2_dir_get_hash_table(s
 
 	hc = kmalloc(hsize, GFP_NOFS | __GFP_NOWARN);
 	if (hc == NULL)
-		hc = __vmalloc(hsize, GFP_NOFS, PAGE_KERNEL);
+		hc = __vmalloc(hsize, GFP_NOFS);
 
 	if (hc == NULL)
 		return ERR_PTR(-ENOMEM);
@@ -1166,7 +1166,7 @@ static int dir_double_exhash(struct gfs2
 
 	hc2 = kmalloc_array(hsize_bytes, 2, GFP_NOFS | __GFP_NOWARN);
 	if (hc2 == NULL)
-		hc2 = __vmalloc(hsize_bytes * 2, GFP_NOFS, PAGE_KERNEL);
+		hc2 = __vmalloc(hsize_bytes * 2, GFP_NOFS);
 
 	if (!hc2)
 		return -ENOMEM;
@@ -1327,7 +1327,7 @@ static void *gfs2_alloc_sort_buffer(unsi
 	if (size < KMALLOC_MAX_SIZE)
 		ptr = kmalloc(size, GFP_NOFS | __GFP_NOWARN);
 	if (!ptr)
-		ptr = __vmalloc(size, GFP_NOFS, PAGE_KERNEL);
+		ptr = __vmalloc(size, GFP_NOFS);
 	return ptr;
 }
 
@@ -1987,8 +1987,7 @@ static int leaf_dealloc(struct gfs2_inod
 
 	ht = kzalloc(size, GFP_NOFS | __GFP_NOWARN);
 	if (ht == NULL)
-		ht = __vmalloc(size, GFP_NOFS | __GFP_NOWARN | __GFP_ZERO,
-			       PAGE_KERNEL);
+		ht = __vmalloc(size, GFP_NOFS | __GFP_NOWARN | __GFP_ZERO);
 	if (!ht)
 		return -ENOMEM;
 
--- a/fs/gfs2/quota.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/gfs2/quota.c
@@ -1365,7 +1365,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp
 	sdp->sd_quota_bitmap = kzalloc(bm_size, GFP_NOFS | __GFP_NOWARN);
 	if (sdp->sd_quota_bitmap == NULL)
 		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS |
-						 __GFP_ZERO, PAGE_KERNEL);
+						 __GFP_ZERO);
 	if (!sdp->sd_quota_bitmap)
 		return error;
 
--- a/fs/nfs/blocklayout/extent_tree.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/nfs/blocklayout/extent_tree.c
@@ -582,7 +582,7 @@ retry:
 		if (!arg->layoutupdate_pages)
 			return -ENOMEM;
 
-		start_p = __vmalloc(buffer_size, GFP_NOFS, PAGE_KERNEL);
+		start_p = __vmalloc(buffer_size, GFP_NOFS);
 		if (!start_p) {
 			kfree(arg->layoutupdate_pages);
 			return -ENOMEM;
--- a/fs/ntfs/malloc.h~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/ntfs/malloc.h
@@ -34,7 +34,7 @@ static inline void *__ntfs_malloc(unsign
 		/* return (void *)__get_free_page(gfp_mask); */
 	}
 	if (likely((size >> PAGE_SHIFT) < totalram_pages()))
-		return __vmalloc(size, gfp_mask, PAGE_KERNEL);
+		return __vmalloc(size, gfp_mask);
 	return NULL;
 }
 
--- a/fs/ubifs/debug.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/ubifs/debug.c
@@ -815,7 +815,7 @@ void ubifs_dump_leb(const struct ubifs_i
 
 	pr_err("(pid %d) start dumping LEB %d\n", current->pid, lnum);
 
-	buf = __vmalloc(c->leb_size, GFP_NOFS, PAGE_KERNEL);
+	buf = __vmalloc(c->leb_size, GFP_NOFS);
 	if (!buf) {
 		ubifs_err(c, "cannot allocate memory for dumping LEB %d", lnum);
 		return;
--- a/fs/ubifs/lprops.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/ubifs/lprops.c
@@ -1095,7 +1095,7 @@ static int scan_check_cb(struct ubifs_in
 		return LPT_SCAN_CONTINUE;
 	}
 
-	buf = __vmalloc(c->leb_size, GFP_NOFS, PAGE_KERNEL);
+	buf = __vmalloc(c->leb_size, GFP_NOFS);
 	if (!buf)
 		return -ENOMEM;
 
--- a/fs/ubifs/lpt_commit.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/ubifs/lpt_commit.c
@@ -1596,7 +1596,7 @@ static int dbg_check_ltab_lnum(struct ub
 	if (!dbg_is_chk_lprops(c))
 		return 0;
 
-	buf = p = __vmalloc(c->leb_size, GFP_NOFS, PAGE_KERNEL);
+	buf = p = __vmalloc(c->leb_size, GFP_NOFS);
 	if (!buf) {
 		ubifs_err(c, "cannot allocate memory for ltab checking");
 		return 0;
@@ -1845,7 +1845,7 @@ static void dump_lpt_leb(const struct ub
 	void *buf, *p;
 
 	pr_err("(pid %d) start dumping LEB %d\n", current->pid, lnum);
-	buf = p = __vmalloc(c->leb_size, GFP_NOFS, PAGE_KERNEL);
+	buf = p = __vmalloc(c->leb_size, GFP_NOFS);
 	if (!buf) {
 		ubifs_err(c, "cannot allocate memory to dump LPT");
 		return;
--- a/fs/ubifs/orphan.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/ubifs/orphan.c
@@ -977,7 +977,7 @@ static int dbg_scan_orphans(struct ubifs
 	if (c->no_orphs)
 		return 0;
 
-	buf = __vmalloc(c->leb_size, GFP_NOFS, PAGE_KERNEL);
+	buf = __vmalloc(c->leb_size, GFP_NOFS);
 	if (!buf) {
 		ubifs_err(c, "cannot allocate memory to check orphans");
 		return 0;
--- a/fs/xfs/kmem.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/fs/xfs/kmem.c
@@ -48,7 +48,7 @@ __kmem_vmalloc(size_t size, xfs_km_flags
 	if (flags & KM_NOFS)
 		nofs_flag = memalloc_nofs_save();
 
-	ptr = __vmalloc(size, lflags, PAGE_KERNEL);
+	ptr = __vmalloc(size, lflags);
 
 	if (flags & KM_NOFS)
 		memalloc_nofs_restore(nofs_flag);
--- a/include/linux/vmalloc.h~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/include/linux/vmalloc.h
@@ -110,7 +110,7 @@ extern void *vmalloc_user_node_flags(uns
 extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
-extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
+extern void *__vmalloc(unsigned long size, gfp_t gfp_mask);
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
--- a/kernel/bpf/core.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/kernel/bpf/core.c
@@ -82,7 +82,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats
 	struct bpf_prog *fp;
 
 	size = round_up(size, PAGE_SIZE);
-	fp = __vmalloc(size, gfp_flags, PAGE_KERNEL);
+	fp = __vmalloc(size, gfp_flags);
 	if (fp == NULL)
 		return NULL;
 
@@ -232,7 +232,7 @@ struct bpf_prog *bpf_prog_realloc(struct
 	if (ret)
 		return NULL;
 
-	fp = __vmalloc(size, gfp_flags, PAGE_KERNEL);
+	fp = __vmalloc(size, gfp_flags);
 	if (fp == NULL) {
 		__bpf_prog_uncharge(fp_old->aux->user, delta);
 	} else {
@@ -1089,7 +1089,7 @@ static struct bpf_prog *bpf_prog_clone_c
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
 
-	fp = __vmalloc(fp_other->pages * PAGE_SIZE, gfp_flags, PAGE_KERNEL);
+	fp = __vmalloc(fp_other->pages * PAGE_SIZE, gfp_flags);
 	if (fp != NULL) {
 		/* aux->prog still points to the fp_other one, so
 		 * when promoting the clone to the real program,
--- a/kernel/groups.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/kernel/groups.c
@@ -20,7 +20,7 @@ struct group_info *groups_alloc(int gids
 	len = sizeof(struct group_info) + sizeof(kgid_t) * gidsetsize;
 	gi = kmalloc(len, GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY);
 	if (!gi)
-		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT, PAGE_KERNEL);
+		gi = __vmalloc(len, GFP_KERNEL_ACCOUNT);
 	if (!gi)
 		return NULL;
 
--- a/kernel/module.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/kernel/module.c
@@ -2946,8 +2946,7 @@ static int copy_module_from_user(const v
 		return err;
 
 	/* Suck in entire file: we'll want most of it. */
-	info->hdr = __vmalloc(info->len,
-			GFP_KERNEL | __GFP_NOWARN, PAGE_KERNEL);
+	info->hdr = __vmalloc(info->len, GFP_KERNEL | __GFP_NOWARN);
 	if (!info->hdr)
 		return -ENOMEM;
 
--- a/mm/nommu.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/mm/nommu.c
@@ -140,7 +140,7 @@ void vfree(const void *addr)
 }
 EXPORT_SYMBOL(vfree);
 
-void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
+void *__vmalloc(unsigned long size, gfp_t gfp_mask)
 {
 	/*
 	 *  You can't specify __GFP_HIGHMEM with kmalloc() since kmalloc()
@@ -152,14 +152,14 @@ EXPORT_SYMBOL(__vmalloc);
 
 void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
 {
-	return __vmalloc(size, flags, PAGE_KERNEL);
+	return __vmalloc(size, flags);
 }
 
 static void *__vmalloc_user_flags(unsigned long size, gfp_t flags)
 {
 	void *ret;
 
-	ret = __vmalloc(size, flags, PAGE_KERNEL);
+	ret = __vmalloc(size, flags);
 	if (ret) {
 		struct vm_area_struct *vma;
 
@@ -230,7 +230,7 @@ long vwrite(char *buf, char *addr, unsig
  */
 void *vmalloc(unsigned long size)
 {
-       return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL);
+       return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM);
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -248,8 +248,7 @@ EXPORT_SYMBOL(vmalloc);
  */
 void *vzalloc(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
-			PAGE_KERNEL);
+	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vzalloc);
 
@@ -302,7 +301,7 @@ EXPORT_SYMBOL(vzalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
+	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM);
 }
 
 /**
@@ -314,7 +313,7 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL);
+	return __vmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc_32);
 
--- a/mm/page_alloc.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/mm/page_alloc.c
@@ -8244,7 +8244,7 @@ void *__init alloc_large_system_hash(con
 				table = memblock_alloc_raw(size,
 							   SMP_CACHE_BYTES);
 		} else if (get_order(size) >= MAX_ORDER || hashdist) {
-			table = __vmalloc(size, gfp_flags, PAGE_KERNEL);
+			table = __vmalloc(size, gfp_flags);
 			virt = true;
 		} else {
 			/*
--- a/mm/percpu.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/mm/percpu.c
@@ -482,7 +482,7 @@ static void *pcpu_mem_zalloc(size_t size
 	if (size <= PAGE_SIZE)
 		return kzalloc(size, gfp);
 	else
-		return __vmalloc(size, gfp | __GFP_ZERO, PAGE_KERNEL);
+		return __vmalloc(size, gfp | __GFP_ZERO);
 }
 
 /**
--- a/mm/vmalloc.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/mm/vmalloc.c
@@ -2564,9 +2564,9 @@ static void *__vmalloc_node(unsigned lon
 				gfp_mask, prot, 0, node, caller);
 }
 
-void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
+void *__vmalloc(unsigned long size, gfp_t gfp_mask)
 {
-	return __vmalloc_node(size, 1, gfp_mask, prot, NUMA_NO_NODE,
+	return __vmalloc_node(size, 1, gfp_mask, PAGE_KERNEL, NUMA_NO_NODE,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
--- a/net/bridge/netfilter/ebtables.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/net/bridge/netfilter/ebtables.c
@@ -1095,16 +1095,14 @@ static int do_replace(struct net *net, c
 	tmp.name[sizeof(tmp.name) - 1] = 0;
 
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
-	newinfo = __vmalloc(sizeof(*newinfo) + countersize, GFP_KERNEL_ACCOUNT,
-			    PAGE_KERNEL);
+	newinfo = __vmalloc(sizeof(*newinfo) + countersize, GFP_KERNEL_ACCOUNT);
 	if (!newinfo)
 		return -ENOMEM;
 
 	if (countersize)
 		memset(newinfo->counters, 0, countersize);
 
-	newinfo->entries = __vmalloc(tmp.entries_size, GFP_KERNEL_ACCOUNT,
-				     PAGE_KERNEL);
+	newinfo->entries = __vmalloc(tmp.entries_size, GFP_KERNEL_ACCOUNT);
 	if (!newinfo->entries) {
 		ret = -ENOMEM;
 		goto free_newinfo;
--- a/sound/core/memalloc.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/sound/core/memalloc.c
@@ -143,7 +143,7 @@ int snd_dma_alloc_pages(int type, struct
 		break;
 	case SNDRV_DMA_TYPE_VMALLOC:
 		gfp = snd_mem_get_gfp_flags(device, GFP_KERNEL | __GFP_HIGHMEM);
-		dmab->area = __vmalloc(size, gfp, PAGE_KERNEL);
+		dmab->area = __vmalloc(size, gfp);
 		dmab->addr = 0;
 		break;
 #ifdef CONFIG_HAS_DMA
--- a/sound/core/pcm_memory.c~mm-remove-the-pgprot-argument-to-__vmalloc
+++ a/sound/core/pcm_memory.c
@@ -460,7 +460,7 @@ int _snd_pcm_lib_alloc_vmalloc_buffer(st
 			return 0; /* already large enough */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = __vmalloc(size, gfp_flags, PAGE_KERNEL);
+	runtime->dma_area = __vmalloc(size, gfp_flags);
 	if (!runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
_
