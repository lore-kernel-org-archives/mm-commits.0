Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FDC7F57B
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A5u7ctuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E762C433C9;
	Tue, 12 Dec 2023 18:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407570;
	bh=qy4f/WA1X/MrjTDQ2pUY+TPyDhce+4ejweoGbbFqZmo=;
	h=Date:To:From:Subject:From;
	b=A5u7ctuhXEs+Pykm84MhEIvInMnn37cYLm5HRswNtwssIdKtxYAkY1luKIK618mIN
	 XC2UjNTs1DY9vL44yXO3TXztuXztiJScpNEIUW1KtuzfuIZ1LR0+tmch+JNMy6bUkz
	 vfrSl3fnwSFgyjyl2xYfa+9f9LMVgInKYEKFj+88=
Date: Tue, 12 Dec 2023 10:59:29 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch removed from -mm tree
Message-Id: <20231212185930.1E762C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement files for scheme quota goals setup
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement files for scheme quota goals setup
Date: Thu, 30 Nov 2023 02:36:45 +0000

Implement DAMON sysfs directories and files for the goals of DAMOS quota. 
Those allow users set multiple goals for their aim, with target values. 
Users can further enter the current score value for each goal as feedback
for DAMOS.

Note that this commit is implementing only the basic file operations, and
not connecting the files with the DAMOS core logic.  Hence writing
something to the files makes no real effect.  The following commit will
connect the file operations and the core logic.

Link: https://lkml.kernel.org/r/20231130023652.50284-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |  224 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 221 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup
+++ a/mm/damon/sysfs-schemes.c
@@ -821,6 +821,203 @@ static const struct kobj_type damon_sysf
 };
 
 /*
+ * quota goal directory
+ */
+
+struct damos_sysfs_quota_goal {
+	struct kobject kobj;
+	unsigned long target_value;
+	unsigned long current_value;
+};
+
+static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
+{
+	return kzalloc(sizeof(struct damos_sysfs_quota_goal), GFP_KERNEL);
+}
+
+static ssize_t target_value_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%lu\n", goal->target_value);
+}
+
+static ssize_t target_value_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+	int err = kstrtoul(buf, 0, &goal->target_value);
+
+	return err ? err : count;
+}
+
+static ssize_t current_value_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%lu\n", goal->current_value);
+}
+
+static ssize_t current_value_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+	int err = kstrtoul(buf, 0, &goal->current_value);
+
+	/* feed callback should check existence of this file and read value */
+	return err ? err : count;
+}
+
+static void damos_sysfs_quota_goal_release(struct kobject *kobj)
+{
+	/* or, notify this release to the feed callback */
+	kfree(container_of(kobj, struct damos_sysfs_quota_goal, kobj));
+}
+
+static struct kobj_attribute damos_sysfs_quota_goal_target_value_attr =
+		__ATTR_RW_MODE(target_value, 0600);
+
+static struct kobj_attribute damos_sysfs_quota_goal_current_value_attr =
+		__ATTR_RW_MODE(current_value, 0600);
+
+static struct attribute *damos_sysfs_quota_goal_attrs[] = {
+	&damos_sysfs_quota_goal_target_value_attr.attr,
+	&damos_sysfs_quota_goal_current_value_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damos_sysfs_quota_goal);
+
+static const struct kobj_type damos_sysfs_quota_goal_ktype = {
+	.release = damos_sysfs_quota_goal_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damos_sysfs_quota_goal_groups,
+};
+
+/*
+ * quota goals directory
+ */
+
+struct damos_sysfs_quota_goals {
+	struct kobject kobj;
+	struct damos_sysfs_quota_goal **goals_arr;	/* counted by nr */
+	int nr;
+};
+
+static struct damos_sysfs_quota_goals *damos_sysfs_quota_goals_alloc(void)
+{
+	return kzalloc(sizeof(struct damos_sysfs_quota_goals), GFP_KERNEL);
+}
+
+static void damos_sysfs_quota_goals_rm_dirs(
+		struct damos_sysfs_quota_goals *goals)
+{
+	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
+	int i;
+
+	for (i = 0; i < goals->nr; i++)
+		kobject_put(&goals_arr[i]->kobj);
+	goals->nr = 0;
+	kfree(goals_arr);
+	goals->goals_arr = NULL;
+}
+
+static int damos_sysfs_quota_goals_add_dirs(
+		struct damos_sysfs_quota_goals *goals, int nr_goals)
+{
+	struct damos_sysfs_quota_goal **goals_arr, *goal;
+	int err, i;
+
+	damos_sysfs_quota_goals_rm_dirs(goals);
+	if (!nr_goals)
+		return 0;
+
+	goals_arr = kmalloc_array(nr_goals, sizeof(*goals_arr),
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!goals_arr)
+		return -ENOMEM;
+	goals->goals_arr = goals_arr;
+
+	for (i = 0; i < nr_goals; i++) {
+		goal = damos_sysfs_quota_goal_alloc();
+		if (!goal) {
+			damos_sysfs_quota_goals_rm_dirs(goals);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&goal->kobj,
+				&damos_sysfs_quota_goal_ktype, &goals->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&goal->kobj);
+			damos_sysfs_quota_goals_rm_dirs(goals);
+			return err;
+		}
+
+		goals_arr[i] = goal;
+		goals->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_goals_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goals *goals = container_of(kobj,
+			struct damos_sysfs_quota_goals, kobj);
+
+	return sysfs_emit(buf, "%d\n", goals->nr);
+}
+
+static ssize_t nr_goals_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goals *goals;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	goals = container_of(kobj, struct damos_sysfs_quota_goals, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damos_sysfs_quota_goals_add_dirs(goals, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static void damos_sysfs_quota_goals_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damos_sysfs_quota_goals, kobj));
+}
+
+static struct kobj_attribute damos_sysfs_quota_goals_nr_attr =
+		__ATTR_RW_MODE(nr_goals, 0600);
+
+static struct attribute *damos_sysfs_quota_goals_attrs[] = {
+	&damos_sysfs_quota_goals_nr_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damos_sysfs_quota_goals);
+
+static const struct kobj_type damos_sysfs_quota_goals_ktype = {
+	.release = damos_sysfs_quota_goals_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damos_sysfs_quota_goals_groups,
+};
+
+/*
  * scheme/weights directory
  */
 
