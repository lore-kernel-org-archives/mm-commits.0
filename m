From: akpm@linux-foundation.org
Subject: [folded-merged]
 selftests-vm-pkeys-introduce-powerpc-support-fix.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 16:24:15 -0700
Message-ID: <20200604232415.54xoHvKbE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXYR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests: vm: pkeys: fix powerpc access right updates
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-introduce-powerpc-support-fix.patch

This patch was dropped because it was folded into selftests-vm-pkeys-introduce-powerpc-support.patch

------------------------------------------------------
From: Sandipan Das <sandipan@linux.ibm.com>
Subject: selftests: vm: pkeys: fix powerpc access right updates

The Power ISA mandates that all writes to the Authority Mask Register
(AMR) must always be preceded as well as succeeded by a
context-synchronizing instruction.  This applies to both the privileged
and unprivileged variants of the Move To AMR instruction.

Link: http://lkml.kernel.org/r/5f65cf37be993760de8112a88da194e3ccbb2bf8.1588959697.git.sandipan@linux.ibm.com
Fixes: 130f573c2a79 ("selftests/vm/pkeys: introduce powerpc support")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Suggested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-powerpc.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-introduce-powerpc-support-fix
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -54,7 +54,8 @@ static inline void __write_pkey_reg(u64
 	dprintf4("%s() changing %016llx to %016llx\n",
 			 __func__, __read_pkey_reg(), pkey_reg);
 
-	asm volatile("mtspr 0xd, %0" : : "r" ((unsigned long)(amr)) : "memory");
+	asm volatile("isync; mtspr 0xd, %0; isync"
+		     : : "r" ((unsigned long)(amr)) : "memory");
 
 	dprintf4("%s() pkey register after changing %016llx to %016llx\n",
 			__func__, __read_pkey_reg(), pkey_reg);
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-introduce-powerpc-support.patch
selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch
