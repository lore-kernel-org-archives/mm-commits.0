Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C943CEC1
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 21:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783460549; cv=none; b=KMLH5feDW37czFsUOxUe6/zdPicazx8k9ZzY/00l/Hm8iQerHjaVSoKYCaTcInMvCQzkyakbitqqbMPJiPfCHrszMf5lkw2PNzvMbAwnMMyyRIzy2w4cxnRUGWspbzLyfHBCn3aAMIp3hfAYIPWKlQguENQ5tGtAETWA77EOYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783460549; c=relaxed/simple;
	bh=bZede8xmPLyvOSum0MMzHeRXCNPvui+T84QCUT25AvE=;
	h=Date:To:From:Subject:Message-Id; b=nSpEcFwKI3pgLCK5lLNzTa6YssEPyS6j7NEU23YqDvBeB5uVgCOPuyILSx53/QU7N99QrBqHpk8WhkfwZhMG4oPwjyFWVi7CrMJgMNPCfFPgFQoOgP+EO7+a0q6u1lXntORl+6VxIY1gp9oWoeeUau76JsNrJiTpgtslj3ING2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIrkysBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIrkysBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15B71F00A3A;
	Tue,  7 Jul 2026 21:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783460547;
	bh=b+OWTDWIMSPFkwOGt8VVUcZaD+QP3LZj9X0FJU0gpfg=;
	h=Date:To:From:Subject;
	b=jIrkysBuUT8LmSQRQSANTHxS29AD8hcWnZNeVffCu+W83j0WWvQNk6rq7UR92A42x
	 ui3piOmAKFv4UfeTqDQ4M/cNiE2TvC9f3GQrcqG2QDR3j02yLcFntXyz8IDsiunv/g
	 oAgmNl8z4LhrasDHdpfaI0o9WO58I/urJWY6AjGY=
Date: Tue, 07 Jul 2026 14:42:27 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,yanlonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal_test-fix-mmap-return-value-check-in-test_seal_zero_address.patch added to mm-new branch
Message-Id: <20260707214227.B15B71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/mseal_test: Fix mmap return value check in test_seal_zero_address
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-mseal_test-fix-mmap-return-value-check-in-test_seal_zero_address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mseal_test-fix-mmap-return-value-check-in-test_seal_zero_address.patch

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
From: longlong yan <yanlonglong@kylinos.cn>
Subject: selftests/mm/mseal_test: Fix mmap return value check in test_seal_zero_address
Date: Tue, 7 Jul 2026 11:17:45 +0800

The return value for a failed mmap function is MAP_FAILED.  According to
the definition of FAIL_TEST_IF FALSE,ptr must be determined to be distinct
from MAP_FAILED

Link: https://lore.kernel.org/20260707031745.1039-1-yanlonglong@kylinos.cn
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-mseal_test-fix-mmap-return-value-check-in-test_seal_zero_address
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -482,7 +482,7 @@ static void test_seal_zero_address(void)
 	/* use mmap to change protection. */
 	ptr = mmap(0, size, PROT_NONE,
 		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
-	FAIL_TEST_IF_FALSE(ptr == 0);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	size = get_vma_size(ptr, &prot);
 	FAIL_TEST_IF_FALSE(size == 4 * page_size);
_

Patches currently in -mm which might be from yanlonglong@kylinos.cn are

selftests-mm-mseal_test-fix-mmap-return-value-check-in-test_seal_zero_address.patch

