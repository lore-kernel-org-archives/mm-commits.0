From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 114/127] selftests/vm/pkeys: introduce powerpc
 support
Date: Thu, 04 Jun 2020 16:52:15 -0700
Message-ID: <20200604235215.2yVoxTng0%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgFDXwS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:52:18 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linux-mm@kvack.org, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: introduce powerpc support

This makes use of the abstractions added earlier and introduces support
for powerpc.

For powerpc, after receiving the SIGSEGV, the signal handler must
explicitly restore access permissions for the faulting pkey to allow the
test to continue.  As this makes use of pkey_access_allow(), all of its
dependencies and other similar functions have been moved ahead of the
signal handler.

[sandipan@linux.ibm.com: fix powerpc access right updates]
  Link: http://lkml.kernel.org/r/5f65cf37be993760de8112a88da194e3ccbb2bf8.1588959697.git.sandipan@linux.ibm.com
Link: http://lkml.kernel.org/r/b121e9fd33789ed9195276e32fe4e80bb6b88a31.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-helpers.h    |    2 
 tools/testing/selftests/vm/pkey-powerpc.h    |   91 +++++
 tools/testing/selftests/vm/protection_keys.c |  269 ++++++++---------
 3 files changed, 234 insertions(+), 128 deletions(-)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-introduce-powerpc-support
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -79,6 +79,8 @@ void expected_pkey_fault(int pkey);
 
 #if defined(__i386__) || defined(__x86_64__) /* arch */
 #include "pkey-x86.h"
+#elif defined(__powerpc64__) /* arch */
+#include "pkey-powerpc.h"
 #else /* arch */
 #error Architecture not supported
 #endif /* arch */
--- /dev/null
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _PKEYS_POWERPC_H
+#define _PKEYS_POWERPC_H
+
+#ifndef SYS_mprotect_key
+# define SYS_mprotect_key	386
+#endif
+#ifndef SYS_pkey_alloc
+# define SYS_pkey_alloc		384
+# define SYS_pkey_free		385
+#endif
+#define REG_IP_IDX		PT_NIP
+#define REG_TRAPNO		PT_TRAP
+#define gregs			gp_regs
+#define fpregs			fp_regs
+#define si_pkey_offset		0x20
+
+#ifndef PKEY_DISABLE_ACCESS
+# define PKEY_DISABLE_ACCESS	0x3  /* disable read and write */
+#endif
+
+#ifndef PKEY_DISABLE_WRITE
+# define PKEY_DISABLE_WRITE	0x2
+#endif
+
+#define NR_PKEYS		32
+#define NR_RESERVED_PKEYS_4K	27 /* pkey-0, pkey-1, exec-only-pkey
+				      and 24 other keys that cannot be
+				      represented in the PTE */
+#define NR_RESERVED_PKEYS_64K	3  /* pkey-0, pkey-1 and exec-only-pkey */
+#define PKEY_BITS_PER_PKEY	2
+#define HPAGE_SIZE		(1UL << 24)
+#define PAGE_SIZE		(1UL << 16)
+
+static inline u32 pkey_bit_position(int pkey)
+{
+	return (NR_PKEYS - pkey - 1) * PKEY_BITS_PER_PKEY;
+}
+
+static inline u64 __read_pkey_reg(void)
+{
+	u64 pkey_reg;
+
+	asm volatile("mfspr %0, 0xd" : "=r" (pkey_reg));
+
+	return pkey_reg;
+}
+
+static inline void __write_pkey_reg(u64 pkey_reg)
+{
+	u64 amr = pkey_reg;
+
+	dprintf4("%s() changing %016llx to %016llx\n",
+			 __func__, __read_pkey_reg(), pkey_reg);
+
+	asm volatile("isync; mtspr 0xd, %0; isync"
+		     : : "r" ((unsigned long)(amr)) : "memory");
+
+	dprintf4("%s() pkey register after changing %016llx to %016llx\n",
+			__func__, __read_pkey_reg(), pkey_reg);
+}
+
+static inline int cpu_has_pku(void)
+{
+	return 1;
+}
+
+static inline int get_arch_reserved_keys(void)
+{
+	if (sysconf(_SC_PAGESIZE) == 4096)
+		return NR_RESERVED_PKEYS_4K;
+	else
+		return NR_RESERVED_PKEYS_64K;
+}
+
+void expect_fault_on_read_execonly_key(void *p1, int pkey)
+{
+	/*
+	 * powerpc does not allow userspace to change permissions of exec-only
+	 * keys since those keys are not allocated by userspace. The signal
+	 * handler wont be able to reset the permissions, which means the code
+	 * will infinitely continue to segfault here.
+	 */
+	return;
+}
+
+/* 4-byte instructions * 16384 = 64K page */
+#define __page_o_noops() asm(".rept 16384 ; nop; .endr")
+
+#endif /* _PKEYS_POWERPC_H */
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-introduce-powerpc-support
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -169,6 +169,125 @@ void dump_mem(void *dumpme, int len_byte
 	}
 }
 
