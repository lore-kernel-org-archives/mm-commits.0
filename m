Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FD62367B5
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343244; cv=none; b=Oz1tZak1RkcPp3P6VrphEs63Zc6DTw4/jnw2NLOorzvCqMTRXApvyRUFoiHj0tWYL4wnVXNTu0Ky5UJwv2ntfyNvfi4/oO7djSh8VGO/w7f0eewiEAHUWMbL0QcsiljCXB/cBjDvEeFVFFB0KUrgbVhHReHI41yVsa/2R1A0Kpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343244; c=relaxed/simple;
	bh=++DN1FkdWdJaWuvSUW/u+NPB+UT7Iz21uX7rgau+z84=;
	h=Date:To:From:Subject:Message-Id; b=qxsvJ/AmEfgBzsUymafYKbdifOCM+MMal6FV5HMFRabjUpl+cJFYKpBwAnbUcibZIhz+fb06KE3kRFb6twhK0PaCoV7tpnBpAkGMrMdXfRaVfodDQ9S1n6JDgZ8RrBUVYFpNLO0v7ganP0FbfBn7cUD4TXVFF4ZaYEHbr3d5uVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8MHaSRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8MHaSRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A052EC4CEF1;
	Mon, 17 Nov 2025 01:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343244;
	bh=++DN1FkdWdJaWuvSUW/u+NPB+UT7Iz21uX7rgau+z84=;
	h=Date:To:From:Subject:From;
	b=N8MHaSRJAqlOpwmKX0mkmKGHObZvo2dG2fdEcc2/jzxoGkdV/VBF0iavASQHpPcB+
	 LObt9aC9anQeFTIXfgA6kdmJV7GEqsy27i3GiDY8O1zNBa7THYFGAJ5EfBDxEU8ROO
	 7h2JQ97vQQn5QZLEjNNDnO1tXkOs2KR5LkzSyK8E=
Date: Sun, 16 Nov 2025 17:34:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch removed from -mm tree
Message-Id: <20251117013404.A052EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/stat: fix a typo: s/sampling events/sampling interval/
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/stat: fix a typo: s/sampling events/sampling interval/
Date: Sun, 26 Oct 2025 11:22:08 -0700

It is a contextual typo.  Fix it.

Link: https://lkml.kernel.org/r/20251026182216.118200-4-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/stat.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -17,7 +17,7 @@ DAMON_STAT uses monitoring intervals :re
 <damon_design_monitoring_intervals_autotuning>` to make its accuracy high and
 overhead minimum.  It auto-tunes the intervals aiming 4 % of observable access
 events to be captured in each snapshot, while limiting the resulting sampling
-events to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
+interval to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
 production server systems, it resulted in consuming only 0.x % single CPU time,
 while capturing reasonable quality of access patterns.
 
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

