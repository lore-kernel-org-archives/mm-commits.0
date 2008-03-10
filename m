From: akpm@linux-foundation.org
Subject: + kvm-provide-kvmh-for-all-architecture-fixes-headers_install.patch added to -mm tree
Date: Mon, 10 Mar 2008 09:06:07 -0700
Message-ID: <200803101606.m2AG67nk024990__29210.3507360027$1205165302$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbYCJQHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 12:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borntraeger@de.ibm.com, avi@qumranet.com, dwmw2@infradead.org, linux-arch@vger.kernel.org, sam@ravnborg.org


The patch titled
     kvm: provide kvm.h for all architecture: fixes headers_install
has been added to the -mm tree.  Its filename is
     kvm-provide-kvmh-for-all-architecture-fixes-headers_install.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: provide kvm.h for all architecture: fixes headers_install
From: Christian Borntraeger <borntraeger@de.ibm.com>

Currently include/linux/kvm.h is not considered by make headers_install,
because Kbuild cannot handle " unifdef-$(CONFIG_FOO) += foo.h.  This problem
was introduced by 040922c04cf2c8ac70be2e88a8a9614ecdb41d2e, which makes this
an 2.6.25 regression.

One way of solving the issue is to enhance Kbuild, but Avi and David conviced
me, that changing headers_install is not the way to go.  This patch changes
the definition for linux/kvm.h to unifdef-y.

If unifdef-y is used for linux/kvm.h "make headers_check" will fail on all
architectures without asm/kvm.h.  Therefore, this patch also provides
asm/kvm.h on all architectures.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Avi Kivity <avi@qumranet.com>
Cc: Sam Ravnborg <sam@ravnborg.org
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/kvm.h     |    6 ++++++
 include/asm-arm/kvm.h       |    6 ++++++
 include/asm-avr32/kvm.h     |    6 ++++++
 include/asm-blackfin/kvm.h  |    6 ++++++
 include/asm-cris/kvm.h      |    6 ++++++
 include/asm-frv/kvm.h       |    6 ++++++
 include/asm-h8300/kvm.h     |    6 ++++++
 include/asm-ia64/kvm.h      |    6 ++++++
 include/asm-m32r/kvm.h      |    6 ++++++
 include/asm-m68k/kvm.h      |    6 ++++++
 include/asm-m68knommu/kvm.h |    6 ++++++
 include/asm-mips/kvm.h      |    6 ++++++
 include/asm-mn10300/kvm.h   |    6 ++++++
 include/asm-parisc/kvm.h    |    6 ++++++
 include/asm-powerpc/kvm.h   |    6 ++++++
 include/asm-s390/kvm.h      |    6 ++++++
 include/asm-sh/kvm.h        |    6 ++++++
 include/asm-sparc/kvm.h     |    6 ++++++
 include/asm-sparc64/kvm.h   |    6 ++++++
 include/asm-v850/kvm.h      |    6 ++++++
 include/asm-xtensa/kvm.h    |    6 ++++++
 include/linux/Kbuild        |    2 +-
 22 files changed, 127 insertions(+), 1 deletion(-)

