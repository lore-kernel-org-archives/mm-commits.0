Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382ACC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiCVVvH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbiCVVvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:51:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538FF62135
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E170FB81DAB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94629C340F3;
        Tue, 22 Mar 2022 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985771;
        bh=xchtpzypoJhLrFD0F18zrUgkVb6ZuqxFpl7RFND0jfs=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=cfJHzZgKoqtYeyV8dRgpa8kOHYyjVmOpjT4X8jSRC5+wS+VgsLa2nnxVvRrQ8yTTv
         rLUZuzCn6Z8xSpcqqSPqIs3oGgYXr/Ay/WwSjREVo5GbxUxgK2gAdPEfRG+tKD9jr0
         yHXoaddQz0bwaFI+JNWYoEBo45dVtGvKXaeXQZz0=
Date:   Tue, 22 Mar 2022 14:49:30 -0700
To:     xhao@linux.alibaba.com, skhan@linuxfoundation.org,
        rientjes@google.com, gregkh@linuxfoundation.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 217/227] mm/damon/sysfs: link DAMON for virtual address spaces monitoring
Message-Id: <20220322214931.94629C340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: link DAMON for virtual address spaces monitoring

This commit links the DAMON sysfs interface to DAMON so that users can
control DAMON via the interface.  In detail, this commit makes writing
'on' to 'state' file constructs DAMON contexts based on values that users
have written to relevant sysfs files and start the context.  It supports
only virtual address spaces monitoring at the moment, though.

The files hierarchy of DAMON sysfs interface after this commit is shown
below.  In the below figure, parents-children relations are represented
with indentations, each directory is having ``/`` suffix, and files in
each directory are separated by comma (",").

    /sys/kernel/mm/damon/admin
    │ kdamonds/nr_kdamonds
    │ │ 0/state,pid
    │ │ │ contexts/nr_contexts
    │ │ │ │ 0/operations
    │ │ │ │ │ monitoring_attrs/
    │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
    │ │ │ │ │ │ nr_regions/min,max
    │ │ │ │ │ targets/nr_targets
    │ │ │ │ │ │ 0/pid_target
    │ │ │ │ │ │ ...
    │ │ │ │ ...
    │ │ ...

The usage is straightforward.  Writing a number ('N') to each 'nr_*' file
makes directories named '0' to 'N-1'.  Users can construct DAMON contexts
by writing proper values to the files in the straightforward manner and
start each kdamond by writing 'on' to 'kdamonds/<N>/state'.

Link: https://lkml.kernel.org/r/20220228081314.5770-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  192 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 189 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-link-damon-for-virtual-address-spaces-monitoring
+++ a/mm/damon/sysfs.c
@@ -808,22 +808,208 @@ static void damon_sysfs_kdamond_rm_dirs(
 	kobject_put(&kdamond->contexts->kobj);
 }
 
+static bool damon_sysfs_ctx_running(struct damon_ctx *ctx)
+{
+	bool running;
+
+	mutex_lock(&ctx->kdamond_lock);
+	running = ctx->kdamond != NULL;
+	mutex_unlock(&ctx->kdamond_lock);
+	return running;
+}
+
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
-	return -EINVAL;
+	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
+			struct damon_sysfs_kdamond, kobj);
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+	bool running;
+
+	if (!ctx)
+		running = false;
+	else
+		running = damon_sysfs_ctx_running(ctx);
+
+	return sysfs_emit(buf, "%s\n", running ? "on" : "off");
+}
+
+static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
+		struct damon_sysfs_attrs *sys_attrs)
+{
+	struct damon_sysfs_intervals *sys_intervals = sys_attrs->intervals;
+	struct damon_sysfs_ul_range *sys_nr_regions =
+		sys_attrs->nr_regions_range;
+
+	return damon_set_attrs(ctx, sys_intervals->sample_us,
+			sys_intervals->aggr_us, sys_intervals->update_us,
+			sys_nr_regions->min, sys_nr_regions->max);
+}
+
+static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
+{
+	struct damon_target *t, *next;
+
+	damon_for_each_target_safe(t, next, ctx) {
+		if (ctx->ops.id == DAMON_OPS_VADDR)
+			put_pid(t->pid);
+		damon_destroy_target(t);
+	}
+}
+
+static int damon_sysfs_set_targets(struct damon_ctx *ctx,
+		struct damon_sysfs_targets *sysfs_targets)
+{
+	int i;
+
+	for (i = 0; i < sysfs_targets->nr; i++) {
+		struct damon_sysfs_target *sys_target =
+			sysfs_targets->targets_arr[i];
+		struct damon_target *t = damon_new_target();
+
+		if (!t) {
+			damon_sysfs_destroy_targets(ctx);
+			return -ENOMEM;
+		}
+		if (ctx->ops.id == DAMON_OPS_VADDR) {
+			t->pid = find_get_pid(sys_target->pid);
+			if (!t->pid) {
+				damon_sysfs_destroy_targets(ctx);
+				return -EINVAL;
+			}
+		}
+		damon_add_target(ctx, t);
+	}
+	return 0;
+}
+
+static void damon_sysfs_before_terminate(struct damon_ctx *ctx)
+{
+	struct damon_target *t, *next;
+
+	if (ctx->ops.id != DAMON_OPS_VADDR)
+		return;
+
+	mutex_lock(&ctx->kdamond_lock);
+	damon_for_each_target_safe(t, next, ctx) {
+		put_pid(t->pid);
+		damon_destroy_target(t);
+	}
+	mutex_unlock(&ctx->kdamond_lock);
+}
+
+static struct damon_ctx *damon_sysfs_build_ctx(
+		struct damon_sysfs_context *sys_ctx)
+{
+	struct damon_ctx *ctx = damon_new_ctx();
+	int err;
+
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	if (err)
+		goto out;
+	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		goto out;
+	err = damon_sysfs_set_targets(ctx, sys_ctx->targets);
+	if (err)
+		goto out;
+
+	ctx->callback.before_terminate = damon_sysfs_before_terminate;
+	return ctx;
+
+out:
+	damon_destroy_ctx(ctx);
+	return ERR_PTR(err);
+}
+
+static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx;
+	int err;
+
+	if (kdamond->damon_ctx &&
+			damon_sysfs_ctx_running(kdamond->damon_ctx))
+		return -EBUSY;
+	/* TODO: support multiple contexts per kdamond */
+	if (kdamond->contexts->nr != 1)
+		return -EINVAL;
+
+	if (kdamond->damon_ctx)
+		damon_destroy_ctx(kdamond->damon_ctx);
+	kdamond->damon_ctx = NULL;
+
+	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	err = damon_start(&ctx, 1, false);
+	if (err) {
+		damon_destroy_ctx(ctx);
+		return err;
+	}
+	kdamond->damon_ctx = ctx;
+	return err;
+}
+
+static int damon_sysfs_turn_damon_off(struct damon_sysfs_kdamond *kdamond)
+{
+	if (!kdamond->damon_ctx)
+		return -EINVAL;
+	return damon_stop(&kdamond->damon_ctx, 1);
+	/*
+	 * To allow users show final monitoring results of already turned-off
+	 * DAMON, we free kdamond->damon_ctx in next
+	 * damon_sysfs_turn_damon_on(), or kdamonds_nr_store()
+	 */
 }
 
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 		const char *buf, size_t count)
 {
-	return -EINVAL;
+	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
+			struct damon_sysfs_kdamond, kobj);
+	ssize_t ret;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	if (sysfs_streq(buf, "on"))
+		ret = damon_sysfs_turn_damon_on(kdamond);
+	else if (sysfs_streq(buf, "off"))
+		ret = damon_sysfs_turn_damon_off(kdamond);
+	else
+		ret = -EINVAL;
+	mutex_unlock(&damon_sysfs_lock);
+	if (!ret)
+		ret = count;
+	return ret;
 }
 
 static ssize_t pid_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
-	return -EINVAL;
+	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
+			struct damon_sysfs_kdamond, kobj);
+	struct damon_ctx *ctx;
+	int pid;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	ctx = kdamond->damon_ctx;
+	if (!ctx) {
+		pid = -1;
+		goto out;
+	}
+	mutex_lock(&ctx->kdamond_lock);
+	if (!ctx->kdamond)
+		pid = -1;
+	else
+		pid = ctx->kdamond->pid;
+	mutex_unlock(&ctx->kdamond_lock);
+out:
+	mutex_unlock(&damon_sysfs_lock);
+	return sysfs_emit(buf, "%d\n", pid);
 }
 
 static void damon_sysfs_kdamond_release(struct kobject *kobj)
_
