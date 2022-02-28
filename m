Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD47C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiB1Ttl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiB1Ttf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:49:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B12C10075B
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D639AB81627
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227AC340F1;
        Mon, 28 Feb 2022 19:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646077678;
        bh=lWQS2lxhX/GYGZP+Podoz1ETYw6ht9oy6UmfkqWYUpA=;
        h=Date:To:From:Subject:From;
        b=oxSI3iVLLKimLXFDwvwNrhXQ/wxVnwAoZdU0MtkqxJ0ppVuH8EHaWOfrDAsrYwl7D
         KJrxNPg2s/DCbvlzDSPCJrb7vA5SLHnDmycxsvJ05VkURAHgtctMurvr6Ku1UGvWWa
         q9B6fleK/votQ/3ZnzSN+cxRK7ItNzsG3tEm2c60=
Date:   Mon, 28 Feb 2022 11:47:57 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-schemes-prioritization.patch added to -mm tree
Message-Id: <20220228194758.8227AC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: support schemes prioritization
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-support-schemes-prioritization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-support-schemes-prioritization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-support-schemes-prioritization.patch

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
Subject: mm/damon/sysfs: support schemes prioritization

This commit makes DAMON sysfs interface supports the DAMOS' regions
prioritization weights feature under quotas limitation.  Specifically,
this commit adds 'weights' directory under each scheme directory and makes
kdamond 'state' file writing respects the contents in the directory.

    /sys/kernel/mm/damon/admin
    │ kdamonds/nr
    │ │ 0/state,pid
    │ │ │ contexts/nr
    │ │ │ │ 0/operations
    │ │ │ │ │ monitoring_attrs/intervals/sample_us,aggr_us,update_us
    │ │ │ │ │ │ nr_regions/min,max
    │ │ │ │ │ targets/nr
    │ │ │ │ │ │ 0/pid
    │ │ │ │ │ │ │ regions/nr
    │ │ │ │ │ │ │ │ 0/start,end
    │ │ │ │ │ │ │ │ ...
    │ │ │ │ │ │ ...
    │ │ │ │ │ schemes/nr
    │ │ │ │ │ │ 0/action
    │ │ │ │ │ │ │ access_pattern/
    │ │ │ │ │ │ │ │ sz/min,max
    │ │ │ │ │ │ │ │ nr_accesses/min,max
    │ │ │ │ │ │ │ │ age/min,max
    │ │ │ │ │ │ │ quotas/ms,bytes,reset_interval_ms
    │ │ │ │ │ │ │ │ weights/    <- NEW DIRECTORY
    │ │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
    │ │ │ │ │ │ ...
    │ │ │ │ ...
    │ │ ...

Link: https://lkml.kernel.org/r/20220228081314.5770-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  152 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 149 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-schemes-prioritization
+++ a/mm/damon/sysfs.c
@@ -114,11 +114,129 @@ static struct kobj_type damon_sysfs_ul_r
 };
 
 /*
+ * scheme/weights directory
+ */
+
+struct damon_sysfs_weights {
+	struct kobject kobj;
+	unsigned int sz;
+	unsigned int nr_accesses;
+	unsigned int age;
+};
+
+static struct damon_sysfs_weights *damon_sysfs_weights_alloc(unsigned int sz,
+		unsigned int nr_accesses, unsigned int age)
+{
+	struct damon_sysfs_weights *weights = kmalloc(sizeof(*weights),
+			GFP_KERNEL);
+
+	if (!weights)
+		return NULL;
+	weights->kobj = (struct kobject){};
+	weights->sz = sz;
+	weights->nr_accesses = nr_accesses;
+	weights->age = age;
+	return weights;
+}
+
+static ssize_t sz_permil_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_weights *weights = container_of(kobj,
+			struct damon_sysfs_weights, kobj);
+
+	return sysfs_emit(buf, "%u\n", weights->sz);
+}
+
+static ssize_t sz_permil_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_weights *weights = container_of(kobj,
+			struct damon_sysfs_weights, kobj);
+	int err = kstrtouint(buf, 0, &weights->sz);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t nr_accesses_permil_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_weights *weights = container_of(kobj,
+			struct damon_sysfs_weights, kobj);
+
+	return sysfs_emit(buf, "%u\n", weights->nr_accesses);
+}
+
+static ssize_t nr_accesses_permil_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_weights *weights = container_of(kobj,
+			struct damon_sysfs_weights, kobj);
+	int err = kstrtouint(buf, 0, &weights->nr_accesses);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t age_permil_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_weights *weights = container_of(kobj,
+			struct damon_sysfs_weights, kobj);
+
+	return sysfs_emit(buf, "%u\n", weights->age);
+}
+
+static ssize_t age_permil_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_weights *weights = container_of(kobj,
+			struct damon_sysfs_weights, kobj);
+	int err = kstrtouint(buf, 0, &weights->age);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static void damon_sysfs_weights_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_weights, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_weights_sz_attr =
+		__ATTR_RW_MODE(sz_permil, 0600);
+
+static struct kobj_attribute damon_sysfs_weights_nr_accesses_attr =
+		__ATTR_RW_MODE(nr_accesses_permil, 0600);
+
+static struct kobj_attribute damon_sysfs_weights_age_attr =
+		__ATTR_RW_MODE(age_permil, 0600);
+
+static struct attribute *damon_sysfs_weights_attrs[] = {
+	&damon_sysfs_weights_sz_attr.attr,
+	&damon_sysfs_weights_nr_accesses_attr.attr,
+	&damon_sysfs_weights_age_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_weights);
+
+static struct kobj_type damon_sysfs_weights_ktype = {
+	.release = damon_sysfs_weights_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_weights_groups,
+};
+
+/*
  * quotas directory
  */
 
 struct damon_sysfs_quotas {
 	struct kobject kobj;
+	struct damon_sysfs_weights *weights;
 	unsigned long ms;
 	unsigned long sz;
 	unsigned long reset_interval_ms;
@@ -129,6 +247,29 @@ static struct damon_sysfs_quotas *damon_
 	return kzalloc(sizeof(struct damon_sysfs_quotas), GFP_KERNEL);
 }
 
