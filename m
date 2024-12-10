Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A900136326
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796490; cv=none; b=HG9hpfH9MQB9J5e+ekfVcb6cC6HBalym4MHz1894Pvy+T1rwBnzyv+cpn0qeJcQMPAF91/73m5oeO0B5SxGf7xyT5ai7lvUAMtZK0yHMa+R+/57dqxvgaJrBDJ0xe6/dWz4y+RmFsdirqb8ToNxR+IvHf3oUn752yFVw1nu6IJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796490; c=relaxed/simple;
	bh=fQTxR3tWEZjWWMdyMzHGn2bBPXf9wG0on1wzbkvja1A=;
	h=Date:To:From:Subject:Message-Id; b=qZ3ZSLY+fGqbGtEsquCPNX/QHhEADQ2MWT4cPwBbn9gtm86AcCTYU/RHZp+kisRybt5lVSyCWx8KW6UVlnhnqV7T0M534GLGfhAdFCPeeFiai6cCmdUw7UvTYqDhmxLHWOixqIyACo+ecVl803+dJo/+pX/48Xz3aGJfOFdRVsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bFMjebxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bFMjebxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDA7C4CED1;
	Tue, 10 Dec 2024 02:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796490;
	bh=fQTxR3tWEZjWWMdyMzHGn2bBPXf9wG0on1wzbkvja1A=;
	h=Date:To:From:Subject:From;
	b=bFMjebxUf98G++T7S5+PnP+kwQU5g2BZmxMXy/SWUXCpBpI3qPl/cIZs53CPx92SJ
	 Nt/DHzvsExKEHAP41lxrzhROErxwa1mYGSLnMFqzCEf5zR63hT/1ujbZVAa1PWhWDj
	 X4jdrLPEkM1JAlRlxvqfZXIb/agqdoHa3VH8FVpo=
Date: Mon, 09 Dec 2024 18:08:09 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-sys_pkey-helpers-consistently.patch added to mm-unstable branch
Message-Id: <20241210020810.4DDA7C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use sys_pkey helpers consistently
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-sys_pkey-helpers-consistently.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-sys_pkey-helpers-consistently.patch

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
Subject: selftests/mm: use sys_pkey helpers consistently
Date: Mon, 9 Dec 2024 09:50:16 +0000

sys_pkey_alloc, sys_pkey_free and sys_mprotect_pkey are currently used in
protections_keys.c, while pkey_sighandler_tests.c calls the libc wrappers
directly (e.g.  pkey_mprotect()).  This is probably ok when using glibc
(those symbols appeared a while ago), but Musl does not currently provide
them.  The logging in the helpers from pkey-helpers.h can also come in
handy.

Make things more consistent by using the sys_pkey helpers in
pkey_sighandler_tests.c too.  To that end their implementation is moved to
a common .c file (pkey_util.c).  This also enables calling
is_pkeys_supported() outside of protections_keys.c, since it relies on
sys_pkey_{alloc,free}.

Link: https://lkml.kernel.org/r/20241209095019.1732120-12-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/Makefile                |    4 -
 tools/testing/selftests/mm/pkey-helpers.h          |    2 
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    8 +-
 tools/testing/selftests/mm/pkey_util.c             |   40 +++++++++++
 tools/testing/selftests/mm/protection_keys.c       |   35 ---------
 5 files changed, 48 insertions(+), 41 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-use-sys_pkey-helpers-consistently
+++ a/tools/testing/selftests/mm/Makefile
@@ -146,8 +146,8 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c thp_settings.c
-$(TEST_GEN_FILES): vm_util.c thp_settings.c
+$(TEST_GEN_PROGS): vm_util.c thp_settings.c pkey_util.c
+$(TEST_GEN_FILES): vm_util.c thp_settings.c pkey_util.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-use-sys_pkey-helpers-consistently
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -89,6 +89,8 @@ extern void abort_hooks(void);
 
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
+int sys_mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
+		unsigned long pkey);
 
 /* For functions called from protection_keys.c only */
 noinline int read_ptr(int *ptr);
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-use-sys_pkey-helpers-consistently
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -311,8 +311,8 @@ static void test_sigsegv_handler_with_di
 	__write_pkey_reg(pkey_reg);
 
 	/* Protect the new stack with MPK 1 */
