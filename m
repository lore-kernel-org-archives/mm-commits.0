From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?selftests-vm-pkeys-detect-write-violation-on-a-mapped-acce?=
 =?US-ASCII?Q?ss-denied-key-page.patch?= removed from -mm tree
Date: Fri, 05 Jun 2020 13:20:57 -0700
Message-ID: <20200605202057.EZaNXc8_4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgFEUU6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: detect write violation on a mapped access-denied-key page
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-detect-write-violation-on-a-mapped-access-denied-key-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: detect write violation on a mapped access-denied-key page

Detect write-violation on a page to which access-disabled key is
associated much after the page is mapped.

Link: http://lkml.kernel.org/r/6a7dd4069ee18a2a51b207a55aa197f3f3c59753.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
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

 tools/testing/selftests/vm/protection_keys.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-detect-write-violation-on-a-mapped-access-denied-key-page
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1027,6 +1027,18 @@ void test_write_of_access_disabled_regio
 	*ptr = __LINE__;
 	expected_pkey_fault(pkey);
 }
+
+void test_write_of_access_disabled_region_with_page_already_mapped(int *ptr,
+			u16 pkey)
+{
+	*ptr = __LINE__;
+	dprintf1("disabling access; after accessing the page, "
+		" to PKEY[%02d], doing write\n", pkey);
+	pkey_access_deny(pkey);
+	*ptr = __LINE__;
+	expected_pkey_fault(pkey);
+}
+
 void test_kernel_write_of_access_disabled_region(int *ptr, u16 pkey)
 {
 	int ret;
@@ -1423,6 +1435,7 @@ void (*pkey_tests[])(int *ptr, u16 pkey)
 	test_write_of_write_disabled_region,
 	test_write_of_write_disabled_region_with_page_already_mapped,
 	test_write_of_access_disabled_region,
+	test_write_of_access_disabled_region_with_page_already_mapped,
 	test_kernel_write_of_access_disabled_region,
 	test_kernel_write_of_write_disabled_region,
 	test_kernel_gup_of_access_disabled_region,
_

Patches currently in -mm which might be from linuxram@us.ibm.com are
