From: akpm@linux-foundation.org
Subject: +
 selftests-vm-pkeys-move-some-definitions-to-arch-specific-header.patch
 added to -mm tree
Date: Fri, 17 Apr 2020 16:30:17 -0700
Message-ID: <20200417233017.TV1Y8txe-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: move some definitions to arch-specific header
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-move-some-definitions-to-arch-specific-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-move-some-definitions-to-arch-specific-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-move-some-definitions-to-arch-specific-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: selftests/vm/pkeys: move some definitions to arch-specific header

In preparation for multi-arch support, move definitions which
have arch-specific values to x86-specific header.

Link: http://lkml.kernel.org/r/d58eba2930059c8b209eefd6d5b48fe922a5b010.1585646528.git.sandipan@linux.ibm.com
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-helpers.h    |  111 ------------
 tools/testing/selftests/vm/pkey-x86.h        |  156 +++++++++++++++++
 tools/testing/selftests/vm/protection_keys.c |   47 -----
 3 files changed, 162 insertions(+), 152 deletions(-)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-move-some-definitions-to-arch-specific-header
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -21,9 +21,6 @@
 
 #define PTR_ERR_ENOTSUP ((void *)-ENOTSUP)
 
-#define NR_PKEYS 16
-#define PKEY_BITS_PER_PKEY 2
-
 #ifndef DEBUG_LEVEL
 #define DEBUG_LEVEL 0
 #endif
@@ -73,19 +70,13 @@ extern void abort_hooks(void);
 	}					\
 } while (0)
 
+#if defined(__i386__) || defined(__x86_64__) /* arch */
+#include "pkey-x86.h"
+#else /* arch */
+#error Architecture not supported
+#endif /* arch */
+
 extern unsigned int shadow_pkey_reg;
