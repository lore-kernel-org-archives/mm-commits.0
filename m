Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A774117A2E8
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476166; cv=none; b=sbS/YfmHBnoiZ4tpJsBrywKNIm6GRHXyc0o8R+kdAtYrLcpabIke9UgZWFcaLKn1DVyno9iGXO2lmvqs/4DU+ve+W3iYESlkfs1Bdb8iiPE/7YSKn1V/IBB5DxhJcgHQVHwRUUKvOJo2GSVC8AiaOfnK/ApwQAO05HSfxvElXiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476166; c=relaxed/simple;
	bh=979Q0X2ADg1tiwxrRyVIkKTIP8Faw90PDE042vGPIwY=;
	h=Date:To:From:Subject:Message-Id; b=XzpsH13GiKwYQhLLNneyQpr8zxdmLarP6tbaRo4RPQeVPGH0subUTC9EbmcZ0IsVOCbVWXGZilTMkjW3wWir76vHIh7d8PnkvPDB4Ye9YH4oFW11hnbHspuyAMIxDmhsnNGgfFzv8b36Sckedj+z363kipMNJ/iSc1QjxIvGr0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d0Njxbpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d0Njxbpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F765C19425;
	Wed, 29 Apr 2026 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777476166;
	bh=979Q0X2ADg1tiwxrRyVIkKTIP8Faw90PDE042vGPIwY=;
	h=Date:To:From:Subject:From;
	b=d0Njxbpv8EN7fNCUjbw3xrjDGPzsn9D8Q5tLDBP5YXLOA261LvlFOR/12MmJcZ72x
	 /yg3rQPiEIehcreBk//zZJh3m8fOZt0xOc9FUJoVuzkCnu9amfFZ7mODbQJz0M/Bj4
	 FYNCHuSMzWhtgVSHxSuAjSMXTg33aoQuEw2XOs8w=
Date: Wed, 29 Apr 2026 08:22:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch added to mm-new branch
Message-Id: <20260429152246.3F765C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -475,10 +475,10 @@ directory can be used for installing fil
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

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch
docs-abi-damon-mark-schemes-s-filters-deprecated.patch

