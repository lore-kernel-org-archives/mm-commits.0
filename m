Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA30233134
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343243; cv=none; b=KzGrYYsLrudfDEUhiG5hMUhbWo/WNiMQGcewiAYqb9ygNgqCUtWM8+IrtJ4bPR3Dq1j8aZKiEnXhWImz6wZVJhqKeF+78HMW6PVbJl6Irg7UIt09xXDyyN/iYuEj5TqfWgW8JvSpBiCHxqmv3fKluCZv6LnWhlnzK3vQM4Cv8j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343243; c=relaxed/simple;
	bh=BUisCeVKztwsaccrWHY0GKHq7ZEXHevaDOnGzBu4AA8=;
	h=Date:To:From:Subject:Message-Id; b=qFJDirustaSwQxyO/Dhf7gzfo6/e4bwOik1NOE7z5LmSen/Kdk2/A7/DeCRbYPAohhB5Mjrg0UdiVO6l0q7d5qLgb4PKuw5I0jqv4/InQgymzLdTmr8n+7SRadTb302r5UdcMesq8PltkZFMtX93eOr2VEo4x45nPWE2r59dCe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=spqhmbY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="spqhmbY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AB1C19421;
	Mon, 17 Nov 2025 01:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343243;
	bh=BUisCeVKztwsaccrWHY0GKHq7ZEXHevaDOnGzBu4AA8=;
	h=Date:To:From:Subject:From;
	b=spqhmbY7cQwAksUZG/GUD7SpFGlQmiQPTzxizbyxG2HNuf71bYjszEhSRrqzPhKBx
	 9YOGWdz1MN0Hp4LTMNbKTRl1F44y9x3JiflDVQ7o6rk84c2Pyp+dSTJsEzTFw++8HG
	 8GMpAZ2uLbHYc7l62Ddx05zj6GoFHT1hIN3XO0oI=
Date: Sun, 16 Nov 2025 17:34:02 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch removed from -mm tree
Message-Id: <20251117013403.42AB1C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix wrong link to intervals goal section
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: fix wrong link to intervals goal section
Date: Sun, 26 Oct 2025 11:22:07 -0700

Commit b243d666d107 ("Docs/admin-guide/mm/damon/usage: add intervals_goal
directory on the hierarchy") mistakenly added a wrong reference for
intervals goal usage documentation on the design document.  Fix it.

Link: https://lkml.kernel.org/r/20251026182216.118200-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section
+++ a/Documentation/mm/damon/design.rst
@@ -381,8 +381,8 @@ That is, assumes 4% (20% of 20%) DAMON-o
 to capture 64% (80% multipled by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:`intervals_goal <sysfs_scheme>` part of
-the documentation.
+<sysfs_interface>`, refer to :ref:`intervals_goal
+<damon_usage_sysfs_monitoring_intervals_goal>` part of the documentation.
 
 
 .. _damon_design_damos:
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

