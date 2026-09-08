Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF7C4E80C4
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 22:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788907750; cv=none; b=dC09VTbNpIjXo+L0ILmiVuY0sII1SM04DFlL8kN0+WJMl6g/9VyXmaUUq5YQBQIGmP7yhqjr0dNSugxOWe89yQJVbWhlHokPtR78+vNKc4qe6749nGeq8GS6UM3qH9Tv2RrgwJekVPrHspIw/t09pFEByVKv9e7b1NEwuxT3XWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788907750; c=relaxed/simple;
	bh=g1EVNKdrYG7pv2nPaYzdy/dxyJLUoDc54LAF10r6/A4=;
	h=Date:To:From:Subject:Message-Id; b=V1aI08XobgRXQx0SGz7Qu6Aq6mSy0t49ZaA6UmSBjZspu6QvBrVBaRjsbJkjxD+tT1UJovwRqSMcu+xVnjv0yiF86CgGerY03gzQorwXUTdCMGK04oqqVsrQhdDb+f6XS3ibsImiyRkBFagdv3JnRkYFpUwVz75NVQ6V4g4xaNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xttd0tG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xttd0tG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD87F1F00A3A;
	Tue,  8 Sep 2026 22:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788907745;
	bh=Te2IywBEIr+tGVWig4bpVAclGqIpCtdDz6RTLn6Qn6w=;
	h=Date:To:From:Subject;
	b=xttd0tG9SZ3xLmWAHzUf026o0blR/jooyCK0PhWbNaVGs8a8rLMCgsjq+L53SX3L7
	 +kmWw7j4ozIwbsmllHsaLuoU/TM4Dame705XKOkBYMf0ZKSoRONTNa0ObRg7J3U/hj
	 BskyYVr9kAIqrBt2GGft/ECWBf8lMjwgZ69eL18o=
Date: Tue, 08 Sep 2026 15:49:05 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cover-a-shared-source-collapse-write-race-fix.patch added to mm-new branch
Message-Id: <20260908224905.CD87F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-cover-a-shared-source-collapse-write-race-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-cover-a-shared-source-collapse-write-race-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cover-a-shared-source-collapse-write-race-fix.patch

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
Subject: selftests-mm-cover-a-shared-source-collapse-write-race-fix
Date: Tue, 8 Sep 2026 22:02:13 +0100

Sashiko flagged two issues here:

 - sync[0] never closed. It is fd leak;

 - wstatus is garbage if waitpid() fails, returning -1;

Link: https://lore.kernel.org/aqB2ckEupUKnoJt_@thinkstation
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-cover-a-shared-source-collapse-write-race-fix
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1230,6 +1230,7 @@ static void collapse_fork_cow_race(struc
 	close(sync[1]);
 	if (read(sync[0], &go, 1) != 1)
 		ksft_exit_fail_msg("child never reached the collapse\n");
+	close(sync[0]);
 
 	/*
 	 * Unshare one page at a time: a burst would break CoW on the whole
@@ -1237,12 +1238,17 @@ static void collapse_fork_cow_race(struc
 	 */
 	i = 0;
 	for (;;) {
+		pid_t ret;
+
 		if (i < n)
 			ip[i * stride] = i + 0xbeef0000;
 		i++;
 		usleep(10 * 1000);
-		if (waitpid(child, &wstatus, WNOHANG))
+		ret = waitpid(child, &wstatus, WNOHANG);
+		if (ret == child)
 			break;
+		if (ret < 0)
+			ksft_exit_fail_perror("waitpid()");
 	}
 
 	/* Finish whatever the paced sweep did not reach */
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

