From: akpm@linux-foundation.org
Subject: +
 selftests-vm-pkeys-use-sane-types-for-pkey-register.patch added to -mm tree
Date: Fri, 17 Apr 2020 16:30:23 -0700
Message-ID: <20200417233023.YrsZnWIpr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXa1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests: vm: pkeys: Use sane types for pkey register
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-use-sane-types-for-pkey-register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-use-sane-types-for-pkey-register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sandipan Das <sandipan@linux.ibm.com>
Subject: selftests: vm: pkeys: Use sane types for pkey register

The size of the pkey register can vary across architectures.  This
converts the data type of all its references to u64 in preparation for
multi-arch support.

To keep the definition of the u64 type consistent and remove format
specifier related warnings, __SANE_USERSPACE_TYPES__ is defined as
suggested by Michael Ellerman.

Link: http://lkml.kernel.org/r/d3e271798455d940e395e56e1ff1e82a31bcb7aa.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-helpers.h    |   31 +++---
 tools/testing/selftests/vm/pkey-x86.h        |    8 -
 tools/testing/selftests/vm/protection_keys.c |   86 ++++++++++-------
 3 files changed, 72 insertions(+), 53 deletions(-)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-use-sane-types-for-pkey-register
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -14,10 +14,10 @@
 #include <sys/mman.h>
 
 /* Define some kernel-like types */
-#define  u8 uint8_t
-#define u16 uint16_t
-#define u32 uint32_t
-#define u64 uint64_t
+#define  u8 __u8
+#define u16 __u16
+#define u32 __u32
+#define u64 __u64
 
 #define PTR_ERR_ENOTSUP ((void *)-ENOTSUP)
 
@@ -80,13 +80,14 @@ extern void abort_hooks(void);
 #error Architecture not supported
 #endif /* arch */
 
-extern unsigned int shadow_pkey_reg;
+extern u64 shadow_pkey_reg;
 
