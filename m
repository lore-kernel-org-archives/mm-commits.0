From: akpm@linux-foundation.org
Subject: - infiniband-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:06 -0700
Message-ID: <200803172100.m2HL06aQ030832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbYCQVAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     infiniband: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     infiniband-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: infiniband: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/amso1100/c2_ae.c       |    8 
 drivers/infiniband/hw/amso1100/c2_alloc.c    |    2 
 drivers/infiniband/hw/amso1100/c2_provider.c |   82 ++++----
 drivers/infiniband/hw/amso1100/c2_qp.c       |    8 
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    4 
 drivers/infiniband/hw/amso1100/c2_vq.c       |    2 
 drivers/infiniband/hw/cxgb3/cxio_dbg.c       |   24 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c       |   84 ++++----
 drivers/infiniband/hw/cxgb3/cxio_resource.c  |   12 -
 drivers/infiniband/hw/cxgb3/iwch.c           |    6 
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |  166 ++++++++---------
 drivers/infiniband/hw/cxgb3/iwch_cm.h        |    4 
 drivers/infiniband/hw/cxgb3/iwch_cq.c        |    4 
 drivers/infiniband/hw/cxgb3/iwch_ev.c        |   12 -
 drivers/infiniband/hw/cxgb3/iwch_mem.c       |    6 
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   76 +++----
 drivers/infiniband/hw/cxgb3/iwch_provider.h  |    4 
 drivers/infiniband/hw/cxgb3/iwch_qp.c        |   38 +--
 drivers/infiniband/hw/ehca/ehca_tools.h      |   16 -
 drivers/infiniband/hw/nes/nes.c              |    2 
 drivers/infiniband/hw/nes/nes.h              |    6 
 drivers/infiniband/hw/nes/nes_cm.c           |   16 -
 drivers/infiniband/hw/nes/nes_hw.c           |   14 -
 drivers/infiniband/hw/nes/nes_nic.c          |    2 
 drivers/infiniband/hw/nes/nes_utils.c        |    2 
 drivers/infiniband/hw/nes/nes_verbs.c        |    4 
 26 files changed, 302 insertions(+), 302 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/c2_ae.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/amso1100/c2_ae.c
--- a/drivers/infiniband/hw/amso1100/c2_ae.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/amso1100/c2_ae.c
@@ -61,7 +61,7 @@ static int c2_convert_cm_status(u32 c2_s
 	default:
 		printk(KERN_ERR PFX
 		       "%s - Unable to convert CM status: %d\n",
-		       __FUNCTION__, c2_status);
+		       __func__, c2_status);
 		return -EIO;
 	}
 }
