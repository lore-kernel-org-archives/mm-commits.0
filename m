From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-pkeys-improve-checks-to-determine-pkey-support.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:20:48 -0700
Message-ID: <20200605202048.BI21U8vy_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgFEUUt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: improve checks to determine pkey support
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-improve-checks-to-determine-pkey-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: improve checks to determine pkey support

For the pkeys subsystem to work, both the CPU and the kernel need to have
support.  So, additionally check if the kernel supports pkeys apart from
the CPU feature checks.

Link: http://lkml.kernel.org/r/8fb76c63ebdadcf068ecd2d23731032e195cd364.1585646528.git.sandipan@linux.ibm.com
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

 tools/testing/selftests/vm/pkey-helpers.h    |   30 +++++++++++++++++
 tools/testing/selftests/vm/pkey-powerpc.h    |    3 +
 tools/testing/selftests/vm/pkey-x86.h        |    2 -
 tools/testing/selftests/vm/protection_keys.c |    7 ++-
 4 files changed, 37 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-improve-checks-to-determine-pkey-support
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -76,6 +76,8 @@ extern void abort_hooks(void);
 
 __attribute__((noinline)) int read_ptr(int *ptr);
 void expected_pkey_fault(int pkey);
+int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
+int sys_pkey_free(unsigned long pkey);
 
 #if defined(__i386__) || defined(__x86_64__) /* arch */
 #include "pkey-x86.h"
@@ -186,4 +188,32 @@ static inline u32 *siginfo_get_pkey_ptr(
 #endif
 }
 
+static inline int kernel_has_pkeys(void)
+{
+	/* try allocating a key and see if it succeeds */
+	int ret = sys_pkey_alloc(0, 0);
+	if (ret <= 0) {
+		return 0;
+	}
+	sys_pkey_free(ret);
+	return 1;
+}
+
+static inline int is_pkeys_supported(void)
+{
+	/* check if the cpu supports pkeys */
+	if (!cpu_has_pkeys()) {
+		dprintf1("SKIP: %s: no CPU support\n", __func__);
+		return 0;
+	}
+
+	/* check if the kernel supports pkeys */
+	if (!kernel_has_pkeys()) {
+		dprintf1("SKIP: %s: no kernel support\n", __func__);
+		return 0;
+	}
+
+	return 1;
+}
+
 #endif /* _PKEYS_HELPER_H */
--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-improve-checks-to-determine-pkey-support
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -64,8 +64,9 @@ static inline void __write_pkey_reg(u64
 			__func__, __read_pkey_reg(), pkey_reg);
 }
 
-static inline int cpu_has_pku(void)
+static inline int cpu_has_pkeys(void)
 {
+	/* No simple way to determine this */
 	return 1;
 }
 
--- a/tools/testing/selftests/vm/pkey-x86.h~selftests-vm-pkeys-improve-checks-to-determine-pkey-support
+++ a/tools/testing/selftests/vm/pkey-x86.h
@@ -97,7 +97,7 @@ static inline void __cpuid(unsigned int
 #define X86_FEATURE_PKU        (1<<3) /* Protection Keys for Userspace */
 #define X86_FEATURE_OSPKE      (1<<4) /* OS Protection Keys Enable */
 
-static inline int cpu_has_pku(void)
+static inline int cpu_has_pkeys(void)
 {
 	unsigned int eax;
 	unsigned int ebx;
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-improve-checks-to-determine-pkey-support
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1378,7 +1378,7 @@ void test_mprotect_pkey_on_unsupported_c
 	int size = PAGE_SIZE;
 	int sret;
 
-	if (cpu_has_pku()) {
+	if (cpu_has_pkeys()) {
 		dprintf1("SKIP: %s: no CPU support\n", __func__);
 		return;
 	}
@@ -1447,12 +1447,13 @@ void pkey_setup_shadow(void)
 int main(void)
 {
 	int nr_iterations = 22;
+	int pkeys_supported = is_pkeys_supported();
 
 	setup_handlers();
 
-	printf("has pku: %d\n", cpu_has_pku());
+	printf("has pkeys: %d\n", pkeys_supported);
 
-	if (!cpu_has_pku()) {
+	if (!pkeys_supported) {
 		int size = PAGE_SIZE;
 		int *ptr;
 
_

Patches currently in -mm which might be from linuxram@us.ibm.com are
