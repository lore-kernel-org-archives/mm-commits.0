Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6D5C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiB1Ttk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiB1Ttd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:49:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87716215905
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:47:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCFFCB8162A
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79774C340F1;
        Mon, 28 Feb 2022 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646077676;
        bh=B6suHbqcpBHIaCrcDTenx3cMpidPMBlqgHM7jwpVX78=;
        h=Date:To:From:Subject:From;
        b=ldRObo57e+6cK1detAGDmgivSNhw/wEMcwjcOhKsdoUOprBMbTxwfRQhfUq2k6Oh2
         cMMKGAc9C2Yq4dA/DOOyyug4tOywvV4M1F/fmrMu4/0yDWyzFN57ZGFzjz9DuATI1X
         CPOeoC80RThJdXBb8eRwjq6NS12o5/k4B1osmkXA=
Date:   Mon, 28 Feb 2022 11:47:55 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-damos-quotas.patch added to -mm tree
Message-Id: <20220228194756.79774C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: support DAMOS quotas
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-support-damos-quotas.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-support-damos-quotas.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-support-damos-quotas.patch

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
Subject: mm/damon/sysfs: support DAMOS quotas

This commit makes DAMON sysfs interface supports the DAMOS quotas feature.
Specifically, this commit adds 'quotas' directory under each scheme
directory and makes kdamond 'state' file writing respects the contents in
the directory.

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
    │ │ │ │ │ │ │ quotas/ms,bytes,reset_interval_ms    <- NEW DIRECTORY
    │ │ │ │ │ │ ...
    │ │ │ │ ...
    │ │ ...

Link: https://lkml.kernel.org/r/20220228081314.5770-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  146 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-damos-quotas
+++ a/mm/damon/sysfs.c
@@ -114,6 +114,113 @@ static struct kobj_type damon_sysfs_ul_r
 };
 
 /*
+ * quotas directory
+ */
+
+struct damon_sysfs_quotas {
+	struct kobject kobj;
+	unsigned long ms;
+	unsigned long sz;
+	unsigned long reset_interval_ms;
+};
+
+static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_quotas), GFP_KERNEL);
+}
+
+static ssize_t ms_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%lu\n", quotas->ms);
+}
+
+static ssize_t ms_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtoul(buf, 0, &quotas->ms);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t bytes_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%lu\n", quotas->sz);
+}
+
+static ssize_t bytes_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtoul(buf, 0, &quotas->sz);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t reset_interval_ms_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%lu\n", quotas->reset_interval_ms);
+}
+
+static ssize_t reset_interval_ms_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtoul(buf, 0, &quotas->reset_interval_ms);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static void damon_sysfs_quotas_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_quotas_ms_attr =
+		__ATTR_RW_MODE(ms, 0600);
+
+static struct kobj_attribute damon_sysfs_quotas_sz_attr =
+		__ATTR_RW_MODE(bytes, 0600);
+
+static struct kobj_attribute damon_sysfs_quotas_reset_interval_ms_attr =
+		__ATTR_RW_MODE(reset_interval_ms, 0600);
+
+static struct attribute *damon_sysfs_quotas_attrs[] = {
+	&damon_sysfs_quotas_ms_attr.attr,
+	&damon_sysfs_quotas_sz_attr.attr,
+	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_quotas);
+
+static struct kobj_type damon_sysfs_quotas_ktype = {
+	.release = damon_sysfs_quotas_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_quotas_groups,
+};
+
+/*
  * access_pattern directory
  */
 
@@ -220,6 +327,7 @@ struct damon_sysfs_scheme {
 	struct kobject kobj;
 	enum damos_action action;
 	struct damon_sysfs_access_pattern *access_pattern;
+	struct damon_sysfs_quotas *quotas;
 };
 
 /* This should match with enum damos_action */
@@ -270,6 +378,25 @@ out:
 	return err;
 }
 
+static int damon_sysfs_scheme_set_quotas(struct damon_sysfs_scheme *scheme)
+{
+	struct damon_sysfs_quotas *quotas = damon_sysfs_quotas_alloc();
+	int err;
+
+	if (!quotas)
+		return -ENOMEM;
+	err = kobject_init_and_add(&quotas->kobj, &damon_sysfs_quotas_ktype,
+			&scheme->kobj, "quotas");
+	if (err)
+		goto out;
+	scheme->quotas = quotas;
+	return 0;
+
+out:
+	kobject_put(&quotas->kobj);
+	return err;
+}
+
 static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 {
 	int err;
@@ -277,13 +404,22 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_access_pattern(scheme);
 	if (err)
 		return err;
+	err = damon_sysfs_scheme_set_quotas(scheme);
+	if (err)
+		goto put_access_pattern_out;
 	return 0;
+
+put_access_pattern_out:
+	kobject_put(&scheme->access_pattern->kobj);
+	scheme->access_pattern = NULL;
+	return err;
 }
 
 static void damon_sysfs_scheme_rm_dirs(struct damon_sysfs_scheme *scheme)
 {
 	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
+	kobject_put(&scheme->quotas->kobj);
 }
 
 static ssize_t action_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1520,7 +1656,15 @@ static struct damos *damon_sysfs_mk_sche
 {
 	struct damon_sysfs_access_pattern *pattern =
 		sysfs_scheme->access_pattern;
-	struct damos_quota quota = (struct damos_quota){};
+	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
+	struct damos_quota quota = {
+		.ms = sysfs_quotas->ms,
+		.sz = sysfs_quotas->sz,
+		.reset_interval = sysfs_quotas->reset_interval_ms,
+		.weight_sz = 1000,
+		.weight_nr_accesses = 1000,
+		.weight_age = 1000,
+	};
 	struct damos_watermarks wmarks = {
 		.metric = DAMOS_WMARK_NONE,
 		.interval = 0,
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