@@ -193,7 +193,7 @@ void c2_ae_event(struct c2_dev *c2dev, u
 		pr_debug("%s: event = %s, user_context=%llx, "
 			"resource_type=%x, "
 			"resource=%x, qp_state=%s\n",
-			__FUNCTION__,
+			__func__,
 			to_event_str(event_id),
 			(unsigned long long) be64_to_cpu(wr->ae.ae_generic.user_context),
 			be32_to_cpu(wr->ae.ae_generic.resource_type),
@@ -259,7 +259,7 @@ void c2_ae_event(struct c2_dev *c2dev, u
 			BUG_ON(1);
 			pr_debug("%s:%d Unexpected event_id=%d on QP=%p, "
 				"CM_ID=%p\n",
-				__FUNCTION__, __LINE__,
+				__func__, __LINE__,
 				event_id, qp, cm_id);
 			break;
 		}
@@ -276,7 +276,7 @@ void c2_ae_event(struct c2_dev *c2dev, u
 		pr_debug("C2_RES_IND_EP event_id=%d\n", event_id);
 		if (event_id != CCAE_CONNECTION_REQUEST) {
 			pr_debug("%s: Invalid event_id: %d\n",
-				__FUNCTION__, event_id);
+				__func__, event_id);
 			break;
 		}
 		cm_event.event = IW_CM_EVENT_CONNECT_REQUEST;
diff -puN drivers/infiniband/hw/amso1100/c2_alloc.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/amso1100/c2_alloc.c
--- a/drivers/infiniband/hw/amso1100/c2_alloc.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/amso1100/c2_alloc.c
@@ -113,7 +113,7 @@ u16 *c2_alloc_mqsp(struct c2_dev *c2dev,
 		*dma_addr = head->dma_addr +
 			    ((unsigned long) &(head->shared_ptr[mqsp]) -
 			     (unsigned long) head);
-		pr_debug("%s addr %p dma_addr %llx\n", __FUNCTION__,
+		pr_debug("%s addr %p dma_addr %llx\n", __func__,
 			 &(head->shared_ptr[mqsp]), (unsigned long long) *dma_addr);
 		return &(head->shared_ptr[mqsp]);
 	}
diff -puN drivers/infiniband/hw/amso1100/c2_provider.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/amso1100/c2_provider.c
--- a/drivers/infiniband/hw/amso1100/c2_provider.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -67,7 +67,7 @@ static int c2_query_device(struct ib_dev
 {
 	struct c2_dev *c2dev = to_c2dev(ibdev);
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	*props = c2dev->props;
 	return 0;
@@ -76,7 +76,7 @@ static int c2_query_device(struct ib_dev
 static int c2_query_port(struct ib_device *ibdev,
 			 u8 port, struct ib_port_attr *props)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	props->max_mtu = IB_MTU_4096;
 	props->lid = 0;
@@ -102,14 +102,14 @@ static int c2_modify_port(struct ib_devi
 			  u8 port, int port_modify_mask,
 			  struct ib_port_modify *props)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return 0;
 }
 
 static int c2_query_pkey(struct ib_device *ibdev,
 			 u8 port, u16 index, u16 * pkey)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	*pkey = 0;
 	return 0;
 }
@@ -119,7 +119,7 @@ static int c2_query_gid(struct ib_device
 {
 	struct c2_dev *c2dev = to_c2dev(ibdev);
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	memset(&(gid->raw[0]), 0, sizeof(gid->raw));
 	memcpy(&(gid->raw[0]), c2dev->pseudo_netdev->dev_addr, 6);
 
@@ -134,7 +134,7 @@ static struct ib_ucontext *c2_alloc_ucon
 {
 	struct c2_ucontext *context;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	context = kmalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return ERR_PTR(-ENOMEM);
@@ -144,14 +144,14 @@ static struct ib_ucontext *c2_alloc_ucon
 
 static int c2_dealloc_ucontext(struct ib_ucontext *context)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	kfree(context);
 	return 0;
 }
 
 static int c2_mmap_uar(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
 }
 
@@ -162,7 +162,7 @@ static struct ib_pd *c2_alloc_pd(struct 
 	struct c2_pd *pd;
 	int err;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd)
@@ -187,7 +187,7 @@ static struct ib_pd *c2_alloc_pd(struct 
 
 static int c2_dealloc_pd(struct ib_pd *pd)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	c2_pd_free(to_c2dev(pd->device), to_c2pd(pd));
 	kfree(pd);
 
@@ -196,13 +196,13 @@ static int c2_dealloc_pd(struct ib_pd *p
 
 static struct ib_ah *c2_ah_create(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return ERR_PTR(-ENOSYS);
 }
 
 static int c2_ah_destroy(struct ib_ah *ah)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
 }
 
@@ -230,7 +230,7 @@ struct ib_qp *c2_get_qp(struct ib_device
 
 	qp = c2_find_qpn(c2dev, qpn);
 	pr_debug("%s Returning QP=%p for QPN=%d, device=%p, refcount=%d\n",
-		__FUNCTION__, qp, qpn, device,
+		__func__, qp, qpn, device,
 		(qp?atomic_read(&qp->refcount):0));
 
 	return (qp?&qp->ibqp:NULL);
@@ -243,13 +243,13 @@ static struct ib_qp *c2_create_qp(struct
 	struct c2_qp *qp;
 	int err;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	switch (init_attr->qp_type) {
 	case IB_QPT_RC:
 		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 		if (!qp) {
-			pr_debug("%s: Unable to allocate QP\n", __FUNCTION__);
+			pr_debug("%s: Unable to allocate QP\n", __func__);
 			return ERR_PTR(-ENOMEM);
 		}
 		spin_lock_init(&qp->lock);
@@ -266,7 +266,7 @@ static struct ib_qp *c2_create_qp(struct
 
 		break;
 	default:
-		pr_debug("%s: Invalid QP type: %d\n", __FUNCTION__,
+		pr_debug("%s: Invalid QP type: %d\n", __func__,
 			init_attr->qp_type);
 		return ERR_PTR(-EINVAL);
 		break;
@@ -285,7 +285,7 @@ static int c2_destroy_qp(struct ib_qp *i
 	struct c2_qp *qp = to_c2qp(ib_qp);
 
 	pr_debug("%s:%u qp=%p,qp->state=%d\n",
-		__FUNCTION__, __LINE__,ib_qp,qp->state);
+		__func__, __LINE__,ib_qp,qp->state);
 	c2_free_qp(to_c2dev(ib_qp->device), qp);
 	kfree(qp);
 	return 0;
@@ -300,13 +300,13 @@ static struct ib_cq *c2_create_cq(struct
 
 	cq = kmalloc(sizeof(*cq), GFP_KERNEL);
 	if (!cq) {
-		pr_debug("%s: Unable to allocate CQ\n", __FUNCTION__);
+		pr_debug("%s: Unable to allocate CQ\n", __func__);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	err = c2_init_cq(to_c2dev(ibdev), entries, NULL, cq);
 	if (err) {
-		pr_debug("%s: error initializing CQ\n", __FUNCTION__);
+		pr_debug("%s: error initializing CQ\n", __func__);
 		kfree(cq);
 		return ERR_PTR(err);
 	}
@@ -318,7 +318,7 @@ static int c2_destroy_cq(struct ib_cq *i
 {
 	struct c2_cq *cq = to_c2cq(ib_cq);
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	c2_free_cq(to_c2dev(ib_cq->device), cq);
 	kfree(cq);
@@ -400,7 +400,7 @@ static struct ib_mr *c2_reg_phys_mr(stru
 	mr->umem = NULL;
 	pr_debug("%s - page shift %d, pbl_depth %d, total_len %u, "
 		"*iova_start %llx, first pa %llx, last pa %llx\n",
-		__FUNCTION__, page_shift, pbl_depth, total_len,
+		__func__, page_shift, pbl_depth, total_len,
 		(unsigned long long) *iova_start,
 	       	(unsigned long long) page_list[0],
 	       	(unsigned long long) page_list[pbl_depth-1]);
@@ -422,7 +422,7 @@ static struct ib_mr *c2_get_dma_mr(struc
 	struct ib_phys_buf bl;
 	u64 kva = 0;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	/* AMSO1100 limit */
 	bl.size = 0xffffffff;
@@ -442,7 +442,7 @@ static struct ib_mr *c2_reg_user_mr(stru
 	struct c2_pd *c2pd = to_c2pd(pd);
 	struct c2_mr *c2mr;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	c2mr = kmalloc(sizeof(*c2mr), GFP_KERNEL);
 	if (!c2mr)
@@ -506,7 +506,7 @@ static int c2_dereg_mr(struct ib_mr *ib_
 	struct c2_mr *mr = to_c2mr(ib_mr);
 	int err;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	err = c2_stag_dealloc(to_c2dev(ib_mr->device), ib_mr->lkey);
 	if (err)
@@ -524,7 +524,7 @@ static ssize_t show_rev(struct device *d
 			char *buf)
 {
 	struct c2_dev *c2dev = container_of(dev, struct c2_dev, ibdev.dev);
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return sprintf(buf, "%x\n", c2dev->props.hw_ver);
 }
 
@@ -532,7 +532,7 @@ static ssize_t show_fw_ver(struct device
 			   char *buf)
 {
 	struct c2_dev *c2dev = container_of(dev, struct c2_dev, ibdev.dev);
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return sprintf(buf, "%x.%x.%x\n",
 		       (int) (c2dev->props.fw_ver >> 32),
 		       (int) (c2dev->props.fw_ver >> 16) & 0xffff,
@@ -542,14 +542,14 @@ static ssize_t show_fw_ver(struct device
 static ssize_t show_hca(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return sprintf(buf, "AMSO1100\n");
 }
 
 static ssize_t show_board(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return sprintf(buf, "%.*s\n", 32, "AMSO1100 Board ID");
 }
 
@@ -579,13 +579,13 @@ static int c2_modify_qp(struct ib_qp *ib
 
 static int c2_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
 }
 
 static int c2_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
 }
 
@@ -596,13 +596,13 @@ static int c2_process_mad(struct ib_devi
 			  struct ib_grh *in_grh,
 			  struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
 }
 
 static int c2_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *iw_param)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	/* Request a connection */
 	return c2_llp_connect(cm_id, iw_param);
@@ -610,7 +610,7 @@ static int c2_connect(struct iw_cm_id *c
 
 static int c2_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *iw_param)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	/* Accept the new connection */
 	return c2_llp_accept(cm_id, iw_param);
@@ -620,7 +620,7 @@ static int c2_reject(struct iw_cm_id *cm
 {
 	int err;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	err = c2_llp_reject(cm_id, pdata, pdata_len);
 	return err;
@@ -630,10 +630,10 @@ static int c2_service_create(struct iw_c
 {
 	int err;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	err = c2_llp_service_create(cm_id, backlog);
 	pr_debug("%s:%u err=%d\n",
-		__FUNCTION__, __LINE__,
+		__func__, __LINE__,
 		err);
 	return err;
 }
@@ -641,7 +641,7 @@ static int c2_service_create(struct iw_c
 static int c2_service_destroy(struct iw_cm_id *cm_id)
 {
 	int err;
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 
 	err = c2_llp_service_destroy(cm_id);
 
@@ -747,7 +747,7 @@ static struct net_device *c2_pseudo_netd
 	netdev = alloc_netdev(sizeof(*netdev), name, setup);
 	if (!netdev) {
 		printk(KERN_ERR PFX "%s -  etherdev alloc failed",
-			__FUNCTION__);
+			__func__);
 		return NULL;
 	}
 
@@ -784,7 +784,7 @@ int c2_register_device(struct c2_dev *de
 	if (ret)
 		goto out2;
 
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	strlcpy(dev->ibdev.name, "amso%d", IB_DEVICE_NAME_MAX);
 	dev->ibdev.owner = THIS_MODULE;
 	dev->ibdev.uverbs_cmd_mask =
@@ -877,13 +877,13 @@ out1:
 out2:
 	free_netdev(dev->pseudo_netdev);
 out3:
-	pr_debug("%s:%u ret=%d\n", __FUNCTION__, __LINE__, ret);
+	pr_debug("%s:%u ret=%d\n", __func__, __LINE__, ret);
 	return ret;
 }
 
 void c2_unregister_device(struct c2_dev *dev)
 {
-	pr_debug("%s:%u\n", __FUNCTION__, __LINE__);
+	pr_debug("%s:%u\n", __func__, __LINE__);
 	unregister_netdev(dev->pseudo_netdev);
 	free_netdev(dev->pseudo_netdev);
 	ib_unregister_device(&dev->ibdev);
diff -puN drivers/infiniband/hw/amso1100/c2_qp.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/amso1100/c2_qp.c
--- a/drivers/infiniband/hw/amso1100/c2_qp.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -121,7 +121,7 @@ void c2_set_qp_state(struct c2_qp *qp, i
 	int new_state = to_ib_state(c2_state);
 
 	pr_debug("%s: qp[%p] state modify %s --> %s\n",
-	       __FUNCTION__,
+	       __func__,
 		qp,
 		to_ib_state_str(qp->state),
 		to_ib_state_str(new_state));
@@ -141,7 +141,7 @@ int c2_qp_modify(struct c2_dev *c2dev, s
 	int err;
 
 	pr_debug("%s:%d qp=%p, %s --> %s\n",
-		__FUNCTION__, __LINE__,
+		__func__, __LINE__,
 		qp,
 		to_ib_state_str(qp->state),
 		to_ib_state_str(attr->qp_state));
@@ -224,7 +224,7 @@ int c2_qp_modify(struct c2_dev *c2dev, s
 		qp->state = next_state;
 #ifdef DEBUG
 	else
-		pr_debug("%s: c2_errno=%d\n", __FUNCTION__, err);
+		pr_debug("%s: c2_errno=%d\n", __func__, err);
 #endif
 	/*
 	 * If we're going to error and generating the event here, then
@@ -243,7 +243,7 @@ int c2_qp_modify(struct c2_dev *c2dev, s
 	vq_req_free(c2dev, vq_req);
 
 	pr_debug("%s:%d qp=%p, cur_state=%s\n",
-		__FUNCTION__, __LINE__,
+		__func__, __LINE__,
 		qp,
 		to_ib_state_str(qp->state));
 	return err;
diff -puN drivers/infiniband/hw/amso1100/c2_rnic.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/amso1100/c2_rnic.c
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -524,7 +524,7 @@ int __devinit c2_rnic_init(struct c2_dev
 		goto bail1;
 	}
 	pci_unmap_addr_set(&c2dev->rep_vq, mapping, c2dev->rep_vq.host_dma);
-	pr_debug("%s rep_vq va %p dma %llx\n", __FUNCTION__, q1_pages,
+	pr_debug("%s rep_vq va %p dma %llx\n", __func__, q1_pages,
 		 (unsigned long long) c2dev->rep_vq.host_dma);
 	c2_mq_rep_init(&c2dev->rep_vq,
 		   1,
@@ -545,7 +545,7 @@ int __devinit c2_rnic_init(struct c2_dev
 		goto bail2;
 	}
 	pci_unmap_addr_set(&c2dev->aeq, mapping, c2dev->aeq.host_dma);
-	pr_debug("%s aeq va %p dma %llx\n", __FUNCTION__, q2_pages,
+	pr_debug("%s aeq va %p dma %llx\n", __func__, q2_pages,
 		 (unsigned long long) c2dev->aeq.host_dma);
 	c2_mq_rep_init(&c2dev->aeq,
 		       2,
diff -puN drivers/infiniband/hw/amso1100/c2_vq.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/amso1100/c2_vq.c
--- a/drivers/infiniband/hw/amso1100/c2_vq.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/amso1100/c2_vq.c
@@ -197,7 +197,7 @@ int vq_send_wr(struct c2_dev *c2dev, uni
 	 */
 	while (msg == NULL) {
 		pr_debug("%s:%d no available msg in VQ, waiting...\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		init_waitqueue_entry(&__wait, current);
 		add_wait_queue(&c2dev->req_vq_wo, &__wait);
 		spin_unlock(&c2dev->vqlock);
diff -puN drivers/infiniband/hw/cxgb3/cxio_dbg.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/cxio_dbg.c
--- a/drivers/infiniband/hw/cxgb3/cxio_dbg.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/cxio_dbg.c
@@ -45,16 +45,16 @@ void cxio_dump_tpt(struct cxio_rdev *rde
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
 	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __FUNCTION__);
+		PDBG("%s couldn't allocate memory.\n", __func__);
 		return;
 	}
 	m->mem_id = MEM_PMRX;
 	m->addr = (stag>>8) * 32 + rdev->rnic_info.tpt_base;
 	m->len = size;
-	PDBG("%s TPT addr 0x%x len %d\n", __FUNCTION__, m->addr, m->len);
+	PDBG("%s TPT addr 0x%x len %d\n", __func__, m->addr, m->len);
 	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
 	if (rc) {
-		PDBG("%s toectl returned error %d\n", __FUNCTION__, rc);
+		PDBG("%s toectl returned error %d\n", __func__, rc);
 		kfree(m);
 		return;
 	}
@@ -82,17 +82,17 @@ void cxio_dump_pbl(struct cxio_rdev *rde
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
 	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __FUNCTION__);
+		PDBG("%s couldn't allocate memory.\n", __func__);
 		return;
 	}
 	m->mem_id = MEM_PMRX;
 	m->addr = pbl_addr;
 	m->len = size;
 	PDBG("%s PBL addr 0x%x len %d depth %d\n",
-		__FUNCTION__, m->addr, m->len, npages);
+		__func__, m->addr, m->len, npages);
 	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
 	if (rc) {
-		PDBG("%s toectl returned error %d\n", __FUNCTION__, rc);
+		PDBG("%s toectl returned error %d\n", __func__, rc);
 		kfree(m);
 		return;
 	}
@@ -144,16 +144,16 @@ void cxio_dump_rqt(struct cxio_rdev *rde
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
 	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __FUNCTION__);
+		PDBG("%s couldn't allocate memory.\n", __func__);
 		return;
 	}
 	m->mem_id = MEM_PMRX;
 	m->addr = ((hwtid)<<10) + rdev->rnic_info.rqt_base;
 	m->len = size;
-	PDBG("%s RQT addr 0x%x len %d\n", __FUNCTION__, m->addr, m->len);
+	PDBG("%s RQT addr 0x%x len %d\n", __func__, m->addr, m->len);
 	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
 	if (rc) {
-		PDBG("%s toectl returned error %d\n", __FUNCTION__, rc);
+		PDBG("%s toectl returned error %d\n", __func__, rc);
 		kfree(m);
 		return;
 	}
@@ -177,16 +177,16 @@ void cxio_dump_tcb(struct cxio_rdev *rde
 
 	m = kmalloc(sizeof(*m) + size, GFP_ATOMIC);
 	if (!m) {
-		PDBG("%s couldn't allocate memory.\n", __FUNCTION__);
+		PDBG("%s couldn't allocate memory.\n", __func__);
 		return;
 	}
 	m->mem_id = MEM_CM;
 	m->addr = hwtid * size;
 	m->len = size;
-	PDBG("%s TCB %d len %d\n", __FUNCTION__, m->addr, m->len);
+	PDBG("%s TCB %d len %d\n", __func__, m->addr, m->len);
 	rc = rdev->t3cdev_p->ctl(rdev->t3cdev_p, RDMA_GET_MEM, m);
 	if (rc) {
-		PDBG("%s toectl returned error %d\n", __FUNCTION__, rc);
+		PDBG("%s toectl returned error %d\n", __func__, rc);
 		kfree(m);
 		return;
 	}
diff -puN drivers/infiniband/hw/cxgb3/cxio_hal.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/cxio_hal.c
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -140,7 +140,7 @@ static int cxio_hal_clear_qp_ctx(struct 
 	struct t3_modify_qp_wr *wqe;
 	struct sk_buff *skb = alloc_skb(sizeof(*wqe), GFP_KERNEL);
 	if (!skb) {
-		PDBG("%s alloc_skb failed\n", __FUNCTION__);
+		PDBG("%s alloc_skb failed\n", __func__);
 		return -ENOMEM;
 	}
 	wqe = (struct t3_modify_qp_wr *) skb_put(skb, sizeof(*wqe));
@@ -225,7 +225,7 @@ static u32 get_qpid(struct cxio_rdev *rd
 	}
 out:
 	mutex_unlock(&uctx->lock);
-	PDBG("%s qpid 0x%x\n", __FUNCTION__, qpid);
+	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	return qpid;
 }
 
@@ -237,7 +237,7 @@ static void put_qpid(struct cxio_rdev *r
 	entry = kmalloc(sizeof *entry, GFP_KERNEL);
 	if (!entry)
 		return;
-	PDBG("%s qpid 0x%x\n", __FUNCTION__, qpid);
+	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	entry->qpid = qpid;
 	mutex_lock(&uctx->lock);
 	list_add_tail(&entry->entry, &uctx->qpids);
@@ -300,7 +300,7 @@ int cxio_create_qp(struct cxio_rdev *rde
 	if (!kernel_domain)
 		wq->udb = (u64)rdev_p->rnic_info.udbell_physbase +
 					(wq->qpid << rdev_p->qpshift);
-	PDBG("%s qpid 0x%x doorbell 0x%p udb 0x%llx\n", __FUNCTION__,
+	PDBG("%s qpid 0x%x doorbell 0x%p udb 0x%llx\n", __func__,
 	     wq->qpid, wq->doorbell, (unsigned long long) wq->udb);
 	return 0;
 err4:
@@ -345,7 +345,7 @@ static void insert_recv_cqe(struct t3_wq
 {
 	struct t3_cqe cqe;
 
-	PDBG("%s wq %p cq %p sw_rptr 0x%x sw_wptr 0x%x\n", __FUNCTION__,
+	PDBG("%s wq %p cq %p sw_rptr 0x%x sw_wptr 0x%x\n", __func__,
 	     wq, cq, cq->sw_rptr, cq->sw_wptr);
 	memset(&cqe, 0, sizeof(cqe));
 	cqe.header = cpu_to_be32(V_CQE_STATUS(TPT_ERR_SWFLUSH) |
@@ -363,10 +363,10 @@ void cxio_flush_rq(struct t3_wq *wq, str
 {
 	u32 ptr;
 
-	PDBG("%s wq %p cq %p\n", __FUNCTION__, wq, cq);
+	PDBG("%s wq %p cq %p\n", __func__, wq, cq);
 
 	/* flush RQ */
-	PDBG("%s rq_rptr %u rq_wptr %u skip count %u\n", __FUNCTION__,
+	PDBG("%s rq_rptr %u rq_wptr %u skip count %u\n", __func__,
 	    wq->rq_rptr, wq->rq_wptr, count);
 	ptr = wq->rq_rptr + count;
 	while (ptr++ != wq->rq_wptr)
@@ -378,7 +378,7 @@ static void insert_sq_cqe(struct t3_wq *
 {
 	struct t3_cqe cqe;
 
-	PDBG("%s wq %p cq %p sw_rptr 0x%x sw_wptr 0x%x\n", __FUNCTION__,
+	PDBG("%s wq %p cq %p sw_rptr 0x%x sw_wptr 0x%x\n", __func__,
 	     wq, cq, cq->sw_rptr, cq->sw_wptr);
 	memset(&cqe, 0, sizeof(cqe));
 	cqe.header = cpu_to_be32(V_CQE_STATUS(TPT_ERR_SWFLUSH) |
@@ -415,11 +415,11 @@ void cxio_flush_hw_cq(struct t3_cq *cq)
 {
 	struct t3_cqe *cqe, *swcqe;
 
-	PDBG("%s cq %p cqid 0x%x\n", __FUNCTION__, cq, cq->cqid);
+	PDBG("%s cq %p cqid 0x%x\n", __func__, cq, cq->cqid);
 	cqe = cxio_next_hw_cqe(cq);
 	while (cqe) {
 		PDBG("%s flushing hwcq rptr 0x%x to swcq wptr 0x%x\n",
-		     __FUNCTION__, cq->rptr, cq->sw_wptr);
+		     __func__, cq->rptr, cq->sw_wptr);
 		swcqe = cq->sw_queue + Q_PTR2IDX(cq->sw_wptr, cq->size_log2);
 		*swcqe = *cqe;
 		swcqe->header |= cpu_to_be32(V_CQE_SWCQE(1));
@@ -461,7 +461,7 @@ void cxio_count_scqes(struct t3_cq *cq, 
 			(*count)++;
 		ptr++;
 	}
-	PDBG("%s cq %p count %d\n", __FUNCTION__, cq, *count);
+	PDBG("%s cq %p count %d\n", __func__, cq, *count);
 }
 
 void cxio_count_rcqes(struct t3_cq *cq, struct t3_wq *wq, int *count)
@@ -470,7 +470,7 @@ void cxio_count_rcqes(struct t3_cq *cq, 
 	u32 ptr;
 
 	*count = 0;
-	PDBG("%s count zero %d\n", __FUNCTION__, *count);
+	PDBG("%s count zero %d\n", __func__, *count);
 	ptr = cq->sw_rptr;
 	while (!Q_EMPTY(ptr, cq->sw_wptr)) {
 		cqe = cq->sw_queue + (Q_PTR2IDX(ptr, cq->size_log2));
@@ -479,7 +479,7 @@ void cxio_count_rcqes(struct t3_cq *cq, 
 			(*count)++;
 		ptr++;
 	}
-	PDBG("%s cq %p count %d\n", __FUNCTION__, cq, *count);
+	PDBG("%s cq %p count %d\n", __func__, cq, *count);
 }
 
 static int cxio_hal_init_ctrl_cq(struct cxio_rdev *rdev_p)
@@ -506,12 +506,12 @@ static int cxio_hal_init_ctrl_qp(struct 
 
 	skb = alloc_skb(sizeof(*wqe), GFP_KERNEL);
 	if (!skb) {
-		PDBG("%s alloc_skb failed\n", __FUNCTION__);
+		PDBG("%s alloc_skb failed\n", __func__);
 		return -ENOMEM;
 	}
 	err = cxio_hal_init_ctrl_cq(rdev_p);
 	if (err) {
-		PDBG("%s err %d initializing ctrl_cq\n", __FUNCTION__, err);
+		PDBG("%s err %d initializing ctrl_cq\n", __func__, err);
 		goto err;
 	}
 	rdev_p->ctrl_qp.workq = dma_alloc_coherent(
@@ -521,7 +521,7 @@ static int cxio_hal_init_ctrl_qp(struct 
 					&(rdev_p->ctrl_qp.dma_addr),
 					GFP_KERNEL);
 	if (!rdev_p->ctrl_qp.workq) {
-		PDBG("%s dma_alloc_coherent failed\n", __FUNCTION__);
+		PDBG("%s dma_alloc_coherent failed\n", __func__);
 		err = -ENOMEM;
 		goto err;
 	}
@@ -591,25 +591,25 @@ static int cxio_hal_ctrl_qp_write_mem(st
 	addr &= 0x7FFFFFF;
 	nr_wqe = len % 96 ? len / 96 + 1 : len / 96;	/* 96B max per WQE */
 	PDBG("%s wptr 0x%x rptr 0x%x len %d, nr_wqe %d data %p addr 0x%0x\n",
-	     __FUNCTION__, rdev_p->ctrl_qp.wptr, rdev_p->ctrl_qp.rptr, len,
+	     __func__, rdev_p->ctrl_qp.wptr, rdev_p->ctrl_qp.rptr, len,
 	     nr_wqe, data, addr);
 	utx_len = 3;		/* in 32B unit */
 	for (i = 0; i < nr_wqe; i++) {
 		if (Q_FULL(rdev_p->ctrl_qp.rptr, rdev_p->ctrl_qp.wptr,
 		           T3_CTRL_QP_SIZE_LOG2)) {
 			PDBG("%s ctrl_qp full wtpr 0x%0x rptr 0x%0x, "
-			     "wait for more space i %d\n", __FUNCTION__,
+			     "wait for more space i %d\n", __func__,
 			     rdev_p->ctrl_qp.wptr, rdev_p->ctrl_qp.rptr, i);
 			if (wait_event_interruptible(rdev_p->ctrl_qp.waitq,
 					     !Q_FULL(rdev_p->ctrl_qp.rptr,
 						     rdev_p->ctrl_qp.wptr,
 						     T3_CTRL_QP_SIZE_LOG2))) {
 				PDBG("%s ctrl_qp workq interrupted\n",
-				     __FUNCTION__);
+				     __func__);
 				return -ERESTARTSYS;
 			}
 			PDBG("%s ctrl_qp wakeup, continue posting work request "
-			     "i %d\n", __FUNCTION__, i);
+			     "i %d\n", __func__, i);
 		}
 		wqe = (__be64 *)(rdev_p->ctrl_qp.workq + (rdev_p->ctrl_qp.wptr %
 						(1 << T3_CTRL_QP_SIZE_LOG2)));
@@ -630,7 +630,7 @@ static int cxio_hal_ctrl_qp_write_mem(st
 		if ((i != 0) &&
 		    (i % (((1 << T3_CTRL_QP_SIZE_LOG2)) >> 1) == 0)) {
 			flag = T3_COMPLETION_FLAG;
-			PDBG("%s force completion at i %d\n", __FUNCTION__, i);
+			PDBG("%s force completion at i %d\n", __func__, i);
 		}
 
 		/* build the utx mem command */
@@ -701,7 +701,7 @@ static int __cxio_tpt_op(struct cxio_rde
 		*stag = (stag_idx << 8) | ((*stag) & 0xFF);
 	}
 	PDBG("%s stag_state 0x%0x type 0x%0x pdid 0x%0x, stag_idx 0x%x\n",
-	     __FUNCTION__, stag_state, type, pdid, stag_idx);
+	     __func__, stag_state, type, pdid, stag_idx);
 
 	if (reset_tpt_entry)
 		cxio_hal_pblpool_free(rdev_p, *pbl_addr, *pbl_size << 3);
@@ -718,7 +718,7 @@ static int __cxio_tpt_op(struct cxio_rde
 	if (pbl) {
 
 		PDBG("%s *pdb_addr 0x%x, pbl_base 0x%x, pbl_size %d\n",
-		     __FUNCTION__, *pbl_addr, rdev_p->rnic_info.pbl_base,
+		     __func__, *pbl_addr, rdev_p->rnic_info.pbl_base,
 		     *pbl_size);
 		err = cxio_hal_ctrl_qp_write_mem(rdev_p,
 				(*pbl_addr >> 5),
@@ -814,7 +814,7 @@ int cxio_rdma_init(struct cxio_rdev *rde
 	struct sk_buff *skb = alloc_skb(sizeof(*wqe), GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
-	PDBG("%s rdev_p %p\n", __FUNCTION__, rdev_p);
+	PDBG("%s rdev_p %p\n", __func__, rdev_p);
 	wqe = (struct t3_rdma_init_wr *) __skb_put(skb, sizeof(*wqe));
 	wqe->wrh.op_seop_flags = cpu_to_be32(V_FW_RIWR_OP(T3_WR_INIT));
 	wqe->wrh.gen_tid_len = cpu_to_be32(V_FW_RIWR_TID(attr->tid) |
@@ -856,7 +856,7 @@ static int cxio_hal_ev_handler(struct t3
 	struct respQ_msg_t *rsp_msg = (struct respQ_msg_t *) skb->data;
 	PDBG("%d: %s cq_id 0x%x cq_ptr 0x%x genbit %0x overflow %0x an %0x"
 	     " se %0x notify %0x cqbranch %0x creditth %0x\n",
-	     cnt, __FUNCTION__, RSPQ_CQID(rsp_msg), RSPQ_CQPTR(rsp_msg),
+	     cnt, __func__, RSPQ_CQID(rsp_msg), RSPQ_CQPTR(rsp_msg),
 	     RSPQ_GENBIT(rsp_msg), RSPQ_OVERFLOW(rsp_msg), RSPQ_AN(rsp_msg),
 	     RSPQ_SE(rsp_msg), RSPQ_NOTIFY(rsp_msg), RSPQ_CQBRANCH(rsp_msg),
 	     RSPQ_CREDIT_THRESH(rsp_msg));
@@ -868,7 +868,7 @@ static int cxio_hal_ev_handler(struct t3
 	     CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
 	rdev_p = (struct cxio_rdev *)t3cdev_p->ulp;
 	if (!rdev_p) {
-		PDBG("%s called by t3cdev %p with null ulp\n", __FUNCTION__,
+		PDBG("%s called by t3cdev %p with null ulp\n", __func__,
 		     t3cdev_p);
 		return 0;
 	}
@@ -908,13 +908,13 @@ int cxio_rdev_open(struct cxio_rdev *rde
 		strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
 			T3_MAX_DEV_NAME_LEN);
 	} else {
-		PDBG("%s t3cdev_p or dev_name must be set\n", __FUNCTION__);
+		PDBG("%s t3cdev_p or dev_name must be set\n", __func__);
 		return -EINVAL;
 	}
 
 	list_add_tail(&rdev_p->entry, &rdev_list);
 
-	PDBG("%s opening rnic dev %s\n", __FUNCTION__, rdev_p->dev_name);
+	PDBG("%s opening rnic dev %s\n", __func__, rdev_p->dev_name);
 	memset(&rdev_p->ctrl_qp, 0, sizeof(rdev_p->ctrl_qp));
 	if (!rdev_p->t3cdev_p)
 		rdev_p->t3cdev_p = dev2t3cdev(netdev_p);
@@ -923,14 +923,14 @@ int cxio_rdev_open(struct cxio_rdev *rde
 					 &(rdev_p->rnic_info));
 	if (err) {
 		printk(KERN_ERR "%s t3cdev_p(%p)->ctl returned error %d.\n",
-		     __FUNCTION__, rdev_p->t3cdev_p, err);
+		     __func__, rdev_p->t3cdev_p, err);
 		goto err1;
 	}
 	err = rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, GET_PORTS,
 				    &(rdev_p->port_info));
 	if (err) {
 		printk(KERN_ERR "%s t3cdev_p(%p)->ctl returned error %d.\n",
-		     __FUNCTION__, rdev_p->t3cdev_p, err);
+		     __func__, rdev_p->t3cdev_p, err);
 		goto err1;
 	}
 
@@ -947,7 +947,7 @@ int cxio_rdev_open(struct cxio_rdev *rde
 	rdev_p->qpmask = (65536 >> ilog2(rdev_p->qpnr)) - 1;
 	PDBG("%s rnic %s info: tpt_base 0x%0x tpt_top 0x%0x num stags %d "
 	     "pbl_base 0x%0x pbl_top 0x%0x rqt_base 0x%0x, rqt_top 0x%0x\n",
-	     __FUNCTION__, rdev_p->dev_name, rdev_p->rnic_info.tpt_base,
+	     __func__, rdev_p->dev_name, rdev_p->rnic_info.tpt_base,
 	     rdev_p->rnic_info.tpt_top, cxio_num_stags(rdev_p),
 	     rdev_p->rnic_info.pbl_base,
 	     rdev_p->rnic_info.pbl_top, rdev_p->rnic_info.rqt_base,
@@ -961,7 +961,7 @@ int cxio_rdev_open(struct cxio_rdev *rde
 	err = cxio_hal_init_ctrl_qp(rdev_p);
 	if (err) {
 		printk(KERN_ERR "%s error %d initializing ctrl_qp.\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		goto err1;
 	}
 	err = cxio_hal_init_resource(rdev_p, cxio_num_stags(rdev_p), 0,
@@ -969,19 +969,19 @@ int cxio_rdev_open(struct cxio_rdev *rde
 				     T3_MAX_NUM_PD);
 	if (err) {
 		printk(KERN_ERR "%s error %d initializing hal resources.\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		goto err2;
 	}
 	err = cxio_hal_pblpool_create(rdev_p);
 	if (err) {
 		printk(KERN_ERR "%s error %d initializing pbl mem pool.\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		goto err3;
 	}
 	err = cxio_hal_rqtpool_create(rdev_p);
 	if (err) {
 		printk(KERN_ERR "%s error %d initializing rqt mem pool.\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		goto err4;
 	}
 	return 0;
@@ -1043,7 +1043,7 @@ static void flush_completed_wrs(struct t
 			 * Insert this completed cqe into the swcq.
 			 */
 			PDBG("%s moving cqe into swcq sq idx %ld cq idx %ld\n",
-			     __FUNCTION__, Q_PTR2IDX(ptr,  wq->sq_size_log2),
+			     __func__, Q_PTR2IDX(ptr,  wq->sq_size_log2),
 			     Q_PTR2IDX(cq->sw_wptr, cq->size_log2));
 			sqp->cqe.header |= htonl(V_CQE_SWCQE(1));
 			*(cq->sw_queue + Q_PTR2IDX(cq->sw_wptr, cq->size_log2))
@@ -1112,7 +1112,7 @@ int cxio_poll_cq(struct t3_wq *wq, struc
 
 	PDBG("%s CQE OOO %d qpid 0x%0x genbit %d type %d status 0x%0x"
 	     " opcode 0x%0x len 0x%0x wrid_hi_stag 0x%x wrid_low_msn 0x%x\n",
-	     __FUNCTION__, CQE_OOO(*hw_cqe), CQE_QPID(*hw_cqe),
+	     __func__, CQE_OOO(*hw_cqe), CQE_QPID(*hw_cqe),
 	     CQE_GENBIT(*hw_cqe), CQE_TYPE(*hw_cqe), CQE_STATUS(*hw_cqe),
 	     CQE_OPCODE(*hw_cqe), CQE_LEN(*hw_cqe), CQE_WRID_HI(*hw_cqe),
 	     CQE_WRID_LOW(*hw_cqe));
@@ -1215,7 +1215,7 @@ int cxio_poll_cq(struct t3_wq *wq, struc
 		struct t3_swsq *sqp;
 
 		PDBG("%s out of order completion going in swsq at idx %ld\n",
-		     __FUNCTION__,
+		     __func__,
 		     Q_PTR2IDX(CQE_WRID_SQ_WPTR(*hw_cqe), wq->sq_size_log2));
 		sqp = wq->sq +
 		      Q_PTR2IDX(CQE_WRID_SQ_WPTR(*hw_cqe), wq->sq_size_log2);
@@ -1234,13 +1234,13 @@ proc_cqe:
 	 */
 	if (SQ_TYPE(*hw_cqe)) {
 		wq->sq_rptr = CQE_WRID_SQ_WPTR(*hw_cqe);
-		PDBG("%s completing sq idx %ld\n", __FUNCTION__,
+		PDBG("%s completing sq idx %ld\n", __func__,
 		     Q_PTR2IDX(wq->sq_rptr, wq->sq_size_log2));
 		*cookie = (wq->sq +
 			   Q_PTR2IDX(wq->sq_rptr, wq->sq_size_log2))->wr_id;
 		wq->sq_rptr++;
 	} else {
-		PDBG("%s completing rq idx %ld\n", __FUNCTION__,
+		PDBG("%s completing rq idx %ld\n", __func__,
 		     Q_PTR2IDX(wq->rq_rptr, wq->rq_size_log2));
 		*cookie = *(wq->rq + Q_PTR2IDX(wq->rq_rptr, wq->rq_size_log2));
 		wq->rq_rptr++;
@@ -1255,11 +1255,11 @@ flush_wq:
 skip_cqe:
 	if (SW_CQE(*hw_cqe)) {
 		PDBG("%s cq %p cqid 0x%x skip sw cqe sw_rptr 0x%x\n",
-		     __FUNCTION__, cq, cq->cqid, cq->sw_rptr);
+		     __func__, cq, cq->cqid, cq->sw_rptr);
 		++cq->sw_rptr;
 	} else {
 		PDBG("%s cq %p cqid 0x%x skip hw cqe rptr 0x%x\n",
-		     __FUNCTION__, cq, cq->cqid, cq->rptr);
+		     __func__, cq, cq->cqid, cq->rptr);
 		++cq->rptr;
 
 		/*
diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -206,13 +206,13 @@ void cxio_hal_put_stag(struct cxio_hal_r
 u32 cxio_hal_get_qpid(struct cxio_hal_resource *rscp)
 {
 	u32 qpid = cxio_hal_get_resource(rscp->qpid_fifo);
-	PDBG("%s qpid 0x%x\n", __FUNCTION__, qpid);
+	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	return qpid;
 }
 
 void cxio_hal_put_qpid(struct cxio_hal_resource *rscp, u32 qpid)
 {
-	PDBG("%s qpid 0x%x\n", __FUNCTION__, qpid);
+	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	cxio_hal_put_resource(rscp->qpid_fifo, qpid);
 }
 
@@ -255,13 +255,13 @@ void cxio_hal_destroy_resource(struct cx
 u32 cxio_hal_pblpool_alloc(struct cxio_rdev *rdev_p, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev_p->pbl_pool, size);
-	PDBG("%s addr 0x%x size %d\n", __FUNCTION__, (u32)addr, size);
+	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size);
 	return (u32)addr;
 }
 
 void cxio_hal_pblpool_free(struct cxio_rdev *rdev_p, u32 addr, int size)
 {
-	PDBG("%s addr 0x%x size %d\n", __FUNCTION__, addr, size);
+	PDBG("%s addr 0x%x size %d\n", __func__, addr, size);
 	gen_pool_free(rdev_p->pbl_pool, (unsigned long)addr, size);
 }
 
@@ -292,13 +292,13 @@ void cxio_hal_pblpool_destroy(struct cxi
 u32 cxio_hal_rqtpool_alloc(struct cxio_rdev *rdev_p, int size)
 {
 	unsigned long addr = gen_pool_alloc(rdev_p->rqt_pool, size << 6);
-	PDBG("%s addr 0x%x size %d\n", __FUNCTION__, (u32)addr, size << 6);
+	PDBG("%s addr 0x%x size %d\n", __func__, (u32)addr, size << 6);
 	return (u32)addr;
 }
 
 void cxio_hal_rqtpool_free(struct cxio_rdev *rdev_p, u32 addr, int size)
 {
-	PDBG("%s addr 0x%x size %d\n", __FUNCTION__, addr, size << 6);
+	PDBG("%s addr 0x%x size %d\n", __func__, addr, size << 6);
 	gen_pool_free(rdev_p->rqt_pool, (unsigned long)addr, size << 6);
 }
 
diff -puN drivers/infiniband/hw/cxgb3/iwch.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch.c
--- a/drivers/infiniband/hw/cxgb3/iwch.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch.c
@@ -65,7 +65,7 @@ static DEFINE_MUTEX(dev_mutex);
 
 static void rnic_init(struct iwch_dev *rnicp)
 {
-	PDBG("%s iwch_dev %p\n", __FUNCTION__,  rnicp);
+	PDBG("%s iwch_dev %p\n", __func__,  rnicp);
 	idr_init(&rnicp->cqidr);
 	idr_init(&rnicp->qpidr);
 	idr_init(&rnicp->mmidr);
@@ -106,7 +106,7 @@ static void open_rnic_dev(struct t3cdev 
 	struct iwch_dev *rnicp;
 	static int vers_printed;
 
-	PDBG("%s t3cdev %p\n", __FUNCTION__,  tdev);
+	PDBG("%s t3cdev %p\n", __func__,  tdev);
 	if (!vers_printed++)
 		printk(KERN_INFO MOD "Chelsio T3 RDMA Driver - version %s\n",
 		       DRV_VERSION);
@@ -144,7 +144,7 @@ static void open_rnic_dev(struct t3cdev 
 static void close_rnic_dev(struct t3cdev *tdev)
 {
 	struct iwch_dev *dev, *tmp;
-	PDBG("%s t3cdev %p\n", __FUNCTION__,  tdev);
+	PDBG("%s t3cdev %p\n", __func__,  tdev);
 	mutex_lock(&dev_mutex);
 	list_for_each_entry_safe(dev, tmp, &dev_list, entry) {
 		if (dev->rdev.t3cdev_p == tdev) {
diff -puN drivers/infiniband/hw/cxgb3/iwch_cm.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_cm.c
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -110,9 +110,9 @@ static void connect_reply_upcall(struct 
 
 static void start_ep_timer(struct iwch_ep *ep)
 {
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	if (timer_pending(&ep->timer)) {
-		PDBG("%s stopped / restarted timer ep %p\n", __FUNCTION__, ep);
+		PDBG("%s stopped / restarted timer ep %p\n", __func__, ep);
 		del_timer_sync(&ep->timer);
 	} else
 		get_ep(&ep->com);
@@ -124,7 +124,7 @@ static void start_ep_timer(struct iwch_e
 
 static void stop_ep_timer(struct iwch_ep *ep)
 {
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	del_timer_sync(&ep->timer);
 	put_ep(&ep->com);
 }
@@ -190,7 +190,7 @@ int iwch_resume_tid(struct iwch_ep *ep)
 
 static void set_emss(struct iwch_ep *ep, u16 opt)
 {
-	PDBG("%s ep %p opt %u\n", __FUNCTION__, ep, opt);
+	PDBG("%s ep %p opt %u\n", __func__, ep, opt);
 	ep->emss = T3C_DATA(ep->com.tdev)->mtus[G_TCPOPT_MSS(opt)] - 40;
 	if (G_TCPOPT_TSTAMP(opt))
 		ep->emss -= 12;
@@ -220,7 +220,7 @@ static void state_set(struct iwch_ep_com
 	unsigned long flags;
 
 	spin_lock_irqsave(&epc->lock, flags);
-	PDBG("%s - %s -> %s\n", __FUNCTION__, states[epc->state], states[new]);
+	PDBG("%s - %s -> %s\n", __func__, states[epc->state], states[new]);
 	__state_set(epc, new);
 	spin_unlock_irqrestore(&epc->lock, flags);
 	return;
@@ -236,7 +236,7 @@ static void *alloc_ep(int size, gfp_t gf
 		spin_lock_init(&epc->lock);
 		init_waitqueue_head(&epc->waitq);
 	}
-	PDBG("%s alloc ep %p\n", __FUNCTION__, epc);
+	PDBG("%s alloc ep %p\n", __func__, epc);
 	return epc;
 }
 
@@ -244,13 +244,13 @@ void __free_ep(struct kref *kref)
 {
 	struct iwch_ep_common *epc;
 	epc = container_of(kref, struct iwch_ep_common, kref);
-	PDBG("%s ep %p state %s\n", __FUNCTION__, epc, states[state_read(epc)]);
+	PDBG("%s ep %p state %s\n", __func__, epc, states[state_read(epc)]);
 	kfree(epc);
 }
 
 static void release_ep_resources(struct iwch_ep *ep)
 {
-	PDBG("%s ep %p tid %d\n", __FUNCTION__, ep, ep->hwtid);
+	PDBG("%s ep %p tid %d\n", __func__, ep, ep->hwtid);
 	cxgb3_remove_tid(ep->com.tdev, (void *)ep, ep->hwtid);
 	dst_release(ep->dst);
 	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
@@ -349,7 +349,7 @@ static unsigned int find_best_mtu(const 
 
 static void arp_failure_discard(struct t3cdev *dev, struct sk_buff *skb)
 {
-	PDBG("%s t3cdev %p\n", __FUNCTION__, dev);
+	PDBG("%s t3cdev %p\n", __func__, dev);
 	kfree_skb(skb);
 }
 
@@ -370,7 +370,7 @@ static void abort_arp_failure(struct t3c
 {
 	struct cpl_abort_req *req = cplhdr(skb);
 
-	PDBG("%s t3cdev %p\n", __FUNCTION__, dev);
+	PDBG("%s t3cdev %p\n", __func__, dev);
 	req->cmd = CPL_ABORT_NO_RST;
 	cxgb3_ofld_send(dev, skb);
 }
@@ -380,10 +380,10 @@ static int send_halfclose(struct iwch_ep
 	struct cpl_close_con_req *req;
 	struct sk_buff *skb;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(NULL, sizeof(*req), gfp);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - failed to alloc skb\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - failed to alloc skb\n", __func__);
 		return -ENOMEM;
 	}
 	skb->priority = CPL_PRIORITY_DATA;
@@ -400,11 +400,11 @@ static int send_abort(struct iwch_ep *ep
 {
 	struct cpl_abort_req *req;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(skb, sizeof(*req), gfp);
 	if (!skb) {
 		printk(KERN_ERR MOD "%s - failed to alloc skb.\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENOMEM;
 	}
 	skb->priority = CPL_PRIORITY_DATA;
@@ -426,12 +426,12 @@ static int send_connect(struct iwch_ep *
 	unsigned int mtu_idx;
 	int wscale;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
 		printk(KERN_ERR MOD "%s - failed to alloc skb.\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENOMEM;
 	}
 	mtu_idx = find_best_mtu(T3C_DATA(ep->com.tdev), dst_mtu(ep->dst));
@@ -470,7 +470,7 @@ static void send_mpa_req(struct iwch_ep 
 	struct mpa_message *mpa;
 	int len;
 
-	PDBG("%s ep %p pd_len %d\n", __FUNCTION__, ep, ep->plen);
+	PDBG("%s ep %p pd_len %d\n", __func__, ep, ep->plen);
 
 	BUG_ON(skb_cloned(skb));
 
@@ -530,13 +530,13 @@ static int send_mpa_reject(struct iwch_e
 	struct mpa_message *mpa;
 	struct sk_buff *skb;
 
-	PDBG("%s ep %p plen %d\n", __FUNCTION__, ep, plen);
+	PDBG("%s ep %p plen %d\n", __func__, ep, plen);
 
 	mpalen = sizeof(*mpa) + plen;
 
 	skb = get_skb(NULL, mpalen + sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - cannot alloc skb!\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc skb!\n", __func__);
 		return -ENOMEM;
 	}
 	skb_reserve(skb, sizeof(*req));
@@ -580,13 +580,13 @@ static int send_mpa_reply(struct iwch_ep
 	int len;
 	struct sk_buff *skb;
 
-	PDBG("%s ep %p plen %d\n", __FUNCTION__, ep, plen);
+	PDBG("%s ep %p plen %d\n", __func__, ep, plen);
 
 	mpalen = sizeof(*mpa) + plen;
 
 	skb = get_skb(NULL, mpalen + sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - cannot alloc skb!\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc skb!\n", __func__);
 		return -ENOMEM;
 	}
 	skb->priority = CPL_PRIORITY_DATA;
@@ -630,7 +630,7 @@ static int act_establish(struct t3cdev *
 	struct cpl_act_establish *req = cplhdr(skb);
 	unsigned int tid = GET_TID(req);
 
-	PDBG("%s ep %p tid %d\n", __FUNCTION__, ep, tid);
+	PDBG("%s ep %p tid %d\n", __func__, ep, tid);
 
 	dst_confirm(ep->dst);
 
@@ -663,7 +663,7 @@ static void close_complete_upcall(struct
 {
 	struct iw_cm_event event;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_CLOSE;
 	if (ep->com.cm_id) {
@@ -680,7 +680,7 @@ static void peer_close_upcall(struct iwc
 {
 	struct iw_cm_event event;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_DISCONNECT;
 	if (ep->com.cm_id) {
@@ -694,7 +694,7 @@ static void peer_abort_upcall(struct iwc
 {
 	struct iw_cm_event event;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_CLOSE;
 	event.status = -ECONNRESET;
@@ -712,7 +712,7 @@ static void connect_reply_upcall(struct 
 {
 	struct iw_cm_event event;
 
-	PDBG("%s ep %p status %d\n", __FUNCTION__, ep, status);
+	PDBG("%s ep %p status %d\n", __func__, ep, status);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_CONNECT_REPLY;
 	event.status = status;
@@ -724,7 +724,7 @@ static void connect_reply_upcall(struct 
 		event.private_data = ep->mpa_pkt + sizeof(struct mpa_message);
 	}
 	if (ep->com.cm_id) {
-		PDBG("%s ep %p tid %d status %d\n", __FUNCTION__, ep,
+		PDBG("%s ep %p tid %d status %d\n", __func__, ep,
 		     ep->hwtid, status);
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 	}
@@ -739,7 +739,7 @@ static void connect_request_upcall(struc
 {
 	struct iw_cm_event event;
 
-	PDBG("%s ep %p tid %d\n", __FUNCTION__, ep, ep->hwtid);
+	PDBG("%s ep %p tid %d\n", __func__, ep, ep->hwtid);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_CONNECT_REQUEST;
 	event.local_addr = ep->com.local_addr;
@@ -759,11 +759,11 @@ static void established_upcall(struct iw
 {
 	struct iw_cm_event event;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	memset(&event, 0, sizeof(event));
 	event.event = IW_CM_EVENT_ESTABLISHED;
 	if (ep->com.cm_id) {
-		PDBG("%s ep %p tid %d\n", __FUNCTION__, ep, ep->hwtid);
+		PDBG("%s ep %p tid %d\n", __func__, ep, ep->hwtid);
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 	}
 }
@@ -773,7 +773,7 @@ static int update_rx_credits(struct iwch
 	struct cpl_rx_data_ack *req;
 	struct sk_buff *skb;
 
-	PDBG("%s ep %p credits %u\n", __FUNCTION__, ep, credits);
+	PDBG("%s ep %p credits %u\n", __func__, ep, credits);
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
 		printk(KERN_ERR MOD "update_rx_credits - cannot alloc skb!\n");
@@ -797,7 +797,7 @@ static void process_mpa_reply(struct iwc
 	enum iwch_qp_attr_mask mask;
 	int err;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 
 	/*
 	 * Stop mpa timer.  If it expired, then the state has
@@ -884,7 +884,7 @@ static void process_mpa_reply(struct iwc
 	ep->mpa_attr.xmit_marker_enabled = mpa->flags & MPA_MARKERS ? 1 : 0;
 	ep->mpa_attr.version = mpa_rev;
 	PDBG("%s - crc_enabled=%d, recv_marker_enabled=%d, "
-	     "xmit_marker_enabled=%d, version=%d\n", __FUNCTION__,
+	     "xmit_marker_enabled=%d, version=%d\n", __func__,
 	     ep->mpa_attr.crc_enabled, ep->mpa_attr.recv_marker_enabled,
 	     ep->mpa_attr.xmit_marker_enabled, ep->mpa_attr.version);
 
@@ -915,7 +915,7 @@ static void process_mpa_request(struct i
 	struct mpa_message *mpa;
 	u16 plen;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 
 	/*
 	 * Stop mpa timer.  If it expired, then the state has
@@ -935,7 +935,7 @@ static void process_mpa_request(struct i
 		return;
 	}
 
-	PDBG("%s enter (%s line %u)\n", __FUNCTION__, __FILE__, __LINE__);
+	PDBG("%s enter (%s line %u)\n", __func__, __FILE__, __LINE__);
 
 	/*
 	 * Copy the new data into our accumulation buffer.
@@ -950,7 +950,7 @@ static void process_mpa_request(struct i
 	 */
 	if (ep->mpa_pkt_len < sizeof(*mpa))
 		return;
-	PDBG("%s enter (%s line %u)\n", __FUNCTION__, __FILE__, __LINE__);
+	PDBG("%s enter (%s line %u)\n", __func__, __FILE__, __LINE__);
 	mpa = (struct mpa_message *) ep->mpa_pkt;
 
 	/*
@@ -1000,7 +1000,7 @@ static void process_mpa_request(struct i
 	ep->mpa_attr.xmit_marker_enabled = mpa->flags & MPA_MARKERS ? 1 : 0;
 	ep->mpa_attr.version = mpa_rev;
 	PDBG("%s - crc_enabled=%d, recv_marker_enabled=%d, "
-	     "xmit_marker_enabled=%d, version=%d\n", __FUNCTION__,
+	     "xmit_marker_enabled=%d, version=%d\n", __func__,
 	     ep->mpa_attr.crc_enabled, ep->mpa_attr.recv_marker_enabled,
 	     ep->mpa_attr.xmit_marker_enabled, ep->mpa_attr.version);
 
@@ -1017,7 +1017,7 @@ static int rx_data(struct t3cdev *tdev, 
 	struct cpl_rx_data *hdr = cplhdr(skb);
 	unsigned int dlen = ntohs(hdr->len);
 
-	PDBG("%s ep %p dlen %u\n", __FUNCTION__, ep, dlen);
+	PDBG("%s ep %p dlen %u\n", __func__, ep, dlen);
 
 	skb_pull(skb, sizeof(*hdr));
 	skb_trim(skb, dlen);
@@ -1037,7 +1037,7 @@ static int rx_data(struct t3cdev *tdev, 
 	default:
 		printk(KERN_ERR MOD "%s Unexpected streaming data."
 		       " ep %p state %d tid %d\n",
-		       __FUNCTION__, ep, state_read(&ep->com), ep->hwtid);
+		       __func__, ep, state_read(&ep->com), ep->hwtid);
 
 		/*
 		 * The ep will timeout and inform the ULP of the failure.
@@ -1063,7 +1063,7 @@ static int tx_ack(struct t3cdev *tdev, s
 	struct cpl_wr_ack *hdr = cplhdr(skb);
 	unsigned int credits = ntohs(hdr->credits);
 
-	PDBG("%s ep %p credits %u\n", __FUNCTION__, ep, credits);
+	PDBG("%s ep %p credits %u\n", __func__, ep, credits);
 
 	if (credits == 0)
 		return CPL_RET_BUF_DONE;
@@ -1084,7 +1084,7 @@ static int abort_rpl(struct t3cdev *tdev
 {
 	struct iwch_ep *ep = ctx;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 
 	/*
 	 * We get 2 abort replies from the HW.  The first one must
@@ -1115,7 +1115,7 @@ static int act_open_rpl(struct t3cdev *t
 	struct iwch_ep *ep = ctx;
 	struct cpl_act_open_rpl *rpl = cplhdr(skb);
 
-	PDBG("%s ep %p status %u errno %d\n", __FUNCTION__, ep, rpl->status,
+	PDBG("%s ep %p status %u errno %d\n", __func__, ep, rpl->status,
 	     status2errno(rpl->status));
 	connect_reply_upcall(ep, status2errno(rpl->status));
 	state_set(&ep->com, DEAD);
@@ -1133,7 +1133,7 @@ static int listen_start(struct iwch_list
 	struct sk_buff *skb;
 	struct cpl_pass_open_req *req;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
 		printk(KERN_ERR MOD "t3c_listen_start failed to alloc skb!\n");
@@ -1162,7 +1162,7 @@ static int pass_open_rpl(struct t3cdev *
 	struct iwch_listen_ep *ep = ctx;
 	struct cpl_pass_open_rpl *rpl = cplhdr(skb);
 
-	PDBG("%s ep %p status %d error %d\n", __FUNCTION__, ep,
+	PDBG("%s ep %p status %d error %d\n", __func__, ep,
 	     rpl->status, status2errno(rpl->status));
 	ep->com.rpl_err = status2errno(rpl->status);
 	ep->com.rpl_done = 1;
@@ -1176,10 +1176,10 @@ static int listen_stop(struct iwch_liste
 	struct sk_buff *skb;
 	struct cpl_close_listserv_req *req;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	skb = get_skb(NULL, sizeof(*req), GFP_KERNEL);
 	if (!skb) {
-		printk(KERN_ERR MOD "%s - failed to alloc skb\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - failed to alloc skb\n", __func__);
 		return -ENOMEM;
 	}
 	req = (struct cpl_close_listserv_req *) skb_put(skb, sizeof(*req));
@@ -1197,7 +1197,7 @@ static int close_listsrv_rpl(struct t3cd
 	struct iwch_listen_ep *ep = ctx;
 	struct cpl_close_listserv_rpl *rpl = cplhdr(skb);
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	ep->com.rpl_err = status2errno(rpl->status);
 	ep->com.rpl_done = 1;
 	wake_up(&ep->com.waitq);
@@ -1211,7 +1211,7 @@ static void accept_cr(struct iwch_ep *ep
 	u32 opt0h, opt0l, opt2;
 	int wscale;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	BUG_ON(skb_cloned(skb));
 	skb_trim(skb, sizeof(*rpl));
 	skb_get(skb);
@@ -1244,7 +1244,7 @@ static void accept_cr(struct iwch_ep *ep
 static void reject_cr(struct t3cdev *tdev, u32 hwtid, __be32 peer_ip,
 		      struct sk_buff *skb)
 {
-	PDBG("%s t3cdev %p tid %u peer_ip %x\n", __FUNCTION__, tdev, hwtid,
+	PDBG("%s t3cdev %p tid %u peer_ip %x\n", __func__, tdev, hwtid,
 	     peer_ip);
 	BUG_ON(skb_cloned(skb));
 	skb_trim(skb, sizeof(struct cpl_tid_release));
@@ -1279,11 +1279,11 @@ static int pass_accept_req(struct t3cdev
 	struct rtable *rt;
 	struct iff_mac tim;
 
-	PDBG("%s parent ep %p tid %u\n", __FUNCTION__, parent_ep, hwtid);
+	PDBG("%s parent ep %p tid %u\n", __func__, parent_ep, hwtid);
 
 	if (state_read(&parent_ep->com) != LISTEN) {
 		printk(KERN_ERR "%s - listening ep not in LISTEN\n",
-		       __FUNCTION__);
+		       __func__);
 		goto reject;
 	}
 
@@ -1295,7 +1295,7 @@ static int pass_accept_req(struct t3cdev
 	if (tdev->ctl(tdev, GET_IFF_FROM_MAC, &tim) < 0 || !tim.dev) {
 		printk(KERN_ERR
 			"%s bad dst mac %02x %02x %02x %02x %02x %02x\n",
-			__FUNCTION__,
+			__func__,
 			req->dst_mac[0],
 			req->dst_mac[1],
 			req->dst_mac[2],
@@ -1313,21 +1313,21 @@ static int pass_accept_req(struct t3cdev
 			req->peer_port, G_PASS_OPEN_TOS(ntohl(req->tos_tid)));
 	if (!rt) {
 		printk(KERN_ERR MOD "%s - failed to find dst entry!\n",
-		       __FUNCTION__);
+		       __func__);
 		goto reject;
 	}
 	dst = &rt->u.dst;
 	l2t = t3_l2t_get(tdev, dst->neighbour, dst->neighbour->dev);
 	if (!l2t) {
 		printk(KERN_ERR MOD "%s - failed to allocate l2t entry!\n",
-		       __FUNCTION__);
+		       __func__);
 		dst_release(dst);
 		goto reject;
 	}
 	child_ep = alloc_ep(sizeof(*child_ep), GFP_KERNEL);
 	if (!child_ep) {
 		printk(KERN_ERR MOD "%s - failed to allocate ep entry!\n",
-		       __FUNCTION__);
+		       __func__);
 		l2t_release(L2DATA(tdev), l2t);
 		dst_release(dst);
 		goto reject;
@@ -1362,7 +1362,7 @@ static int pass_establish(struct t3cdev 
 	struct iwch_ep *ep = ctx;
 	struct cpl_pass_establish *req = cplhdr(skb);
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	ep->snd_seq = ntohl(req->snd_isn);
 	ep->rcv_seq = ntohl(req->rcv_isn);
 
@@ -1383,7 +1383,7 @@ static int peer_close(struct t3cdev *tde
 	int disconnect = 1;
 	int release = 0;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	dst_confirm(ep->dst);
 
 	spin_lock_irqsave(&ep->com.lock, flags);
@@ -1473,7 +1473,7 @@ static int peer_abort(struct t3cdev *tde
 	int state;
 
 	if (is_neg_adv_abort(req->status)) {
-		PDBG("%s neg_adv_abort ep %p tid %d\n", __FUNCTION__, ep,
+		PDBG("%s neg_adv_abort ep %p tid %d\n", __func__, ep,
 		     ep->hwtid);
 		t3_l2t_send_event(ep->com.tdev, ep->l2t);
 		return CPL_RET_BUF_DONE;
@@ -1489,7 +1489,7 @@ static int peer_abort(struct t3cdev *tde
 	}
 
 	state = state_read(&ep->com);
-	PDBG("%s ep %p state %u\n", __FUNCTION__, ep, state);
+	PDBG("%s ep %p state %u\n", __func__, ep, state);
 	switch (state) {
 	case CONNECTING:
 		break;
@@ -1528,14 +1528,14 @@ static int peer_abort(struct t3cdev *tde
 			if (ret)
 				printk(KERN_ERR MOD
 				       "%s - qp <- error failed!\n",
-				       __FUNCTION__);
+				       __func__);
 		}
 		peer_abort_upcall(ep);
 		break;
 	case ABORTING:
 		break;
 	case DEAD:
-		PDBG("%s PEER_ABORT IN DEAD STATE!!!!\n", __FUNCTION__);
+		PDBG("%s PEER_ABORT IN DEAD STATE!!!!\n", __func__);
 		return CPL_RET_BUF_DONE;
 	default:
 		BUG_ON(1);
@@ -1546,7 +1546,7 @@ static int peer_abort(struct t3cdev *tde
 	rpl_skb = get_skb(skb, sizeof(*rpl), GFP_KERNEL);
 	if (!rpl_skb) {
 		printk(KERN_ERR MOD "%s - cannot allocate skb!\n",
-		       __FUNCTION__);
+		       __func__);
 		dst_release(ep->dst);
 		l2t_release(L2DATA(ep->com.tdev), ep->l2t);
 		put_ep(&ep->com);
@@ -1573,7 +1573,7 @@ static int close_con_rpl(struct t3cdev *
 	unsigned long flags;
 	int release = 0;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	BUG_ON(!ep);
 
 	/* The cm_id may be null if we failed to connect */
@@ -1624,9 +1624,9 @@ static int terminate(struct t3cdev *tdev
 {
 	struct iwch_ep *ep = ctx;
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	skb_pull(skb, sizeof(struct cpl_rdma_terminate));
-	PDBG("%s saving %d bytes of term msg\n", __FUNCTION__, skb->len);
+	PDBG("%s saving %d bytes of term msg\n", __func__, skb->len);
 	skb_copy_from_linear_data(skb, ep->com.qp->attr.terminate_buffer,
 				  skb->len);
 	ep->com.qp->attr.terminate_msg_len = skb->len;
@@ -1639,13 +1639,13 @@ static int ec_status(struct t3cdev *tdev
 	struct cpl_rdma_ec_status *rep = cplhdr(skb);
 	struct iwch_ep *ep = ctx;
 
-	PDBG("%s ep %p tid %u status %d\n", __FUNCTION__, ep, ep->hwtid,
+	PDBG("%s ep %p tid %u status %d\n", __func__, ep, ep->hwtid,
 	     rep->status);
 	if (rep->status) {
 		struct iwch_qp_attributes attrs;
 
 		printk(KERN_ERR MOD "%s BAD CLOSE - Aborting tid %u\n",
-		       __FUNCTION__, ep->hwtid);
+		       __func__, ep->hwtid);
 		stop_ep_timer(ep);
 		attrs.next_state = IWCH_QP_STATE_ERROR;
 		iwch_modify_qp(ep->com.qp->rhp,
@@ -1663,7 +1663,7 @@ static void ep_timeout(unsigned long arg
 	unsigned long flags;
 
 	spin_lock_irqsave(&ep->com.lock, flags);
-	PDBG("%s ep %p tid %u state %d\n", __FUNCTION__, ep, ep->hwtid,
+	PDBG("%s ep %p tid %u state %d\n", __func__, ep, ep->hwtid,
 	     ep->com.state);
 	switch (ep->com.state) {
 	case MPA_REQ_SENT:
@@ -1693,7 +1693,7 @@ int iwch_reject_cr(struct iw_cm_id *cm_i
 {
 	int err;
 	struct iwch_ep *ep = to_ep(cm_id);
-	PDBG("%s ep %p tid %u\n", __FUNCTION__, ep, ep->hwtid);
+	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	if (state_read(&ep->com) == DEAD) {
 		put_ep(&ep->com);
@@ -1718,7 +1718,7 @@ int iwch_accept_cr(struct iw_cm_id *cm_i
 	struct iwch_dev *h = to_iwch_dev(cm_id->device);
 	struct iwch_qp *qp = get_qhp(h, conn_param->qpn);
 
-	PDBG("%s ep %p tid %u\n", __FUNCTION__, ep, ep->hwtid);
+	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 	if (state_read(&ep->com) == DEAD)
 		return -ECONNRESET;
 
@@ -1739,7 +1739,7 @@ int iwch_accept_cr(struct iw_cm_id *cm_i
 	ep->com.rpl_err = 0;
 	ep->ird = conn_param->ird;
 	ep->ord = conn_param->ord;
-	PDBG("%s %d ird %d ord %d\n", __FUNCTION__, __LINE__, ep->ird, ep->ord);
+	PDBG("%s %d ird %d ord %d\n", __func__, __LINE__, ep->ird, ep->ord);
 
 	get_ep(&ep->com);
 
@@ -1810,7 +1810,7 @@ int iwch_connect(struct iw_cm_id *cm_id,
 
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
-		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __func__);
 		err = -ENOMEM;
 		goto out;
 	}
@@ -1827,7 +1827,7 @@ int iwch_connect(struct iw_cm_id *cm_id,
 	ep->com.cm_id = cm_id;
 	ep->com.qp = get_qhp(h, conn_param->qpn);
 	BUG_ON(!ep->com.qp);
-	PDBG("%s qpn 0x%x qp %p cm_id %p\n", __FUNCTION__, conn_param->qpn,
+	PDBG("%s qpn 0x%x qp %p cm_id %p\n", __func__, conn_param->qpn,
 	     ep->com.qp, cm_id);
 
 	/*
@@ -1835,7 +1835,7 @@ int iwch_connect(struct iw_cm_id *cm_id,
 	 */
 	ep->atid = cxgb3_alloc_atid(h->rdev.t3cdev_p, &t3c_client, ep);
 	if (ep->atid == -1) {
-		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __func__);
 		err = -ENOMEM;
 		goto fail2;
 	}
@@ -1847,7 +1847,7 @@ int iwch_connect(struct iw_cm_id *cm_id,
 			cm_id->local_addr.sin_port,
 			cm_id->remote_addr.sin_port, IPTOS_LOWDELAY);
 	if (!rt) {
-		printk(KERN_ERR MOD "%s - cannot find route.\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot find route.\n", __func__);
 		err = -EHOSTUNREACH;
 		goto fail3;
 	}
@@ -1857,7 +1857,7 @@ int iwch_connect(struct iw_cm_id *cm_id,
 	ep->l2t = t3_l2t_get(ep->com.tdev, ep->dst->neighbour,
 			     ep->dst->neighbour->dev);
 	if (!ep->l2t) {
-		printk(KERN_ERR MOD "%s - cannot alloc l2e.\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc l2e.\n", __func__);
 		err = -ENOMEM;
 		goto fail4;
 	}
@@ -1894,11 +1894,11 @@ int iwch_create_listen(struct iw_cm_id *
 
 	ep = alloc_ep(sizeof(*ep), GFP_KERNEL);
 	if (!ep) {
-		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc ep.\n", __func__);
 		err = -ENOMEM;
 		goto fail1;
 	}
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 	ep->com.tdev = h->rdev.t3cdev_p;
 	cm_id->add_ref(cm_id);
 	ep->com.cm_id = cm_id;
@@ -1910,7 +1910,7 @@ int iwch_create_listen(struct iw_cm_id *
 	 */
 	ep->stid = cxgb3_alloc_stid(h->rdev.t3cdev_p, &t3c_client, ep);
 	if (ep->stid == -1) {
-		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __FUNCTION__);
+		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __func__);
 		err = -ENOMEM;
 		goto fail2;
 	}
@@ -1942,7 +1942,7 @@ int iwch_destroy_listen(struct iw_cm_id 
 	int err;
 	struct iwch_listen_ep *ep = to_listen_ep(cm_id);
 
-	PDBG("%s ep %p\n", __FUNCTION__, ep);
+	PDBG("%s ep %p\n", __func__, ep);
 
 	might_sleep();
 	state_set(&ep->com, DEAD);
@@ -1965,11 +1965,11 @@ int iwch_ep_disconnect(struct iwch_ep *e
 
 	spin_lock_irqsave(&ep->com.lock, flags);
 
-	PDBG("%s ep %p state %s, abrupt %d\n", __FUNCTION__, ep,
+	PDBG("%s ep %p state %s, abrupt %d\n", __func__, ep,
 	     states[ep->com.state], abrupt);
 
 	if (ep->com.state == DEAD) {
-		PDBG("%s already dead ep %p\n", __FUNCTION__, ep);
+		PDBG("%s already dead ep %p\n", __func__, ep);
 		goto out;
 	}
 
@@ -2020,7 +2020,7 @@ int iwch_ep_redirect(void *ctx, struct d
 	if (ep->dst != old)
 		return 0;
 
-	PDBG("%s ep %p redirect to dst %p l2t %p\n", __FUNCTION__, ep, new,
+	PDBG("%s ep %p redirect to dst %p l2t %p\n", __func__, ep, new,
 	     l2t);
 	dst_hold(new);
 	l2t_release(L2DATA(ep->com.tdev), ep->l2t);
diff -puN drivers/infiniband/hw/cxgb3/iwch_cm.h~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_cm.h
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.h~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_cm.h
@@ -54,13 +54,13 @@
 #define MPA_FLAGS_MASK		0xE0
 
 #define put_ep(ep) { \
-	PDBG("put_ep (via %s:%u) ep %p refcnt %d\n", __FUNCTION__, __LINE__,  \
+	PDBG("put_ep (via %s:%u) ep %p refcnt %d\n", __func__, __LINE__,  \
 	     ep, atomic_read(&((ep)->kref.refcount))); \
 	kref_put(&((ep)->kref), __free_ep); \
 }
 
 #define get_ep(ep) { \
-	PDBG("get_ep (via %s:%u) ep %p, refcnt %d\n", __FUNCTION__, __LINE__, \
+	PDBG("get_ep (via %s:%u) ep %p, refcnt %d\n", __func__, __LINE__, \
 	     ep, atomic_read(&((ep)->kref.refcount))); \
 	kref_get(&((ep)->kref));  \
 }
diff -puN drivers/infiniband/hw/cxgb3/iwch_cq.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_cq.c
--- a/drivers/infiniband/hw/cxgb3/iwch_cq.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_cq.c
@@ -67,7 +67,7 @@ static int iwch_poll_cq_one(struct iwch_
 	ret = cxio_poll_cq(wq, &(chp->cq), &cqe, &cqe_flushed, &cookie,
 				   &credit);
 	if (t3a_device(chp->rhp) && credit) {
-		PDBG("%s updating %d cq credits on id %d\n", __FUNCTION__,
+		PDBG("%s updating %d cq credits on id %d\n", __func__,
 		     credit, chp->cq.cqid);
 		cxio_hal_cq_op(&rhp->rdev, &chp->cq, CQ_CREDIT_UPDATE, credit);
 	}
@@ -83,7 +83,7 @@ static int iwch_poll_cq_one(struct iwch_
 	wc->vendor_err = CQE_STATUS(cqe);
 
 	PDBG("%s qpid 0x%x type %d opcode %d status 0x%x wrid hi 0x%x "
-	     "lo 0x%x cookie 0x%llx\n", __FUNCTION__,
+	     "lo 0x%x cookie 0x%llx\n", __func__,
 	     CQE_QPID(cqe), CQE_TYPE(cqe),
 	     CQE_OPCODE(cqe), CQE_STATUS(cqe), CQE_WRID_HI(cqe),
 	     CQE_WRID_LOW(cqe), (unsigned long long) cookie);
diff -puN drivers/infiniband/hw/cxgb3/iwch_ev.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_ev.c
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -52,7 +52,7 @@ static void post_qp_event(struct iwch_de
 
 	if (!qhp) {
 		printk(KERN_ERR "%s unaffiliated error 0x%x qpid 0x%x\n",
-		       __FUNCTION__, CQE_STATUS(rsp_msg->cqe),
+		       __func__, CQE_STATUS(rsp_msg->cqe),
 		       CQE_QPID(rsp_msg->cqe));
 		spin_unlock(&rnicp->lock);
 		return;
@@ -61,14 +61,14 @@ static void post_qp_event(struct iwch_de
 	if ((qhp->attr.state == IWCH_QP_STATE_ERROR) ||
 	    (qhp->attr.state == IWCH_QP_STATE_TERMINATE)) {
 		PDBG("%s AE received after RTS - "
-		     "qp state %d qpid 0x%x status 0x%x\n", __FUNCTION__,
+		     "qp state %d qpid 0x%x status 0x%x\n", __func__,
 		     qhp->attr.state, qhp->wq.qpid, CQE_STATUS(rsp_msg->cqe));
 		spin_unlock(&rnicp->lock);
 		return;
 	}
 
 	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
-	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __FUNCTION__,
+	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __func__,
 	       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
 	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
 	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
@@ -132,10 +132,10 @@ void iwch_ev_dispatch(struct cxio_rdev *
 	    (CQE_STATUS(rsp_msg->cqe) == 0)) {
 		if (SQ_TYPE(rsp_msg->cqe)) {
 			PDBG("%s QPID 0x%x ep %p disconnecting\n",
-			     __FUNCTION__, qhp->wq.qpid, qhp->ep);
+			     __func__, qhp->wq.qpid, qhp->ep);
 			iwch_ep_disconnect(qhp->ep, 0, GFP_ATOMIC);
 		} else {
-			PDBG("%s post REQ_ERR AE QPID 0x%x\n", __FUNCTION__,
+			PDBG("%s post REQ_ERR AE QPID 0x%x\n", __func__,
 			     qhp->wq.qpid);
 			post_qp_event(rnicp, chp, rsp_msg,
 				      IB_EVENT_QP_REQ_ERR, 0);
@@ -180,7 +180,7 @@ void iwch_ev_dispatch(struct cxio_rdev *
 	case TPT_ERR_INVALIDATE_SHARED_MR:
 	case TPT_ERR_INVALIDATE_MR_WITH_MW_BOUND:
 		printk(KERN_ERR "%s - CQE Err qpid 0x%x opcode %d status 0x%x "
-		       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __FUNCTION__,
+		       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __func__,
 		       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
 		       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
 		       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
diff -puN drivers/infiniband/hw/cxgb3/iwch_mem.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_mem.c
--- a/drivers/infiniband/hw/cxgb3/iwch_mem.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_mem.c
@@ -62,7 +62,7 @@ int iwch_register_mem(struct iwch_dev *r
 	mmid = stag >> 8;
 	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
 	insert_handle(rhp, &rhp->mmidr, mhp, mmid);
-	PDBG("%s mmid 0x%x mhp %p\n", __FUNCTION__, mmid, mhp);
+	PDBG("%s mmid 0x%x mhp %p\n", __func__, mmid, mhp);
 	return 0;
 }
 
@@ -96,7 +96,7 @@ int iwch_reregister_mem(struct iwch_dev 
 	mmid = stag >> 8;
 	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
 	insert_handle(rhp, &rhp->mmidr, mhp, mmid);
-	PDBG("%s mmid 0x%x mhp %p\n", __FUNCTION__, mmid, mhp);
+	PDBG("%s mmid 0x%x mhp %p\n", __func__, mmid, mhp);
 	return 0;
 }
 
@@ -163,7 +163,7 @@ int build_phys_page_list(struct ib_phys_
 			    ((u64) j << *shift));
 
 	PDBG("%s va 0x%llx mask 0x%llx shift %d len %lld pbl_size %d\n",
-	     __FUNCTION__, (unsigned long long) *iova_start,
+	     __func__, (unsigned long long) *iova_start,
 	     (unsigned long long) mask, *shift, (unsigned long long) *total_size,
 	     *npages);
 
diff -puN drivers/infiniband/hw/cxgb3/iwch_provider.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_provider.c
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -101,7 +101,7 @@ static int iwch_dealloc_ucontext(struct 
 	struct iwch_ucontext *ucontext = to_iwch_ucontext(context);
 	struct iwch_mm_entry *mm, *tmp;
 
-	PDBG("%s context %p\n", __FUNCTION__, context);
+	PDBG("%s context %p\n", __func__, context);
 	list_for_each_entry_safe(mm, tmp, &ucontext->mmaps, entry)
 		kfree(mm);
 	cxio_release_ucontext(&rhp->rdev, &ucontext->uctx);
@@ -115,7 +115,7 @@ static struct ib_ucontext *iwch_alloc_uc
 	struct iwch_ucontext *context;
 	struct iwch_dev *rhp = to_iwch_dev(ibdev);
 
-	PDBG("%s ibdev %p\n", __FUNCTION__, ibdev);
+	PDBG("%s ibdev %p\n", __func__, ibdev);
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return ERR_PTR(-ENOMEM);
@@ -129,7 +129,7 @@ static int iwch_destroy_cq(struct ib_cq 
 {
 	struct iwch_cq *chp;
 
-	PDBG("%s ib_cq %p\n", __FUNCTION__, ib_cq);
+	PDBG("%s ib_cq %p\n", __func__, ib_cq);
 	chp = to_iwch_cq(ib_cq);
 
 	remove_handle(chp->rhp, &chp->rhp->cqidr, chp->cq.cqid);
@@ -151,7 +151,7 @@ static struct ib_cq *iwch_create_cq(stru
 	struct iwch_create_cq_req ureq;
 	struct iwch_ucontext *ucontext = NULL;
 
-	PDBG("%s ib_dev %p entries %d\n", __FUNCTION__, ibdev, entries);
+	PDBG("%s ib_dev %p entries %d\n", __func__, ibdev, entries);
 	rhp = to_iwch_dev(ibdev);
 	chp = kzalloc(sizeof(*chp), GFP_KERNEL);
 	if (!chp)
@@ -233,7 +233,7 @@ static int iwch_resize_cq(struct ib_cq *
 	struct t3_cq oldcq, newcq;
 	int ret;
 
-	PDBG("%s ib_cq %p cqe %d\n", __FUNCTION__, cq, cqe);
+	PDBG("%s ib_cq %p cqe %d\n", __func__, cq, cqe);
 
 	/* We don't downsize... */
 	if (cqe <= cq->cqe)
@@ -281,7 +281,7 @@ static int iwch_resize_cq(struct ib_cq *
 	ret = cxio_destroy_cq(&chp->rhp->rdev, &oldcq);
 	if (ret) {
 		printk(KERN_ERR MOD "%s - cxio_destroy_cq failed %d\n",
-			__FUNCTION__, ret);
+			__func__, ret);
 	}
 
 	/* add user hooks here */
@@ -316,7 +316,7 @@ static int iwch_arm_cq(struct ib_cq *ibc
 		chp->cq.rptr = rptr;
 	} else
 		spin_lock_irqsave(&chp->lock, flag);
-	PDBG("%s rptr 0x%x\n", __FUNCTION__, chp->cq.rptr);
+	PDBG("%s rptr 0x%x\n", __func__, chp->cq.rptr);
 	err = cxio_hal_cq_op(&rhp->rdev, &chp->cq, cq_op, 0);
 	spin_unlock_irqrestore(&chp->lock, flag);
 	if (err < 0)
@@ -337,7 +337,7 @@ static int iwch_mmap(struct ib_ucontext 
 	struct iwch_ucontext *ucontext;
 	u64 addr;
 
-	PDBG("%s pgoff 0x%lx key 0x%x len %d\n", __FUNCTION__, vma->vm_pgoff,
+	PDBG("%s pgoff 0x%lx key 0x%x len %d\n", __func__, vma->vm_pgoff,
 	     key, len);
 
 	if (vma->vm_start & (PAGE_SIZE-1)) {
@@ -390,7 +390,7 @@ static int iwch_deallocate_pd(struct ib_
 
 	php = to_iwch_pd(pd);
 	rhp = php->rhp;
-	PDBG("%s ibpd %p pdid 0x%x\n", __FUNCTION__, pd, php->pdid);
+	PDBG("%s ibpd %p pdid 0x%x\n", __func__, pd, php->pdid);
 	cxio_hal_put_pdid(rhp->rdev.rscp, php->pdid);
 	kfree(php);
 	return 0;
@@ -404,7 +404,7 @@ static struct ib_pd *iwch_allocate_pd(st
 	u32 pdid;
 	struct iwch_dev *rhp;
 
-	PDBG("%s ibdev %p\n", __FUNCTION__, ibdev);
+	PDBG("%s ibdev %p\n", __func__, ibdev);
 	rhp = (struct iwch_dev *) ibdev;
 	pdid = cxio_hal_get_pdid(rhp->rdev.rscp);
 	if (!pdid)
@@ -422,7 +422,7 @@ static struct ib_pd *iwch_allocate_pd(st
 			return ERR_PTR(-EFAULT);
 		}
 	}
-	PDBG("%s pdid 0x%0x ptr 0x%p\n", __FUNCTION__, pdid, php);
+	PDBG("%s pdid 0x%0x ptr 0x%p\n", __func__, pdid, php);
 	return &php->ibpd;
 }
 
@@ -432,7 +432,7 @@ static int iwch_dereg_mr(struct ib_mr *i
 	struct iwch_mr *mhp;
 	u32 mmid;
 
-	PDBG("%s ib_mr %p\n", __FUNCTION__, ib_mr);
+	PDBG("%s ib_mr %p\n", __func__, ib_mr);
 	/* There can be no memory windows */
 	if (atomic_read(&ib_mr->usecnt))
 		return -EINVAL;
@@ -447,7 +447,7 @@ static int iwch_dereg_mr(struct ib_mr *i
 		kfree((void *) (unsigned long) mhp->kva);
 	if (mhp->umem)
 		ib_umem_release(mhp->umem);
-	PDBG("%s mmid 0x%x ptr %p\n", __FUNCTION__, mmid, mhp);
+	PDBG("%s mmid 0x%x ptr %p\n", __func__, mmid, mhp);
 	kfree(mhp);
 	return 0;
 }
@@ -467,7 +467,7 @@ static struct ib_mr *iwch_register_phys_
 	struct iwch_mr *mhp;
 	int ret;
 
-	PDBG("%s ib_pd %p\n", __FUNCTION__, pd);
+	PDBG("%s ib_pd %p\n", __func__, pd);
 	php = to_iwch_pd(pd);
 	rhp = php->rhp;
 
@@ -531,7 +531,7 @@ static int iwch_reregister_phys_mem(stru
 	int npages;
 	int ret;
 
-	PDBG("%s ib_mr %p ib_pd %p\n", __FUNCTION__, mr, pd);
+	PDBG("%s ib_mr %p ib_pd %p\n", __func__, mr, pd);
 
 	/* There can be no memory windows */
 	if (atomic_read(&mr->usecnt))
@@ -594,7 +594,7 @@ static struct ib_mr *iwch_reg_user_mr(st
 	struct iwch_mr *mhp;
 	struct iwch_reg_user_mr_resp uresp;
 
-	PDBG("%s ib_pd %p\n", __FUNCTION__, pd);
+	PDBG("%s ib_pd %p\n", __func__, pd);
 
 	php = to_iwch_pd(pd);
 	rhp = php->rhp;
@@ -649,7 +649,7 @@ static struct ib_mr *iwch_reg_user_mr(st
 	if (udata && !t3a_device(rhp)) {
 		uresp.pbl_addr = (mhp->attr.pbl_addr -
 	                         rhp->rdev.rnic_info.pbl_base) >> 3;
-		PDBG("%s user resp pbl_addr 0x%x\n", __FUNCTION__,
+		PDBG("%s user resp pbl_addr 0x%x\n", __func__,
 		     uresp.pbl_addr);
 
 		if (ib_copy_to_udata(udata, &uresp, sizeof (uresp))) {
@@ -673,7 +673,7 @@ static struct ib_mr *iwch_get_dma_mr(str
 	u64 kva;
 	struct ib_mr *ibmr;
 
-	PDBG("%s ib_pd %p\n", __FUNCTION__, pd);
+	PDBG("%s ib_pd %p\n", __func__, pd);
 
 	/*
 	 * T3 only supports 32 bits of size.
@@ -710,7 +710,7 @@ static struct ib_mw *iwch_alloc_mw(struc
 	mhp->attr.stag = stag;
 	mmid = (stag) >> 8;
 	insert_handle(rhp, &rhp->mmidr, mhp, mmid);
-	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __FUNCTION__, mmid, mhp, stag);
+	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
 	return &(mhp->ibmw);
 }
 
@@ -726,7 +726,7 @@ static int iwch_dealloc_mw(struct ib_mw 
 	cxio_deallocate_window(&rhp->rdev, mhp->attr.stag);
 	remove_handle(rhp, &rhp->mmidr, mmid);
 	kfree(mhp);
-	PDBG("%s ib_mw %p mmid 0x%x ptr %p\n", __FUNCTION__, mw, mmid, mhp);
+	PDBG("%s ib_mw %p mmid 0x%x ptr %p\n", __func__, mw, mmid, mhp);
 	return 0;
 }
 
@@ -754,7 +754,7 @@ static int iwch_destroy_qp(struct ib_qp 
 	cxio_destroy_qp(&rhp->rdev, &qhp->wq,
 			ucontext ? &ucontext->uctx : &rhp->rdev.uctx);
 
-	PDBG("%s ib_qp %p qpid 0x%0x qhp %p\n", __FUNCTION__,
+	PDBG("%s ib_qp %p qpid 0x%0x qhp %p\n", __func__,
 	     ib_qp, qhp->wq.qpid, qhp);
 	kfree(qhp);
 	return 0;
@@ -773,7 +773,7 @@ static struct ib_qp *iwch_create_qp(stru
 	int wqsize, sqsize, rqsize;
 	struct iwch_ucontext *ucontext;
 
-	PDBG("%s ib_pd %p\n", __FUNCTION__, pd);
+	PDBG("%s ib_pd %p\n", __func__, pd);
 	if (attrs->qp_type != IB_QPT_RC)
 		return ERR_PTR(-EINVAL);
 	php = to_iwch_pd(pd);
@@ -805,7 +805,7 @@ static struct ib_qp *iwch_create_qp(stru
 	 */
 	sqsize = roundup_pow_of_two(attrs->cap.max_send_wr);
 	wqsize = roundup_pow_of_two(rqsize + sqsize);
-	PDBG("%s wqsize %d sqsize %d rqsize %d\n", __FUNCTION__,
+	PDBG("%s wqsize %d sqsize %d rqsize %d\n", __func__,
 	     wqsize, sqsize, rqsize);
 	qhp = kzalloc(sizeof(*qhp), GFP_KERNEL);
 	if (!qhp)
@@ -895,7 +895,7 @@ static struct ib_qp *iwch_create_qp(stru
 	init_timer(&(qhp->timer));
 	PDBG("%s sq_num_entries %d, rq_num_entries %d "
 	     "qpid 0x%0x qhp %p dma_addr 0x%llx size %d\n",
-	     __FUNCTION__, qhp->attr.sq_num_entries, qhp->attr.rq_num_entries,
+	     __func__, qhp->attr.sq_num_entries, qhp->attr.rq_num_entries,
 	     qhp->wq.qpid, qhp, (unsigned long long) qhp->wq.dma_addr,
 	     1 << qhp->wq.size_log2);
 	return &qhp->ibqp;
@@ -909,7 +909,7 @@ static int iwch_ib_modify_qp(struct ib_q
 	enum iwch_qp_attr_mask mask = 0;
 	struct iwch_qp_attributes attrs;
 
-	PDBG("%s ib_qp %p\n", __FUNCTION__, ibqp);
+	PDBG("%s ib_qp %p\n", __func__, ibqp);
 
 	/* iwarp does not support the RTR state */
 	if ((attr_mask & IB_QP_STATE) && (attr->qp_state == IB_QPS_RTR))
@@ -942,20 +942,20 @@ static int iwch_ib_modify_qp(struct ib_q
 
 void iwch_qp_add_ref(struct ib_qp *qp)
 {
-	PDBG("%s ib_qp %p\n", __FUNCTION__, qp);
+	PDBG("%s ib_qp %p\n", __func__, qp);
 	atomic_inc(&(to_iwch_qp(qp)->refcnt));
 }
 
 void iwch_qp_rem_ref(struct ib_qp *qp)
 {
-	PDBG("%s ib_qp %p\n", __FUNCTION__, qp);
+	PDBG("%s ib_qp %p\n", __func__, qp);
 	if (atomic_dec_and_test(&(to_iwch_qp(qp)->refcnt)))
 	        wake_up(&(to_iwch_qp(qp)->wait));
 }
 
 static struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn)
 {
-	PDBG("%s ib_dev %p qpn 0x%x\n", __FUNCTION__, dev, qpn);
+	PDBG("%s ib_dev %p qpn 0x%x\n", __func__, dev, qpn);
 	return (struct ib_qp *)get_qhp(to_iwch_dev(dev), qpn);
 }
 
@@ -963,7 +963,7 @@ static struct ib_qp *iwch_get_qp(struct 
 static int iwch_query_pkey(struct ib_device *ibdev,
 			   u8 port, u16 index, u16 * pkey)
 {
-	PDBG("%s ibdev %p\n", __FUNCTION__, ibdev);
+	PDBG("%s ibdev %p\n", __func__, ibdev);
 	*pkey = 0;
 	return 0;
 }
@@ -974,7 +974,7 @@ static int iwch_query_gid(struct ib_devi
 	struct iwch_dev *dev;
 
 	PDBG("%s ibdev %p, port %d, index %d, gid %p\n",
-	       __FUNCTION__, ibdev, port, index, gid);
+	       __func__, ibdev, port, index, gid);
 	dev = to_iwch_dev(ibdev);
 	BUG_ON(port == 0 || port > 2);
 	memset(&(gid->raw[0]), 0, sizeof(gid->raw));
@@ -987,7 +987,7 @@ static int iwch_query_device(struct ib_d
 {
 
 	struct iwch_dev *dev;
-	PDBG("%s ibdev %p\n", __FUNCTION__, ibdev);
+	PDBG("%s ibdev %p\n", __func__, ibdev);
 
 	dev = to_iwch_dev(ibdev);
 	memset(props, 0, sizeof *props);
@@ -1014,7 +1014,7 @@ static int iwch_query_device(struct ib_d
 static int iwch_query_port(struct ib_device *ibdev,
 			   u8 port, struct ib_port_attr *props)
 {
-	PDBG("%s ibdev %p\n", __FUNCTION__, ibdev);
+	PDBG("%s ibdev %p\n", __func__, ibdev);
 	props->max_mtu = IB_MTU_4096;
 	props->lid = 0;
 	props->lmc = 0;
@@ -1043,7 +1043,7 @@ static ssize_t show_rev(struct device *d
 {
 	struct iwch_dev *iwch_dev = container_of(dev, struct iwch_dev,
 						 ibdev.dev);
-	PDBG("%s dev 0x%p\n", __FUNCTION__, dev);
+	PDBG("%s dev 0x%p\n", __func__, dev);
 	return sprintf(buf, "%d\n", iwch_dev->rdev.t3cdev_p->type);
 }
 
@@ -1054,7 +1054,7 @@ static ssize_t show_fw_ver(struct device
 	struct ethtool_drvinfo info;
 	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
 
-	PDBG("%s dev 0x%p\n", __FUNCTION__, dev);
+	PDBG("%s dev 0x%p\n", __func__, dev);
 	lldev->ethtool_ops->get_drvinfo(lldev, &info);
 	return sprintf(buf, "%s\n", info.fw_version);
 }
@@ -1067,7 +1067,7 @@ static ssize_t show_hca(struct device *d
 	struct ethtool_drvinfo info;
 	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
 
-	PDBG("%s dev 0x%p\n", __FUNCTION__, dev);
+	PDBG("%s dev 0x%p\n", __func__, dev);
 	lldev->ethtool_ops->get_drvinfo(lldev, &info);
 	return sprintf(buf, "%s\n", info.driver);
 }
@@ -1077,7 +1077,7 @@ static ssize_t show_board(struct device 
 {
 	struct iwch_dev *iwch_dev = container_of(dev, struct iwch_dev,
 						 ibdev.dev);
-	PDBG("%s dev 0x%p\n", __FUNCTION__, dev);
+	PDBG("%s dev 0x%p\n", __func__, dev);
 	return sprintf(buf, "%x.%x\n", iwch_dev->rdev.rnic_info.pdev->vendor,
 		       iwch_dev->rdev.rnic_info.pdev->device);
 }
@@ -1099,7 +1099,7 @@ int iwch_register_device(struct iwch_dev
 	int ret;
 	int i;
 
-	PDBG("%s iwch_dev %p\n", __FUNCTION__, dev);
+	PDBG("%s iwch_dev %p\n", __func__, dev);
 	strlcpy(dev->ibdev.name, "cxgb3_%d", IB_DEVICE_NAME_MAX);
 	memset(&dev->ibdev.node_guid, 0, sizeof(dev->ibdev.node_guid));
 	memcpy(&dev->ibdev.node_guid, dev->rdev.t3cdev_p->lldev->dev_addr, 6);
@@ -1203,7 +1203,7 @@ void iwch_unregister_device(struct iwch_
 {
 	int i;
 
-	PDBG("%s iwch_dev %p\n", __FUNCTION__, dev);
+	PDBG("%s iwch_dev %p\n", __func__, dev);
 	for (i = 0; i < ARRAY_SIZE(iwch_class_attributes); ++i)
 		device_remove_file(&dev->ibdev.dev,
 				   iwch_class_attributes[i]);
diff -puN drivers/infiniband/hw/cxgb3/iwch_provider.h~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_provider.h
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -213,7 +213,7 @@ static inline struct iwch_mm_entry *remo
 		if (mm->key == key && mm->len == len) {
 			list_del_init(&mm->entry);
 			spin_unlock(&ucontext->mmap_lock);
-			PDBG("%s key 0x%x addr 0x%llx len %d\n", __FUNCTION__,
+			PDBG("%s key 0x%x addr 0x%llx len %d\n", __func__,
 			     key, (unsigned long long) mm->addr, mm->len);
 			return mm;
 		}
@@ -226,7 +226,7 @@ static inline void insert_mmap(struct iw
 			       struct iwch_mm_entry *mm)
 {
 	spin_lock(&ucontext->mmap_lock);
-	PDBG("%s key 0x%x addr 0x%llx len %d\n", __FUNCTION__,
+	PDBG("%s key 0x%x addr 0x%llx len %d\n", __func__,
 	     mm->key, (unsigned long long) mm->addr, mm->len);
 	list_add_tail(&mm->entry, &ucontext->mmaps);
 	spin_unlock(&ucontext->mmap_lock);
diff -puN drivers/infiniband/hw/cxgb3/iwch_qp.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/cxgb3/iwch_qp.c
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -168,30 +168,30 @@ static int iwch_sgl2pbl_map(struct iwch_
 
 		mhp = get_mhp(rhp, (sg_list[i].lkey) >> 8);
 		if (!mhp) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
+			PDBG("%s %d\n", __func__, __LINE__);
 			return -EIO;
 		}
 		if (!mhp->attr.state) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
+			PDBG("%s %d\n", __func__, __LINE__);
 			return -EIO;
 		}
 		if (mhp->attr.zbva) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
+			PDBG("%s %d\n", __func__, __LINE__);
 			return -EIO;
 		}
 
 		if (sg_list[i].addr < mhp->attr.va_fbo) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
+			PDBG("%s %d\n", __func__, __LINE__);
 			return -EINVAL;
 		}
 		if (sg_list[i].addr + ((u64) sg_list[i].length) <
 		    sg_list[i].addr) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
+			PDBG("%s %d\n", __func__, __LINE__);
 			return -EINVAL;
 		}
 		if (sg_list[i].addr + ((u64) sg_list[i].length) >
 		    mhp->attr.va_fbo + ((u64) mhp->attr.len)) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
+			PDBG("%s %d\n", __func__, __LINE__);
 			return -EINVAL;
 		}
 		offset = sg_list[i].addr - mhp->attr.va_fbo;
@@ -290,7 +290,7 @@ int iwch_post_send(struct ib_qp *ibqp, s
 				qhp->wq.oldest_read = sqp;
 			break;
 		default:
-			PDBG("%s post of type=%d TBD!\n", __FUNCTION__,
+			PDBG("%s post of type=%d TBD!\n", __func__,
 			     wr->opcode);
 			err = -EINVAL;
 		}
@@ -309,7 +309,7 @@ int iwch_post_send(struct ib_qp *ibqp, s
 			       Q_GENBIT(qhp->wq.wptr, qhp->wq.size_log2),
 			       0, t3_wr_flit_cnt);
 		PDBG("%s cookie 0x%llx wq idx 0x%x swsq idx %ld opcode %d\n",
-		     __FUNCTION__, (unsigned long long) wr->wr_id, idx,
+		     __func__, (unsigned long long) wr->wr_id, idx,
 		     Q_PTR2IDX(qhp->wq.sq_wptr, qhp->wq.sq_size_log2),
 		     sqp->opcode);
 		wr = wr->next;
@@ -361,7 +361,7 @@ int iwch_post_receive(struct ib_qp *ibqp
 			       Q_GENBIT(qhp->wq.wptr, qhp->wq.size_log2),
 			       0, sizeof(struct t3_receive_wr) >> 3);
 		PDBG("%s cookie 0x%llx idx 0x%x rq_wptr 0x%x rw_rptr 0x%x "
-		     "wqe %p \n", __FUNCTION__, (unsigned long long) wr->wr_id,
+		     "wqe %p \n", __func__, (unsigned long long) wr->wr_id,
 		     idx, qhp->wq.rq_wptr, qhp->wq.rq_rptr, wqe);
 		++(qhp->wq.rq_wptr);
 		++(qhp->wq.wptr);
@@ -407,7 +407,7 @@ int iwch_bind_mw(struct ib_qp *qp,
 		return -ENOMEM;
 	}
 	idx = Q_PTR2IDX(qhp->wq.wptr, qhp->wq.size_log2);
-	PDBG("%s: idx 0x%0x, mw 0x%p, mw_bind 0x%p\n", __FUNCTION__, idx,
+	PDBG("%s: idx 0x%0x, mw 0x%p, mw_bind 0x%p\n", __func__, idx,
 	     mw, mw_bind);
 	wqe = (union t3_wr *) (qhp->wq.queue + idx);
 
@@ -595,10 +595,10 @@ int iwch_post_terminate(struct iwch_qp *
 	struct terminate_message *term;
 	struct sk_buff *skb;
 
-	PDBG("%s %d\n", __FUNCTION__, __LINE__);
+	PDBG("%s %d\n", __func__, __LINE__);
 	skb = alloc_skb(40, GFP_ATOMIC);
 	if (!skb) {
-		printk(KERN_ERR "%s cannot send TERMINATE!\n", __FUNCTION__);
+		printk(KERN_ERR "%s cannot send TERMINATE!\n", __func__);
 		return -ENOMEM;
 	}
 	wqe = (union t3_wr *)skb_put(skb, 40);
@@ -629,7 +629,7 @@ static void __flush_qp(struct iwch_qp *q
 	rchp = get_chp(qhp->rhp, qhp->attr.rcq);
 	schp = get_chp(qhp->rhp, qhp->attr.scq);
 
-	PDBG("%s qhp %p rchp %p schp %p\n", __FUNCTION__, qhp, rchp, schp);
+	PDBG("%s qhp %p rchp %p schp %p\n", __func__, qhp, rchp, schp);
 	/* take a ref on the qhp since we must release the lock */
 	atomic_inc(&qhp->refcnt);
 	spin_unlock_irqrestore(&qhp->lock, *flag);
@@ -720,11 +720,11 @@ static int rdma_init(struct iwch_dev *rh
 	init_attr.flags |= capable(CAP_NET_BIND_SERVICE) ? PRIV_QP : 0;
 	init_attr.irs = qhp->ep->rcv_seq;
 	PDBG("%s init_attr.rq_addr 0x%x init_attr.rq_size = %d "
-	     "flags 0x%x qpcaps 0x%x\n", __FUNCTION__,
+	     "flags 0x%x qpcaps 0x%x\n", __func__,
 	     init_attr.rq_addr, init_attr.rq_size,
 	     init_attr.flags, init_attr.qpcaps);
 	ret = cxio_rdma_init(&rhp->rdev, &init_attr);
-	PDBG("%s ret %d\n", __FUNCTION__, ret);
+	PDBG("%s ret %d\n", __func__, ret);
 	return ret;
 }
 
@@ -742,7 +742,7 @@ int iwch_modify_qp(struct iwch_dev *rhp,
 	int free = 0;
 	struct iwch_ep *ep = NULL;
 
-	PDBG("%s qhp %p qpid 0x%x ep %p state %d -> %d\n", __FUNCTION__,
+	PDBG("%s qhp %p qpid 0x%x ep %p state %d -> %d\n", __func__,
 	     qhp, qhp->wq.qpid, qhp->ep, qhp->attr.state,
 	     (mask & IWCH_QP_ATTR_NEXT_STATE) ? attrs->next_state : -1);
 
@@ -899,14 +899,14 @@ int iwch_modify_qp(struct iwch_dev *rhp,
 		break;
 	default:
 		printk(KERN_ERR "%s in a bad state %d\n",
-		       __FUNCTION__, qhp->attr.state);
+		       __func__, qhp->attr.state);
 		ret = -EINVAL;
 		goto err;
 		break;
 	}
 	goto out;
 err:
-	PDBG("%s disassociating ep %p qpid 0x%x\n", __FUNCTION__, qhp->ep,
+	PDBG("%s disassociating ep %p qpid 0x%x\n", __func__, qhp->ep,
 	     qhp->wq.qpid);
 
 	/* disassociate the LLP connection */
@@ -939,7 +939,7 @@ out:
 	if (free)
 		put_ep(&ep->com);
 
-	PDBG("%s exit state %d\n", __FUNCTION__, qhp->attr.state);
+	PDBG("%s exit state %d\n", __func__, qhp->attr.state);
 	return ret;
 }
 
diff -puN drivers/infiniband/hw/ehca/ehca_tools.h~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/ehca/ehca_tools.h
--- a/drivers/infiniband/hw/ehca/ehca_tools.h~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -73,37 +73,37 @@ extern int ehca_debug_level;
 		if (unlikely(ehca_debug_level)) \
 			dev_printk(KERN_DEBUG, (ib_dev)->dma_device, \
 				   "PU%04x EHCA_DBG:%s " format "\n", \
-				   raw_smp_processor_id(), __FUNCTION__, \
+				   raw_smp_processor_id(), __func__, \
 				   ## arg); \
 	} while (0)
 
 #define ehca_info(ib_dev, format, arg...) \
 	dev_info((ib_dev)->dma_device, "PU%04x EHCA_INFO:%s " format "\n", \
-		 raw_smp_processor_id(), __FUNCTION__, ## arg)
+		 raw_smp_processor_id(), __func__, ## arg)
 
 #define ehca_warn(ib_dev, format, arg...) \
 	dev_warn((ib_dev)->dma_device, "PU%04x EHCA_WARN:%s " format "\n", \
-		 raw_smp_processor_id(), __FUNCTION__, ## arg)
+		 raw_smp_processor_id(), __func__, ## arg)
 
 #define ehca_err(ib_dev, format, arg...) \
 	dev_err((ib_dev)->dma_device, "PU%04x EHCA_ERR:%s " format "\n", \
-		raw_smp_processor_id(), __FUNCTION__, ## arg)
+		raw_smp_processor_id(), __func__, ## arg)
 
 /* use this one only if no ib_dev available */
 #define ehca_gen_dbg(format, arg...) \
 	do { \
 		if (unlikely(ehca_debug_level)) \
 			printk(KERN_DEBUG "PU%04x EHCA_DBG:%s " format "\n", \
-			       raw_smp_processor_id(), __FUNCTION__, ## arg); \
+			       raw_smp_processor_id(), __func__, ## arg); \
 	} while (0)
 
 #define ehca_gen_warn(format, arg...) \
 	printk(KERN_INFO "PU%04x EHCA_WARN:%s " format "\n", \
-	       raw_smp_processor_id(), __FUNCTION__, ## arg)
+	       raw_smp_processor_id(), __func__, ## arg)
 
 #define ehca_gen_err(format, arg...) \
 	printk(KERN_ERR "PU%04x EHCA_ERR:%s " format "\n", \
-	       raw_smp_processor_id(), __FUNCTION__, ## arg)
+	       raw_smp_processor_id(), __func__, ## arg)
 
 /**
  * ehca_dmp - printk a memory block, whose length is n*8 bytes.
@@ -118,7 +118,7 @@ extern int ehca_debug_level;
 		for (x = 0; x < l; x += 16) { \
 			printk(KERN_INFO "EHCA_DMP:%s " format \
 			       " adr=%p ofs=%04x %016lx %016lx\n", \
-			       __FUNCTION__, ##args, deb, x, \
+			       __func__, ##args, deb, x, \
 			       *((u64 *)&deb[0]), *((u64 *)&deb[8])); \
 			deb += 16; \
 		} \
diff -puN drivers/infiniband/hw/nes/nes.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes.c
--- a/drivers/infiniband/hw/nes/nes.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes.c
@@ -303,7 +303,7 @@ void nes_rem_ref(struct ib_qp *ibqp)
 
 	if (atomic_read(&nesqp->refcount) == 0) {
 		printk(KERN_INFO PFX "%s: Reference count already 0 for QP%d, last aeq = 0x%04X.\n",
-				__FUNCTION__, ibqp->qp_num, nesqp->last_aeq);
+				__func__, ibqp->qp_num, nesqp->last_aeq);
 		BUG();
 	}
 
diff -puN drivers/infiniband/hw/nes/nes.h~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes.h
--- a/drivers/infiniband/hw/nes/nes.h~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes.h
@@ -143,12 +143,12 @@
 #ifdef CONFIG_INFINIBAND_NES_DEBUG
 #define nes_debug(level, fmt, args...) \
 	if (level & nes_debug_level) \
-		printk(KERN_ERR PFX "%s[%u]: " fmt, __FUNCTION__, __LINE__, ##args)
+		printk(KERN_ERR PFX "%s[%u]: " fmt, __func__, __LINE__, ##args)
 
 #define assert(expr)                                                \
 if (!(expr)) {                                                       \
 	printk(KERN_ERR PFX "Assertion failed! %s, %s, %s, line %d\n",  \
-		   #expr, __FILE__, __FUNCTION__, __LINE__);                \
+		   #expr, __FILE__, __func__, __LINE__);                \
 }
 
 #define NES_EVENT_TIMEOUT   1200000
@@ -403,7 +403,7 @@ static inline int nes_alloc_resource(str
 	if (resource_num >= max_resources) {
 		resource_num = find_first_zero_bit(resource_array, max_resources);
 		if (resource_num >= max_resources) {
-			printk(KERN_ERR PFX "%s: No available resourcess.\n", __FUNCTION__);
+			printk(KERN_ERR PFX "%s: No available resourcess.\n", __func__);
 			spin_unlock_irqrestore(&nesadapter->resource_lock, flags);
 			return -EMFILE;
 		}
diff -puN drivers/infiniband/hw/nes/nes_cm.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -1013,7 +1013,7 @@ static void nes_addr_send_arp(u32 dst_ip
 	fl.nl_u.ip4_u.daddr = htonl(dst_ip);
 	if (ip_route_output_key(&init_net, &rt, &fl)) {
 		printk("%s: ip_route_output_key failed for 0x%08X\n",
-				__FUNCTION__, dst_ip);
+				__func__, dst_ip);
 		return;
 	}
 
@@ -1238,7 +1238,7 @@ static int process_options(struct nes_cm
 				continue;
 			case OPTION_NUMBER_MSS:
 				nes_debug(NES_DBG_CM, "%s: MSS Length: %d Offset: %d Size: %d\n",
-						__FUNCTION__,
+						__func__,
 						all_options->as_mss.length, offset, optionsize);
 				got_mss_option = 1;
 				if (all_options->as_mss.length != 4) {
@@ -1359,7 +1359,7 @@ int process_packet(struct nes_cm_node *c
 	if (optionsize) {
 		u8 *optionsloc = (u8 *)&tcph[1];
 		if (process_options(cm_node, optionsloc, optionsize, (u32)tcph->syn)) {
-			nes_debug(NES_DBG_CM, "%s: Node %p, Sending RESET\n", __FUNCTION__, cm_node);
+			nes_debug(NES_DBG_CM, "%s: Node %p, Sending RESET\n", __func__, cm_node);
 			send_reset(cm_node);
 			if (cm_node->state != NES_CM_STATE_SYN_SENT)
 			rem_ref_cm_node(cm_core, cm_node);
@@ -2481,7 +2481,7 @@ int nes_accept(struct iw_cm_id *cm_id, s
 	}
 	if (ret)
 		printk("%s[%u] OFA CM event_handler returned, ret=%d\n",
-				__FUNCTION__, __LINE__, ret);
+				__func__, __LINE__, ret);
 
 	return 0;
 }
@@ -2649,7 +2649,7 @@ int nes_create_listen(struct iw_cm_id *c
 	cm_node = g_cm_core->api->listen(g_cm_core, nesvnic, &cm_info);
 	if (!cm_node) {
 		printk("%s[%u] Error returned from listen API call\n",
-				__FUNCTION__, __LINE__);
+				__func__, __LINE__);
 		return -ENOMEM;
 	}
 
@@ -2863,7 +2863,7 @@ void cm_event_connected(struct nes_cm_ev
 
 	if (ret)
 		printk("%s[%u] OFA CM event_handler returned, ret=%d\n",
-				__FUNCTION__, __LINE__, ret);
+				__func__, __LINE__, ret);
 	nes_debug(NES_DBG_CM, "Exiting connect thread for QP%u. jiffies = %lu\n",
 			nesqp->hwqp.qp_id, jiffies );
 
@@ -2918,7 +2918,7 @@ void cm_event_connect_error(struct nes_c
 	nes_debug(NES_DBG_CM, "OFA CM event_handler returned, ret=%d\n", ret);
 	if (ret)
 		printk("%s[%u] OFA CM event_handler returned, ret=%d\n",
-				__FUNCTION__, __LINE__, ret);
+				__func__, __LINE__, ret);
 	nes_rem_ref(&nesqp->ibqp);
 		cm_id->rem_ref(cm_id);
 
@@ -3006,7 +3006,7 @@ void cm_event_mpa_req(struct nes_cm_even
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	if (ret)
 		printk("%s[%u] OFA CM event_handler returned, ret=%d\n",
-				__FUNCTION__, __LINE__, ret);
+				__func__, __LINE__, ret);
 
 	return;
 }
diff -puN drivers/infiniband/hw/nes/nes_hw.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes_hw.c
--- a/drivers/infiniband/hw/nes/nes_hw.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes_hw.c
@@ -370,7 +370,7 @@ struct nes_adapter *nes_init_adapter(str
 		nesadapter->et_use_adaptive_rx_coalesce = 1;
 		nesadapter->timer_int_limit = NES_TIMER_INT_LIMIT_DYNAMIC;
 		nesadapter->et_rx_coalesce_usecs_irq = 0;
-		printk(PFX "%s: Using Adaptive Interrupt Moderation\n", __FUNCTION__);
+		printk(PFX "%s: Using Adaptive Interrupt Moderation\n", __func__);
 	}
 	/* Setup and enable the periodic timer */
 	if (nesadapter->et_rx_coalesce_usecs_irq)
@@ -572,7 +572,7 @@ struct nes_adapter *nes_init_adapter(str
 		if (vendor_id == 0xffff)
 			break;
 	}
-	nes_debug(NES_DBG_INIT, "%s %d functions found for %s.\n", __FUNCTION__,
+	nes_debug(NES_DBG_INIT, "%s %d functions found for %s.\n", __func__,
 		func_index, pci_name(nesdev->pcidev));
 	nesadapter->adapter_fcn_count = func_index;
 
@@ -739,7 +739,7 @@ int nes_init_serdes(struct nes_device *n
 				& 0x0000000f)) != 0x0000000f) && (i++ < 5000))
 				mdelay(1);
 			if (i >= 5000) {
-				printk("%s: Init: serdes 1 not ready, status=%x\n", __FUNCTION__, u32temp);
+				printk("%s: Init: serdes 1 not ready, status=%x\n", __func__, u32temp);
 				/* return 1; */
 			}
 			nes_write_indexed(nesdev, NES_IDX_ETH_SERDES_TX_EMP1, 0x000bdef7);
@@ -1204,7 +1204,7 @@ int nes_init_phy(struct nes_device *nesd
 	if (nesadapter->OneG_Mode) {
 		nes_debug(NES_DBG_PHY, "1G PHY, mac_index = %d.\n", mac_index);
 		if (nesadapter->phy_type[mac_index] == NES_PHY_TYPE_1G) {
-			printk(PFX "%s: Programming mdc config for 1G\n", __FUNCTION__);
+			printk(PFX "%s: Programming mdc config for 1G\n", __func__);
 			tx_config = nes_read_indexed(nesdev, NES_IDX_MAC_TX_CONFIG);
 			tx_config |= 0x04;
 			nes_write_indexed(nesdev, NES_IDX_MAC_TX_CONFIG, tx_config);
@@ -1358,7 +1358,7 @@ static void nes_replenish_nic_rq(struct 
 static void nes_rq_wqes_timeout(unsigned long parm)
 {
 	struct nes_vnic *nesvnic = (struct nes_vnic *)parm;
-	printk("%s: Timer fired.\n", __FUNCTION__);
+	printk("%s: Timer fired.\n", __func__);
 	atomic_set(&nesvnic->rx_skb_timer_running, 0);
 	if (atomic_read(&nesvnic->rx_skbs_needed))
 		nes_replenish_nic_rq(nesvnic);
@@ -2163,7 +2163,7 @@ void nes_process_mac_intr(struct nes_dev
 				temp_phy_data = phy_data;
 			} while (1);
 			nes_debug(NES_DBG_PHY, "%s: Phy data = 0x%04X, link was %s.\n",
-				__FUNCTION__, phy_data, nesadapter->mac_link_down ? "DOWN" : "UP");
+				__func__, phy_data, nesadapter->mac_link_down ? "DOWN" : "UP");
 
 		} else {
 			phy_data = (0x0f0f0000 == (pcs_control_status & 0x0f1f0000)) ? 4 : 0;
@@ -2819,7 +2819,7 @@ void nes_process_iwarp_aeqe(struct nes_d
 					le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]));
 			if (resource_allocated) {
 				printk(KERN_ERR PFX "%s: Processing an NES_AEQE_AEID_CQ_OPERATION_ERROR event on CQ%u\n",
-						__FUNCTION__, le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]));
+						__func__, le32_to_cpu(aeqe->aeqe_words[NES_AEQE_COMP_QP_CQ_ID_IDX]));
 			}
 			break;
 		case NES_AEQE_AEID_DDP_UBE_DDP_MESSAGE_TOO_LONG_FOR_AVAILABLE_BUFFER:
diff -puN drivers/infiniband/hw/nes/nes_nic.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes_nic.c
--- a/drivers/infiniband/hw/nes/nes_nic.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes_nic.c
@@ -802,7 +802,7 @@ static int nes_netdev_set_mac_address(st
 
 	memcpy(netdev->dev_addr, mac_addr->sa_data, netdev->addr_len);
 	printk(PFX "%s: Address length = %d, Address = %02X%02X%02X%02X%02X%02X..\n",
-		   __FUNCTION__, netdev->addr_len,
+		   __func__, netdev->addr_len,
 		   mac_addr->sa_data[0], mac_addr->sa_data[1],
 		   mac_addr->sa_data[2], mac_addr->sa_data[3],
 		   mac_addr->sa_data[4], mac_addr->sa_data[5]);
diff -puN drivers/infiniband/hw/nes/nes_utils.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes_utils.c
--- a/drivers/infiniband/hw/nes/nes_utils.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes_utils.c
@@ -566,7 +566,7 @@ struct nes_cqp_request *nes_get_cqp_requ
 				cqp_request);
 	} else
 		printk(KERN_ERR PFX "%s: Could not allocated a CQP request.\n",
-			   __FUNCTION__);
+			   __func__);
 
 	return cqp_request;
 }
diff -puN drivers/infiniband/hw/nes/nes_verbs.c~infiniband-replace-remaining-__function__-occurrences drivers/infiniband/hw/nes/nes_verbs.c
--- a/drivers/infiniband/hw/nes/nes_verbs.c~infiniband-replace-remaining-__function__-occurrences
+++ a/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1908,13 +1908,13 @@ static int nes_destroy_cq(struct ib_cq *
 		nesadapter->free_256pbl++;
 		if (nesadapter->free_256pbl > nesadapter->max_256pbl) {
 			printk(KERN_ERR PFX "%s: free 256B PBLs(%u) has exceeded the max(%u)\n",
-					__FUNCTION__, nesadapter->free_256pbl, nesadapter->max_256pbl);
+					__func__, nesadapter->free_256pbl, nesadapter->max_256pbl);
 		}
 	} else if (nescq->virtual_cq == 2) {
 		nesadapter->free_4kpbl++;
 		if (nesadapter->free_4kpbl > nesadapter->max_4kpbl) {
 			printk(KERN_ERR PFX "%s: free 4K PBLs(%u) has exceeded the max(%u)\n",
-					__FUNCTION__, nesadapter->free_4kpbl, nesadapter->max_4kpbl);
+					__func__, nesadapter->free_4kpbl, nesadapter->max_4kpbl);
 		}
 		opcode |= NES_CQP_CQ_4KB_CHUNK;
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-async-tx.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

