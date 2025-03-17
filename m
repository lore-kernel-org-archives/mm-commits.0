Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FE7217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188501; cv=none; b=LGBQHVSUbwVWbExi754n+6TTfyRNthfKczJ+ER9dvomXiStNBXLHEOSQfyGvstX5YEC1L9K79CcHdu2/1jWWoDofE1qJTwl7dHCnPPD/ksNY1fwky1lRK38eWDt/ZZOAXb9tU9PbMZ4MiPxB/4yd97AR2r9SfkPesiUVLKp2o9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188501; c=relaxed/simple;
	bh=kU3jSv9uzQi/xr11JbvEamXEZeC+KM1k37JfOQBjcZc=;
	h=Date:To:From:Subject:Message-Id; b=MNg0+eGCOzNR5r+oXLXu/iC7CH7nso/jIYY148soEoaL+neb6V79VaalEH8AjEhpKPDDy49c2aw8Ifx/0rUL4U2ko91omtNv+H1h6M/I0UOvvle10AesCol8/ydpDuPIYBn2PeSLd0N1D4AS8Hmprf8i03OxsTJycq+xA6ZonVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WUljBil1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WUljBil1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2A0C4CEEC;
	Mon, 17 Mar 2025 05:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188501;
	bh=kU3jSv9uzQi/xr11JbvEamXEZeC+KM1k37JfOQBjcZc=;
	h=Date:To:From:Subject:From;
	b=WUljBil15VWFc0NvoWmdrbluXwTyBk+Brort41hMxiViK8uL8gTLJs3WYkXdguusR
	 wAJq/OBrm9acFYiuOadm/2xcGPDunuk5aiSLfwM1XDvLArl3ZbnCsCi/htOO8m658p
	 9Al88MAVzrcpWBC18twZDGYceej7Y0twYtoWSyoQ=
Date: Sun, 16 Mar 2025 22:15:00 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch removed from -mm tree
Message-Id: <20250317051501.6B2A0C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement intervals tuning goal directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement intervals tuning goal directory
Date: Mon, 3 Mar 2025 14:17:21 -0800

Implement DAMON sysfs interface directory and its files for setting DAMON
sampling and aggregation intervals auto-tuning goal.

