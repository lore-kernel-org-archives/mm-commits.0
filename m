From: akpm@linux-foundation.org
Subject: - unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch removed from -mm tree
Date: Sat, 29 Nov 2008 17:24:56 -0800
Message-ID: <200811300124.mAU1OutV016603__37542.5608516254$1228008390$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905AbYK3BZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 20:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     unaligned: remove last bits of the unaligned access helpers
has been removed from the -mm tree.  Its filename was
     unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: remove last bits of the unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned/be_byteshift.h |   70 -----------------------
 include/linux/unaligned/be_memmove.h   |   36 -----------
 include/linux/unaligned/generic.h      |   68 ----------------------
 include/linux/unaligned/le_byteshift.h |   70 -----------------------
 include/linux/unaligned/le_memmove.h   |   36 -----------
 include/linux/unaligned/memmove.h      |   45 --------------
 6 files changed, 325 deletions(-)

diff -puN include/linux/unaligned/be_byteshift.h~unaligned-remove-last-bits-of-the-unaligned-access-helpers /dev/null
--- a/include/linux/unaligned/be_byteshift.h
+++ /dev/null
@@ -1,70 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_BYTESHIFT_H
-#define _LINUX_UNALIGNED_BE_BYTESHIFT_H
-
-#include <linux/kernel.h>
-
-static inline u16 __get_unaligned_be16(const u8 *p)
-{
-	return p[0] << 8 | p[1];
-}
-
-static inline u32 __get_unaligned_be32(const u8 *p)
-{
-	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
-}
-
-static inline u64 __get_unaligned_be64(const u8 *p)
-{
-	return (u64)__get_unaligned_be32(p) << 32 |
-	       __get_unaligned_be32(p + 4);
-}
-
-static inline void __put_unaligned_be16(u16 val, u8 *p)
-{
-	*p++ = val >> 8;
-	*p++ = val;
-}
-
-static inline void __put_unaligned_be32(u32 val, u8 *p)
-{
-	__put_unaligned_be16(val >> 16, p);
-	__put_unaligned_be16(val, p + 2);
-}
-
-static inline void __put_unaligned_be64(u64 val, u8 *p)
-{
-	__put_unaligned_be32(val >> 32, p);
-	__put_unaligned_be32(val, p + 4);
-}
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_be16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_be32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_be64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_be16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_be32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_be64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_BE_BYTESHIFT_H */
diff -puN include/linux/unaligned/be_memmove.h~unaligned-remove-last-bits-of-the-unaligned-access-helpers /dev/null
--- a/include/linux/unaligned/be_memmove.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_MEMMOVE_H
-#define _LINUX_UNALIGNED_BE_MEMMOVE_H
-
-#include <linux/unaligned/memmove.h>
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_memmove16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_memmove32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_memmove64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_memmove16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_memmove32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_memmove64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
diff -puN include/linux/unaligned/generic.h~unaligned-remove-last-bits-of-the-unaligned-access-helpers /dev/null
--- a/include/linux/unaligned/generic.h
+++ /dev/null
@@ -1,68 +0,0 @@
-#ifndef _LINUX_UNALIGNED_GENERIC_H
-#define _LINUX_UNALIGNED_GENERIC_H
-
-/*
- * Cause a link-time error if we try an unaligned access other than
- * 1,2,4 or 8 bytes long
- */
-extern void __bad_unaligned_access_size(void);
-
-#define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
-	}))
-
-#define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
-	}))
-
-#define __put_unaligned_le(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_le16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_le32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_le64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#define __put_unaligned_be(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_be16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_be32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_be64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#endif /* _LINUX_UNALIGNED_GENERIC_H */
diff -puN include/linux/unaligned/le_byteshift.h~unaligned-remove-last-bits-of-the-unaligned-access-helpers /dev/null
--- a/include/linux/unaligned/le_byteshift.h
+++ /dev/null
@@ -1,70 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_BYTESHIFT_H
-#define _LINUX_UNALIGNED_LE_BYTESHIFT_H
-
-#include <linux/kernel.h>
-
-static inline u16 __get_unaligned_le16(const u8 *p)
-{
-	return p[0] | p[1] << 8;
-}
-
-static inline u32 __get_unaligned_le32(const u8 *p)
-{
-	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
-}
-
-static inline u64 __get_unaligned_le64(const u8 *p)
-{
-	return (u64)__get_unaligned_le32(p + 4) << 32 |
-	       __get_unaligned_le32(p);
-}
-
-static inline void __put_unaligned_le16(u16 val, u8 *p)
-{
-	*p++ = val;
-	*p++ = val >> 8;
-}
-
-static inline void __put_unaligned_le32(u32 val, u8 *p)
-{
-	__put_unaligned_le16(val >> 16, p + 2);
-	__put_unaligned_le16(val, p);
-}
-
-static inline void __put_unaligned_le64(u64 val, u8 *p)
-{
-	__put_unaligned_le32(val >> 32, p + 4);
-	__put_unaligned_le32(val, p);
-}
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_le16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_le32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_le64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_le16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_le32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_le64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_BYTESHIFT_H */
diff -puN include/linux/unaligned/le_memmove.h~unaligned-remove-last-bits-of-the-unaligned-access-helpers /dev/null
--- a/include/linux/unaligned/le_memmove.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_MEMMOVE_H
-#define _LINUX_UNALIGNED_LE_MEMMOVE_H
-
-#include <linux/unaligned/memmove.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_memmove16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_memmove32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_memmove64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_memmove16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_memmove32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_memmove64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
diff -puN include/linux/unaligned/memmove.h~unaligned-remove-last-bits-of-the-unaligned-access-helpers /dev/null
--- a/include/linux/unaligned/memmove.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef _LINUX_UNALIGNED_MEMMOVE_H
-#define _LINUX_UNALIGNED_MEMMOVE_H
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
-
-static inline u16 __get_unaligned_memmove16(const void *p)
-{
-	u16 tmp;
-	memmove(&tmp, p, 2);
-	return tmp;
-}
-
-static inline u32 __get_unaligned_memmove32(const void *p)
-{
-	u32 tmp;
-	memmove(&tmp, p, 4);
-	return tmp;
-}
-
-static inline u64 __get_unaligned_memmove64(const void *p)
-{
-	u64 tmp;
-	memmove(&tmp, p, 8);
-	return tmp;
-}
-
-static inline void __put_unaligned_memmove16(u16 val, void *p)
-{
-	memmove(p, &val, 2);
-}
-
-static inline void __put_unaligned_memmove32(u32 val, void *p)
-{
-	memmove(p, &val, 4);
-}
-
-static inline void __put_unaligned_memmove64(u64 val, void *p)
-{
-	memmove(p, &val, 8);
-}
-
-#endif /* _LINUX_UNALIGNED_MEMMOVE_H */
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
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