-static inline unsigned int __read_pkey_reg(void)
-{
-	unsigned int eax, edx;
-	unsigned int ecx = 0;
-	unsigned int pkey_reg;
-
-	asm volatile(".byte 0x0f,0x01,0xee\n\t"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (ecx));
-	pkey_reg = eax;
-	return pkey_reg;
-}
 
 static inline unsigned int _read_pkey_reg(int line)
 {
@@ -100,19 +91,6 @@ static inline unsigned int _read_pkey_re
 
 #define read_pkey_reg() _read_pkey_reg(__LINE__)
 
-static inline void __write_pkey_reg(unsigned int pkey_reg)
-{
-	unsigned int eax = pkey_reg;
-	unsigned int ecx = 0;
-	unsigned int edx = 0;
-
-	dprintf4("%s() changing %08x to %08x\n", __func__,
-			__read_pkey_reg(), pkey_reg);
-	asm volatile(".byte 0x0f,0x01,0xef\n\t"
-		     : : "a" (eax), "c" (ecx), "d" (edx));
-	assert(pkey_reg == __read_pkey_reg());
-}
-
 static inline void write_pkey_reg(unsigned int pkey_reg)
 {
 	dprintf4("%s() changing %08x to %08x\n", __func__,
@@ -157,83 +135,6 @@ static inline void __pkey_write_allow(in
 	dprintf4("pkey_reg now: %08x\n", read_pkey_reg());
 }
 
-#define PAGE_SIZE 4096
-#define MB	(1<<20)
-
-static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
-		unsigned int *ecx, unsigned int *edx)
-{
-	/* ecx is often an input as well as an output. */
-	asm volatile(
-		"cpuid;"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (*eax), "2" (*ecx));
-}
-
-/* Intel-defined CPU features, CPUID level 0x00000007:0 (ecx) */
-#define X86_FEATURE_PKU        (1<<3) /* Protection Keys for Userspace */
-#define X86_FEATURE_OSPKE      (1<<4) /* OS Protection Keys Enable */
-
-static inline int cpu_has_pku(void)
-{
-	unsigned int eax;
-	unsigned int ebx;
-	unsigned int ecx;
-	unsigned int edx;
-
-	eax = 0x7;
-	ecx = 0x0;
-	__cpuid(&eax, &ebx, &ecx, &edx);
-
-	if (!(ecx & X86_FEATURE_PKU)) {
-		dprintf2("cpu does not have PKU\n");
-		return 0;
-	}
-	if (!(ecx & X86_FEATURE_OSPKE)) {
-		dprintf2("cpu does not have OSPKE\n");
-		return 0;
-	}
-	return 1;
-}
-
-#define XSTATE_PKEY_BIT	(9)
-#define XSTATE_PKEY	0x200
-
-int pkey_reg_xstate_offset(void)
-{
-	unsigned int eax;
-	unsigned int ebx;
-	unsigned int ecx;
-	unsigned int edx;
-	int xstate_offset;
-	int xstate_size;
-	unsigned long XSTATE_CPUID = 0xd;
-	int leaf;
-
-	/* assume that XSTATE_PKEY is set in XCR0 */
-	leaf = XSTATE_PKEY_BIT;
-	{
-		eax = XSTATE_CPUID;
-		ecx = leaf;
-		__cpuid(&eax, &ebx, &ecx, &edx);
-
-		if (leaf == XSTATE_PKEY_BIT) {
-			xstate_offset = ebx;
-			xstate_size = eax;
-		}
-	}
-
-	if (xstate_size == 0) {
-		printf("could not find size/offset of PKEY in xsave state\n");
-		return 0;
-	}
-
-	return xstate_offset;
-}
-
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
--- /dev/null
+++ a/tools/testing/selftests/vm/pkey-x86.h
@@ -0,0 +1,156 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _PKEYS_X86_H
+#define _PKEYS_X86_H
+
+#ifdef __i386__
+
+#ifndef SYS_mprotect_key
+# define SYS_mprotect_key	380
+#endif
+
+#ifndef SYS_pkey_alloc
+# define SYS_pkey_alloc		381
+# define SYS_pkey_free		382
+#endif
+
+#define REG_IP_IDX		REG_EIP
+#define si_pkey_offset		0x14
+
+#else
+
+#ifndef SYS_mprotect_key
+# define SYS_mprotect_key	329
+#endif
+
+#ifndef SYS_pkey_alloc
+# define SYS_pkey_alloc		330
+# define SYS_pkey_free		331
+#endif
+
+#define REG_IP_IDX		REG_RIP
+#define si_pkey_offset		0x20
+
+#endif
+
+#ifndef PKEY_DISABLE_ACCESS
+# define PKEY_DISABLE_ACCESS	0x1
+#endif
+
+#ifndef PKEY_DISABLE_WRITE
+# define PKEY_DISABLE_WRITE	0x2
+#endif
+
+#define NR_PKEYS		16
+#define PKEY_BITS_PER_PKEY	2
+#define HPAGE_SIZE		(1UL<<21)
+#define PAGE_SIZE		4096
+#define MB			(1<<20)
+
+static inline void __page_o_noops(void)
+{
+	/* 8-bytes of instruction * 512 bytes = 1 page */
+	asm(".rept 512 ; nopl 0x7eeeeeee(%eax) ; .endr");
+}
+
+static inline unsigned int __read_pkey_reg(void)
+{
+	unsigned int eax, edx;
+	unsigned int ecx = 0;
+	unsigned int pkey_reg;
+
+	asm volatile(".byte 0x0f,0x01,0xee\n\t"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (ecx));
+	pkey_reg = eax;
+	return pkey_reg;
+}
+
+static inline void __write_pkey_reg(unsigned int pkey_reg)
+{
+	unsigned int eax = pkey_reg;
+	unsigned int ecx = 0;
+	unsigned int edx = 0;
+
+	dprintf4("%s() changing %08x to %08x\n", __func__,
+			__read_pkey_reg(), pkey_reg);
+	asm volatile(".byte 0x0f,0x01,0xef\n\t"
+		     : : "a" (eax), "c" (ecx), "d" (edx));
+	assert(pkey_reg == __read_pkey_reg());
+}
+
+static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
+		unsigned int *ecx, unsigned int *edx)
+{
+	/* ecx is often an input as well as an output. */
+	asm volatile(
+		"cpuid;"
+		: "=a" (*eax),
+		  "=b" (*ebx),
+		  "=c" (*ecx),
+		  "=d" (*edx)
+		: "0" (*eax), "2" (*ecx));
+}
+
+/* Intel-defined CPU features, CPUID level 0x00000007:0 (ecx) */
+#define X86_FEATURE_PKU        (1<<3) /* Protection Keys for Userspace */
+#define X86_FEATURE_OSPKE      (1<<4) /* OS Protection Keys Enable */
+
+static inline int cpu_has_pku(void)
+{
+	unsigned int eax;
+	unsigned int ebx;
+	unsigned int ecx;
+	unsigned int edx;
+
+	eax = 0x7;
+	ecx = 0x0;
+	__cpuid(&eax, &ebx, &ecx, &edx);
+
+	if (!(ecx & X86_FEATURE_PKU)) {
+		dprintf2("cpu does not have PKU\n");
+		return 0;
+	}
+	if (!(ecx & X86_FEATURE_OSPKE)) {
+		dprintf2("cpu does not have OSPKE\n");
+		return 0;
+	}
+	return 1;
+}
+
+#define XSTATE_PKEY_BIT	(9)
+#define XSTATE_PKEY	0x200
+
+int pkey_reg_xstate_offset(void)
+{
+	unsigned int eax;
+	unsigned int ebx;
+	unsigned int ecx;
+	unsigned int edx;
+	int xstate_offset;
+	int xstate_size;
+	unsigned long XSTATE_CPUID = 0xd;
+	int leaf;
+
+	/* assume that XSTATE_PKEY is set in XCR0 */
+	leaf = XSTATE_PKEY_BIT;
+	{
+		eax = XSTATE_CPUID;
+		ecx = leaf;
+		__cpuid(&eax, &ebx, &ecx, &edx);
+
+		if (leaf == XSTATE_PKEY_BIT) {
+			xstate_offset = ebx;
+			xstate_size = eax;
+		}
+	}
+
+	if (xstate_size == 0) {
+		printf("could not find size/offset of PKEY in xsave state\n");
+		return 0;
+	}
+
+	return xstate_offset;
+}
+
+#endif /* _PKEYS_X86_H */
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-move-some-definitions-to-arch-specific-header
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -49,9 +49,6 @@ int iteration_nr = 1;
 int test_nr;
 
 unsigned int shadow_pkey_reg;
-
-#define HPAGE_SIZE	(1UL<<21)
-
 int dprint_in_signal;
 char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
@@ -137,12 +134,6 @@ void abort_hooks(void)
 #endif
 }
 
