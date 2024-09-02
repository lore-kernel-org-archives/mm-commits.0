Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D44223D2;
	Mon,  2 Sep 2024 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238770; cv=none; b=SL6YIcUKsDbJmR00za+3q2W38LFtpDkhTxWFlTUAHLJiJnSjg3/y7DgXPzOrhMGrhjXlurSIlw1S9oDWcPWpI3m9fuxgzU+mmbeXO/G6se+aG5JZraaCV/YUTN77os5VcJSfctQm4nezEaprMhH4bfx6Z51PaHeHkEWnV4KOM7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238770; c=relaxed/simple;
	bh=UkeLpNrA1tkxnoleV3qkMGYSrCGgU/j4GkFRBiYeSa8=;
	h=Date:To:From:Subject:Message-Id; b=dJdRHAjAvPZIvjKQi5exgKj25btWTdef5Ty9IwRBCeHAiEX5JFpLDH1HWbVpdMWkAjt8qz+3MD1iFUsScX2ehvmk6fLXaJIf+7WRd6O0pfstQGEuUz1RSV3fVEQ9incLqrjKu99coDkq1yNWeuCtDv9rvxC90QAXd0yHFaSNrqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1dMhJfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1dMhJfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786FAC4CEC3;
	Mon,  2 Sep 2024 00:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238769;
	bh=UkeLpNrA1tkxnoleV3qkMGYSrCGgU/j4GkFRBiYeSa8=;
	h=Date:To:From:Subject:From;
	b=O1dMhJfc+813gqnMofKS6LfWoJfDODFAdL5EYVJXgqi+RtlAcOd3Q1e1eQJ64Jqnz
	 FSNasjsuid/4pv1f70+lhYUn9UjAgRn1P0RKayfd0sBR/kYtwUcGGh3gEosfORkjLv
	 6xSqRwy9rbyYwvuXZmZ9Mq1OwOSERIViHEEAtj+M=
Date: Sun, 01 Sep 2024 17:59:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-build-errors-on-armhf.patch removed from -mm tree
Message-Id: <20240902005929.786FAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix build errors on armhf
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-build-errors-on-armhf.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: fix build errors on armhf
Date: Fri, 9 Aug 2024 13:25:11 +0500

The __NR_mmap isn't found on armhf.  The mmap() is commonly available
system call and its wrapper is present on all architectures.  So it should
be used directly.  It solves problem for armhf and doesn't create problem
for other architectures.

Remove sys_mmap() functions as they aren't doing anything else other than
calling mmap().  There is no need to set errno = 0 manually as glibc
always resets it.

For reference errors are as following:

  CC       seal_elf
seal_elf.c: In function 'sys_mmap':
seal_elf.c:39:33: error: '__NR_mmap' undeclared (first use in this function)
   39 |         sret = (void *) syscall(__NR_mmap, addr, len, prot,
      |                                 ^~~~~~~~~

mseal_test.c: In function 'sys_mmap':
mseal_test.c:90:33: error: '__NR_mmap' undeclared (first use in this function)
   90 |         sret = (void *) syscall(__NR_mmap, addr, len, prot,
      |                                 ^~~~~~~~~

Link: https://lkml.kernel.org/r/20240809082511.497266-1-usama.anjum@collabora.com
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |   37 +++++++---------------
 tools/testing/selftests/mm/seal_elf.c   |   13 -------
 2 files changed, 14 insertions(+), 36 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-fix-build-errors-on-armhf
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -81,17 +81,6 @@ static int sys_mprotect_pkey(void *ptr,
 	return sret;
 }
 
-static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
-	unsigned long flags, unsigned long fd, unsigned long offset)
-{
-	void *sret;
-
-	errno = 0;
-	sret = (void *) syscall(__NR_mmap, addr, len, prot,
-		flags, fd, offset);
-	return sret;
-}
-
 static int sys_munmap(void *ptr, size_t size)
 {
 	int sret;
@@ -172,7 +161,7 @@ static void setup_single_address(int siz
 {
 	void *ptr;
 
-	ptr = sys_mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ptr = mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	*ptrOut = ptr;
 }
 
@@ -181,7 +170,7 @@ static void setup_single_address_rw(int
 	void *ptr;
 	unsigned long mapflags = MAP_ANONYMOUS | MAP_PRIVATE;
 
-	ptr = sys_mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, 0);
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, 0);
 	*ptrOut = ptr;
 }
 
@@ -205,7 +194,7 @@ bool seal_support(void)
 	void *ptr;
 	unsigned long page_size = getpagesize();
 
-	ptr = sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ptr = mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (ptr == (void *) -1)
 		return false;
 
@@ -481,8 +470,8 @@ static void test_seal_zero_address(void)
 	int prot;
 
 	/* use mmap to change protection. */
-	ptr = sys_mmap(0, size, PROT_NONE,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ptr = mmap(0, size, PROT_NONE,
+		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	FAIL_TEST_IF_FALSE(ptr == 0);
 
 	size = get_vma_size(ptr, &prot);
@@ -1209,8 +1198,8 @@ static void test_seal_mmap_overwrite_pro
 	}
 
 	/* use mmap to change protection. */
-	ret2 = sys_mmap(ptr, size, PROT_NONE,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ret2 = mmap(ptr, size, PROT_NONE,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1240,8 +1229,8 @@ static void test_seal_mmap_expand(bool s
 	}
 
 	/* use mmap to expand. */
-	ret2 = sys_mmap(ptr, size, PROT_READ,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ret2 = mmap(ptr, size, PROT_READ,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1268,8 +1257,8 @@ static void test_seal_mmap_shrink(bool s
 	}
 
 	/* use mmap to shrink. */
-	ret2 = sys_mmap(ptr, 8 * page_size, PROT_READ,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ret2 = mmap(ptr, 8 * page_size, PROT_READ,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1650,7 +1639,7 @@ static void test_seal_discard_ro_anon_on
 	ret = fallocate(fd, 0, 0, size);
 	FAIL_TEST_IF_FALSE(!ret);
 
-	ptr = sys_mmap(NULL, size, PROT_READ, mapflags, fd, 0);
+	ptr = mmap(NULL, size, PROT_READ, mapflags, fd, 0);
 	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
@@ -1680,7 +1669,7 @@ static void test_seal_discard_ro_anon_on
 	int ret;
 	unsigned long mapflags = MAP_ANONYMOUS | MAP_SHARED;
 
-	ptr = sys_mmap(NULL, size, PROT_READ, mapflags, -1, 0);
+	ptr = mmap(NULL, size, PROT_READ, mapflags, -1, 0);
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
--- a/tools/testing/selftests/mm/seal_elf.c~selftests-mm-fix-build-errors-on-armhf
+++ a/tools/testing/selftests/mm/seal_elf.c
@@ -30,17 +30,6 @@ static int sys_mseal(void *start, size_t
 	return sret;
 }
 
-static void *sys_mmap(void *addr, unsigned long len, unsigned long prot,
-	unsigned long flags, unsigned long fd, unsigned long offset)
-{
-	void *sret;
-
-	errno = 0;
-	sret = (void *) syscall(__NR_mmap, addr, len, prot,
-		flags, fd, offset);
-	return sret;
-}
-
 static inline int sys_mprotect(void *ptr, size_t size, unsigned long prot)
 {
 	int sret;
@@ -56,7 +45,7 @@ static bool seal_support(void)
 	void *ptr;
 	unsigned long page_size = getpagesize();
 
-	ptr = sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ptr = mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (ptr == (void *) -1)
 		return false;
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


