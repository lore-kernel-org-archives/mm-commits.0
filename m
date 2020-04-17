From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detec?=
 =?US-ASCII?Q?t-access-violation.patch?= added to -mm tree
Date: Fri, 17 Apr 2020 16:30:57 -0700
Message-ID: <20200417233057.1_R8ixbV8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXbA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: associate key on a mapped page and detect access violation
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detect-access-violation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detect-access-violation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detect-access-violation.patch

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
Subject: selftests/vm/pkeys: associate key on a mapped page and detect access violation

Detect access-violation on a page to which access-disabled key is
associated much after the page is mapped.

Link: http://lkml.kernel.org/r/4a19cf9252c03dd883887e9002881599e6900d06.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off: Sandipan Das <sandipan@linux.ibm.com>
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

 tools/testing/selftests/vm/protection_keys.c |   19 +++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-associate-key-on-a-mapped-page-and-detect-access-violation
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -984,6 +984,24 @@ void test_read_of_access_disabled_region
 	dprintf1("*ptr: %d\n", ptr_contents);
 	expected_pkey_fault(pkey);
 }
+
+void test_read_of_access_disabled_region_with_page_already_mapped(int *ptr,
+		u16 pkey)
+{
+	int ptr_contents;
+
+	dprintf1("disabling access to PKEY[%02d], doing read @ %p\n",
+				pkey, ptr);
+	ptr_contents = read_ptr(ptr);
+	dprintf1("reading ptr before disabling the read : %d\n",
+			ptr_contents);
+	read_pkey_reg();
+	pkey_access_deny(pkey);
+	ptr_contents = read_ptr(ptr);
+	dprintf1("*ptr: %d\n", ptr_contents);
+	expected_pkey_fault(pkey);
+}
+
 void test_write_of_write_disabled_region(int *ptr, u16 pkey)
 {
 	dprintf1("disabling write access to PKEY[%02d], doing write\n", pkey);
@@ -1390,6 +1408,7 @@ void test_mprotect_pkey_on_unsupported_c
 void (*pkey_tests[])(int *ptr, u16 pkey) = {
 	test_read_of_write_disabled_region,
 	test_read_of_access_disabled_region,
+	test_read_of_access_disabled_region_with_page_already_mapped,
 	test_write_of_write_disabled_region,
 	test_write_of_access_disabled_region,
 	test_kernel_write_of_access_disabled_region,
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