-static inline void __page_o_noops(void)
-{
-	/* 8-bytes of instruction * 512 bytes = 1 page */
-	asm(".rept 512 ; nopl 0x7eeeeeee(%eax) ; .endr");
-}
-
 /*
  * This attempts to have roughly a page of instructions followed by a few
  * instructions that do a write, and another page of instructions.  That
@@ -165,36 +156,6 @@ void lots_o_noops_around_write(int *writ
 	dprintf3("%s() done\n", __func__);
 }
 
-#ifdef __i386__
-
-#ifndef SYS_mprotect_key
-# define SYS_mprotect_key	380
-#endif
-
-#ifndef SYS_pkey_alloc
-# define SYS_pkey_alloc		381
-# define SYS_pkey_free		382
-#endif
-
-#define REG_IP_IDX		REG_EIP
-#define si_pkey_offset		0x14
-
-#else
-
-#ifndef SYS_mprotect_key
-# define SYS_mprotect_key	329
-#endif
-
-#ifndef SYS_pkey_alloc
-# define SYS_pkey_alloc		330
-# define SYS_pkey_free		331
-#endif
-
-#define REG_IP_IDX		REG_RIP
-#define si_pkey_offset		0x20
-
-#endif
-
 void dump_mem(void *dumpme, int len_bytes)
 {
 	char *c = (void *)dumpme;
@@ -367,14 +328,6 @@ pid_t fork_lazy_child(void)
 	return forkret;
 }
 
-#ifndef PKEY_DISABLE_ACCESS
-# define PKEY_DISABLE_ACCESS	0x1
-#endif
-
-#ifndef PKEY_DISABLE_WRITE
-# define PKEY_DISABLE_WRITE	0x2
-#endif
