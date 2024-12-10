Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B15678289
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796477; cv=none; b=Uoc8mIZmC1MYJe41/dfpKO9ctT2VyHMmkE5ZaZl8i8qTegPrzIGyqBKQAo3llJoLtcUSphDSpY8P0eJj96l9CkRft+ArfrxHdOYjN4Xjes78GxEvPDEXazeZiJ4Mg/lQ5aPlvoLJbQy+V3a9GaWPcYpnToZLzFoUYbHp8O4YPpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796477; c=relaxed/simple;
	bh=y9fF581mzp6FlnJOYiqhOX6Ztuc2Bv3zcffANwf9c78=;
	h=Date:To:From:Subject:Message-Id; b=mLVvryNQimGInCjCLUQ1VNiWSLtM/170LMSajpwGOHFctRbVRdjSGDEIliz9wkLfJJBTzyA3An0gYvrxu5iCZFgwwSrFTN3nnvTAjWN1LvqVfOoUednBxhR5DhUtWsEKLX3zGtYSZBl6tltOsaCFd6iGIvQDsnLN4P1pWE6Fnmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K6tAXuRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K6tAXuRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D0AC4CEDE;
	Tue, 10 Dec 2024 02:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796476;
	bh=y9fF581mzp6FlnJOYiqhOX6Ztuc2Bv3zcffANwf9c78=;
	h=Date:To:From:Subject:From;
	b=K6tAXuRG40UAyTpTTU4O8Cc70m0s+juhFq3M0dWdVZQp2dveKEtDeMu/uaDuf6OaY
	 WMC3yXVwsk1WyY1OExsM7Dk4jXfq3FJpDhNYErxJqEscs0620EeNBQ/65UInxQ2vjG
	 AiW98qQ59M+0LiInD8++K9ZaCnntzcRYrpVOsmaQ=
Date: Mon, 09 Dec 2024 18:07:56 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-unused-pkey-helpers.patch added to mm-unstable branch
Message-Id: <20241210020756.D8D0AC4CEDE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove unused pkey helpers
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-unused-pkey-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-unused-pkey-helpers.patch

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: remove unused pkey helpers
Date: Mon, 9 Dec 2024 09:50:11 +0000

Commit 5f23f6d082a9 ("x86/pkeys: Add self-tests") introduced a
number of helpers and functions that don't seem to have ever been
used. Let's remove them.

Link: https://lkml.kernel.org/r/20241209095019.1732120-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h    |   34 -----------------
 tools/testing/selftests/mm/protection_keys.c |   34 -----------------
 2 files changed, 68 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-remove-unused-pkey-helpers
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -26,9 +26,7 @@
 #ifndef DEBUG_LEVEL
 #define DEBUG_LEVEL 0
 #endif
-#define DPRINT_IN_SIGNAL_BUF_SIZE 4096
 extern int dprint_in_signal;
-extern char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
 extern int test_nr;
 extern int iteration_nr;
@@ -171,38 +169,6 @@ static inline void write_pkey_reg(u64 pk
 			pkey_reg, __read_pkey_reg());
 }
 
-/*
- * These are technically racy. since something could
- * change PKEY register between the read and the write.
- */
-static inline void __pkey_access_allow(int pkey, int do_allow)
-{
-	u64 pkey_reg = read_pkey_reg();
-	int bit = pkey * 2;
-
-	if (do_allow)
-		pkey_reg &= (1<<bit);
-	else
-		pkey_reg |= (1<<bit);
-
-	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
-	write_pkey_reg(pkey_reg);
-}
-
-static inline void __pkey_write_allow(int pkey, int do_allow_write)
-{
-	u64 pkey_reg = read_pkey_reg();
-	int bit = pkey * 2 + 1;
-
-	if (do_allow_write)
-		pkey_reg &= (1<<bit);
-	else
-		pkey_reg |= (1<<bit);
-
-	write_pkey_reg(pkey_reg);
-	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
-}
-
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
 #define ALIGN_PTR_UP(p, ptr_align_to)	\
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-remove-unused-pkey-helpers
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -53,7 +53,6 @@ int test_nr;
 
 u64 shadow_pkey_reg;
 int dprint_in_signal;
-char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
 void cat_into_file(char *str, char *file)
 {
@@ -397,12 +396,6 @@ void signal_handler(int signum, siginfo_
 	dprint_in_signal = 0;
 }
 
-int wait_all_children(void)
-{
-	int status;
-	return waitpid(-1, &status, 0);
-}
-
 void sig_chld(int x)
 {
 	dprint_in_signal = 1;
@@ -817,39 +810,12 @@ void *malloc_pkey_hugetlb(long size, int
 	return ptr;
 }
 
-void *malloc_pkey_mmap_dax(long size, int prot, u16 pkey)
-{
-	void *ptr;
-	int fd;
-
-	dprintf1("doing %s(size=%ld, prot=0x%x, pkey=%d)\n", __func__,
-			size, prot, pkey);
-	pkey_assert(pkey < NR_PKEYS);
-	fd = open("/dax/foo", O_RDWR);
-	pkey_assert(fd >= 0);
-
-	ptr = mmap(0, size, prot, MAP_SHARED, fd, 0);
-	pkey_assert(ptr != (void *)-1);
-
-	mprotect_pkey(ptr, size, prot, pkey);
-
-	record_pkey_malloc(ptr, size, prot);
-
-	dprintf1("mmap()'d for pkey %d @ %p\n", pkey, ptr);
-	close(fd);
-	return ptr;
-}
-
 void *(*pkey_malloc[])(long size, int prot, u16 pkey) = {
 
 	malloc_pkey_with_mprotect,
 	malloc_pkey_with_mprotect_subpage,
 	malloc_pkey_anon_huge,
 	malloc_pkey_hugetlb
-/* can not do direct with the pkey_mprotect() API:
-	malloc_pkey_mmap_direct,
-	malloc_pkey_mmap_dax,
-*/
 };
 
 void *malloc_pkey(long size, int prot, u16 pkey)
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

