Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E7D537FF
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247765; cv=none; b=JlsM/2Ewo8giyMJvD1bAjsC1Zht3RwXxQFIIjgIgblD8FyRcQMW+Y43llnOMi6OJYGUqw66dbl+2+8+s5BK2CcugcCpQ7zRfnxc5QK//TdB/xhcj1OMkEDajoX/pvwwetcv933WZZ+Mg4gmP8i6frNd6JSgLk2MsXrpfEykpp1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247765; c=relaxed/simple;
	bh=bSD3zu16uvE9CNEhVutYxLnBdckRMxO2yan1yCKHLHU=;
	h=Date:To:From:Subject:Message-Id; b=JrajKwYnAoLaTF66PI0Mu2FYkOO/1KTCTCSIZIkMKAID4xKH1jf9ZVkFQt/Ujeg2NUKZRX1YjKB3BAfn6ul1Zf7RrU+gy3UqJy2C+yNupY1BFq+CZREGk04QgIPvX3LFvDfYRIKQ2mOmFEvGEpE4tZPjhhVWFToW69cqWo+R7N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BqiCalUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BqiCalUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D281DC4CEC7;
	Mon,  2 Sep 2024 03:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247764;
	bh=bSD3zu16uvE9CNEhVutYxLnBdckRMxO2yan1yCKHLHU=;
	h=Date:To:From:Subject:From;
	b=BqiCalUNvY8p7KBb9PBsp1mU2+VL+WNR3Z3M4MiyCijLEdhjGkgpBXBjZKKY7DAtq
	 0zw7U3V2/9oURzRumXV08LwExDZOzvAA5qfs/wC9FmUSh3ScQhgPbtZYypO/pOnsnG
	 b9Kc5s3nQ1rTnVlCZpiRw6pG/K3+emCcqTI3wars=
Date: Sun, 01 Sep 2024 20:29:24 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-mseal-test-for-no-discard-madvise.patch removed from -mm tree
Message-Id: <20240902032924.D281DC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add mseal test for no-discard madvise
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-mseal-test-for-no-discard-madvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: selftests/mm: add mseal test for no-discard madvise
Date: Wed, 7 Aug 2024 18:33:36 +0100

Add an mseal test for madvise() operations that aren't considered
"discard" (e.g purely advisory ops such as MADV_RANDOM).

[pedro.falcato@gmail.com: adjust the mseal test's plan]
  Link: https://lkml.kernel.org/r/20240807203724.2686144-1-pedro.falcato@gmail.com
Link: https://lkml.kernel.org/r/20240807173336.2523757-3-pedro.falcato@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Tested-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |   36 +++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-mseal-test-for-no-discard-madvise
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1731,6 +1731,38 @@ static void test_seal_discard_ro_anon(bo
 	REPORT_TEST_PASS();
 }
 
+static void test_seal_madvise_nodiscard(bool seal)
+{
+	void *ptr;
+	unsigned long page_size = getpagesize();
+	unsigned long size = 4 * page_size;
+	int ret;
+
+	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
+	if (seal) {
+		ret = seal_single_address(ptr, size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
+
+	/*
+	 * Test a random madvise flag like MADV_RANDOM that does not touch page
+	 * contents (and thus should work for msealed VMAs). RANDOM also happens to
+	 * share bits with other discard-ish flags like REMOVE.
+	 */
+	ret = sys_madvise(ptr, size, MADV_RANDOM);
+	FAIL_TEST_IF_FALSE(!ret);
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
 int main(int argc, char **argv)
 {
 	bool test_seal = seal_support();
@@ -1743,7 +1775,7 @@ int main(int argc, char **argv)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(80);
+	ksft_set_plan(82);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
@@ -1822,6 +1854,8 @@ int main(int argc, char **argv)
 	test_seal_mremap_move_fixed_zero(true);
 	test_seal_mremap_move_dontunmap_anyaddr(false);
 	test_seal_mremap_move_dontunmap_anyaddr(true);
+	test_seal_madvise_nodiscard(false);
+	test_seal_madvise_nodiscard(true);
 	test_seal_discard_ro_anon(false);
 	test_seal_discard_ro_anon(true);
 	test_seal_discard_ro_anon_on_rw(false);
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch
selftests-mm-add-more-mseal-traversal-tests-fix-2.patch

