Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955EB22E004
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343254; cv=none; b=aQZJ/l+Jqu5MdKhGE+zny9bTn5XzuIq4LNlW+KQH5P6TyWm5YOK//IdPIy5JvJJNnM7UQ36KaQQ2voP/pNO+YA3IPAyoLbaX2/dyRy2TVB+DR4Mj5Gy251ScuZUKEADQjXXxcfc+JCUcUloFEmUfc9FdRjslSu7A+j9aV08Knuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343254; c=relaxed/simple;
	bh=PQ99GzS3nNbs/IXCe8SawMvmMcDabD7GiPbKO1L74O8=;
	h=Date:To:From:Subject:Message-Id; b=nDBx3CFFGFE0Ncj1AOrhY8tKiK7KjVl9h9Kfa1GTHL0JQML+5vXF4AUaof5viQNUhy1ZBz07OFhVXCDsazHtg167pg/co3BFqUP5bB/66bv9xx4t+jqdSVS5MRDddiaK5SlFuVnuoniVh93Eqh7tIgf4QYwVTDfVGjmlIoN3Ucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bwSsMsu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bwSsMsu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690C2C116D0;
	Mon, 17 Nov 2025 01:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343254;
	bh=PQ99GzS3nNbs/IXCe8SawMvmMcDabD7GiPbKO1L74O8=;
	h=Date:To:From:Subject:From;
	b=bwSsMsu/Y5aKsLQaFecVH6n8ecL2Xis5CIGRnS9XcXRbQlacRxh6djN7nqeoeZtuZ
	 VrY3uWEcCtdLXtFcH68q680ubUT4fF6edrNMK+fkkJ8JankNzfbPYpSUAESE92WtSe
	 VNCdhp3DVcXvG0UNljsvCga27ez3WEOat9OBvXRs=
Date: Sun, 16 Nov 2025 17:34:13 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-test-commit-input-against-realistic-destination.patch removed from -mm tree
Message-Id: <20251117013414.690C2C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: test commit input against realistic destination
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-test-commit-input-against-realistic-destination.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: test commit input against realistic destination
Date: Wed, 22 Oct 2025 18:25:26 -0700

DAMON sysfs interface tests if given online parameters update request is
valid, by committing those using the DAMON kernel API, to a test-purpose
destination context.  The test-purpose destination context is constructed
using damon_new_ctx(), so it has no target, no scheme.

If a source target has the obsolete field set, the test-purpose commit
will fail because damon_commit_targets() fails when there is a source
obsolete target that cannot find its matching destination target.  DAMON
sysfs interface is not letting users set the field for now, so there is no
problem.  However, the following commit will support that.  Also there
could be similar future changes that making commit fails based on current
context structure.

Make the test purpose commit destination context similar to the current
running one, by committing the running one to the test purpose context,
before doing the real test-purpose commit.

Link: https://lkml.kernel.org/r/20251023012535.69625-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-test-commit-input-against-realistic-destination
+++ a/mm/damon/sysfs.c
@@ -1452,6 +1452,26 @@ static struct damon_ctx *damon_sysfs_bui
 		struct damon_sysfs_context *sys_ctx);
 
 /*
+ * Return a new damon_ctx for testing new parameters to commit.
+ */
+static struct damon_ctx *damon_sysfs_new_test_ctx(
+		struct damon_ctx *running_ctx)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = damon_commit_ctx(test_ctx, running_ctx);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
+/*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
@@ -1472,7 +1492,7 @@ static int damon_sysfs_commit_input(void
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_new_ctx();
+	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
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

