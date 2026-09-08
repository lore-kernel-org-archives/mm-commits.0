Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0655A5156
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 22:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788907751; cv=none; b=G4LR/qnER0OL23WM47gIuanlxGKAOvjj1ovSNewhJcuY3Co1FQkMOGni8GnE7CcKtqNZElNoeeUl70U/AC8Hfy9vPXA9W1iM4HdxxPHDmNdfmazTOxi+mBhKDqf4B7CKB8oJpUk6hHvAfZ2TXh2a+HKtMJYjtdlhhA0P94gVEA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788907751; c=relaxed/simple;
	bh=+E+9F5lk+rRzqt1waWbut0vHZzMajlo0XS2Q6hek00o=;
	h=Date:To:From:Subject:Message-Id; b=KmtmOUccXZKkY2S4ujpVJw6MaMnnUKw/C2d6kXsr8xZCjqPgGimQeWCiXpjW208tkV6R14TQGKzpORK+UL/fwJX7v0oe5c6wu1SpO/ve2GhHgTvK80iwz4UokSpumcyZJ3A9ST48XzlgBNBQ8lym09ZMx3KqX3S4zpQ04RaxTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QNCfOY6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QNCfOY6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5881F00A3D;
	Tue,  8 Sep 2026 22:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788907748;
	bh=78USJ+To7hVI4M5XWhE7Uz/SORmGJgEwQ6Nd67nA7Qw=;
	h=Date:To:From:Subject;
	b=QNCfOY6N5Gil5IOxB4KqBwu+GnBhfIrgEhVjkxGY1rlWGGFqtCYrus8R0nzlj5lqt
	 eA0ZpuYtmPCxrWc91iBUNOQkpz4T6FajdyCU0shMa2pDZLG8jjJPP7PEdNezjPqY7E
	 2Z9jrxVTk8AADuD2j/rqfbtawOsS8U1Kaoz6IY+M=
Date: Tue, 08 Sep 2026 15:49:08 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-khugepaged-race-harness-fix.patch added to mm-new branch
Message-Id: <20260908224908.AD5881F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-khugepaged-race-harness-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-khugepaged-race-harness-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-khugepaged-race-harness-fix.patch

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
From: Kiryl Shutsemau (Meta) <kas@kernel.org>
Subject: selftests-mm-add-khugepaged-race-harness-fix
Date: Tue, 8 Sep 2026 22:34:08 +0100

Sashiko pointed out that mremap() freed scratch area and it has to be
re-reserved for next cycle.

Link: https://lore.kernel.org/aqB-ycE8MlVwZJ7I@thinkstation
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged_race.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged_race.c~selftests-mm-add-khugepaged-race-harness-fix
+++ a/tools/testing/selftests/mm/khugepaged_race.c
@@ -194,6 +194,11 @@ static void *mremapper_fn(void *arg)
 			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
 		if (p == MAP_FAILED)
 			ksft_exit_fail_perror("mremap() back");
+		/* The move back unmapped the scratch address: claim it again */
+		if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
+			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
+			-1, 0) != (void *)mremap_scratch)
+			ksft_exit_fail_perror("mmap() mremap scratch");
 		usleep(rand_r(&seed) % 2000);
 	}
 	return NULL;
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-cover-a-shared-source-collapse-write-race-fix.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-add-khugepaged-race-harness-fix.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch

