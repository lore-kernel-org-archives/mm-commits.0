Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A10370AF8
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027688; cv=none; b=ZN6IjbaLGyPJekqsUA78r4wKwfMUnc1WqYCvAgO9FomFmy/BjgincXCg4ZBPRUsUjc9A9u+vlbocdqSPsN1SVpH8yYluZl9BproJw704jXJDoBMMKhu1Oz6W0RHggeWYqoZ8HAU36Mw1Dql6rxTuVjs7GV5sI0PAwvLHHZ6rhMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027688; c=relaxed/simple;
	bh=iy801vqCnKr0cP16zwaZZy19DRILfyLKfdZ7A4uFoKw=;
	h=Date:To:From:Subject:Message-Id; b=kA4F+CaenqXRjL3W3C1RMEY/ZYZj9Jv4eo/STBTVrZnWUxGXw9iyt4DRcHOaNC0GQ9XggBxO8BXkKs8gdvfmgYhN50Bhq4OcPf9xBS/wUAXhJTswdULmzdhxqYORGa0I9lbR4Q32ePL/Owm8sNQosce1gTWfOFa+rZGYZHZ1Rrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=knkECZB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="knkECZB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50A81F00893;
	Fri, 29 May 2026 04:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027686;
	bh=YRJTzQ4ngkqNpv+YQn6WbLU537aPpGFC2HJ4dFMM78k=;
	h=Date:To:From:Subject;
	b=knkECZB5XwuCbHhQP4pVwEMLa8klax+dzGIaviQ+FdZisVYdccUj+VjWJCIr7OTia
	 sC/bnY/OxyE6Kjpyi01pR64juXTKcWt0i+9viUpxNblaLHcpvHlXkAYeaWxEkkNLuL
	 z4I9UQHbxlb6SBiWpdg+71/fx3pgLi7ZyaeGpE/8=
Date: Thu, 28 May 2026 21:08:06 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch removed from -mm tree
Message-Id: <20260529040806.B50A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated
Date: Wed, 29 Apr 2026 08:03:05 -0700

Patch series "mm/damon/sysfs: document filters/ directory as deprecated".

Commit ab71d2d30121 ("mm/damon/sysfs-schemes: let
damon_sysfs_scheme_set_filters() be used for different named directories")
introduced alternatives of 'filters' directory, namely core_filters/ and
'ops_filters/ directories.  Now the alternatives are well stabilized and
ready for all users.  All filters/ directory use cases are expected to be
able to be migrated to the alternatives.  An LTS kernel having the
alternatives, namely 6.18.y, is also released.  Existence of filters/
directory is only confusing.

It would be better not immediately removing the directory, though.  There
could be users that need time before migrating to the alternatives.  There
might be unexpected use cases that the alternatives cannot support.  Doing
the deprecation step by step across multiple years like DAMON debugfs
deprecation would be safer.  Start the deprecation changes by announcing
the deprecation on the documents.

Every year, one more action for completely removing the directory will be
followed, like DAMON debugfs deprecation did.  Following yearly actions
are currently expected.  In 2027, deprecation warning kernel messages will
be printed once, for use of filters/ directory.  In 2028, filters/
directory will be renamed to filters_DEPRECATED/.  In 2029,
filters_DEPRECATED/ directory will be removed.


This patch (of 2):

The alternatives of 'filters/' directory, namely 'core_filters/' and
'ops_filters/', can fully support all the features 'filters/' directory
can do, and provide better user experience.  Having 'filters/' directory
is only confusing to users.  Announce it as deprecated on the usage
document.

Link: https://lore.kernel.org/20260429150309.82282-1-sj@kernel.org
Link: https://lore.kernel.org/20260429150309.82282-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -485,10 +485,10 @@ directory can be used for installing fil
 layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
 installed before those of ``filters``.  All three directories have same files.
 
-Use of ``filters`` directory can make expecting evaluation orders of given
-filters with the files under directory bit confusing.  Users are hence
-recommended to use ``core_filters`` and ``ops_filters`` directories.  The
-``filters`` directory could be deprecated in future.
+Use of ``filters`` directory can make filters evaluation orders confusing to
+expect.  For this reason, ``filters`` directory is deprecated.  It is still
+functioning, but is scheduled for removal in the near future.  Users should use
+``core_filters`` and ``ops_filters`` directories instead.
 
 In the beginning, the directory has only one file, ``nr_filters``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

