From: akpm@linux-foundation.org
Subject: +
 selftests-vm-pkeys-override-access-right-definitions-on-powerpc.patch added
 to -mm tree
Date: Fri, 17 Apr 2020 16:31:12 -0700
Message-ID: <20200417233112.bFtuXRsWR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXbP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: override access right definitions on powerpc
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-override-access-right-definitions-on-powerpc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-override-access-right-definitions-on-powerpc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-override-access-right-definitions-on-powerpc.patch

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
Subject: selftests/vm/pkeys: override access right definitions on powerpc

Some platforms hardcode the x86 values for PKEY_DISABLE_ACCESS
and PKEY_DISABLE_WRITE such as those in:
 /usr/include/bits/mman-shared.h.

This overrides the definitions with correct values for powerpc.

Link: http://lkml.kernel.org/r/f6eb38cb3a1e12eb2cdc9da6300bc5a5dfba0db9.1585646528.git.sandipan@linux.ibm.com
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

 tools/testing/selftests/vm/pkey-powerpc.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-override-access-right-definitions-on-powerpc
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -16,11 +16,13 @@
 #define fpregs			fp_regs
 #define si_pkey_offset		0x20
 
-#ifndef PKEY_DISABLE_ACCESS
+#ifdef PKEY_DISABLE_ACCESS
+#undef PKEY_DISABLE_ACCESS
 # define PKEY_DISABLE_ACCESS	0x3  /* disable read and write */
 #endif
 
-#ifndef PKEY_DISABLE_WRITE
+#ifdef PKEY_DISABLE_WRITE
+#undef PKEY_DISABLE_WRITE
 # define PKEY_DISABLE_WRITE	0x2
 #endif
 
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
