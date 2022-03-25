Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87844C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357516AbiCYBg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357479AbiCYBfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A7D2E0BD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46C2D60A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF1EC340EC;
        Fri, 25 Mar 2022 01:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172014;
        bh=iDiGSrC/LHS6gmo4YuHQtXafgQ0t5wpd+/zwU8Lmco0=;
        h=Date:To:From:Subject:From;
        b=asmf29oKZpYZ3Y1B87nRGJ+9oub6mzb8AeY/1QhnAMLg5WHjOyWs67a8UfQ/aOFMH
         an9yTj1lsQ+6cBSyaHdunHXyPTHV5QPQ38vO5Whw+lFWEIruoZunpK8YK/ofOCMJDw
         g9DknrP3pgxWNm+BVeWYxSbgVLWbPy4cZWt/i2Fw=
Date:   Thu, 24 Mar 2022 18:33:34 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-sysfs-support-damos-stats.patch removed from -mm tree
Message-Id: <20220325013334.9CF1EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: support DAMOS stats
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-damos-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: support DAMOS stats

This commit makes DAMON sysfs interface supports the DAMOS stats feature. 
Specifically, this commit adds 'stats' directory under each scheme
directory, and update the contents of the files under the directory
according to the latest monitoring results, when the user writes special
keyword, 'update_schemes_stats' to the 'state' file of the kdamond.

As a result, the files hierarchy becomes as below:

    /sys/kernel/mm/damon/admin
    │ kdamonds/nr_kdamonds
    │ │ 0/state,pid
    │ │ │ contexts/nr_contexts
    │ │ │ │ 0/operations
    │ │ │ │ │ monitoring_attrs/intervals/sample_us,aggr_us,update_us
    │ │ │ │ │ │ nr_regions/min,max
    │ │ │ │ │ targets/nr_targets
    │ │ │ │ │ │ 0/pid_target
    │ │ │ │ │ │ │ regions/nr_regions
    │ │ │ │ │ │ │ │ 0/start,end
    │ │ │ │ │ │ │ │ ...
    │ │ │ │ │ │ ...
    │ │ │ │ │ schemes/nr_schemes
    │ │ │ │ │ │ 0/action
    │ │ │ │ │ │ │ access_pattern/
    │ │ │ │ │ │ │ │ sz/min,max
    │ │ │ │ │ │ │ │ nr_accesses/min,max
    │ │ │ │ │ │ │ │ age/min,max
    │ │ │ │ │ │ │ quotas/ms,sz,reset_interval_ms
    │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
    │ │ │ │ │ │ │ watermarks/metric,interval_us,high,mid,low
    │ │ │ │ │ │ │ stats/    <- NEW DIRECTORY
    │ │ │ │ │ │ │ │ nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
    │ │ │ │ │ │ ...
    │ │ │ │ ...
    │ │ ...

Link: https://lkml.kernel.org/r/20220228081314.5770-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  150 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-damos-stats
+++ a/mm/damon/sysfs.c
@@ -114,6 +114,105 @@ static struct kobj_type damon_sysfs_ul_r
 };
 
 /*
+ * schemes/stats directory
+ */
+
+struct damon_sysfs_stats {
+	struct kobject kobj;
+	unsigned long nr_tried;
+	unsigned long sz_tried;
+	unsigned long nr_applied;
+	unsigned long sz_applied;
+	unsigned long qt_exceeds;
+};
+
+static struct damon_sysfs_stats *damon_sysfs_stats_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_stats), GFP_KERNEL);
+}
+
+static ssize_t nr_tried_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->nr_tried);
+}
+
+static ssize_t sz_tried_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_tried);
+}
+
+static ssize_t nr_applied_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->nr_applied);
+}
+
+static ssize_t sz_applied_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_applied);
+}
+
+static ssize_t qt_exceeds_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->qt_exceeds);
+}
+
+static void damon_sysfs_stats_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_stats, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_stats_nr_tried_attr =
+		__ATTR_RO_MODE(nr_tried, 0400);
+
+static struct kobj_attribute damon_sysfs_stats_sz_tried_attr =
+		__ATTR_RO_MODE(sz_tried, 0400);
+
+static struct kobj_attribute damon_sysfs_stats_nr_applied_attr =
+		__ATTR_RO_MODE(nr_applied, 0400);
+
+static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
+		__ATTR_RO_MODE(sz_applied, 0400);
+
+static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
+		__ATTR_RO_MODE(qt_exceeds, 0400);
+
+static struct attribute *damon_sysfs_stats_attrs[] = {
+	&damon_sysfs_stats_nr_tried_attr.attr,
+	&damon_sysfs_stats_sz_tried_attr.attr,
+	&damon_sysfs_stats_nr_applied_attr.attr,
+	&damon_sysfs_stats_sz_applied_attr.attr,
+	&damon_sysfs_stats_qt_exceeds_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_stats);
+
+static struct kobj_type damon_sysfs_stats_ktype = {
+	.release = damon_sysfs_stats_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_stats_groups,
+};
+
+/*
  * watermarks directory
  */
 
