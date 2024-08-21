Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6A3EA98
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206085; cv=none; b=q0b+RaG0THrWATCeIrCiluowD5DwXwY+6rZJcb5feXx7sQ5K2Fp5hN7ZMetbT4YDZLYr6Rc4l+xULh+7rTiuA0SG896p1CypvVwx5aJ26zpcZKYQlqV2Uo9rF4kBmZ3dM7ai0+/XegSwwahSt6KnDtrY8RCD52NCHkANj+Rn/eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206085; c=relaxed/simple;
	bh=tLrTXB1cizgWl6VpIqAcoTBpaQYTawptOcPow8trXso=;
	h=Date:To:From:Subject:Message-Id; b=Mc8sOsCPvUnpeh7uC7UHTnuVW8LqHOnfskUXLWc2JPgjljUbivyfDebeHyrzH3kpUc47nFpHmgM5okBGFOJITalK3OiCfh5AMz00YA5edQWNOFtldt0btW9kklBRXYSJm35U1R5Yv1eoSixvKCeujAqLQq0e2rpLLYf6efxoHFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xs5Q7ZFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xs5Q7ZFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5BCC4AF18;
	Wed, 21 Aug 2024 02:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206085;
	bh=tLrTXB1cizgWl6VpIqAcoTBpaQYTawptOcPow8trXso=;
	h=Date:To:From:Subject:From;
	b=Xs5Q7ZFH734iePw16ZxoLXeorneBv0xrAvsa8xBnx/KCtvH051Z8R6xjUUHAb6ypk
	 UZ2AwlzUYxI7LgdboM0DcGpkCnGvgJoT7ci3ml5A1Znzd77ObyIdnjdk0+XjQr6sRs
	 ZF/MuCk7CqcbZMKOfL4sqZyQQFylz0GwcU/xUMWM=
Date: Tue, 20 Aug 2024 19:08:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-more-mseal-traversal-tests.patch added to mm-unstable branch
Message-Id: <20240821020805.5A5BCC4AF18@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add more mseal traversal tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-more-mseal-traversal-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-more-mseal-traversal-tests.patch

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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: selftests/mm: add more mseal traversal tests
Date: Sat, 17 Aug 2024 01:18:34 +0100

Add more mseal traversal tests across VMAs, where we could possibly screw
up sealing checks.  These test more across-vma traversal for mprotect,
munmap and madvise.  Particularly, we test for the case where a regular
VMA is followed by a sealed VMA.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-7-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |  111 +++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -766,6 +766,42 @@ static void test_seal_mprotect_partial_m
 	REPORT_TEST_PASS();
 }
 
+static void test_seal_mprotect_partial_mprotect_tail(bool seal)
+{
+	void *ptr;
+	unsigned long page_size = getpagesize();
+	unsigned long size = 2 * page_size;
+	int ret;
+	int prot;
+
+	/*
+	 * Check if a partial mseal (that results in two vmas) works correctly.
+	 * It might mprotect the first, but it'll never touch the second (msealed) vma.
+	 */
+
+	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
+	if (seal) {
+		ret = sys_mseal(ptr + page_size, size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
+
+	ret = sys_mprotect(ptr, size, PROT_EXEC);
+	if (seal)
+		FAIL_TEST_IF_FALSE(ret < 0);
+	else
+		FAIL_TEST_IF_FALSE(!ret);
+
+	if (seal) {
+		FAIL_TEST_IF_FALSE(get_vma_size(ptr + page_size, &prot) > 0);
+		FAIL_TEST_IF_FALSE(prot == 0x4);
+	}
+
+	REPORT_TEST_PASS();
+}
+
+
 static void test_seal_mprotect_two_vma_with_gap(bool seal)
 {
 	void *ptr;
@@ -983,6 +1019,41 @@ static void test_seal_munmap_vma_with_ga
 	REPORT_TEST_PASS();
 }
 
+static void test_seal_munmap_partial_across_vmas(bool seal)
+{
+	void *ptr;
+	unsigned long page_size = getpagesize();
+	unsigned long size = 2 * page_size;
+	int ret;
+	int prot;
+
+	/*
+	 * Check if a partial mseal (that results in two vmas) works correctly.
+	 * It might unmap the first, but it'll never unmap the second (msealed) vma.
+	 */
+
+	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
+	if (seal) {
+		ret = sys_mseal(ptr + page_size, size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
+
+	ret = sys_munmap(ptr, size);
+	if (seal)
+		FAIL_TEST_IF_FALSE(ret < 0);
+	else
+		FAIL_TEST_IF_FALSE(!ret);
+
+	if (seal) {
+		FAIL_TEST_IF_FALSE(get_vma_size(ptr + page_size, &prot) > 0);
+		FAIL_TEST_IF_FALSE(prot == 0x4);
+	}
+
+	REPORT_TEST_PASS();
+}
+
 static void test_munmap_start_freed(bool seal)
 {
 	void *ptr;
@@ -1735,6 +1806,37 @@ static void test_seal_discard_ro_anon(bo
 	REPORT_TEST_PASS();
 }
 
+static void test_seal_discard_across_vmas(bool seal)
+{
+	void *ptr;
+	unsigned long page_size = getpagesize();
+	unsigned long size = 2 * page_size;
+	int ret;
+
+	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
+	if (seal) {
+		ret = seal_single_address(ptr + page_size, page_size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
+
+	ret = sys_madvise(ptr, size, MADV_DONTNEED);
+	if (seal)
+		FAIL_TEST_IF_FALSE(ret < 0);
+	else
+		FAIL_TEST_IF_FALSE(!ret);
+
+	ret = sys_munmap(ptr, size);
+	if (seal)
+		FAIL_TEST_IF_FALSE(ret < 0);
+	else
+		FAIL_TEST_IF_FALSE(!ret);
+
+	REPORT_TEST_PASS();
+}
+
+
 static void test_seal_madvise_nodiscard(bool seal)
 {
 	void *ptr;
@@ -1779,7 +1881,7 @@ int main(int argc, char **argv)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(82);
+	ksft_set_plan(88);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
@@ -1825,12 +1927,17 @@ int main(int argc, char **argv)
 	test_seal_mprotect_split(false);
 	test_seal_mprotect_split(true);
 
+	test_seal_mprotect_partial_mprotect_tail(false);
+	test_seal_mprotect_partial_mprotect_tail(true);
+
 	test_seal_munmap(false);
 	test_seal_munmap(true);
 	test_seal_munmap_two_vma(false);
 	test_seal_munmap_two_vma(true);
 	test_seal_munmap_vma_with_gap(false);
 	test_seal_munmap_vma_with_gap(true);
+	test_seal_munmap_partial_across_vmas(false);
+	test_seal_munmap_partial_across_vmas(true);
 
 	test_munmap_start_freed(false);
 	test_munmap_start_freed(true);
@@ -1862,6 +1969,8 @@ int main(int argc, char **argv)
 	test_seal_madvise_nodiscard(true);
 	test_seal_discard_ro_anon(false);
 	test_seal_discard_ro_anon(true);
+	test_seal_discard_across_vmas(false);
+	test_seal_discard_across_vmas(true);
 	test_seal_discard_ro_anon_on_rw(false);
 	test_seal_discard_ro_anon_on_rw(true);
 	test_seal_discard_ro_anon_on_shared(false);
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