-static inline unsigned int _read_pkey_reg(int line)
+static inline u64 _read_pkey_reg(int line)
 {
-	unsigned int pkey_reg = __read_pkey_reg();
+	u64 pkey_reg = __read_pkey_reg();
 
-	dprintf4("read_pkey_reg(line=%d) pkey_reg: %x shadow: %x\n",
+	dprintf4("read_pkey_reg(line=%d) pkey_reg: %016llx"
+			" shadow: %016llx\n",
 			line, pkey_reg, shadow_pkey_reg);
 	assert(pkey_reg == shadow_pkey_reg);
 
@@ -95,15 +96,15 @@ static inline unsigned int _read_pkey_re
 
 #define read_pkey_reg() _read_pkey_reg(__LINE__)
 
-static inline void write_pkey_reg(unsigned int pkey_reg)
+static inline void write_pkey_reg(u64 pkey_reg)
 {
-	dprintf4("%s() changing %08x to %08x\n", __func__,
+	dprintf4("%s() changing %016llx to %016llx\n", __func__,
 			__read_pkey_reg(), pkey_reg);
 	/* will do the shadow check for us: */
 	read_pkey_reg();
 	__write_pkey_reg(pkey_reg);
 	shadow_pkey_reg = pkey_reg;
-	dprintf4("%s(%08x) pkey_reg: %08x\n", __func__,
+	dprintf4("%s(%016llx) pkey_reg: %016llx\n", __func__,
 			pkey_reg, __read_pkey_reg());
 }
 
@@ -113,7 +114,7 @@ static inline void write_pkey_reg(unsign
  */
 static inline void __pkey_access_allow(int pkey, int do_allow)
 {
-	unsigned int pkey_reg = read_pkey_reg();
+	u64 pkey_reg = read_pkey_reg();
 	int bit = pkey * 2;
 
 	if (do_allow)
@@ -121,13 +122,13 @@ static inline void __pkey_access_allow(i
 	else
 		pkey_reg |= (1<<bit);
 
-	dprintf4("pkey_reg now: %08x\n", read_pkey_reg());
+	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
 	write_pkey_reg(pkey_reg);
 }
 
 static inline void __pkey_write_allow(int pkey, int do_allow_write)
 {
-	long pkey_reg = read_pkey_reg();
+	u64 pkey_reg = read_pkey_reg();
 	int bit = pkey * 2 + 1;
 
 	if (do_allow_write)
@@ -136,7 +137,7 @@ static inline void __pkey_write_allow(in
 		pkey_reg |= (1<<bit);
 
 	write_pkey_reg(pkey_reg);
-	dprintf4("pkey_reg now: %08x\n", read_pkey_reg());
+	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
 }
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
--- a/tools/testing/selftests/vm/pkey-x86.h~selftests-vm-pkeys-use-sane-types-for-pkey-register
+++ a/tools/testing/selftests/vm/pkey-x86.h
@@ -53,11 +53,11 @@ static inline void __page_o_noops(void)
 	asm(".rept 512 ; nopl 0x7eeeeeee(%eax) ; .endr");
 }
 
-static inline unsigned int __read_pkey_reg(void)
+static inline u64 __read_pkey_reg(void)
 {
 	unsigned int eax, edx;
 	unsigned int ecx = 0;
-	unsigned int pkey_reg;
+	unsigned pkey_reg;
 
 	asm volatile(".byte 0x0f,0x01,0xee\n\t"
 		     : "=a" (eax), "=d" (edx)
@@ -66,13 +66,13 @@ static inline unsigned int __read_pkey_r
 	return pkey_reg;
 }
 
-static inline void __write_pkey_reg(unsigned int pkey_reg)
+static inline void __write_pkey_reg(u64 pkey_reg)
 {
 	unsigned int eax = pkey_reg;
 	unsigned int ecx = 0;
 	unsigned int edx = 0;
 
-	dprintf4("%s() changing %08x to %08x\n", __func__,
+	dprintf4("%s() changing %016llx to %016llx\n", __func__,
 			__read_pkey_reg(), pkey_reg);
 	asm volatile(".byte 0x0f,0x01,0xef\n\t"
 		     : : "a" (eax), "c" (ecx), "d" (edx));
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-use-sane-types-for-pkey-register
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -22,6 +22,7 @@
  *	gcc -m32 -o protection_keys_32 -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
  */
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__
 #include <errno.h>
 #include <linux/futex.h>
 #include <sys/time.h>
@@ -48,7 +49,7 @@
 int iteration_nr = 1;
 int test_nr;
 
-unsigned int shadow_pkey_reg;
+u64 shadow_pkey_reg;
 int dprint_in_signal;
 char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
@@ -163,7 +164,7 @@ void dump_mem(void *dumpme, int len_byte
 
 	for (i = 0; i < len_bytes; i += sizeof(u64)) {
 		u64 *ptr = (u64 *)(c + i);
-		dprintf1("dump[%03d][@%p]: %016jx\n", i, ptr, *ptr);
+		dprintf1("dump[%03d][@%p]: %016llx\n", i, ptr, *ptr);
 	}
 }
 
@@ -205,7 +206,8 @@ void signal_handler(int signum, siginfo_
 
 	dprint_in_signal = 1;
 	dprintf1(">>>>===============SIGSEGV============================\n");
-	dprintf1("%s()::%d, pkey_reg: 0x%x shadow: %x\n", __func__, __LINE__,
+	dprintf1("%s()::%d, pkey_reg: 0x%016llx shadow: %016llx\n",
+			__func__, __LINE__,
 			__read_pkey_reg(), shadow_pkey_reg);
 
 	trapno = uctxt->uc_mcontext.gregs[REG_TRAPNO];
@@ -213,8 +215,9 @@ void signal_handler(int signum, siginfo_
 	fpregset = uctxt->uc_mcontext.fpregs;
 	fpregs = (void *)fpregset;
 
-	dprintf2("%s() trapno: %d ip: 0x%lx info->si_code: %s/%d\n", __func__,
-			trapno, ip, si_code_str(si->si_code), si->si_code);
+	dprintf2("%s() trapno: %d ip: 0x%016lx info->si_code: %s/%d\n",
+			__func__, trapno, ip, si_code_str(si->si_code),
+			si->si_code);
 #ifdef __i386__
 	/*
 	 * 32-bit has some extra padding so that userspace can tell whether
@@ -256,8 +259,9 @@ void signal_handler(int signum, siginfo_
 	 * need __read_pkey_reg() version so we do not do shadow_pkey_reg
 	 * checking
 	 */
-	dprintf1("signal pkey_reg from  pkey_reg: %08x\n", __read_pkey_reg());
-	dprintf1("pkey from siginfo: %jx\n", siginfo_pkey);
+	dprintf1("signal pkey_reg from  pkey_reg: %016llx\n",
+			__read_pkey_reg());
+	dprintf1("pkey from siginfo: %016llx\n", siginfo_pkey);
 	*(u64 *)pkey_reg_ptr = 0x00000000;
 	dprintf1("WARNING: set PKEY_REG=0 to allow faulting instruction to continue\n");
 	pkey_faults++;
@@ -331,16 +335,17 @@ pid_t fork_lazy_child(void)
 static u32 hw_pkey_get(int pkey, unsigned long flags)
 {
 	u32 mask = (PKEY_DISABLE_ACCESS|PKEY_DISABLE_WRITE);
-	u32 pkey_reg = __read_pkey_reg();
-	u32 shifted_pkey_reg;
+	u64 pkey_reg = __read_pkey_reg();
+	u64 shifted_pkey_reg;
 	u32 masked_pkey_reg;
 
 	dprintf1("%s(pkey=%d, flags=%lx) = %x / %d\n",
 			__func__, pkey, flags, 0, 0);
-	dprintf2("%s() raw pkey_reg: %x\n", __func__, pkey_reg);
+	dprintf2("%s() raw pkey_reg: %016llx\n", __func__, pkey_reg);
 
 	shifted_pkey_reg = (pkey_reg >> (pkey * PKEY_BITS_PER_PKEY));
-	dprintf2("%s() shifted_pkey_reg: %x\n", __func__, shifted_pkey_reg);
+	dprintf2("%s() shifted_pkey_reg: %016llx\n", __func__,
+			shifted_pkey_reg);
 	masked_pkey_reg = shifted_pkey_reg & mask;
 	dprintf2("%s() masked  pkey_reg: %x\n", __func__, masked_pkey_reg);
 	/*
@@ -353,8 +358,8 @@ static u32 hw_pkey_get(int pkey, unsigne
 static int hw_pkey_set(int pkey, unsigned long rights, unsigned long flags)
 {
 	u32 mask = (PKEY_DISABLE_ACCESS|PKEY_DISABLE_WRITE);
-	u32 old_pkey_reg = __read_pkey_reg();
-	u32 new_pkey_reg;
+	u64 old_pkey_reg = __read_pkey_reg();
+	u64 new_pkey_reg;
 
 	/* make sure that 'rights' only contains the bits we expect: */
 	assert(!(rights & ~mask));
@@ -369,7 +374,7 @@ static int hw_pkey_set(int pkey, unsigne
 	__write_pkey_reg(new_pkey_reg);
 
 	dprintf3("%s(pkey=%d, rights=%lx, flags=%lx) = %x"
-		" pkey_reg now: %x old_pkey_reg: %x\n",
+		" pkey_reg now: %016llx old_pkey_reg: %016llx\n",
 		__func__, pkey, rights, flags, 0, __read_pkey_reg(),
 		old_pkey_reg);
 	return 0;
@@ -380,7 +385,7 @@ void pkey_disable_set(int pkey, int flag
 	unsigned long syscall_flags = 0;
 	int ret;
 	int pkey_rights;
-	u32 orig_pkey_reg = read_pkey_reg();
+	u64 orig_pkey_reg = read_pkey_reg();
 
 	dprintf1("START->%s(%d, 0x%x)\n", __func__,
 		pkey, flags);
@@ -390,6 +395,7 @@ void pkey_disable_set(int pkey, int flag
 
 	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
 			pkey, pkey, pkey_rights);
+
 	pkey_assert(pkey_rights >= 0);
 
 	pkey_rights |= flags;
@@ -398,7 +404,8 @@ void pkey_disable_set(int pkey, int flag
 	assert(!ret);
 	/* pkey_reg and flags have the same format */
 	shadow_pkey_reg |= flags << (pkey * 2);
-	dprintf1("%s(%d) shadow: 0x%x\n", __func__, pkey, shadow_pkey_reg);
+	dprintf1("%s(%d) shadow: 0x%016llx\n",
+		__func__, pkey, shadow_pkey_reg);
 
 	pkey_assert(ret >= 0);
 
@@ -406,7 +413,8 @@ void pkey_disable_set(int pkey, int flag
 	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
 			pkey, pkey, pkey_rights);
 
-	dprintf1("%s(%d) pkey_reg: 0x%x\n", __func__, pkey, read_pkey_reg());
+	dprintf1("%s(%d) pkey_reg: 0x%016llx\n",
+		__func__, pkey, read_pkey_reg());
 	if (flags)
 		pkey_assert(read_pkey_reg() > orig_pkey_reg);
 	dprintf1("END<---%s(%d, 0x%x)\n", __func__,
@@ -418,7 +426,7 @@ void pkey_disable_clear(int pkey, int fl
 	unsigned long syscall_flags = 0;
 	int ret;
 	int pkey_rights = hw_pkey_get(pkey, syscall_flags);
-	u32 orig_pkey_reg = read_pkey_reg();
+	u64 orig_pkey_reg = read_pkey_reg();
 
 	pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
 
@@ -436,7 +444,8 @@ void pkey_disable_clear(int pkey, int fl
 	dprintf1("%s(%d) hw_pkey_get(%d): %x\n", __func__,
 			pkey, pkey, pkey_rights);
 
-	dprintf1("%s(%d) pkey_reg: 0x%x\n", __func__, pkey, read_pkey_reg());
+	dprintf1("%s(%d) pkey_reg: 0x%016llx\n", __func__,
+			pkey, read_pkey_reg());
 	if (flags)
 		assert(read_pkey_reg() > orig_pkey_reg);
 }
@@ -491,20 +500,22 @@ int alloc_pkey(void)
 	int ret;
 	unsigned long init_val = 0x0;
 
-	dprintf1("%s()::%d, pkey_reg: 0x%x shadow: %x\n", __func__,
-			__LINE__, __read_pkey_reg(), shadow_pkey_reg);
+	dprintf1("%s()::%d, pkey_reg: 0x%016llx shadow: %016llx\n",
+			__func__, __LINE__, __read_pkey_reg(), shadow_pkey_reg);
 	ret = sys_pkey_alloc(0, init_val);
 	/*
 	 * pkey_alloc() sets PKEY register, so we need to reflect it in
 	 * shadow_pkey_reg:
 	 */
-	dprintf4("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n",
+	dprintf4("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+			" shadow: 0x%016llx\n",
 			__func__, __LINE__, ret, __read_pkey_reg(),
 			shadow_pkey_reg);
 	if (ret) {
 		/* clear both the bits: */
 		shadow_pkey_reg &= ~(0x3      << (ret * 2));
-		dprintf4("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n",
+		dprintf4("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+				" shadow: 0x%016llx\n",
 				__func__,
 				__LINE__, ret, __read_pkey_reg(),
 				shadow_pkey_reg);
@@ -514,13 +525,15 @@ int alloc_pkey(void)
 		 */
 		shadow_pkey_reg |=  (init_val << (ret * 2));
 	}
-	dprintf4("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n",
+	dprintf4("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+			" shadow: 0x%016llx\n",
 			__func__, __LINE__, ret, __read_pkey_reg(),
 			shadow_pkey_reg);
 	dprintf1("%s()::%d errno: %d\n", __func__, __LINE__, errno);
 	/* for shadow checking: */
 	read_pkey_reg();
-	dprintf4("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n",
+	dprintf4("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+		 " shadow: 0x%016llx\n",
 		__func__, __LINE__, ret, __read_pkey_reg(),
 		shadow_pkey_reg);
 	return ret;
@@ -573,7 +586,8 @@ int alloc_random_pkey(void)
 		free_ret = sys_pkey_free(alloced_pkeys[i]);
 		pkey_assert(!free_ret);
 	}
-	dprintf1("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n", __func__,
+	dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+			 " shadow: 0x%016llx\n", __func__,
 			__LINE__, ret, __read_pkey_reg(), shadow_pkey_reg);
 	return ret;
 }
@@ -592,11 +606,13 @@ int mprotect_pkey(void *ptr, size_t size
 		if (nr_iterations-- < 0)
 			break;
 
-		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n",
+		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+			" shadow: 0x%016llx\n",
 			__func__, __LINE__, ret, __read_pkey_reg(),
 			shadow_pkey_reg);
 		sys_pkey_free(rpkey);
-		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n",
+		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+			" shadow: 0x%016llx\n",
 			__func__, __LINE__, ret, __read_pkey_reg(),
 			shadow_pkey_reg);
 	}
@@ -606,7 +622,8 @@ int mprotect_pkey(void *ptr, size_t size
 	dprintf1("mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
 			ptr, size, orig_prot, pkey, ret);
 	pkey_assert(!ret);
-	dprintf1("%s()::%d, ret: %d pkey_reg: 0x%x shadow: 0x%x\n", __func__,
+	dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
+			" shadow: 0x%016llx\n", __func__,
 			__LINE__, ret, __read_pkey_reg(), shadow_pkey_reg);
 	return ret;
 }
@@ -885,7 +902,7 @@ void expected_pkey_fault(int pkey)
 		pkey_assert(0);
 
 	__write_pkey_reg(shadow_pkey_reg);
-	dprintf1("%s() set pkey_reg=%x to restore state after signal "
+	dprintf1("%s() set pkey_reg=%016llx to restore state after signal "
 		       "nuked it\n", __func__, shadow_pkey_reg);
 	last_pkey_faults = pkey_faults;
 	last_si_pkey = -1;
@@ -1097,7 +1114,8 @@ void test_pkey_alloc_exhaust(int *ptr, u
 		int new_pkey;
 		dprintf1("%s() alloc loop: %d\n", __func__, i);
 		new_pkey = alloc_pkey();
-		dprintf4("%s()::%d, err: %d pkey_reg: 0x%x shadow: 0x%x\n",
+		dprintf4("%s()::%d, err: %d pkey_reg: 0x%016llx"
+				" shadow: 0x%016llx\n",
 				__func__, __LINE__, err, __read_pkey_reg(),
 				shadow_pkey_reg);
 		read_pkey_reg(); /* for shadow checking */
@@ -1285,7 +1303,7 @@ void test_executing_on_unreadable_memory
 	pkey_assert(!ret);
 	pkey_access_deny(pkey);
 
-	dprintf2("pkey_reg: %x\n", read_pkey_reg());
+	dprintf2("pkey_reg: %016llx\n", read_pkey_reg());
 
 	/*
 	 * Make sure this is an *instruction* fault
@@ -1316,7 +1334,7 @@ void test_implicit_mprotect_exec_only_me
 	ret = mprotect(p1, PAGE_SIZE, PROT_EXEC);
 	pkey_assert(!ret);
 
-	dprintf2("pkru: %x\n", read_pkey_reg());
+	dprintf2("pkey_reg: %016llx\n", read_pkey_reg());
 
 	/* Make sure this is an *instruction* fault */
 	madvise(p1, PAGE_SIZE, MADV_DONTNEED);
@@ -1433,7 +1451,7 @@ int main(void)
 	}
 
 	pkey_setup_shadow();
-	printf("startup pkey_reg: %x\n", read_pkey_reg());
+	printf("startup pkey_reg: %016llx\n", read_pkey_reg());
 	setup_hugetlbfs();
 
 	while (nr_iterations-- > 0)
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch
