Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EF319D093
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744869; cv=none; b=lpedYj+YVkfGxpReWMq8ks0MoA2J8E4isQS5rytbSlDHAQlbWd9pjsCe6U00KGEMp2bIqlb9TigeKfr1D6p0nN6r8yFEYoWza57JrNiViIrf04NdXsgMl/McDyOHa+O6lXBCuIL7F0LK9nSDievgkgVRupq62Oovwv9UTnv7dk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744869; c=relaxed/simple;
	bh=jbza7Yt2oW0Ti++vdlCe9G5IGThW4k/JaxJRdcNDXZ8=;
	h=Date:To:From:Subject:Message-Id; b=IdDJvgxWmq9rKzHknM8mYFKcZeA1Jki5+/1imzzUSpNBan5bhfzXjJt9LaxuthMfh6ZwPO0588Yj54Jtz2HI1EpqMZOwrb0k+uj4nsVH/ydQyVrqJ6oIg8tPMEoVrOJXm4NK2ktpT9F0jurvJd4ZDAeUMzc24PAo1aFVm6OIwZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KYTqNfuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KYTqNfuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B78AC4CEF7;
	Sun, 29 Mar 2026 00:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744869;
	bh=jbza7Yt2oW0Ti++vdlCe9G5IGThW4k/JaxJRdcNDXZ8=;
	h=Date:To:From:Subject:From;
	b=KYTqNfuSza8beqdjpRs9Nam8W1FLXOcyI0xd7cZgf8xT03w+mutEerQSSI4J1kEWD
	 7eRJAq4vdD8FkJn6+VHmjYAYj8KYInD0MrImDgrFiaDZcaydSaiwf4S2GQmvom3OBK
	 kx7asv4yQM8N8EBaLRQASAjqEjnIImI/VzFu7NjY=
Date: Sat, 28 Mar 2026 17:41:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch removed from -mm tree
Message-Id: <20260329004109.5B78AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement quotas->goal_tuner file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement quotas->goal_tuner file
Date: Mon, 9 Mar 2026 18:05:20 -0700

Add a new DAMON sysfs interface file, namely 'goal_tuner' under the DAMOS
quotas directory.  It is connected to the damos_quota->goal_tuner field. 
Users can therefore select their favorite goal-based quotas tuning
algorithm by writing the name of the tuner to the file.  Reading the file
returns the name of the currently selected tuner.

Link: https://lkml.kernel.org/r/20260310010529.91162-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   58 +++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file
+++ a/mm/damon/sysfs-schemes.c
@@ -1488,6 +1488,7 @@ struct damon_sysfs_quotas {
 	unsigned long sz;
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
+	enum damos_quota_goal_tuner goal_tuner;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1610,6 +1611,58 @@ static ssize_t effective_bytes_show(stru
 	return sysfs_emit(buf, "%lu\n", quotas->effective_sz);
 }
 
+struct damos_sysfs_qgoal_tuner_name {
+	enum damos_quota_goal_tuner tuner;
+	char *name;
+};
+
+static struct damos_sysfs_qgoal_tuner_name damos_sysfs_qgoal_tuner_names[] = {
+	{
+		.tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.name = "consist",
+	},
+	{
+		.tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.name = "temporal",
+	},
+};
+
+static ssize_t goal_tuner_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_tuner_names); i++) {
+		struct damos_sysfs_qgoal_tuner_name *tuner_name;
+
+		tuner_name = &damos_sysfs_qgoal_tuner_names[i];
+		if (tuner_name->tuner == quotas->goal_tuner)
+			return sysfs_emit(buf, "%s\n", tuner_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t goal_tuner_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_qgoal_tuner_names); i++) {
+		struct damos_sysfs_qgoal_tuner_name *tuner_name;
+
+		tuner_name = &damos_sysfs_qgoal_tuner_names[i];
+		if (sysfs_streq(buf, tuner_name->name)) {
+			quotas->goal_tuner = tuner_name->tuner;
+			return count;
+		}
+	}
+	return -EINVAL;
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1627,11 +1680,15 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
 		__ATTR_RO_MODE(effective_bytes, 0400);
 
+static struct kobj_attribute damon_sysfs_quotas_goal_tuner_attr =
+		__ATTR_RW_MODE(goal_tuner, 0600);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
 	&damon_sysfs_quotas_effective_bytes_attr.attr,
+	&damon_sysfs_quotas_goal_tuner_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
@@ -2718,6 +2775,7 @@ static struct damos *damon_sysfs_mk_sche
 		.weight_sz = sysfs_weights->sz,
 		.weight_nr_accesses = sysfs_weights->nr_accesses,
 		.weight_age = sysfs_weights->age,
+		.goal_tuner = sysfs_quotas->goal_tuner,
 	};
 	struct damos_watermarks wmarks = {
 		.metric = sysfs_wmarks->metric,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

