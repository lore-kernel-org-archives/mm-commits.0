From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 14 Dec 2016 15:23:42 -0800
Message-ID: <5851d47e.69TboeAfb7eVAnIh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933121AbcLNXbZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/reg.h  |    9 --
 arch/powerpc/mm/pgtable-radix.c |    3 
 drivers/md/raid5-cache.c        |   12 ---
 drivers/scsi/g_NCR5380.c        |   18 ----
 drivers/scsi/ufs/ufs_quirks.h   |   27 -------
 drivers/scsi/ufs/ufshcd.c       |    3 
 drivers/scsi/ufs/ufshcd.h       |   11 --
 fs/ext4/inode.c                 |   11 --
 fs/xfs/xfs_aops.c               |  111 ------------------------------
 fs/xfs/xfs_file.c               |   22 -----
 include/linux/iomap.h           |    3 
 11 files changed, 230 deletions(-)

diff -puN arch/powerpc/include/asm/reg.h~linux-next-git-rejects arch/powerpc/include/asm/reg.h
--- a/arch/powerpc/include/asm/reg.h~linux-next-git-rejects
+++ a/arch/powerpc/include/asm/reg.h
@@ -295,11 +295,8 @@
 #define SPRN_HRMOR	0x139	/* Real mode offset register */
 #define SPRN_HSRR0	0x13A	/* Hypervisor Save/Restore 0 */
 #define SPRN_HSRR1	0x13B	/* Hypervisor Save/Restore 1 */
-<<<<<<< HEAD
 #define SPRN_LMRR	0x32D	/* Load Monitor Region Register */
 #define SPRN_LMSER	0x32E	/* Load Monitor Section Enable Register */
-=======
->>>>>>> linux-next/akpm-base
 #define SPRN_ASDR	0x330	/* Access segment descriptor register */
 #define SPRN_IC		0x350	/* Virtual Instruction Count */
 #define SPRN_VTB	0x351	/* Virtual Time Base */
@@ -311,10 +308,7 @@
 #define SPRN_PMCR	0x374	/* Power Management Control Register */
 
 /* HFSCR and FSCR bit numbers are the same */
-<<<<<<< HEAD
 #define FSCR_LM_LG	11	/* Enable Load Monitor Registers */
-=======
->>>>>>> linux-next/akpm-base
 #define FSCR_MSGP_LG	10	/* Enable MSGP */
 #define FSCR_TAR_LG	8	/* Enable Target Address Register */
 #define FSCR_EBB_LG	7	/* Enable Event Based Branching */
@@ -329,10 +323,7 @@
 #define   FSCR_EBB	__MASK(FSCR_EBB_LG)
 #define   FSCR_DSCR	__MASK(FSCR_DSCR_LG)
 #define SPRN_HFSCR	0xbe	/* HV=1 Facility Status & Control Register */
-<<<<<<< HEAD
 #define   HFSCR_LM	__MASK(FSCR_LM_LG)
-=======
->>>>>>> linux-next/akpm-base
 #define   HFSCR_MSGP	__MASK(FSCR_MSGP_LG)
 #define   HFSCR_TAR	__MASK(FSCR_TAR_LG)
 #define   HFSCR_EBB	__MASK(FSCR_EBB_LG)
diff -puN arch/powerpc/mm/pgtable-radix.c~linux-next-git-rejects arch/powerpc/mm/pgtable-radix.c
--- a/arch/powerpc/mm/pgtable-radix.c~linux-next-git-rejects
+++ a/arch/powerpc/mm/pgtable-radix.c
@@ -405,10 +405,7 @@ void __init radix__early_init_mmu(void)
 
 	memblock_set_current_limit(MEMBLOCK_ALLOC_ANYWHERE);
 
-<<<<<<< HEAD
-=======
 	radix_init_iamr();
->>>>>>> linux-next/akpm-base
 	radix_init_pgtable();
 }
 
