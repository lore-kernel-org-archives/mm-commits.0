From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 124/127] selftests: vm: pkeys: use the correct
 page size on powerpc
Date: Thu, 04 Jun 2020 16:52:50 -0700
Message-ID: <20200604235250.V_LHl7lP1%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:52:52 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linux-mm@kvack.org, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org, torvalds@linux-foundation.org

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
@@ -32,7 +32,7 @@
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
