Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C031EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354709AbiCYBgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357433AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8758725C5C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD5A60A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA6FC340EC;
        Fri, 25 Mar 2022 01:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171994;
        bh=eWxodczbMdo+0PGiOjFEEW0NItNbOI0LaRqZnHTIfKk=;
        h=Date:To:From:Subject:From;
        b=UZmFKL5/MVlfGNZW/GsZWa7Dyjw8C/u010Njg3ZBsbx9xyXqHN2pJEtRiV3RyJKOI
         yuRfwB0lTFjl7VH822euhmT4bZTJlcjp8yVBhdJ1duYIig13BSXDDHE9SRx4UX8ZQ1
         qRd/Nh+URqrMVs8i3RegnsEqbB12INrk7TEiekEk=
Date:   Thu, 24 Mar 2022 18:33:13 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch removed from -mm tree
Message-Id: <20220325013314.3EA6FC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: let monitoring operations can be registered and selected
has been removed from the -mm tree.  Its filename was
     mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: let monitoring operations can be registered and selected

In-kernel DAMON user code like DAMON debugfs interface should set 'struct
damon_operations' of its 'struct damon_ctx' on its own.  Therefore, the
client code should depend on all supporting monitoring operations
implementations that it could use.  For example, DAMON debugfs interface
depends on both vaddr and paddr, while some of the users are not always
interested in both.

To minimize such unnecessary dependencies, this commit makes the
monitoring operations can be registered by implementing code and then
dynamically selected by the user code without build-time dependency.

Link: https://lkml.kernel.org/r/20220215184603.1479-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   18 ++++++++++
 mm/damon/core.c       |   66 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

--- a/include/linux/damon.h~mm-damon-let-monitoring-operations-can-be-registered-and-selected
+++ a/include/linux/damon.h
@@ -253,11 +253,24 @@ struct damos {
 	struct list_head list;
 };
 
+/**
+ * enum damon_ops_id - Identifier for each monitoring operations implementation
+ *
+ * @DAMON_OPS_VADDR:	Monitoring operations for virtual address spaces
+ * @DAMON_OPS_PADDR:	Monitoring operations for the physical address space
+ */
+enum damon_ops_id {
+	DAMON_OPS_VADDR,
+	DAMON_OPS_PADDR,
+	NR_DAMON_OPS,
+};
+
 struct damon_ctx;
 
 /**
  * struct damon_operations - Monitoring operations for given use cases.
  *
+ * @id:				Identifier of this operations set.
  * @init:			Initialize operations-related data structures.
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
@@ -277,6 +290,8 @@ struct damon_ctx;
  * &damon_ctx.sample_interval.  Finally, @reset_aggregated is called after each
  * &damon_ctx.aggr_interval.
  *
+ * Each &struct damon_operations instance having valid @id can be registered
+ * via damon_register_ops() and selected by damon_select_ops() later.
  * @init should initialize operations-related data structures.  For example,
  * this could be used to construct proper monitoring target regions and link
  * those to @damon_ctx.adaptive_targets.
@@ -301,6 +316,7 @@ struct damon_ctx;
  * @cleanup is called from @kdamond just before its termination.
  */
 struct damon_operations {
+	enum damon_ops_id id;
 	void (*init)(struct damon_ctx *context);
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
@@ -489,6 +505,8 @@ int damon_set_attrs(struct damon_ctx *ct
 int damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_nr_running_ctxs(void);
+int damon_register_ops(struct damon_operations *ops);
+int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
--- a/mm/damon/core.c~mm-damon-let-monitoring-operations-can-be-registered-and-selected
+++ a/mm/damon/core.c
@@ -25,6 +25,72 @@
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 
+static DEFINE_MUTEX(damon_ops_lock);
+static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
+
+/* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
+static bool damon_registered_ops_id(enum damon_ops_id id)
+{
+	struct damon_operations empty_ops = {};
+
+	if (!memcmp(&empty_ops, &damon_registered_ops[id], sizeof(empty_ops)))
+		return false;
+	return true;
+}
+
+/**
+ * damon_register_ops() - Register a monitoring operations set to DAMON.
+ * @ops:	monitoring operations set to register.
+ *
+ * This function registers a monitoring operations set of valid &struct
+ * damon_operations->id so that others can find and use them later.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_register_ops(struct damon_operations *ops)
+{
+	int err = 0;
+
+	if (ops->id >= NR_DAMON_OPS)
+		return -EINVAL;
+	mutex_lock(&damon_ops_lock);
+	/* Fail for already registered ops */
+	if (damon_registered_ops_id(ops->id)) {
+		err = -EINVAL;
+		goto out;
+	}
+	damon_registered_ops[ops->id] = *ops;
+out:
+	mutex_unlock(&damon_ops_lock);
+	return err;
+}
+
+/**
+ * damon_select_ops() - Select a monitoring operations to use with the context.
+ * @ctx:	monitoring context to use the operations.
+ * @id:		id of the registered monitoring operations to select.
+ *
+ * This function finds registered monitoring operations set of @id and make
+ * @ctx to use it.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
+{
+	int err = 0;
+
+	if (id >= NR_DAMON_OPS)
+		return -EINVAL;
+
+	mutex_lock(&damon_ops_lock);
+	if (!damon_registered_ops_id(id))
+		err = -EINVAL;
+	else
+		ctx->ops = damon_registered_ops[id];
+	mutex_unlock(&damon_ops_lock);
+	return err;
+}
+
 /*
  * Construct a damon_region struct
  *
_

Patches currently in -mm which might be from sj@kernel.org are


