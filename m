Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735E943D4F9
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777387749; cv=none; b=fKgVw03iV3tq3zOi6IwhUhJRQDsIbwpK2777WqH33iOqR3f8sx3dRx0aNdTnFIVNTylbCh8l3kbU9KppylEqTmvsYQH3nA39KT4BIIlJRPEmD9M9i2G6MJMwFcgYNqanI+SLACB4rd755uGBETKs2b3eFN4Wi7z8B/TsIOx0928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777387749; c=relaxed/simple;
	bh=3dVYW9pBUihgxfkRWEQAXpNuWgaBT3WWrohVGrF9Oxo=;
	h=Date:To:From:Subject:Message-Id; b=NqQjQ9xVfZLiwjJwPy6YNF+8sMVnJhSNceLlK1WTUYCMuEkQvDty7NJc2H2s75e3wpyx808iWpGQ8giAfRrzh1mvVEINcInkYzqSxFKxKL4PKNFaVZKJYyzp4B6vnHP1EjktIziNuNJXbpl2DGSfLStLwBDKxlH3gsIZd+t16k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rH4wm0E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rH4wm0E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7F4C2BCAF;
	Tue, 28 Apr 2026 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777387749;
	bh=3dVYW9pBUihgxfkRWEQAXpNuWgaBT3WWrohVGrF9Oxo=;
	h=Date:To:From:Subject:From;
	b=rH4wm0E2I1uML3F+BEdRal65y4P3i8EZ6tRmBXOPdtodVZKKfvHG1MoxA5zvTfGlp
	 AECT7cGGsoGkT0NReuOZB9VC5SOUAkufcCBG1/1+CgYWaYNML89jhC6pMLl1FocL1x
	 fYjUdxwRd00YKO7SF1Fo5KJEWI911DDU+NibNf3U=
Date: Tue, 28 Apr 2026 07:49:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-fail_charge_numdenom.patch added to mm-new branch
Message-Id: <20260428144909.4A7F4C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document fail_charge_{num,denom}
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-document-fail_charge_numdenom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-fail_charge_numdenom.patch

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
Subject: Docs/ABI/damon: document fail_charge_{num,denom}
Date: Mon, 27 Apr 2026 18:33:56 -0700

Update DAMON ABI document for the DAMOS action failed regions quota charge
ratio control sysfs files.

Link: https://lore.kernel.org/20260428013402.115171-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-fail_charge_numdenom
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
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