+static int damon_sysfs_quotas_add_dirs(struct damon_sysfs_quotas *quotas)
+{
+	struct damon_sysfs_weights *weights;
+	int err;
+
+	weights = damon_sysfs_weights_alloc(0, 0, 0);
+	if (!weights)
+		return -ENOMEM;
+
+	err = kobject_init_and_add(&weights->kobj, &damon_sysfs_weights_ktype,
+			&quotas->kobj, "weights");
+	if (err)
+		kobject_put(&weights->kobj);
+	else
+		quotas->weights = weights;
+	return err;
+}
+
+static void damon_sysfs_quotas_rm_dirs(struct damon_sysfs_quotas *quotas)
+{
+	kobject_put(&quotas->weights->kobj);
+}
+
 static ssize_t ms_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -389,6 +530,9 @@ static int damon_sysfs_scheme_set_quotas
 			&scheme->kobj, "quotas");
 	if (err)
 		goto out;
+	err = damon_sysfs_quotas_add_dirs(quotas);
+	if (err)
+		goto out;
 	scheme->quotas = quotas;
 	return 0;
 
@@ -419,6 +563,7 @@ static void damon_sysfs_scheme_rm_dirs(s
 {
 	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 }
 
@@ -1657,13 +1802,14 @@ static struct damos *damon_sysfs_mk_sche
 	struct damon_sysfs_access_pattern *pattern =
 		sysfs_scheme->access_pattern;
 	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
+	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
 	struct damos_quota quota = {
 		.ms = sysfs_quotas->ms,
 		.sz = sysfs_quotas->sz,
 		.reset_interval = sysfs_quotas->reset_interval_ms,
-		.weight_sz = 1000,
-		.weight_nr_accesses = 1000,
-		.weight_age = 1000,
+		.weight_sz = sysfs_weights->sz,
+		.weight_nr_accesses = sysfs_weights->nr_accesses,
+		.weight_age = sysfs_weights->age,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = DAMOS_WMARK_NONE,
_

Patches currently in -mm which might be from sj@kernel.org are

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
docs-vm-damon-call-low-level-monitoring-primitives-the-operations.patch
docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling.patch
docs-damon-update-outdated-term-regions-update-interval.patch
mm-damon-core-allow-non-exclusive-damon-start-stop.patch
mm-damon-core-add-number-of-each-enum-type-values.patch
mm-damon-implement-a-minimal-stub-for-sysfs-based-damon-interface.patch
mm-damon-sysfs-link-damon-for-virtual-address-spaces-monitoring.patch
mm-damon-sysfs-support-the-physical-address-space-monitoring.patch
mm-damon-sysfs-support-damon-based-operation-schemes.patch
mm-damon-sysfs-support-damos-quotas.patch
mm-damon-sysfs-support-schemes-prioritization.patch
mm-damon-sysfs-support-damos-watermarks.patch
mm-damon-sysfs-support-damos-stats.patch
selftests-damon-add-a-test-for-damon-sysfs-interface.patch
docs-admin-guide-mm-damon-usage-document-damon-sysfs-interface.patch
docs-abi-testing-add-damon-sysfs-interface-abi-document.patch