+static u32 hw_pkey_get(int pkey, unsigned long flags)
+{
+	u64 pkey_reg = __read_pkey_reg();
+
+	dprintf1("%s(pkey=%d, flags=%lx) = %x / %d\n",
+			__func__, pkey, flags, 0, 0);
+	dprintf2("%s() raw pkey_reg: %016llx\n", __func__, pkey_reg);
+
+	return (u32) get_pkey_bits(pkey_reg, pkey);
+}
+
+static int hw_pkey_set(int pkey, unsigned long rights, unsigned long flags)
+{
+	u32 mask = (PKEY_DISABLE_ACCESS|PKEY_DISABLE_WRITE);
+	u64 old_pkey_reg = __read_pkey_reg();
+	u64 new_pkey_reg;
+
+	/* make sure that 'rights' only contains the bits we expect: */
+	assert(!(rights & ~mask));
+
+	/* modify bits accordingly in old pkey_reg and assign it */
+	new_pkey_reg = set_pkey_bits(old_pkey_reg, pkey, rights);
+
+	__write_pkey_reg(new_pkey_reg);
+
+	dprintf3("%s(pkey=%d, rights=%lx, flags=%lx) = %x"
+		" pkey_reg now: %016llx old_pkey_reg: %016llx\n",
+		__func__, pkey, rights, flags, 0, __read_pkey_reg(),
+		old_pkey_reg);
+	return 0;
+}
+
+void pkey_disable_set(int pkey, int flags)
+{
+	unsigned long syscall_flags = 0;
+	int ret;
+	int pkey_rights;
+	u64 orig_pkey_reg = read_pkey_reg();
+
+	dprintf1("START->%s(%d, 0x%x)\n", __func__,
+		pkey, flags);
+	pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
+
+	pkey_rights = hw_pkey_get(pkey, syscall_flags);
+
+	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
+			pkey, pkey, pkey_rights);
+
+	pkey_assert(pkey_rights >= 0);
+
+	pkey_rights |= flags;
+
+	ret = hw_pkey_set(pkey, pkey_rights, syscall_flags);
+	assert(!ret);
+	/* pkey_reg and flags have the same format */
+	shadow_pkey_reg = set_pkey_bits(shadow_pkey_reg, pkey, pkey_rights);
+	dprintf1("%s(%d) shadow: 0x%016llx\n",
+		__func__, pkey, shadow_pkey_reg);
+
+	pkey_assert(ret >= 0);
+
+	pkey_rights = hw_pkey_get(pkey, syscall_flags);
+	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
+			pkey, pkey, pkey_rights);
+
+	dprintf1("%s(%d) pkey_reg: 0x%016llx\n",
+		__func__, pkey, read_pkey_reg());
+	if (flags)
+		pkey_assert(read_pkey_reg() >= orig_pkey_reg);
+	dprintf1("END<---%s(%d, 0x%x)\n", __func__,
+		pkey, flags);
+}
+
+void pkey_disable_clear(int pkey, int flags)
+{
+	unsigned long syscall_flags = 0;
+	int ret;
+	int pkey_rights = hw_pkey_get(pkey, syscall_flags);
+	u64 orig_pkey_reg = read_pkey_reg();
+
+	pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
+
+	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
+			pkey, pkey, pkey_rights);
+	pkey_assert(pkey_rights >= 0);
+
+	pkey_rights &= ~flags;
+
+	ret = hw_pkey_set(pkey, pkey_rights, 0);
+	shadow_pkey_reg = set_pkey_bits(shadow_pkey_reg, pkey, pkey_rights);
+	pkey_assert(ret >= 0);
+
+	pkey_rights = hw_pkey_get(pkey, syscall_flags);
+	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
+			pkey, pkey, pkey_rights);
+
+	dprintf1("%s(%d) pkey_reg: 0x%016llx\n", __func__,
+			pkey, read_pkey_reg());
+	if (flags)
+		assert(read_pkey_reg() <= orig_pkey_reg);
+}
+
+void pkey_write_allow(int pkey)
+{
+	pkey_disable_clear(pkey, PKEY_DISABLE_WRITE);
+}
+void pkey_write_deny(int pkey)
+{
+	pkey_disable_set(pkey, PKEY_DISABLE_WRITE);
+}
+void pkey_access_allow(int pkey)
+{
+	pkey_disable_clear(pkey, PKEY_DISABLE_ACCESS);
+}
+void pkey_access_deny(int pkey)
+{
+	pkey_disable_set(pkey, PKEY_DISABLE_ACCESS);
+}
+
 /* Failed address bound checks: */
 #ifndef SEGV_BNDERR
 # define SEGV_BNDERR		3
