Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A2D28E37
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796481; cv=none; b=jgT0a3bt85ALq6Iy7PuqxphG/0ALx4tZBY9fezZgBEKII1k7+w5poTc7OocwDymTKlZcmG/qvHs3tWrNmmgSieX2kyEhZ/Km/Ks3c4spq34rpYAEoFjfkaG0VrhT154FL3gEXa7HmzpLyfzorv+saMXTvjKYIFOOzW/ONRy1wjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796481; c=relaxed/simple;
	bh=ee+3Zx6jooMt5t2S26sfmWLHI3W7cXsoPfFvXD+RBeE=;
	h=Date:To:From:Subject:Message-Id; b=ZEYYRji1moJbLdu+KR/0PnOlRPzu4W8ASMLxwyoJ1EF5uJxB5IevLM424pYuyUGYS6uxofX7QJmG2dLrbRwJpJZ5h0nMK1UTNtc5xnfHGVVvBgNRSdZc32OjV0vX51Hv223/4aZG1Auffm+YAsZzXw0rgY5UMyrWVEsAbpQGLzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3jU33hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3jU33hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34604C4CED1;
	Tue, 10 Dec 2024 02:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796481;
	bh=ee+3Zx6jooMt5t2S26sfmWLHI3W7cXsoPfFvXD+RBeE=;
	h=Date:To:From:Subject:From;
	b=t3jU33hjaNQGBiBsp0Z6Ud0ctKFib5TaLTV7y8Ka4FdfnQGEN3wuX/fQxR58pK4/1
	 R0xCcF8IRT6qn3U3zv9tRjWD6xUeHa2w6qvIToUl9yHSwEovTIrE3CcuYo9xJVCFUJ
	 H4WdkeCIWwSYgKbJ+HZp3wJLVygHt3oyixDKFwVA=
Date: Mon, 09 Dec 2024 18:08:00 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-ensure-pkey-h-define-inline-functions-only.patch added to mm-unstable branch
Message-Id: <20241210020801.34604C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: ensure pkey-*.h define inline functions only
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-ensure-pkey-h-define-inline-functions-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-ensure-pkey-h-define-inline-functions-only.patch

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
Subject: selftests/mm: ensure pkey-*.h define inline functions only
Date: Mon, 9 Dec 2024 09:50:13 +0000

Headers should not define non-inline functions, as this prevents them from
being included more than once in a given program.  pkey-helpers.h and the
arch-specific headers it includes currently define multiple such
non-inline functions.

In most cases those functions can simply be made inline - this patch does
just that.  read_ptr() is an exception as it must not be inlined.  Since
it is only called from protection_keys.c, we just move it there.

Link: https://lkml.kernel.org/r/20241209095019.1732120-9-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey-arm64.h      |    4 ++--
 tools/testing/selftests/mm/pkey-helpers.h    |    8 +-------
 tools/testing/selftests/mm/pkey-powerpc.h    |    4 ++--
 tools/testing/selftests/mm/pkey-x86.h        |    6 +++---
 tools/testing/selftests/mm/protection_keys.c |    7 +++++++
 5 files changed, 15 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/pkey-arm64.h~selftests-mm-ensure-pkey-h-define-inline-functions-only
+++ a/tools/testing/selftests/mm/pkey-arm64.h
@@ -81,11 +81,11 @@ static inline int get_arch_reserved_keys
 	return NR_RESERVED_PKEYS;
 }
 
-void expect_fault_on_read_execonly_key(void *p1, int pkey)
+static inline void expect_fault_on_read_execonly_key(void *p1, int pkey)
 {
 }
 
-void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
 {
 	return PTR_ERR_ENOTSUP;
 }
--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-ensure-pkey-h-define-inline-functions-only
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -84,13 +84,7 @@ extern void abort_hooks(void);
 # define noinline __attribute__((noinline))
 #endif
 
-noinline int read_ptr(int *ptr)
-{
-	/* Keep GCC from optimizing this away somehow */
-	barrier();
-	return *ptr;
-}
-
+noinline int read_ptr(int *ptr);
 void expected_pkey_fault(int pkey);
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
--- a/tools/testing/selftests/mm/pkey-powerpc.h~selftests-mm-ensure-pkey-h-define-inline-functions-only
+++ a/tools/testing/selftests/mm/pkey-powerpc.h
@@ -91,7 +91,7 @@ static inline int get_arch_reserved_keys
 			return NR_RESERVED_PKEYS_64K_3KEYS;
 }
 
-void expect_fault_on_read_execonly_key(void *p1, int pkey)
+static inline void expect_fault_on_read_execonly_key(void *p1, int pkey)
 {
 	/*
 	 * powerpc does not allow userspace to change permissions of exec-only
@@ -105,7 +105,7 @@ void expect_fault_on_read_execonly_key(v
 /* 4-byte instructions * 16384 = 64K page */
 #define __page_o_noops() asm(".rept 16384 ; nop; .endr")
 
-void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
 {
 	void *ptr;
 	int ret;
--- a/tools/testing/selftests/mm/pkey-x86.h~selftests-mm-ensure-pkey-h-define-inline-functions-only
+++ a/tools/testing/selftests/mm/pkey-x86.h
@@ -113,7 +113,7 @@ static inline u32 pkey_bit_position(int
 #define XSTATE_PKEY	0x200
 #define XSTATE_BV_OFFSET	512
 
-int pkey_reg_xstate_offset(void)
+static inline int pkey_reg_xstate_offset(void)
 {
 	unsigned int eax;
 	unsigned int ebx;
@@ -148,7 +148,7 @@ static inline int get_arch_reserved_keys
 	return NR_RESERVED_PKEYS;
 }
 
-void expect_fault_on_read_execonly_key(void *p1, int pkey)
+static inline void expect_fault_on_read_execonly_key(void *p1, int pkey)
 {
 	int ptr_contents;
 
@@ -157,7 +157,7 @@ void expect_fault_on_read_execonly_key(v
 	expected_pkey_fault(pkey);
 }
 
-void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
 {
 	return PTR_ERR_ENOTSUP;
 }
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-ensure-pkey-h-define-inline-functions-only
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -54,6 +54,13 @@ int test_nr;
 u64 shadow_pkey_reg;
 int dprint_in_signal;
 
+noinline int read_ptr(int *ptr)
+{
+	/* Keep GCC from optimizing this away somehow */
+	barrier();
+	return *ptr;
+}
+
 void cat_into_file(char *str, char *file)
 {
 	int fd = open(file, O_RDWR);
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

