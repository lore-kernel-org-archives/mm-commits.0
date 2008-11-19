From: akpm@linux-foundation.org
Subject: + unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch added to -mm tree
Date: Tue, 18 Nov 2008 22:15:08 -0800
Message-ID: <200811190615.mAJ6F8VJ007444__34532.4123082266$1227075423$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYKSGPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 01:15:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linux-arch@vger.kernel.org


The patch titled
     unaligned: remove packed-struct and unaligned access_ok headers
has been added to the -mm tree.  Its filename is
     unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: remove packed-struct and unaligned access_ok headers
From: Harvey Harrison <harvey.harrison@gmail.com>

The asm-generic version of unaligned.h now contains these bits.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned/access_ok.h     |   67 ----------------------
 include/linux/unaligned/be_struct.h     |   36 -----------
 include/linux/unaligned/le_struct.h     |   36 -----------
 include/linux/unaligned/packed_struct.h |   46 ---------------
 4 files changed, 185 deletions(-)

diff -puN include/linux/unaligned/access_ok.h~unaligned-remove-packed-struct-and-unaligned-access_ok-headers /dev/null
--- a/include/linux/unaligned/access_ok.h
+++ /dev/null
@@ -1,67 +0,0 @@
-#ifndef _LINUX_UNALIGNED_ACCESS_OK_H
-#define _LINUX_UNALIGNED_ACCESS_OK_H
-
-#include <linux/kernel.h>
-#include <asm/byteorder.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return le16_to_cpup((__le16 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return le32_to_cpup((__le32 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return le64_to_cpup((__le64 *)p);
-}
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return be16_to_cpup((__be16 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return be32_to_cpup((__be32 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return be64_to_cpup((__be64 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	*((__le16 *)p) = cpu_to_le16(val);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	*((__le32 *)p) = cpu_to_le32(val);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	*((__le64 *)p) = cpu_to_le64(val);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	*((__be16 *)p) = cpu_to_be16(val);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	*((__be32 *)p) = cpu_to_be32(val);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	*((__be64 *)p) = cpu_to_be64(val);
-}
-
-#endif /* _LINUX_UNALIGNED_ACCESS_OK_H */
diff -puN include/linux/unaligned/be_struct.h~unaligned-remove-packed-struct-and-unaligned-access_ok-headers /dev/null
--- a/include/linux/unaligned/be_struct.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_STRUCT_H
-#define _LINUX_UNALIGNED_BE_STRUCT_H
-
-#include <linux/unaligned/packed_struct.h>
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_cpu16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_cpu32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_cpu64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_cpu16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_cpu32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_cpu64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_BE_STRUCT_H */
diff -puN include/linux/unaligned/le_struct.h~unaligned-remove-packed-struct-and-unaligned-access_ok-headers /dev/null
--- a/include/linux/unaligned/le_struct.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_STRUCT_H
-#define _LINUX_UNALIGNED_LE_STRUCT_H
-
-#include <linux/unaligned/packed_struct.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_cpu16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_cpu32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_cpu64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_cpu16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_cpu32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_cpu64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_STRUCT_H */
diff -puN include/linux/unaligned/packed_struct.h~unaligned-remove-packed-struct-and-unaligned-access_ok-headers /dev/null
--- a/include/linux/unaligned/packed_struct.h
+++ /dev/null
@@ -1,46 +0,0 @@
-#ifndef _LINUX_UNALIGNED_PACKED_STRUCT_H
-#define _LINUX_UNALIGNED_PACKED_STRUCT_H
-
-#include <linux/kernel.h>
-
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
-
-static inline u16 __get_unaligned_cpu16(const void *p)
-{
-	const struct __una_u16 *ptr = (const struct __una_u16 *)p;
-	return ptr->x;
-}
-
-static inline u32 __get_unaligned_cpu32(const void *p)
-{
-	const struct __una_u32 *ptr = (const struct __una_u32 *)p;
-	return ptr->x;
-}
-
-static inline u64 __get_unaligned_cpu64(const void *p)
-{
-	const struct __una_u64 *ptr = (const struct __una_u64 *)p;
-	return ptr->x;
-}
-
-static inline void __put_unaligned_cpu16(u16 val, void *p)
-{
-	struct __una_u16 *ptr = (struct __una_u16 *)p;
-	ptr->x = val;
-}
-
-static inline void __put_unaligned_cpu32(u32 val, void *p)
-{
-	struct __una_u32 *ptr = (struct __una_u32 *)p;
-	ptr->x = val;
-}
-
-static inline void __put_unaligned_cpu64(u64 val, void *p)
-{
-	struct __una_u64 *ptr = (struct __una_u64 *)p;
-	ptr->x = val;
-}
-
-#endif /* _LINUX_UNALIGNED_PACKED_STRUCT_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch
v4l-s2255drv-fix-firmware-test-on-big-endian.patch
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
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

