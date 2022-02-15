Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D90C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 20:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243135AbiBOU5z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 15:57:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbiBOU5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 15:57:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DB5E031
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 12:57:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E48DB81CFB
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 20:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D509DC340F0;
        Tue, 15 Feb 2022 20:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644958661;
        bh=FTb52og/Bgxy9OC2aVNVqg7cdzwiQfvBdO2W+XEeetc=;
        h=Date:To:From:Subject:From;
        b=aaFP/rkvieb8MeuJD7E4WHjnnoH7+h5jTafA3Dk4Y7+5Yx4R11rHOz/4MSQlBazKc
         SF5V9UfHmMdG/cDmcQtDLB3eHlQoEkz8dlyk/T1ZWSANF2k+gZGR2UjzXgB8v62/xI
         PAbW2VHu9X9S1WrJoVZjnZMtp3RnetbJ8eCCdS/s=
Date:   Tue, 15 Feb 2022 12:57:40 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch added to -mm tree
Message-Id: <20220215205740.D509DC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: let monitoring operations can be registered and selected
has been added to the -mm tree.  Its filename is
     mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch
mm-damon-rename-damon_primitives-to-damon_operations.patch
mm-damon-let-monitoring-operations-can-be-registered-and-selected.patch
mm-damon-paddrvaddr-register-themselves-to-damon-in-subsys_initcall.patch
mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch
mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid.patch
mm-damon-dbgfs-test-fix-is_target_id-change.patch
mm-damon-paddrvaddr-remove-damon_pva_target_validset_operations.patch