Link: https://lkml.kernel.org/r/20250303221726.484227-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |  189 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 189 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-intervals-tuning-goal-directory
+++ a/mm/damon/sysfs.c
@@ -409,6 +409,164 @@ static const struct kobj_type damon_sysf
 };
 
 /*
+ * intervals goal directory
+ */
+
+struct damon_sysfs_intervals_goal {
+	struct kobject kobj;
+	unsigned long access_bp;
+	unsigned long aggrs;
+	unsigned long min_sample_us;
+	unsigned long max_sample_us;
+};
+
+static struct damon_sysfs_intervals_goal *damon_sysfs_intervals_goal_alloc(
+		unsigned long access_bp, unsigned long aggrs,
+		unsigned long min_sample_us, unsigned long max_sample_us)
+{
+	struct damon_sysfs_intervals_goal *goal = kmalloc(sizeof(*goal),
+			GFP_KERNEL);
+
+	if (!goal)
+		return NULL;
+
+	goal->kobj = (struct kobject){};
+	goal->access_bp = access_bp;
+	goal->aggrs = aggrs;
+	goal->min_sample_us = min_sample_us;
+	goal->max_sample_us = max_sample_us;
+	return goal;
+}
+
+static ssize_t access_bp_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+
+	return sysfs_emit(buf, "%lu\n", goal->access_bp);
+}
+
+static ssize_t access_bp_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+	unsigned long nr;
+	int err = kstrtoul(buf, 0, &nr);
+
+	if (err)
+		return err;
+
+	goal->access_bp = nr;
+	return count;
+}
+
+static ssize_t aggrs_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+
+	return sysfs_emit(buf, "%lu\n", goal->aggrs);
+}
+
+static ssize_t aggrs_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+	unsigned long nr;
+	int err = kstrtoul(buf, 0, &nr);
+
+	if (err)
+		return err;
+
+	goal->aggrs = nr;
+	return count;
+}
+
+static ssize_t min_sample_us_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+
+	return sysfs_emit(buf, "%lu\n", goal->min_sample_us);
+}
+
+static ssize_t min_sample_us_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+	unsigned long nr;
+	int err = kstrtoul(buf, 0, &nr);
+
+	if (err)
+		return err;
+
+	goal->min_sample_us = nr;
+	return count;
+}
+
+static ssize_t max_sample_us_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+
+	return sysfs_emit(buf, "%lu\n", goal->max_sample_us);
+}
+
+static ssize_t max_sample_us_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_intervals_goal *goal = container_of(kobj,
+			struct damon_sysfs_intervals_goal, kobj);
+	unsigned long nr;
+	int err = kstrtoul(buf, 0, &nr);
+
+	if (err)
+		return err;
+
+	goal->max_sample_us = nr;
+	return count;
+}
+
+static void damon_sysfs_intervals_goal_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_intervals_goal, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_intervals_goal_access_bp_attr =
+		__ATTR_RW_MODE(access_bp, 0600);
+
+static struct kobj_attribute damon_sysfs_intervals_goal_aggrs_attr =
+		__ATTR_RW_MODE(aggrs, 0600);
+
+static struct kobj_attribute damon_sysfs_intervals_goal_min_sample_us_attr =
+		__ATTR_RW_MODE(min_sample_us, 0600);
+
+static struct kobj_attribute damon_sysfs_intervals_goal_max_sample_us_attr =
+		__ATTR_RW_MODE(max_sample_us, 0600);
+
+static struct attribute *damon_sysfs_intervals_goal_attrs[] = {
+	&damon_sysfs_intervals_goal_access_bp_attr.attr,
+	&damon_sysfs_intervals_goal_aggrs_attr.attr,
+	&damon_sysfs_intervals_goal_min_sample_us_attr.attr,
+	&damon_sysfs_intervals_goal_max_sample_us_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_intervals_goal);
+
+static const struct kobj_type damon_sysfs_intervals_goal_ktype = {
+	.release = damon_sysfs_intervals_goal_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_intervals_goal_groups,
+};
+
+/*
  * intervals directory
  */
 
@@ -417,6 +575,7 @@ struct damon_sysfs_intervals {
 	unsigned long sample_us;
 	unsigned long aggr_us;
 	unsigned long update_us;
+	struct damon_sysfs_intervals_goal *intervals_goal;
 };
 
 static struct damon_sysfs_intervals *damon_sysfs_intervals_alloc(
@@ -436,6 +595,32 @@ static struct damon_sysfs_intervals *dam
 	return intervals;
 }
 
+static int damon_sysfs_intervals_add_dirs(struct damon_sysfs_intervals *intervals)
+{
+	struct damon_sysfs_intervals_goal *goal;
+	int err;
+
+	goal = damon_sysfs_intervals_goal_alloc(0, 0, 0, 0);
+	if (!goal)
+		return -ENOMEM;
+
+	err = kobject_init_and_add(&goal->kobj,
+			&damon_sysfs_intervals_goal_ktype, &intervals->kobj,
+			"intervals_goal");
+	if (err) {
+		kobject_put(&goal->kobj);
+		intervals->intervals_goal = NULL;
+		return err;
+	}
+	intervals->intervals_goal = goal;
+	return 0;
+}
+
+static void damon_sysfs_intervals_rm_dirs(struct damon_sysfs_intervals *intervals)
+{
+	kobject_put(&intervals->intervals_goal->kobj);
+}
+
 static ssize_t sample_us_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -571,6 +756,9 @@ static int damon_sysfs_attrs_add_dirs(st
 			"intervals");
 	if (err)
 		goto put_intervals_out;
+	err = damon_sysfs_intervals_add_dirs(intervals);
+	if (err)
+		goto put_intervals_out;
 	attrs->intervals = intervals;
 
 	nr_regions_range = damon_sysfs_ul_range_alloc(10, 1000);
@@ -599,6 +787,7 @@ put_intervals_out:
 static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 {
 	kobject_put(&attrs->nr_regions_range->kobj);
+	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

