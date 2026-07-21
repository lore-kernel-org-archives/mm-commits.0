Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BCC3161BF
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653543; cv=none; b=F/S6IS28aqtKzwYIxg5Kig5H4lA+NCvjnloLR2UK3cFgwgbjFc/moTb7P8gRVS4jF4g1RqgrdVYfqASJOZQVNkV978j3aQJAdvwr/OanJp2bfevRQY4NWTE/UhISm6n9DYqi6nJg6K9WpUdpSfjripAIEbvwnvehSXITN3TktCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653543; c=relaxed/simple;
	bh=cXaZBnnaIiQXMQdw5n8qZv12FjAkO4n1sv8khgN/rRg=;
	h=Date:To:From:Subject:Message-Id; b=QnfwPwY3OGqdj5WdXQdu2NFqT3hvX0vKP9py05CY3bwKrR2Y89Qev+M8dUFY7wmMycAqmjBSLAcyw4xyF7VA/yLqlqTeY8Hq8udyEqeUyF3ikshik+Eh/lcQXyh1Ss/7wnhKCrGB6ssQOtGMm2aopxSUJhwQg+cl1tdlsukaDGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y//QeRL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y//QeRL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C31F00A3A;
	Tue, 21 Jul 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784653541;
	bh=IIdPO1+n153Nmi7NtQqhpyC4KLf8QO/SsGrGUmGxct4=;
	h=Date:To:From:Subject;
	b=Y//QeRL5AQmxAXVrJoY5drxdEWTidXO3uRh0n7iXuVRa5JWLD0M3wdl3eO1tL/G4+
	 hIFVw8jA0wZFgu5TyBbyLS3JrsPVQ+8yVOlcX4UF/CgPyu3CjPtQ1UQuz4COCrR6Lw
	 aAPlyGnaHA7PFPUbVHJX6opuivmpBgfSvdae+wmk=
Date: Tue, 21 Jul 2026 10:05:41 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@kernel.org,yanlonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc.patch added to mm-new branch
Message-Id: <20260721170541.A55C31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/pagemap_ioctl: fix missing NULL checks after calloc()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc.patch

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
Subject: selftests/mm/pagemap_ioctl: fix missing NULL checks after calloc()
Date: Tue, 21 Jul 2026 14:36:11 +0800

The pagemap_ioctl selftest allocates memory via calloc() in several places
but does not check the return values.  If calloc() fails, the subsequent
code will dereference a NULL pointer and crash.

Additionally, in sanity_tests(), the calloc() failure check incorrectly
uses MAP_FAILED (the mmap() error constant) instead of NULL.  Since
calloc() returns NULL on failure, the check never triggers and a failed
allocation goes undetected.

Add NULL checks after each calloc() call, and fix the wrong error constant
in sanity_tests().  Use ksft_exit_fail_msg() consistent with the existing
error handling pattern in the file.

Link: https://lore.kernel.org/20260721063611.342-1-yanlonglong@kylinos.cn
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -213,6 +213,8 @@ int userfaultfd_tests(void)
 
 	vec_size = mem_size/page_size;
 	vec = calloc(vec_size, sizeof(struct page_region));
+	if (!vec)
+		ksft_exit_fail_msg("error nomem\n");
 
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 				vec_size - 2, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
@@ -700,6 +702,8 @@ int base_tests(char *prefix, char *mem,
 	vec_size = mem_size/page_size;
 	vec = calloc(vec_size, sizeof(struct page_region));
 	vec2 = calloc(vec_size, sizeof(struct page_region));
+	if (!vec || !vec2)
+		ksft_exit_fail_msg("error nomem\n");
 
 	/* 1. all new pages must be not be written (dirty) */
 	written = pagemap_ioctl(mem, mem_size, vec, 1, PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -1001,6 +1005,8 @@ int unmapped_region_tests(void)
 	int written, len = 0x00040000;
 	long vec_size = len / page_size;
 	struct page_region *vec = calloc(vec_size, sizeof(struct page_region));
+	if (!vec)
+		ksft_exit_fail_msg("error nomem\n");
 
 	/* 1. Get written pages */
 	written = pagemap_ioctl(start, len, vec, vec_size, 0, 0,
@@ -1163,7 +1169,7 @@ int sanity_tests(void)
 
 	vec = calloc(vec_size, sizeof(struct page_region));
 	mem = mmap(NULL, mem_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
-	if (mem == MAP_FAILED || vec == MAP_FAILED)
+	if (mem == MAP_FAILED || !vec)
 		ksft_exit_fail_msg("error nomem\n");
 
 	wp_init(mem, mem_size);
_

Patches currently in -mm which might be from yanlonglong@kylinos.cn are

selftests-mm-use-map_failed-for-mmap-error-check.patch
selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc.patch

