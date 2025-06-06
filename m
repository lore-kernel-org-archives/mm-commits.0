Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2260F5223
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 01:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749171861; cv=none; b=oFkd9grvoi7Cdb3uZTJC3IqzsrzKC4NtwtwvsfkJAG8H2m6wgmRr3C/TBMdzjhN/Qr6FWLloFlemCEAXdZWzo68swf8llN/9WXtikLPtnTb1TbSTRO4OwByG1VT7FXYgLzyK0MstXUraWrFz+eU3bGwjZSy3a7KrzFshtwGE+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749171861; c=relaxed/simple;
	bh=Vr9YzVpt1nkT4tD6+8Ur/7H99HBnW220IrkvItVTiC0=;
	h=Date:To:From:Subject:Message-Id; b=ir7wHvdBbaHDYYIH+pxSI/0Zg1GdPIXZfhiMGFlrOAgYCF3lfPjb7BPGEBrOe0ZfoA7eMMpSxKzt5iuBTwRj83WGT6vLpVGfIWdNDphomhlD3RXFLWnmp8KaCE0118txkYI9B9oq8S9CC836YAb5vx9heS6XyxwxD4btSoxcn08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iRsHxBaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iRsHxBaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1E9C4CEE7;
	Fri,  6 Jun 2025 01:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749171860;
	bh=Vr9YzVpt1nkT4tD6+8Ur/7H99HBnW220IrkvItVTiC0=;
	h=Date:To:From:Subject:From;
	b=iRsHxBaW5sLY1Yz4j+6O0LOLTD/6HAKABc3D+q1q28/RWUmrC8NeonlqXjz4UzP2k
	 nIWv7FYeQTuvfw7UNN8M5C+PARIBBFtiEPRJheqokBXX8CPZoF1iNcQ+Ub/p5iKKN/
	 D9upwbvnuizIROxpTDVIK6TaCpLPuBQEOfync74M=
Date: Thu, 05 Jun 2025 18:04:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch added to mm-hotfixes-unstable branch
Message-Id: <20250606010420.7D1E9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip failed memfd setups in gup_longterm
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: selftests/mm: skip failed memfd setups in gup_longterm
Date: Thu, 05 Jun 2025 22:34:31 +0100

Unlike the other cases gup_longterm's memfd tests previously skipped the
test when failing to set up the file descriptor to test.  Restore this
behavior to avoid hitting failures when hugetlb isn't configured.

Link: https://lkml.kernel.org/r/20250605-selftest-mm-gup-longterm-tweaks-v1-1-2fae34b05958@kernel.org
Fies: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Closes: https://lkml.kernel.org/r/a76fc252-0fe3-4d4b-a9a1-4a2895c2680d@lucifer.local
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-skip-failed-memfd-setups-in-gup_longterm
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -298,8 +298,11 @@ static void run_with_memfd(test_fn fn, c
 	log_test_start("%s ... with memfd", desc);
 
 	fd = memfd_create("test", 0);
-	if (fd < 0)
+	if (fd < 0) {
 		ksft_print_msg("memfd_create() failed (%s)\n", strerror(errno));
+		log_test_result(KSFT_SKIP);
+		return;
+	}
 
 	fn(fd, pagesize);
 	close(fd);
@@ -366,6 +369,8 @@ static void run_with_memfd_hugetlb(test_
 	fd = memfd_create("test", flags);
 	if (fd < 0) {
 		ksft_print_msg("memfd_create() failed (%s)\n", strerror(errno));
+		log_test_result(KSFT_SKIP);
+		return;
 	}
 
 	fn(fd, hugetlbsize);
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-skip-failed-memfd-setups-in-gup_longterm.patch

