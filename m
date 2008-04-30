From: akpm@linux-foundation.org
Subject: - kernel-add-common-infrastructure-for-unaligned-access.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:05 -0700
Message-ID: <200804300549.m3U5n5Ks029969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758988AbYD3GMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel: add common infrastructure for unaligned access
has been removed from the -mm tree.  Its filename was
     kernel-add-common-infrastructure-for-unaligned-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: add common infrastructure for unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>

Create a linux/unaligned directory similar in spirit to the linux/byteorder
folder to hold generic implementations collected from various arches.

Currently there are five implementations:
1) packed_struct.h: C-struct based, from asm-generic/unaligned.h
2) le_byteshift.h: Open coded byte-swapping, heavily based on asm-arm
3) be_byteshift.h: Open coded byte-swapping, heavily based on asm-arm
4) memmove.h: taken from multiple implementations in tree
5) access_ok.h: taken from x86 and others, unaligned access is ok.

All of the new implementations checks for sizes not equal to 1,2,4,8
and will fail to link.

API additions:

get_unaligned_{le16|le32|le64|be16|be32|be64}(p) which is meant to replace
code of the form:
le16_to_cpu(get_unaligned((__le16 *)p));

put_unaligned_{le16|le32|le64|be16|be32|be64}(val, pointer) which is meant to
replace code of the form:
put_unaligned(cpu_to_le16(val), (__le16 *)p);

The headers that arches should include from their asm/unaligned.h:

access_ok.h : Wrappers of the byteswapping functions in asm/byteorder

Choose a particular implementation for little-endian access:
le_byteshift.h
le_memmove.h (arch must be LE)
le_struct.h (arch must be LE)

Choose a particular implementation for big-endian access:
be_byteshift.h
be_memmove.h (arch must be BE)
be_struct.h (arch must be BE)

After including as needed from the above, include unaligned/generic.h and
define your arch's get/put_unaligned as (for LE):

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/unaligned/access_ok.h     |   67 +++++++++++++++++++++
 include/linux/unaligned/be_byteshift.h  |   70 ++++++++++++++++++++++
 include/linux/unaligned/be_memmove.h    |   36 +++++++++++
 include/linux/unaligned/be_struct.h     |   36 +++++++++++
 include/linux/unaligned/generic.h       |   68 +++++++++++++++++++++
 include/linux/unaligned/le_byteshift.h  |   70 ++++++++++++++++++++++
 include/linux/unaligned/le_memmove.h    |   36 +++++++++++
 include/linux/unaligned/le_struct.h     |   36 +++++++++++
 include/linux/unaligned/memmove.h       |   45 ++++++++++++++
 include/linux/unaligned/packed_struct.h |   46 ++++++++++++++
 10 files changed, 510 insertions(+)