-	pkey = pkey_alloc(0, 0);
-	pkey_mprotect(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
+	pkey = sys_pkey_alloc(0, 0);
+	sys_mprotect_pkey(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
 
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
@@ -484,8 +484,8 @@ static void test_pkru_sigreturn(void)
 	__write_pkey_reg(pkey_reg);
 
 	/* Protect the stack with MPK 2 */
-	pkey = pkey_alloc(0, 0);
-	pkey_mprotect(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
+	pkey = sys_pkey_alloc(0, 0);
+	sys_mprotect_pkey(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
 
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
diff --git a/tools/testing/selftests/mm/pkey_util.c a/tools/testing/selftests/mm/pkey_util.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/pkey_util.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "pkey-helpers.h"
+
+int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
+{
+	int ret = syscall(SYS_pkey_alloc, flags, init_val);
+	dprintf1("%s(flags=%lx, init_val=%lx) syscall ret: %d errno: %d\n",
+			__func__, flags, init_val, ret, errno);
+	return ret;
+}
+
+int sys_pkey_free(unsigned long pkey)
+{
+	int ret = syscall(SYS_pkey_free, pkey);
+	dprintf1("%s(pkey=%ld) syscall ret: %d\n", __func__, pkey, ret);
+	return ret;
+}
+
+int sys_mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
+		unsigned long pkey)
+{
+	int sret;
+
+	dprintf2("%s(0x%p, %zx, prot=%lx, pkey=%lx)\n", __func__,
+			ptr, size, orig_prot, pkey);
+
+	errno = 0;
+	sret = syscall(__NR_pkey_mprotect, ptr, size, orig_prot, pkey);
+	if (errno) {
+		dprintf2("SYS_mprotect_key sret: %d\n", sret);
+		dprintf2("SYS_mprotect_key prot: 0x%lx\n", orig_prot);
+		dprintf2("SYS_mprotect_key failed, errno: %d\n", errno);
+		if (DEBUG_LEVEL >= 2)
+			perror("SYS_mprotect_pkey");
+	}
+	return sret;
+}
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-use-sys_pkey-helpers-consistently
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -460,34 +460,6 @@ static pid_t fork_lazy_child(void)
 	return forkret;
 }
 
-int sys_mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
-		unsigned long pkey)
-{
-	int sret;
-
-	dprintf2("%s(0x%p, %zx, prot=%lx, pkey=%lx)\n", __func__,
-			ptr, size, orig_prot, pkey);
-
-	errno = 0;
-	sret = syscall(__NR_pkey_mprotect, ptr, size, orig_prot, pkey);
-	if (errno) {
-		dprintf2("SYS_mprotect_key sret: %d\n", sret);
-		dprintf2("SYS_mprotect_key prot: 0x%lx\n", orig_prot);
-		dprintf2("SYS_mprotect_key failed, errno: %d\n", errno);
-		if (DEBUG_LEVEL >= 2)
-			perror("SYS_mprotect_pkey");
-	}
-	return sret;
-}
-
-int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
-{
-	int ret = syscall(SYS_pkey_alloc, flags, init_val);
-	dprintf1("%s(flags=%lx, init_val=%lx) syscall ret: %d errno: %d\n",
-			__func__, flags, init_val, ret, errno);
-	return ret;
-}
-
 static int alloc_pkey(void)
 {
 	int ret;
@@ -534,13 +506,6 @@ static int alloc_pkey(void)
 	return ret;
 }
 
-int sys_pkey_free(unsigned long pkey)
-{
-	int ret = syscall(SYS_pkey_free, pkey);
-	dprintf1("%s(pkey=%ld) syscall ret: %d\n", __func__, pkey, ret);
-	return ret;
-}
-
 /*
  * I had a bug where pkey bits could be set by mprotect() but
  * not cleared.  This ensures we get lots of random bit sets
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

