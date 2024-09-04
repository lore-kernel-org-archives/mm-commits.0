Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7899E75804
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423516; cv=none; b=jkg5kgc6PulxhAT66VI5EfhVOJuWwY8hZTfv29xe0YyiSPED0hmJjw0ovy9er6J062rVTscxI9NLY9+4pBjm426j03ZN/frbTeLFxDU7zQQckrPALSiRPhE+ztPBRdd+3DfbvHatnF5mBOXrmvZzRjRvLls0/N8TzURh1zef3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423516; c=relaxed/simple;
	bh=wX3VTjjm8QqlaGa4WvV8acTITDyjdOCRiVxNzhdGZko=;
	h=Date:To:From:Subject:Message-Id; b=LynBycp37cbQqKcWAN3PQ+UEBA25yRigyTe6VhniBJprJiwut6jzvY/9HTSs51McnHfqOsS+goVRCWNmnKh0Y1b9YQw4puKjLoIDXGK2XuRQSkhAbE882Cp6VSFreQtBq6rORK6hurkj87ef7QHWKnP3PF130deSumEWR5RbYM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A1gFlauX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A1gFlauX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD4DC4CEC2;
	Wed,  4 Sep 2024 04:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423516;
	bh=wX3VTjjm8QqlaGa4WvV8acTITDyjdOCRiVxNzhdGZko=;
	h=Date:To:From:Subject:From;
	b=A1gFlauXj4Z1iVG+hIeUDmYbmuzyPpFpuZpPneswsiTUZrhLEULpMg3QZI6ePXL20
	 Xu0ALO92YdopEc0EL8kqv2YFAQycdpWMCk8eLpFW3MuQqi/aIGe6KXGj2FHJQIS7AL
	 w3lhnn0K3NzMf/7QQvTGzwtDzMZbcoTTni6fYnm0=
Date: Tue, 03 Sep 2024 21:18:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-more-mseal-traversal-tests.patch removed from -mm tree
Message-Id: <20240904041836.4DD4DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add more mseal traversal tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-more-mseal-traversal-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: selftests/mm: add more mseal traversal tests
Date: Sat, 17 Aug 2024 01:18:34 +0100

Add more mseal traversal tests across VMAs, where we could possibly screw
up sealing checks.  These test more across-vma traversal for mprotect,
munmap and madvise.  Particularly, we test for the case where a regular
VMA is followed by a sealed VMA.

[akpm@linux-foundation.org: remove incorrect comment, per review]
[akpm@linux-foundation.org: remove the correct comment, per Pedro]
[pedro.falcato@gmail.com: fix mseal's length]
  Link: https://lkml.kernel.org/r/vc4czyuemmu3kylqb4ctaga6y5yvondlyabimx6jvljlw2fkea@djawlllf45xa
Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-7-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |  106 +++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -777,6 +777,42 @@ static void test_seal_mprotect_partial_m
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
+		ret = sys_mseal(ptr + page_size, page_size);
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
@@ -994,6 +1030,36 @@ static void test_seal_munmap_vma_with_ga
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
+	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
+	if (seal) {
+		ret = sys_mseal(ptr + page_size, page_size);
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
@@ -1746,6 +1812,37 @@ static void test_seal_discard_ro_anon(bo
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
@@ -1790,7 +1887,7 @@ int main(int argc, char **argv)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(82);
+	ksft_set_plan(88);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
@@ -1836,12 +1933,17 @@ int main(int argc, char **argv)
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
@@ -1873,6 +1975,8 @@ int main(int argc, char **argv)
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


