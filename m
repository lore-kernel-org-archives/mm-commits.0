Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A705C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiB1Tt5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiB1Tth (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:49:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE322FEB21
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:47:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACDBA615BC
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 19:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D90CC340F2;
        Mon, 28 Feb 2022 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646077672;
        bh=rxvJR4d12ynfc4oJB1+ni5C26sHlkCNlLTHRz/29plk=;
        h=Date:To:From:Subject:From;
        b=Ygntl6MRfRdIMuZbqW2tF+A5djhR8qnMaLGTx6vDI4jXb+9LSAxIWkhEAZCtMGcQy
         v35Um2dS5BwNgXbda3/WfOAw/gR1lyAZO4x8Hh14rYGt5p42V7xhYFUBFKVRpnpjHw
         3ycjEhEChGZoIM/VapKp3IKwz2WRoHXNW7Eod5TQ=
Date:   Mon, 28 Feb 2022 11:47:51 -0800
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        skhan@linuxfoundation.org, rientjes@google.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-the-physical-address-space-monitoring.patch added to -mm tree
Message-Id: <20220228194752.0D90CC340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: support the physical address space monitoring
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-support-the-physical-address-space-monitoring.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-support-the-physical-address-space-monitoring.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-support-the-physical-address-space-monitoring.patch

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
Subject: mm/damon/sysfs: support the physical address space monitoring

This commit makes DAMON sysfs interface supports the physical address
space monitoring.  Specifically, this commit adds support of the initial
monitoring regions set feature by adding 'regions' directory under each
target directory and makes context operations file to receive 'paddr' in
addition to 'vaddr'.

As a result, the files hierarchy becomes as below:

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
    │ │ │ │ │ │ │ regions/nr_regions    <- NEW DIRECTORY
    │ │ │ │ │ │ │ │ 0/start,end
    │ │ │ │ │ │ │ │ ...
    │ │ │ │ │ │ ...
    │ │ │ │ ...
    │ │ ...

Link: https://lkml.kernel.org/r/20220228081314.5770-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  276 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 271 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-the-physical-address-space-monitoring
+++ a/mm/damon/sysfs.c
@@ -114,11 +114,219 @@ static struct kobj_type damon_sysfs_ul_r
 };
 
 /*
+ * init region directory
+ */
+
+struct damon_sysfs_region {
+	struct kobject kobj;
+	unsigned long start;
+	unsigned long end;
+};
+
+static struct damon_sysfs_region *damon_sysfs_region_alloc(
+		unsigned long start,
+		unsigned long end)
+{
+	struct damon_sysfs_region *region = kmalloc(sizeof(*region),
+			GFP_KERNEL);
+
+	if (!region)
+		return NULL;
+	region->kobj = (struct kobject){};
+	region->start = start;
+	region->end = end;
+	return region;
+}
+
+static ssize_t start_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_region *region = container_of(kobj,
+			struct damon_sysfs_region, kobj);
+
+	return sysfs_emit(buf, "%lu\n", region->start);
+}
+
+static ssize_t start_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_region *region = container_of(kobj,
+			struct damon_sysfs_region, kobj);
+	int err = kstrtoul(buf, 0, &region->start);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t end_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_region *region = container_of(kobj,
+			struct damon_sysfs_region, kobj);
+
+	return sysfs_emit(buf, "%lu\n", region->end);
+}
+
+static ssize_t end_store(struct kobject *kobj, struct kobj_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct damon_sysfs_region *region = container_of(kobj,
+			struct damon_sysfs_region, kobj);
+	int err = kstrtoul(buf, 0, &region->end);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
+static void damon_sysfs_region_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_region, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_region_start_attr =
+		__ATTR_RW_MODE(start, 0600);
+
+static struct kobj_attribute damon_sysfs_region_end_attr =
+		__ATTR_RW_MODE(end, 0600);
+
+static struct attribute *damon_sysfs_region_attrs[] = {
+	&damon_sysfs_region_start_attr.attr,
+	&damon_sysfs_region_end_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_region);
+
+static struct kobj_type damon_sysfs_region_ktype = {
+	.release = damon_sysfs_region_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_region_groups,
+};
+
+/*
+ * init_regions directory
+ */
+
+struct damon_sysfs_regions {
+	struct kobject kobj;
+	struct damon_sysfs_region **regions_arr;
+	int nr;
+};
+
+static struct damon_sysfs_regions *damon_sysfs_regions_alloc(void)
+{
+	return kzalloc(sizeof(struct damon_sysfs_regions), GFP_KERNEL);
+}
+
+static void damon_sysfs_regions_rm_dirs(struct damon_sysfs_regions *regions)
+{
+	struct damon_sysfs_region **regions_arr = regions->regions_arr;
+	int i;
+
+	for (i = 0; i < regions->nr; i++)
+		kobject_put(&regions_arr[i]->kobj);
+	regions->nr = 0;
+	kfree(regions_arr);
+	regions->regions_arr = NULL;
+}
+
+static int damon_sysfs_regions_add_dirs(struct damon_sysfs_regions *regions,
+		int nr_regions)
+{
+	struct damon_sysfs_region **regions_arr, *region;
+	int err, i;
+
+	damon_sysfs_regions_rm_dirs(regions);
+	if (!nr_regions)
+		return 0;
+
+	regions_arr = kmalloc_array(nr_regions, sizeof(*regions_arr),
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!regions_arr)
+		return -ENOMEM;
+	regions->regions_arr = regions_arr;
+
+	for (i = 0; i < nr_regions; i++) {
+		region = damon_sysfs_region_alloc(0, 0);
+		if (!region) {
+			damon_sysfs_regions_rm_dirs(regions);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&region->kobj,
+				&damon_sysfs_region_ktype, &regions->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&region->kobj);
+			damon_sysfs_regions_rm_dirs(regions);
+			return err;
+		}
+
+		regions_arr[i] = region;
+		regions->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_regions_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_regions *regions = container_of(kobj,
+			struct damon_sysfs_regions, kobj);
+
+	return sysfs_emit(buf, "%d\n", regions->nr);
+}
+
+static ssize_t nr_regions_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_regions *regions = container_of(kobj,
+			struct damon_sysfs_regions, kobj);
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_regions_add_dirs(regions, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static void damon_sysfs_regions_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_regions, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_regions_nr_attr =
+		__ATTR_RW_MODE(nr_regions, 0600);
+
+static struct attribute *damon_sysfs_regions_attrs[] = {
+	&damon_sysfs_regions_nr_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_regions);
+
+static struct kobj_type damon_sysfs_regions_ktype = {
+	.release = damon_sysfs_regions_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_regions_groups,
+};
+
+/*
  * target directory
  */
 
 struct damon_sysfs_target {
 	struct kobject kobj;
+	struct damon_sysfs_regions *regions;
 	int pid;
 };
 
@@ -127,6 +335,29 @@ static struct damon_sysfs_target *damon_
 	return kzalloc(sizeof(struct damon_sysfs_target), GFP_KERNEL);
 }
 
+static int damon_sysfs_target_add_dirs(struct damon_sysfs_target *target)
+{
+	struct damon_sysfs_regions *regions = damon_sysfs_regions_alloc();
+	int err;
+
+	if (!regions)
+		return -ENOMEM;
+
+	err = kobject_init_and_add(&regions->kobj, &damon_sysfs_regions_ktype,
+			&target->kobj, "regions");
+	if (err)
+		kobject_put(&regions->kobj);
+	else
+		target->regions = regions;
+	return err;
+}
+
+static void damon_sysfs_target_rm_dirs(struct damon_sysfs_target *target)
+{
+	damon_sysfs_regions_rm_dirs(target->regions);
+	kobject_put(&target->regions->kobj);
+}
+
 static ssize_t pid_target_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -188,8 +419,10 @@ static void damon_sysfs_targets_rm_dirs(
 	struct damon_sysfs_target **targets_arr = targets->targets_arr;
 	int i;
 
-	for (i = 0; i < targets->nr; i++)
+	for (i = 0; i < targets->nr; i++) {
+		damon_sysfs_target_rm_dirs(targets_arr[i]);
 		kobject_put(&targets_arr[i]->kobj);
+	}
 	targets->nr = 0;
 	kfree(targets_arr);
 	targets->targets_arr = NULL;
@@ -224,6 +457,10 @@ static int damon_sysfs_targets_add_dirs(
 		if (err)
 			goto out;
 
+		err = damon_sysfs_target_add_dirs(target);
+		if (err)
+			goto out;
+
 		targets_arr[i] = target;
 		targets->nr++;
 	}
@@ -608,9 +845,6 @@ static ssize_t operations_store(struct k
 
 	for (id = 0; id < NR_DAMON_OPS; id++) {
 		if (sysfs_streq(buf, damon_sysfs_ops_strs[id])) {
-			/* Support only vaddr */
-			if (id != DAMON_OPS_VADDR)
-				return -EINVAL;
 			context->ops_id = id;
 			return count;
 		}
@@ -855,10 +1089,37 @@ static void damon_sysfs_destroy_targets(
 	}
 }
 
+static int damon_sysfs_set_regions(struct damon_target *t,
+		struct damon_sysfs_regions *sysfs_regions)
+{
+	int i;
+
+	for (i = 0; i < sysfs_regions->nr; i++) {
+		struct damon_sysfs_region *sys_region =
+			sysfs_regions->regions_arr[i];
+		struct damon_region *prev, *r;
+
+		if (sys_region->start > sys_region->end)
+			return -EINVAL;
+		r = damon_new_region(sys_region->start, sys_region->end);
+		if (!r)
+			return -ENOMEM;
+		damon_add_region(r, t);
+		if (damon_nr_regions(t) > 1) {
+			prev = damon_prev_region(r);
+			if (prev->ar.end > r->ar.start) {
+				damon_destroy_region(r, t);
+				return -EINVAL;
+			}
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
-	int i;
+	int i, err;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
 		struct damon_sysfs_target *sys_target =
@@ -877,6 +1138,11 @@ static int damon_sysfs_set_targets(struc
 			}
 		}
 		damon_add_target(ctx, t);
+		err = damon_sysfs_set_regions(t, sys_target->regions);
+		if (err) {
+			damon_sysfs_destroy_targets(ctx);
+			return err;
+		}
 	}
 	return 0;
 }
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

