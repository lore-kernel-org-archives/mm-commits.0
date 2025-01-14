Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0BF35953
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 04:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736827565; cv=none; b=LW+ip2jsuMlBSm9dbrMEeMQXpRkrl0Dnv7tSeCiHfODbSqJB5aniFBkaPNizBb53NwMsnL4Nsn3zQ6fj6NciSkF9QxjSx/dk//+NjR8TcUoBm0J5qEzYl8B8gqehvmAW+2h9REZK8VkZESXOxQHn89/Iq3QXmv+3d24fIYccPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736827565; c=relaxed/simple;
	bh=e/v2aelwYcvVXDMunTHa/68IcotfmtlOnNtJz2Tzwgo=;
	h=Date:To:From:Subject:Message-Id; b=S2s32lWi4hFuXYtkkxXk5qufEfrA2z+HePUlCC2WqaJjwIl0NmmdtMnkhum14q9KB+aXGD4FOVz7WH5nr2OMdMFLsXrZYnL9oySrxVSbJI9O+hZfFdOXSGeGu0uEbaYrCIekLal4pKx4D/t3DBttRic/+8OahcG0YmKEsQTEvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jFTznCE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jFTznCE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37937C4CEDF;
	Tue, 14 Jan 2025 04:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736827565;
	bh=e/v2aelwYcvVXDMunTHa/68IcotfmtlOnNtJz2Tzwgo=;
	h=Date:To:From:Subject:From;
	b=jFTznCE/SflMNWz+P+04cqC5NsfWgtAejfpTg7dA6eMZxqLhi6mEwZU29ZRYic90y
	 EIcvRrwEWYwQC6qFzYIQl4+N2YIh02oetPuINi+irQCRJGS4ATIiI0ZsgE2RgF/CMn
	 lS18lHoAiyXv38+E6phaBthpBKN6HzAeVLkERPY4=
Date: Mon, 13 Jan 2025 20:06:04 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-modify-the-incorrect-checking-parameters-v2.patch added to mm-unstable branch
Message-Id: <20250114040605.37937C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-cow-modify-the-incorrect-checking-parameters-v2
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-modify-the-incorrect-checking-parameters-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-modify-the-incorrect-checking-parameters-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hao Ge <gehao@kylinos.cn>
Subject: selftests-mm-cow-modify-the-incorrect-checking-parameters-v2
Date: Mon, 13 Jan 2025 13:09:08 +0800

fix other errant sites, per Anshuman

Link: https://lkml.kernel.org/r/20250113050908.93638-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-modify-the-incorrect-checking-parameters-v2
+++ a/tools/testing/selftests/mm/cow.c
@@ -1490,7 +1490,7 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1591,7 +1591,7 @@ static void run_with_memfd(non_anon_test
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
@@ -1642,7 +1642,7 @@ static void run_with_tmpfile(non_anon_te
 		goto close;
 	}
 	smem = mmap(NULL, pagesize, PROT_READ, MAP_SHARED, fd, 0);
-	if (mem == MAP_FAILED) {
+	if (smem == MAP_FAILED) {
 		ksft_test_result_fail("mmap() failed\n");
 		goto munmap;
 	}
_

Patches currently in -mm which might be from gehao@kylinos.cn are

selftests-mm-cow-modify-the-incorrect-checking-parameters.patch
selftests-mm-cow-modify-the-incorrect-checking-parameters-v2.patch

