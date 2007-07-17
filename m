From: akpm@linux-foundation.org
Subject: - crc7-support.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:56 -0700
Message-ID: <200707172302.l6HN2u15011642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936713AbXGQXQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.nikitenko@gmail.com, dbrownell@users.sourceforge.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     CRC7 support
has been removed from the -mm tree.  Its filename was
     crc7-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRC7 support
From: Jan Nikitenko <jan.nikitenko@gmail.com>

Add CRC7 routines, used for example in MMC over SPI communication. 
Kerneldoc updates

[akpm@linux-foundation.org: fix funny mix of const and non-const]
Signed-off-by: Jan Nikitenko <jan.nikitenko@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    4 +
 include/linux/crc7.h                  |   14 ++++
 lib/Kconfig                           |    8 ++
 lib/Makefile                          |    1 
 lib/crc7.c                            |   68 ++++++++++++++++++++++++
 5 files changed, 94 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~crc7-support Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~crc7-support
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -139,8 +139,10 @@ X!Ilib/string.c
 !Elib/cmdline.c
      </sect1>
 
-     <sect1><title>CRC Functions</title>
+     <sect1 id="crc"><title>CRC Functions</title>
+!Elib/crc7.c
 !Elib/crc16.c
+!Elib/crc-itu-t.c
 !Elib/crc32.c
 !Elib/crc-ccitt.c
      </sect1>
diff -puN /dev/null include/linux/crc7.h
--- /dev/null
+++ a/include/linux/crc7.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_CRC7_H
+#define _LINUX_CRC7_H
+#include <linux/types.h>
+
+extern const u8 crc7_syndrome_table[256];
+
+static inline u8 crc7_byte(u8 crc, u8 data)
+{
+	return crc7_syndrome_table[(crc << 1) ^ data];
+}
+
+extern u8 crc7(u8 crc, const u8 *buffer, size_t len);
+
+#endif
diff -puN lib/Kconfig~crc7-support lib/Kconfig
--- a/lib/Kconfig~crc7-support
+++ a/lib/Kconfig
@@ -41,6 +41,14 @@ config CRC32
 	  kernel tree does. Such modules that use library CRC32 functions
 	  require M here.
 
+config CRC7
+	tristate "CRC7 functions"
+	help
+	  This option is provided for the case where no in-kernel-tree
+	  modules require CRC7 functions, but a module built outside
+	  the kernel tree does. Such modules that use library CRC7
+	  functions require M here.
+
 config LIBCRC32C
 	tristate "CRC32c (Castagnoli, et al) Cyclic Redundancy-Check"
 	help
diff -puN lib/Makefile~crc7-support lib/Makefile
--- a/lib/Makefile~crc7-support
+++ a/lib/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CRC_CCITT)	+= crc-ccitt.o
 obj-$(CONFIG_CRC16)	+= crc16.o
 obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
+obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
diff -puN /dev/null lib/crc7.c
--- /dev/null
+++ a/lib/crc7.c
@@ -0,0 +1,68 @@
+/*
+ *      crc7.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/crc7.h>
+
+
+/* Table for CRC-7 (polynomial x^7 + x^3 + 1) */
+const u8 crc7_syndrome_table[256] = {
+	0x00, 0x09, 0x12, 0x1b, 0x24, 0x2d, 0x36, 0x3f,
+	0x48, 0x41, 0x5a, 0x53, 0x6c, 0x65, 0x7e, 0x77,
+	0x19, 0x10, 0x0b, 0x02, 0x3d, 0x34, 0x2f, 0x26,
+	0x51, 0x58, 0x43, 0x4a, 0x75, 0x7c, 0x67, 0x6e,
+	0x32, 0x3b, 0x20, 0x29, 0x16, 0x1f, 0x04, 0x0d,
+	0x7a, 0x73, 0x68, 0x61, 0x5e, 0x57, 0x4c, 0x45,
+	0x2b, 0x22, 0x39, 0x30, 0x0f, 0x06, 0x1d, 0x14,
+	0x63, 0x6a, 0x71, 0x78, 0x47, 0x4e, 0x55, 0x5c,
+	0x64, 0x6d, 0x76, 0x7f, 0x40, 0x49, 0x52, 0x5b,
+	0x2c, 0x25, 0x3e, 0x37, 0x08, 0x01, 0x1a, 0x13,
+	0x7d, 0x74, 0x6f, 0x66, 0x59, 0x50, 0x4b, 0x42,
+	0x35, 0x3c, 0x27, 0x2e, 0x11, 0x18, 0x03, 0x0a,
+	0x56, 0x5f, 0x44, 0x4d, 0x72, 0x7b, 0x60, 0x69,
+	0x1e, 0x17, 0x0c, 0x05, 0x3a, 0x33, 0x28, 0x21,
+	0x4f, 0x46, 0x5d, 0x54, 0x6b, 0x62, 0x79, 0x70,
+	0x07, 0x0e, 0x15, 0x1c, 0x23, 0x2a, 0x31, 0x38,
+	0x41, 0x48, 0x53, 0x5a, 0x65, 0x6c, 0x77, 0x7e,
+	0x09, 0x00, 0x1b, 0x12, 0x2d, 0x24, 0x3f, 0x36,
+	0x58, 0x51, 0x4a, 0x43, 0x7c, 0x75, 0x6e, 0x67,
+	0x10, 0x19, 0x02, 0x0b, 0x34, 0x3d, 0x26, 0x2f,
+	0x73, 0x7a, 0x61, 0x68, 0x57, 0x5e, 0x45, 0x4c,
+	0x3b, 0x32, 0x29, 0x20, 0x1f, 0x16, 0x0d, 0x04,
+	0x6a, 0x63, 0x78, 0x71, 0x4e, 0x47, 0x5c, 0x55,
+	0x22, 0x2b, 0x30, 0x39, 0x06, 0x0f, 0x14, 0x1d,
+	0x25, 0x2c, 0x37, 0x3e, 0x01, 0x08, 0x13, 0x1a,
+	0x6d, 0x64, 0x7f, 0x76, 0x49, 0x40, 0x5b, 0x52,
+	0x3c, 0x35, 0x2e, 0x27, 0x18, 0x11, 0x0a, 0x03,
+	0x74, 0x7d, 0x66, 0x6f, 0x50, 0x59, 0x42, 0x4b,
+	0x17, 0x1e, 0x05, 0x0c, 0x33, 0x3a, 0x21, 0x28,
+	0x5f, 0x56, 0x4d, 0x44, 0x7b, 0x72, 0x69, 0x60,
+	0x0e, 0x07, 0x1c, 0x15, 0x2a, 0x23, 0x38, 0x31,
+	0x46, 0x4f, 0x54, 0x5d, 0x62, 0x6b, 0x70, 0x79
+};
+EXPORT_SYMBOL(crc7_syndrome_table);
+
+/**
+ * crc7 - update the CRC7 for the data buffer
+ * @crc:     previous CRC7 value
+ * @buffer:  data pointer
+ * @len:     number of bytes in the buffer
+ * Context: any
+ *
+ * Returns the updated CRC7 value.
+ */
+u8 crc7(u8 crc, const u8 *buffer, size_t len)
+{
+	while (len--)
+		crc = crc7_byte(crc, *buffer++);
+	return crc;
+}
+EXPORT_SYMBOL(crc7);
+
+MODULE_DESCRIPTION("CRC7 calculations");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jan.nikitenko@gmail.com are

origin.patch
