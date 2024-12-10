Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A0B4A04
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794680; cv=none; b=pYE5AvO/M5RQGyOwHmxARh68l1yZvE2Nz4ADGyfhq1cvRXfd3c7OtREoTbk2gQK5lZESR4hThyjfEmOAG1FKaZOUHpgsjTsUa8yrXsVhzE7htC7+E4Ix5uMI7X4zzCg5589R3/qRwicskCzp0kD0DWKvUr1tWihLmnJxAXm4Sdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794680; c=relaxed/simple;
	bh=OQhHRfC0od6gHTgDhN4XntFCb/a0pWKkSewHnejSGIE=;
	h=Date:To:From:Subject:Message-Id; b=D4W6BRbfBWHzNRIu8fPTMxODQ/k3YzILXSnYtTeYWgjZqtpQ8F5VXjOZ5XS3XpRRgDsLKmV6EbzJy1afPsRYru/PIS0q9q3+REeTkkTGX/YdPkJd2XOOqkbW2orDaS1Mp/SYR3TAVNzNJyO9L3TDh3iAbEkAPBIz1nVHjHRFM7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdwY31lp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdwY31lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4395FC4CED1;
	Tue, 10 Dec 2024 01:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733794680;
	bh=OQhHRfC0od6gHTgDhN4XntFCb/a0pWKkSewHnejSGIE=;
	h=Date:To:From:Subject:From;
	b=HdwY31lpKxD2OrDUULo1+FkMVXJYjjmeG6QH0BEbvj9gER/MR7QCQEXJlitllhjRq
	 e95Kh2cF4wQJtmaQOC5ZJivNF/r8qzpFlNo2pXSwO+6Tif7IsYB7Z8Uqkgmbpo1teM
	 WrXvM/ZmY4H7lo+G7cx0BpanP/cUUqDIUMrsH5f0=
Date: Mon, 09 Dec 2024 17:37:59 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal_test-remove-unused-variables.patch added to mm-unstable branch
Message-Id: <20241210013800.4395FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mseal_test: remove unused variables
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mseal_test-remove-unused-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mseal_test-remove-unused-variables.patch

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

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

