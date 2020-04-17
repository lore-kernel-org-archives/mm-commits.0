From: akpm@linux-foundation.org
Subject: +
 selftests-vm-pkeys-make-gcc-check-arguments-of-sigsafe_printf.patch added
 to -mm tree
Date: Fri, 17 Apr 2020 16:30:20 -0700
Message-ID: <20200417233020.K28h2tRQV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDQXaX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 19:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests/vm/pkeys: make gcc check arguments of sigsafe_printf()
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-make-gcc-check-arguments-of-sigsafe_printf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-make-gcc-check-arguments-of-sigsafe_printf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-make-gcc-check-arguments-of-sigsafe_printf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: selftests/vm/pkeys: make gcc check arguments of sigsafe_printf()

This will help us ensure we print pkey_reg_t values correctly in different
architectures.

Link: http://lkml.kernel.org/r/b40b7a95fdd4045d62530a2a34452934caf3b0bc.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/pkey-helpers.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/vm/pkey-helpers.h~selftests-vm-pkeys-make-gcc-check-arguments-of-sigsafe_printf
+++ a/tools/testing/selftests/vm/pkey-helpers.h
@@ -27,6 +27,10 @@
 #define DPRINT_IN_SIGNAL_BUF_SIZE 4096
 extern int dprint_in_signal;
 extern char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
+
+#ifdef __GNUC__
+__attribute__((format(printf, 1, 2)))
+#endif
 static inline void sigsafe_printf(const char *format, ...)
 {
 	va_list ap;
_

Patches currently in -mm which might be from bauerman@linux.ibm.com are

selftests-vm-pkeys-move-some-definitions-to-arch-specific-header.patch
selftests-vm-pkeys-make-gcc-check-arguments-of-sigsafe_printf.patch