diff -puN drivers/md/raid5-cache.c~linux-next-git-rejects drivers/md/raid5-cache.c
--- a/drivers/md/raid5-cache.c~linux-next-git-rejects
+++ a/drivers/md/raid5-cache.c
@@ -574,30 +574,18 @@ static void r5l_do_submit_io(struct r5l_
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
 	if (io->has_flush)
-<<<<<<< HEAD
-		io->current_bio->bi_opf |= REQ_PREFLUSH;
-	if (io->has_fua)
-		io->current_bio->bi_opf |= REQ_FUA;
-=======
 		io->current_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 	if (io->has_fua)
 		io->current_bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
->>>>>>> linux-next/akpm-base
 	submit_bio(io->current_bio);
 
 	if (!io->split_bio)
 		return;
 
 	if (io->has_flush)
-<<<<<<< HEAD
-		io->split_bio->bi_opf |= REQ_PREFLUSH;
-	if (io->has_fua)
-		io->split_bio->bi_opf |= REQ_FUA;
-=======
 		io->split_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 	if (io->has_fua)
 		io->split_bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
->>>>>>> linux-next/akpm-base
 	submit_bio(io->split_bio);
 }
 
diff -puN drivers/scsi/g_NCR5380.c~linux-next-git-rejects drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~linux-next-git-rejects
+++ a/drivers/scsi/g_NCR5380.c
@@ -67,8 +67,6 @@ MODULE_PARM_DESC(card, "card type (0=NCR
 MODULE_ALIAS("g_NCR5380_mmio");
 MODULE_LICENSE("GPL");
 
-<<<<<<< HEAD
-=======
 static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
@@ -119,7 +117,6 @@ static int g_NCR5380_probe_irq(struct Sc
 	return irq;
 }
 
->>>>>>> linux-next/akpm-base
 /*
  * Configure I/O address of 53C400A or DTC436 by writing magic numbers
  * to ports 0x779 and 0x379.
@@ -142,8 +139,6 @@ static void magic_configure(int idx, u8
 	outb(cfg, 0x379);
 }
 
-<<<<<<< HEAD
-=======
 static irqreturn_t legacy_empty_irq_handler(int irq, void *dev_id)
 {
 	return IRQ_HANDLED;
@@ -163,7 +158,6 @@ static int legacy_find_free_irq(int *irq
 	return -1;
 }
 
->>>>>>> linux-next/akpm-base
 static unsigned int ncr_53c400a_ports[] = {
 	0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
 };
@@ -176,12 +170,9 @@ static u8 ncr_53c400a_magic[] = {	/* 53C
 static u8 hp_c2502_magic[] = {	/* HP C2502 */
 	0x0f, 0x22, 0xf0, 0x20, 0x80
 };
-<<<<<<< HEAD
-=======
 static int hp_c2502_irqs[] = {
 	9, 5, 7, 3, 4, -1
 };
->>>>>>> linux-next/akpm-base
 
 static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 			struct device *pdev, int base, int irq, int board)
@@ -327,8 +318,6 @@ static int generic_NCR5380_init_one(stru
 			ret = -EINVAL;
 			goto out_unregister;
 		}
-<<<<<<< HEAD
-=======
 	}
 
 	/* Check for vacant slot */
@@ -336,7 +325,6 @@ static int generic_NCR5380_init_one(stru
 	if (NCR5380_read(MODE_REG) != 0) {
 		ret = -ENODEV;
 		goto out_unregister;
->>>>>>> linux-next/akpm-base
 	}
 
 	ret = NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP);
