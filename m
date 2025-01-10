Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C03DDCD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468162; cv=none; b=KUimszoFGEXchlStjMB6GOEjel7PuURc1TgSvIliL71y3p1VhROdjQ3sbJc7/6a7N7LN1MyG3e9nlmTr8/YLySm9f1704fFCd5xDucuV8NcK5WRhJXGPHnPQeZET8yS4uOPC+YiDV04tdw/aMN5cmnidVO51P8yKjj14w2bEp3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468162; c=relaxed/simple;
	bh=dbOKjYJKVCZyaiJmO2x7Ja36Tyb39o4AlN7bpZIaptg=;
	h=Date:To:From:Subject:Message-Id; b=tCIRXZnvrORHV7LfAPbJ4eSxGv0a07pYmzlPI63r+bZQvc6w5zSllemXyt18xAL+DSgTPZg01mDAwxgV/C2e6G01jNNBfn+DDEraua39AJ2gnrbz3Fgeqs/cu6DydVi4zt3PlODv0LFc02/ZC2lIBvmCxYjaa0FEgqdAJAoVPng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RU9Vx5Vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RU9Vx5Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFE4C4CED3;
	Fri, 10 Jan 2025 00:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468161;
	bh=dbOKjYJKVCZyaiJmO2x7Ja36Tyb39o4AlN7bpZIaptg=;
	h=Date:To:From:Subject:From;
	b=RU9Vx5Vu85CnT1r0matJXvp5xhNYNbZDnZgjnRMa9FZvE8vhdrLxpngjHA2B2liCT
	 GGvKEu9u2Sd/s0/8fbXah85PcciBdP/bn7q9/fl40HaPumDVKV7a+LeCRdcA8rxBhD
	 w5vJkFAD37CmgAc0wZ8WJ2h2zTC/DgQy37lT8heI=
Date: Thu, 09 Jan 2025 16:16:01 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-fix-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001601.8EFE4C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged: fix type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-khugepaged-fix-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-fix-type-mismatch-warnings.patch

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
Subject: selftests/mm: khugepaged: fix type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:38 +0500

Fix type mismatch warnings.

Link: https://lkml.kernel.org/r/20250109173842.1142376-13-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -140,7 +140,7 @@ static void get_finfo(const char *dir)
 		exit(EXIT_FAILURE);
 	}
 	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
-		     finfo.dir) >= sizeof(finfo.path)) {
+		     finfo.dir) >= (signed int)sizeof(finfo.path)) {
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
@@ -155,7 +155,7 @@ static void get_finfo(const char *dir)
 	/* Find owning device's queue/read_ahead_kb control */
 	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
 		     major(path_stat.st_dev), minor(path_stat.st_dev))
-	    >= sizeof(path)) {
+	    >= (signed int)sizeof(path)) {
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
@@ -169,7 +169,7 @@ static void get_finfo(const char *dir)
 			     sizeof(finfo.dev_queue_read_ahead_path),
 			     "/sys/dev/block/%d:%d/queue/read_ahead_kb",
 			     major(path_stat.st_dev), minor(path_stat.st_dev))
-		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
+		    >= (signed int)sizeof(finfo.dev_queue_read_ahead_path)) {
 			printf("%s: Pathname is too long\n", __func__);
 			exit(EXIT_FAILURE);
 		}
@@ -197,7 +197,7 @@ static void get_finfo(const char *dir)
 			if (snprintf(finfo.dev_queue_read_ahead_path,
 				     sizeof(finfo.dev_queue_read_ahead_path),
 				     "/sys/block/%s/queue/read_ahead_kb",
-				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
+				     str) >= (signed int)sizeof(finfo.dev_queue_read_ahead_path)) {
 				printf("%s: Pathname is too long\n", __func__);
 				exit(EXIT_FAILURE);
 			}
@@ -271,7 +271,7 @@ static void *alloc_mapping(int nr)
 
 static void fill_memory(int *p, unsigned long start, unsigned long end)
 {
-	int i;
+	unsigned int i;
 
 	for (i = start / page_size; i < end / page_size; i++)
 		p[i * page_size / sizeof(*p)] = i + 0xdead0000;
@@ -333,10 +333,10 @@ static void *alloc_hpage(struct mem_ops
 
 static void validate_memory(int *p, unsigned long start, unsigned long end)
 {
-	int i;
+	unsigned int i;
 
 	for (i = start / page_size; i < end / page_size; i++) {
-		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000) {
+		if ((unsigned int)p[i * page_size / sizeof(*p)] != i + 0xdead0000) {
 			printf("Page %d is corrupted: %#x\n",
 					i, p[i * page_size / sizeof(*p)]);
 			exit(EXIT_FAILURE);
@@ -537,7 +537,7 @@ static void madvise_collapse(const char
 static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 			  struct mem_ops *ops)
 {
-	int full_scans;
+	unsigned int full_scans;
 	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch
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

