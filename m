Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F55A8F5B
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747494484; cv=none; b=rotVOgzcyLGR7b2Px0GQYSmfiMlzhgwrAtdSNDZHHK2qanRp8FtlwObaFhE2WbNNK3GupQZlBzLfMNFdw/HhfBHRcHnWixnzG+HWI75ymWax/mkdkJSMTpvphnWI7vdWtmdMptypJTs/VEZyed4bSWkBtFRK09QDeDr+9sC7c3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747494484; c=relaxed/simple;
	bh=R/9i7qZuc+OllyzSOn7mKlarT59a13eseGJuvyQWgGQ=;
	h=Date:To:From:Subject:Message-Id; b=p0o1eUK42GFRj4nZsqDvrgh2Y93doaoOPSeNTKyR66q4hoenZp1xwVh3Woxg8ivpzn+cElQ6q1m1tVn98QUzEEVWti6b8rT0Kv83fZyFiQ8SoZYTaYw8bmcL6Zn6gzeBT3RJgx1ikoKlV0yc7Vkmq29pJkpq0p4aJYD+80Hh7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nqs9L50m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nqs9L50m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2680C4CEE3;
	Sat, 17 May 2025 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747494484;
	bh=R/9i7qZuc+OllyzSOn7mKlarT59a13eseGJuvyQWgGQ=;
	h=Date:To:From:Subject:From;
	b=nqs9L50mPDTbSkQohkOLd2YMF7O7iUsST/0Tu9Gh1Av63ocyd8VV8hICT3v7d76UZ
	 CGlM07hUKShgGCcL3mMiT409upXIvV4qbRJHqxCRmOOUrW7HH3HuNS0tJQYZZmZEGu
	 r2X+43F+eooj21L+yfKZwv9A2dNJuarJoaiYLm80=
Date: Sat, 17 May 2025 08:08:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch added to mm-new branch
Message-Id: <20250517150803.D2680C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: deduplicate default page size test results in thuge-gen
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch

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
Subject: selftests/mm: deduplicate default page size test results in thuge-gen
Date: Thu, 15 May 2025 11:36:14 +0200

The thuge-gen test program runs mmap() and shmget() tests for both every
available page size and the default page size, resulting in two tests for
the default size.  These tests are distinct since the flags in the default
case do not specify an explicit size, add the flags to the test name that
is logged to deduplicate.

Link: https://lkml.kernel.org/r/20250515-selfests-mm-thuge-gen-dup-v1-1-057d2836553f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -127,7 +127,7 @@ void test_mmap(unsigned long size, unsig
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s mmap %lu\n", __func__, size);
+			 "%s mmap %lu %x\n", __func__, size, flags);
 
 	if (munmap(map, size * NUM_PAGES))
 		ksft_exit_fail_msg("%s: unmap %s\n", __func__, strerror(errno));
@@ -165,7 +165,7 @@ void test_shmget(unsigned long size, uns
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s: mmap %lu\n", __func__, size);
+			 "%s: mmap %lu %x\n", __func__, size, flags);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
 }
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch

