Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53683157466;
	Thu,  8 Aug 2024 23:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723158445; cv=none; b=RaH76vqkFTuVVUTPFRAFpLMqTRkQ6a9qukGFNeaxe304GJzlOYsRbUQR5p0TP8KUS/Ga6wu4sBl9rbuQIl6sOJRa6mETEARPFOSTA7F+WKQfGBc5KHcsTnpasYv6s9hH2ED1ehgZTz/FuT6yXNIlMdP07hr7+6H5fxl6KGlP8R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723158445; c=relaxed/simple;
	bh=qcyZl8+8R+slIVrWSgB26pY2mC6/DFYYz5nZyBghsCc=;
	h=Date:To:From:Subject:Message-Id; b=NnnWoZHnsNQQJXqfSjdEX7b24n/3xlKsuCCl06LEXHFtxe8+VKufo7IADdiI8f9B+pnCYz60xjy+Wv82i36FXqovlfmiBGh/nmyWpNHAmikacpVceyehO+H0AXRQ0sKnXE3/qhTiQVZX2sLAnTLaP9VBBnNWAMuwu/UZd+diY/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtTCdsHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtTCdsHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB58CC32782;
	Thu,  8 Aug 2024 23:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723158444;
	bh=qcyZl8+8R+slIVrWSgB26pY2mC6/DFYYz5nZyBghsCc=;
	h=Date:To:From:Subject:From;
	b=ZtTCdsHDPEpGq2WKD2Vb5T1YZnXZS3SH1JM6wec0xUZJ6rq2W9gH7Z38SYqmQaZlq
	 uKSknzCwHz5Z+SJMBXyvrdiPVPn3Uz4QCrAuTlI2cTnETg7GDizp8cuEUBs9lKB1p8
	 EPv66dxHFJFS5ZuEJ0TyuoYLv7RQM9VU3h2AnZ8Y=
Date: Thu, 08 Aug 2024 16:07:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,pedro.falcato@gmail.com,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dave.hansen@intel.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-mseal-fix-test_seal_mremap_move_dontunmap_anyaddr.patch added to mm-unstable branch
Message-Id: <20240808230724.BB58CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest mm/mseal: fix test_seal_mremap_move_dontunmap_anyaddr
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-mseal-fix-test_seal_mremap_move_dontunmap_anyaddr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-mseal-fix-test_seal_mremap_move_dontunmap_anyaddr.patch

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
Subject: selftest mm/mseal: fix test_seal_mremap_move_dontunmap_anyaddr
Date: Wed, 7 Aug 2024 21:23:20 +0000

the syscall remap accepts following:

mremap(src, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP, dst)

when the src is sealed, the call will fail with error code:
EPERM

Previously, the test uses hard-coded 0xdeaddead as dst, and it
will fail on the system with newer glibc installed.

This patch removes test's dependency on glibc for mremap(), also
fix the test and remove the hardcoded address.

Link: https://lkml.kernel.org/r/20240807212320.2831848-1-jeffxu@chromium.org
Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reported-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |   57 +++++++++++++---------
 1 file changed, 36 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftest-mm-mseal-fix-test_seal_mremap_move_dontunmap_anyaddr
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -110,6 +110,16 @@ static int sys_madvise(void *start, size
 	return sret;
 }
 
