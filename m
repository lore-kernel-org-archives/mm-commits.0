From: akpm@linux-foundation.org
Subject: +
 selftests-vm-pkeys-introduce-generic-pkey-abstractions.patch added to -mm
 tree
Date: Fri, 17 Apr 2020 16:30:42 -0700
Message-ID: <20200417233042.-RmPHVs7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXao (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: introduce generic pkey abstractions
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-introduce-generic-pkey-abstractions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-introduce-generic-pkey-abstractions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-introduce-generic-pkey-abstractions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: introduce generic pkey abstractions

This introduces some generic abstractions and provides the corresponding
architecture-specfic implementations for these abstractions.

Link: http://lkml.kernel.org/r/1c977915e69fb7767fb0dbd55ac7656554b15b93.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
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

 tools/testing/selftests/vm/pkey-helpers.h    |   12 ++++++++++++
 tools/testing/selftests/vm/pkey-x86.h        |   15 +++++++++++++++
 tools/testing/selftests/vm/protection_keys.c |    8 ++------
 3 files changed, 29 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-introduce-generic-pkey-abstractions
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -74,6 +74,9 @@ extern void abort_hooks(void);
 	}					\
 } while (0)
 
+__attribute__((noinline)) int read_ptr(int *ptr);
+void expected_pkey_fault(int pkey);
+
 #if defined(__i386__) || defined(__x86_64__) /* arch */
 #include "pkey-x86.h"
 #else /* arch */
@@ -172,4 +175,13 @@ static inline void __pkey_write_allow(in
 #define __stringify_1(x...)     #x
 #define __stringify(x...)       __stringify_1(x)
 
+static inline u32 *siginfo_get_pkey_ptr(siginfo_t *si)
+{
+#ifdef si_pkey
+	return &si->si_pkey;
+#else
+	return (u32 *)(((u8 *)si) + si_pkey_offset);
+#endif
+}
+
 #endif /* _PKEYS_HELPER_H */
--- a/tools/testing/selftests/vm/pkey-x86.h~selftests-vm-pkeys-introduce-generic-pkey-abstractions
+++ a/tools/testing/selftests/vm/pkey-x86.h
@@ -42,6 +42,7 @@
 #endif
 
 #define NR_PKEYS		16
+#define NR_RESERVED_PKEYS	2 /* pkey-0 and exec-only-pkey */
 #define PKEY_BITS_PER_PKEY	2
 #define HPAGE_SIZE		(1UL<<21)
 #define PAGE_SIZE		4096
@@ -158,4 +159,18 @@ int pkey_reg_xstate_offset(void)
 	return xstate_offset;
 }
 
+static inline int get_arch_reserved_keys(void)
+{
+	return NR_RESERVED_PKEYS;
+}
+
+void expect_fault_on_read_execonly_key(void *p1, int pkey)
+{
+	int ptr_contents;
+
+	ptr_contents = read_ptr(p1);
+	dprintf2("ptr (%p) contents@%d: %x\n", p1, __LINE__, ptr_contents);
+	expected_pkey_fault(pkey);
+}
+
 #endif /* _PKEYS_X86_H */
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-introduce-generic-pkey-abstractions
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1307,9 +1307,7 @@ void test_executing_on_unreadable_memory
 	madvise(p1, PAGE_SIZE, MADV_DONTNEED);
 	lots_o_noops_around_write(&scratch);
 	do_not_expect_pkey_fault("executing on PROT_EXEC memory");
-	ptr_contents = read_ptr(p1);
-	dprintf2("ptr (%p) contents@%d: %x\n", p1, __LINE__, ptr_contents);
-	expected_pkey_fault(pkey);
+	expect_fault_on_read_execonly_key(p1, pkey);
 }
 
 void test_implicit_mprotect_exec_only_memory(int *ptr, u16 pkey)
@@ -1336,9 +1334,7 @@ void test_implicit_mprotect_exec_only_me
 	madvise(p1, PAGE_SIZE, MADV_DONTNEED);
 	lots_o_noops_around_write(&scratch);
 	do_not_expect_pkey_fault("executing on PROT_EXEC memory");
-	ptr_contents = read_ptr(p1);
-	dprintf2("ptr (%p) contents@%d: %x\n", p1, __LINE__, ptr_contents);
-	expected_pkey_fault(UNKNOWN_PKEY);
+	expect_fault_on_read_execonly_key(p1, UNKNOWN_PKEY);
 
 	/*
 	 * Put the memory back to non-PROT_EXEC.  Should clear the
_

Patches currently in -mm which might be from linuxram@us.ibm.com are

selftests-x86-pkeys-move-selftests-to-arch-neutral-directory.patch
selftests-vm-pkeys-rename-all-references-to-pkru-to-a-generic-name.patch
selftests-vm-pkeys-move-generic-definitions-to-header-file.patch
selftests-vm-pkeys-fix-pkey_disable_clear.patch
selftests-vm-pkeys-fix-assertion-in-pkey_disable_set-clear.patch
selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-random.patch
selftests-vm-pkeys-introduce-generic-pkey-abstractions.patch
selftests-vm-pkeys-introduce-powerpc-support.patch
selftests-vm-pkeys-fix-assertion-in-test_pkey_alloc_exhaust.patch
selftests-vm-pkeys-improve-checks-to-determine-pkey-support.patch
selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detect-access-violation.patch
selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detect-write-violation.patch
selftests-vm-pkeys-detect-write-violation-on-a-mapped-access-denied-key-page.patch
selftests-vm-pkeys-introduce-a-sub-page-allocator.patch
selftests-vm-pkeys-test-correct-behaviour-of-pkey-0.patch
selftests-vm-pkeys-override-access-right-definitions-on-powerpc.patch
