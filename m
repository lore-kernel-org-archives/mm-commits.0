From: akpm@linux-foundation.org
Subject: [merged] ib-core-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:03 -0800
Message-ID: <20130228201403.BF52631C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:44304 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3B1UOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:05 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so244746ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hal.rosenstock@gmail.com, mike.marciniszyn@intel.com, roland@kernel.org, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/core: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-core-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/core: convert to idr_alloc()

Convert to the much saner new idr interface.

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
@@ -125,18 +125,17 @@ static int idr_add_uobj(struct idr *idr,
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

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

