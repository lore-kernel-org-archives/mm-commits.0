From: akpm@linux-foundation.org
Subject: - unaligned-introduce-common-header.patch removed from -mm tree
Date: Sat, 29 Nov 2008 17:24:15 -0800
Message-ID: <200811300124.mAU1OFPP016167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbYK3B00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 20:26:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, benh@kernel.crashing.org, bryan.wu@analog.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, grundler@parisc-linux.org


The patch titled
     unaligned: introduce common header
has been removed from the -mm tree.  Its filename was
     unaligned-introduce-common-header.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: introduce common header
From: Harvey Harrison <harvey.harrison@gmail.com>

There are two common cases in the kernel, one where unaligned access is OK
for an arch and one where the arch uses a packed-struct for the native
endianness and opencoded C byteshifting for the other endianness. 
Consolidate these two implementations in asm-generic/unaligned.h

Arches that require no special handling of unaligned access can define
_UNALIGNED_ACCESS_OK in their asm/unaligned.h before including the generic
version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unaligned.h |  323 ++++++++++++++++++++++++++++++
 1 file changed, 323 insertions(+)

diff -puN /dev/null include/asm-generic/unaligned.h
--- /dev/null
+++ a/include/asm-generic/unaligned.h
@@ -0,0 +1,323 @@
+#ifndef _ASM_GENERIC_UNALIGNED_H
+#define _ASM_GENERIC_UNALIGNED_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#ifdef _UNALIGNED_ACCESS_OK
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return le16_to_cpup(p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return le32_to_cpup(p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return le64_to_cpup(p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return be16_to_cpup(p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return be32_to_cpup(p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return be64_to_cpup(p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	*(__le16 *)p = cpu_to_le16(val);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	*(__le32 *)p = cpu_to_le32(val);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	*(__le64 *)p = cpu_to_le64(val);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	*(__be16 *)p = cpu_to_be16(val);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	*(__be32 *)p = cpu_to_be32(val);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	*(__be64 *)p = cpu_to_be64(val);
+}
+
+#else /* _UNALIGNED_ACCESS_OK */
+
+struct __una_u16 { u16 x __attribute__((packed)); };
+struct __una_u32 { u32 x __attribute__((packed)); };
+struct __una_u64 { u64 x __attribute__((packed)); };
+
+static inline u16 __get_le16_noalign(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u32 __get_le32_noalign(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline u64 __get_le64_noalign(const u8 *p)
+{
+	return ((u64)__get_le32_noalign(p + 4) << 32) | __get_le32_noalign(p);
+}
+
+static inline u16 __get_be16_noalign(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline u32 __get_be32_noalign(const u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline u64 __get_be64_noalign(const u8 *p)
+{
+	return ((u64)__get_be32_noalign(p) << 32) | __get_be32_noalign(p + 4);
+}
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u16 *)p)->x;
+#else
+	return __get_le16_noalign(p);
+#endif
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u32 *)p)->x;
+#else
+	return __get_le32_noalign(p);
+#endif
+}
+
+static inline u16 get_unaligned_le64(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u64 *)p)->x;
+#else
+	return __get_le64_noalign(p);
+#endif
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u16 *)p)->x;
+#else
+	return __get_be16_noalign(p);
+#endif
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u32 *)p)->x;
+#else
+	return __get_be32_noalign(p);
+#endif
+}
+
+static inline u16 get_unaligned_be64(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u64 *)p)->x;
+#else
+	return __get_be64_noalign(p);
+#endif
+}
+
+static inline void __put_le16_noalign(u8 *p, u16 val)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_le32_noalign(u8 *p, u32 val)
+{
+	__put_le16_noalign(p + 2, val >> 16);
+	__put_le16_noalign(p, val);
+}
+
+static inline void __put_le64_noalign(u8 *p, u64 val)
+{
+	__put_le32_noalign(p + 4, val >> 32);
+	__put_le32_noalign(p, val);
+}
+
+static inline void __put_be16_noalign(u8 *p, u16 val)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_be32_noalign(u8 *p, u32 val)
+{
+	__put_be16_noalign(p, val >> 16);
+	__put_be16_noalign(p + 2, val);
+}
+
+static inline void __put_be64_noalign(u8 *p, u64 val)
+{
+	__put_be32_noalign(p, val >> 32);
+	__put_be32_noalign(p + 4, val);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u16 *)p)->x = val;
+#else
+	__put_le16_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u32 *)p)->x = val;
+#else
+	__put_le32_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u64 *)p)->x = val;
+#else
+	__put_le64_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u16 *)p)->x = val;
+#else
+	__put_be16_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u32 *)p)->x = val;
+#else
+	__put_be32_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u64 *)p)->x = val;
+#else
+	__put_be64_noalign(p, val);
+#endif
+}
+
+#endif /* _UNALIGNED_ACCESS_OK */
+
+/*
+ * Cause a link-time error if we try an unaligned access other than
+ * 1,2,4 or 8 bytes long
+ */
+extern void __bad_unaligned_access_size(void);
+
+#define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
+	__bad_unaligned_access_size()))));					\
+	}))
+
+#define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
+	__bad_unaligned_access_size()))));					\
+	}))
+
+#define __put_unaligned_le(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_le16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_le32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_le64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#define __put_unaligned_be(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_be16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_be32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_be64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#ifdef __LITTLE_ENDIAN
+# define get_unaligned __get_unaligned_le
+# define put_unaligned __put_unaligned_le
+#else
+# define get_unaligned __get_unaligned_be
+# define put_unaligned __put_unaligned_be
+#endif
+
+#endif /* _ASM_GENERIC_UNALIGNED_H */
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

