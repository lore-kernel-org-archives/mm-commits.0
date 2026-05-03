Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A796B13C9C4
	for <mm-commits@vger.kernel.org>; Sun,  3 May 2026 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777814166; cv=none; b=OX6W0Qu9VKSUhHD5CFDVgmea427zl48paSzblja12r7rm04XW3DOLN2E+puUZ8FPVuXrVi8/ksfXYoWkGO0+gSwkCbv5McJQfH+/J/BM6w9O3YuV2LiMk98a/MWz75PYnwruOFtfiUe08EADsq8szXhvjp3lqesghN0WZu/GLyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777814166; c=relaxed/simple;
	bh=rFvZFuuLnRas2jxZh5ITeqrRd12OasR8L13V+oHkmnQ=;
	h=Date:To:From:Subject:Message-Id; b=mpQYDm2Y8DQsngJ1NYMWWXwpwaaQOKfb/83ALHOvuw1yjlFJMOw8O48SLCFJul/4ems7pEbNgAgBF8PTm+m4dPwpbCCaiv4IPqxqJnnEFbUujV4b2XHC+HKF6yqj3pHsO4VSmDDxdqmr1BkYI8p25q2YLikzcbZBJvXmGruyXYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZ7f8jBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZ7f8jBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE705C2BCB4;
	Sun,  3 May 2026 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777814166;
	bh=rFvZFuuLnRas2jxZh5ITeqrRd12OasR8L13V+oHkmnQ=;
	h=Date:To:From:Subject:From;
	b=CZ7f8jBmugm0CFzaVWaTvNxrUKRRvyDnRsD2bh+ISNSdEm4wUS1kx61xbKl5HyMgr
	 QGbTSEhYozSj+tfPxoHdRTtG85Qw9aMV/EGeyiH2eytlu4rSCCNRkTesLLXjNnTkYY
	 0ThSc4pdqIvPCrSAl5I1gH36jXxblLTuWHuAVtUU=
Date: Sun, 03 May 2026 06:16:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch added to mm-new branch
Message-Id: <20260503131605.CE705C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch

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
Subject: Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Fri, 1 May 2026 19:05:04 -0700

Update DAMON_STAT usage document for newly added kdamond_pid parameter.

Link: https://lore.kernel.org/20260502020505.80822-3-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/stat.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -89,3 +89,10 @@ percentiles of the idle time values via
 parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_STAT is enabled, this becomes the PID of the worker thread.  Else, -1.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch
mm-damon-core-merge-regions-after-applying-damos-schemes.patch
mm-damon-core-introduce-failed-region-quota-charge-ratio.patch
mm-damon-sysfs-schemes-implement-fail_charge_numdenom-files.patch
docs-mm-damon-design-document-fail_charge_numdenom.patch
docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch
docs-abi-damon-document-fail_charge_numdenom.patch
mm-damon-tests-core-kunit-test-fail_charge_numdenom-committing.patch
selftests-damon-_damon_sysfs-support-failed-region-quota-charge-ratio.patch
selftests-damon-drgn_dump_damon_status-support-failed-region-quota-charge-ratio.patch
selftests-damon-sysfspy-test-failed-region-quota-charge-ratio.patch
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
mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch
docs-admin-guide-mm-damon-reclaim-update-for-autotune_monitoring_intervals.patch
mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch
docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch

