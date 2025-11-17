Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EA023A9AD
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343257; cv=none; b=Jyaew5wVkHNbPsCEGS8lfZz2aJiKeq+x4ilOu1vkToveloMYUlS+O8E5UHRcVOs1gA8dOtg0QaWGnenjc5VFONePBxAwDSGz7Mz7heMZbTxctkM+mNI6/LLaSuxNeKbPlEVh4D9mQUMmQTMWs7BGkU4iPib56QPjsljeerdSkDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343257; c=relaxed/simple;
	bh=7MiM2X4DzUBNjszefd5k24JwabHK5603q+wCSHb7H5o=;
	h=Date:To:From:Subject:Message-Id; b=BzUCGxWQz3HBruCoslvdio9xtfW9CGGMNAo0NzG7WGpOt8ytrODfuHjHCxwpAy3TuqAeZHOPYD1gnK2+TRl44vOSZM3VLae5S8nqqQ7P/ChJ/X5MDTHS07nacgjql8M3xogr4ulE2yu7l9N8cK3Rd9zEKxlO1zh9ZynDoVF0fGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z/PENSyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z/PENSyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5A1C4CEF1;
	Mon, 17 Nov 2025 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343257;
	bh=7MiM2X4DzUBNjszefd5k24JwabHK5603q+wCSHb7H5o=;
	h=Date:To:From:Subject:From;
	b=z/PENSyLROjeCGrutlgqs+GRTYka/EZFwTmLpYNVuHGZXf4pjkxPHbDhfWwhAr1Mx
	 LQUooOc2PqR3rWAy5gmbSNnQFsyCYYauP+ZInTe2gUAofbTQNcW0JnxI+ysx+HRl+H
	 YnnsMnkXNQ2a3jkenCv7mV6/ywLm/Xfw/RCO5Z2c=
Date: Sun, 16 Nov 2025 17:34:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch removed from -mm tree
Message-Id: <20251117013416.DE5A1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document obsolete_target file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document obsolete_target file
Date: Wed, 22 Oct 2025 18:25:28 -0700

Document the newly added obsolete_target DAMON sysfs file.

Link: https://lkml.kernel.org/r/20251023012535.69625-5-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-obsolete_target-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -67,7 +67,7 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
-    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target
+    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
     │ │ │ │ │ │ │ │ :ref:`0 <sysfs_region>`/start,end
     │ │ │ │ │ │ │ │ ...
@@ -265,13 +265,20 @@ to ``N-1``.  Each directory represents e
 targets/<N>/
 ------------
 
-In each target directory, one file (``pid_target``) and one directory
-(``regions``) exist.
+In each target directory, two files (``pid_target`` and ``obsolete_target``)
+and one directory (``regions``) exist.
 
 If you wrote ``vaddr`` to the ``contexts/<N>/operations``, each target should
 be a process.  You can specify the process to DAMON by writing the pid of the
 process to the ``pid_target`` file.
 
+Users can selectively remove targets in the middle of the targets array by
+writing non-zero value to ``obsolete_target`` file and committing it (writing
+``commit`` to ``state`` file).  DAMON will remove the matching targets from its
+internal targets array.  Users are responsible to construct target directories
+again, so that those correctly represent the changed internal targets array.
+
+
 .. _sysfs_regions:
 
 targets/<N>/regions
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