@@ -395,12 +383,6 @@ static int generic_NCR5380_init_one(stru
 	}
 
 	if (instance->irq != NO_IRQ) {
-<<<<<<< HEAD
-		/* set IRQ for HP C2502 */
-		if (board == BOARD_HP_C2502)
-			magic_configure(port_idx, instance->irq, magic);
-=======
->>>>>>> linux-next/akpm-base
 		if (request_irq(instance->irq, generic_NCR5380_intr,
 				0, "NCR5380", instance)) {
 			instance->irq = NO_IRQ;
diff -puN drivers/scsi/ufs/ufs_quirks.h~linux-next-git-rejects drivers/scsi/ufs/ufs_quirks.h
--- a/drivers/scsi/ufs/ufs_quirks.h~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufs_quirks.h
@@ -134,8 +134,6 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE	(1 << 7)
 
-<<<<<<< HEAD
-=======
 /*
  * The max. value PA_SaveConfigTime is 250 (10us) but this is not enough for
  * some vendors.
@@ -145,33 +143,8 @@ struct ufs_dev_fix {
  * PA_SaveConfigTime to >32us as per vendor recommendation.
  */
 #define UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME	(1 << 8)
->>>>>>> linux-next/akpm-base
 
 struct ufs_hba;
 void ufs_advertise_fixup_device(struct ufs_hba *hba);
 
-<<<<<<< HEAD
-static struct ufs_dev_fix ufs_fixups[] = {
-	/* UFS cards deviations table */
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_NO_FASTAUTO),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
-		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
-		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
-
-	END_FIX
-};
-=======
->>>>>>> linux-next/akpm-base
 #endif /* UFS_QUIRKS_H_ */
diff -puN drivers/scsi/ufs/ufshcd.c~linux-next-git-rejects drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -5237,11 +5237,8 @@ static void ufshcd_tune_unipro_params(st
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
-<<<<<<< HEAD
-=======
 
 	ufshcd_vops_apply_dev_quirks(hba);
->>>>>>> linux-next/akpm-base
 }
 
 /**
diff -puN drivers/scsi/ufs/ufshcd.h~linux-next-git-rejects drivers/scsi/ufs/ufshcd.h
--- a/drivers/scsi/ufs/ufshcd.h~linux-next-git-rejects
+++ a/drivers/scsi/ufs/ufshcd.h
@@ -266,11 +266,7 @@ struct ufs_pwr_mode_info {
  * @setup_task_mgmt: called before any task management request is issued
  *                  to set some things
  * @hibern8_notify: called around hibern8 enter/exit
-<<<<<<< HEAD
- *		    to configure some things
-=======
  * @apply_dev_quirks: called to apply device specific quirks
->>>>>>> linux-next/akpm-base
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -297,12 +293,8 @@ struct ufs_hba_variant_ops {
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
-<<<<<<< HEAD
-				       enum ufs_notify_change_status);
-=======
 					enum ufs_notify_change_status);
 	int	(*apply_dev_quirks)(struct ufs_hba *);
->>>>>>> linux-next/akpm-base
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -848,8 +840,6 @@ static inline void ufshcd_vops_hibern8_n
 		return hba->vops->hibern8_notify(hba, cmd, status);
 }
 
-<<<<<<< HEAD
-=======
 static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->apply_dev_quirks)
@@ -857,7 +847,6 @@ static inline int ufshcd_vops_apply_dev_
 	return 0;
 }
 
->>>>>>> linux-next/akpm-base
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
diff -puN fs/ext4/inode.c~linux-next-git-rejects fs/ext4/inode.c
--- a/fs/ext4/inode.c~linux-next-git-rejects
+++ a/fs/ext4/inode.c
@@ -3286,7 +3286,6 @@ static int ext4_iomap_begin(struct inode
 
 	map.m_lblk = first_block;
 	map.m_len = last_block - first_block + 1;
-<<<<<<< HEAD
 
 	if (!(flags & IOMAP_WRITE)) {
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
@@ -3295,16 +3294,6 @@ static int ext4_iomap_begin(struct inode
 		handle_t *handle;
 		int retries = 0;
 
-=======
-
-	if (!(flags & IOMAP_WRITE)) {
-		ret = ext4_map_blocks(NULL, inode, &map, 0);
-	} else {
-		int dio_credits;
-		handle_t *handle;
-		int retries = 0;
-
->>>>>>> linux-next/akpm-base
 		/* Trim mapping request to maximum we can map at once for DIO */
 		if (map.m_len > DIO_MAX_BLOCKS)
 			map.m_len = DIO_MAX_BLOCKS;
diff -puN fs/xfs/xfs_aops.c~linux-next-git-rejects fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~linux-next-git-rejects
+++ a/fs/xfs/xfs_aops.c
@@ -1214,12 +1214,7 @@ xfs_get_blocks(
 	struct inode		*inode,
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
-<<<<<<< HEAD
-	int			create,
-	bool			direct)
-=======
 	int			create)
->>>>>>> linux-next/akpm-base
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1281,15 +1276,6 @@ xfs_get_blocks(
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    !ISUNWRITTEN(&imap))
 		xfs_map_buffer(inode, bh_result, &imap, offset);
-<<<<<<< HEAD
-		if (ISUNWRITTEN(&imap))
-			set_buffer_unwritten(bh_result);
-		/* direct IO needs special help */
-		if (create)
-			xfs_map_direct(inode, bh_result, &imap, offset, is_cow);
-	}
-=======
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * If this is a realtime file, data may be on a different device.
@@ -1303,103 +1289,6 @@ out_unlock:
 	return error;
 }
 
-<<<<<<< HEAD
-int
-xfs_get_blocks(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
-}
-
-int
-xfs_get_blocks_direct(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
-}
-
-/*
- * Complete a direct I/O write request.
- *
- * xfs_map_direct passes us some flags in the private data to tell us what to
- * do.  If no flags are set, then the write IO is an overwrite wholly within
- * the existing allocated file size and so there is nothing for us to do.
- *
- * Note that in this case the completion can be called in interrupt context,
- * whereas if we have flags set we will always be called in task context
- * (i.e. from a workqueue).
- */
-int
-xfs_end_io_direct_write(
-	struct kiocb		*iocb,
-	loff_t			offset,
-	ssize_t			size,
-	void			*private)
-{
-	struct inode		*inode = file_inode(iocb->ki_filp);
-	struct xfs_inode	*ip = XFS_I(inode);
-	uintptr_t		flags = (uintptr_t)private;
-	int			error = 0;
-
-	trace_xfs_end_io_direct_write(ip, offset, size);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
-
-	if (size <= 0)
-		return size;
-
-	/*
-	 * The flags tell us whether we are doing unwritten extent conversions
-	 * or an append transaction that updates the on-disk file size. These
-	 * cases are the only cases where we should *potentially* be needing
-	 * to update the VFS inode size.
-	 */
-	if (flags == 0) {
-		ASSERT(offset + size <= i_size_read(inode));
-		return 0;
-	}
-
-	/*
-	 * We need to update the in-core inode size here so that we don't end up
-	 * with the on-disk inode size being outside the in-core inode size. We
-	 * have no other method of updating EOF for AIO, so always do it here
-	 * if necessary.
-	 *
-	 * We need to lock the test/set EOF update as we can be racing with
-	 * other IO completions here to update the EOF. Failing to serialise
-	 * here can result in EOF moving backwards and Bad Things Happen when
-	 * that occurs.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	if (offset + size > i_size_read(inode))
-		i_size_write(inode, offset + size);
-	spin_unlock(&ip->i_flags_lock);
-
-	if (flags & XFS_DIO_FLAG_COW)
-		error = xfs_reflink_end_cow(ip, offset, size);
-	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
-		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
-
-		error = xfs_iomap_write_unwritten(ip, offset, size);
-	}
-	if (flags & XFS_DIO_FLAG_APPEND) {
-		trace_xfs_end_io_direct_write_append(ip, offset, size);
-
-		error = xfs_setfilesize(ip, offset, size);
-	}
-
-	return error;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 STATIC ssize_t
 xfs_vm_direct_IO(
 	struct kiocb		*iocb,
diff -puN fs/xfs/xfs_file.c~linux-next-git-rejects fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~linux-next-git-rejects
+++ a/fs/xfs/xfs_file.c
@@ -237,15 +237,9 @@ xfs_file_dax_read(
 	if (!count)
 		return 0; /* skip atime */
 
-<<<<<<< HEAD
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
-	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
-=======
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
->>>>>>> linux-next/akpm-base
 
 	file_accessed(iocb->ki_filp);
 	return ret;
@@ -599,10 +593,6 @@ xfs_file_dax_write(
 	count = iov_iter_count(from);
 
 	trace_xfs_file_dax_write(ip, count, pos);
-<<<<<<< HEAD
-
-=======
->>>>>>> linux-next/akpm-base
 	ret = dax_iomap_rw(iocb, from, &xfs_iomap_ops);
 	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
 		i_size_write(inode, iocb->ki_pos);
@@ -1423,21 +1413,9 @@ xfs_filemap_fault(
 		return xfs_filemap_page_mkwrite(vma, vmf);
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-<<<<<<< HEAD
-	if (IS_DAX(inode)) {
-		/*
-		 * we do not want to trigger unwritten extent conversion on read
-		 * faults - that is unnecessary overhead and would also require
-		 * changes to xfs_get_blocks_direct() to map unwritten extent
-		 * ioend for conversion on read-only mappings.
-		 */
-		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
-	} else
-=======
 	if (IS_DAX(inode))
 		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
 	else
->>>>>>> linux-next/akpm-base
 		ret = filemap_fault(vma, vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
diff -puN include/linux/iomap.h~linux-next-git-rejects include/linux/iomap.h
--- a/include/linux/iomap.h~linux-next-git-rejects
+++ a/include/linux/iomap.h
@@ -50,10 +50,7 @@ struct iomap {
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
-<<<<<<< HEAD
-=======
 #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
->>>>>>> linux-next/akpm-base
 
 struct iomap_ops {
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

