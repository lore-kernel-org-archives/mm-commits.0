Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FBE3F54C5
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777467130; cv=none; b=NubqJqo5cdpYkfENB5tziAwaR/SmF8OWX0hhCd3ClQCuUP3HpnxS9ABvdcFkPULkE5cgBLuSctfcLiVjPHmsYfR3zwCbRc0CQSBgidHGcPOno+siQGMpVuwL437v/igIQ4BpSThAdOXkk7w7uZq5LAg67fDEGugzdTpy29C5oNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777467130; c=relaxed/simple;
	bh=zynYvgoJzgkLsD29ZIXIrt7KK9c8X1kE/8en2cfaksA=;
	h=Date:To:From:Subject:Message-Id; b=NAmX5arMF358mOeW9F0z5ototXgom0UWxztHyxrjDyfTJT0bREebYZ3KQToBVQCBOJt8ObTjMNcx8vqtxyAF1Hx58eRhXB95SnfXyYGgl5hOQkdkiPMevVMynSLb6vcLkY+xRs/YzGm7nLsjnYwfpkmyNnGdKLDPVdqIE0rlWoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzFqkVPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzFqkVPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBDBC19425;
	Wed, 29 Apr 2026 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777467129;
	bh=zynYvgoJzgkLsD29ZIXIrt7KK9c8X1kE/8en2cfaksA=;
	h=Date:To:From:Subject:From;
	b=ZzFqkVPNK9fgft4LRuooUYMGzk9JRbWs5Ljro8RfJVCOZmNfi4WlwA6kxoXIJf0WW
	 UtFDCMyfj76mMqO8bapLm/LfNI4hk7jxSnDW0MPdR9Xr2goM7KcUBAFBuLbI2oMoI3
	 TyTeECjeNJBXqf4GYJw953QfuMKP7trGw5V2xqU8=
Date: Wed, 29 Apr 2026 05:52:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch added to mm-new branch
Message-Id: <20260429125209.AEBDBC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch

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
Subject: Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring
Date: Tue, 28 Apr 2026 21:12:28 -0700

Update DAMON_RECLAIM usage document for the changed default monitoring
target region selection.

Link: https://lore.kernel.org/20260429041232.90257-7-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/reclaim.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -229,7 +229,8 @@ Start of target memory region in physica
 
 The start physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
-and reclaims.  By default, biggest System RAM is used as the region.
+and reclaims.  By default, the system's entire physical memory is used as the
+region.
 
 monitor_region_end
 ------------------
@@ -238,7 +239,8 @@ End of target memory region in physical
 
 The end physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
-and reclaims.  By default, biggest System RAM is used as the region.
+and reclaims.  By default, the system's entire physical memory is used as the
+region.
 
 addr_unit
 ---------
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

