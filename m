From: akpm@linux-foundation.org
Subject: - ib-expand-ib_umem_get-prototype.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:41 -0700
Message-ID: <200804300543.m3U5hfPk029335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760795AbYD3GM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akepner@sgi.com, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com, michael@ellerm


The patch titled
     IB: expand ib_umem_get() prototype
has been removed from the -mm tree.  Its filename was
     ib-expand-ib_umem_get-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IB: expand ib_umem_get() prototype
From: Arthur Kepner <akepner@sgi.com>

Add a new parameter, dmasync, to the ib_umem_get() prototype.  Use dmasync = 1
when mapping user-allocated CQs with ib_umem_get().

Signed-off-by: Arthur Kepner <akepner@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c               |   17 ++++++--
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 -
 drivers/infiniband/hw/ehca/ehca_mrmw.c       |    2 -
 drivers/infiniband/hw/ipath/ipath_mr.c       |    3 +
 drivers/infiniband/hw/mlx4/cq.c              |    2 -
 drivers/infiniband/hw/mlx4/doorbell.c        |    2 -
 drivers/infiniband/hw/mlx4/mr.c              |    3 +
 drivers/infiniband/hw/mlx4/qp.c              |    2 -
 drivers/infiniband/hw/mlx4/srq.c             |    2 -
 drivers/infiniband/hw/mthca/mthca_provider.c |    8 +++-
 drivers/infiniband/hw/mthca/mthca_user.h     |   10 ++++-
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 -
 include/rdma/ib_umem.h                       |    4 +-
 include/rdma/ib_verbs.h                      |   33 +++++++++++++++++
 15 files changed, 75 insertions(+), 19 deletions(-)

diff -puN drivers/infiniband/core/umem.c~ib-expand-ib_umem_get-prototype drivers/infiniband/core/umem.c
--- a/drivers/infiniband/core/umem.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/core/umem.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
+#include <linux/dma-attrs.h>
 
 #include "uverbs.h"
 
@@ -72,9 +73,10 @@ static void __ib_umem_release(struct ib_
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
+ * @dmasync: flush in-flight DMA when the memory region is written
  */
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access)
+			    size_t size, int access, int dmasync)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -87,6 +89,10 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	int ret;
 	int off;
 	int i;
+	DEFINE_DMA_ATTRS(attrs);
+
+	if (dmasync)
+		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
 
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
@@ -174,10 +180,11 @@ struct ib_umem *ib_umem_get(struct ib_uc
 				sg_set_page(&chunk->page_list[i], page_list[i + off], PAGE_SIZE, 0);
 			}
 
-			chunk->nmap = ib_dma_map_sg(context->device,
-						    &chunk->page_list[0],
-						    chunk->nents,
-						    DMA_BIDIRECTIONAL);
+			chunk->nmap = ib_dma_map_sg_attrs(context->device,
+							  &chunk->page_list[0],
+							  chunk->nents,
+							  DMA_BIDIRECTIONAL,
+							  &attrs);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
 					put_page(sg_page(&chunk->page_list[i]));
diff -puN drivers/infiniband/hw/amso1100/c2_provider.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/amso1100/c2_provider.c
--- a/drivers/infiniband/hw/amso1100/c2_provider.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -452,7 +452,7 @@ static struct ib_mr *c2_reg_user_mr(stru
 		return ERR_PTR(-ENOMEM);
 	c2mr->pd = c2pd;
 
-	c2mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	c2mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
 	if (IS_ERR(c2mr->umem)) {
 		err = PTR_ERR(c2mr->umem);
 		kfree(c2mr);
diff -puN drivers/infiniband/hw/cxgb3/iwch_provider.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/cxgb3/iwch_provider.c
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -602,7 +602,7 @@ static struct ib_mr *iwch_reg_user_mr(st
 	if (!mhp)
 		return ERR_PTR(-ENOMEM);
 
-	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	mhp->umem = ib_umem_get(pd->uobject->context, start, length, acc, 0);
 	if (IS_ERR(mhp->umem)) {
 		err = PTR_ERR(mhp->umem);
 		kfree(mhp);
diff -puN drivers/infiniband/hw/ehca/ehca_mrmw.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/ehca/ehca_mrmw.c
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -323,7 +323,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib
 	}
 
 	e_mr->umem = ib_umem_get(pd->uobject->context, start, length,
-				 mr_access_flags);
+				 mr_access_flags, 0);
 	if (IS_ERR(e_mr->umem)) {
 		ib_mr = (void *)e_mr->umem;
 		goto reg_user_mr_exit1;
diff -puN drivers/infiniband/hw/ipath/ipath_mr.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/ipath/ipath_mr.c
--- a/drivers/infiniband/hw/ipath/ipath_mr.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -195,7 +195,8 @@ struct ib_mr *ipath_reg_user_mr(struct i
 		goto bail;
 	}
 
-	umem = ib_umem_get(pd->uobject->context, start, length, mr_access_flags);
+	umem = ib_umem_get(pd->uobject->context, start, length,
+			   mr_access_flags, 0);
 	if (IS_ERR(umem))
 		return (void *) umem;
 
diff -puN drivers/infiniband/hw/mlx4/cq.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mlx4/cq.c
--- a/drivers/infiniband/hw/mlx4/cq.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mlx4/cq.c
@@ -137,7 +137,7 @@ static int mlx4_ib_get_cq_umem(struct ml
 	int err;
 
 	*umem = ib_umem_get(context, buf_addr, cqe * sizeof (struct mlx4_cqe),
-			    IB_ACCESS_LOCAL_WRITE);
+			    IB_ACCESS_LOCAL_WRITE, 1);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
 
diff -puN drivers/infiniband/hw/mlx4/doorbell.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mlx4/doorbell.c
--- a/drivers/infiniband/hw/mlx4/doorbell.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mlx4/doorbell.c
@@ -63,7 +63,7 @@ int mlx4_ib_db_map_user(struct mlx4_ib_u
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
 	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0);
+				      PAGE_SIZE, 0, 0);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff -puN drivers/infiniband/hw/mlx4/mr.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mlx4/mr.c
--- a/drivers/infiniband/hw/mlx4/mr.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mlx4/mr.c
@@ -132,7 +132,8 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, access_flags);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length,
+			       access_flags, 0);
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err_free;
diff -puN drivers/infiniband/hw/mlx4/qp.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mlx4/qp.c
--- a/drivers/infiniband/hw/mlx4/qp.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mlx4/qp.c
@@ -482,7 +482,7 @@ static int create_qp_common(struct mlx4_
 			goto err;
 
 		qp->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-				       qp->buf_size, 0);
+				       qp->buf_size, 0, 0);
 		if (IS_ERR(qp->umem)) {
 			err = PTR_ERR(qp->umem);
 			goto err;
diff -puN drivers/infiniband/hw/mlx4/srq.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mlx4/srq.c
--- a/drivers/infiniband/hw/mlx4/srq.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mlx4/srq.c
@@ -109,7 +109,7 @@ struct ib_srq *mlx4_ib_create_srq(struct
 		}
 
 		srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr,
-					buf_size, 0);
+					buf_size, 0, 0);
 		if (IS_ERR(srq->umem)) {
 			err = PTR_ERR(srq->umem);
 			goto err_srq;
diff -puN drivers/infiniband/hw/mthca/mthca_provider.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mthca/mthca_provider.c
--- a/drivers/infiniband/hw/mthca/mthca_provider.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1006,17 +1006,23 @@ static struct ib_mr *mthca_reg_user_mr(s
 	struct mthca_dev *dev = to_mdev(pd->device);
 	struct ib_umem_chunk *chunk;
 	struct mthca_mr *mr;
+	struct mthca_reg_mr ucmd;
 	u64 *pages;
 	int shift, n, len;
 	int i, j, k;
 	int err = 0;
 	int write_mtt_size;
 
+	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
+		return ERR_PTR(-EFAULT);
+
 	mr = kmalloc(sizeof *mr, GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
+	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc,
+			       ucmd.mr_attrs & MTHCA_MR_DMASYNC);
+
 	if (IS_ERR(mr->umem)) {
 		err = PTR_ERR(mr->umem);
 		goto err;
diff -puN drivers/infiniband/hw/mthca/mthca_user.h~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/mthca/mthca_user.h
--- a/drivers/infiniband/hw/mthca/mthca_user.h~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/mthca/mthca_user.h
@@ -41,7 +41,7 @@
  * Increment this value if any changes that break userspace ABI
  * compatibility are made.
  */
-#define MTHCA_UVERBS_ABI_VERSION	1
+#define MTHCA_UVERBS_ABI_VERSION	2
 
 /*
  * Make sure that all structs defined in this file remain laid out so
@@ -61,6 +61,14 @@ struct mthca_alloc_pd_resp {
 	__u32 reserved;
 };
 
+struct mthca_reg_mr {
+	__u32 mr_attrs;
+#define MTHCA_MR_DMASYNC 0x1
+/* mark the memory region with a DMA attribute that causes
+ * in-flight DMA to be flushed when the region is written to */
+	__u32 reserved;
+};
+
 struct mthca_create_cq {
 	__u32 lkey;
 	__u32 pdn;
diff -puN drivers/infiniband/hw/nes/nes_verbs.c~ib-expand-ib_umem_get-prototype drivers/infiniband/hw/nes/nes_verbs.c
--- a/drivers/infiniband/hw/nes/nes_verbs.c~ib-expand-ib_umem_get-prototype
+++ a/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2377,7 +2377,7 @@ static struct ib_mr *nes_reg_user_mr(str
 	u8 single_page = 1;
 	u8 stag_key;
 
-	region = ib_umem_get(pd->uobject->context, start, length, acc);
+	region = ib_umem_get(pd->uobject->context, start, length, acc, 0);
 	if (IS_ERR(region)) {
 		return (struct ib_mr *)region;
 	}
diff -puN include/rdma/ib_umem.h~ib-expand-ib_umem_get-prototype include/rdma/ib_umem.h
--- a/include/rdma/ib_umem.h~ib-expand-ib_umem_get-prototype
+++ a/include/rdma/ib_umem.h
@@ -62,7 +62,7 @@ struct ib_umem_chunk {
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access);
+			    size_t size, int access, int dmasync);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
@@ -72,7 +72,7 @@ int ib_umem_page_count(struct ib_umem *u
 
 static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  unsigned long addr, size_t size,
-					  int access) {
+					  int access, int dmasync) {
 	return ERR_PTR(-EINVAL);
 }
 static inline void ib_umem_release(struct ib_umem *umem) { }
diff -puN include/rdma/ib_verbs.h~ib-expand-ib_umem_get-prototype include/rdma/ib_verbs.h
--- a/include/rdma/ib_verbs.h~ib-expand-ib_umem_get-prototype
+++ a/include/rdma/ib_verbs.h
@@ -1542,6 +1542,24 @@ static inline void ib_dma_unmap_single(s
 		dma_unmap_single(dev->dma_device, addr, size, direction);
 }
 
+static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
+					  void *cpu_addr, size_t size,
+					  enum dma_data_direction direction,
+					  struct dma_attrs *attrs)
+{
+	return dma_map_single_attrs(dev->dma_device, cpu_addr, size,
+				    direction, attrs);
+}
+
+static inline void ib_dma_unmap_single_attrs(struct ib_device *dev,
+					     u64 addr, size_t size,
+					     enum dma_data_direction direction,
+					     struct dma_attrs *attrs)
+{
+	return dma_unmap_single_attrs(dev->dma_device, addr, size,
+				      direction, attrs);
+}
+
 /**
  * ib_dma_map_page - Map a physical page to DMA address
  * @dev: The device for which the dma_addr is to be created
@@ -1611,6 +1629,21 @@ static inline void ib_dma_unmap_sg(struc
 		dma_unmap_sg(dev->dma_device, sg, nents, direction);
 }
 
+static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
+				      struct scatterlist *sg, int nents,
+				      enum dma_data_direction direction,
+				      struct dma_attrs *attrs)
+{
+	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+}
+
+static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
+					 struct scatterlist *sg, int nents,
+					 enum dma_data_direction direction,
+					 struct dma_attrs *attrs)
+{
+	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+}
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
  * @dev: The device for which the DMA addresses were created
_

Patches currently in -mm which might be from akepner@sgi.com are

origin.patch