diff -puN include/asm-alpha/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-alpha/Kbuild
diff -puN /dev/null include/asm-alpha/kvm.h
--- /dev/null
+++ a/include/asm-alpha/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ALPHA_H
+#define __LINUX_KVM_ALPHA_H
+
+/* alpha does not support KVM */
+
+#endif
diff -puN include/asm-arm/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-arm/Kbuild
diff -puN /dev/null include/asm-arm/kvm.h
--- /dev/null
+++ a/include/asm-arm/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ARM_H
+#define __LINUX_KVM_ARM_H
+
+/* arm does not support KVM */
+
+#endif
diff -puN include/asm-avr32/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-avr32/Kbuild
diff -puN /dev/null include/asm-avr32/kvm.h
--- /dev/null
+++ a/include/asm-avr32/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_AVR32_H
+#define __LINUX_KVM_AVR32_H
+
+/* avr32 does not support KVM */
+
+#endif
diff -puN include/asm-blackfin/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-blackfin/Kbuild
diff -puN /dev/null include/asm-blackfin/kvm.h
--- /dev/null
+++ a/include/asm-blackfin/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_BLACKFIN_H
+#define __LINUX_KVM_BLACKFIN_H
+
+/* blackfin does not support KVM */
+
+#endif
diff -puN include/asm-cris/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-cris/Kbuild
diff -puN /dev/null include/asm-cris/kvm.h
--- /dev/null
+++ a/include/asm-cris/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_CRIS_H
+#define __LINUX_KVM_CRIS_H
+
+/* cris does not support KVM */
+
+#endif
diff -puN include/asm-frv/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-frv/Kbuild
diff -puN /dev/null include/asm-frv/kvm.h
--- /dev/null
+++ a/include/asm-frv/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_FRV_H
+#define __LINUX_KVM_FRV_H
+
+/* frv does not support KVM */
+
+#endif
diff -puN include/asm-h8300/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-h8300/Kbuild
diff -puN /dev/null include/asm-h8300/kvm.h
--- /dev/null
+++ a/include/asm-h8300/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_H8300_H
+#define __LINUX_KVM_H8300_H
+
+/* h8300 does not support KVM */
+
+#endif
diff -puN include/asm-ia64/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-ia64/Kbuild
diff -puN /dev/null include/asm-ia64/kvm.h
--- /dev/null
+++ a/include/asm-ia64/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_IA64_H
+#define __LINUX_KVM_IA64_H
+
+/* ia64 does not support KVM */
+
+#endif
diff -puN include/asm-m32r/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-m32r/Kbuild
diff -puN /dev/null include/asm-m32r/kvm.h
--- /dev/null
+++ a/include/asm-m32r/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M32R_H
+#define __LINUX_KVM_M32R_H
+
+/* m32r does not support KVM */
+
+#endif
diff -puN include/asm-m68k/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-m68k/Kbuild
diff -puN /dev/null include/asm-m68k/kvm.h
--- /dev/null
+++ a/include/asm-m68k/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M68K_H
+#define __LINUX_KVM_M68K_H
+
+/* m68k does not support KVM */
+
+#endif
diff -puN include/asm-m68knommu/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-m68knommu/Kbuild
diff -puN /dev/null include/asm-m68knommu/kvm.h
--- /dev/null
+++ a/include/asm-m68knommu/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M68KNOMMU_H
+#define __LINUX_KVM_M68KNOMMU_H
+
+/* m68knommu does not support KVM */
+
+#endif
diff -puN include/asm-mips/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-mips/Kbuild
diff -puN /dev/null include/asm-mips/kvm.h
--- /dev/null
+++ a/include/asm-mips/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_MIPS_H
+#define __LINUX_KVM_MIPS_H
+
+/* mips does not support KVM */
+
+#endif
diff -puN include/asm-mn10300/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-mn10300/Kbuild
diff -puN /dev/null include/asm-mn10300/kvm.h
--- /dev/null
+++ a/include/asm-mn10300/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_MN10300_H
+#define __LINUX_KVM_MN10300_H
+
+/* mn10300 does not support KVM */
+
+#endif
diff -puN include/asm-parisc/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-parisc/Kbuild
diff -puN /dev/null include/asm-parisc/kvm.h
--- /dev/null
+++ a/include/asm-parisc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_PARISC_H
+#define __LINUX_KVM_PARISC_H
+
+/* parisc does not support KVM */
+
+#endif
diff -puN include/asm-powerpc/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-powerpc/Kbuild
diff -puN /dev/null include/asm-powerpc/kvm.h
--- /dev/null
+++ a/include/asm-powerpc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_POWERPC_H
+#define __LINUX_KVM_POWERPC_H
+
+/* powerpc does not support KVM */
+
+#endif
diff -puN include/asm-s390/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-s390/Kbuild
diff -puN /dev/null include/asm-s390/kvm.h
--- /dev/null
+++ a/include/asm-s390/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_S390_H
+#define __LINUX_KVM_S390_H
+
+/* s390 does not support KVM */
+
+#endif
diff -puN include/asm-sh/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-sh/Kbuild
diff -puN /dev/null include/asm-sh/kvm.h
--- /dev/null
+++ a/include/asm-sh/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SH_H
+#define __LINUX_KVM_SH_H
+
+/* sh does not support KVM */
+
+#endif
diff -puN include/asm-sparc/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-sparc/Kbuild
diff -puN /dev/null include/asm-sparc/kvm.h
--- /dev/null
+++ a/include/asm-sparc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SPARC_H
+#define __LINUX_KVM_SPARC_H
+
+/* sparc does not support KVM */
+
+#endif
diff -puN include/asm-sparc64/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-sparc64/Kbuild
diff -puN /dev/null include/asm-sparc64/kvm.h
--- /dev/null
+++ a/include/asm-sparc64/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SPARC64_H
+#define __LINUX_KVM_SPARC64_H
+
+/* sparc64 does not support KVM */
+
+#endif
diff -puN include/asm-v850/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-v850/Kbuild
diff -puN /dev/null include/asm-v850/kvm.h
--- /dev/null
+++ a/include/asm-v850/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_V850_H
+#define __LINUX_KVM_V850_H
+
+/* v850 does not support KVM */
+
+#endif
diff -puN include/asm-xtensa/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/asm-xtensa/Kbuild
diff -puN /dev/null include/asm-xtensa/kvm.h
--- /dev/null
+++ a/include/asm-xtensa/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_XTENSA_H
+#define __LINUX_KVM_XTENSA_H
+
+/* xtensa does not support KVM */
+
+#endif
diff -puN include/linux/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install include/linux/Kbuild
--- a/include/linux/Kbuild~kvm-provide-kvmh-for-all-architecture-fixes-headers_install
+++ a/include/linux/Kbuild
@@ -257,7 +257,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-$(CONFIG_HAVE_KVM) += kvm.h
+unifdef-y += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
_

Patches currently in -mm which might be from borntraeger@de.ibm.com are

origin.patch
kvm-provide-kvmh-for-all-architecture-fixes-headers_install.patch
git-kvm.patch

