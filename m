From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Fri, 10 Apr 2020 11:19:15 -0700
Message-ID: <20200410181915.KP6TsiHq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgDJSTR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/9p.rst |    4 ----
 drivers/block/rbd.c              |    9 ---------
 drivers/vdpa/Kconfig             |    6 ------
 drivers/vdpa/ifcvf/ifcvf_base.c  |    8 --------
 drivers/vdpa/ifcvf/ifcvf_main.c  |    8 --------
 drivers/vdpa/vdpa_sim/vdpa_sim.c |    4 ----
 drivers/vhost/Kconfig            |    7 -------
 drivers/vhost/vdpa.c             |   14 --------------
 drivers/vhost/vhost.h            |    7 -------
 drivers/vhost/vringh.c           |   12 ------------
 include/linux/vringh.h           |   11 -----------
 tools/virtio/Makefile            |    4 ----
 12 files changed, 94 deletions(-)

--- a/Documentation/filesystems/9p.rst~linux-next-git-rejects
+++ a/Documentation/filesystems/9p.rst
@@ -158,13 +158,9 @@ Options
 		/sys/fs/9p/caches. (applies only to cache=fscache)
   ============= ===============================================================
 
-<<<<<<< HEAD
-Behavior
-========
 =======
 Behaviour
 =========
->>>>>>> linux-next/akpm-base
 
 This section aims at describing 9p 'quirks' that can be different
 from a local filesystem behaviors.
--- a/drivers/block/rbd.c~linux-next-git-rejects
+++ a/drivers/block/rbd.c
@@ -1626,21 +1626,12 @@ static void rbd_img_capture_header(struc
 	struct rbd_device *rbd_dev = img_req->rbd_dev;
 
 	lockdep_assert_held(&rbd_dev->header_rwsem);
-<<<<<<< HEAD
 
 	if (rbd_img_is_write(img_req))
 		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
 	else
 		img_req->snap_id = rbd_dev->spec->snap_id;
 
-=======
-
-	if (rbd_img_is_write(img_req))
-		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
-	else
-		img_req->snap_id = rbd_dev->spec->snap_id;
-
->>>>>>> linux-next/akpm-base
 	if (rbd_dev_parent_get(rbd_dev))
 		img_request_layered_set(img_req);
 }