@@ -938,6 +1135,7 @@ static const struct kobj_type damon_sysf
 struct damon_sysfs_quotas {
 	struct kobject kobj;
 	struct damon_sysfs_weights *weights;
+	struct damos_sysfs_quota_goals *goals;
 	unsigned long ms;
 	unsigned long sz;
 	unsigned long reset_interval_ms;
@@ -951,6 +1149,7 @@ static struct damon_sysfs_quotas *damon_
 static int damon_sysfs_quotas_add_dirs(struct damon_sysfs_quotas *quotas)
 {
 	struct damon_sysfs_weights *weights;
+	struct damos_sysfs_quota_goals *goals;
 	int err;
 
 	weights = damon_sysfs_weights_alloc(0, 0, 0);
@@ -959,16 +1158,35 @@ static int damon_sysfs_quotas_add_dirs(s
 
 	err = kobject_init_and_add(&weights->kobj, &damon_sysfs_weights_ktype,
 			&quotas->kobj, "weights");
-	if (err)
+	if (err) {
 		kobject_put(&weights->kobj);
-	else
-		quotas->weights = weights;
+		return err;
+	}
+	quotas->weights = weights;
+
+	goals = damos_sysfs_quota_goals_alloc();
+	if (!goals) {
+		kobject_put(&weights->kobj);
+		return -ENOMEM;
+	}
+	err = kobject_init_and_add(&goals->kobj,
+			&damos_sysfs_quota_goals_ktype, &quotas->kobj,
+			"goals");
+	if (err) {
+		kobject_put(&weights->kobj);
+		kobject_put(&goals->kobj);
+	} else {
+		quotas->goals = goals;
+	}
+
 	return err;
 }
 
 static void damon_sysfs_quotas_rm_dirs(struct damon_sysfs_quotas *quotas)
 {
 	kobject_put(&quotas->weights->kobj);
+	damos_sysfs_quota_goals_rm_dirs(quotas->goals);
+	kobject_put(&quotas->goals->kobj);
 }
 
 static ssize_t ms_show(struct kobject *kobj, struct kobj_attribute *attr,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

