Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882ED20DD47
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738720892; cv=none; b=K0wz5Q8O6qcS74dyA9g0+kbXFlngGlPD3lYM1LMKKc3qpwC6g1NRKteKANln76h5Zf99Dc0hGEGOxpkOn1jwClMjjivkcWytYNqzKoDkB86E5FUFH0iWvxuiDae/b1thF/69Ooh8nJrkjzZ1kHXi0qIdtSZBt5ZGPmxG0Frjurk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738720892; c=relaxed/simple;
	bh=nhs5lNu0jrmNw2veFJEFKU4CqG1zmupWY+AjBLCGQ/4=;
	h=Date:To:From:Subject:Message-Id; b=o22k5R+reimSoBfnNag8LA6IECLBaR1wnvbsSthXyKiFzu6yBGMI/u55ANad693NZw4fV9Uw0qP2hvO79MrF7AEIFVnJiSm0nZCbZdlvwS3tIwKWx0h8+mflU27Myl0rtyMwZOtlXkRuRzIGfRDybgU/HxUUqHQN72ZAno5SIOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EC+a4h2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EC+a4h2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED81EC4CEDF;
	Wed,  5 Feb 2025 02:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738720892;
	bh=nhs5lNu0jrmNw2veFJEFKU4CqG1zmupWY+AjBLCGQ/4=;
	h=Date:To:From:Subject:From;
	b=EC+a4h2k2as9/ykXdTpEGNkpxWk0wd2kIqEDZ1C4D7uLhrTDxhuadhKeVqLe9w1+i
	 5GxB7SzuIJpfyCWWm1RUFgHhs7YnUyMpnGW5g/N7/1Vcz7xxT5G/51Mg2McXH4azRd
	 9vuWmti1cX9dc/Y0r6Q3ILvbL+Qs3FF/cCuBYWgQ=
Date: Tue, 04 Feb 2025 18:01:31 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-thuge-gen-test-name-uniqueness.patch added to mm-unstable branch
Message-Id: <20250205020131.ED81EC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: Fix thuge-gen test name uniqueness
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-thuge-gen-test-name-uniqueness.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-thuge-gen-test-name-uniqueness.patch

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: Fix thuge-gen test name uniqueness
Date: Tue, 04 Feb 2025 22:53:43 +0000

The thuge-gen test_mmap() and test_shmget() tests are repeatedly run for a
variety of sizes but always report the result of their test with the same
name, meaning that automated sysetms running the tests are unable to
distinguish between the various tests.  Add the supplied sizes to the
logged test names to distinguish between runs.

Link: https://lkml.kernel.org/r/20250204-kselftest-mm-fix-dups-v1-1-6afe417ef4bb@kernel.org
Fixes: b38bd9b2c448 ("selftests/mm: thuge-gen: conform to TAP format output")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-fix-thuge-gen-test-name-uniqueness
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -127,7 +127,7 @@ void test_mmap(unsigned long size, unsig
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s mmap\n", __func__);
+			 "%s mmap %lu\n", __func__, size);
 
 	if (munmap(map, size * NUM_PAGES))
 		ksft_exit_fail_msg("%s: unmap %s\n", __func__, strerror(errno));
@@ -165,7 +165,7 @@ void test_shmget(unsigned long size, uns
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s: mmap\n", __func__);
+			 "%s: mmap %lu\n", __func__, size);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
 }
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-fix-thuge-gen-test-name-uniqueness.patch

