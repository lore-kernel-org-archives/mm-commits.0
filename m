From: akpm@osdl.org
Subject: + transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:00:22 -0800
Message-ID: <200612210400.kBL40M7M015107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422677AbWLUEPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, James.Bottomley@steeleye.com, Joel.Becker@oracle.com, ak@muc.de, chrisw@sous-sol.org, davem@davemloft.net, greg@kroah.com, jack@ucw.cz, jmorris@namei.org, mhalcrow@us.ibm.com, roland@redhat.com, sds@tycho.nsa.gov, swhiteho@redhat.com, tony.luck@intel.com


The patch titled
     Transform kmem_cache_alloc()+memset(0) -> kmem_cache_zalloc().
has been added to the -mm tree.  Its filename is
     transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Transform kmem_cache_alloc()+memset(0) -> kmem_cache_zalloc().
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace appropriate pairs of "kmem_cache_alloc()" + "memset(0)" with the
corresponding "kmem_cache_zalloc()" call.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@muc.de>
Cc: Roland McGrath <roland@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/ia32/binfmt_elf32.c          |   13 ++++---------
 arch/ia64/kernel/perfmon.c             |    3 +--
 arch/ia64/mm/init.c                    |    6 ++----
 arch/x86_64/ia32/ia32_binfmt.c         |    4 +---
 arch/x86_64/ia32/syscall32.c           |    3 +--
 drivers/infiniband/hw/ehca/ehca_cq.c   |    3 +--
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    6 ++----
 drivers/infiniband/hw/ehca/ehca_pd.c   |    3 +--
 drivers/infiniband/hw/ehca/ehca_qp.c   |    3 +--
 drivers/scsi/aic94xx/aic94xx_hwi.c     |    3 +--
 drivers/scsi/scsi_lib.c                |    3 +--
 drivers/usb/host/hc_crisv10.c          |    3 +--
 drivers/usb/host/uhci-q.c              |    4 +---
 fs/aio.c                               |    3 +--
 fs/configfs/dir.c                      |    3 +--
 fs/dlm/memory.c                        |    4 +---
 fs/dquot.c                             |    3 +--
 fs/ecryptfs/crypto.c                   |    4 ++--
 fs/ecryptfs/file.c                     |    3 +--
 fs/ecryptfs/inode.c                    |    5 ++---
 fs/ecryptfs/keystore.c                 |    4 +---
 fs/ecryptfs/main.c                     |    8 ++------
 fs/exec.c                              |    4 +---
 fs/gfs2/meta_io.c                      |    3 +--
 fs/namespace.c                         |    3 +--
 fs/smbfs/request.c                     |    3 +--
 fs/sysfs/dir.c                         |    3 +--
 include/scsi/libsas.h                  |    3 +--
 kernel/posix-timers.c                  |    3 +--
 net/core/dst.c                         |    3 +--
 net/core/neighbour.c                   |    4 +---
 net/decnet/dn_table.c                  |    4 +---
 net/ipv4/ipmr.c                        |    6 ++----
 net/ipv4/ipvs/ip_vs_conn.c             |    3 +--
 net/ipv4/netfilter/ip_conntrack_core.c |    3 +--
 net/ipv6/ip6_fib.c                     |    3 +--
 net/sctp/sm_make_chunk.c               |    3 +--
 security/selinux/avc.c                 |    3 +--
 security/selinux/hooks.c               |    3 +--
 security/selinux/ss/avtab.c            |    3 +--
 40 files changed, 49 insertions(+), 105 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -91,9 +91,8 @@ ia64_elf32_init (struct pt_regs *regs)
 	 * it with privilege level 3 because the IVE uses non-privileged accesses to these
 	 * tables.  IA-32 segmentation is used to protect against IA-32 accesses to them.
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
-		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
 		vma->vm_start = IA32_GDT_OFFSET;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
@@ -117,9 +116,8 @@ ia64_elf32_init (struct pt_regs *regs)
 	 * code is locked in specific gate page, which is pointed by pretcode
 	 * when setup_frame_ia32
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
-		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
 		vma->vm_start = IA32_GATE_OFFSET;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
