Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA42327A7
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585749; cv=none; b=kCjS79yBs5DHAxVYEEd3Zyer/vd7v1PvpMMwQGnLEXOXUCvEJackYkg8mpWXcLIxyKo9If2u94p6evHDNdMU4GK5YpSYYAks5sOLj69QPaxBDWaMmmPS3EKKhMKc6WOk0cX07zF2kbBMrrOw4mqHTrQKgXppf+WAP6PbyxQfnyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585749; c=relaxed/simple;
	bh=lr0eplV50hjSZdx1ncJgHNNYgcrXfomSnQHs16WKflQ=;
	h=Date:To:From:Subject:Message-Id; b=YTqEjMIv0IrDE2XWkylJ5zD6Rc+izaV1gGqBcHHjZZFEQOsS69yFTE4+hyFB0armKBxUIKB4GOXA4p6dSQQh5u53jWO6mVp/LQJkems1uddtc2JGAqLTuEwCmLs7SJ+nqYwve2bPFi4JwYIgEpfUWX1r7g1vIk8jxYdiMhkaK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w3LTmfBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w3LTmfBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA873C4CEED;
	Tue, 10 Jun 2025 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749585748;
	bh=lr0eplV50hjSZdx1ncJgHNNYgcrXfomSnQHs16WKflQ=;
	h=Date:To:From:Subject:From;
	b=w3LTmfBvUX0UitwGBYRaemjdi+pgfQjVdZGUgbr1+cfYDyUC7uqkCqM0ZLHDlo6ID
	 rTOwVfrY6zMqzwfvuPcmCGbhNK8oZ5Z+cmRGt5aH+wIxH4FPIoFVYq8U8xQLR128Hn
	 E8jxnCF/Zz0h0yvrecqcUIP1wpTMCcDV4m/oMi+g=
Date: Tue, 10 Jun 2025 13:02:28 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch added to mm-new branch
Message-Id: <20250610200228.CA873C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check for YAMA ptrace_scope configuraiton before modifying it
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch

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
Subject: selftests/mm: check for YAMA ptrace_scope configuraiton before modifying it
Date: Tue, 10 Jun 2025 15:07:44 +0100

When running the memfd_secret test run_vmtests.sh unconditionally tries
to confgiure the YAMA LSM's ptrace_scope configuration, leading to an error
if YAMA is not in the running kernel:

# ./run_vmtests.sh: line 432: /proc/sys/kernel/yama/ptrace_scope: No such file or directory
# # ----------------------
# # running ./memfd_secret
# # ----------------------

Check that this file is present before trying to write to it.

The indentation here is a bit odd, and it doesn't seem great that we
configure but don't restore ptrace_scope.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-enable-yama-v1-1-0097b6713116@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -429,7 +429,9 @@ CATEGORY="vma_merge" run_test ./merge
 
 if [ -x ./memfd_secret ]
 then
-(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
+	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+fi
 CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch
kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch
selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch

