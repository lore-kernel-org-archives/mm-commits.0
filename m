Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD163B8127
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068140; cv=none; b=ZNkdes8G9GOk6MSvFoy7hLBBK1AArNIcuwP0F2SV916AMFkqd/qtTzFhjQ6GPcupqjatuCTR5oPvix6JNDeZRjs7uZub9MCBVG8p6K793VxdY+XfSc6Z+wuR5P9rGL6a3UNgulEZX4YkTpDvtj4JRhkRC8EOT6Ldu5xT/kaiD2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068140; c=relaxed/simple;
	bh=ZDXOWAv3mQg+BaSzns+igY9/xNaoKfRAwuICl1cP9LM=;
	h=Date:To:From:Subject:Message-Id; b=EGGcrUzBQ7pk94TWcJnScVkTw9oudz0ex24bPlaG0uakN3NHmK6ORQ77z5NE1EeYkSBGg3Os2B+bUncCQK6TcrW1ppbMiqHHRrjhxvxZ8XokwX3NTO1fb4Yy9eFZTEfitHxMxwwxYtQpXvQUAEtvbsxjK8Shl5/qAbGO3gkEGp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHxAPERd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHxAPERd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E171F000E9;
	Fri,  7 Aug 2026 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068139;
	bh=2tuZdYJhNjmGPnWugonTuMKUfg32thYNAkPfm7GV0hE=;
	h=Date:To:From:Subject;
	b=NHxAPERdO3Tegrslf8464TfT1lEmGcZDGwB9zwI7KXy6+SZWAtXstp2OhZyidLhot
	 o0GpAfD7o21SI6Xsz/uxluq67Nv61m6wiFNZm3jDwxSpiij/BGpk9NPawi3v/4/N7S
	 TjklYatayylpsTVSI9x0He+gjsRKL+r3HDL0jOVU=
Date: Thu, 06 Aug 2026 19:02:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,david@kernel.org,yanlonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc.patch removed from -mm tree
Message-Id: <20260807020219.80E171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/pagemap_ioctl: fix missing NULL checks after calloc()
has been removed from the -mm tree.  Its filename was
     selftests-mm-pagemap_ioctl-fix-missing-null-checks-after-calloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: SJ Park <sj@kernel.org>
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


