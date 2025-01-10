Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8896FA2D
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736468165; cv=none; b=D4BSvx2kklu9NALQvDPVbJXdIykMcdlenciGpWIcA2+XnvvELlmnGUTW3r3mo++AE1S/whOADuGbij/b5sN9hN8Xq9PoIIvChmCaFTCZAaU+kS4bxlQWnx+TVhYcOxenH5z5ktu4UqHEDal3TKlTCr32HF3E5bgC2BcnoCdcuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736468165; c=relaxed/simple;
	bh=BpivQTQrMPmSLpu6kM3U3huGyiK01fq7QQE91pz7Ljc=;
	h=Date:To:From:Subject:Message-Id; b=D0ZQl4zNDsa5HH+AkFXHjxTMrL/q2lU92crT8T4XhE6V81gV04wvgxfl4HY/Gf3lELeV2FJBh4k4G/ysfG3e9Y0mMJ0epgNmxkU14TYyFCifb+p1LKv2vPooMrzTIGjlT3PuYpoMIDB0h05wSHXiiv3tJdOnbeBWv7m7Ntp4hvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGPyHT6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGPyHT6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D688C4CED2;
	Fri, 10 Jan 2025 00:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736468165;
	bh=BpivQTQrMPmSLpu6kM3U3huGyiK01fq7QQE91pz7Ljc=;
	h=Date:To:From:Subject:From;
	b=XGPyHT6FmhPUwAb2HJeGsYgPBP3yr1YWoUZ6ZxnPXSTDvLdVDQTFqAbKHILrRUEvA
	 AztVt/pn/abUqq8gD6sQ+cn35RX9jnWWA7S0zmQ3EvpqyNFFPmXyaQLmkbtKRf2EQ2
	 Zk3ggDy0B7vQFYM5GXrTE0xDhcGaO2nlaWa/DSVs=
Date: Thu, 09 Jan 2025 16:16:04 -0800
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,luto@amacapital.net,kees@kernel.org,jglisse@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch added to mm-unstable branch
Message-Id: <20250110001605.5D688C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: thuge-gen: fix type mismatch warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch

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
Subject: selftests/mm: thuge-gen: fix type mismatch warnings
Date: Thu, 9 Jan 2025 22:38:40 +0500

Fix all the found type mismatch warnings.

Link: https://lkml.kernel.org/r/20250109173842.1142376-15-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-thuge-gen-fix-type-mismatch-warnings
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -65,7 +65,7 @@ void show(unsigned long ps)
 {
 	char buf[100];
 
-	if (ps == getpagesize())
+	if ((signed long)ps == getpagesize())
 		return;
 
 	ksft_print_msg("%luMB: ", ps >> 20);
@@ -106,7 +106,7 @@ unsigned long read_sysfs(int warn, char
 
 unsigned long read_free(unsigned long ps)
 {
-	return read_sysfs(ps != getpagesize(),
+	return read_sysfs((signed long)ps != getpagesize(),
 			  "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
 			  ps >> 10);
 }
@@ -126,7 +126,7 @@ void test_mmap(unsigned long size, unsig
 	after = read_free(size);
 
 	show(size);
-	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+	ksft_test_result((signed long)size == getpagesize() || (before - after) == NUM_PAGES,
 			 "%s mmap\n", __func__);
 
 	if (munmap(map, size * NUM_PAGES))
@@ -164,7 +164,7 @@ void test_shmget(unsigned long size, uns
 	after = read_free(size);
 
 	show(size);
-	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+	ksft_test_result((signed long)size == getpagesize() || (before - after) == NUM_PAGES,
 			 "%s: mmap\n", __func__);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
@@ -173,7 +173,7 @@ void test_shmget(unsigned long size, uns
 void find_pagesizes(void)
 {
 	unsigned long largest = getpagesize();
-	int i;
+	unsigned int i;
 	glob_t g;
 
 	glob("/sys/kernel/mm/hugepages/hugepages-*kB", 0, NULL, &g);
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

