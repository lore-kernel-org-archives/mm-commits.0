Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA71B651A1
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 21:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389100; cv=none; b=eFAbYBgUdPv5vrtz/vJ8lEyYXJ0lhtkWsDBJsilboAMOvz60kisAxaazSaF1KVuyIbbIhAuNzX00qjVIzYfiLsyNCjlsG4oHjA6ca3RnnMaASdjTy08Oj+EhyHhnqnb8iTtdHY3K6FSNf8tz6/AXVlWIIh8wd3pw7oIQjxn7IgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389100; c=relaxed/simple;
	bh=1MNJEjW5myKyEfc5BrxxQVxdDVao8H3lOMN5ot+2Ufc=;
	h=Date:To:From:Subject:Message-Id; b=PQQaJ5DGkQclp5+wnfTNbj3A0y1pWtA0XHWJGFPcPk2JUwS73H+ev6bWczeSKPCxoXAIYOj0pMWnbhiUOXT/8Sj1esZwwlXgOapSs7keNeLWMeHciiw8gMfPUMCUD1eP+WeayQoWEl1ZBbALGykZl40EOkbnxBH2a+aAo7/RgPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KNjoUEKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KNjoUEKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32999C072AA;
	Wed, 17 Apr 2024 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713389100;
	bh=1MNJEjW5myKyEfc5BrxxQVxdDVao8H3lOMN5ot+2Ufc=;
	h=Date:To:From:Subject:From;
	b=KNjoUEKNTgeJLkTxOABJxwR/0LGDN16eb2StBPKUTL5uFVgwnB/PIwEPVy7h8z3Lp
	 dJOvayt5iYU57kwNt8Ro/iEu2XWgwZu0unNAuWBUVzNsovnPaxf+fJ0gRNJpNiy23u
	 u9QuiMwt0z7kEP5DCC7Xx/N6HXWeopgWV6iP/naw=
Date: Wed, 17 Apr 2024 14:24:59 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-mseal-read-only-elf-memory-segment-fix.patch added to mm-unstable branch
Message-Id: <20240417212500.32999C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest mm/mseal: style change
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-mseal-read-only-elf-memory-segment-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-mseal-read-only-elf-memory-segment-fix.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: selftest mm/mseal: style change
Date: Tue, 16 Apr 2024 22:09:44 +0000

remove "assert" from testcase.
remove "return 0"

Link: https://lkml.kernel.org/r/20240416220944.2481203-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Suggested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |  124 ++++++++++++++++------
 tools/testing/selftests/mm/seal_elf.c   |    3 
 2 files changed, 91 insertions(+), 36 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftest-mm-mseal-read-only-elf-memory-segment-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -12,9 +12,7 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <assert.h>
 #include <fcntl.h>
-#include <assert.h>
 #include <sys/ioctl.h>
 #include <sys/vfs.h>
 #include <sys/stat.h>
@@ -189,7 +187,6 @@ static void __write_pkey_reg(u64 pkey_re
 
 	asm volatile(".byte 0x0f,0x01,0xef\n\t"
 			: : "a" (eax), "c" (ecx), "d" (edx));
-	assert(pkey_reg == __read_pkey_reg());
 #endif
 }
 
@@ -214,7 +211,6 @@ static void set_pkey(int pkey, unsigned
 	unsigned long mask = (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE);
 	u64 new_pkey_reg;
 
-	assert(!(pkey_value & ~mask));
 	new_pkey_reg = set_pkey_bits(__read_pkey_reg(), pkey, pkey_value);
 	__write_pkey_reg(new_pkey_reg);
 }
@@ -224,7 +220,6 @@ static void setup_single_address(int siz
 	void *ptr;
 
 	ptr = sys_mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	assert(ptr != (void *)-1);
 	*ptrOut = ptr;
 }
 
@@ -234,24 +229,21 @@ static void setup_single_address_rw(int
 	unsigned long mapflags = MAP_ANONYMOUS | MAP_PRIVATE;
 
 	ptr = sys_mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, 0);
-	assert(ptr != (void *)-1);
 	*ptrOut = ptr;
 }
 
-static void clean_single_address(void *ptr, int size)
+static int clean_single_address(void *ptr, int size)
 {
 	int ret;
-
 	ret = munmap(ptr, size);
-	assert(!ret);
+	return ret;
 }
 
-static void seal_single_address(void *ptr, int size)
+static int seal_single_address(void *ptr, int size)
 {
 	int ret;
-
 	ret = sys_mseal(ptr, size);
-	assert(!ret);
+	return ret;
 }
 
 bool seal_support(void)
