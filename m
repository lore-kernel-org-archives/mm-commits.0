From: akpm@linux-foundation.org
Subject: - kernel-add-common-endian-load-store-api.patch removed from -mm tree
Date: Fri, 28 Nov 2008 22:14:14 -0800
Message-ID: <200811290614.mAT6EET0014020__47108.3794175231$1227939384$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbYK2GO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 01:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ecashin@coraid.com, jens.axboe@oracle.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel: add common endian load/store API
has been removed from the -mm tree.  Its filename was
     kernel-add-common-endian-load-store-api.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: add common endian load/store API
From: Harvey Harrison <harvey.harrison@gmail.com>

Add the following API for the 6 endian types in the kernel __le16,__le32,
__le64, __be16, __be32, __be64:

u16 load_le16(const __le16 *p)
u16 load_le16_noalign(const __le16 *p)

void store_le16(__le16 *p, u16 val)
void store_le16_noalign(__le16 *p, u16 val)

get/put_unaligned are being replaced because get/put in the kernel usually
implies some kind of reference is being taken/released, which is not the
case here.  They work with void * pointers which defeats sparse checking. 
Also, put_unaligned takes its arguments in the opposite order from what is
expected.  The new names are chosen to allow the APIs to live in parallel
without breaking compilation.  The get/put_unaligned API can be removed
once all users are converted.

load_le16 is a synonym for the existing le16_to_cpup and is added to be
symmetric with the load_le16_noalign API.  On arches where unaligned
access is OK, the unaligned calls are replaced with aligned calls.  This
name is also shorter than le16_to_cpup which will hopefully encourage its
use as it is generally faster than dereferencing the pointer and using
le16_to_cpu.  The only case where this does not hold is when taking the
address of a stack variable, as the work to get the stack variable address
generally outweighs just using le16_to_cpu directly.

store_le16 is a new API and is added to be symmetric with the unaligned
functions.  It is implemented as a macro to allow compile-time
byteswapping when the value is a constant.  This will also allow use in
many places currently that are of the form:

*(__le16 *)ptr = cpu_to_le16(foo);

In addition, some drivers/filesystems/arches already provide this API
privately, which will allow them to be consolidated into this common code.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |  100 +++++++++++++++++++-----------
 include/linux/byteorder.h       |   14 ++++
 2 files changed, 78 insertions(+), 36 deletions(-)

diff -puN include/asm-generic/unaligned.h~kernel-add-common-endian-load-store-api include/asm-generic/unaligned.h
--- a/include/asm-generic/unaligned.h~kernel-add-common-endian-load-store-api
+++ a/include/asm-generic/unaligned.h
@@ -6,6 +6,20 @@
 
 #ifdef _UNALIGNED_ACCESS_OK
 
+# define load_le16_noalign load_le16
+# define load_le32_noalign load_le32
+# define load_le64_noalign load_le64
+# define load_be16_noalign load_be16
+# define load_be32_noalign load_be32
+# define load_be64_noalign load_be64
+
+# define store_le16_noalign store_le16
+# define store_le32_noalign store_le32
+# define store_le64_noalign store_le64
+# define store_be16_noalign store_be16
+# define store_be32_noalign store_be32
+# define store_be64_noalign store_be64
+
 static inline u16 get_unaligned_le16(const void *p)
 {
 	return le16_to_cpup(p);
@@ -102,60 +116,67 @@ static inline u64 __get_be64_noalign(con
 	return ((u64)__get_be32_noalign(p) << 32) | __get_be32_noalign(p + 4);
 }
 
-static inline u16 get_unaligned_le16(const void *p)
+static inline u16 load_le16_noalign(const __le16 *p)
 {
 #ifdef __LITTLE_ENDIAN
-	return ((const struct __una_u16 *)p)->x;
+	return ((__force const struct __una_u16 *)p)->x;
 #else
-	return __get_le16_noalign(p);
+	return __get_le16_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u32 get_unaligned_le32(const void *p)
+static inline u32 load_le32_noalign(const __le32 *p)
 {
 #ifdef __LITTLE_ENDIAN
-	return ((const struct __una_u32 *)p)->x;
+	return ((__force const struct __una_u32 *)p)->x;
 #else
-	return __get_le32_noalign(p);
+	return __get_le32_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u64 get_unaligned_le64(const void *p)
+static inline u64 load_le64_noalign(const __le64 *p)
 {
 #ifdef __LITTLE_ENDIAN
-	return ((const struct __una_u64 *)p)->x;
+	return ((__force const struct __una_u64 *)p)->x;
 #else
-	return __get_le64_noalign(p);
+	return __get_le64_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u16 get_unaligned_be16(const void *p)
+static inline u16 load_be16_noalign(const __be16 *p)
 {
 #ifdef __BIG_ENDIAN
-	return ((const struct __una_u16 *)p)->x;
+	return ((__force const struct __una_u16 *)p)->x;
 #else
-	return __get_be16_noalign(p);
+	return __get_be16_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u32 get_unaligned_be32(const void *p)
+static inline u32 load_be32_noalign(const __be32 *p)
 {
 #ifdef __BIG_ENDIAN
-	return ((const struct __una_u32 *)p)->x;
+	return ((__force const struct __una_u32 *)p)->x;
 #else
-	return __get_be32_noalign(p);
+	return __get_be32_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u64 get_unaligned_be64(const void *p)
+static inline u64 load_be64_noalign(const __be64 *p)
 {
 #ifdef __BIG_ENDIAN
-	return ((const struct __una_u64 *)p)->x;
+	return ((__force const struct __una_u64 *)p)->x;
 #else
-	return __get_be64_noalign(p);
+	return __get_be64_noalign((__force const u8 *)p);
 #endif
 }
 
+#define get_unaligned_le16(p) load_le16_noalign((void *)(p))
+#define get_unaligned_le32(p) load_le32_noalign((void *)(p))
+#define get_unaligned_le64(p) load_le64_noalign((void *)(p))
+#define get_unaligned_be16(p) load_be16_noalign((void *)(p))
+#define get_unaligned_be32(p) load_be32_noalign((void *)(p))
+#define get_unaligned_be64(p) load_be64_noalign((void *)(p))
+
 static inline void __put_le16_noalign(u8 *p, u16 val)
 {
 	*p++ = val;
@@ -192,60 +213,67 @@ static inline void __put_be64_noalign(u8
 	__put_be32_noalign(p + 4, val);
 }
 
-static inline void put_unaligned_le16(u16 val, void *p)
+static inline void store_le16_noalign(__le16 *p, u16 val)
 {
 #ifdef __LITTLE_ENDIAN
-	((struct __una_u16 *)p)->x = val;
+	((__force struct __una_u16 *)p)->x = val;
 #else
-	__put_le16_noalign(p, val);
+	__put_le16_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_le32(u32 val, void *p)
+static inline void store_le32_noalign(__le32 *p, u32 val)
 {
 #ifdef __LITTLE_ENDIAN
-	((struct __una_u32 *)p)->x = val;
+	((__force struct __una_u32 *)p)->x = val;
 #else
-	__put_le32_noalign(p, val);
+	__put_le32_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_le64(u64 val, void *p)
+static inline void store_le64_noalign(__le64 *p, u64 val)
 {
 #ifdef __LITTLE_ENDIAN
-	((struct __una_u64 *)p)->x = val;
+	((__force struct __una_u64 *)p)->x = val;
 #else
-	__put_le64_noalign(p, val);
+	__put_le64_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_be16(u16 val, void *p)
+static inline void store_be16_noalign(__be16 *p, u16 val)
 {
 #ifdef __BIG_ENDIAN
-	((struct __una_u16 *)p)->x = val;
+	((__force struct __una_u16 *)p)->x = val;
 #else
-	__put_be16_noalign(p, val);
+	__put_be16_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_be32(u32 val, void *p)
+static inline void store_be32_noalign(__be32 *p, u32 val)
 {
 #ifdef __BIG_ENDIAN
-	((struct __una_u32 *)p)->x = val;
+	((__force struct __una_u32 *)p)->x = val;
 #else
-	__put_be32_noalign(p, val);
+	__put_be32_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_be64(u64 val, void *p)
+static inline void store_be64_noalign(__be64 *p, u64 val)
 {
 #ifdef __BIG_ENDIAN
-	((struct __una_u64 *)p)->x = val;
+	((__force struct __una_u64 *)p)->x = val;
 #else
-	__put_be64_noalign(p, val);
+	__put_be64_noalign((__force u8 *)p, val);
 #endif
 }
 
+#define put_unaligned_le16(val, p) store_le16_noalign((void *)(p), (val))
+#define put_unaligned_le32(val, p) store_le32_noalign((void *)(p), (val))
+#define put_unaligned_le64(val, p) store_le64_noalign((void *)(p), (val))
+#define put_unaligned_be16(val, p) store_be16_noalign((void *)(p), (val))
+#define put_unaligned_be32(val, p) store_be32_noalign((void *)(p), (val))
+#define put_unaligned_be64(val, p) store_be64_noalign((void *)(p), (val))
+
 #endif /* _UNALIGNED_ACCESS_OK */
 
 /*
diff -puN include/linux/byteorder.h~kernel-add-common-endian-load-store-api include/linux/byteorder.h
--- a/include/linux/byteorder.h~kernel-add-common-endian-load-store-api
+++ a/include/linux/byteorder.h
@@ -292,6 +292,20 @@ static inline __be64 __cpu_to_be64p(cons
 # define cpu_to_be32 __cpu_to_be32
 # define cpu_to_be64 __cpu_to_be64
 
+# define load_le16 __le16_to_cpup
+# define load_le32 __le32_to_cpup
+# define load_le64 __le64_to_cpup
+# define load_be16 __be16_to_cpup
+# define load_be32 __be32_to_cpup
+# define load_be64 __be64_to_cpup
+
+# define store_le16(p, val) (*(__le16 *)(p) = cpu_to_le16(val))
+# define store_le32(p, val) (*(__le32 *)(p) = cpu_to_le32(val))
+# define store_le64(p, val) (*(__le64 *)(p) = cpu_to_le64(val))
+# define store_be16(p, val) (*(__be16 *)(p) = cpu_to_be16(val))
+# define store_be32(p, val) (*(__be32 *)(p) = cpu_to_be32(val))
+# define store_be64(p, val) (*(__be64 *)(p) = cpu_to_be64(val))
+
 # define le16_to_cpup __le16_to_cpup
 # define le32_to_cpup __le32_to_cpup
 # define le64_to_cpup __le64_to_cpup
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
unaligned-introduce-common-header.patch
unaligned-introduce-common-header-fix.patch
unaligned-introduce-common-header-fix-2.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch
kernel-add-common-endian-load-store-api.patch
block-aoe-switch-to-the-new-endian-helpers.patch