@@ -653,6 +752,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_access_pattern *access_pattern;
 	struct damon_sysfs_quotas *quotas;
 	struct damon_sysfs_watermarks *watermarks;
+	struct damon_sysfs_stats *stats;
 };
 
 /* This should match with enum damos_action */
@@ -743,6 +843,22 @@ static int damon_sysfs_scheme_set_waterm
 	return err;
 }
 
+static int damon_sysfs_scheme_set_stats(struct damon_sysfs_scheme *scheme)
+{
+	struct damon_sysfs_stats *stats = damon_sysfs_stats_alloc();
+	int err;
+
+	if (!stats)
+		return -ENOMEM;
+	err = kobject_init_and_add(&stats->kobj, &damon_sysfs_stats_ktype,
+			&scheme->kobj, "stats");
+	if (err)
+		kobject_put(&stats->kobj);
+	else
+		scheme->stats = stats;
+	return err;
+}
+
 static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 {
 	int err;
@@ -756,8 +872,14 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
+	err = damon_sysfs_scheme_set_stats(scheme);
+	if (err)
+		goto put_watermarks_quotas_access_pattern_out;
 	return 0;
 
+put_watermarks_quotas_access_pattern_out:
+	kobject_put(&scheme->watermarks->kobj);
+	scheme->watermarks = NULL;
 put_quotas_access_pattern_out:
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
@@ -774,6 +896,7 @@ static void damon_sysfs_scheme_rm_dirs(s
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
+	kobject_put(&scheme->stats->kobj);
 }
 
 static ssize_t action_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -2141,6 +2264,31 @@ static int damon_sysfs_turn_damon_off(st
 	 */
 }
 
+static int damon_sysfs_update_schemes_stats(struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	if (!ctx)
+		return -EINVAL;
+	mutex_lock(&ctx->kdamond_lock);
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_schemes *sysfs_schemes;
+		struct damon_sysfs_stats *sysfs_stats;
+
+		sysfs_schemes = kdamond->contexts->contexts_arr[0]->schemes;
+		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
+		sysfs_stats->nr_tried = scheme->stat.nr_tried;
+		sysfs_stats->sz_tried = scheme->stat.sz_tried;
+		sysfs_stats->nr_applied = scheme->stat.nr_applied;
+		sysfs_stats->sz_applied = scheme->stat.sz_applied;
+		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
+	}
+	mutex_unlock(&ctx->kdamond_lock);
+	return 0;
+}
+
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 		const char *buf, size_t count)
 {
@@ -2154,6 +2302,8 @@ static ssize_t state_store(struct kobjec
 		ret = damon_sysfs_turn_damon_on(kdamond);
 	else if (sysfs_streq(buf, "off"))
 		ret = damon_sysfs_turn_damon_off(kdamond);
+	else if (sysfs_streq(buf, "update_schemes_stats"))
+		ret = damon_sysfs_update_schemes_stats(kdamond);
 	else
 		ret = -EINVAL;
 	mutex_unlock(&damon_sysfs_lock);
_

Patches currently in -mm which might be from sj@kernel.org are


