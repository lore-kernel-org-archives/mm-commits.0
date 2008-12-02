From: akpm@linux-foundation.org
Subject: + sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:57:35 -0800
Message-ID: <200812022257.mB2MvZsf022245__49511.1484117389$1228258753$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbYLBW5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:57:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, lethal@linux-sh.org, linux-arch@vger.kernel.org


The patch titled
     sh: wire up arch overrides for unaligned access on the SH4a
has been added to the -mm tree.  Its filename is
     sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch

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
Subject: sh: wire up arch overrides for unaligned access on the SH4a
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/unaligned-sh4a.h |  258 -------------------------
 arch/sh/include/asm/unaligned.h      |   76 +++++--
 2 files changed, 61 insertions(+), 273 deletions(-)

diff -puN arch/sh/include/asm/unaligned-sh4a.h~sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a /dev/null
--- a/arch/sh/include/asm/unaligned-sh4a.h
+++ /dev/null
@@ -1,258 +0,0 @@
-#ifndef __ASM_SH_UNALIGNED_SH4A_H
-#define __ASM_SH_UNALIGNED_SH4A_H
-
-/*
- * SH-4A has support for unaligned 32-bit loads, and 32-bit loads only.
- * Support for 16 and 64-bit accesses are done through shifting and
- * masking relative to the endianness. Unaligned stores are not supported
- * by the instruction encoding, so these continue to use the packed
- * struct.
- *
- * The same note as with the movli.l/movco.l pair applies here, as long
- * as the load is gauranteed to be inlined, nothing else will hook in to
- * r0 and we get the return value for free.
- *
- * NOTE: Due to the fact we require r0 encoding, care should be taken to
- * avoid mixing these heavily with other r0 consumers, such as the atomic
- * ops. Failure to adhere to this can result in the compiler running out
- * of spill registers and blowing up when building at low optimization
- * levels. See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34777.
- */
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
-static __always_inline u32 __get_unaligned_cpu32(const u8 *p)
-{
-	unsigned long unaligned;
-
-	__asm__ __volatile__ (
-		"movua.l	@%1, %0\n\t"
-		 : "=z" (unaligned)
-		 : "r" (p)
-	);
-
-	return unaligned;
-}
-
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
-
-static inline u16 __get_unaligned_cpu16(const u8 *p)
-{
-#ifdef __LITTLE_ENDIAN
-	return __get_unaligned_cpu32(p) & 0xffff;
-#else
-	return __get_unaligned_cpu32(p) >> 16;
-#endif
-}
-
-/*
- * Even though movua.l supports auto-increment on the read side, it can
- * only store to r0 due to instruction encoding constraints, so just let
- * the compiler sort it out on its own.
- */
-static inline u64 __get_unaligned_cpu64(const u8 *p)
-{
-#ifdef __LITTLE_ENDIAN
-	return (u64)__get_unaligned_cpu32(p + 4) << 32 |
-		    __get_unaligned_cpu32(p);
-#else
-	return (u64)__get_unaligned_cpu32(p) << 32 |
-		    __get_unaligned_cpu32(p + 4);
-#endif
-}
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return le16_to_cpu(__get_unaligned_cpu16(p));
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return le32_to_cpu(__get_unaligned_cpu32(p));
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return le64_to_cpu(__get_unaligned_cpu64(p));
-}
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return be16_to_cpu(__get_unaligned_cpu16(p));
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return be32_to_cpu(__get_unaligned_cpu32(p));
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return be64_to_cpu(__get_unaligned_cpu64(p));
-}
-
-static inline void __put_le16_noalign(u8 *p, u16 val)
-{
-	*p++ = val;
-	*p++ = val >> 8;
-}
-
-static inline void __put_le32_noalign(u8 *p, u32 val)
-{
-	__put_le16_noalign(p, val);
-	__put_le16_noalign(p + 2, val >> 16);
-}
-
-static inline void __put_le64_noalign(u8 *p, u64 val)
-{
-	__put_le32_noalign(p, val);
-	__put_le32_noalign(p + 4, val >> 32);
-}
-
-static inline void __put_be16_noalign(u8 *p, u16 val)
-{
-	*p++ = val >> 8;
-	*p++ = val;
-}
-
-static inline void __put_be32_noalign(u8 *p, u32 val)
-{
-	__put_be16_noalign(p, val >> 16);
-	__put_be16_noalign(p + 2, val);
-}
-
-static inline void __put_be64_noalign(u8 *p, u64 val)
-{
-	__put_be32_noalign(p, val >> 32);
-	__put_be32_noalign(p + 4, val);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-#ifdef __LITTLE_ENDIAN
-	((struct __una_u16 *)p)->x = val;
-#else
-	__put_le16_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-#ifdef __LITTLE_ENDIAN
-	((struct __una_u32 *)p)->x = val;
-#else
-	__put_le32_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-#ifdef __LITTLE_ENDIAN
-	((struct __una_u64 *)p)->x = val;
-#else
-	__put_le64_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-#ifdef __BIG_ENDIAN
-	((struct __una_u16 *)p)->x = val;
-#else
-	__put_be16_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-#ifdef __BIG_ENDIAN
-	((struct __una_u32 *)p)->x = val;
-#else
-	__put_be32_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-#ifdef __BIG_ENDIAN
-	((struct __una_u64 *)p)->x = val;
-#else
-	__put_be64_noalign(p, val);
-#endif
-}
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
-#ifdef __LITTLE_ENDIAN
-# define get_unaligned __get_unaligned_le
-# define put_unaligned __put_unaligned_le
-#else
-# define get_unaligned __get_unaligned_be
-# define put_unaligned __put_unaligned_be
-#endif
-
-#endif /* __ASM_SH_UNALIGNED_SH4A_H */
diff -puN arch/sh/include/asm/unaligned.h~sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a arch/sh/include/asm/unaligned.h
--- a/arch/sh/include/asm/unaligned.h~sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a
+++ a/arch/sh/include/asm/unaligned.h
@@ -1,24 +1,70 @@
 #ifndef _ASM_SH_UNALIGNED_H
 #define _ASM_SH_UNALIGNED_H
 
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
 #ifdef CONFIG_CPU_SH4A
-/* SH-4A can handle unaligned loads in a relatively neutered fashion. */
-#include <asm/unaligned-sh4a.h>
-#else
-/* Otherwise, SH can't handle unaligned accesses. */
-#ifdef __LITTLE_ENDIAN__
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
+/*
+ * SH-4A has support for unaligned 32-bit loads, and 32-bit loads only.
+ * Support for 16 and 64-bit accesses are done through shifting and
+ * masking relative to the endianness. Unaligned stores are not supported
+ * by the instruction encoding, so these continue to use the packed
+ * struct.
+ *
+ * The same note as with the movli.l/movco.l pair applies here, as long
+ * as the load is gauranteed to be inlined, nothing else will hook in to
+ * r0 and we get the return value for free.
+ *
+ * NOTE: Due to the fact we require r0 encoding, care should be taken to
+ * avoid mixing these heavily with other r0 consumers, such as the atomic
+ * ops. Failure to adhere to this can result in the compiler running out
+ * of spill registers and blowing up when building at low optimization
+ * levels. See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34777.
+ */
+
+static inline u32 __arch_load_cpu32_noalign(const u8 *p)
+{
+	unsigned long unaligned;
+
+	__asm__ __volatile__ (
+		"movua.l	@%1, %0\n\t"
+		 : "=z" (unaligned)
+		 : "r" (p)
+	);
+
+	return unaligned;
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u16 __arch_load_cpu16_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return __arch_load_cpu32_noalign(p) & 0xffff;
 #else
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
+	return __arch_load_cpu32_noalign(p) >> 16;
 #endif
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+/*
+ * Even though movua.l supports auto-increment on the read side, it can
+ * only store to r0 due to instruction encoding constraints, so just let
+ * the compiler sort it out on its own.
+ */
+static inline u64 __arch_load_cpu64_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (u64)__arch_load_cpu32_noalign(p + 4) << 32 |
+		    __arch_load_cpu32_noalign(p);
+#else
+	return (u64)__arch_load_cpu32_noalign(p) << 32 |
+		    __arch_load_cpu32_noalign(p + 4);
 #endif
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+#endif /* CONFIG_CPU_SH4A */
 
+#include <linux/unaligned.h>
 #endif /* _ASM_SH_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
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
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch

