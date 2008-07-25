From: akpm@linux-foundation.org
Subject: + byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch added to -mm tree
Date: Fri, 25 Jul 2008 14:08:19 -0700
Message-ID: <200807252108.m6PL8JPQ031297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbYGYVIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 17:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, davem@davemloft.net


The patch titled
     Update byteorder helpers to always evaluate args
has been added to the -mm tree.  Its filename is
     byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch

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
Subject: Update byteorder helpers to always evaluate args
From: Harvey Harrison <harvey.harrison@gmail.com>

Update for byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

David Miller noticed a regression in IDE recently because I switched it over
to use the in-place byteswapping which doesn't evaluate arguments in some
endianesses (defined as do {} while(0))

Make them all functions to avoid this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder.h |  108 ++++++++++++++++++++++++++++--------
 1 file changed, 84 insertions(+), 24 deletions(-)

diff -puN include/linux/byteorder.h~byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update include/linux/byteorder.h
--- a/include/linux/byteorder.h~byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update
+++ a/include/linux/byteorder.h
@@ -37,12 +37,6 @@
 # define __cpu_to_le16(x) ((__force __le16)(__u16)(x))
 # define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
 # define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
-# define __le16_to_cpus(x) do {} while (0)
-# define __le32_to_cpus(x) do {} while (0)
-# define __le64_to_cpus(x) do {} while (0)
-# define __cpu_to_le16s(x) do {} while (0)
-# define __cpu_to_le32s(x) do {} while (0)
-# define __cpu_to_le64s(x) do {} while (0)
 
 # define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
 # define __be32_to_cpu(x) __swab32((__force __u32)(__be32)(x))
@@ -50,12 +44,6 @@
 # define __cpu_to_be16(x) ((__force __be16)__swab16(x))
 # define __cpu_to_be32(x) ((__force __be32)__swab32(x))
 # define __cpu_to_be64(x) ((__force __be64)__swab64(x))
-# define __be16_to_cpus(x) __swab16s(x)
-# define __be32_to_cpus(x) __swab32s(x)
-# define __be64_to_cpus(x) __swab64s(x)
-# define __cpu_to_be16s(x) __swab16s(x)
-# define __cpu_to_be32s(x) __swab32s(x)
-# define __cpu_to_be64s(x) __swab64s(x)
 #endif
 
 #ifdef __BIG_ENDIAN
@@ -65,12 +53,6 @@
 # define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
 # define __cpu_to_be32(x) ((__force __be32)(__u32)(x))
 # define __cpu_to_be64(x) ((__force __be64)(__u64)(x))
-# define __be16_to_cpus(x) do {} while (0)
-# define __be32_to_cpus(x) do {} while (0)
-# define __be64_to_cpus(x) do {} while (0)
-# define __cpu_to_be16s(x) do {} while (0)
-# define __cpu_to_be32s(x) do {} while (0)
-# define __cpu_to_be64s(x) do {} while (0)
 
 # define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
 # define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
@@ -78,12 +60,6 @@
 # define __cpu_to_le16(x) ((__force __le16)__swab16(x))
 # define __cpu_to_le32(x) ((__force __le32)__swab32(x))
 # define __cpu_to_le64(x) ((__force __le64)__swab64(x))
-# define __le16_to_cpus(x) __swab16s(x)
-# define __le32_to_cpus(x) __swab32s(x)
-# define __le64_to_cpus(x) __swab64s(x)
-# define __cpu_to_le16s(x) __swab16s(x)
-# define __cpu_to_le32s(x) __swab32s(x)
-# define __cpu_to_le64s(x) __swab64s(x)
 #endif
 
 /*
@@ -109,6 +85,90 @@
 #define __constant_cpu_to_be32(x) __cpu_to_be32(x)
 #define __constant_cpu_to_be64(x) __cpu_to_be64(x)
 
+static inline void __le16_to_cpus(__u16 *p)
+{
+#ifdef __BIG_ENDIAN
+	__swab16s(p);
+#endif
+}
+
+static inline void __cpu_to_le16s(__u16 *p)
+{
+#ifdef __BIG_ENDIAN
+	__swab16s(p);
+#endif
+}
+
+static inline void __le32_to_cpus(__u32 *p)
+{
+#ifdef __BIG_ENDIAN
+	__swab32s(p);
+#endif
+}
+
+static inline void __cpu_to_le32s(__u32 *p)
+{
+#ifdef __BIG_ENDIAN
+	__swab32s(p);
+#endif
+}
+
+static inline void __le64_to_cpus(__u64 *p)
+{
+#ifdef __BIG_ENDIAN
+	__swab64s(p);
+#endif
+}
+
+static inline void __cpu_to_le64s(__u64 *p)
+{
+#ifdef __BIG_ENDIAN
+	__swab64s(p);
+#endif
+}
+
+static inline void __be16_to_cpus(__u16 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	__swab16s(p);
+#endif
+}
+
+static inline void __cpu_to_be16s(__u16 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	__swab16s(p);
+#endif
+}
+
+static inline void __be32_to_cpus(__u32 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	__swab32s(p);
+#endif
+}
+
+static inline void __cpu_to_be32s(__u32 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	__swab32s(p);
+#endif
+}
+
+static inline void __be64_to_cpus(__u64 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	__swab64s(p);
+#endif
+}
+
+static inline void __cpu_to_be64s(__u64 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	__swab64s(p);
+#endif
+}
+
 static inline __u16 __le16_to_cpup(const __le16 *p)
 {
 #ifdef __LITTLE_ENDIAN
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
markers-fix-sparse-integer-as-null-pointer-warning.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers-update.patch

