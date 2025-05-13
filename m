Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C5C3214
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119202; cv=none; b=KC0drA34TCK2V+eK3oS28UXv/SFxzwfCfjhBUbp+yH+6+xHsqtwJRMNtUwls11t1tGnck+6+QQSDGcpU93Fy5e/8tOYGjpkxmgR3nU+w2mocQGut5PwPA8jbDgRZvrz4mWIwb2RCCpxVBmRsEjKQV+RlU9isdvcPDbSqNkc7IRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119202; c=relaxed/simple;
	bh=qruXFwafU2Tx7+gC66oj7xFT32AFB2ttPzkwvcNzjhw=;
	h=Date:To:From:Subject:Message-Id; b=RqSJnHKty+cWKBIReY4VFD4gvTv0hku4EtxaWxZz5rVyAdnucKyyhFoPy5ngphj83X3/qjt9z/aiI0p8ue/yEUE9hqhkEffruQmgggcRXTTxvQf958cBjI6YfAAJx4dLEtLAeTTcB5bYbjkyLl/R16BZJDejGppBKyqTIdyj0k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e7J0SWPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e7J0SWPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5A5C4CEE4;
	Tue, 13 May 2025 06:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119202;
	bh=qruXFwafU2Tx7+gC66oj7xFT32AFB2ttPzkwvcNzjhw=;
	h=Date:To:From:Subject:From;
	b=e7J0SWPeMKBAXBgv1s0hY5LORUw/yDH0gm4u02oBQ5nu3h4To0zrpdKymBf+VnL3L
	 ghlcr7Ble3qj/F1N9kdFstqm9cJJqnBf0O7rYVEejgfAosfJ1RGHs41kfIfUSyokxc
	 xWaUsqQa2tlESqS7mGgoNZfXANQ1ug6g4uGajdoo=
Date: Mon, 12 May 2025 23:53:21 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch removed from -mm tree
Message-Id: <20250513065321.EB5A5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement file for quota goal nid parameter
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement file for quota goal nid parameter
Date: Sun, 20 Apr 2025 12:40:25 -0700

DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP DAMOS quota goal metrics require the
node id parameter.  However, there is no DAMON user ABI for setting it. 
Implement a DAMON sysfs file for that with name 'nid', under the quota
goal directory.

Link: https://lkml.kernel.org/r/20250420194030.75838-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter
+++ a/mm/damon/sysfs-schemes.c
@@ -936,6 +936,7 @@ struct damos_sysfs_quota_goal {
 	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
+	int nid;
 };
 
 /* This should match with enum damos_action */
@@ -1016,6 +1017,28 @@ static ssize_t current_value_store(struc
 	return err ? err : count;
 }
 
+static ssize_t nid_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+
+	/* todo: return error if the goal is not using nid */
+
+	return sysfs_emit(buf, "%d\n", goal->nid);
+}
+
+static ssize_t nid_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+	int err = kstrtoint(buf, 0, &goal->nid);
+
+	/* feed callback should check existence of this file and read value */
+	return err ? err : count;
+}
+
 static void damos_sysfs_quota_goal_release(struct kobject *kobj)
 {
 	/* or, notify this release to the feed callback */
@@ -1031,10 +1054,14 @@ static struct kobj_attribute damos_sysfs
 static struct kobj_attribute damos_sysfs_quota_goal_current_value_attr =
 		__ATTR_RW_MODE(current_value, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_nid_attr =
+		__ATTR_RW_MODE(nid, 0600);
+
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
+	&damos_sysfs_quota_goal_nid_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damos_sysfs_quota_goal);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

