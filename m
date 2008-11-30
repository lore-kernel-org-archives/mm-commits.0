From: akpm@linux-foundation.org
Subject: - unaligned-use-generic-implementation-on-packed-struct-arches.patch removed from -mm tree
Date: Sat, 29 Nov 2008 17:24:42 -0800
Message-ID: <200811300124.mAU1Ogc3016399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYK3B0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 20:26:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, bryan.wu@analog.com, davem@davemloft.net, dhowells@redhat.com, grundler@parisc-linux.org, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, kyle@mcmartin.ca


The patch titled
     unaligned: use generic implementation on packed-struct arches
has been removed from the -mm tree.  Its filename was
     unaligned-use-generic-implementation-on-packed-struct-arches.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: use generic implementation on packed-struct arches
From: Harvey Harrison <harvey.harrison@gmail.com>

No functional changes, convert arches that use the packed-struct
implementation for native-endianness and C byteshifting for the other
endianness.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Zankel <zankel@tensilica.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/unaligned.h    |    7 +------
 arch/avr32/include/asm/unaligned.h    |    8 +-------
 arch/blackfin/include/asm/unaligned.h |    7 +------
 arch/ia64/include/asm/unaligned.h     |    7 +------
 arch/mips/include/asm/unaligned.h     |   17 +----------------
 arch/parisc/include/asm/unaligned.h   |    6 +-----
 arch/sh/include/asm/unaligned.h       |   20 +-------------------
 arch/sparc/include/asm/unaligned.h    |    6 +-----
 arch/xtensa/include/asm/unaligned.h   |   16 +---------------
 include/asm-frv/unaligned.h           |    7 +------
 10 files changed, 10 insertions(+), 91 deletions(-)

diff -puN arch/alpha/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/alpha/include/asm/unaligned.h
--- a/arch/alpha/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/alpha/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_ALPHA_UNALIGNED_H
 #define _ASM_ALPHA_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned __get_unaligned_le
-#define put_unaligned __put_unaligned_le
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_ALPHA_UNALIGNED_H */
diff -puN arch/avr32/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/avr32/include/asm/unaligned.h
--- a/arch/avr32/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/avr32/include/asm/unaligned.h
@@ -10,12 +10,6 @@
  * However, swapped word loads must be word-aligned so we can't
  * optimize word loads in general.
  */
-
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_AVR32_UNALIGNED_H */
diff -puN arch/blackfin/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/blackfin/include/asm/unaligned.h
--- a/arch/blackfin/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/blackfin/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_BLACKFIN_UNALIGNED_H
 #define _ASM_BLACKFIN_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_BLACKFIN_UNALIGNED_H */
diff -puN arch/ia64/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/ia64/include/asm/unaligned.h
--- a/arch/ia64/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/ia64/include/asm/unaligned.h
@@ -1,11 +1,6 @@
 #ifndef _ASM_IA64_UNALIGNED_H
 #define _ASM_IA64_UNALIGNED_H
 
-#include <linux/unaligned/le_struct.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_IA64_UNALIGNED_H */
diff -puN arch/mips/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/mips/include/asm/unaligned.h
--- a/arch/mips/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/mips/include/asm/unaligned.h
@@ -8,21 +8,6 @@
 #ifndef _ASM_MIPS_UNALIGNED_H
 #define _ASM_MIPS_UNALIGNED_H
 
-#include <linux/compiler.h>
-#if defined(__MIPSEB__)
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#elif defined(__MIPSEL__)
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
-#endif
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_MIPS_UNALIGNED_H */
diff -puN arch/parisc/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/parisc/include/asm/unaligned.h
--- a/arch/parisc/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/parisc/include/asm/unaligned.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_PARISC_UNALIGNED_H
 #define _ASM_PARISC_UNALIGNED_H
 
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <asm-generic/unaligned.h>
 
 #ifdef __KERNEL__
 struct pt_regs;
diff -puN arch/sparc/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/sparc/include/asm/unaligned.h
--- a/arch/sparc/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/sparc/include/asm/unaligned.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_SPARC_UNALIGNED_H
 #define _ASM_SPARC_UNALIGNED_H
 
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_SPARC_UNALIGNED_H */
diff -puN arch/xtensa/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches arch/xtensa/include/asm/unaligned.h
--- a/arch/xtensa/include/asm/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/arch/xtensa/include/asm/unaligned.h
@@ -10,20 +10,6 @@
 #ifndef _ASM_XTENSA_UNALIGNED_H
 #define _ASM_XTENSA_UNALIGNED_H
 
-#include <asm/byteorder.h>
-
-#ifdef __LITTLE_ENDIAN
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#endif
+#include <asm-generic/unaligned.h>
 
 #endif	/* _ASM_XTENSA_UNALIGNED_H */
diff -puN include/asm-frv/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches include/asm-frv/unaligned.h
--- a/include/asm-frv/unaligned.h~unaligned-use-generic-implementation-on-packed-struct-arches
+++ a/include/asm-frv/unaligned.h
@@ -12,11 +12,6 @@
 #ifndef _ASM_UNALIGNED_H
 #define _ASM_UNALIGNED_H
 
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+#include <asm-generic/unaligned.h>
 
 #endif /* _ASM_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

