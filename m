From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch
 added to -mm tree
Date: Fri, 08 May 2020 16:38:53 -0700
Message-ID: <20200508233853.xnyPaydFQ%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgEHXpJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:45:09 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests: vm: pkeys: fix powerpc access right definitions
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch

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
Subject: selftests: vm: pkeys: fix powerpc access right definitions

For powerpc, PKEY_DISABLE_WRITE and PKEY_DISABLE_ACCESS are redefined only
if the system headers already define them.  Otherwise, the test fails to
compile due to their absence.  This makes sure that they are always
defined irrespective of them being present in the system headers.

Link: http://lkml.kernel.org/r/1ba86fd8a94f38131cfe2d9f277001dd1ad1d34e.1588959697.git.sandipan@linux.ibm.com
Fixes: 130f573c2a79 ("selftests/vm/pkeys: introduce powerpc support")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-powerpc.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -16,15 +16,11 @@
 #define fpregs			fp_regs
 #define si_pkey_offset		0x20
 
-#ifdef PKEY_DISABLE_ACCESS
 #undef PKEY_DISABLE_ACCESS
-# define PKEY_DISABLE_ACCESS	0x3  /* disable read and write */
-#endif
+#define PKEY_DISABLE_ACCESS	0x3  /* disable read and write */
 
-#ifdef PKEY_DISABLE_WRITE
 #undef PKEY_DISABLE_WRITE
-# define PKEY_DISABLE_WRITE	0x2
-#endif
+#define PKEY_DISABLE_WRITE	0x2
 
 #define NR_PKEYS		32
 #define NR_RESERVED_PKEYS_4K	27 /* pkey-0, pkey-1, exec-only-pkey
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

mm-reset-numa-stats-for-boot-pagesets.patch
selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-introduce-powerpc-support-fix.patch
selftests-vm-pkeys-override-access-right-definitions-on-powerpc-fix.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch
