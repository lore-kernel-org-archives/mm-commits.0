From: akpm@linux-foundation.org
Subject: - lib-hexdump.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:39 -0700
Message-ID: <200705120533.l4C5XdXH002131@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbXELFeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lib/hexdump
has been removed from the -mm tree.  Its filename was
     lib-hexdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib/hexdump
From: Randy Dunlap <randy.dunlap@oracle.com>

Based on ace_dump_mem() from Grant Likely for the Xilinx SystemACE
CompactFlash interface.

Add print_hex_dump() & hex_dumper() to lib/hexdump.c and linux/kernel.h.

This patch adds the functions print_hex_dump() & hex_dumper(). 
print_hex_dump() can be used to perform a hex + ASCII dump of data to
syslog, in an easily viewable format, thus providing a common text hex dump
format.

hex_dumper() provides a dump-to-memory function.  It converts one "line" of
output (16 bytes of input) at a time.

Example usages:
	print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
	hex_dumper(frame->data, frame->len, linebuf, sizeof(linebuf));

Example output using %DUMP_PREFIX_OFFSET:
0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
Example output using %DUMP_PREFIX_ADDRESS:
ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.

[akpm@linux-foundation.org: cleanups, add export]
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   11 ++++
 lib/Makefile           |    2 
 lib/hexdump.c          |  104 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~lib-hexdump include/linux/kernel.h
--- a/include/linux/kernel.h~lib-hexdump
+++ a/include/linux/kernel.h
@@ -213,6 +213,17 @@ extern enum system_states {
 
 extern void dump_stack(void);
 
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
+				size_t linebuflen);
+extern void print_hex_dump(const char *level, int prefix_type,
+				void *buf, size_t len);
+#define hex_asc(x)	"0123456789abcdef"[x]
+
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt,arg...) \
diff -puN lib/Makefile~lib-hexdump lib/Makefile
--- a/lib/Makefile~lib-hexdump
+++ a/lib/Makefile
@@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o
+	 bust_spinlocks.o hexdump.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/hexdump.c
--- /dev/null
+++ a/lib/hexdump.c
@@ -0,0 +1,104 @@
+/*
+ * lib/hexdump.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation. See README and COPYING for
+ * more details.
+ */
+
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+/**
+ * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ * @linebuf: where to put the converted data
+ * @linebuflen: total size of @linebuf, including space for terminating NUL
+ *
+ * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
+ * 16 bytes of input data converted to hex + ASCII output.
+ *
+ * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
+ * to a hex + ASCII dump at the supplied memory location.
+ * The converted output is always NUL-terminated.
+ *
+ * E.g.:
+ *	hex_dump_to_buffer(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *
+ * example output buffer:
+ * 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
+ */
+void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
+			size_t linebuflen)
+{
+	const u8 *ptr = buf;
+	u8 ch;
+	int j, lx = 0;
+
+	for (j = 0; (j < 16) && (j < len) && (lx + 3) < linebuflen; j++) {
+		if (j && !(j % 4))
+			linebuf[lx++] = ' ';
+		ch = ptr[j];
+		linebuf[lx++] = hex_asc(ch >> 4);
+		linebuf[lx++] = hex_asc(ch & 0x0f);
+	}
+	if ((lx + 2) < linebuflen) {
+		linebuf[lx++] = ' ';
+		linebuf[lx++] = ' ';
+	}
+	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
+		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
+	linebuf[lx++] = '\0';
+}
+EXPORT_SYMBOL(hex_dump_to_buffer);
+
+/**
+ * print_hex_dump - print a text hex dump to syslog for a binary blob of data
+ * @level: kernel log level (e.g. KERN_DEBUG)
+ * @prefix_type: controls whether prefix of an offset, address, or none
+ *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ *
+ * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
+ * to the kernel log at the specified kernel log level, with an optional
+ * leading prefix.
+ *
+ * E.g.:
+ *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
+ *
+ * Example output using %DUMP_PREFIX_OFFSET:
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
+ * Example output using %DUMP_PREFIX_ADDRESS:
+ * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f  pqrstuvwxyz{|}~.
+ */
+void print_hex_dump(const char *level, int prefix_type, void *buf, size_t len)
+{
+	u8 *ptr = buf;
+	int i, linelen, remaining = len;
+	unsigned char linebuf[100];
+
+	for (i = 0; i < len; i += 16) {
+		linelen = min(remaining, 16);
+		remaining -= 16;
+		hex_dump_to_buffer(ptr + i, linelen, linebuf, sizeof(linebuf));
+
+		switch (prefix_type) {
+		case DUMP_PREFIX_ADDRESS:
+			printk("%s%*p: %s\n", level,
+				(int)(2 * sizeof(void *)), ptr + i, linebuf);
+			break;
+		case DUMP_PREFIX_OFFSET:
+			printk("%s%.8x: %s\n", level, i, linebuf);
+			break;
+		default:
+			printk("%s%s\n", level, linebuf);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(print_hex_dump);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-kstrndup.patch
add-argv_split.patch
add-argv_split-fix.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit.patch
profile-likely-unlikely-macros.patch
