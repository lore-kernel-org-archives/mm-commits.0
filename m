Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221B223C714
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837034; cv=none; b=VgcN9ASM1O4ZpSX3Z+CPVhYHrF6tAHhEPIIti0w7+PZW69kWMfKu00DBN3wnvVHEwxpULyPqHgKTUwupRTpoNIGTE6QDypFfKv+fpiI5KYIVj0XKVoXuc2lqH9QC1AkPT4Kz5NxeFJxg0lHq7LUKtJMRq9jW4JDvtabgHxMR6L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837034; c=relaxed/simple;
	bh=wjoaGw9eK5Tha6Eoa5PC1aaUNbcd31c8pRlE7hKSbZc=;
	h=Date:To:From:Subject:Message-Id; b=cO6Mm8FOWkBkiu6E8HhrGslrRh21s3dRmjhWrEPfzjZdiLL6DzzfmrntBSsONOXYqitNBHUVQzv7uox7yzcCCVEKAREnmRRB7SXY0VJhS5AY4WveE5/zZylUlOLdCO1VVyV7Drn8RtDsouxH8sZYLrIV2KD7nqdTVn4tsrP+77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjqOZk7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjqOZk7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B4C4CEDD;
	Tue, 14 Jan 2025 06:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837034;
	bh=wjoaGw9eK5Tha6Eoa5PC1aaUNbcd31c8pRlE7hKSbZc=;
	h=Date:To:From:Subject:From;
	b=WjqOZk7yZ9979wjBzAHVvm/uKae9rWFprQoJEMRuyji0e4CY12m/4IwTYkJqX9njP
	 iVQK1zJCYrSqnp1C2HEciEO7Dwy+RCg+6K5hspUyZhH335/s4EcBftkkiR4DMZywak
	 /5pv97EiLCcCkGis5AnfHSgNjBnZ7nRao3+W7ReQ=
Date: Mon, 13 Jan 2025 22:43:53 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mseal_test-remove-unused-variables.patch removed from -mm tree
Message-Id: <20250114064353.EC3B4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mseal_test: remove unused variables
has been removed from the -mm tree.  Its filename was
     selftests-mm-mseal_test-remove-unused-variables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mseal_test: remove unused variables
Date: Mon, 9 Dec 2024 23:56:23 +0500

Fix following warnings:
- Remove unused variables and fix following warnings:

Link: https://lkml.kernel.org/r/20241209185624.2245158-4-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-mseal_test-remove-unused-variables
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -802,7 +802,7 @@ static void test_seal_mprotect_partial_m
 }
 
 
-static void test_seal_mprotect_two_vma_with_gap(bool seal)
+static void test_seal_mprotect_two_vma_with_gap(void)
 {
 	void *ptr;
 	unsigned long page_size = getpagesize();
@@ -1864,7 +1864,7 @@ static void test_seal_madvise_nodiscard(
 	REPORT_TEST_PASS();
 }
 
-int main(int argc, char **argv)
+int main(void)
 {
 	bool test_seal = seal_support();
 
@@ -1913,8 +1913,8 @@ int main(int argc, char **argv)
 	test_seal_mprotect_partial_mprotect(false);
 	test_seal_mprotect_partial_mprotect(true);
 
-	test_seal_mprotect_two_vma_with_gap(false);
-	test_seal_mprotect_two_vma_with_gap(true);
+	test_seal_mprotect_two_vma_with_gap();
+	test_seal_mprotect_two_vma_with_gap();
 
 	test_seal_mprotect_merge(false);
 	test_seal_mprotect_merge(true);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-remove-argc-and-argv-unused-parameters.patch
selftests-mm-fix-unused-parameter-warnings.patch
selftests-mm-fix-type-mismatch-warnings.patch
selftests-mm-kselftest_harness-fix-warnings.patch
selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch
selftests-mm-hmm-tests-remove-always-false-expressions.patch
selftests-mm-guard-pages-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch
selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch
selftests-mm-khugepaged-fix-type-mismatch-warnings.patch
selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch
selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch
selftests-mm-uffd-fix-all-type-mismatch-warnings.patch
selftests-mm-makefile-add-the-compiler-flags.patch

