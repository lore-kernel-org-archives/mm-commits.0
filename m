Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7101E9B38
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 03:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663275; cv=none; b=kGNpp/xZChsvGbNEPJbtxgNscD9CYTJDk9z8tALMtngVXRO1ac7VUCOhYLUc2+Q1F0INoJP3EDqPDqzQpclXdvqjiBL1ROR57sZcDd2bwqDUviKJEZC0Z4TyDT4hvyW+QCvEAqqCmoRF9NvSPKu8yl6+Sjd1HZXx9lo34mo2Uq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663275; c=relaxed/simple;
	bh=ULoCqHWk99h2Yu068nOVaiI8NYmw8e3GarXm7D1PTsM=;
	h=Date:To:From:Subject:Message-Id; b=NBJGc7NjmxGBpGP26dRQw6Wj1j78MxAaxI151EAU1TAMNPfuKtLBlzAJDaMnb3FWT1ZQlhCI+RmMhDPGLQhKyfNp85ksRfgCW08atQus47nGxfRRj6NXfXOPbrcs8yQk5xe5AacUxhlQ8nBlRR8CRtKmT3i0IDTwvqwmIyvW8Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OBOs+b2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OBOs+b2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25044C4CEE9;
	Tue, 11 Mar 2025 03:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741663275;
	bh=ULoCqHWk99h2Yu068nOVaiI8NYmw8e3GarXm7D1PTsM=;
	h=Date:To:From:Subject:From;
	b=OBOs+b2JKYDQdEsfN8oNikcWYhIj/u9u24SArdjgR5/iTnkHqvP7tSkYkzAIvohLB
	 sxXvPWzYO3N3tmFX9ArwBmX9p9WT5Fr+uKwOFRBS29NIH6U84IIE5wAvCmibcBzjTu
	 k44Em2Cj6X26T+BkYWDGWNZo/fw4M3G5aKWFpQOg=
Date: Mon, 10 Mar 2025 20:21:14 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,cyan.yang@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-fix-the-incorrect-error-handling.patch added to mm-unstable branch
Message-Id: <20250311032115.25044C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/cow: fix the incorrect error handling
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-fix-the-incorrect-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-fix-the-incorrect-error-handling.patch

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
From: Cyan Yang <cyan.yang@sifive.com>
Subject: selftests/mm/cow: fix the incorrect error handling
Date: Tue, 11 Mar 2025 10:37:30 +0800

There are two error handlings did not check the correct return value. 
This patch will fix them.

Link: https://lkml.kernel.org/r/20250311023730.56658-1-cyan.yang@sifive.com
Fixes: f4b5fd6946e244cdedc3bbb9a1f24c8133b2077a ("selftests/vm: anon_cow: THP tests")
Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-fix-the-incorrect-error-handling
+++ a/tools/testing/selftests/mm/cow.c
@@ -876,13 +876,13 @@ static void do_run_with_thp(test_fn fn,
 		mremap_size = thpsize / 2;
 		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
 				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-		if (mem == MAP_FAILED) {
+		if (mremap_mem == MAP_FAILED) {
 			ksft_test_result_fail("mmap() failed\n");
 			goto munmap;
 		}
 		tmp = mremap(mem + mremap_size, mremap_size, mremap_size,
 			     MREMAP_MAYMOVE | MREMAP_FIXED, mremap_mem);
-		if (tmp != mremap_mem) {
+		if (tmp == MAP_FAILED) {
 			ksft_test_result_fail("mremap() failed\n");
 			goto munmap;
 		}
_

Patches currently in -mm which might be from cyan.yang@sifive.com are

selftests-mm-cow-fix-the-incorrect-error-handling.patch