@@ -142,9 +140,8 @@ ia64_elf32_init (struct pt_regs *regs)
 	 * Install LDT as anonymous memory.  This gives us all-zero segment descriptors
 	 * until a task modifies them via modify_ldt().
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
-		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
 		vma->vm_start = IA32_LDT_OFFSET;
 		vma->vm_end = vma->vm_start + PAGE_ALIGN(IA32_LDT_ENTRIES*IA32_LDT_ENTRY_SIZE);
@@ -214,12 +211,10 @@ ia32_setup_arg_pages (struct linux_binpr
 		bprm->loader += stack_base;
 	bprm->exec += stack_base;
 
-	mpnt = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	mpnt = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!mpnt)
 		return -ENOMEM;
 
-	memset(mpnt, 0, sizeof(*mpnt));
-
 	down_write(&current->mm->mmap_sem);
 	{
 		mpnt->vm_mm = current->mm;
diff -puN arch/ia64/kernel/perfmon.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/arch/ia64/kernel/perfmon.c
@@ -2301,12 +2301,11 @@ pfm_smpl_buffer_alloc(struct task_struct
 	DPRINT(("smpl_buf @%p\n", smpl_buf));
 
 	/* allocate vma */
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		DPRINT(("Cannot allocate vma\n"));
 		goto error_kmem;
 	}
-	memset(vma, 0, sizeof(*vma));
 
 	/*
 	 * partially initialize the vma for the sampling buffer
diff -puN arch/ia64/mm/init.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/arch/ia64/mm/init.c
@@ -156,9 +156,8 @@ ia64_init_addr_space (void)
 	 * the problem.  When the process attempts to write to the register backing store
 	 * for the first time, it will get a SEGFAULT in this case.
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
-		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
 		vma->vm_start = current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
@@ -175,9 +174,8 @@ ia64_init_addr_space (void)
 
 	/* map NaT-page at address zero to speed up speculative dereferencing of NULL: */
 	if (!(current->personality & MMAP_PAGE_ZERO)) {
-		vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+		vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 		if (vma) {
-			memset(vma, 0, sizeof(*vma));
 			vma->vm_mm = current->mm;
 			vma->vm_end = PAGE_SIZE;
 			vma->vm_page_prot = __pgprot(pgprot_val(PAGE_READONLY) | _PAGE_MA_NAT);
diff -puN arch/x86_64/ia32/ia32_binfmt.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -349,12 +349,10 @@ int ia32_setup_arg_pages(struct linux_bi
 		bprm->loader += stack_base;
 	bprm->exec += stack_base;
 
-	mpnt = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	mpnt = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!mpnt) 
 		return -ENOMEM; 
 
-	memset(mpnt, 0, sizeof(*mpnt));
-
 	down_write(&mm->mmap_sem);
 	{
 		mpnt->vm_mm = mm;
diff -puN arch/x86_64/ia32/syscall32.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/arch/x86_64/ia32/syscall32.c
@@ -49,11 +49,10 @@ int syscall32_setup_pages(struct linux_b
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma)
 		return -ENOMEM;
 
-	memset(vma, 0, sizeof(struct vm_area_struct));
 	/* Could randomize here */
 	vma->vm_start = VSYSCALL32_BASE;
 	vma->vm_end = VSYSCALL32_END;
diff -puN drivers/infiniband/hw/ehca/ehca_cq.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/infiniband/hw/ehca/ehca_cq.c
--- a/drivers/infiniband/hw/ehca/ehca_cq.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -134,14 +134,13 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
 		return ERR_PTR(-EINVAL);
 
-	my_cq = kmem_cache_alloc(cq_cache, GFP_KERNEL);
+	my_cq = kmem_cache_zalloc(cq_cache, GFP_KERNEL);
 	if (!my_cq) {
 		ehca_err(device, "Out of memory for ehca_cq struct device=%p",
 			 device);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memset(my_cq, 0, sizeof(struct ehca_cq));
 	memset(&param, 0, sizeof(struct ehca_alloc_cq_parms));
 
 	spin_lock_init(&my_cq->spinlock);
diff -puN drivers/infiniband/hw/ehca/ehca_mrmw.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/infiniband/hw/ehca/ehca_mrmw.c
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -53,9 +53,8 @@ static struct ehca_mr *ehca_mr_new(void)
 {
 	struct ehca_mr *me;
 
-	me = kmem_cache_alloc(mr_cache, GFP_KERNEL);
+	me = kmem_cache_zalloc(mr_cache, GFP_KERNEL);
 	if (me) {
-		memset(me, 0, sizeof(struct ehca_mr));
 		spin_lock_init(&me->mrlock);
 	} else
 		ehca_gen_err("alloc failed");
@@ -72,9 +71,8 @@ static struct ehca_mw *ehca_mw_new(void)
 {
 	struct ehca_mw *me;
 
-	me = kmem_cache_alloc(mw_cache, GFP_KERNEL);
+	me = kmem_cache_zalloc(mw_cache, GFP_KERNEL);
 	if (me) {
-		memset(me, 0, sizeof(struct ehca_mw));
 		spin_lock_init(&me->mwlock);
 	} else
 		ehca_gen_err("alloc failed");
diff -puN drivers/infiniband/hw/ehca/ehca_pd.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/infiniband/hw/ehca/ehca_pd.c
--- a/drivers/infiniband/hw/ehca/ehca_pd.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -50,14 +50,13 @@ struct ib_pd *ehca_alloc_pd(struct ib_de
 {
 	struct ehca_pd *pd;
 
-	pd = kmem_cache_alloc(pd_cache, GFP_KERNEL);
+	pd = kmem_cache_zalloc(pd_cache, GFP_KERNEL);
 	if (!pd) {
 		ehca_err(device, "device=%p context=%p out of memory",
 			 device, context);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memset(pd, 0, sizeof(struct ehca_pd));
 	pd->ownpid = current->tgid;
 
 	/*
diff -puN drivers/infiniband/hw/ehca/ehca_qp.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/infiniband/hw/ehca/ehca_qp.c
--- a/drivers/infiniband/hw/ehca/ehca_qp.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -450,13 +450,12 @@ struct ib_qp *ehca_create_qp(struct ib_p
 	if (pd->uobject && udata)
 		context = pd->uobject->context;
 
-	my_qp = kmem_cache_alloc(qp_cache, GFP_KERNEL);
+	my_qp = kmem_cache_zalloc(qp_cache, GFP_KERNEL);
 	if (!my_qp) {
 		ehca_err(pd->device, "pd=%p not enough memory to alloc qp", pd);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memset(my_qp, 0, sizeof(struct ehca_qp));
 	memset (&parms, 0, sizeof(struct ehca_alloc_qp_parms));
 	spin_lock_init(&my_qp->spinlock_s);
 	spin_lock_init(&my_qp->spinlock_r);
diff -puN drivers/scsi/aic94xx/aic94xx_hwi.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/scsi/aic94xx/aic94xx_hwi.c
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1052,10 +1052,9 @@ static inline struct asd_ascb *asd_ascb_
 	struct asd_ascb *ascb;
 	unsigned long flags;
 
-	ascb = kmem_cache_alloc(asd_ascb_cache, gfp_flags);
+	ascb = kmem_cache_zalloc(asd_ascb_cache, gfp_flags);
 
 	if (ascb) {
-		memset(ascb, 0, sizeof(*ascb));
 		ascb->dma_scb.size = sizeof(struct scb);
 		ascb->dma_scb.vaddr = dma_pool_alloc(asd_ha->scb_pool,
 						     gfp_flags,
diff -puN drivers/scsi/scsi_lib.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/scsi/scsi_lib.c
@@ -388,10 +388,9 @@ int scsi_execute_async(struct scsi_devic
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
 
-	sioc = kmem_cache_alloc(scsi_io_context_cache, gfp);
+	sioc = kmem_cache_zalloc(scsi_io_context_cache, gfp);
 	if (!sioc)
 		return DRIVER_ERROR << 24;
-	memset(sioc, 0, sizeof(*sioc));
 
 	req = blk_get_request(sdev->request_queue, write, gfp);
 	if (!req)
diff -puN drivers/usb/host/hc_crisv10.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/usb/host/hc_crisv10.c
@@ -2163,9 +2163,8 @@ static void etrax_usb_add_to_bulk_sb_lis
 
 	maxlen = usb_maxpacket(urb->dev, urb->pipe, usb_pipeout(urb->pipe));
 
-	sb_desc = (USB_SB_Desc_t*)kmem_cache_alloc(usb_desc_cache, SLAB_FLAG);
+	sb_desc = kmem_cache_zalloc(usb_desc_cache, SLAB_FLAG);
 	assert(sb_desc != NULL);
-	memset(sb_desc, 0, sizeof(USB_SB_Desc_t));
 
 
 	if (usb_pipeout(urb->pipe)) {
diff -puN drivers/usb/host/uhci-q.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc drivers/usb/host/uhci-q.c
--- a/drivers/usb/host/uhci-q.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/drivers/usb/host/uhci-q.c
@@ -498,12 +498,10 @@ static inline struct urb_priv *uhci_allo
 {
 	struct urb_priv *urbp;
 
-	urbp = kmem_cache_alloc(uhci_up_cachep, GFP_ATOMIC);
+	urbp = kmem_cache_zalloc(uhci_up_cachep, GFP_ATOMIC);
 	if (!urbp)
 		return NULL;
 
-	memset((void *)urbp, 0, sizeof(*urbp));
-
 	urbp->urb = urb;
 	urb->hcpriv = urbp;
 	
diff -puN fs/aio.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/aio.c
--- a/fs/aio.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/aio.c
@@ -211,11 +211,10 @@ static struct kioctx *ioctx_alloc(unsign
 	if ((unsigned long)nr_events > aio_max_nr)
 		return ERR_PTR(-EAGAIN);
 
-	ctx = kmem_cache_alloc(kioctx_cachep, GFP_KERNEL);
+	ctx = kmem_cache_zalloc(kioctx_cachep, GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	memset(ctx, 0, sizeof(*ctx));
 	ctx->max_reqs = nr_events;
 	mm = ctx->mm = current->mm;
 	atomic_inc(&mm->mm_count);
diff -puN fs/configfs/dir.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/configfs/dir.c
--- a/fs/configfs/dir.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/configfs/dir.c
@@ -72,11 +72,10 @@ static struct configfs_dirent *configfs_
 {
 	struct configfs_dirent * sd;
 
-	sd = kmem_cache_alloc(configfs_dir_cachep, GFP_KERNEL);
+	sd = kmem_cache_zalloc(configfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
 		return NULL;
 
-	memset(sd, 0, sizeof(*sd));
 	atomic_set(&sd->s_count, 1);
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
diff -puN fs/dlm/memory.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/dlm/memory.c
--- a/fs/dlm/memory.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/dlm/memory.c
@@ -76,9 +76,7 @@ struct dlm_lkb *allocate_lkb(struct dlm_
 {
 	struct dlm_lkb *lkb;
 
-	lkb = kmem_cache_alloc(lkb_cache, GFP_KERNEL);
-	if (lkb)
-		memset(lkb, 0, sizeof(*lkb));
+	lkb = kmem_cache_zalloc(lkb_cache, GFP_KERNEL);
 	return lkb;
 }
 
diff -puN fs/dquot.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/dquot.c
--- a/fs/dquot.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/dquot.c
@@ -600,11 +600,10 @@ static struct dquot *get_empty_dquot(str
 {
 	struct dquot *dquot;
 
-	dquot = kmem_cache_alloc(dquot_cachep, GFP_NOFS);
+	dquot = kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
 	if(!dquot)
 		return NODQUOT;
 
-	memset((caddr_t)dquot, 0, sizeof(struct dquot));
 	mutex_init(&dquot->dq_lock);
 	INIT_LIST_HEAD(&dquot->dq_free);
 	INIT_LIST_HEAD(&dquot->dq_inuse);
diff -puN fs/ecryptfs/crypto.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/ecryptfs/crypto.c
@@ -1334,13 +1334,13 @@ int ecryptfs_write_headers(struct dentry
 		goto out;
 	}
 	/* Released in this function */
-	page_virt = kmem_cache_alloc(ecryptfs_header_cache_0, GFP_USER);
+	page_virt = kmem_cache_zalloc(ecryptfs_header_cache_0, GFP_USER);
 	if (!page_virt) {
 		ecryptfs_printk(KERN_ERR, "Out of memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(page_virt, 0, PAGE_CACHE_SIZE);
+
 	rc = ecryptfs_write_headers_virt(page_virt, crypt_stat,
 					 ecryptfs_dentry);
 	if (unlikely(rc)) {
diff -puN fs/ecryptfs/file.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/ecryptfs/file.c
@@ -251,7 +251,7 @@ static int ecryptfs_open(struct inode *i
 	int lower_flags;
 
 	/* Released in ecryptfs_release or end of function if failure */
-	file_info = kmem_cache_alloc(ecryptfs_file_info_cache, GFP_KERNEL);
+	file_info = kmem_cache_zalloc(ecryptfs_file_info_cache, GFP_KERNEL);
 	ecryptfs_set_file_private(file, file_info);
 	if (!file_info) {
 		ecryptfs_printk(KERN_ERR,
@@ -259,7 +259,6 @@ static int ecryptfs_open(struct inode *i
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(file_info, 0, sizeof(*file_info));
 	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
 	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
 	mount_crypt_stat = &ecryptfs_superblock_to_private(
diff -puN fs/ecryptfs/inode.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/ecryptfs/inode.c
@@ -361,8 +361,7 @@ static struct dentry *ecryptfs_lookup(st
 		goto out;
 	}
 	/* Released in this function */
-	page_virt =
-	    (char *)kmem_cache_alloc(ecryptfs_header_cache_2,
+	page_virt = kmem_cache_zalloc(ecryptfs_header_cache_2,
 				     GFP_USER);
 	if (!page_virt) {
 		rc = -ENOMEM;
@@ -370,7 +369,7 @@ static struct dentry *ecryptfs_lookup(st
 				"Cannot ecryptfs_kmalloc a page\n");
 		goto out_dput;
 	}
-	memset(page_virt, 0, PAGE_CACHE_SIZE);
+
 	rc = ecryptfs_read_header_region(page_virt, lower_dentry, nd->mnt);
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	if (!ECRYPTFS_CHECK_FLAG(crypt_stat->flags, ECRYPTFS_POLICY_APPLIED))
diff -puN fs/ecryptfs/keystore.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/ecryptfs/keystore.c
@@ -681,14 +681,12 @@ parse_tag_3_packet(struct ecryptfs_crypt
 	/* Released: wipe_auth_tok_list called in ecryptfs_parse_packet_set or
 	 * at end of function upon failure */
 	auth_tok_list_item =
-	    kmem_cache_alloc(ecryptfs_auth_tok_list_item_cache, GFP_KERNEL);
+	    kmem_cache_zalloc(ecryptfs_auth_tok_list_item_cache, GFP_KERNEL);
 	if (!auth_tok_list_item) {
 		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(auth_tok_list_item, 0,
-	       sizeof(struct ecryptfs_auth_tok_list_item));
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
 
 	/* check for body size - one to two bytes */
diff -puN fs/ecryptfs/main.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/ecryptfs/main.c
@@ -417,15 +417,13 @@ ecryptfs_fill_super(struct super_block *
 
 	/* Released in ecryptfs_put_super() */
 	ecryptfs_set_superblock_private(sb,
-					kmem_cache_alloc(ecryptfs_sb_info_cache,
+					kmem_cache_zalloc(ecryptfs_sb_info_cache,
 							 GFP_KERNEL));
 	if (!ecryptfs_superblock_to_private(sb)) {
 		ecryptfs_printk(KERN_WARNING, "Out of memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(ecryptfs_superblock_to_private(sb), 0,
-	       sizeof(struct ecryptfs_sb_info));
 	sb->s_op = &ecryptfs_sops;
 	/* Released through deactivate_super(sb) from get_sb_nodev */
 	sb->s_root = d_alloc(NULL, &(const struct qstr) {
@@ -441,7 +439,7 @@ ecryptfs_fill_super(struct super_block *
 	/* Released in d_release when dput(sb->s_root) is called */
 	/* through deactivate_super(sb) from get_sb_nodev() */
 	ecryptfs_set_dentry_private(sb->s_root,
-				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
+				    kmem_cache_zalloc(ecryptfs_dentry_info_cache,
 						     GFP_KERNEL));
 	if (!ecryptfs_dentry_to_private(sb->s_root)) {
 		ecryptfs_printk(KERN_ERR,
@@ -449,8 +447,6 @@ ecryptfs_fill_super(struct super_block *
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(ecryptfs_dentry_to_private(sb->s_root), 0,
-	       sizeof(struct ecryptfs_dentry_info));
 	rc = 0;
 out:
 	/* Should be able to rely on deactivate_super called from
diff -puN fs/exec.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/exec.c
--- a/fs/exec.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/exec.c
@@ -405,12 +405,10 @@ int setup_arg_pages(struct linux_binprm 
 		bprm->loader += stack_base;
 	bprm->exec += stack_base;
 
-	mpnt = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	mpnt = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!mpnt)
 		return -ENOMEM;
 
-	memset(mpnt, 0, sizeof(*mpnt));
-
 	down_write(&mm->mmap_sem);
 	{
 		mpnt->vm_mm = mm;
diff -puN fs/gfs2/meta_io.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/gfs2/meta_io.c
--- a/fs/gfs2/meta_io.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/gfs2/meta_io.c
@@ -282,8 +282,7 @@ void gfs2_attach_bufdata(struct gfs2_glo
 		return;
 	}
 
-	bd = kmem_cache_alloc(gfs2_bufdata_cachep, GFP_NOFS | __GFP_NOFAIL),
-	memset(bd, 0, sizeof(struct gfs2_bufdata));
+	bd = kmem_cache_zalloc(gfs2_bufdata_cachep, GFP_NOFS | __GFP_NOFAIL),
 	bd->bd_bh = bh;
 	bd->bd_gl = gl;
 
diff -puN fs/namespace.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/namespace.c
--- a/fs/namespace.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/namespace.c
@@ -53,9 +53,8 @@ static inline unsigned long hash(struct 
 
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
-	struct vfsmount *mnt = kmem_cache_alloc(mnt_cache, GFP_KERNEL);
+	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
 	if (mnt) {
-		memset(mnt, 0, sizeof(struct vfsmount));
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
diff -puN fs/smbfs/request.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/smbfs/request.c
--- a/fs/smbfs/request.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/smbfs/request.c
@@ -61,7 +61,7 @@ static struct smb_request *smb_do_alloc_
 	struct smb_request *req;
 	unsigned char *buf = NULL;
 
-	req = kmem_cache_alloc(req_cachep, GFP_KERNEL);
+	req = kmem_cache_zalloc(req_cachep, GFP_KERNEL);
 	VERBOSE("allocating request: %p\n", req);
 	if (!req)
 		goto out;
@@ -74,7 +74,6 @@ static struct smb_request *smb_do_alloc_
 		}
 	}
 
-	memset(req, 0, sizeof(struct smb_request));
 	req->rq_buffer = buf;
 	req->rq_bufsize = bufsize;
 	req->rq_server = server;
diff -puN fs/sysfs/dir.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/fs/sysfs/dir.c
@@ -37,11 +37,10 @@ static struct sysfs_dirent * sysfs_new_d
 {
 	struct sysfs_dirent * sd;
 
-	sd = kmem_cache_alloc(sysfs_dir_cachep, GFP_KERNEL);
+	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
 		return NULL;
 
-	memset(sd, 0, sizeof(*sd));
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
diff -puN include/scsi/libsas.h~transform-kmem_cache_allocmemset0-kmem_cache_zalloc include/scsi/libsas.h
--- a/include/scsi/libsas.h~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/include/scsi/libsas.h
@@ -566,10 +566,9 @@ struct sas_task {
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
 {
 	extern struct kmem_cache *sas_task_cache;
-	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
+	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
 
 	if (task) {
-		memset(task, 0, sizeof(*task));
 		INIT_LIST_HEAD(&task->list);
 		spin_lock_init(&task->task_state_lock);
 		task->task_state_flags = SAS_TASK_STATE_PENDING;
diff -puN kernel/posix-timers.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc kernel/posix-timers.c
--- a/kernel/posix-timers.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/kernel/posix-timers.c
@@ -399,10 +399,9 @@ EXPORT_SYMBOL_GPL(register_posix_clock);
 static struct k_itimer * alloc_posix_timer(void)
 {
 	struct k_itimer *tmr;
-	tmr = kmem_cache_alloc(posix_timers_cache, GFP_KERNEL);
+	tmr = kmem_cache_zalloc(posix_timers_cache, GFP_KERNEL);
 	if (!tmr)
 		return tmr;
-	memset(tmr, 0, sizeof (struct k_itimer));
 	if (unlikely(!(tmr->sigq = sigqueue_alloc()))) {
 		kmem_cache_free(posix_timers_cache, tmr);
 		tmr = NULL;
diff -puN net/core/dst.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/core/dst.c
--- a/net/core/dst.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/core/dst.c
@@ -132,10 +132,9 @@ void * dst_alloc(struct dst_ops * ops)
 		if (ops->gc())
 			return NULL;
 	}
-	dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
+	dst = kmem_cache_zalloc(ops->kmem_cachep, GFP_ATOMIC);
 	if (!dst)
 		return NULL;
-	memset(dst, 0, ops->entry_size);
 	atomic_set(&dst->__refcnt, 0);
 	dst->ops = ops;
 	dst->lastuse = jiffies;
diff -puN net/core/neighbour.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/core/neighbour.c
--- a/net/core/neighbour.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/core/neighbour.c
@@ -251,12 +251,10 @@ static struct neighbour *neigh_alloc(str
 			goto out_entries;
 	}
 
-	n = kmem_cache_alloc(tbl->kmem_cachep, GFP_ATOMIC);
+	n = kmem_cache_zalloc(tbl->kmem_cachep, GFP_ATOMIC);
 	if (!n)
 		goto out_entries;
 
-	memset(n, 0, tbl->entry_size);
-
 	skb_queue_head_init(&n->arp_queue);
 	rwlock_init(&n->lock);
 	n->updated	  = n->used = now;
diff -puN net/decnet/dn_table.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/decnet/dn_table.c
--- a/net/decnet/dn_table.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/decnet/dn_table.c
@@ -590,12 +590,10 @@ create:
 
 replace:
 	err = -ENOBUFS;
-	new_f = kmem_cache_alloc(dn_hash_kmem, GFP_KERNEL);
+	new_f = kmem_cache_zalloc(dn_hash_kmem, GFP_KERNEL);
 	if (new_f == NULL)
 		goto out;
 
-	memset(new_f, 0, sizeof(struct dn_fib_node));
-
 	new_f->fn_key = key;
 	new_f->fn_type = type;
 	new_f->fn_scope = r->rtm_scope;
diff -puN net/ipv4/ipmr.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/ipv4/ipmr.c
@@ -479,20 +479,18 @@ static struct mfc_cache *ipmr_cache_find
  */
 static struct mfc_cache *ipmr_cache_alloc(void)
 {
-	struct mfc_cache *c=kmem_cache_alloc(mrt_cachep, GFP_KERNEL);
+	struct mfc_cache *c=kmem_cache_zalloc(mrt_cachep, GFP_KERNEL);
 	if(c==NULL)
 		return NULL;
-	memset(c, 0, sizeof(*c));
 	c->mfc_un.res.minvif = MAXVIFS;
 	return c;
 }
 
 static struct mfc_cache *ipmr_cache_alloc_unres(void)
 {
-	struct mfc_cache *c=kmem_cache_alloc(mrt_cachep, GFP_ATOMIC);
+	struct mfc_cache *c=kmem_cache_zalloc(mrt_cachep, GFP_ATOMIC);
 	if(c==NULL)
 		return NULL;
-	memset(c, 0, sizeof(*c));
 	skb_queue_head_init(&c->mfc_un.unres.unresolved);
 	c->mfc_un.unres.expires = jiffies + 10*HZ;
 	return c;
diff -puN net/ipv4/ipvs/ip_vs_conn.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/ipv4/ipvs/ip_vs_conn.c
--- a/net/ipv4/ipvs/ip_vs_conn.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/ipv4/ipvs/ip_vs_conn.c
@@ -603,13 +603,12 @@ ip_vs_conn_new(int proto, __be32 caddr, 
 	struct ip_vs_conn *cp;
 	struct ip_vs_protocol *pp = ip_vs_proto_get(proto);
 
-	cp = kmem_cache_alloc(ip_vs_conn_cachep, GFP_ATOMIC);
+	cp = kmem_cache_zalloc(ip_vs_conn_cachep, GFP_ATOMIC);
 	if (cp == NULL) {
 		IP_VS_ERR_RL("ip_vs_conn_new: no memory available.\n");
 		return NULL;
 	}
 
-	memset(cp, 0, sizeof(*cp));
 	INIT_LIST_HEAD(&cp->c_list);
 	init_timer(&cp->timer);
 	cp->timer.data     = (unsigned long)cp;
diff -puN net/ipv4/netfilter/ip_conntrack_core.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/ipv4/netfilter/ip_conntrack_core.c
@@ -638,14 +638,13 @@ struct ip_conntrack *ip_conntrack_alloc(
 		}
 	}
 
-	conntrack = kmem_cache_alloc(ip_conntrack_cachep, GFP_ATOMIC);
+	conntrack = kmem_cache_zalloc(ip_conntrack_cachep, GFP_ATOMIC);
 	if (!conntrack) {
 		DEBUGP("Can't allocate conntrack.\n");
 		atomic_dec(&ip_conntrack_count);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memset(conntrack, 0, sizeof(*conntrack));
 	atomic_set(&conntrack->ct_general.use, 1);
 	conntrack->ct_general.destroy = destroy_conntrack;
 	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple = *orig;
diff -puN net/ipv6/ip6_fib.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/ipv6/ip6_fib.c
--- a/net/ipv6/ip6_fib.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/ipv6/ip6_fib.c
@@ -150,8 +150,7 @@ static __inline__ struct fib6_node * nod
 {
 	struct fib6_node *fn;
 
-	if ((fn = kmem_cache_alloc(fib6_node_kmem, GFP_ATOMIC)) != NULL)
-		memset(fn, 0, sizeof(struct fib6_node));
+	fn = kmem_cache_zalloc(fib6_node_kmem, GFP_ATOMIC);
 
 	return fn;
 }
diff -puN net/sctp/sm_make_chunk.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc net/sctp/sm_make_chunk.c
--- a/net/sctp/sm_make_chunk.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/net/sctp/sm_make_chunk.c
@@ -979,11 +979,10 @@ struct sctp_chunk *sctp_chunkify(struct 
 {
 	struct sctp_chunk *retval;
 
-	retval = kmem_cache_alloc(sctp_chunk_cachep, GFP_ATOMIC);
+	retval = kmem_cache_zalloc(sctp_chunk_cachep, GFP_ATOMIC);
 
 	if (!retval)
 		goto nodata;
-	memset(retval, 0, sizeof(struct sctp_chunk));
 
 	if (!sk) {
 		SCTP_DEBUG_PRINTK("chunkifying skb %p w/o an sk\n", skb);
diff -puN security/selinux/avc.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc security/selinux/avc.c
--- a/security/selinux/avc.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/security/selinux/avc.c
@@ -332,11 +332,10 @@ static struct avc_node *avc_alloc_node(v
 {
 	struct avc_node *node;
 
-	node = kmem_cache_alloc(avc_node_cachep, GFP_ATOMIC);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
 	if (!node)
 		goto out;
 
-	memset(node, 0, sizeof(*node));
 	INIT_RCU_HEAD(&node->rhead);
 	INIT_LIST_HEAD(&node->list);
 	atomic_set(&node->ae.used, 1);
diff -puN security/selinux/hooks.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc security/selinux/hooks.c
--- a/security/selinux/hooks.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/security/selinux/hooks.c
@@ -181,11 +181,10 @@ static int inode_alloc_security(struct i
 	struct task_security_struct *tsec = current->security;
 	struct inode_security_struct *isec;
 
-	isec = kmem_cache_alloc(sel_inode_cache, GFP_KERNEL);
+	isec = kmem_cache_zalloc(sel_inode_cache, GFP_KERNEL);
 	if (!isec)
 		return -ENOMEM;
 
-	memset(isec, 0, sizeof(*isec));
 	mutex_init(&isec->lock);
 	INIT_LIST_HEAD(&isec->list);
 	isec->inode = inode;
diff -puN security/selinux/ss/avtab.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc security/selinux/ss/avtab.c
--- a/security/selinux/ss/avtab.c~transform-kmem_cache_allocmemset0-kmem_cache_zalloc
+++ a/security/selinux/ss/avtab.c
@@ -36,10 +36,9 @@ avtab_insert_node(struct avtab *h, int h
 		  struct avtab_key *key, struct avtab_datum *datum)
 {
 	struct avtab_node * newnode;
-	newnode = kmem_cache_alloc(avtab_node_cachep, GFP_KERNEL);
+	newnode = kmem_cache_zalloc(avtab_node_cachep, GFP_KERNEL);
 	if (newnode == NULL)
 		return NULL;
-	memset(newnode, 0, sizeof(struct avtab_node));
 	newnode->key = *key;
 	newnode->datum = *datum;
 	if (prev) {
_

Patches currently in -mm which might be from rpjday@mindspring.com are

add-a-new-section-to-codingstyle-promoting-include-linux-kernelh.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch

