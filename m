From: akpm@osdl.org
Subject: - slab-remove-slab_kernel.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:15 -0800
Message-ID: <200612072258.kB7MwFVb029377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163641AbWLGW6Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_KERNEL
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_KERNEL
From: Christoph Lameter <clameter@sgi.com>

SLAB_KERNEL is an alias of GFP_KERNEL.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/sysenter.c               |    2 -
 arch/ia64/ia32/binfmt_elf32.c             |    8 ++---
 arch/ia64/kernel/perfmon.c                |    2 -
 arch/ia64/mm/init.c                       |    4 +-
 arch/powerpc/kernel/vdso.c                |    2 -
 arch/powerpc/platforms/cell/spufs/inode.c |    2 -
 arch/sh/kernel/vsyscall/vsyscall.c        |    2 -
 arch/x86_64/ia32/ia32_binfmt.c            |    2 -
 arch/x86_64/ia32/syscall32.c              |    2 -
 drivers/atm/he.c                          |    4 +-
 drivers/base/dmapool.c                    |    2 -
 drivers/dma/ioatdma.c                     |    4 +-
 drivers/ieee1394/hosts.c                  |    2 -
 drivers/ieee1394/ohci1394.c               |    8 ++---
 drivers/ieee1394/pcilynx.c                |    2 -
 drivers/ieee1394/raw1394.c                |   10 +++----
 drivers/infiniband/hw/ehca/ehca_av.c      |    2 -
 drivers/infiniband/hw/ehca/ehca_cq.c      |    2 -
 drivers/infiniband/hw/ehca/ehca_main.c    |    2 -
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |    4 +-
 drivers/infiniband/hw/ehca/ehca_pd.c      |    2 -
 drivers/infiniband/hw/ehca/ehca_qp.c      |    2 -
 drivers/input/touchscreen/ads7846.c       |    2 -
 drivers/isdn/gigaset/bas-gigaset.c        |   14 +++++-----
 drivers/isdn/gigaset/usb-gigaset.c        |    6 ++--
 drivers/media/dvb/cinergyT2/cinergyT2.c   |    2 -
 drivers/mtd/devices/m25p80.c              |    2 -
 drivers/scsi/ipr.c                        |    2 -
 drivers/spi/spi.c                         |    4 +-
 drivers/spi/spi_bitbang.c                 |    2 -
 drivers/usb/core/hub.c                    |    4 +-
 drivers/usb/gadget/gmidi.c                |    2 -
 drivers/usb/gadget/goku_udc.c             |    2 -
 drivers/usb/gadget/inode.c                |    6 ++--
 drivers/usb/gadget/net2280.c              |    2 -
 drivers/usb/gadget/omap_udc.c             |    2 -
 drivers/usb/gadget/zero.c                 |    2 -
 drivers/usb/host/hc_crisv10.c             |    2 -
 drivers/usb/host/ohci-pnx4008.c           |    2 -
 drivers/usb/input/acecad.c                |    2 -
 drivers/usb/input/usbtouchscreen.c        |    2 -
 drivers/usb/misc/usbtest.c                |   28 ++++++++++----------
 drivers/usb/net/rndis_host.c              |    2 -
 drivers/usb/net/usbnet.c                  |    4 +-
 fs/adfs/super.c                           |    2 -
 fs/affs/super.c                           |    2 -
 fs/afs/super.c                            |    2 -
 fs/befs/linuxvfs.c                        |    2 -
 fs/bfs/inode.c                            |    2 -
 fs/block_dev.c                            |    2 -
 fs/cifs/cifsfs.c                          |    2 -
 fs/cifs/misc.c                            |    4 +-
 fs/cifs/transport.c                       |    4 +-
 fs/coda/inode.c                           |    2 -
 fs/dnotify.c                              |    2 -
 fs/ecryptfs/crypto.c                      |    2 -
 fs/ecryptfs/file.c                        |    2 -
 fs/ecryptfs/inode.c                       |    4 +-
 fs/ecryptfs/keystore.c                    |    2 -
 fs/ecryptfs/main.c                        |    4 +-
 fs/ecryptfs/super.c                       |    2 -
 fs/efs/super.c                            |    2 -
 fs/eventpoll.c                            |    4 +-
 fs/exec.c                                 |    2 -
 fs/ext2/super.c                           |    2 -
 fs/fat/cache.c                            |    2 -
 fs/fat/inode.c                            |    2 -
 fs/fcntl.c                                |    2 -
 fs/freevxfs/vxfs_inode.c                  |    4 +-
 fs/fuse/dev.c                             |    2 -
 fs/fuse/inode.c                           |    2 -
 fs/hfs/super.c                            |    2 -
 fs/hfsplus/super.c                        |    2 -
 fs/hugetlbfs/inode.c                      |    2 -
 fs/inode.c                                |    2 -
 fs/isofs/inode.c                          |    2 -
 fs/jffs2/super.c                          |    2 -
 fs/locks.c                                |    2 -
 fs/minix/inode.c                          |    2 -
 fs/ncpfs/inode.c                          |    2 -
 fs/nfs/direct.c                           |    2 -
 fs/nfs/inode.c                            |    2 -
 fs/nfs/pagelist.c                         |    2 -
 fs/openpromfs/inode.c                     |    2 -
 fs/proc/inode.c                           |    2 -
 fs/qnx4/inode.c                           |    2 -
 fs/reiserfs/super.c                       |    2 -
 fs/romfs/inode.c                          |    2 -
 fs/smbfs/inode.c                          |    2 -
 fs/smbfs/request.c                        |    2 -
 fs/sysv/inode.c                           |    2 -
 fs/udf/super.c                            |    2 -
 fs/ufs/super.c                            |    2 -
 include/linux/fs.h                        |    2 -
 include/linux/rmap.h                      |    2 -
 include/linux/slab.h                      |    1 
 include/linux/taskstats_kern.h            |    2 -
 ipc/mqueue.c                              |    2 -
 kernel/delayacct.c                        |    2 -
 kernel/fork.c                             |    6 ++--
 kernel/taskstats.c                        |    2 -
 kernel/user.c                             |    2 -
 mm/mempolicy.c                            |    2 -
 mm/mmap.c                                 |    4 +-
 mm/shmem.c                                |    2 -
 mm/slab.c                                 |    2 -
 net/decnet/dn_table.c                     |    2 -
 net/ipv4/fib_hash.c                       |    4 +-
 net/ipv4/fib_trie.c                       |    4 +-
 net/socket.c                              |    2 -
 net/sunrpc/rpc_pipe.c                     |    2 -
 security/keys/key.c                       |    2 -
 security/selinux/hooks.c                  |    2 -
 security/selinux/ss/avtab.c               |    2 -
 114 files changed, 164 insertions(+), 165 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~slab-remove-slab_kernel arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~slab-remove-slab_kernel
+++ a/arch/i386/kernel/sysenter.c
@@ -132,7 +132,7 @@ int arch_setup_additional_pages(struct l
 		goto up_fail;
 	}
 
-	vma = kmem_cache_zalloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		ret = -ENOMEM;
 		goto up_fail;
diff -puN arch/ia64/ia32/binfmt_elf32.c~slab-remove-slab_kernel arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~slab-remove-slab_kernel
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -91,7 +91,7 @@ ia64_elf32_init (struct pt_regs *regs)
 	 * it with privilege level 3 because the IVE uses non-privileged accesses to these
 	 * tables.  IA-32 segmentation is used to protect against IA-32 accesses to them.
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
 		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
@@ -117,7 +117,7 @@ ia64_elf32_init (struct pt_regs *regs)
 	 * code is locked in specific gate page, which is pointed by pretcode
 	 * when setup_frame_ia32
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
 		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
@@ -142,7 +142,7 @@ ia64_elf32_init (struct pt_regs *regs)
 	 * Install LDT as anonymous memory.  This gives us all-zero segment descriptors
 	 * until a task modifies them via modify_ldt().
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
 		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
@@ -214,7 +214,7 @@ ia32_setup_arg_pages (struct linux_binpr
 		bprm->loader += stack_base;
 	bprm->exec += stack_base;
 
-	mpnt = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	mpnt = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!mpnt)
 		return -ENOMEM;
 
diff -puN arch/ia64/kernel/perfmon.c~slab-remove-slab_kernel arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~slab-remove-slab_kernel
+++ a/arch/ia64/kernel/perfmon.c
@@ -2302,7 +2302,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	DPRINT(("smpl_buf @%p\n", smpl_buf));
 
 	/* allocate vma */
-	vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		DPRINT(("Cannot allocate vma\n"));
 		goto error_kmem;
diff -puN arch/ia64/mm/init.c~slab-remove-slab_kernel arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~slab-remove-slab_kernel
+++ a/arch/ia64/mm/init.c
@@ -156,7 +156,7 @@ ia64_init_addr_space (void)
 	 * the problem.  When the process attempts to write to the register backing store
 	 * for the first time, it will get a SEGFAULT in this case.
 	 */
