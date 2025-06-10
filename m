Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC892327A7
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585696; cv=none; b=VtJjeFIdMh3ltooWRDvz0P6HnQCbw2SZnJ5GcADXk2+NWgQadTCwsfrYxAP/QcJsnBIKvHIICCahR/0FpibVLUYFUqn8876T5sjxt5dqrAFHKWHqt/OUq7ADaL80UgdQQX+CEtTcdOFrZB4uR2WxgJ1DEaIlL1rBKnWvYhsQd5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585696; c=relaxed/simple;
	bh=2yM1BGkiilXFggmt7CGA+k/qqE5LqVTK80rNCk9BNAM=;
	h=Date:To:From:Subject:Message-Id; b=FiOkyvBk4XnoEHapkKnGT/vsR27LiZIY3GKKOBgcZsHVG8xFkHVuAmdgHPsFqByy5Srb5SZfp4oInmFQ4v8XDuQRjitjVCgSgyrcGPYxvcqOskllje4qtP8pIDcqwck3t8DwkMItBhBvIEKsDRKrJBPOurss8QlSXc1az3i44tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GrrXYE9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GrrXYE9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A400EC4CEED;
	Tue, 10 Jun 2025 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749585695;
	bh=2yM1BGkiilXFggmt7CGA+k/qqE5LqVTK80rNCk9BNAM=;
	h=Date:To:From:Subject:From;
	b=GrrXYE9OYcJnyjCxbzav1dMWYN/0zj1LbXpNewOEdWCbZsp98by+9JkAagj1NqLBE
	 FWOB40OS6PJ6XgdJb4IKFSnToDiWmcQZrB55cJ487Kvqxw2k65yi/6rfNKkUpcAUaP
	 FjuLXuadSOoCV71x+mbrdlKGkXsFZq59nYYJQbm0=
Date: Tue, 10 Jun 2025 13:01:34 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-clarify-errors-for-pipe.patch added to mm-new branch
Message-Id: <20250610200135.A400EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest/mm: clarify errors for pipe()
has been added to the -mm mm-new branch.  Its filename is
     kselftest-mm-clarify-errors-for-pipe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-clarify-errors-for-pipe.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: kselftest/mm: clarify errors for pipe()
Date: Tue, 10 Jun 2025 15:13:54 +0100

Patch series "selftests/mm: Tweaks to the cow test".

A collection of non-functional updates from David Hildenbrand's review.


This patch (of 4):

Specify that errors reported from pipe() failures are the result of
failures.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-0-43cd7457500f@kernel.org
Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-1-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~kselftest-mm-clarify-errors-for-pipe
+++ a/tools/testing/selftests/mm/cow.c
@@ -113,11 +113,11 @@ struct comm_pipes {
 static int setup_comm_pipes(struct comm_pipes *comm_pipes)
 {
 	if (pipe(comm_pipes->child_ready) < 0) {
-		ksft_perror("pipe()");
+		ksft_perror("pipe() failed");
 		return -errno;
 	}
 	if (pipe(comm_pipes->parent_ready) < 0) {
-		ksft_perror("pipe()");
+		ksft_perror("pipe() failed");
 		close(comm_pipes->child_ready[0]);
 		close(comm_pipes->child_ready[1]);
 		return -errno;
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch
kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

