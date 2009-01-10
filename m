From: akpm@linux-foundation.org
Subject: - unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch removed from -mm tree
Date: Fri, 09 Jan 2009 16:16:33 -0800
Message-ID: <200901100032.n0A0WxYY006980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbZAJAdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 19:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     unaligned: consolidate unaligned headers add load_/store_{endian}_noalign
has been removed from the -mm tree.  Its filename was
     unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: consolidate unaligned headers add load_/store_{endian}_noalign
From: Harvey Harrison <harvey.harrison@gmail.com>

Consolidate include/linux/unaligned/*.h into a single linux/unaligned.h

There are two common cases in the kernel, one where unaligned access is OK
for an arch and one where the arch uses a packed-struct for the native
endianness and opencoded C byteshifting for the other endianness. 
Consolidate these two implementations in linux/unaligned.h

Arches that require no special handling of unaligned access can define
_UNALIGNED_ACCESS_OK in their asm/unaligned.h before including the generic
version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned.h |  339 ++++++++++++++++++++++++++++++++++++
 1 file changed, 339 insertions(+)

diff -puN /dev/null include/linux/unaligned.h
--- /dev/null
+++ a/include/linux/unaligned.h
@@ -0,0 +1,339 @@
+#ifndef _LINUX_UNALIGNED_H
+#define _LINUX_UNALIGNED_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+#ifdef _UNALIGNED_ACCESS_OK
+
+static inline u16 __load_cpu16_noalign(const void *p)
+{
+	return *(u16 *)p;
+}
+
+static inline u32 __load_cpu32_noalign(const void *p)
+{
+	return *(u32 *)p;
+}
+
+static inline u64 __load_cpu64_noalign(const void *p)
+{
+	return *(u64 *)p;
+}
+
+static inline void __store_cpu16_noalign(void *p, u16 val)
+{
+	*(u16 *)p = val;
+}
+
+static inline void __store_cpu32_noalign(void *p, u32 val)
+{
+	*(u32 *)p = val;
+}
+
+static inline void __store_cpu64_noalign(void *p, u64 val)
+{
+	*(u64 *)p = val;
+}
+
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
+#else /* _UNALIGNED_ACCESS_OK */
+
+struct __una_u16 { u16 x; } __attribute__((packed));
+struct __una_u32 { u32 x; } __attribute__((packed));
+struct __una_u64 { u64 x; } __attribute__((packed));
+
+static inline u16 __load_cpu16_noalign(const void *p)
+{
+#ifdef __arch_load_cpu16_noalign
+	return __arch_load_cpu16_noalign(p);
+#else
+	return ((const struct __una_u16 *)p)->x;
+#endif
+}
+
+static inline u32 __load_cpu32_noalign(const void *p)
+{
+#ifdef __arch_load_cpu32_noalign
+	return __arch_load_cpu32_noalign(p);
+#else
+	return ((const struct __una_u32 *)p)->x;
+#endif
+}
+
+static inline u64 __load_cpu64_noalign(const void *p)
+{
+#ifdef __arch_load_cpu64_noalign
+	return __arch_load_cpu64_noalign(p);
+#else
+	return ((const struct __una_u64 *)p)->x;
+#endif
+}
+
+static inline u16 __load_le16_noalign(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u32 __load_le32_noalign(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline u64 __load_le64_noalign(const u8 *p)
+{
+	return ((u64)__load_le32_noalign(p + 4) << 32) | __load_le32_noalign(p);
+}
+
+static inline u16 __load_be16_noalign(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline u32 __load_be32_noalign(const u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline u64 __load_be64_noalign(const u8 *p)
+{
+	return ((u64)__load_be32_noalign(p) << 32) | __load_be32_noalign(p + 4);
+}
+
+static inline u16 load_le16_noalign(const __le16 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return __load_cpu16_noalign(p);
+#else
+	return __load_le16_noalign((__force u8 *)p);
+#endif
+}
+
+static inline u32 load_le32_noalign(const __le32 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return __load_cpu32_noalign(p);
+#else
+	return __load_le32_noalign((__force u8 *)p);
+#endif
+}
+
+static inline u64 load_le64_noalign(const __le64 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return __load_cpu64_noalign(p);
+#else
+	return __load_le64_noalign((__force u8 *)p);
+#endif
+}
+
+static inline u16 load_be16_noalign(const __be16 *p)
+{
+#ifdef __BIG_ENDIAN
+	return __load_cpu16_noalign(p);
+#else
+	return __load_be16_noalign((__force u8 *)p);
+#endif
+}
+
+static inline u32 load_be32_noalign(const __be32 *p)
+{
+#ifdef __BIG_ENDIAN
+	return __load_cpu32_noalign(p);
+#else
+	return __load_be32_noalign((__force u8 *)p);
+#endif
+}
+
+static inline u64 load_be64_noalign(const __be64 *p)
+{
+#ifdef __BIG_ENDIAN
+	return __load_cpu64_noalign(p);
+#else
+	return __load_be64_noalign((__force u8 *)p);
+#endif
+}
+
+static inline void __store_cpu16_noalign(void *p, u16 val)
+{
+#ifdef __arch_store_cpu16_noalign
+	__arch_store_cpu16_noalign(p, val);
+#else
+	((struct __una_u16 *)p)->x = val;
+#endif
+}
+
+static inline void __store_cpu32_noalign(void *p, u32 val)
+{
+#ifdef __arch_store_cpu32_noalign
+	__arch_store_cpu32_noalign(p, val);
+#else
+	((struct __una_u32 *)p)->x = val;
+#endif
+}
+
+static inline void __store_cpu64_noalign(void *p, u64 val)
+{
+#ifdef __arch_store_cpu64_noalign
+	__arch_store_cpu64_noalign(p, val);
+#else
+	((struct __una_u64 *)p)->x = val;
+#endif
+}
+
+static inline void __store_le16_noalign(u8 *p, u16 val)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __store_le32_noalign(u8 *p, u32 val)
+{
+	__store_le16_noalign(p, val);
+	__store_le16_noalign(p + 2, val >> 16);
+}
+
+static inline void __store_le64_noalign(u8 *p, u64 val)
+{
+	__store_le32_noalign(p, val);
+	__store_le32_noalign(p + 4, val >> 32);
+}
+
+static inline void __store_be16_noalign(u8 *p, u16 val)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __store_be32_noalign(u8 *p, u32 val)
+{
+	__store_be16_noalign(p, val >> 16);
+	__store_be16_noalign(p + 2, val);
+}
+
+static inline void __store_be64_noalign(u8 *p, u64 val)
+{
+	__store_be32_noalign(p, val >> 32);
+	__store_be32_noalign(p + 4, val);
+}
+
+static inline void store_le16_noalign(__le16 *p, u16 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__store_cpu16_noalign(p, val);
+#else
+	__store_le16_noalign((__force u8 *)p, val);
+#endif
+}
+
+static inline void store_le32_noalign(__le32 *p, u32 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__store_cpu32_noalign(p, val);
+#else
+	__store_le32_noalign((__force u8 *)p, val);
+#endif
+}
+
+static inline void store_le64_noalign(__le64 *p, u64 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__store_cpu64_noalign(p, val);
+#else
+	__store_le64_noalign((__force u8 *)p, val);
+#endif
+}
+
+static inline void store_be16_noalign(__be16 *p, u16 val)
+{
+#ifdef __BIG_ENDIAN
+	__store_cpu16_noalign(p, val);
+#else
+	__store_be16_noalign((__force u8 *)p, val);
+#endif
+}
+
+static inline void store_be32_noalign(__be32 *p, u32 val)
+{
+#ifdef __BIG_ENDIAN
+	__store_cpu32_noalign(p, val);
+#else
+	__store_be32_noalign((__force u8 *)p, val);
+#endif
+}
+
+static inline void store_be64_noalign(__be64 *p, u64 val)
+{
+#ifdef __BIG_ENDIAN
+	__store_cpu64_noalign(p, val);
+#else
+	__store_be64_noalign((__force u8 *)p, val);
+#endif
+}
+
+#endif /* _UNALIGNED_ACCESS_OK */
+
+#define get_unaligned_le16(p) load_le16_noalign((void *)(p))
+#define get_unaligned_le32(p) load_le32_noalign((void *)(p))
+#define get_unaligned_le64(p) load_le64_noalign((void *)(p))
+#define get_unaligned_be16(p) load_be16_noalign((void *)(p))
+#define get_unaligned_be32(p) load_be32_noalign((void *)(p))
+#define get_unaligned_be64(p) load_be64_noalign((void *)(p))
+
+#define put_unaligned_le16(val, p) store_le16_noalign((void *)(p), (val))
+#define put_unaligned_le32(val, p) store_le32_noalign((void *)(p), (val))
+#define put_unaligned_le64(val, p) store_le64_noalign((void *)(p), (val))
+#define put_unaligned_be16(val, p) store_be16_noalign((void *)(p), (val))
+#define put_unaligned_be32(val, p) store_be32_noalign((void *)(p), (val))
+#define put_unaligned_be64(val, p) store_be64_noalign((void *)(p), (val))
+
+/*
+ * Cause a link-time error if we try an unaligned access other than
+ * 1,2,4 or 8 bytes long
+ */
+extern void __bad_unaligned_access_size(void);
+
+#define get_unaligned(ptr) ((__force typeof(*(ptr)))({				\
+	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, __load_cpu16_noalign(ptr),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, __load_cpu32_noalign(ptr),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, __load_cpu64_noalign(ptr),	\
+	__bad_unaligned_access_size()))));					\
+	}))
+
+#define put_unaligned(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		__store_cpu16_noalign(__gu_p, (__force u16)(val));	\
+		break;							\
+	case 4:								\
+		__store_cpu32_noalign(__gu_p, (__force u32)(val));	\
+		break;							\
+	case 8:								\
+		__store_cpu64_noalign(__gu_p, (__force u64)(val));	\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
memstick-annotate-endianness-of-attribute-structs.patch

