Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F322215F5C
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343165; cv=none; b=XTvetE5dcDu1Mon0QQsiLKYvu+sidgeLEhH9eYQ7AR/SgPAk2tJvNqSfgqKvBxZFTDTmoX5nWhdMXfpKmxvhtkystsoEjvBcWOtfg4QxJW19Pte8xkfpsgMAPMRP1j+v0KvI/Ig/KP0n7UaIgg1Kq4DpsvDQqQ/jfCVAbqjnZSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343165; c=relaxed/simple;
	bh=eNOnUsezO68Ol2o90ydVKca5r+DTsmV0tlzusXNPfNg=;
	h=Date:To:From:Subject:Message-Id; b=WhUimpgWME3cmgm4iTyccgSBO/eJM+lsybFjWC39iqzEsOHuzy3AIvj57POzeJuW2KF/qwhXO4X3OdAVtM3Vp6UnyLEBI8qjQs+WNRUCJQcuCWjhC8WmZExDVbDCnU/1MomOza3i1mxQqH8mhbIaUXDqvvmf1EuqKsZqnwnpFtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FuFb4eCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FuFb4eCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7B2C4CEF5;
	Mon, 17 Nov 2025 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343165;
	bh=eNOnUsezO68Ol2o90ydVKca5r+DTsmV0tlzusXNPfNg=;
	h=Date:To:From:Subject:From;
	b=FuFb4eCo9LxUO8NsQ89vxKuaiFbRQkn9Io+seQ0YXG9AV7+ZrrBvT19TKGwp7zJPL
	 ppyh4BObawhklvwQap+HHEd6F80CG+U/MFtRAXh5eAfUHTCA+8Dd/zk/N9chEETGw1
	 c5eVt7C+kYvoDNl+MjSqBJvtei+aRfYbU3/rSy1k=
Date: Sun, 16 Nov 2025 17:32:44 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-damos-quota-goal-path-file.patch removed from -mm tree
Message-Id: <20251117013245.1C7B2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document DAMOS quota goal path file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-damos-quota-goal-path-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document DAMOS quota goal path file
Date: Fri, 17 Oct 2025 14:27:02 -0700

A DAMON sysfs interface file for DAMOS quota goal's optional path argument
has been added.  Document it on the ABI doc.

Link: https://lkml.kernel.org/r/20251017212706.183502-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-damos-quota-goal-path-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -303,6 +303,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the nid
 		parameter of the goal.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/path
+Date:		Oct 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the path
+		parameter of the goal.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
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