--- a/drivers/vdpa/ifcvf/ifcvf_base.c~linux-next-git-rejects
+++ a/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -301,18 +301,10 @@ int ifcvf_set_vq_state(struct ifcvf_hw *
 
 static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 {
-<<<<<<< HEAD
-	struct ifcvf_lm_cfg __iomem *ifcvf_lm;
-=======
->>>>>>> linux-next/akpm-base
 	struct virtio_pci_common_cfg __iomem *cfg;
 	struct ifcvf_adapter *ifcvf;
 	u32 i;
 
-<<<<<<< HEAD
-	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
-=======
->>>>>>> linux-next/akpm-base
 	ifcvf = vf_to_adapter(hw);
 	cfg = hw->common_cfg;
 	ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
--- a/drivers/vdpa/ifcvf/ifcvf_main.c~linux-next-git-rejects
+++ a/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -31,17 +31,9 @@ static irqreturn_t ifcvf_intr_handler(in
 static int ifcvf_start_datapath(void *private)
 {
 	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
-<<<<<<< HEAD
-	struct ifcvf_adapter *ifcvf;
 	u8 status;
 	int ret;
 
-	ifcvf = vf_to_adapter(vf);
-=======
-	u8 status;
-	int ret;
-
->>>>>>> linux-next/akpm-base
 	vf->nr_vring = IFCVF_MAX_QUEUE_PAIRS * 2;
 	ret = ifcvf_start_hw(vf);
 	if (ret < 0) {
--- a/drivers/vdpa/Kconfig~linux-next-git-rejects
+++ a/drivers/vdpa/Kconfig
@@ -14,16 +14,10 @@ if VDPA_MENU
 
 config VDPA_SIM
 	tristate "vDPA device simulator"
-<<<<<<< HEAD
-	depends on RUNTIME_TESTING_MENU
-	select VDPA
-	select VHOST_RING
-=======
 	depends on RUNTIME_TESTING_MENU && HAS_DMA
 	select VDPA
 	select VHOST_RING
 	select VHOST_IOTLB
->>>>>>> linux-next/akpm-base
 	default n
 	help
 	  vDPA networking device simulator which loop TX traffic back
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c~linux-next-git-rejects
+++ a/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -488,11 +488,7 @@ static u8 vdpasim_get_status(struct vdpa
 	status = vdpasim->status;
 	spin_unlock(&vdpasim->lock);
 
-<<<<<<< HEAD
-	return vdpasim->status;
-=======
 	return status;
->>>>>>> linux-next/akpm-base
 }
 
 static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
--- a/drivers/vhost/Kconfig~linux-next-git-rejects
+++ a/drivers/vhost/Kconfig
@@ -3,18 +3,11 @@ config VHOST_IOTLB
 	tristate
 	help
 	  Generic IOTLB implementation for vhost and vringh.
-<<<<<<< HEAD
-
-config VHOST_RING
-	tristate
-	select VHOST_IOTLB
-=======
 	  This option is selected by any driver which needs to support
 	  an IOMMU in software.
 
 config VHOST_RING
 	tristate
->>>>>>> linux-next/akpm-base
 	help
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
--- a/drivers/vhost/vdpa.c~linux-next-git-rejects
+++ a/drivers/vhost/vdpa.c
@@ -296,10 +296,6 @@ static long vhost_vdpa_vring_ioctl(struc
 	struct vdpa_callback cb;
 	struct vhost_virtqueue *vq;
 	struct vhost_vring_state s;
-<<<<<<< HEAD
-	u8 status;
-=======
->>>>>>> linux-next/akpm-base
 	u32 idx;
 	long r;
 
@@ -313,11 +309,6 @@ static long vhost_vdpa_vring_ioctl(struc
 	idx = array_index_nospec(idx, v->nvqs);
 	vq = &v->vqs[idx];
 
-<<<<<<< HEAD
-	status = ops->get_status(vdpa);
-
-=======
->>>>>>> linux-next/akpm-base
 	if (cmd == VHOST_VDPA_SET_VRING_ENABLE) {
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
@@ -684,11 +675,6 @@ static int vhost_vdpa_open(struct inode
 	int nvqs, i, r, opened;
 
 	v = container_of(inode->i_cdev, struct vhost_vdpa, cdev);
-<<<<<<< HEAD
-	if (!v)
-		return -ENODEV;
-=======
->>>>>>> linux-next/akpm-base
 
 	opened = atomic_cmpxchg(&v->opened, 0, 1);
 	if (opened)
--- a/drivers/vhost/vhost.h~linux-next-git-rejects
+++ a/drivers/vhost/vhost.h
@@ -74,12 +74,6 @@ struct vhost_virtqueue {
 	/* The actual ring of buffers. */
 	struct mutex mutex;
 	unsigned int num;
-<<<<<<< HEAD
-	struct vring_desc __user *desc;
-	struct vring_avail __user *avail;
-	struct vring_used __user *used;
-	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
-=======
 	vring_desc_t __user *desc;
 	vring_avail_t __user *avail;
 	vring_used_t __user *used;
@@ -90,7 +84,6 @@ struct vhost_virtqueue {
 	int first_desc;
 	int max_descs;
 
->>>>>>> linux-next/akpm-base
 	struct file *kick;
 	struct eventfd_ctx *call_ctx;
 	struct eventfd_ctx *error_ctx;
--- a/drivers/vhost/vringh.c~linux-next-git-rejects
+++ a/drivers/vhost/vringh.c
@@ -13,17 +13,11 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/export.h>
-<<<<<<< HEAD
-#include <linux/bvec.h>
-#include <linux/highmem.h>
-#include <linux/vhost_iotlb.h>
-=======
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 #include <linux/bvec.h>
 #include <linux/highmem.h>
 #include <linux/vhost_iotlb.h>
 #endif
->>>>>>> linux-next/akpm-base
 #include <uapi/linux/virtio_config.h>
 
 static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
@@ -1067,11 +1061,8 @@ int vringh_need_notify_kern(struct vring
 }
 EXPORT_SYMBOL(vringh_need_notify_kern);
 
-<<<<<<< HEAD
-=======
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 
->>>>>>> linux-next/akpm-base
 static int iotlb_translate(const struct vringh *vrh,
 			   u64 addr, u64 len, struct bio_vec iov[],
 			   int iov_size, u32 perm)
@@ -1429,9 +1420,6 @@ int vringh_need_notify_iotlb(struct vrin
 }
 EXPORT_SYMBOL(vringh_need_notify_iotlb);
 
-<<<<<<< HEAD
-=======
 #endif
->>>>>>> linux-next/akpm-base
 
 MODULE_LICENSE("GPL");
--- a/include/linux/vringh.h~linux-next-git-rejects
+++ a/include/linux/vringh.h
@@ -15,15 +15,10 @@
 #include <linux/virtio_byteorder.h>
 #include <linux/uio.h>
 #include <linux/slab.h>
-<<<<<<< HEAD
-#include <linux/dma-direction.h>
-#include <linux/vhost_iotlb.h>
-=======
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 #include <linux/dma-direction.h>
 #include <linux/vhost_iotlb.h>
 #endif
->>>>>>> linux-next/akpm-base
 #include <asm/barrier.h>
 
 /* virtio_ring with information needed for host access. */
@@ -262,11 +257,8 @@ static inline __virtio64 cpu_to_vringh64
 	return __cpu_to_virtio64(vringh_is_little_endian(vrh), val);
 }
 
-<<<<<<< HEAD
-=======
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 
->>>>>>> linux-next/akpm-base
 void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb);
 
 int vringh_init_iotlb(struct vringh *vrh, u64 features,
@@ -297,9 +289,6 @@ void vringh_notify_disable_iotlb(struct
 
 int vringh_need_notify_iotlb(struct vringh *vrh);
 
-<<<<<<< HEAD
-=======
 #endif /* CONFIG_VHOST_IOTLB */
 
->>>>>>> linux-next/akpm-base
 #endif /* _LINUX_VRINGH_H */
--- a/tools/virtio/Makefile~linux-next-git-rejects
+++ a/tools/virtio/Makefile
@@ -22,12 +22,8 @@ OOT_CONFIGS=\
 	CONFIG_VHOST=m \
 	CONFIG_VHOST_NET=n \
 	CONFIG_VHOST_SCSI=n \
-<<<<<<< HEAD
-	CONFIG_VHOST_VSOCK=n
-=======
 	CONFIG_VHOST_VSOCK=n \
 	CONFIG_VHOST_RING=n
->>>>>>> linux-next/akpm-base
 OOT_BUILD=KCFLAGS="-I "${OOT_VHOST} ${MAKE} -C ${OOT_KSRC} V=${V}
 oot-build:
 	echo "UNSUPPORTED! Don't use the resulting modules in production!"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-update-checkpatch-fixes.patch
mm-cma-numa-node-interface-fix.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
