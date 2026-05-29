Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60560370D49
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027689; cv=none; b=JwjMV8CnlsXQEQFgCGj9lIULkJhU6pp5xU6XbP3laBiec6wTAFkvjIxcz0ZiR2bVllEn26OJEmRzrC/IOJoqcx3dzDPdErvtB/U1bOtLU0+HgGR1kj11KZjHEZIJOmOdOD3dk/YAMMmzG156J/yQ6sPJLmHEZ2b3oymCzzl/MW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027689; c=relaxed/simple;
	bh=Amr5H2pRy0TaK0Fit/F1/Fc9sXL66tJQxc9n19hpGHI=;
	h=Date:To:From:Subject:Message-Id; b=brmWIOUSs0gzNJ1u3AtUY4SgBmj+yAsW1nZ7CCUe7DsZGQqK99RRkyjvHvd8hpuY/jZGdmMTSsLvCpFLsw3ckLOCwXMxWXzRjXi/Qbg1+F/ezBZXwa9YvWQPMme9jxDiwcV4Fb6qo9PQWMsPSc+hEjqdDEgWAbslulijAaGQpMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2WX/H3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2WX/H3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76BA1F00898;
	Fri, 29 May 2026 04:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027688;
	bh=ffxQndfDlEdRgZ1qGtugSY+XHr9hW0tnus3VRaL3slk=;
	h=Date:To:From:Subject;
	b=Z2WX/H3X1TF5Ra90equjB1NxPh6OD+g3VEYPhsaajun3WSr+YJC088acRc2r1u4N1
	 VPxgXWud1NJt8PlUKGXFTuLCFHdScSx/ZLZhnfpOYMEc1lpBBGkJm/R5HMlDAeNaoc
	 u1NlvSh/wWBOFg+qePyMutFfrrMb5mJVUTZkSRVk=
Date: Thu, 28 May 2026 21:08:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-mark-schemes-s-filters-deprecated.patch removed from -mm tree
Message-Id: <20260529040807.D76BA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: mark schemes/<S>/filters/ deprecated
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-mark-schemes-s-filters-deprecated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: mark schemes/<S>/filters/ deprecated
Date: Wed, 29 Apr 2026 08:03:06 -0700

Now the 'filters/' directory is deprecated.  Update ABI document to also
announce the fact.  Also update the descriptions of the files to be based
on 'core_filter/' directory, to make the old descriptions ready to be
removed when the time arrives.

Link: https://lore.kernel.org/20260429150309.82282-3-sj@kernel.org
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

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   62 +++++++-------
 1 file changed, 34 insertions(+), 28 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-mark-schemes-s-filters-deprecated
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -396,15 +396,20 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the low
 		watermark of the scheme in permil.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/nr_filters
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMON core layer-handled DAMOS filters.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/nr_filters
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting filters of the scheme named '0' to
-		'N-1' under the filters/ directory.
+		'N-1' under the core_filters/ directory.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/type
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/type
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
@@ -412,77 +417,78 @@ Description:	Writing to and reading from
 		'addr' for address range (an open-ended interval), or 'target'
 		for DAMON monitoring target can be written and read.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/memcg_path
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_start
-Date:		Jul 2023
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_start
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the start address of the address
 		range for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_end
-Date:		Jul 2023
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_end
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the end address of the address
 		range for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/min
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/min
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the minimum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/max
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/max
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/target_idx
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
 		reading from this file sets or gets the index of the DAMON
 		monitoring target of the interest.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/matching
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
 		the memory of the 'type', or all except the 'type'.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/allow
-Date:		Jan 2025
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/allow
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		applying the scheme's action to the memory that satisfies the
 		'type' and the 'matching' of the directory.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
-Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
-Description:	Directory for DAMON core layer-handled DAMOS filters.  Files
-		under this directory works same to those of
-		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
-		directory.
-
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/ops_filters
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Directory for DAMON operations set layer-handled DAMOS filters.
 		Files under this directory works same to those of
-		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
 		directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+Date:		Dec 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMOS filters.  Files under this directory works
+		same to those of
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/{core,ops}_filters
+		directory.  This is deprecated.  Use the core_filters and
+		ops_filters instead.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/nr_dests
 Date:		Jul 2025
 Contact:	SeongJae Park <sj@kernel.org>
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

