Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329DD198A2F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041117; cv=none; b=pnEY7mjRfgcUC63X7xFjEexfGy08wrqfcEcEi+8UI73QX+FH/34om4d2HtFaGlr7P0BDeqXRUQEMX6PoGWvQ+7wgPLKpRsiV0f9cx1ofRzxNVDze6KFv+JRirxppwZqqJtZAbI7WAKDR6Wnim2zpOnt8fe/4N/jif+vTVFVyGMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041117; c=relaxed/simple;
	bh=bUTmgyBWnD9KUUhLRlMeCMVUp+TPtzZf/YLRsPWLog8=;
	h=Date:To:From:Subject:Message-Id; b=DHlyazK0EIX5yxyosCgD2g+/W3ul/6i2Z7I+tslzU2isSpjLwnS1e0szZiBP5/AI5qz4i0sUVCGqYSMpGlID0GTAKF70iryLfnX3pFubE+h6fy+6VlW/lonr410iUJGnen3NBx/dMVUQlYb+z9oZjYx6dx5XuuE+Kd8aCez5+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uwHcMgGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uwHcMgGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C7AC4CED6;
	Mon,  3 Mar 2025 22:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741041116;
	bh=bUTmgyBWnD9KUUhLRlMeCMVUp+TPtzZf/YLRsPWLog8=;
	h=Date:To:From:Subject:From;
	b=uwHcMgGw2kue0sigszX4ON+gupIYu9PcTXE2vpMD0RyD7W5bJzcQ2yvHuJf3f1MJM
	 ksZAPnfgK/qT1Tr2TGoSgaHwj/LCbP4ZNTeAIdDxCjo1VbjEoqhuvBdbcgsCJtCPlh
	 3AFnAsCrY5PsD/72gP5Cv1AIKgUT8S0rNj03faHA=
Date: Mon, 03 Mar 2025 14:31:56 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch added to mm-unstable branch
Message-Id: <20250303223156.94C7AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement intervals tuning goal directory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

