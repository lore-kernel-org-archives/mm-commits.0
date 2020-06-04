From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 123/127] selftests/vm/pkeys: override access right
 definitions on powerpc
Date: Thu, 04 Jun 2020 16:52:46 -0700
Message-ID: <20200604235246.wk-wpmwsd%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:52:48 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linux-mm@kvack.org, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Ram Pai <linuxram@us.ibm.com>
Subject: selftests/vm/pkeys: override access right definitions on powerpc

Some platforms hardcode the x86 values for PKEY_DISABLE_ACCESS
and PKEY_DISABLE_WRITE such as those in:
 /usr/include/bits/mman-shared.h.

This overrides the definitions with correct values for powerpc.

[sandipan@linux.ibm.com: fix powerpc access right definitions]
  Link: http://lkml.kernel.org/r/1ba86fd8a94f38131cfe2d9f277001dd1ad1d34e.1588959697.git.sandipan@linux.ibm.com
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

 tools/testing/selftests/vm/pkey-powerpc.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/pkey-powerpc.h~selftests-vm-pkeys-override-access-right-definitions-on-powerpc
+++ a/tools/testing/selftests/vm/pkey-powerpc.h
@@ -16,13 +16,11 @@
 #define fpregs			fp_regs
 #define si_pkey_offset		0x20
 
-#ifndef PKEY_DISABLE_ACCESS
-# define PKEY_DISABLE_ACCESS	0x3  /* disable read and write */
-#endif
+#undef PKEY_DISABLE_ACCESS
+#define PKEY_DISABLE_ACCESS	0x3  /* disable read and write */
 
-#ifndef PKEY_DISABLE_WRITE
-# define PKEY_DISABLE_WRITE	0x2
-#endif
+#undef PKEY_DISABLE_WRITE
+#define PKEY_DISABLE_WRITE	0x2
 
 #define NR_PKEYS		32
 #define NR_RESERVED_PKEYS_4K	27 /* pkey-0, pkey-1, exec-only-pkey
_
