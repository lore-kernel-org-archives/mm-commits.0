From: akpm@linux-foundation.org
Subject: +
 selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch added to -mm
 tree
Date: Fri, 17 Apr 2020 16:31:15 -0700
Message-ID: <20200417233115.APHeAmw0z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXbR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:31:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests: vm: pkeys: use the correct page size on powerpc
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch

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
Subject: selftests: vm: pkeys: use the correct page size on powerpc

Both 4K and 64K pages are supported on powerpc.  Parts of the selftest
code perform alignment computations based on the PAGE_SIZE macro which is
currently hardcoded to 64K for powerpc.  This causes some test failures on
kernels configured with 4K page size.

In some cases, we need to enforce function alignment on page size.  Since
this can only be done at build time, 64K is used as the alignment factor
as that also ensures 4K alignment.

Link: http://lkml.kernel.org/r/5dcdfbf3353acdc90f315172e800b49f5ca21299.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-powerpc.h    |    2 +-
 tools/testing/selftests/vm/protection_keys.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-use-the-correct-page-size-on-powerpc
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -36,7 +36,7 @@
 					     pkey-31 and exec-only key */
 #define PKEY_BITS_PER_PKEY	2
 #define HPAGE_SIZE		(1UL << 24)
-#define PAGE_SIZE		(1UL << 16)
+#define PAGE_SIZE		sysconf(_SC_PAGESIZE)
 
 static inline u32 pkey_bit_position(int pkey)
 {
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-use-the-correct-page-size-on-powerpc
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -146,7 +146,12 @@ void abort_hooks(void)
  * will then fault, which makes sure that the fault code handles
  * execute-only memory properly.
  */
+#ifdef __powerpc64__
+/* This way, both 4K and 64K alignment are maintained */
+__attribute__((__aligned__(65536)))
+#else
 __attribute__((__aligned__(PAGE_SIZE)))
+#endif
 void lots_o_noops_around_write(int *write_to_me)
 {
 	dprintf3("running %s()\n", __func__);
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are

selftests-vm-pkeys-use-sane-types-for-pkey-register.patch
selftests-vm-pkeys-add-helpers-for-pkey-bits.patch
selftests-vm-pkeys-use-the-correct-huge-page-size.patch
selftests-vm-pkeys-use-the-correct-page-size-on-powerpc.patch
selftests-vm-pkeys-fix-multilib-builds-for-x86.patch