@@ -199,11 +318,12 @@ void signal_handler(int signum, siginfo_
 	int trapno;
 	unsigned long ip;
 	char *fpregs;
+#if defined(__i386__) || defined(__x86_64__) /* arch */
 	u32 *pkey_reg_ptr;
+	int pkey_reg_offset;
+#endif /* arch */
 	u64 siginfo_pkey;
 	u32 *si_pkey_ptr;
-	int pkey_reg_offset;
-	fpregset_t fpregset;
 
 	dprint_in_signal = 1;
 	dprintf1(">>>>===============SIGSEGV============================\n");
@@ -213,12 +333,13 @@ void signal_handler(int signum, siginfo_
 
 	trapno = uctxt->uc_mcontext.gregs[REG_TRAPNO];
 	ip = uctxt->uc_mcontext.gregs[REG_IP_IDX];
-	fpregset = uctxt->uc_mcontext.fpregs;
-	fpregs = (void *)fpregset;
+	fpregs = (char *) uctxt->uc_mcontext.fpregs;
 
 	dprintf2("%s() trapno: %d ip: 0x%016lx info->si_code: %s/%d\n",
 			__func__, trapno, ip, si_code_str(si->si_code),
 			si->si_code);
+
+#if defined(__i386__) || defined(__x86_64__) /* arch */
 #ifdef __i386__
 	/*
 	 * 32-bit has some extra padding so that userspace can tell whether
@@ -226,12 +347,10 @@ void signal_handler(int signum, siginfo_
 	 * state.  We just assume that it is here.
 	 */
 	fpregs += 0x70;
-#endif
+#endif /* i386 */
 	pkey_reg_offset = pkey_reg_xstate_offset();
 	pkey_reg_ptr = (void *)(&fpregs[pkey_reg_offset]);
 
-	dprintf1("siginfo: %p\n", si);
-	dprintf1(" fpregs: %p\n", fpregs);
 	/*
 	 * If we got a PKEY fault, we *HAVE* to have at least one bit set in
 	 * here.
@@ -240,6 +359,10 @@ void signal_handler(int signum, siginfo_
 	if (DEBUG_LEVEL > 4)
 		dump_mem(pkey_reg_ptr - 128, 256);
 	pkey_assert(*pkey_reg_ptr);
+#endif /* arch */
+
+	dprintf1("siginfo: %p\n", si);
+	dprintf1(" fpregs: %p\n", fpregs);
 
 	if ((si->si_code == SEGV_MAPERR) ||
 	    (si->si_code == SEGV_ACCERR) ||
@@ -248,14 +371,13 @@ void signal_handler(int signum, siginfo_
 		exit(4);
 	}
 
-	si_pkey_ptr = (u32 *)(((u8 *)si) + si_pkey_offset);
+	si_pkey_ptr = siginfo_get_pkey_ptr(si);
 	dprintf1("si_pkey_ptr: %p\n", si_pkey_ptr);
 	dump_mem((u8 *)si_pkey_ptr - 8, 24);
 	siginfo_pkey = *si_pkey_ptr;
 	pkey_assert(siginfo_pkey < NR_PKEYS);
 	last_si_pkey = siginfo_pkey;
 
-	dprintf1("signal pkey_reg from xsave: %08x\n", *pkey_reg_ptr);
 	/*
 	 * need __read_pkey_reg() version so we do not do shadow_pkey_reg
 	 * checking
@@ -263,8 +385,14 @@ void signal_handler(int signum, siginfo_
 	dprintf1("signal pkey_reg from  pkey_reg: %016llx\n",
 			__read_pkey_reg());
 	dprintf1("pkey from siginfo: %016llx\n", siginfo_pkey);
+#if defined(__i386__) || defined(__x86_64__) /* arch */
+	dprintf1("signal pkey_reg from xsave: %08x\n", *pkey_reg_ptr);
 	*(u64 *)pkey_reg_ptr = 0x00000000;
 	dprintf1("WARNING: set PKEY_REG=0 to allow faulting instruction to continue\n");
+#elif defined(__powerpc64__) /* arch */
+	/* restore access and let the faulting instruction continue */
+	pkey_access_allow(siginfo_pkey);
+#endif /* arch */
 	pkey_faults++;
 	dprintf1("<<<<==================================================\n");
 	dprint_in_signal = 0;
@@ -333,125 +461,6 @@ pid_t fork_lazy_child(void)
 	return forkret;
 }
 
-static u32 hw_pkey_get(int pkey, unsigned long flags)
-{
-	u64 pkey_reg = __read_pkey_reg();
-
-	dprintf1("%s(pkey=%d, flags=%lx) = %x / %d\n",
-			__func__, pkey, flags, 0, 0);
-	dprintf2("%s() raw pkey_reg: %016llx\n", __func__, pkey_reg);
-
-	return (u32) get_pkey_bits(pkey_reg, pkey);
-}
-
-static int hw_pkey_set(int pkey, unsigned long rights, unsigned long flags)
-{
-	u32 mask = (PKEY_DISABLE_ACCESS|PKEY_DISABLE_WRITE);
-	u64 old_pkey_reg = __read_pkey_reg();
-	u64 new_pkey_reg;
-
-	/* make sure that 'rights' only contains the bits we expect: */
-	assert(!(rights & ~mask));
-
-	/* modify bits accordingly in old pkey_reg and assign it */
-	new_pkey_reg = set_pkey_bits(old_pkey_reg, pkey, rights);
-
-	__write_pkey_reg(new_pkey_reg);
-
-	dprintf3("%s(pkey=%d, rights=%lx, flags=%lx) = %x"
-		" pkey_reg now: %016llx old_pkey_reg: %016llx\n",
-		__func__, pkey, rights, flags, 0, __read_pkey_reg(),
-		old_pkey_reg);
-	return 0;
-}
-
-void pkey_disable_set(int pkey, int flags)
-{
-	unsigned long syscall_flags = 0;
-	int ret;
-	int pkey_rights;
-	u64 orig_pkey_reg = read_pkey_reg();
-
-	dprintf1("START->%s(%d, 0x%x)\n", __func__,
-		pkey, flags);
-	pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
-
-	pkey_rights = hw_pkey_get(pkey, syscall_flags);
-
-	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
-			pkey, pkey, pkey_rights);
-
-	pkey_assert(pkey_rights >= 0);
-
-	pkey_rights |= flags;
-
-	ret = hw_pkey_set(pkey, pkey_rights, syscall_flags);
-	assert(!ret);
-	/* pkey_reg and flags have the same format */
-	shadow_pkey_reg = set_pkey_bits(shadow_pkey_reg, pkey, pkey_rights);
-	dprintf1("%s(%d) shadow: 0x%016llx\n",
-		__func__, pkey, shadow_pkey_reg);
-
-	pkey_assert(ret >= 0);
-
-	pkey_rights = hw_pkey_get(pkey, syscall_flags);
-	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
-			pkey, pkey, pkey_rights);
-
-	dprintf1("%s(%d) pkey_reg: 0x%016llx\n",
-		__func__, pkey, read_pkey_reg());
-	if (flags)
-		pkey_assert(read_pkey_reg() >= orig_pkey_reg);
-	dprintf1("END<---%s(%d, 0x%x)\n", __func__,
-		pkey, flags);
-}
-
-void pkey_disable_clear(int pkey, int flags)
-{
-	unsigned long syscall_flags = 0;
-	int ret;
-	int pkey_rights = hw_pkey_get(pkey, syscall_flags);
-	u64 orig_pkey_reg = read_pkey_reg();
-
-	pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
-
-	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
-			pkey, pkey, pkey_rights);
-	pkey_assert(pkey_rights >= 0);
-
-	pkey_rights &= ~flags;
-
-	ret = hw_pkey_set(pkey, pkey_rights, 0);
-	shadow_pkey_reg = set_pkey_bits(shadow_pkey_reg, pkey, pkey_rights);
-	pkey_assert(ret >= 0);
-
-	pkey_rights = hw_pkey_get(pkey, syscall_flags);
-	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
-			pkey, pkey, pkey_rights);
-
-	dprintf1("%s(%d) pkey_reg: 0x%016llx\n", __func__,
-			pkey, read_pkey_reg());
-	if (flags)
-		assert(read_pkey_reg() <= orig_pkey_reg);
-}
-
-void pkey_write_allow(int pkey)
-{
-	pkey_disable_clear(pkey, PKEY_DISABLE_WRITE);
-}
-void pkey_write_deny(int pkey)
-{
-	pkey_disable_set(pkey, PKEY_DISABLE_WRITE);
-}
-void pkey_access_allow(int pkey)
-{
-	pkey_disable_clear(pkey, PKEY_DISABLE_ACCESS);
-}
-void pkey_access_deny(int pkey)
-{
-	pkey_disable_set(pkey, PKEY_DISABLE_ACCESS);
-}