-	vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (vma) {
 		memset(vma, 0, sizeof(*vma));
 		vma->vm_mm = current->mm;
@@ -175,7 +175,7 @@ ia64_init_addr_space (void)
 
 	/* map NaT-page at address zero to speed up speculative dereferencing of NULL: */
 	if (!(current->personality & MMAP_PAGE_ZERO)) {
-		vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+		vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (vma) {
 			memset(vma, 0, sizeof(*vma));
 			vma->vm_mm = current->mm;
diff -puN arch/powerpc/kernel/vdso.c~slab-remove-slab_kernel arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~slab-remove-slab_kernel
+++ a/arch/powerpc/kernel/vdso.c
@@ -264,7 +264,7 @@ int arch_setup_additional_pages(struct l
 
 
 	/* Allocate a VMA structure and fill it up */
-	vma = kmem_cache_zalloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (vma == NULL) {
 		rc = -ENOMEM;
 		goto fail_mmapsem;
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~slab-remove-slab_kernel arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~slab-remove-slab_kernel
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -48,7 +48,7 @@ spufs_alloc_inode(struct super_block *sb
 {
 	struct spufs_inode_info *ei;
 
-	ei = kmem_cache_alloc(spufs_inode_cache, SLAB_KERNEL);
+	ei = kmem_cache_alloc(spufs_inode_cache, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~slab-remove-slab_kernel arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~slab-remove-slab_kernel
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -97,7 +97,7 @@ int arch_setup_additional_pages(struct l
 		goto up_fail;
 	}
 
-	vma = kmem_cache_zalloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma) {
 		ret = -ENOMEM;
 		goto up_fail;
diff -puN arch/x86_64/ia32/ia32_binfmt.c~slab-remove-slab_kernel arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~slab-remove-slab_kernel
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -351,7 +351,7 @@ int ia32_setup_arg_pages(struct linux_bi
 		bprm->loader += stack_base;
 	bprm->exec += stack_base;
 
-	mpnt = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	mpnt = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!mpnt) 
 		return -ENOMEM; 
 
diff -puN arch/x86_64/ia32/syscall32.c~slab-remove-slab_kernel arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~slab-remove-slab_kernel
+++ a/arch/x86_64/ia32/syscall32.c
@@ -49,7 +49,7 @@ int syscall32_setup_pages(struct linux_b
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma)
 		return -ENOMEM;
 
diff -puN drivers/atm/he.c~slab-remove-slab_kernel drivers/atm/he.c
--- a/drivers/atm/he.c~slab-remove-slab_kernel
+++ a/drivers/atm/he.c
@@ -820,7 +820,7 @@ he_init_group(struct he_dev *he_dev, int
 		void *cpuaddr;
 
 #ifdef USE_RBPS_POOL 
-		cpuaddr = pci_pool_alloc(he_dev->rbps_pool, SLAB_KERNEL|SLAB_DMA, &dma_handle);
+		cpuaddr = pci_pool_alloc(he_dev->rbps_pool, GFP_KERNEL|SLAB_DMA, &dma_handle);
 		if (cpuaddr == NULL)
 			return -ENOMEM;
 #else
@@ -884,7 +884,7 @@ he_init_group(struct he_dev *he_dev, int
 		void *cpuaddr;
 
 #ifdef USE_RBPL_POOL
-		cpuaddr = pci_pool_alloc(he_dev->rbpl_pool, SLAB_KERNEL|SLAB_DMA, &dma_handle);
+		cpuaddr = pci_pool_alloc(he_dev->rbpl_pool, GFP_KERNEL|SLAB_DMA, &dma_handle);
 		if (cpuaddr == NULL)
 			return -ENOMEM;
 #else
diff -puN drivers/base/dmapool.c~slab-remove-slab_kernel drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~slab-remove-slab_kernel
+++ a/drivers/base/dmapool.c
@@ -126,7 +126,7 @@ dma_pool_create (const char *name, struc
 	} else if (allocation < size)
 		return NULL;
 
-	if (!(retval = kmalloc (sizeof *retval, SLAB_KERNEL)))
+	if (!(retval = kmalloc (sizeof *retval, GFP_KERNEL)))
 		return retval;
 
 	strlcpy (retval->name, name, sizeof retval->name);
diff -puN drivers/dma/ioatdma.c~slab-remove-slab_kernel drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~slab-remove-slab_kernel
+++ a/drivers/dma/ioatdma.c
@@ -636,10 +636,10 @@ static int ioat_self_test(struct ioat_de
 	dma_cookie_t cookie;
 	int err = 0;
 
-	src = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, SLAB_KERNEL);
+	src = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, GFP_KERNEL);
 	if (!src)
 		return -ENOMEM;
-	dest = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, SLAB_KERNEL);
+	dest = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, GFP_KERNEL);
 	if (!dest) {
 		kfree(src);
 		return -ENOMEM;
diff -puN drivers/ieee1394/hosts.c~slab-remove-slab_kernel drivers/ieee1394/hosts.c
--- a/drivers/ieee1394/hosts.c~slab-remove-slab_kernel
+++ a/drivers/ieee1394/hosts.c
@@ -123,7 +123,7 @@ struct hpsb_host *hpsb_alloc_host(struct
 	int i;
 	int hostnum = 0;
 
-	h = kzalloc(sizeof(*h) + extra, SLAB_KERNEL);
+	h = kzalloc(sizeof(*h) + extra, GFP_KERNEL);
 	if (!h)
 		return NULL;
 
diff -puN drivers/ieee1394/ohci1394.c~slab-remove-slab_kernel drivers/ieee1394/ohci1394.c
--- a/drivers/ieee1394/ohci1394.c~slab-remove-slab_kernel
+++ a/drivers/ieee1394/ohci1394.c
@@ -1225,7 +1225,7 @@ static int ohci_iso_recv_init(struct hps
 	int ctx;
 	int ret = -ENOMEM;
 
-	recv = kmalloc(sizeof(*recv), SLAB_KERNEL);
+	recv = kmalloc(sizeof(*recv), GFP_KERNEL);
 	if (!recv)
 		return -ENOMEM;
 
@@ -1918,7 +1918,7 @@ static int ohci_iso_xmit_init(struct hps
 	int ctx;
 	int ret = -ENOMEM;
 
-	xmit = kmalloc(sizeof(*xmit), SLAB_KERNEL);
+	xmit = kmalloc(sizeof(*xmit), GFP_KERNEL);
 	if (!xmit)
 		return -ENOMEM;
 
@@ -3021,7 +3021,7 @@ alloc_dma_rcv_ctx(struct ti_ohci *ohci, 
 			return -ENOMEM;
 		}
 
-		d->prg_cpu[i] = pci_pool_alloc(d->prg_pool, SLAB_KERNEL, d->prg_bus+i);
+		d->prg_cpu[i] = pci_pool_alloc(d->prg_pool, GFP_KERNEL, d->prg_bus+i);
 		OHCI_DMA_ALLOC("pool dma_rcv prg[%d]", i);
 
                 if (d->prg_cpu[i] != NULL) {
@@ -3117,7 +3117,7 @@ alloc_dma_trm_ctx(struct ti_ohci *ohci, 
 	OHCI_DMA_ALLOC("dma_rcv prg pool");
 
 	for (i = 0; i < d->num_desc; i++) {
-		d->prg_cpu[i] = pci_pool_alloc(d->prg_pool, SLAB_KERNEL, d->prg_bus+i);
+		d->prg_cpu[i] = pci_pool_alloc(d->prg_pool, GFP_KERNEL, d->prg_bus+i);
 		OHCI_DMA_ALLOC("pool dma_trm prg[%d]", i);
 
                 if (d->prg_cpu[i] != NULL) {
diff -puN drivers/ieee1394/pcilynx.c~slab-remove-slab_kernel drivers/ieee1394/pcilynx.c
--- a/drivers/ieee1394/pcilynx.c~slab-remove-slab_kernel
+++ a/drivers/ieee1394/pcilynx.c
@@ -1428,7 +1428,7 @@ static int __devinit add_card(struct pci
         	struct i2c_algo_bit_data i2c_adapter_data;
 
         	error = -ENOMEM;
-		i2c_ad = kmalloc(sizeof(*i2c_ad), SLAB_KERNEL);
+		i2c_ad = kmalloc(sizeof(*i2c_ad), GFP_KERNEL);
         	if (!i2c_ad) FAIL("failed to allocate I2C adapter memory");
 
 		memcpy(i2c_ad, &bit_ops, sizeof(struct i2c_adapter));
diff -puN drivers/ieee1394/raw1394.c~slab-remove-slab_kernel drivers/ieee1394/raw1394.c
--- a/drivers/ieee1394/raw1394.c~slab-remove-slab_kernel
+++ a/drivers/ieee1394/raw1394.c
@@ -112,7 +112,7 @@ static struct pending_request *__alloc_p
 
 static inline struct pending_request *alloc_pending_request(void)
 {
-	return __alloc_pending_request(SLAB_KERNEL);
+	return __alloc_pending_request(GFP_KERNEL);
 }
 
 static void free_pending_request(struct pending_request *req)
@@ -1737,7 +1737,7 @@ static int arm_register(struct file_info
 		return (-EINVAL);
 	}
 	/* addr-list-entry for fileinfo */
-	addr = kmalloc(sizeof(*addr), SLAB_KERNEL);
+	addr = kmalloc(sizeof(*addr), GFP_KERNEL);
 	if (!addr) {
 		req->req.length = 0;
 		return (-ENOMEM);
@@ -2103,7 +2103,7 @@ static int write_phypacket(struct file_i
 static int get_config_rom(struct file_info *fi, struct pending_request *req)
 {
 	int ret = sizeof(struct raw1394_request);
-	quadlet_t *data = kmalloc(req->req.length, SLAB_KERNEL);
+	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	int status;
 
 	if (!data)
@@ -2133,7 +2133,7 @@ static int get_config_rom(struct file_in
 static int update_config_rom(struct file_info *fi, struct pending_request *req)
 {
 	int ret = sizeof(struct raw1394_request);
-	quadlet_t *data = kmalloc(req->req.length, SLAB_KERNEL);
+	quadlet_t *data = kmalloc(req->req.length, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	if (copy_from_user(data, int2ptr(req->req.sendb), req->req.length)) {
@@ -2779,7 +2779,7 @@ static int raw1394_open(struct inode *in
 {
 	struct file_info *fi;
 
-	fi = kzalloc(sizeof(*fi), SLAB_KERNEL);
+	fi = kzalloc(sizeof(*fi), GFP_KERNEL);
 	if (!fi)
 		return -ENOMEM;
 
diff -puN drivers/infiniband/hw/ehca/ehca_av.c~slab-remove-slab_kernel drivers/infiniband/hw/ehca/ehca_av.c
--- a/drivers/infiniband/hw/ehca/ehca_av.c~slab-remove-slab_kernel
+++ a/drivers/infiniband/hw/ehca/ehca_av.c
@@ -57,7 +57,7 @@ struct ib_ah *ehca_create_ah(struct ib_p
 	struct ehca_shca *shca = container_of(pd->device, struct ehca_shca,
 					      ib_device);
 
-	av = kmem_cache_alloc(av_cache, SLAB_KERNEL);
+	av = kmem_cache_alloc(av_cache, GFP_KERNEL);
 	if (!av) {
 		ehca_err(pd->device, "Out of memory pd=%p ah_attr=%p",
 			 pd, ah_attr);
diff -puN drivers/infiniband/hw/ehca/ehca_cq.c~slab-remove-slab_kernel drivers/infiniband/hw/ehca/ehca_cq.c
--- a/drivers/infiniband/hw/ehca/ehca_cq.c~slab-remove-slab_kernel
+++ a/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -134,7 +134,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
 		return ERR_PTR(-EINVAL);
 
-	my_cq = kmem_cache_alloc(cq_cache, SLAB_KERNEL);
+	my_cq = kmem_cache_alloc(cq_cache, GFP_KERNEL);
 	if (!my_cq) {
 		ehca_err(device, "Out of memory for ehca_cq struct device=%p",
 			 device);
diff -puN drivers/infiniband/hw/ehca/ehca_main.c~slab-remove-slab_kernel drivers/infiniband/hw/ehca/ehca_main.c
--- a/drivers/infiniband/hw/ehca/ehca_main.c~slab-remove-slab_kernel
+++ a/drivers/infiniband/hw/ehca/ehca_main.c
@@ -108,7 +108,7 @@ static struct kmem_cache *ctblk_cache = 
 
 void *ehca_alloc_fw_ctrlblock(void)
 {
-	void *ret = kmem_cache_zalloc(ctblk_cache, SLAB_KERNEL);
+	void *ret = kmem_cache_zalloc(ctblk_cache, GFP_KERNEL);
 	if (!ret)
 		ehca_gen_err("Out of memory for ctblk");
 	return ret;
diff -puN drivers/infiniband/hw/ehca/ehca_mrmw.c~slab-remove-slab_kernel drivers/infiniband/hw/ehca/ehca_mrmw.c
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c~slab-remove-slab_kernel
+++ a/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -53,7 +53,7 @@ static struct ehca_mr *ehca_mr_new(void)
 {
 	struct ehca_mr *me;
 
-	me = kmem_cache_alloc(mr_cache, SLAB_KERNEL);
+	me = kmem_cache_alloc(mr_cache, GFP_KERNEL);
 	if (me) {
 		memset(me, 0, sizeof(struct ehca_mr));
 		spin_lock_init(&me->mrlock);
@@ -72,7 +72,7 @@ static struct ehca_mw *ehca_mw_new(void)
 {
 	struct ehca_mw *me;
 
-	me = kmem_cache_alloc(mw_cache, SLAB_KERNEL);
+	me = kmem_cache_alloc(mw_cache, GFP_KERNEL);
 	if (me) {
 		memset(me, 0, sizeof(struct ehca_mw));
 		spin_lock_init(&me->mwlock);
diff -puN drivers/infiniband/hw/ehca/ehca_pd.c~slab-remove-slab_kernel drivers/infiniband/hw/ehca/ehca_pd.c
--- a/drivers/infiniband/hw/ehca/ehca_pd.c~slab-remove-slab_kernel
+++ a/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -50,7 +50,7 @@ struct ib_pd *ehca_alloc_pd(struct ib_de
 {
 	struct ehca_pd *pd;
 
-	pd = kmem_cache_alloc(pd_cache, SLAB_KERNEL);
+	pd = kmem_cache_alloc(pd_cache, GFP_KERNEL);
 	if (!pd) {
 		ehca_err(device, "device=%p context=%p out of memory",
 			 device, context);
diff -puN drivers/infiniband/hw/ehca/ehca_qp.c~slab-remove-slab_kernel drivers/infiniband/hw/ehca/ehca_qp.c
--- a/drivers/infiniband/hw/ehca/ehca_qp.c~slab-remove-slab_kernel
+++ a/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -450,7 +450,7 @@ struct ib_qp *ehca_create_qp(struct ib_p
 	if (pd->uobject && udata)
 		context = pd->uobject->context;
 
-	my_qp = kmem_cache_alloc(qp_cache, SLAB_KERNEL);
+	my_qp = kmem_cache_alloc(qp_cache, GFP_KERNEL);
 	if (!my_qp) {
 		ehca_err(pd->device, "pd=%p not enough memory to alloc qp", pd);
 		return ERR_PTR(-ENOMEM);
diff -puN drivers/input/touchscreen/ads7846.c~slab-remove-slab_kernel drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~slab-remove-slab_kernel
+++ a/drivers/input/touchscreen/ads7846.c
@@ -189,7 +189,7 @@ static int ads7846_read12_ser(struct dev
 {
 	struct spi_device	*spi = to_spi_device(dev);
 	struct ads7846		*ts = dev_get_drvdata(dev);
-	struct ser_req		*req = kzalloc(sizeof *req, SLAB_KERNEL);
+	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
 	int			status;
 	int			sample;
 	int			i;
diff -puN drivers/isdn/gigaset/bas-gigaset.c~slab-remove-slab_kernel drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~slab-remove-slab_kernel
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -2218,21 +2218,21 @@ static int gigaset_probe(struct usb_inte
 	 * - three for the different uses of the default control pipe
 	 * - three for each isochronous pipe
 	 */
-	if (!(ucs->urb_int_in = usb_alloc_urb(0, SLAB_KERNEL)) ||
-	    !(ucs->urb_cmd_in = usb_alloc_urb(0, SLAB_KERNEL)) ||
-	    !(ucs->urb_cmd_out = usb_alloc_urb(0, SLAB_KERNEL)) ||
-	    !(ucs->urb_ctrl = usb_alloc_urb(0, SLAB_KERNEL)))
+	if (!(ucs->urb_int_in = usb_alloc_urb(0, GFP_KERNEL)) ||
+	    !(ucs->urb_cmd_in = usb_alloc_urb(0, GFP_KERNEL)) ||
+	    !(ucs->urb_cmd_out = usb_alloc_urb(0, GFP_KERNEL)) ||
+	    !(ucs->urb_ctrl = usb_alloc_urb(0, GFP_KERNEL)))
 		goto allocerr;
 
 	for (j = 0; j < 2; ++j) {
 		ubc = cs->bcs[j].hw.bas;
 		for (i = 0; i < BAS_OUTURBS; ++i)
 			if (!(ubc->isoouturbs[i].urb =
-			      usb_alloc_urb(BAS_NUMFRAMES, SLAB_KERNEL)))
+			      usb_alloc_urb(BAS_NUMFRAMES, GFP_KERNEL)))
 				goto allocerr;
 		for (i = 0; i < BAS_INURBS; ++i)
 			if (!(ubc->isoinurbs[i] =
-			      usb_alloc_urb(BAS_NUMFRAMES, SLAB_KERNEL)))
+			      usb_alloc_urb(BAS_NUMFRAMES, GFP_KERNEL)))
 				goto allocerr;
 	}
 
@@ -2246,7 +2246,7 @@ static int gigaset_probe(struct usb_inte
 					(endpoint->bEndpointAddress) & 0x0f),
 			 ucs->int_in_buf, 3, read_int_callback, cs,
 			 endpoint->bInterval);
-	if ((rc = usb_submit_urb(ucs->urb_int_in, SLAB_KERNEL)) != 0) {
+	if ((rc = usb_submit_urb(ucs->urb_int_in, GFP_KERNEL)) != 0) {
 		dev_err(cs->dev, "could not submit interrupt URB: %s\n",
 			get_usb_rcmsg(rc));
 		goto error;
diff -puN drivers/isdn/gigaset/usb-gigaset.c~slab-remove-slab_kernel drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~slab-remove-slab_kernel
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -763,7 +763,7 @@ static int gigaset_probe(struct usb_inte
 		goto error;
 	}
 
-	ucs->bulk_out_urb = usb_alloc_urb(0, SLAB_KERNEL);
+	ucs->bulk_out_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!ucs->bulk_out_urb) {
 		dev_err(cs->dev, "Couldn't allocate bulk_out_urb\n");
 		retval = -ENOMEM;
@@ -774,7 +774,7 @@ static int gigaset_probe(struct usb_inte
 
 	atomic_set(&ucs->busy, 0);
 
-	ucs->read_urb = usb_alloc_urb(0, SLAB_KERNEL);
+	ucs->read_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!ucs->read_urb) {
 		dev_err(cs->dev, "No free urbs available\n");
 		retval = -ENOMEM;
@@ -797,7 +797,7 @@ static int gigaset_probe(struct usb_inte
 			 gigaset_read_int_callback,
 			 cs->inbuf + 0, endpoint->bInterval);
 
-	retval = usb_submit_urb(ucs->read_urb, SLAB_KERNEL);
+	retval = usb_submit_urb(ucs->read_urb, GFP_KERNEL);
 	if (retval) {
 		dev_err(cs->dev, "Could not submit URB (error %d)\n", -retval);
 		goto error;
diff -puN drivers/media/dvb/cinergyT2/cinergyT2.c~slab-remove-slab_kernel drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c~slab-remove-slab_kernel
+++ a/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -287,7 +287,7 @@ static int cinergyt2_alloc_stream_urbs (
 	int i;
 
 	cinergyt2->streambuf = usb_buffer_alloc(cinergyt2->udev, STREAM_URB_COUNT*STREAM_BUF_SIZE,
-					      SLAB_KERNEL, &cinergyt2->streambuf_dmahandle);
+					      GFP_KERNEL, &cinergyt2->streambuf_dmahandle);
 	if (!cinergyt2->streambuf) {
 		dprintk(1, "failed to alloc consistent stream memory area, bailing out!\n");
 		return -ENOMEM;
diff -puN drivers/mtd/devices/m25p80.c~slab-remove-slab_kernel drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~slab-remove-slab_kernel
+++ a/drivers/mtd/devices/m25p80.c
@@ -451,7 +451,7 @@ static int __devinit m25p_probe(struct s
 		return -ENODEV;
 	}
 
-	flash = kzalloc(sizeof *flash, SLAB_KERNEL);
+	flash = kzalloc(sizeof *flash, GFP_KERNEL);
 	if (!flash)
 		return -ENOMEM;
 
diff -puN drivers/scsi/ipr.c~slab-remove-slab_kernel drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~slab-remove-slab_kernel
+++ a/drivers/scsi/ipr.c
@@ -6940,7 +6940,7 @@ static int __devinit ipr_alloc_cmd_blks(
 		return -ENOMEM;
 
 	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
-		ipr_cmd = pci_pool_alloc (ioa_cfg->ipr_cmd_pool, SLAB_KERNEL, &dma_addr);
+		ipr_cmd = pci_pool_alloc (ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
 
 		if (!ipr_cmd) {
 			ipr_free_cmd_blks(ioa_cfg);
diff -puN drivers/spi/spi.c~slab-remove-slab_kernel drivers/spi/spi.c
--- a/drivers/spi/spi.c~slab-remove-slab_kernel
+++ a/drivers/spi/spi.c
@@ -360,7 +360,7 @@ spi_alloc_master(struct device *dev, uns
 	if (!dev)
 		return NULL;
 
-	master = kzalloc(size + sizeof *master, SLAB_KERNEL);
+	master = kzalloc(size + sizeof *master, GFP_KERNEL);
 	if (!master)
 		return NULL;
 
@@ -607,7 +607,7 @@ static int __init spi_init(void)
 {
 	int	status;
 
-	buf = kmalloc(SPI_BUFSIZ, SLAB_KERNEL);
+	buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
 	if (!buf) {
 		status = -ENOMEM;
 		goto err0;
diff -puN drivers/spi/spi_bitbang.c~slab-remove-slab_kernel drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~slab-remove-slab_kernel
+++ a/drivers/spi/spi_bitbang.c
@@ -196,7 +196,7 @@ int spi_bitbang_setup(struct spi_device 
 		return -EINVAL;
 
 	if (!cs) {
-		cs = kzalloc(sizeof *cs, SLAB_KERNEL);
+		cs = kzalloc(sizeof *cs, GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
 		spi->controller_state = cs;
diff -puN drivers/usb/core/hub.c~slab-remove-slab_kernel drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~slab-remove-slab_kernel
+++ a/drivers/usb/core/hub.c
@@ -2371,7 +2371,7 @@ check_highspeed (struct usb_hub *hub, st
 	struct usb_qualifier_descriptor	*qual;
 	int				status;
 
-	qual = kmalloc (sizeof *qual, SLAB_KERNEL);
+	qual = kmalloc (sizeof *qual, GFP_KERNEL);
 	if (qual == NULL)
 		return;
 
@@ -2922,7 +2922,7 @@ static int config_descriptors_changed(st
 		if (len < le16_to_cpu(udev->config[index].desc.wTotalLength))
 			len = le16_to_cpu(udev->config[index].desc.wTotalLength);
 	}
-	buf = kmalloc (len, SLAB_KERNEL);
+	buf = kmalloc (len, GFP_KERNEL);
 	if (buf == NULL) {
 		dev_err(&udev->dev, "no mem to re-read configs after reset\n");
 		/* assume the worst */
diff -puN drivers/usb/gadget/gmidi.c~slab-remove-slab_kernel drivers/usb/gadget/gmidi.c
--- a/drivers/usb/gadget/gmidi.c~slab-remove-slab_kernel
+++ a/drivers/usb/gadget/gmidi.c
@@ -1236,7 +1236,7 @@ autoconf_fail:
 
 
 	/* ok, we made sense of the hardware ... */
-	dev = kzalloc(sizeof(*dev), SLAB_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		return -ENOMEM;
 	}
diff -puN drivers/usb/gadget/goku_udc.c~slab-remove-slab_kernel drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~slab-remove-slab_kernel
+++ a/drivers/usb/gadget/goku_udc.c
@@ -1864,7 +1864,7 @@ static int goku_probe(struct pci_dev *pd
 	}
 
 	/* alloc, and start init */
-	dev = kmalloc (sizeof *dev, SLAB_KERNEL);
+	dev = kmalloc (sizeof *dev, GFP_KERNEL);
 	if (dev == NULL){
 		pr_debug("enomem %s\n", pci_name(pdev));
 		retval = -ENOMEM;
diff -puN drivers/usb/gadget/inode.c~slab-remove-slab_kernel drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~slab-remove-slab_kernel
+++ a/drivers/usb/gadget/inode.c
@@ -412,7 +412,7 @@ ep_read (struct file *fd, char __user *b
 	/* FIXME readahead for O_NONBLOCK and poll(); careful with ZLPs */
 
 	value = -ENOMEM;
-	kbuf = kmalloc (len, SLAB_KERNEL);
+	kbuf = kmalloc (len, GFP_KERNEL);
 	if (unlikely (!kbuf))
 		goto free1;
 
@@ -456,7 +456,7 @@ ep_write (struct file *fd, const char __
 	/* FIXME writebehind for O_NONBLOCK and poll(), qlen = 1 */
 
 	value = -ENOMEM;
-	kbuf = kmalloc (len, SLAB_KERNEL);
+	kbuf = kmalloc (len, GFP_KERNEL);
 	if (!kbuf)
 		goto free1;
 	if (copy_from_user (kbuf, buf, len)) {
@@ -1898,7 +1898,7 @@ dev_config (struct file *fd, const char 
 	buf += 4;
 	length -= 4;
 
-	kbuf = kmalloc (length, SLAB_KERNEL);
+	kbuf = kmalloc (length, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 	if (copy_from_user (kbuf, buf, length)) {
diff -puN drivers/usb/gadget/net2280.c~slab-remove-slab_kernel drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~slab-remove-slab_kernel
+++ a/drivers/usb/gadget/net2280.c
@@ -2861,7 +2861,7 @@ static int net2280_probe (struct pci_dev
 	}
 
 	/* alloc, and start init */
-	dev = kzalloc (sizeof *dev, SLAB_KERNEL);
+	dev = kzalloc (sizeof *dev, GFP_KERNEL);
 	if (dev == NULL){
 		retval = -ENOMEM;
 		goto done;
diff -puN drivers/usb/gadget/omap_udc.c~slab-remove-slab_kernel drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c~slab-remove-slab_kernel
+++ a/drivers/usb/gadget/omap_udc.c
@@ -2581,7 +2581,7 @@ omap_udc_setup(struct platform_device *o
 	/* UDC_PULLUP_EN gates the chip clock */
 	// OTG_SYSCON_1_REG |= DEV_IDLE_EN;
 
-	udc = kzalloc(sizeof(*udc), SLAB_KERNEL);
+	udc = kzalloc(sizeof(*udc), GFP_KERNEL);
 	if (!udc)
 		return -ENOMEM;
 
diff -puN drivers/usb/gadget/zero.c~slab-remove-slab_kernel drivers/usb/gadget/zero.c
--- a/drivers/usb/gadget/zero.c~slab-remove-slab_kernel
+++ a/drivers/usb/gadget/zero.c
@@ -1190,7 +1190,7 @@ autoconf_fail:
 
 
 	/* ok, we made sense of the hardware ... */
-	dev = kzalloc(sizeof(*dev), SLAB_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 	spin_lock_init (&dev->lock);
diff -puN drivers/usb/host/hc_crisv10.c~slab-remove-slab_kernel drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~slab-remove-slab_kernel
+++ a/drivers/usb/host/hc_crisv10.c
@@ -188,7 +188,7 @@ static DEFINE_TIMER(bulk_eot_timer, NULL
 #define CHECK_ALIGN(x) if (((__u32)(x)) & 0x00000003) \
 {panic("Alignment check (DWORD) failed at %s:%s:%d\n", __FILE__, __FUNCTION__, __LINE__);}
 
-#define SLAB_FLAG     (in_interrupt() ? GFP_ATOMIC : SLAB_KERNEL)
+#define SLAB_FLAG     (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
 #define KMALLOC_FLAG  (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
 
 /* Most helpful debugging aid */
diff -puN drivers/usb/host/ohci-pnx4008.c~slab-remove-slab_kernel drivers/usb/host/ohci-pnx4008.c
--- a/drivers/usb/host/ohci-pnx4008.c~slab-remove-slab_kernel
+++ a/drivers/usb/host/ohci-pnx4008.c
@@ -134,7 +134,7 @@ static int isp1301_attach(struct i2c_ada
 {
 	struct i2c_client *c;
 
-	c = (struct i2c_client *)kzalloc(sizeof(*c), SLAB_KERNEL);
+	c = (struct i2c_client *)kzalloc(sizeof(*c), GFP_KERNEL);
 
 	if (!c)
 		return -ENOMEM;
diff -puN drivers/usb/input/acecad.c~slab-remove-slab_kernel drivers/usb/input/acecad.c
--- a/drivers/usb/input/acecad.c~slab-remove-slab_kernel
+++ a/drivers/usb/input/acecad.c
@@ -152,7 +152,7 @@ static int usb_acecad_probe(struct usb_i
 	if (!acecad || !input_dev)
 		goto fail1;
 
-	acecad->data = usb_buffer_alloc(dev, 8, SLAB_KERNEL, &acecad->data_dma);
+	acecad->data = usb_buffer_alloc(dev, 8, GFP_KERNEL, &acecad->data_dma);
 	if (!acecad->data)
 		goto fail1;
 
diff -puN drivers/usb/input/usbtouchscreen.c~slab-remove-slab_kernel drivers/usb/input/usbtouchscreen.c
--- a/drivers/usb/input/usbtouchscreen.c~slab-remove-slab_kernel
+++ a/drivers/usb/input/usbtouchscreen.c
@@ -680,7 +680,7 @@ static int usbtouch_probe(struct usb_int
 		type->process_pkt = usbtouch_process_pkt;
 
 	usbtouch->data = usb_buffer_alloc(udev, type->rept_size,
-	                                  SLAB_KERNEL, &usbtouch->data_dma);
+	                                  GFP_KERNEL, &usbtouch->data_dma);
 	if (!usbtouch->data)
 		goto out_free;
 
diff -puN drivers/usb/misc/usbtest.c~slab-remove-slab_kernel drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~slab-remove-slab_kernel
+++ a/drivers/usb/misc/usbtest.c
@@ -213,7 +213,7 @@ static struct urb *simple_alloc_urb (
 
 	if (bytes < 0)
 		return NULL;
-	urb = usb_alloc_urb (0, SLAB_KERNEL);
+	urb = usb_alloc_urb (0, GFP_KERNEL);
 	if (!urb)
 		return urb;
 	usb_fill_bulk_urb (urb, udev, pipe, NULL, bytes, simple_callback, NULL);
@@ -223,7 +223,7 @@ static struct urb *simple_alloc_urb (
 	urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 	if (usb_pipein (pipe))
 		urb->transfer_flags |= URB_SHORT_NOT_OK;
-	urb->transfer_buffer = usb_buffer_alloc (udev, bytes, SLAB_KERNEL,
+	urb->transfer_buffer = usb_buffer_alloc (udev, bytes, GFP_KERNEL,
 			&urb->transfer_dma);
 	if (!urb->transfer_buffer) {
 		usb_free_urb (urb);
@@ -315,7 +315,7 @@ static int simple_io (
 		init_completion (&completion);
 		if (usb_pipeout (urb->pipe))
 			simple_fill_buf (urb);
-		if ((retval = usb_submit_urb (urb, SLAB_KERNEL)) != 0)
+		if ((retval = usb_submit_urb (urb, GFP_KERNEL)) != 0)
 			break;
 
 		/* NOTE:  no timeouts; can't be broken out of by interrupt */
@@ -374,7 +374,7 @@ alloc_sglist (int nents, int max, int va
 	unsigned		i;
 	unsigned		size = max;
 
-	sg = kmalloc (nents * sizeof *sg, SLAB_KERNEL);
+	sg = kmalloc (nents * sizeof *sg, GFP_KERNEL);
 	if (!sg)
 		return NULL;
 
@@ -382,7 +382,7 @@ alloc_sglist (int nents, int max, int va
 		char		*buf;
 		unsigned	j;
 
-		buf = kzalloc (size, SLAB_KERNEL);
+		buf = kzalloc (size, GFP_KERNEL);
 		if (!buf) {
 			free_sglist (sg, i);
 			return NULL;
@@ -428,7 +428,7 @@ static int perform_sglist (
 				(udev->speed == USB_SPEED_HIGH)
 					? (INTERRUPT_RATE << 3)
 					: INTERRUPT_RATE,
-				sg, nents, 0, SLAB_KERNEL);
+				sg, nents, 0, GFP_KERNEL);
 		
 		if (retval)
 			break;
@@ -855,7 +855,7 @@ test_ctrl_queue (struct usbtest_dev *dev
 	 * as with bulk/intr sglists, sglen is the queue depth; it also
 	 * controls which subtests run (more tests than sglen) or rerun.
 	 */
-	urb = kcalloc(param->sglen, sizeof(struct urb *), SLAB_KERNEL);
+	urb = kcalloc(param->sglen, sizeof(struct urb *), GFP_KERNEL);
 	if (!urb)
 		return -ENOMEM;
 	for (i = 0; i < param->sglen; i++) {
@@ -981,7 +981,7 @@ test_ctrl_queue (struct usbtest_dev *dev
 		if (!u)
 			goto cleanup;
 
-		reqp = usb_buffer_alloc (udev, sizeof *reqp, SLAB_KERNEL,
+		reqp = usb_buffer_alloc (udev, sizeof *reqp, GFP_KERNEL,
 				&u->setup_dma);
 		if (!reqp)
 			goto cleanup;
@@ -1067,7 +1067,7 @@ static int unlink1 (struct usbtest_dev *
 	 * FIXME want additional tests for when endpoint is STALLing
 	 * due to errors, or is just NAKing requests.
 	 */
-	if ((retval = usb_submit_urb (urb, SLAB_KERNEL)) != 0) {
+	if ((retval = usb_submit_urb (urb, GFP_KERNEL)) != 0) {
 		dev_dbg (&dev->intf->dev, "submit fail %d\n", retval);
 		return retval;
 	}
@@ -1251,7 +1251,7 @@ static int ctrl_out (struct usbtest_dev 
 	if (length < 1 || length > 0xffff || vary >= length)
 		return -EINVAL;
 
-	buf = kmalloc(length, SLAB_KERNEL);
+	buf = kmalloc(length, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -1403,7 +1403,7 @@ static struct urb *iso_alloc_urb (
 	maxp *= 1 + (0x3 & (le16_to_cpu(desc->wMaxPacketSize) >> 11));
 	packets = (bytes + maxp - 1) / maxp;
 
-	urb = usb_alloc_urb (packets, SLAB_KERNEL);
+	urb = usb_alloc_urb (packets, GFP_KERNEL);
 	if (!urb)
 		return urb;
 	urb->dev = udev;
@@ -1411,7 +1411,7 @@ static struct urb *iso_alloc_urb (
 
 	urb->number_of_packets = packets;
 	urb->transfer_buffer_length = bytes;
-	urb->transfer_buffer = usb_buffer_alloc (udev, bytes, SLAB_KERNEL,
+	urb->transfer_buffer = usb_buffer_alloc (udev, bytes, GFP_KERNEL,
 			&urb->transfer_dma);
 	if (!urb->transfer_buffer) {
 		usb_free_urb (urb);
@@ -1900,7 +1900,7 @@ usbtest_probe (struct usb_interface *int
 	}
 #endif
 
-	dev = kzalloc(sizeof(*dev), SLAB_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 	info = (struct usbtest_info *) id->driver_info;
@@ -1910,7 +1910,7 @@ usbtest_probe (struct usb_interface *int
 	dev->intf = intf;
 
 	/* cacheline-aligned scratch for i/o */
-	if ((dev->buf = kmalloc (TBUF_SIZE, SLAB_KERNEL)) == NULL) {
+	if ((dev->buf = kmalloc (TBUF_SIZE, GFP_KERNEL)) == NULL) {
 		kfree (dev);
 		return -ENOMEM;
 	}
diff -puN drivers/usb/net/rndis_host.c~slab-remove-slab_kernel drivers/usb/net/rndis_host.c
--- a/drivers/usb/net/rndis_host.c~slab-remove-slab_kernel
+++ a/drivers/usb/net/rndis_host.c
@@ -469,7 +469,7 @@ static void rndis_unbind(struct usbnet *
 	struct rndis_halt	*halt;
 
 	/* try to clear any rndis state/activity (no i/o from stack!) */
-	halt = kcalloc(1, sizeof *halt, SLAB_KERNEL);
+	halt = kcalloc(1, sizeof *halt, GFP_KERNEL);
 	if (halt) {
 		halt->msg_type = RNDIS_MSG_HALT;
 		halt->msg_len = ccpu2(sizeof *halt);
diff -puN drivers/usb/net/usbnet.c~slab-remove-slab_kernel drivers/usb/net/usbnet.c
--- a/drivers/usb/net/usbnet.c~slab-remove-slab_kernel
+++ a/drivers/usb/net/usbnet.c
@@ -179,9 +179,9 @@ static int init_status (struct usbnet *d
 	period = max ((int) dev->status->desc.bInterval,
 		(dev->udev->speed == USB_SPEED_HIGH) ? 7 : 3);
 
-	buf = kmalloc (maxp, SLAB_KERNEL);
+	buf = kmalloc (maxp, GFP_KERNEL);
 	if (buf) {
-		dev->interrupt = usb_alloc_urb (0, SLAB_KERNEL);
+		dev->interrupt = usb_alloc_urb (0, GFP_KERNEL);
 		if (!dev->interrupt) {
 			kfree (buf);
 			return -ENOMEM;
diff -puN fs/adfs/super.c~slab-remove-slab_kernel fs/adfs/super.c
--- a/fs/adfs/super.c~slab-remove-slab_kernel
+++ a/fs/adfs/super.c
@@ -217,7 +217,7 @@ static kmem_cache_t *adfs_inode_cachep;
 static struct inode *adfs_alloc_inode(struct super_block *sb)
 {
 	struct adfs_inode_info *ei;
-	ei = (struct adfs_inode_info *)kmem_cache_alloc(adfs_inode_cachep, SLAB_KERNEL);
+	ei = (struct adfs_inode_info *)kmem_cache_alloc(adfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/affs/super.c~slab-remove-slab_kernel fs/affs/super.c
--- a/fs/affs/super.c~slab-remove-slab_kernel
+++ a/fs/affs/super.c
@@ -71,7 +71,7 @@ static kmem_cache_t * affs_inode_cachep;
 static struct inode *affs_alloc_inode(struct super_block *sb)
 {
 	struct affs_inode_info *ei;
-	ei = (struct affs_inode_info *)kmem_cache_alloc(affs_inode_cachep, SLAB_KERNEL);
+	ei = (struct affs_inode_info *)kmem_cache_alloc(affs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
diff -puN fs/afs/super.c~slab-remove-slab_kernel fs/afs/super.c
--- a/fs/afs/super.c~slab-remove-slab_kernel
+++ a/fs/afs/super.c
@@ -412,7 +412,7 @@ static struct inode *afs_alloc_inode(str
 	struct afs_vnode *vnode;
 
 	vnode = (struct afs_vnode *)
-		kmem_cache_alloc(afs_inode_cachep, SLAB_KERNEL);
+		kmem_cache_alloc(afs_inode_cachep, GFP_KERNEL);
 	if (!vnode)
 		return NULL;
 
diff -puN fs/befs/linuxvfs.c~slab-remove-slab_kernel fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~slab-remove-slab_kernel
+++ a/fs/befs/linuxvfs.c
@@ -277,7 +277,7 @@ befs_alloc_inode(struct super_block *sb)
 {
         struct befs_inode_info *bi;
         bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
-							SLAB_KERNEL);
+							GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;
diff -puN fs/bfs/inode.c~slab-remove-slab_kernel fs/bfs/inode.c
--- a/fs/bfs/inode.c~slab-remove-slab_kernel
+++ a/fs/bfs/inode.c
@@ -233,7 +233,7 @@ static kmem_cache_t * bfs_inode_cachep;
 static struct inode *bfs_alloc_inode(struct super_block *sb)
 {
 	struct bfs_inode_info *bi;
-	bi = kmem_cache_alloc(bfs_inode_cachep, SLAB_KERNEL);
+	bi = kmem_cache_alloc(bfs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
 	return &bi->vfs_inode;
diff -puN fs/block_dev.c~slab-remove-slab_kernel fs/block_dev.c
--- a/fs/block_dev.c~slab-remove-slab_kernel
+++ a/fs/block_dev.c
@@ -239,7 +239,7 @@ static kmem_cache_t * bdev_cachep __read
 
 static struct inode *bdev_alloc_inode(struct super_block *sb)
 {
-	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, SLAB_KERNEL);
+	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/cifs/cifsfs.c~slab-remove-slab_kernel fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~slab-remove-slab_kernel
+++ a/fs/cifs/cifsfs.c
@@ -245,7 +245,7 @@ static struct inode *
 cifs_alloc_inode(struct super_block *sb)
 {
 	struct cifsInodeInfo *cifs_inode;
-	cifs_inode = kmem_cache_alloc(cifs_inode_cachep, SLAB_KERNEL);
+	cifs_inode = kmem_cache_alloc(cifs_inode_cachep, GFP_KERNEL);
 	if (!cifs_inode)
 		return NULL;
 	cifs_inode->cifsAttrs = 0x20;	/* default */
diff -puN fs/cifs/misc.c~slab-remove-slab_kernel fs/cifs/misc.c
--- a/fs/cifs/misc.c~slab-remove-slab_kernel
+++ a/fs/cifs/misc.c
@@ -153,7 +153,7 @@ cifs_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize 
    defaults to this and can not be bigger */
 	ret_buf =
-	    (struct smb_hdr *) mempool_alloc(cifs_req_poolp, SLAB_KERNEL | GFP_NOFS);
+	    (struct smb_hdr *) mempool_alloc(cifs_req_poolp, GFP_KERNEL | GFP_NOFS);
 
 	/* clear the first few header bytes */
 	/* for most paths, more is cleared in header_assemble */
@@ -192,7 +192,7 @@ cifs_small_buf_get(void)
    albeit slightly larger than necessary and maxbuffersize 
    defaults to this and can not be bigger */
 	ret_buf =
-	    (struct smb_hdr *) mempool_alloc(cifs_sm_req_poolp, SLAB_KERNEL | GFP_NOFS);
+	    (struct smb_hdr *) mempool_alloc(cifs_sm_req_poolp, GFP_KERNEL | GFP_NOFS);
 	if (ret_buf) {
 	/* No need to clear memory here, cleared in header assemble */
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
diff -puN fs/cifs/transport.c~slab-remove-slab_kernel fs/cifs/transport.c
--- a/fs/cifs/transport.c~slab-remove-slab_kernel
+++ a/fs/cifs/transport.c
@@ -51,7 +51,7 @@ AllocMidQEntry(const struct smb_hdr *smb
 	}
 	
 	temp = (struct mid_q_entry *) mempool_alloc(cifs_mid_poolp,
-						    SLAB_KERNEL | GFP_NOFS);
+						    GFP_KERNEL | GFP_NOFS);
 	if (temp == NULL)
 		return temp;
 	else {
@@ -118,7 +118,7 @@ AllocOplockQEntry(struct inode * pinode,
 		return NULL;
 	}
 	temp = (struct oplock_q_entry *) kmem_cache_alloc(cifs_oplock_cachep,
-						       SLAB_KERNEL);
+						       GFP_KERNEL);
 	if (temp == NULL)
 		return temp;
 	else {
diff -puN fs/coda/inode.c~slab-remove-slab_kernel fs/coda/inode.c
--- a/fs/coda/inode.c~slab-remove-slab_kernel
+++ a/fs/coda/inode.c
@@ -43,7 +43,7 @@ static kmem_cache_t * coda_inode_cachep;
 static struct inode *coda_alloc_inode(struct super_block *sb)
 {
 	struct coda_inode_info *ei;
-	ei = (struct coda_inode_info *)kmem_cache_alloc(coda_inode_cachep, SLAB_KERNEL);
+	ei = (struct coda_inode_info *)kmem_cache_alloc(coda_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	memset(&ei->c_fid, 0, sizeof(struct CodaFid));
diff -puN fs/dnotify.c~slab-remove-slab_kernel fs/dnotify.c
--- a/fs/dnotify.c~slab-remove-slab_kernel
+++ a/fs/dnotify.c
@@ -77,7 +77,7 @@ int fcntl_dirnotify(int fd, struct file 
 	inode = filp->f_dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode))
 		return -ENOTDIR;
-	dn = kmem_cache_alloc(dn_cache, SLAB_KERNEL);
+	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
 	if (dn == NULL)
 		return -ENOMEM;
 	spin_lock(&inode->i_lock);
diff -puN fs/ecryptfs/crypto.c~slab-remove-slab_kernel fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~slab-remove-slab_kernel
+++ a/fs/ecryptfs/crypto.c
@@ -628,7 +628,7 @@ int ecryptfs_decrypt_page(struct file *f
 	num_extents_per_page = PAGE_CACHE_SIZE / crypt_stat->extent_size;
 	base_extent = (page->index * num_extents_per_page);
 	lower_page_virt = kmem_cache_alloc(ecryptfs_lower_page_cache,
-					   SLAB_KERNEL);
+					   GFP_KERNEL);
 	if (!lower_page_virt) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error getting page for encrypted "
diff -puN fs/ecryptfs/file.c~slab-remove-slab_kernel fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~slab-remove-slab_kernel
+++ a/fs/ecryptfs/file.c
@@ -250,7 +250,7 @@ static int ecryptfs_open(struct inode *i
 	int lower_flags;
 
 	/* Released in ecryptfs_release or end of function if failure */
-	file_info = kmem_cache_alloc(ecryptfs_file_info_cache, SLAB_KERNEL);
+	file_info = kmem_cache_alloc(ecryptfs_file_info_cache, GFP_KERNEL);
 	ecryptfs_set_file_private(file, file_info);
 	if (!file_info) {
 		ecryptfs_printk(KERN_ERR,
diff -puN fs/ecryptfs/inode.c~slab-remove-slab_kernel fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~slab-remove-slab_kernel
+++ a/fs/ecryptfs/inode.c
@@ -369,7 +369,7 @@ static struct dentry *ecryptfs_lookup(st
 	BUG_ON(!atomic_read(&lower_dentry->d_count));
 	ecryptfs_set_dentry_private(dentry,
 				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
-						     SLAB_KERNEL));
+						     GFP_KERNEL));
 	if (!ecryptfs_dentry_to_private(dentry)) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Out of memory whilst attempting "
@@ -795,7 +795,7 @@ int ecryptfs_truncate(struct dentry *den
 	/* Released at out_free: label */
 	ecryptfs_set_file_private(&fake_ecryptfs_file,
 				  kmem_cache_alloc(ecryptfs_file_info_cache,
-						   SLAB_KERNEL));
+						   GFP_KERNEL));
 	if (unlikely(!ecryptfs_file_to_private(&fake_ecryptfs_file))) {
 		rc = -ENOMEM;
 		goto out;
diff -puN fs/ecryptfs/keystore.c~slab-remove-slab_kernel fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~slab-remove-slab_kernel
+++ a/fs/ecryptfs/keystore.c
@@ -207,7 +207,7 @@ parse_tag_3_packet(struct ecryptfs_crypt
 	/* Released: wipe_auth_tok_list called in ecryptfs_parse_packet_set or
 	 * at end of function upon failure */
 	auth_tok_list_item =
-	    kmem_cache_alloc(ecryptfs_auth_tok_list_item_cache, SLAB_KERNEL);
+	    kmem_cache_alloc(ecryptfs_auth_tok_list_item_cache, GFP_KERNEL);
 	if (!auth_tok_list_item) {
 		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
 		rc = -ENOMEM;
diff -puN fs/ecryptfs/main.c~slab-remove-slab_kernel fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~slab-remove-slab_kernel
+++ a/fs/ecryptfs/main.c
@@ -378,7 +378,7 @@ ecryptfs_fill_super(struct super_block *
 	/* Released in ecryptfs_put_super() */
 	ecryptfs_set_superblock_private(sb,
 					kmem_cache_alloc(ecryptfs_sb_info_cache,
-							 SLAB_KERNEL));
+							 GFP_KERNEL));
 	if (!ecryptfs_superblock_to_private(sb)) {
 		ecryptfs_printk(KERN_WARNING, "Out of memory\n");
 		rc = -ENOMEM;
@@ -402,7 +402,7 @@ ecryptfs_fill_super(struct super_block *
 	/* through deactivate_super(sb) from get_sb_nodev() */
 	ecryptfs_set_dentry_private(sb->s_root,
 				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
-						     SLAB_KERNEL));
+						     GFP_KERNEL));
 	if (!ecryptfs_dentry_to_private(sb->s_root)) {
 		ecryptfs_printk(KERN_ERR,
 				"dentry_info_cache alloc failed\n");
diff -puN fs/ecryptfs/super.c~slab-remove-slab_kernel fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~slab-remove-slab_kernel
+++ a/fs/ecryptfs/super.c
@@ -50,7 +50,7 @@ static struct inode *ecryptfs_alloc_inod
 	struct inode *inode = NULL;
 
 	ecryptfs_inode = kmem_cache_alloc(ecryptfs_inode_info_cache,
-					  SLAB_KERNEL);
+					  GFP_KERNEL);
 	if (unlikely(!ecryptfs_inode))
 		goto out;
 	ecryptfs_init_crypt_stat(&ecryptfs_inode->crypt_stat);
diff -puN fs/efs/super.c~slab-remove-slab_kernel fs/efs/super.c
--- a/fs/efs/super.c~slab-remove-slab_kernel
+++ a/fs/efs/super.c
@@ -57,7 +57,7 @@ static kmem_cache_t * efs_inode_cachep;
 static struct inode *efs_alloc_inode(struct super_block *sb)
 {
 	struct efs_inode_info *ei;
-	ei = (struct efs_inode_info *)kmem_cache_alloc(efs_inode_cachep, SLAB_KERNEL);
+	ei = (struct efs_inode_info *)kmem_cache_alloc(efs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/eventpoll.c~slab-remove-slab_kernel fs/eventpoll.c
--- a/fs/eventpoll.c~slab-remove-slab_kernel
+++ a/fs/eventpoll.c
@@ -961,7 +961,7 @@ static void ep_ptable_queue_proc(struct 
 	struct epitem *epi = ep_item_from_epqueue(pt);
 	struct eppoll_entry *pwq;
 
-	if (epi->nwait >= 0 && (pwq = kmem_cache_alloc(pwq_cache, SLAB_KERNEL))) {
+	if (epi->nwait >= 0 && (pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL))) {
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
@@ -1004,7 +1004,7 @@ static int ep_insert(struct eventpoll *e
 	struct ep_pqueue epq;
 
 	error = -ENOMEM;
-	if (!(epi = kmem_cache_alloc(epi_cache, SLAB_KERNEL)))
+	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		goto eexit_1;
 
 	/* Item initialization follow here ... */
diff -puN fs/exec.c~slab-remove-slab_kernel fs/exec.c
--- a/fs/exec.c~slab-remove-slab_kernel
+++ a/fs/exec.c
@@ -404,7 +404,7 @@ int setup_arg_pages(struct linux_binprm 
 		bprm->loader += stack_base;
 	bprm->exec += stack_base;
 
-	mpnt = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	mpnt = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!mpnt)
 		return -ENOMEM;
 
diff -puN fs/ext2/super.c~slab-remove-slab_kernel fs/ext2/super.c
--- a/fs/ext2/super.c~slab-remove-slab_kernel
+++ a/fs/ext2/super.c
@@ -140,7 +140,7 @@ static kmem_cache_t * ext2_inode_cachep;
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
 	struct ext2_inode_info *ei;
-	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, SLAB_KERNEL);
+	ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
diff -puN fs/fat/cache.c~slab-remove-slab_kernel fs/fat/cache.c
--- a/fs/fat/cache.c~slab-remove-slab_kernel
+++ a/fs/fat/cache.c
@@ -63,7 +63,7 @@ void fat_cache_destroy(void)
 
 static inline struct fat_cache *fat_cache_alloc(struct inode *inode)
 {
-	return kmem_cache_alloc(fat_cache_cachep, SLAB_KERNEL);
+	return kmem_cache_alloc(fat_cache_cachep, GFP_KERNEL);
 }
 
 static inline void fat_cache_free(struct fat_cache *cache)
diff -puN fs/fat/inode.c~slab-remove-slab_kernel fs/fat/inode.c
--- a/fs/fat/inode.c~slab-remove-slab_kernel
+++ a/fs/fat/inode.c
@@ -482,7 +482,7 @@ static kmem_cache_t *fat_inode_cachep;
 static struct inode *fat_alloc_inode(struct super_block *sb)
 {
 	struct msdos_inode_info *ei;
-	ei = kmem_cache_alloc(fat_inode_cachep, SLAB_KERNEL);
+	ei = kmem_cache_alloc(fat_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/fcntl.c~slab-remove-slab_kernel fs/fcntl.c
--- a/fs/fcntl.c~slab-remove-slab_kernel
+++ a/fs/fcntl.c
@@ -567,7 +567,7 @@ int fasync_helper(int fd, struct file * 
 	int result = 0;
 
 	if (on) {
-		new = kmem_cache_alloc(fasync_cache, SLAB_KERNEL);
+		new = kmem_cache_alloc(fasync_cache, GFP_KERNEL);
 		if (!new)
 			return -ENOMEM;
 	}
diff -puN fs/freevxfs/vxfs_inode.c~slab-remove-slab_kernel fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~slab-remove-slab_kernel
+++ a/fs/freevxfs/vxfs_inode.c
@@ -103,7 +103,7 @@ vxfs_blkiget(struct super_block *sbp, u_
 		struct vxfs_inode_info	*vip;
 		struct vxfs_dinode	*dip;
 
-		if (!(vip = kmem_cache_alloc(vxfs_inode_cachep, SLAB_KERNEL)))
+		if (!(vip = kmem_cache_alloc(vxfs_inode_cachep, GFP_KERNEL)))
 			goto fail;
 		dip = (struct vxfs_dinode *)(bp->b_data + offset);
 		memcpy(vip, dip, sizeof(*vip));
@@ -145,7 +145,7 @@ __vxfs_iget(ino_t ino, struct inode *ili
 		struct vxfs_dinode	*dip;
 		caddr_t			kaddr = (char *)page_address(pp);
 
-		if (!(vip = kmem_cache_alloc(vxfs_inode_cachep, SLAB_KERNEL)))
+		if (!(vip = kmem_cache_alloc(vxfs_inode_cachep, GFP_KERNEL)))
 			goto fail;
 		dip = (struct vxfs_dinode *)(kaddr + offset);
 		memcpy(vip, dip, sizeof(*vip));
diff -puN fs/fuse/dev.c~slab-remove-slab_kernel fs/fuse/dev.c
--- a/fs/fuse/dev.c~slab-remove-slab_kernel
+++ a/fs/fuse/dev.c
@@ -41,7 +41,7 @@ static void fuse_request_init(struct fus
 
 struct fuse_req *fuse_request_alloc(void)
 {
-	struct fuse_req *req = kmem_cache_alloc(fuse_req_cachep, SLAB_KERNEL);
+	struct fuse_req *req = kmem_cache_alloc(fuse_req_cachep, GFP_KERNEL);
 	if (req)
 		fuse_request_init(req);
 	return req;
diff -puN fs/fuse/inode.c~slab-remove-slab_kernel fs/fuse/inode.c
--- a/fs/fuse/inode.c~slab-remove-slab_kernel
+++ a/fs/fuse/inode.c
@@ -46,7 +46,7 @@ static struct inode *fuse_alloc_inode(st
 	struct inode *inode;
 	struct fuse_inode *fi;
 
-	inode = kmem_cache_alloc(fuse_inode_cachep, SLAB_KERNEL);
+	inode = kmem_cache_alloc(fuse_inode_cachep, GFP_KERNEL);
 	if (!inode)
 		return NULL;
 
diff -puN fs/hfs/super.c~slab-remove-slab_kernel fs/hfs/super.c
--- a/fs/hfs/super.c~slab-remove-slab_kernel
+++ a/fs/hfs/super.c
@@ -145,7 +145,7 @@ static struct inode *hfs_alloc_inode(str
 {
 	struct hfs_inode_info *i;
 
-	i = kmem_cache_alloc(hfs_inode_cachep, SLAB_KERNEL);
+	i = kmem_cache_alloc(hfs_inode_cachep, GFP_KERNEL);
 	return i ? &i->vfs_inode : NULL;
 }
 
diff -puN fs/hfsplus/super.c~slab-remove-slab_kernel fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~slab-remove-slab_kernel
+++ a/fs/hfsplus/super.c
@@ -440,7 +440,7 @@ static struct inode *hfsplus_alloc_inode
 {
 	struct hfsplus_inode_info *i;
 
-	i = kmem_cache_alloc(hfsplus_inode_cachep, SLAB_KERNEL);
+	i = kmem_cache_alloc(hfsplus_inode_cachep, GFP_KERNEL);
 	return i ? &i->vfs_inode : NULL;
 }
 
diff -puN fs/hugetlbfs/inode.c~slab-remove-slab_kernel fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~slab-remove-slab_kernel
+++ a/fs/hugetlbfs/inode.c
@@ -522,7 +522,7 @@ static struct inode *hugetlbfs_alloc_ino
 
 	if (unlikely(!hugetlbfs_dec_free_inodes(sbinfo)))
 		return NULL;
-	p = kmem_cache_alloc(hugetlbfs_inode_cachep, SLAB_KERNEL);
+	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
 	if (unlikely(!p)) {
 		hugetlbfs_inc_free_inodes(sbinfo);
 		return NULL;
diff -puN fs/inode.c~slab-remove-slab_kernel fs/inode.c
--- a/fs/inode.c~slab-remove-slab_kernel
+++ a/fs/inode.c
@@ -109,7 +109,7 @@ static struct inode *alloc_inode(struct 
 	if (sb->s_op->alloc_inode)
 		inode = sb->s_op->alloc_inode(sb);
 	else
-		inode = (struct inode *) kmem_cache_alloc(inode_cachep, SLAB_KERNEL);
+		inode = (struct inode *) kmem_cache_alloc(inode_cachep, GFP_KERNEL);
 
 	if (inode) {
 		struct address_space * const mapping = &inode->i_data;
diff -puN fs/isofs/inode.c~slab-remove-slab_kernel fs/isofs/inode.c
--- a/fs/isofs/inode.c~slab-remove-slab_kernel
+++ a/fs/isofs/inode.c
@@ -62,7 +62,7 @@ static kmem_cache_t *isofs_inode_cachep;
 static struct inode *isofs_alloc_inode(struct super_block *sb)
 {
 	struct iso_inode_info *ei;
-	ei = kmem_cache_alloc(isofs_inode_cachep, SLAB_KERNEL);
+	ei = kmem_cache_alloc(isofs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/jffs2/super.c~slab-remove-slab_kernel fs/jffs2/super.c
--- a/fs/jffs2/super.c~slab-remove-slab_kernel
+++ a/fs/jffs2/super.c
@@ -33,7 +33,7 @@ static kmem_cache_t *jffs2_inode_cachep;
 static struct inode *jffs2_alloc_inode(struct super_block *sb)
 {
 	struct jffs2_inode_info *ei;
-	ei = (struct jffs2_inode_info *)kmem_cache_alloc(jffs2_inode_cachep, SLAB_KERNEL);
+	ei = (struct jffs2_inode_info *)kmem_cache_alloc(jffs2_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/locks.c~slab-remove-slab_kernel fs/locks.c
--- a/fs/locks.c~slab-remove-slab_kernel
+++ a/fs/locks.c
@@ -147,7 +147,7 @@ static kmem_cache_t *filelock_cache __re
 /* Allocate an empty lock structure. */
 static struct file_lock *locks_alloc_lock(void)
 {
-	return kmem_cache_alloc(filelock_cache, SLAB_KERNEL);
+	return kmem_cache_alloc(filelock_cache, GFP_KERNEL);
 }
 
 static void locks_release_private(struct file_lock *fl)
diff -puN fs/minix/inode.c~slab-remove-slab_kernel fs/minix/inode.c
--- a/fs/minix/inode.c~slab-remove-slab_kernel
+++ a/fs/minix/inode.c
@@ -56,7 +56,7 @@ static kmem_cache_t * minix_inode_cachep
 static struct inode *minix_alloc_inode(struct super_block *sb)
 {
 	struct minix_inode_info *ei;
-	ei = (struct minix_inode_info *)kmem_cache_alloc(minix_inode_cachep, SLAB_KERNEL);
+	ei = (struct minix_inode_info *)kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/ncpfs/inode.c~slab-remove-slab_kernel fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~slab-remove-slab_kernel
+++ a/fs/ncpfs/inode.c
@@ -45,7 +45,7 @@ static kmem_cache_t * ncp_inode_cachep;
 static struct inode *ncp_alloc_inode(struct super_block *sb)
 {
 	struct ncp_inode_info *ei;
-	ei = (struct ncp_inode_info *)kmem_cache_alloc(ncp_inode_cachep, SLAB_KERNEL);
+	ei = (struct ncp_inode_info *)kmem_cache_alloc(ncp_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/nfs/direct.c~slab-remove-slab_kernel fs/nfs/direct.c
--- a/fs/nfs/direct.c~slab-remove-slab_kernel
+++ a/fs/nfs/direct.c
@@ -143,7 +143,7 @@ static inline struct nfs_direct_req *nfs
 {
 	struct nfs_direct_req *dreq;
 
-	dreq = kmem_cache_alloc(nfs_direct_cachep, SLAB_KERNEL);
+	dreq = kmem_cache_alloc(nfs_direct_cachep, GFP_KERNEL);
 	if (!dreq)
 		return NULL;
 
diff -puN fs/nfs/inode.c~slab-remove-slab_kernel fs/nfs/inode.c
--- a/fs/nfs/inode.c~slab-remove-slab_kernel
+++ a/fs/nfs/inode.c
@@ -1080,7 +1080,7 @@ void nfs4_clear_inode(struct inode *inod
 struct inode *nfs_alloc_inode(struct super_block *sb)
 {
 	struct nfs_inode *nfsi;
-	nfsi = (struct nfs_inode *)kmem_cache_alloc(nfs_inode_cachep, SLAB_KERNEL);
+	nfsi = (struct nfs_inode *)kmem_cache_alloc(nfs_inode_cachep, GFP_KERNEL);
 	if (!nfsi)
 		return NULL;
 	nfsi->flags = 0UL;
diff -puN fs/nfs/pagelist.c~slab-remove-slab_kernel fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~slab-remove-slab_kernel
+++ a/fs/nfs/pagelist.c
@@ -26,7 +26,7 @@ static inline struct nfs_page *
 nfs_page_alloc(void)
 {
 	struct nfs_page	*p;
-	p = kmem_cache_alloc(nfs_page_cachep, SLAB_KERNEL);
+	p = kmem_cache_alloc(nfs_page_cachep, GFP_KERNEL);
 	if (p) {
 		memset(p, 0, sizeof(*p));
 		INIT_LIST_HEAD(&p->wb_list);
diff -puN fs/openpromfs/inode.c~slab-remove-slab_kernel fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~slab-remove-slab_kernel
+++ a/fs/openpromfs/inode.c
@@ -336,7 +336,7 @@ static struct inode *openprom_alloc_inod
 {
 	struct op_inode_info *oi;
 
-	oi = kmem_cache_alloc(op_inode_cachep, SLAB_KERNEL);
+	oi = kmem_cache_alloc(op_inode_cachep, GFP_KERNEL);
 	if (!oi)
 		return NULL;
 
diff -puN fs/proc/inode.c~slab-remove-slab_kernel fs/proc/inode.c
--- a/fs/proc/inode.c~slab-remove-slab_kernel
+++ a/fs/proc/inode.c
@@ -88,7 +88,7 @@ static struct inode *proc_alloc_inode(st
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	ei = (struct proc_inode *)kmem_cache_alloc(proc_inode_cachep, SLAB_KERNEL);
+	ei = (struct proc_inode *)kmem_cache_alloc(proc_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	ei->pid = NULL;
diff -puN fs/qnx4/inode.c~slab-remove-slab_kernel fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~slab-remove-slab_kernel
+++ a/fs/qnx4/inode.c
@@ -520,7 +520,7 @@ static kmem_cache_t *qnx4_inode_cachep;
 static struct inode *qnx4_alloc_inode(struct super_block *sb)
 {
 	struct qnx4_inode_info *ei;
-	ei = kmem_cache_alloc(qnx4_inode_cachep, SLAB_KERNEL);
+	ei = kmem_cache_alloc(qnx4_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/reiserfs/super.c~slab-remove-slab_kernel fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~slab-remove-slab_kernel
+++ a/fs/reiserfs/super.c
@@ -496,7 +496,7 @@ static struct inode *reiserfs_alloc_inod
 {
 	struct reiserfs_inode_info *ei;
 	ei = (struct reiserfs_inode_info *)
-	    kmem_cache_alloc(reiserfs_inode_cachep, SLAB_KERNEL);
+	    kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/romfs/inode.c~slab-remove-slab_kernel fs/romfs/inode.c
--- a/fs/romfs/inode.c~slab-remove-slab_kernel
+++ a/fs/romfs/inode.c
@@ -555,7 +555,7 @@ static kmem_cache_t * romfs_inode_cachep
 static struct inode *romfs_alloc_inode(struct super_block *sb)
 {
 	struct romfs_inode_info *ei;
-	ei = (struct romfs_inode_info *)kmem_cache_alloc(romfs_inode_cachep, SLAB_KERNEL);
+	ei = (struct romfs_inode_info *)kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/smbfs/inode.c~slab-remove-slab_kernel fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~slab-remove-slab_kernel
+++ a/fs/smbfs/inode.c
@@ -55,7 +55,7 @@ static kmem_cache_t *smb_inode_cachep;
 static struct inode *smb_alloc_inode(struct super_block *sb)
 {
 	struct smb_inode_info *ei;
-	ei = (struct smb_inode_info *)kmem_cache_alloc(smb_inode_cachep, SLAB_KERNEL);
+	ei = (struct smb_inode_info *)kmem_cache_alloc(smb_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN fs/smbfs/request.c~slab-remove-slab_kernel fs/smbfs/request.c
--- a/fs/smbfs/request.c~slab-remove-slab_kernel
+++ a/fs/smbfs/request.c
@@ -61,7 +61,7 @@ static struct smb_request *smb_do_alloc_
 	struct smb_request *req;
 	unsigned char *buf = NULL;
 
-	req = kmem_cache_alloc(req_cachep, SLAB_KERNEL);
+	req = kmem_cache_alloc(req_cachep, GFP_KERNEL);
 	VERBOSE("allocating request: %p\n", req);
 	if (!req)
 		goto out;
diff -puN fs/sysv/inode.c~slab-remove-slab_kernel fs/sysv/inode.c
--- a/fs/sysv/inode.c~slab-remove-slab_kernel
+++ a/fs/sysv/inode.c
@@ -307,7 +307,7 @@ static struct inode *sysv_alloc_inode(st
 {
 	struct sysv_inode_info *si;
 
-	si = kmem_cache_alloc(sysv_inode_cachep, SLAB_KERNEL);
+	si = kmem_cache_alloc(sysv_inode_cachep, GFP_KERNEL);
 	if (!si)
 		return NULL;
 	return &si->vfs_inode;
diff -puN fs/udf/super.c~slab-remove-slab_kernel fs/udf/super.c
--- a/fs/udf/super.c~slab-remove-slab_kernel
+++ a/fs/udf/super.c
@@ -112,7 +112,7 @@ static kmem_cache_t * udf_inode_cachep;
 static struct inode *udf_alloc_inode(struct super_block *sb)
 {
 	struct udf_inode_info *ei;
-	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep, SLAB_KERNEL);
+	ei = (struct udf_inode_info *)kmem_cache_alloc(udf_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
diff -puN fs/ufs/super.c~slab-remove-slab_kernel fs/ufs/super.c
--- a/fs/ufs/super.c~slab-remove-slab_kernel
+++ a/fs/ufs/super.c
@@ -1209,7 +1209,7 @@ static kmem_cache_t * ufs_inode_cachep;
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
 	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, SLAB_KERNEL);
+	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
diff -puN include/linux/fs.h~slab-remove-slab_kernel include/linux/fs.h
--- a/include/linux/fs.h~slab-remove-slab_kernel
+++ a/include/linux/fs.h
@@ -1483,7 +1483,7 @@ extern void __init vfs_caches_init(unsig
 
 extern struct kmem_cache *names_cachep;
 
-#define __getname()	kmem_cache_alloc(names_cachep, SLAB_KERNEL)
+#define __getname()	kmem_cache_alloc(names_cachep, GFP_KERNEL)
 #define __putname(name) kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
 #define putname(name)   __putname(name)
diff -puN include/linux/rmap.h~slab-remove-slab_kernel include/linux/rmap.h
--- a/include/linux/rmap.h~slab-remove-slab_kernel
+++ a/include/linux/rmap.h
@@ -34,7 +34,7 @@ extern kmem_cache_t *anon_vma_cachep;
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
-	return kmem_cache_alloc(anon_vma_cachep, SLAB_KERNEL);
+	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 }
 
 static inline void anon_vma_free(struct anon_vma *anon_vma)
diff -puN include/linux/slab.h~slab-remove-slab_kernel include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_kernel
+++ a/include/linux/slab.h
@@ -19,7 +19,6 @@ typedef struct kmem_cache kmem_cache_t;
 #include	<asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 
 /* flags for kmem_cache_alloc() */
-#define	SLAB_KERNEL		GFP_KERNEL
 #define	SLAB_DMA		GFP_DMA
 
 /* flags to pass to kmem_cache_create().
diff -puN include/linux/taskstats_kern.h~slab-remove-slab_kernel include/linux/taskstats_kern.h
--- a/include/linux/taskstats_kern.h~slab-remove-slab_kernel
+++ a/include/linux/taskstats_kern.h
@@ -35,7 +35,7 @@ static inline void taskstats_tgid_alloc(
 		return;
 
 	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, SLAB_KERNEL);
+	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!sig->stats) {
diff -puN ipc/mqueue.c~slab-remove-slab_kernel ipc/mqueue.c
--- a/ipc/mqueue.c~slab-remove-slab_kernel
+++ a/ipc/mqueue.c
@@ -224,7 +224,7 @@ static struct inode *mqueue_alloc_inode(
 {
 	struct mqueue_inode_info *ei;
 
-	ei = kmem_cache_alloc(mqueue_inode_cachep, SLAB_KERNEL);
+	ei = kmem_cache_alloc(mqueue_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
diff -puN kernel/delayacct.c~slab-remove-slab_kernel kernel/delayacct.c
--- a/kernel/delayacct.c~slab-remove-slab_kernel
+++ a/kernel/delayacct.c
@@ -41,7 +41,7 @@ void delayacct_init(void)
 
 void __delayacct_tsk_init(struct task_struct *tsk)
 {
-	tsk->delays = kmem_cache_zalloc(delayacct_cache, SLAB_KERNEL);
+	tsk->delays = kmem_cache_zalloc(delayacct_cache, GFP_KERNEL);
 	if (tsk->delays)
 		spin_lock_init(&tsk->delays->lock);
 }
diff -puN kernel/fork.c~slab-remove-slab_kernel kernel/fork.c
--- a/kernel/fork.c~slab-remove-slab_kernel
+++ a/kernel/fork.c
@@ -237,7 +237,7 @@ static inline int dup_mmap(struct mm_str
 				goto fail_nomem;
 			charge = len;
 		}
-		tmp = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+		tmp = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (!tmp)
 			goto fail_nomem;
 		*tmp = *mpnt;
@@ -319,7 +319,7 @@ static inline void mm_free_pgd(struct mm
 
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
 
-#define allocate_mm()	(kmem_cache_alloc(mm_cachep, SLAB_KERNEL))
+#define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
 
 #include <linux/init_task.h>
@@ -621,7 +621,7 @@ static struct files_struct *alloc_files(
 	struct files_struct *newf;
 	struct fdtable *fdt;
 
-	newf = kmem_cache_alloc(files_cachep, SLAB_KERNEL);
+	newf = kmem_cache_alloc(files_cachep, GFP_KERNEL);
 	if (!newf)
 		goto out;
 
diff -puN kernel/taskstats.c~slab-remove-slab_kernel kernel/taskstats.c
--- a/kernel/taskstats.c~slab-remove-slab_kernel
+++ a/kernel/taskstats.c
@@ -425,7 +425,7 @@ void taskstats_exit_alloc(struct tasksta
 	*mycpu = raw_smp_processor_id();
 
 	*ptidstats = NULL;
-	tmp = kmem_cache_zalloc(taskstats_cache, SLAB_KERNEL);
+	tmp = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
 	if (!tmp)
 		return;
 
diff -puN kernel/user.c~slab-remove-slab_kernel kernel/user.c
--- a/kernel/user.c~slab-remove-slab_kernel
+++ a/kernel/user.c
@@ -132,7 +132,7 @@ struct user_struct * alloc_uid(uid_t uid
 	if (!up) {
 		struct user_struct *new;
 
-		new = kmem_cache_alloc(uid_cachep, SLAB_KERNEL);
+		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
 		if (!new)
 			return NULL;
 		new->uid = uid;
diff -puN mm/mempolicy.c~slab-remove-slab_kernel mm/mempolicy.c
--- a/mm/mempolicy.c~slab-remove-slab_kernel
+++ a/mm/mempolicy.c
@@ -1326,7 +1326,7 @@ struct mempolicy *__mpol_copy(struct mem
 	atomic_set(&new->refcnt, 1);
 	if (new->policy == MPOL_BIND) {
 		int sz = ksize(old->v.zonelist);
-		new->v.zonelist = kmemdup(old->v.zonelist, sz, SLAB_KERNEL);
+		new->v.zonelist = kmemdup(old->v.zonelist, sz, GFP_KERNEL);
 		if (!new->v.zonelist) {
 			kmem_cache_free(policy_cache, new);
 			return ERR_PTR(-ENOMEM);
diff -puN mm/mmap.c~slab-remove-slab_kernel mm/mmap.c
--- a/mm/mmap.c~slab-remove-slab_kernel
+++ a/mm/mmap.c
@@ -1736,7 +1736,7 @@ int split_vma(struct mm_struct * mm, str
 	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
-	new = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
@@ -2057,7 +2057,7 @@ struct vm_area_struct *copy_vma(struct v
 		    vma_start < new_vma->vm_end)
 			*vmap = new_vma;
 	} else {
-		new_vma = kmem_cache_alloc(vm_area_cachep, SLAB_KERNEL);
+		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
 			*new_vma = *vma;
 			pol = mpol_copy(vma_policy(vma));
diff -puN mm/shmem.c~slab-remove-slab_kernel mm/shmem.c
--- a/mm/shmem.c~slab-remove-slab_kernel
+++ a/mm/shmem.c
@@ -2263,7 +2263,7 @@ static struct kmem_cache *shmem_inode_ca
 static struct inode *shmem_alloc_inode(struct super_block *sb)
 {
 	struct shmem_inode_info *p;
-	p = (struct shmem_inode_info *)kmem_cache_alloc(shmem_inode_cachep, SLAB_KERNEL);
+	p = (struct shmem_inode_info *)kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
 	if (!p)
 		return NULL;
 	return &p->vfs_inode;
diff -puN mm/slab.c~slab-remove-slab_kernel mm/slab.c
--- a/mm/slab.c~slab-remove-slab_kernel
+++ a/mm/slab.c
@@ -2237,7 +2237,7 @@ kmem_cache_create (const char *name, siz
 	align = ralign;
 
 	/* Get cache's description obj. */
-	cachep = kmem_cache_zalloc(&cache_cache, SLAB_KERNEL);
+	cachep = kmem_cache_zalloc(&cache_cache, GFP_KERNEL);
 	if (!cachep)
 		goto oops;
 
diff -puN net/decnet/dn_table.c~slab-remove-slab_kernel net/decnet/dn_table.c
--- a/net/decnet/dn_table.c~slab-remove-slab_kernel
+++ a/net/decnet/dn_table.c
@@ -590,7 +590,7 @@ create:
 
 replace:
 	err = -ENOBUFS;
-	new_f = kmem_cache_alloc(dn_hash_kmem, SLAB_KERNEL);
+	new_f = kmem_cache_alloc(dn_hash_kmem, GFP_KERNEL);
 	if (new_f == NULL)
 		goto out;
 
diff -puN net/ipv4/fib_hash.c~slab-remove-slab_kernel net/ipv4/fib_hash.c
--- a/net/ipv4/fib_hash.c~slab-remove-slab_kernel
+++ a/net/ipv4/fib_hash.c
@@ -485,13 +485,13 @@ static int fn_hash_insert(struct fib_tab
 		goto out;
 
 	err = -ENOBUFS;
-	new_fa = kmem_cache_alloc(fn_alias_kmem, SLAB_KERNEL);
+	new_fa = kmem_cache_alloc(fn_alias_kmem, GFP_KERNEL);
 	if (new_fa == NULL)
 		goto out;
 
 	new_f = NULL;
 	if (!f) {
-		new_f = kmem_cache_alloc(fn_hash_kmem, SLAB_KERNEL);
+		new_f = kmem_cache_alloc(fn_hash_kmem, GFP_KERNEL);
 		if (new_f == NULL)
 			goto out_free_new_fa;
 
diff -puN net/ipv4/fib_trie.c~slab-remove-slab_kernel net/ipv4/fib_trie.c
--- a/net/ipv4/fib_trie.c~slab-remove-slab_kernel
+++ a/net/ipv4/fib_trie.c
@@ -1187,7 +1187,7 @@ static int fn_trie_insert(struct fib_tab
 			u8 state;
 
 			err = -ENOBUFS;
-			new_fa = kmem_cache_alloc(fn_alias_kmem, SLAB_KERNEL);
+			new_fa = kmem_cache_alloc(fn_alias_kmem, GFP_KERNEL);
 			if (new_fa == NULL)
 				goto out;
 
@@ -1232,7 +1232,7 @@ static int fn_trie_insert(struct fib_tab
 		goto out;
 
 	err = -ENOBUFS;
-	new_fa = kmem_cache_alloc(fn_alias_kmem, SLAB_KERNEL);
+	new_fa = kmem_cache_alloc(fn_alias_kmem, GFP_KERNEL);
 	if (new_fa == NULL)
 		goto out;
 
diff -puN net/socket.c~slab-remove-slab_kernel net/socket.c
--- a/net/socket.c~slab-remove-slab_kernel
+++ a/net/socket.c
@@ -236,7 +236,7 @@ static struct inode *sock_alloc_inode(st
 {
 	struct socket_alloc *ei;
 
-	ei = kmem_cache_alloc(sock_inode_cachep, SLAB_KERNEL);
+	ei = kmem_cache_alloc(sock_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	init_waitqueue_head(&ei->socket.wait);
diff -puN net/sunrpc/rpc_pipe.c~slab-remove-slab_kernel net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~slab-remove-slab_kernel
+++ a/net/sunrpc/rpc_pipe.c
@@ -143,7 +143,7 @@ static struct inode *
 rpc_alloc_inode(struct super_block *sb)
 {
 	struct rpc_inode *rpci;
-	rpci = (struct rpc_inode *)kmem_cache_alloc(rpc_inode_cachep, SLAB_KERNEL);
+	rpci = (struct rpc_inode *)kmem_cache_alloc(rpc_inode_cachep, GFP_KERNEL);
 	if (!rpci)
 		return NULL;
 	return &rpci->vfs_inode;
diff -puN security/keys/key.c~slab-remove-slab_kernel security/keys/key.c
--- a/security/keys/key.c~slab-remove-slab_kernel
+++ a/security/keys/key.c
@@ -285,7 +285,7 @@ struct key *key_alloc(struct key_type *t
 	}
 
 	/* allocate and initialise the key and its description */
-	key = kmem_cache_alloc(key_jar, SLAB_KERNEL);
+	key = kmem_cache_alloc(key_jar, GFP_KERNEL);
 	if (!key)
 		goto no_memory_2;
 
diff -puN security/selinux/hooks.c~slab-remove-slab_kernel security/selinux/hooks.c
--- a/security/selinux/hooks.c~slab-remove-slab_kernel
+++ a/security/selinux/hooks.c
@@ -181,7 +181,7 @@ static int inode_alloc_security(struct i
 	struct task_security_struct *tsec = current->security;
 	struct inode_security_struct *isec;
 
-	isec = kmem_cache_alloc(sel_inode_cache, SLAB_KERNEL);
+	isec = kmem_cache_alloc(sel_inode_cache, GFP_KERNEL);
 	if (!isec)
 		return -ENOMEM;
 
diff -puN security/selinux/ss/avtab.c~slab-remove-slab_kernel security/selinux/ss/avtab.c
--- a/security/selinux/ss/avtab.c~slab-remove-slab_kernel
+++ a/security/selinux/ss/avtab.c
@@ -36,7 +36,7 @@ avtab_insert_node(struct avtab *h, int h
 		  struct avtab_key *key, struct avtab_datum *datum)
 {
 	struct avtab_node * newnode;
-	newnode = kmem_cache_alloc(avtab_node_cachep, SLAB_KERNEL);
+	newnode = kmem_cache_alloc(avtab_node_cachep, GFP_KERNEL);
 	if (newnode == NULL)
 		return NULL;
 	memset(newnode, 0, sizeof(struct avtab_node));
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

