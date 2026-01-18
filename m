Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00A2253EF
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768764083; cv=none; b=ZaBnWSItE/9coBz0t+k6O/O9P4br7Vau7hyHS2ev9h07F9jfA7jCkWZuQaMamnlEbbZXfFeX+ZIUc+we1Jcc4uH6nxVLSv7PEZ7BqjgryzHIRo08esCytigT7fIHEW0KIGj8So1Z2Nnwr9d+Ly0mFe5QTskX+pc3VuShUsExwqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768764083; c=relaxed/simple;
	bh=vhw/Eoz7S2arYkN7vJq3vcyV2Bprh3emI1Rm/zypGks=;
	h=Date:To:From:Subject:Message-Id; b=e2ZrQHUTwtgzOXeD4vbrzQuRnWWAwAOcNhMVNWcVKANv3H74KjtRDLT8yxGp5WyPvythrJfQGYI094DESHEv+vBE3RX8QexPt34mSkdrcAT7BFy5DlolE1zxJDFgIafJFtUAdCiS85rX6DLgazfkvgUMUFtNK581XhsNHeCNY/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DfH/pVlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DfH/pVlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D101C116D0;
	Sun, 18 Jan 2026 19:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768764083;
	bh=vhw/Eoz7S2arYkN7vJq3vcyV2Bprh3emI1Rm/zypGks=;
	h=Date:To:From:Subject:From;
	b=DfH/pVlz3SemPsuUoll2HLFzKj4kxQx4bf6UFrg0v7fut4LQ+xFDGWCw7gP2jG/0J
	 d0WVii9ptdZldZ9Kt4mlqg+hOismE+tECCM1c7m2rxMqoyJZUdoYV6Biz4uOGhrYJX
	 Eu4MfsH9qPICPbzEgSa3IdMM7CmSucVO8H3vH2SY=
Date: Sun, 18 Jan 2026 11:21:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-damon-sample-modules.patch added to mm-new branch
Message-Id: <20260118192123.1D101C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document DAMON sample modules
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-damon-sample-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-damon-sample-modules.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: Docs/mm/damon/design: document DAMON sample modules
Date: Sun, 18 Jan 2026 10:02:54 -0800

People sometimes get confused about the purposes of DAMON special-purpose
modules and sample modules.  Clarify those on the design document by
adding a section describing their existence and purposes.

Link: https://lkml.kernel.org/r/20260118180305.70023-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damon-sample-modules
+++ a/Documentation/mm/damon/design.rst
@@ -836,3 +836,16 @@ modules for proactive reclamation and LR
 more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
+
+
+Sample DAMON Modules
+--------------------
+
+DAMON modules that provides example DAMON kernel API usages.
+
+kernel programmers can build their own special or general purpose DAMON modules
+using DAMON kernel API.  To help them easily understand how DAMON kernel API
+can be used, a few sample modules are provided under ``samples/damon/`` of the
+linux source tree.  Please note that these modules are not developed for being
+used on real products, but only for showing how DAMON kernel API can be used in
+simple ways.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch

