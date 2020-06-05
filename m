From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-pkeys-introduce-a-sub-page-allocator.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:21:00 -0700
Message-ID: <20200605202100.jSLSsbOFW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgFEUVB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: introduce a sub-page allocator
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-introduce-a-sub-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: introduce a sub-page allocator

This introduces a new allocator that allocates 4K hardware pages to back
64K linux pages.  This allocator is available only on powerpc.

Link: http://lkml.kernel.org/r/c4a82fa962ec71015b994fab1aaf83bdfd091553.1585646528.git.sandipan@linux.ibm.com
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

 tools/testing/selftests/vm/pkey-helpers.h    |    6 ++++
 tools/testing/selftests/vm/pkey-powerpc.h    |   25 +++++++++++++++++
 tools/testing/selftests/vm/pkey-x86.h        |    5 +++
 tools/testing/selftests/vm/protection_keys.c |    1 
 4 files changed, 37 insertions(+)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-introduce-a-sub-page-allocator
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -28,6 +28,9 @@
 extern int dprint_in_signal;
 extern char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
+extern int test_nr;
+extern int iteration_nr;
+
 #ifdef __GNUC__
 __attribute__((format(printf, 1, 2)))
 #endif
@@ -78,6 +81,9 @@ __attribute__((noinline)) int read_ptr(i
 void expected_pkey_fault(int pkey);
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
+int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
+		unsigned long pkey);
+void record_pkey_malloc(void *ptr, long size, int prot);
 
 #if defined(__i386__) || defined(__x86_64__) /* arch */
 #include "pkey-x86.h"
--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-introduce-a-sub-page-allocator
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -107,4 +107,29 @@ void expect_fault_on_read_execonly_key(v
 /* 4-byte instructions * 16384 = 64K page */
 #define __page_o_noops() asm(".rept 16384 ; nop; .endr")
 
+void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+{
+	void *ptr;
+	int ret;
+
+	dprintf1("doing %s(size=%ld, prot=0x%x, pkey=%d)\n", __func__,
+			size, prot, pkey);
+	pkey_assert(pkey < NR_PKEYS);
+	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(ptr != (void *)-1);
+
+	ret = syscall(__NR_subpage_prot, ptr, size, NULL);
+	if (ret) {
+		perror("subpage_perm");
+		return PTR_ERR_ENOTSUP;
+	}
+
+	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
+	pkey_assert(!ret);
+	record_pkey_malloc(ptr, size, prot);
+
+	dprintf1("%s() for pkey %d @ %p\n", __func__, pkey, ptr);
+	return ptr;
+}
+
 #endif /* _PKEYS_POWERPC_H */
--- a/tools/testing/selftests/vm/pkey-x86.h~selftests-vm-pkeys-introduce-a-sub-page-allocator
+++ a/tools/testing/selftests/vm/pkey-x86.h
@@ -173,4 +173,9 @@ void expect_fault_on_read_execonly_key(v
 	expected_pkey_fault(pkey);
 }
 
+void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+{
+	return PTR_ERR_ENOTSUP;
+}
+
 #endif /* _PKEYS_X86_H */
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-introduce-a-sub-page-allocator
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -845,6 +845,7 @@ void *malloc_pkey_mmap_dax(long size, in
 void *(*pkey_malloc[])(long size, int prot, u16 pkey) = {
 
 	malloc_pkey_with_mprotect,
+	malloc_pkey_with_mprotect_subpage,
 	malloc_pkey_anon_huge,
 	malloc_pkey_hugetlb
 /* can not do direct with the pkey_mprotect() API:
_

Patches currently in -mm which might be from linuxram@us.ibm.com are
