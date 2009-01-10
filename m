From: akpm@linux-foundation.org
Subject: - unaligned-wire-up-h8300-and-m32r-arches.patch removed from -mm tree
Date: Fri, 09 Jan 2009 16:16:48 -0800
Message-ID: <200901100033.n0A0XEd1007172__19646.7535257854$1231547723$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755925AbZAJAdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 19:33:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linux-arch@vger.kernel.org, takata@linux-m32r.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     unaligned: wire up h8300 and m32r arches
has been removed from the -mm tree.  Its filename was
     unaligned-wire-up-h8300-and-m32r-arches.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unaligned: wire up h8300 and m32r arches
From: Harvey Harrison <harvey.harrison@gmail.com>

Provide arch overrides using memmove to avoid any functional changes.  At
a later time these arches should be able to just use the common header
directly, but this is not certain currently.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/unaligned.h |   51 ++++++++++++++++++++--
 include/asm-m32r/unaligned.h       |   60 +++++++++++++++++++++------
 2 files changed, 93 insertions(+), 18 deletions(-)

diff -puN arch/h8300/include/asm/unaligned.h~unaligned-wire-up-h8300-and-m32r-arches arch/h8300/include/asm/unaligned.h
--- a/arch/h8300/include/asm/unaligned.h~unaligned-wire-up-h8300-and-m32r-arches
+++ a/arch/h8300/include/asm/unaligned.h
@@ -1,11 +1,52 @@
 #ifndef _ASM_H8300_UNALIGNED_H
 #define _ASM_H8300_UNALIGNED_H
 
-#include <linux/unaligned/be_memmove.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
 
+static inline u16 __arch_load_cpu16_noalign(const void *p)
+{
+	u16 tmp;
+	memmove(&tmp, p, 2);
+	return tmp;
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+static inline u32 __arch_load_cpu32_noalign(const void *p)
+{
+	u32 tmp;
+	memmove(&tmp, p, 4);
+	return tmp;
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u64 __arch_load_cpu16_noalign(const void *p)
+{
+	u64 tmp;
+	memmove(&tmp, p, 8);
+	return tmp;
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+static inline void __arch_store_cpu16_noalign(void *p, u16 val)
+{
+	memmove(p, &val, 2);
+}
+#define __arch_store_cpu16_noalign __arch_store_cpu16_noalign
+
+static inline void __arch_store_cpu32_noalign(void *p, u32 val)
+{
+	memmove(p, &val, 4);
+}
+#define __arch_store_cpu32_noalign __arch_store_cpu32_noalign
+
+static inline void __arch_store_cpu64_noalign(void *p, u64 val)
+{
+	memmove(p, &val, 8);
+}
+#define __arch_store_cpu64_noalign __arch_store_cpu64_noalign
+
+#include <linux/unaligned.h>
 #endif /* _ASM_H8300_UNALIGNED_H */
diff -puN include/asm-m32r/unaligned.h~unaligned-wire-up-h8300-and-m32r-arches include/asm-m32r/unaligned.h
--- a/include/asm-m32r/unaligned.h~unaligned-wire-up-h8300-and-m32r-arches
+++ a/include/asm-m32r/unaligned.h
@@ -1,18 +1,52 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-#if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#endif
+#include <linux/kernel.h>
+#include <linux/string.h>
 
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
+
+static inline u16 __arch_load_cpu16_noalign(const void *p)
+{
+	u16 tmp;
+	memmove(&tmp, p, 2);
+	return tmp;
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+static inline u32 __arch_load_cpu32_noalign(const void *p)
+{
+	u32 tmp;
+	memmove(&tmp, p, 4);
+	return tmp;
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u64 __arch_load_cpu16_noalign(const void *p)
+{
+	u64 tmp;
+	memmove(&tmp, p, 8);
+	return tmp;
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+static inline void __arch_store_cpu16_noalign(void *p, u16 val)
+{
+	memmove(p, &val, 2);
+}
+#define __arch_store_cpu16_noalign __arch_store_cpu16_noalign
+
+static inline void __arch_store_cpu32_noalign(void *p, u32 val)
+{
+	memmove(p, &val, 4);
+}
+#define __arch_store_cpu32_noalign __arch_store_cpu32_noalign
+
+static inline void __arch_store_cpu64_noalign(void *p, u64 val)
+{
+	memmove(p, &val, 8);
+}
+#define __arch_store_cpu64_noalign __arch_store_cpu64_noalign
+
+#include <linux/unaligned.h>
 #endif /* _ASM_M32R_UNALIGNED_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
memstick-annotate-endianness-of-attribute-structs.patch