diff -puN /dev/null include/linux/unaligned/access_ok.h
--- /dev/null
+++ a/include/linux/unaligned/access_ok.h
@@ -0,0 +1,67 @@
+#ifndef _LINUX_UNALIGNED_ACCESS_OK_H
+#define _LINUX_UNALIGNED_ACCESS_OK_H
+
+#include <linux/kernel.h>
+#include <asm/byteorder.h>
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return le16_to_cpup((__le16 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return le32_to_cpup((__le32 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return le64_to_cpup((__le64 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return be16_to_cpup((__be16 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return be32_to_cpup((__be32 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return be64_to_cpup((__be64 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	*((__le16 *)p) = cpu_to_le16(val);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	*((__le32 *)p) = cpu_to_le32(val);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	*((__le64 *)p) = cpu_to_le64(val);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	*((__be16 *)p) = cpu_to_be16(val);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	*((__be32 *)p) = cpu_to_be32(val);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	*((__be64 *)p) = cpu_to_be64(val);
+}
+
+#endif /* _LINUX_UNALIGNED_ACCESS_OK_H */
diff -puN /dev/null include/linux/unaligned/be_byteshift.h
--- /dev/null
+++ a/include/linux/unaligned/be_byteshift.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_BE_BYTESHIFT_H
+#define _LINUX_UNALIGNED_BE_BYTESHIFT_H
+
+#include <linux/kernel.h>
+
+static inline u16 __get_unaligned_be16(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline u32 __get_unaligned_be32(const u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline u64 __get_unaligned_be64(const u8 *p)
+{
+	return (u64)__get_unaligned_be32(p) << 32 |
+	       __get_unaligned_be32(p + 4);
+}
+
+static inline void __put_unaligned_be16(u16 val, u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_unaligned_be32(u32 val, u8 *p)
+{
+	__put_unaligned_be16(val >> 16, p);
+	__put_unaligned_be16(val, p + 2);
+}
+
+static inline void __put_unaligned_be64(u64 val, u8 *p)
+{
+	__put_unaligned_be32(val >> 32, p);
+	__put_unaligned_be32(val, p + 4);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_be32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_be64((const u8 *)p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_BE_BYTESHIFT_H */
diff -puN /dev/null include/linux/unaligned/be_memmove.h
--- /dev/null
+++ a/include/linux/unaligned/be_memmove.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_UNALIGNED_BE_MEMMOVE_H
+#define _LINUX_UNALIGNED_BE_MEMMOVE_H
+
+#include <linux/unaligned/memmove.h>
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_memmove16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_memmove32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_memmove64((const u8 *)p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_memmove16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_memmove32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_memmove64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
diff -puN /dev/null include/linux/unaligned/be_struct.h
--- /dev/null
+++ a/include/linux/unaligned/be_struct.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_UNALIGNED_BE_STRUCT_H
+#define _LINUX_UNALIGNED_BE_STRUCT_H
+
+#include <linux/unaligned/packed_struct.h>
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_cpu16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_cpu32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_cpu64((const u8 *)p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_cpu16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_cpu32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_cpu64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_BE_STRUCT_H */
diff -puN /dev/null include/linux/unaligned/generic.h
--- /dev/null
+++ a/include/linux/unaligned/generic.h
@@ -0,0 +1,68 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_H
+#define _LINUX_UNALIGNED_GENERIC_H
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
+#endif /* _LINUX_UNALIGNED_GENERIC_H */
diff -puN /dev/null include/linux/unaligned/le_byteshift.h
--- /dev/null
+++ a/include/linux/unaligned/le_byteshift.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_LE_BYTESHIFT_H
+#define _LINUX_UNALIGNED_LE_BYTESHIFT_H
+
+#include <linux/kernel.h>
+
+static inline u16 __get_unaligned_le16(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u32 __get_unaligned_le32(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline u64 __get_unaligned_le64(const u8 *p)
+{
+	return (u64)__get_unaligned_le32(p + 4) << 32 |
+	       __get_unaligned_le32(p);
+}
+
+static inline void __put_unaligned_le16(u16 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_le32(u32 val, u8 *p)
+{
+	__put_unaligned_le16(val >> 16, p + 2);
+	__put_unaligned_le16(val, p);
+}
+
+static inline void __put_unaligned_le64(u64 val, u8 *p)
+{
+	__put_unaligned_le32(val >> 32, p + 4);
+	__put_unaligned_le32(val, p);
+}
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_le32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_le64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_LE_BYTESHIFT_H */
diff -puN /dev/null include/linux/unaligned/le_memmove.h
--- /dev/null
+++ a/include/linux/unaligned/le_memmove.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_UNALIGNED_LE_MEMMOVE_H
+#define _LINUX_UNALIGNED_LE_MEMMOVE_H
+
+#include <linux/unaligned/memmove.h>
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_memmove16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_memmove32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_memmove64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_memmove16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_memmove32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_memmove64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
diff -puN /dev/null include/linux/unaligned/le_struct.h
--- /dev/null
+++ a/include/linux/unaligned/le_struct.h
@@ -0,0 +1,36 @@
+#ifndef _LINUX_UNALIGNED_LE_STRUCT_H
+#define _LINUX_UNALIGNED_LE_STRUCT_H
+
+#include <linux/unaligned/packed_struct.h>
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_cpu16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_cpu32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_cpu64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_cpu16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_cpu32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_cpu64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_LE_STRUCT_H */
diff -puN /dev/null include/linux/unaligned/memmove.h
--- /dev/null
+++ a/include/linux/unaligned/memmove.h
@@ -0,0 +1,45 @@
+#ifndef _LINUX_UNALIGNED_MEMMOVE_H
+#define _LINUX_UNALIGNED_MEMMOVE_H
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
+
+static inline u16 __get_unaligned_memmove16(const void *p)
+{
+	u16 tmp;
+	memmove(&tmp, p, 2);
+	return tmp;
+}
+
+static inline u32 __get_unaligned_memmove32(const void *p)
+{
+	u32 tmp;
+	memmove(&tmp, p, 4);
+	return tmp;
+}
+
+static inline u64 __get_unaligned_memmove64(const void *p)
+{
+	u64 tmp;
+	memmove(&tmp, p, 8);
+	return tmp;
+}
+
+static inline void __put_unaligned_memmove16(u16 val, void *p)
+{
+	memmove(p, &val, 2);
+}
+
+static inline void __put_unaligned_memmove32(u32 val, void *p)
+{
+	memmove(p, &val, 4);
+}
+
+static inline void __put_unaligned_memmove64(u64 val, void *p)
+{
+	memmove(p, &val, 8);
+}
+
+#endif /* _LINUX_UNALIGNED_MEMMOVE_H */
diff -puN /dev/null include/linux/unaligned/packed_struct.h
--- /dev/null
+++ a/include/linux/unaligned/packed_struct.h
@@ -0,0 +1,46 @@
+#ifndef _LINUX_UNALIGNED_PACKED_STRUCT_H
+#define _LINUX_UNALIGNED_PACKED_STRUCT_H
+
+#include <linux/kernel.h>
+
+struct __una_u16 { u16 x __attribute__((packed)); };
+struct __una_u32 { u32 x __attribute__((packed)); };
+struct __una_u64 { u64 x __attribute__((packed)); };
+
+static inline u16 __get_unaligned_cpu16(const void *p)
+{
+	const struct __una_u16 *ptr = (const struct __una_u16 *)p;
+	return ptr->x;
+}
+
+static inline u32 __get_unaligned_cpu32(const void *p)
+{
+	const struct __una_u32 *ptr = (const struct __una_u32 *)p;
+	return ptr->x;
+}
+
+static inline u64 __get_unaligned_cpu64(const void *p)
+{
+	const struct __una_u64 *ptr = (const struct __una_u64 *)p;
+	return ptr->x;
+}
+
+static inline void __put_unaligned_cpu16(u16 val, void *p)
+{
+	struct __una_u16 *ptr = (struct __una_u16 *)p;
+	ptr->x = val;
+}
+
+static inline void __put_unaligned_cpu32(u32 val, void *p)
+{
+	struct __una_u32 *ptr = (struct __una_u32 *)p;
+	ptr->x = val;
+}
+
+static inline void __put_unaligned_cpu64(u64 val, void *p)
+{
+	struct __una_u64 *ptr = (struct __una_u64 *)p;
+	ptr->x = val;
+}
+
+#endif /* _LINUX_UNALIGNED_PACKED_STRUCT_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

