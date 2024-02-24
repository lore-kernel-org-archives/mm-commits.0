Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0726279F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739424; cv=none; b=J4MeP8bVL7fvGHah5FFok/LPiq0HpyKKU9w6qCI1O08x62H80KzxANwHseB1fTc5Iuc2u73mTnVV7IFn4L4UrdJeaael7rf4GkH9pYXXI5kzHfCtz7qo0ZG2RrvVNqBSQbIqz6gtpDLt53NSha/+IgFEwRI3UEBc936hDGDJDPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739424; c=relaxed/simple;
	bh=QJXie09PNpQN72RTifxQFkC18HbZ7UqukfD0uM3X/rU=;
	h=Date:To:From:Subject:Message-Id; b=o7RKgPwLzS1WtPwZvPm5awjeYoJ4k3EOZRw9g76gXJg/rDPc9FSr9ahEy1qNusy+F21rdt0opGLu9yECT2y0SwSaNcwcy56K3GaPGoZYXVwNA/K4SMOKFXo77RqgxY9q7HLn8szqeWP7NiRFTw3jkd7hcVhaLI8qrDiTnbt4LvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YgeKYAeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YgeKYAeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D145BC433F1;
	Sat, 24 Feb 2024 01:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739423;
	bh=QJXie09PNpQN72RTifxQFkC18HbZ7UqukfD0uM3X/rU=;
	h=Date:To:From:Subject:From;
	b=YgeKYAeVa6D5/p08GktLMQ9QkEp/gnnwBejtBMBJ/jDnQ/8N1Yhfw8Wv7zm2u7cAz
	 iF3875SEhJRKREnTjGlp66Et6ncy0Uv83Mv881h6caV35F6np9i4KOH9jmKdTGxTdd
	 def3EZAazeUXaE5x0jMoDOgkpp+E1gU+LB2rKJxQ=
Date: Fri, 23 Feb 2024 17:50:23 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch removed from -mm tree
Message-Id: <20240224015023.D145BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: support PSI-based quota auto-tune
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: support PSI-based quota auto-tune
Date: Mon, 19 Feb 2024 11:44:25 -0800

Extend DAMON sysfs interface to support the PSI-based quota auto-tuning by
adding a new file, 'target_metric' under the quota goal directory.  Old
users don't get any behavioral changes since the default value of the
metric is 'user input'.

Link: https://lkml.kernel.org/r/20240219194431.159606-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   42 +++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune
+++ a/mm/damon/sysfs-schemes.c
@@ -826,15 +826,48 @@ static const struct kobj_type damon_sysf
 
 struct damos_sysfs_quota_goal {
 	struct kobject kobj;
+	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
 };
 
+/* This should match with enum damos_action */
+static const char * const damos_sysfs_quota_goal_metric_strs[] = {
+	"user_input",
+	"some_mem_psi_us",
+};
+
 static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
 {
 	return kzalloc(sizeof(struct damos_sysfs_quota_goal), GFP_KERNEL);
 }
 
+static ssize_t target_metric_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%s\n",
+			damos_sysfs_quota_goal_metric_strs[goal->metric]);
+}
+
+static ssize_t target_metric_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	enum damos_quota_goal_metric m;
+
+	for (m = 0; m < NR_DAMOS_QUOTA_GOAL_METRICS; m++) {
+		if (sysfs_streq(buf, damos_sysfs_quota_goal_metric_strs[m])) {
+			goal->metric = m;
+			return count;
+		}
+	}
+	return -EINVAL;
+}
+
 static ssize_t target_value_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -880,6 +913,9 @@ static void damos_sysfs_quota_goal_relea
 	kfree(container_of(kobj, struct damos_sysfs_quota_goal, kobj));
 }
 
+static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
+		__ATTR_RW_MODE(target_metric, 0600);
+
 static struct kobj_attribute damos_sysfs_quota_goal_target_value_attr =
 		__ATTR_RW_MODE(target_value, 0600);
 
@@ -887,6 +923,7 @@ static struct kobj_attribute damos_sysfs
 		__ATTR_RW_MODE(current_value, 0600);
 
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
+	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	NULL,
@@ -1899,11 +1936,12 @@ static int damos_sysfs_set_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT,
+		goal = damos_new_quota_goal(sysfs_goal->metric,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
-		goal->current_value = sysfs_goal->current_value;
+		if (sysfs_goal->metric == DAMOS_QUOTA_USER_INPUT)
+			goal->current_value = sysfs_goal->current_value;
 		damos_add_quota_goal(quota, goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are


