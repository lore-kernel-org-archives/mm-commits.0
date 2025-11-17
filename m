Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE501F9F47
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343158; cv=none; b=sbZ1o2ddcdcvNZOKpajXNEszZq8UQtjHF5UFh71BHChiBS6CemNxUHmspGNqannv2HIXWYTkUXKwAVQIX8VrDj3U88uCbEDWJlgHbeUhC0FSLWdVeiU+FmSGwUxj5jmufxmhCUoTlB19GHjJ5FJ71OqdtibNUzXo9mnZha3EqqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343158; c=relaxed/simple;
	bh=JEupVjvne/g4Ajv1axsGv7T+YlCXWyH003d3j7swgTI=;
	h=Date:To:From:Subject:Message-Id; b=L7GBH/Z2DLMCn6ct4d+RZoPW2dnqOZCSFGfy69YzJUltIocOn5Zsonm3UGYbcxb28yaK3jo/bBW4UA2Bl3qOOpjPfN65La1gKYuNWyFb6QZnO7TL/IU8hd14/FZTpHOx2psQDBxM+lJGccISvgYx96yKz6ACQE2DWWYKAzTzHrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YaS+56/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YaS+56/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC7AC116D0;
	Mon, 17 Nov 2025 01:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343158;
	bh=JEupVjvne/g4Ajv1axsGv7T+YlCXWyH003d3j7swgTI=;
	h=Date:To:From:Subject:From;
	b=YaS+56/3pGxiefKVoUIka0dVFwmKlbqjthtm5ycPhhltxTf4CSYRhbbDST1D/TRzV
	 +tWigXYlZOu9MahSniO1n1zISHqNHJqEueGiTACAiwAOCQJ8sDHVHgyeaV6l6cgtW0
	 eelfKOQITnm0FO6spvRnCpnt2+wnedNz5HNmcW4E=
Date: Sun, 16 Nov 2025 17:32:37 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch removed from -mm tree
Message-Id: <20251117013238.1EC7AC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement path file under quota goal directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement path file under quota goal directory
Date: Fri, 17 Oct 2025 14:26:56 -0700

Add a DAMOS sysfs file for specifying the cgroup of the interest for
DAMOS_QUOTA_NODE_MEMCG_USED_BP.

Link: https://lkml.kernel.org/r/20251017212706.183502-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   38 +++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -999,6 +999,7 @@ struct damos_sysfs_quota_goal {
 	unsigned long target_value;
 	unsigned long current_value;
 	int nid;
+	char *path;
 };
 
 static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
@@ -1128,10 +1129,39 @@ static ssize_t nid_store(struct kobject
 	return err ? err : count;
 }
 
+static ssize_t path_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+}
+
+static ssize_t path_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
+				   GFP_KERNEL);
+
+	if (!path)
+		return -ENOMEM;
+
+	strscpy(path, buf, count + 1);
+	kfree(goal->path);
+	goal->path = path;
+	return count;
+}
+
 static void damos_sysfs_quota_goal_release(struct kobject *kobj)
 {
-	/* or, notify this release to the feed callback */
-	kfree(container_of(kobj, struct damos_sysfs_quota_goal, kobj));
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	kfree(goal->path);
+	kfree(goal);
 }
 
 static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
@@ -1146,11 +1176,15 @@ static struct kobj_attribute damos_sysfs
 static struct kobj_attribute damos_sysfs_quota_goal_nid_attr =
 		__ATTR_RW_MODE(nid, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_path_attr =
+		__ATTR_RW_MODE(path, 0600);
+
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	&damos_sysfs_quota_goal_nid_attr.attr,
+	&damos_sysfs_quota_goal_path_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damos_sysfs_quota_goal);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

