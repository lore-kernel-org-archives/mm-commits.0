Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E872327A7
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585700; cv=none; b=pXXjfBJWqaki4qReANaheSTjd+2qMWPvyGKb1mj8uglqb/VW1ZMV1J4OsQy6+AtKBKVjWl8MihL1e9Xg+7+oqcdXTq+9DBzh3rJzQE0yzuWlBnN3LWrPDo/X3fBmHOZ6WheY9hcvqQ9p1Buo40kDEOSGCcTUJDMbBAFTF/J+aO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585700; c=relaxed/simple;
	bh=zwFf5ynU6zeXDS7do17oJREKoj+Of6snNfmVaRi/Gy4=;
	h=Date:To:From:Subject:Message-Id; b=tJ36LYrSgMfdWDApxhDhM9uDKqGDtlSpvfH7ZbcPgviAMYbR70UwxbzZWa8Hk0jqGAh+l+s7hpzyQ83LINUQNCByXIDmY+JIgV08EKBjxrqYzgYp9pxwlqQKN5Pkt8ldQSqj9PadPpBiuO6rAiZ1mQkC1s0gPapSCU0MD8/VJwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEupmDAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEupmDAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB63BC4CEF2;
	Tue, 10 Jun 2025 20:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749585699;
	bh=zwFf5ynU6zeXDS7do17oJREKoj+Of6snNfmVaRi/Gy4=;
	h=Date:To:From:Subject:From;
	b=xEupmDAU0LzeNaqpMYHT0ULS0ICDXvYReUfjhTt6uRmr3Mb8krplEx42KkFYh5lLH
	 CoTjwwRd9FguR1OCflIqgGoVfuwTcPcKpSoOObCss24mgycpUXgjcV/GiJd/Aa9NCe
	 HpzMmEu344E9iGsdTRBQLX1SPjayMi6vvYVgsmjU=
Date: Tue, 10 Jun 2025 13:01:39 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-compare-return-values-to-in-cow.patch added to mm-new branch
Message-Id: <20250610200139.AB63BC4CEF2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: don't compare return values to in cow
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-dont-compare-return-values-to-in-cow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-compare-return-values-to-in-cow.patch

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
Subject: selftests/mm: don't compare return values to in cow
Date: Tue, 10 Jun 2025 15:13:56 +0100

Tweak the coding style for checking for non-zero return values.
While we're at it also remove a now redundant oring of the madvise()
return code.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-cow-tweaks-v1-3-43cd7457500f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-dont-compare-return-values-to-in-cow
+++ a/tools/testing/selftests/mm/cow.c
@@ -1613,13 +1613,13 @@ static void run_with_huge_zeropage(non_a
 	smem = (char *)(((uintptr_t)mmap_smem + pmdsize) & ~(pmdsize - 1));
 
 	ret = madvise(mem, pmdsize, MADV_HUGEPAGE);
-	if (ret != 0) {
+	if (ret) {
 		ksft_perror("madvise()");
 		log_test_result(KSFT_FAIL);
 		goto munmap;
 	}
-	ret |= madvise(smem, pmdsize, MADV_HUGEPAGE);
-	if (ret != 0) {
+	ret = madvise(smem, pmdsize, MADV_HUGEPAGE);
+	if (ret) {
 		ksft_perror("madvise()");
 		log_test_result(KSFT_FAIL);
 		goto munmap;
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch
kselftest-mm-clarify-errors-for-pipe.patch
selftests-mm-convert-some-cow-error-reports-to-ksft_perror.patch
selftests-mm-dont-compare-return-values-to-in-cow.patch
selftests-mm-add-messages-about-test-errors-to-the-cow-tests.patch

