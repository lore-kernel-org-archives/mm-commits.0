From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-pkeys-fix-assertion-in-pkey_disable_set-clear.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:20:27 -0700
Message-ID: <20200605202027._GPBs_POb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgFEUU2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:20:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: fix assertion in pkey_disable_set/clear()
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-fix-assertion-in-pkey_disable_set-clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: fix assertion in pkey_disable_set/clear()

In some cases, a pkey's bits need not necessarily change in a way that the
value of the pkey register increases when performing a pkey_disable_set()
or decreases when performing a pkey_disable_clear().

For example, on powerpc, if a pkey's current state is PKEY_DISABLE_ACCESS
and we perform a pkey_write_disable() on it, the bits still remain the
same.  We will observe something similar when the pkey's current state is
0 and a pkey_access_enable() is performed on it.

Either case would cause some assertions to fail.  This fixes the problem.

Link: http://lkml.kernel.org/r/8240665131e43fc93eed4eea8194676c1ea39a7f.1585646528.git.sandipan@linux.ibm.com
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

 tools/testing/selftests/vm/protection_keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-fix-assertion-in-pkey_disable_set-clear
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -400,7 +400,7 @@ void pkey_disable_set(int pkey, int flag
 	dprintf1("%s(%d) pkey_reg: 0x%016llx\n",
 		__func__, pkey, read_pkey_reg());
 	if (flags)
-		pkey_assert(read_pkey_reg() > orig_pkey_reg);
+		pkey_assert(read_pkey_reg() >= orig_pkey_reg);
 	dprintf1("END<---%s(%d, 0x%x)\n", __func__,
 		pkey, flags);
 }
@@ -431,7 +431,7 @@ void pkey_disable_clear(int pkey, int fl
 	dprintf1("%s(%d) pkey_reg: 0x%016llx\n", __func__,
 			pkey, read_pkey_reg());
 	if (flags)
-		assert(read_pkey_reg() < orig_pkey_reg);
+		assert(read_pkey_reg() <= orig_pkey_reg);
 }
 
 void pkey_write_allow(int pkey)
_

Patches currently in -mm which might be from linuxram@us.ibm.com are