@@ -290,6 +282,7 @@ static void test_seal_addseal(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	ret = sys_mseal(ptr, size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -305,6 +298,7 @@ static void test_seal_unmapped_start(voi
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* munmap 2 pages from ptr. */
 	ret = sys_munmap(ptr, 2 * page_size);
@@ -332,6 +326,7 @@ static void test_seal_unmapped_middle(vo
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* munmap 2 pages from ptr + page. */
 	ret = sys_munmap(ptr + page_size, 2 * page_size);
@@ -363,6 +358,7 @@ static void test_seal_unmapped_end(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* unmap last 2 pages. */
 	ret = sys_munmap(ptr + 2 * page_size, 2 * page_size);
@@ -391,6 +387,7 @@ static void test_seal_multiple_vmas(void
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split the vma into 3. */
 	ret = sys_mprotect(ptr + page_size, 2 * page_size,
@@ -421,6 +418,7 @@ static void test_seal_split_start(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split at middle */
 	ret = sys_mprotect(ptr, 2 * page_size, PROT_READ | PROT_WRITE);
@@ -445,6 +443,7 @@ static void test_seal_split_end(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split at middle */
 	ret = sys_mprotect(ptr, 2 * page_size, PROT_READ | PROT_WRITE);
@@ -469,7 +468,9 @@ static void test_seal_invalid_input(void
 	int ret;
 
 	setup_single_address(8 * page_size, &ptr);
-	clean_single_address(ptr + 4 * page_size, 4 * page_size);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	ret = clean_single_address(ptr + 4 * page_size, 4 * page_size);
+	FAIL_TEST_IF_FALSE(!ret);
 
 	/* invalid flag */
 	ret = syscall(__NR_mseal, ptr, size, 0x20);
@@ -502,6 +503,7 @@ static void test_seal_zero_length(void)
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	ret = sys_mprotect(ptr, 0, PROT_READ | PROT_WRITE);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -551,6 +553,7 @@ static void test_seal_twice(void)
 	unsigned long size = 4 * page_size;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	ret = sys_mseal(ptr, size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -570,9 +573,12 @@ static void test_seal_mprotect(bool seal
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
-	if (seal)
-		seal_single_address(ptr, size);
+	if (seal) {
+		ret = seal_single_address(ptr, size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	ret = sys_mprotect(ptr, size, PROT_READ | PROT_WRITE);
 	if (seal)
@@ -591,9 +597,12 @@ static void test_seal_start_mprotect(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
-	if (seal)
-		seal_single_address(ptr, page_size);
+	if (seal) {
+		ret = seal_single_address(ptr, page_size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	/* the first page is sealed. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -618,9 +627,12 @@ static void test_seal_end_mprotect(bool
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
-	if (seal)
-		seal_single_address(ptr + page_size, 3 * page_size);
+	if (seal) {
+		ret = seal_single_address(ptr + page_size, 3 * page_size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	/* first page is not sealed */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -645,9 +657,12 @@ static void test_seal_mprotect_unalign_l
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
-	if (seal)
-		seal_single_address(ptr, page_size * 2 - 1);
+	if (seal) {
+		ret = seal_single_address(ptr, page_size * 2 - 1);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	/* 2 pages are sealed. */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
@@ -671,8 +686,11 @@ static void test_seal_mprotect_unalign_l
 	int ret;
 
 	setup_single_address(size, &ptr);
-	if (seal)
-		seal_single_address(ptr, page_size * 2 + 1);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+	if (seal) {
+		ret =  seal_single_address(ptr, page_size * 2 + 1);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	/* 3 pages are sealed. */
 	ret = sys_mprotect(ptr, page_size * 3, PROT_READ | PROT_WRITE);
@@ -696,13 +714,16 @@ static void test_seal_mprotect_two_vma(b
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
 	FAIL_TEST_IF_FALSE(!ret);
 
-	if (seal)
-		seal_single_address(ptr, page_size * 4);
+	if (seal) {
+		ret = seal_single_address(ptr, page_size * 4);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
 	if (seal)
@@ -728,14 +749,17 @@ static void test_seal_mprotect_two_vma_w
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split as two vma. */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
 	FAIL_TEST_IF_FALSE(!ret);
 
 	/* mseal can apply across 2 vma, also split them. */
-	if (seal)
-		seal_single_address(ptr + page_size, page_size * 2);
+	if (seal) {
+		ret = seal_single_address(ptr + page_size, page_size * 2);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	/* the first page is not sealed. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -772,10 +796,13 @@ static void test_seal_mprotect_partial_m
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* seal one page. */
-	if (seal)
-		seal_single_address(ptr, page_size);
+	if (seal) {
+		ret = seal_single_address(ptr, page_size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	/* mprotect first 2 page will fail, since the first page are sealed. */
 	ret = sys_mprotect(ptr, 2 * page_size, PROT_READ | PROT_WRITE);
@@ -795,6 +822,7 @@ static void test_seal_mprotect_two_vma_w
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -837,6 +865,7 @@ static void test_seal_mprotect_split(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -873,6 +902,7 @@ static void test_seal_mprotect_merge(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split one page. */
 	ret = sys_mprotect(ptr, page_size, PROT_READ | PROT_WRITE);
@@ -906,6 +936,7 @@ static void test_seal_munmap(bool seal)
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -936,6 +967,7 @@ static void test_seal_munmap_two_vma(boo
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect to split */
 	ret = sys_mprotect(ptr, page_size * 2, PROT_READ | PROT_WRITE);
@@ -976,6 +1008,7 @@ static void test_seal_munmap_vma_with_ga
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	ret = sys_munmap(ptr + page_size, page_size * 2);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1007,6 +1040,7 @@ static void test_munmap_start_freed(bool
 	int prot;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* unmap the first page. */
 	ret = sys_munmap(ptr, page_size);
@@ -1045,6 +1079,8 @@ static void test_munmap_end_freed(bool s
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
 	/* unmap last page. */
 	ret = sys_munmap(ptr + page_size * 3, page_size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1074,6 +1110,8 @@ static void test_munmap_middle_freed(boo
 	int prot;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
 	/* unmap 2 pages in the middle. */
 	ret = sys_munmap(ptr + page_size, page_size * 2);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1116,6 +1154,7 @@ static void test_seal_mremap_shrink(bool
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1144,6 +1183,7 @@ static void test_seal_mremap_expand(bool
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 	/* ummap last 2 pages. */
 	ret = sys_munmap(ptr + 2 * page_size, 2 * page_size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1175,8 +1215,11 @@ static void test_seal_mremap_move(bool s
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 	setup_single_address(size, &newPtr);
-	clean_single_address(newPtr, size);
+	FAIL_TEST_IF_FALSE(newPtr != (void *)-1);
+	ret = clean_single_address(newPtr, size);
+	FAIL_TEST_IF_FALSE(!ret);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1205,6 +1248,7 @@ static void test_seal_mmap_overwrite_pro
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1232,6 +1276,7 @@ static void test_seal_mmap_expand(bool s
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 	/* ummap last 4 pages. */
 	ret = sys_munmap(ptr + 8 * page_size, 4 * page_size);
 	FAIL_TEST_IF_FALSE(!ret);
@@ -1262,6 +1307,7 @@ static void test_seal_mmap_shrink(bool s
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1290,7 +1336,9 @@ static void test_seal_mremap_shrink_fixe
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 	setup_single_address(size, &newAddr);
+	FAIL_TEST_IF_FALSE(newAddr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1319,7 +1367,9 @@ static void test_seal_mremap_expand_fixe
 	void *ret2;
 
 	setup_single_address(page_size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 	setup_single_address(size, &newAddr);
+	FAIL_TEST_IF_FALSE(newAddr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(newAddr, size);
@@ -1348,7 +1398,9 @@ static void test_seal_mremap_move_fixed(
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 	setup_single_address(size, &newAddr);
+	FAIL_TEST_IF_FALSE(newAddr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(newAddr, size);
@@ -1375,6 +1427,7 @@ static void test_seal_mremap_move_fixed_
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1406,6 +1459,7 @@ static void test_seal_mremap_move_dontun
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1434,6 +1488,7 @@ static void test_seal_mremap_move_dontun
 	void *ret2;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
 		ret = sys_mseal(ptr, size);
@@ -1469,6 +1524,7 @@ static void test_seal_merge_and_split(vo
 
 	/* (24 RO) */
 	setup_single_address(24 * page_size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	/* use mprotect(NONE) to set out boundary */
 	/* (1 NONE) (22 RO) (1 NONE) */
@@ -1700,9 +1756,12 @@ static void test_seal_discard_ro_anon(bo
 	int ret;
 
 	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
-	if (seal)
-		seal_single_address(ptr, size);
+	if (seal) {
+		ret = seal_single_address(ptr, size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
 
 	ret = sys_madvise(ptr, size, MADV_DONTNEED);
 	if (seal)
@@ -1832,5 +1891,4 @@ int main(int argc, char **argv)
 	test_seal_discard_ro_anon_on_pkey(true);
 
 	ksft_finished();
-	return 0;
 }
--- a/tools/testing/selftests/mm/seal_elf.c~selftest-mm-mseal-read-only-elf-memory-segment-fix
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -12,9 +12,7 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <assert.h>
 #include <fcntl.h>
-#include <assert.h>
 #include <sys/ioctl.h>
 #include <sys/vfs.h>
 #include <sys/stat.h>
@@ -179,5 +177,4 @@ int main(int argc, char **argv)
 	test_seal_elf();
 
 	ksft_finished();
-	return 0;
 }
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-wire-up-mseal-syscall.patch
mseal-add-mseal-syscall.patch
selftest-mm-mseal-memory-sealing.patch
mseal-add-documentation.patch
selftest-mm-mseal-read-only-elf-memory-segment.patch
selftest-mm-mseal-read-only-elf-memory-segment-fix.patch

