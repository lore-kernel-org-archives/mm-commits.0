From: akpm@linux-foundation.org
Subject: + ib-core-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:06 -0800
Message-ID: <20130206223807.59F1C5A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60584 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:08 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so209955qcr.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, hal.rosenstock@gmail.com, mike.marciniszyn@intel.com, roland@kernel.org, sean.hefty@intel.com


The patch titled
     Subject: IB/core: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     ib-core-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/core: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

v2: Mike triggered WARN_ON() in idr_preload() because send_mad(),
    which may be used from non-process context, was calling
    idr_preload() unconditionally.  Preload iff @gfp_mask has
    __GFP_WAIT.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Sean Hefty <sean.hefty@intel.com>
Reported-by: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/cm.c         |   22 ++++++++---------
 drivers/infiniband/core/cma.c        |   24 +++++-------------
 drivers/infiniband/core/sa_query.c   |   18 +++++++-------
 drivers/infiniband/core/ucm.c        |   16 +++---------
 drivers/infiniband/core/ucma.c       |   32 ++++++-------------------
 drivers/infiniband/core/uverbs_cmd.c |   17 ++++++-------
 6 files changed, 48 insertions(+), 81 deletions(-)

diff -puN drivers/infiniband/core/cm.c~ib-core-convert-to-idr_alloc drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~ib-core-convert-to-idr_alloc
+++ a/drivers/infiniband/core/cm.c
@@ -382,20 +382,21 @@ static int cm_init_av_by_path(struct ib_
 static int cm_alloc_id(struct cm_id_private *cm_id_priv)
 {
 	unsigned long flags;
-	int ret, id;
+	int id;
 	static int next_id;
 
-	do {
-		spin_lock_irqsave(&cm.lock, flags);
-		ret = idr_get_new_above(&cm.local_id_table, cm_id_priv,
-					next_id, &id);
-		if (!ret)
-			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
-		spin_unlock_irqrestore(&cm.lock, flags);
-	} while( (ret == -EAGAIN) && idr_pre_get(&cm.local_id_table, GFP_KERNEL) );
+	idr_preload(GFP_KERNEL);
+	spin_lock_irqsave(&cm.lock, flags);
+
+	id = idr_alloc(&cm.local_id_table, cm_id_priv, next_id, 0, GFP_NOWAIT);
+	if (id >= 0)
+		next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
+
+	spin_unlock_irqrestore(&cm.lock, flags);
+	idr_preload_end();
 
 	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
-	return ret;
+	return id < 0 ? id : 0;
 }
 
 static void cm_free_id(__be32 local_id)
@@ -3844,7 +3845,6 @@ static int __init ib_cm_init(void)
 	cm.remote_sidr_table = RB_ROOT;
 	idr_init(&cm.local_id_table);
 	get_random_bytes(&cm.random_id_operand, sizeof cm.random_id_operand);
-	idr_pre_get(&cm.local_id_table, GFP_KERNEL);
 	INIT_LIST_HEAD(&cm.timewait_list);
 
 	ret = class_register(&cm_class);
diff -puN drivers/infiniband/core/cma.c~ib-core-convert-to-idr_alloc drivers/infiniband/core/cma.c
--- a/drivers/infiniband/core/cma.c~ib-core-convert-to-idr_alloc
+++ a/drivers/infiniband/core/cma.c
@@ -2143,33 +2143,23 @@ static int cma_alloc_port(struct idr *ps
 			  unsigned short snum)
 {
 	struct rdma_bind_list *bind_list;
-	int port, ret;
+	int ret;
 
 	bind_list = kzalloc(sizeof *bind_list, GFP_KERNEL);
 	if (!bind_list)
 		return -ENOMEM;
 
-	do {
-		ret = idr_get_new_above(ps, bind_list, snum, &port);
-	} while ((ret == -EAGAIN) && idr_pre_get(ps, GFP_KERNEL));
-
-	if (ret)
-		goto err1;
-
-	if (port != snum) {
-		ret = -EADDRNOTAVAIL;
-		goto err2;
-	}
+	ret = idr_alloc(ps, bind_list, snum, snum + 1, GFP_KERNEL);
+	if (ret < 0)
+		goto err;
 
 	bind_list->ps = ps;
-	bind_list->port = (unsigned short) port;
+	bind_list->port = (unsigned short)ret;
 	cma_bind_port(bind_list, id_priv);
 	return 0;
-err2:
-	idr_remove(ps, port);
-err1:
+err:
 	kfree(bind_list);
-	return ret;
+	return ret == -ENOSPC ? -EADDRNOTAVAIL : ret;
 }
 
 static int cma_alloc_any_port(struct idr *ps, struct rdma_id_private *id_priv)
diff -puN drivers/infiniband/core/sa_query.c~ib-core-convert-to-idr_alloc drivers/infiniband/core/sa_query.c
--- a/drivers/infiniband/core/sa_query.c~ib-core-convert-to-idr_alloc
+++ a/drivers/infiniband/core/sa_query.c
@@ -611,19 +611,21 @@ static void init_mad(struct ib_sa_mad *m
 
 static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 {
+	bool preload = gfp_mask & __GFP_WAIT;
 	unsigned long flags;
 	int ret, id;
 
-retry:
-	if (!idr_pre_get(&query_idr, gfp_mask))
-		return -ENOMEM;
+	if (preload)
+		idr_preload(gfp_mask);
 	spin_lock_irqsave(&idr_lock, flags);
-	ret = idr_get_new(&query_idr, query, &id);
+
+	id = idr_alloc(&query_idr, query, 0, 0, GFP_NOWAIT);
+
 	spin_unlock_irqrestore(&idr_lock, flags);
-	if (ret == -EAGAIN)
-		goto retry;
-	if (ret)
-		return ret;
+	if (preload)
+		idr_preload_end();
+	if (id < 0)
+		return id;
 
 	query->mad_buf->timeout_ms  = timeout_ms;
 	query->mad_buf->context[0] = query;
diff -puN drivers/infiniband/core/ucm.c~ib-core-convert-to-idr_alloc drivers/infiniband/core/ucm.c
--- a/drivers/infiniband/core/ucm.c~ib-core-convert-to-idr_alloc
+++ a/drivers/infiniband/core/ucm.c
@@ -176,7 +176,6 @@ static void ib_ucm_cleanup_events(struct
 static struct ib_ucm_context *ib_ucm_ctx_alloc(struct ib_ucm_file *file)
 {
 	struct ib_ucm_context *ctx;
-	int result;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -187,17 +186,10 @@ static struct ib_ucm_context *ib_ucm_ctx
 	ctx->file = file;
 	INIT_LIST_HEAD(&ctx->events);
 
-	do {
-		result = idr_pre_get(&ctx_id_table, GFP_KERNEL);
-		if (!result)
-			goto error;
-
-		mutex_lock(&ctx_id_mutex);
-		result = idr_get_new(&ctx_id_table, ctx, &ctx->id);
-		mutex_unlock(&ctx_id_mutex);
-	} while (result == -EAGAIN);
-
-	if (result)
+	mutex_lock(&ctx_id_mutex);
+	ctx->id = idr_alloc(&ctx_id_table, ctx, 0, 0, GFP_KERNEL);
+	mutex_unlock(&ctx_id_mutex);
+	if (ctx->id < 0)
 		goto error;
 
 	list_add_tail(&ctx->file_list, &file->ctxs);
diff -puN drivers/infiniband/core/ucma.c~ib-core-convert-to-idr_alloc drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c~ib-core-convert-to-idr_alloc
+++ a/drivers/infiniband/core/ucma.c
@@ -145,7 +145,6 @@ static void ucma_put_ctx(struct ucma_con
 static struct ucma_context *ucma_alloc_ctx(struct ucma_file *file)
 {
 	struct ucma_context *ctx;
-	int ret;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -156,17 +155,10 @@ static struct ucma_context *ucma_alloc_c
 	INIT_LIST_HEAD(&ctx->mc_list);
 	ctx->file = file;
 
-	do {
-		ret = idr_pre_get(&ctx_idr, GFP_KERNEL);
-		if (!ret)
-			goto error;
-
-		mutex_lock(&mut);
-		ret = idr_get_new(&ctx_idr, ctx, &ctx->id);
-		mutex_unlock(&mut);
-	} while (ret == -EAGAIN);
-
-	if (ret)
+	mutex_lock(&mut);
+	ctx->id = idr_alloc(&ctx_idr, ctx, 0, 0, GFP_KERNEL);
+	mutex_unlock(&mut);
+	if (ctx->id < 0)
 		goto error;
 
 	list_add_tail(&ctx->list, &file->ctx_list);
@@ -180,23 +172,15 @@ error:
 static struct ucma_multicast* ucma_alloc_multicast(struct ucma_context *ctx)
 {
 	struct ucma_multicast *mc;
-	int ret;
 
 	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return NULL;
 
-	do {
-		ret = idr_pre_get(&multicast_idr, GFP_KERNEL);
-		if (!ret)
-			goto error;
-
-		mutex_lock(&mut);
-		ret = idr_get_new(&multicast_idr, mc, &mc->id);
-		mutex_unlock(&mut);
-	} while (ret == -EAGAIN);
-
-	if (ret)
+	mutex_lock(&mut);
+	mc->id = idr_alloc(&multicast_idr, mc, 0, 0, GFP_KERNEL);
+	mutex_unlock(&mut);
+	if (mc->id < 0)
 		goto error;
 
 	mc->ctx = ctx;
diff -puN drivers/infiniband/core/uverbs_cmd.c~ib-core-convert-to-idr_alloc drivers/infiniband/core/uverbs_cmd.c
--- a/drivers/infiniband/core/uverbs_cmd.c~ib-core-convert-to-idr_alloc
+++ a/drivers/infiniband/core/uverbs_cmd.c
@@ -124,18 +124,17 @@ static int idr_add_uobj(struct idr *idr,
 {
 	int ret;
 
-retry:
-	if (!idr_pre_get(idr, GFP_KERNEL))
-		return -ENOMEM;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&ib_uverbs_idr_lock);
-	ret = idr_get_new(idr, uobj, &uobj->id);
-	spin_unlock(&ib_uverbs_idr_lock);
 
-	if (ret == -EAGAIN)
-		goto retry;
+	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		uobj->id = ret;
 
-	return ret;
+	spin_unlock(&ib_uverbs_idr_lock);
+	idr_preload_end();
+
+	return ret < 0 ? ret : 0;
 }
 
 void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

