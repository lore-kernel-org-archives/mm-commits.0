From: akpm@linux-foundation.org
Subject: - byteorder-add-load-store_endian-api-update.patch removed from -mm tree
Date: Wed, 07 Jan 2009 13:58:27 -0800
Message-ID: <200901072158.n07LwR1W001001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368AbZAGV65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 16:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: add load/store_{endian} api
has been removed from the -mm tree.  Its filename was
     byteorder-add-load-store_endian-api-update.patch

This patch was dropped because it was folded into byteorder-add-load_-store_endian-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: add load/store_{endian} api
From: Harvey Harrison <harvey.harrison@gmail.com>

load_le16 is a synonym for the existing le16_to_cpup and is added to be
symmetric with the load_le16_noalign API.  On arches where unaligned
access is OK, the unaligned calls are replaced with aligned calls.

store_le16 is a new API and is added to be symmetric with the unaligned
functions.  It is implemented as a macro to allow compile-time
byteswapping when the value is a constant.  This will also allow use in
many places currently that are of the form:

*(__le16 *)ptr = cpu_to_le16(foo);

In addition, some drivers/filesystems/arches already provide this API
privately, which will allow them to be consolidated into this common code.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder.h         |   26 ++++++--------------------
 include/linux/byteorder/generic.h |   25 +++++++++++++++++++------
 2 files changed, 25 insertions(+), 26 deletions(-)

diff -puN include/linux/byteorder.h~byteorder-add-load-store_endian-api-update include/linux/byteorder.h
--- a/include/linux/byteorder.h~byteorder-add-load-store_endian-api-update
+++ a/include/linux/byteorder.h
@@ -292,20 +292,6 @@ static inline __be64 __cpu_to_be64p(cons
 # define cpu_to_be32 __cpu_to_be32
 # define cpu_to_be64 __cpu_to_be64
 
-# define load_le16 __le16_to_cpup
-# define load_le32 __le32_to_cpup
-# define load_le64 __le64_to_cpup
-# define load_be16 __be16_to_cpup
-# define load_be32 __be32_to_cpup
-# define load_be64 __be64_to_cpup
-
-# define store_le16(p, val) (*(__le16 *)(p) = cpu_to_le16(val))
-# define store_le32(p, val) (*(__le32 *)(p) = cpu_to_le32(val))
-# define store_le64(p, val) (*(__le64 *)(p) = cpu_to_le64(val))
-# define store_be16(p, val) (*(__be16 *)(p) = cpu_to_be16(val))
-# define store_be32(p, val) (*(__be32 *)(p) = cpu_to_be32(val))
-# define store_be64(p, val) (*(__be64 *)(p) = cpu_to_be64(val))
-
 # define le16_to_cpup __le16_to_cpup
 # define le32_to_cpup __le32_to_cpup
 # define le64_to_cpup __le64_to_cpup
@@ -354,32 +340,32 @@ static inline __be64 __cpu_to_be64p(cons
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	store_le16(var, load_le16(var) + val);
+	*var = cpu_to_le16(le16_to_cpup(var) + val);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	store_le32(var, load_le32(var) + val);
+	*var = cpu_to_le32(le32_to_cpup(var) + val);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	store_le64(var, load_le64(var) + val);
+	*var = cpu_to_le64(le64_to_cpup(var) + val);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	store_be16(var, load_be16(var) + val);
+	*var = cpu_to_be16(be16_to_cpup(var) + val);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	store_be32(var, load_be32(var) + val);
+	*var = cpu_to_be32(be32_to_cpup(var) + val);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	store_be64(var, load_be64(var) + val);
+	*var = cpu_to_be64(be64_to_cpup(var) + val);
 }
 
 #endif /* __KERNEL__ */
diff -puN include/linux/byteorder/generic.h~byteorder-add-load-store_endian-api-update include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~byteorder-add-load-store_endian-api-update
+++ a/include/linux/byteorder/generic.h
@@ -119,6 +119,19 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
+#define load_le16 __le16_to_cpup
+#define load_le32 __le32_to_cpup
+#define load_le64 __le64_to_cpup
+#define load_be16 __be16_to_cpup
+#define load_be32 __be32_to_cpup
+#define load_be64 __be64_to_cpup
+#define store_le16(p, val) (*(__le16 *)(p) = cpu_to_le16(val))
+#define store_le32(p, val) (*(__le32 *)(p) = cpu_to_le32(val))
+#define store_le64(p, val) (*(__le64 *)(p) = cpu_to_le64(val))
+#define store_be16(p, val) (*(__be16 *)(p) = cpu_to_be16(val))
+#define store_be32(p, val) (*(__be32 *)(p) = cpu_to_be32(val))
+#define store_be64(p, val) (*(__be64 *)(p) = cpu_to_be64(val))
+
 /*
  * They have to be macros in order to do the constant folding
  * correctly - if the argument passed into a inline function
@@ -142,32 +155,32 @@
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
+	store_le16(var, load_le16(var) + val);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
+	store_le32(var, load_le32(var) + val);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
+	store_le64(var, load_le64(var) + val);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	*var = cpu_to_be16(be16_to_cpu(*var) + val);
+	store_be16(var, load_be16(var) + val);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
+	store_be32(var, load_be32(var) + val);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	*var = cpu_to_be64(be64_to_cpu(*var) + val);
+	store_be64(var, load_be64(var) + val);
 }
 
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
byteorder-add-load-store_endian-api-update.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