+static void *sys_mremap(void *addr, size_t old_len, size_t new_len,
+	unsigned long flags, void *new_addr)
+{
+	void *sret;
+
+	errno = 0;
+	sret = (void *) syscall(__NR_mremap, addr, old_len, new_len, flags, new_addr);
+	return sret;
+}
+
 static int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
 {
 	int ret = syscall(__NR_pkey_alloc, flags, init_val);
@@ -1115,12 +1125,12 @@ static void test_seal_mremap_shrink(bool
 	}
 
 	/* shrink from 4 pages to 2 pages. */
-	ret2 = mremap(ptr, size, 2 * page_size, 0, 0);
+	ret2 = sys_mremap(ptr, size, 2 * page_size, 0, 0);
 	if (seal) {
-		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
+		FAIL_TEST_IF_FALSE(ret2 == (void *) MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
-		FAIL_TEST_IF_FALSE(ret2 != MAP_FAILED);
+		FAIL_TEST_IF_FALSE(ret2 != (void *) MAP_FAILED);
 
 	}
 
@@ -1147,7 +1157,7 @@ static void test_seal_mremap_expand(bool
 	}
 
 	/* expand from 2 page to 4 pages. */
-	ret2 = mremap(ptr, 2 * page_size, 4 * page_size, 0, 0);
+	ret2 = sys_mremap(ptr, 2 * page_size, 4 * page_size, 0, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1180,7 +1190,7 @@ static void test_seal_mremap_move(bool s
 	}
 
 	/* move from ptr to fixed address. */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newPtr);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newPtr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1299,7 +1309,7 @@ static void test_seal_mremap_shrink_fixe
 	}
 
 	/* mremap to move and shrink to fixed address */
-	ret2 = mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
+	ret2 = sys_mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
 			newAddr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
@@ -1330,7 +1340,7 @@ static void test_seal_mremap_expand_fixe
 	}
 
 	/* mremap to move and expand to fixed address */
-	ret2 = mremap(ptr, page_size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
+	ret2 = sys_mremap(ptr, page_size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
 			newAddr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
@@ -1361,7 +1371,7 @@ static void test_seal_mremap_move_fixed(
 	}
 
 	/* mremap to move to fixed address */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newAddr);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, newAddr);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
@@ -1390,14 +1400,13 @@ static void test_seal_mremap_move_fixed_
 	/*
 	 * MREMAP_FIXED can move the mapping to zero address
 	 */
-	ret2 = mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
+	ret2 = sys_mremap(ptr, size, 2 * page_size, MREMAP_MAYMOVE | MREMAP_FIXED,
 			0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
 		FAIL_TEST_IF_FALSE(ret2 == 0);
-
 	}
 
 	REPORT_TEST_PASS();
@@ -1420,13 +1429,13 @@ static void test_seal_mremap_move_dontun
 	}
 
 	/* mremap to move, and don't unmap src addr. */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP, 0);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP, 0);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
+		/* kernel will allocate a new address */
 		FAIL_TEST_IF_FALSE(ret2 != MAP_FAILED);
-
 	}
 
 	REPORT_TEST_PASS();
@@ -1434,7 +1443,7 @@ static void test_seal_mremap_move_dontun
 
 static void test_seal_mremap_move_dontunmap_anyaddr(bool seal)
 {
-	void *ptr;
+	void *ptr, *ptr2;
 	unsigned long page_size = getpagesize();
 	unsigned long size = 4 * page_size;
 	int ret;
@@ -1449,24 +1458,30 @@ static void test_seal_mremap_move_dontun
 	}
 
 	/*
-	 * The 0xdeaddead should not have effect on dest addr
-	 * when MREMAP_DONTUNMAP is set.
+	 * The new address is any address that not allocated.
+	 * use allocate/free to similate that.
+	 */
+	setup_single_address(size, &ptr2);
+	FAIL_TEST_IF_FALSE(ptr2 != (void *)-1);
+	ret = sys_munmap(ptr2, size);
+	FAIL_TEST_IF_FALSE(!ret);
+
+	/*
+	 * remap to any address.
 	 */
-	ret2 = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
-			0xdeaddead);
+	ret2 = sys_mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+			(void *) ptr2);
 	if (seal) {
 		FAIL_TEST_IF_FALSE(ret2 == MAP_FAILED);
 		FAIL_TEST_IF_FALSE(errno == EPERM);
 	} else {
-		FAIL_TEST_IF_FALSE(ret2 != MAP_FAILED);
-		FAIL_TEST_IF_FALSE((long)ret2 != 0xdeaddead);
-
+		/* remap success and return ptr2 */
+		FAIL_TEST_IF_FALSE(ret2 ==  ptr2);
 	}
 
 	REPORT_TEST_PASS();
 }
 
-
 static void test_seal_merge_and_split(void)
 {
 	void *ptr;
_

Patches currently in -mm which might be from jeffxu@chromium.org are

selftest-mm-mseal-fix-test_seal_mremap_move_dontunmap_anyaddr.patch

