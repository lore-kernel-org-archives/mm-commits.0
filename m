From: akpm@linux-foundation.org
Subject: + lib-hexdump.patch added to -mm tree
Date: Thu, 03 May 2007 18:58:24 -0700
Message-ID: <200705040158.l441wOav027023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbXEDB6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     lib/hexdump
has been added to the -mm tree.  Its filename is
     lib-hexdump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   10 +++
 lib/Makefile           |    2 
 lib/hexdump.c          |  105 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~lib-hexdump include/linux/kernel.h
--- a/include/linux/kernel.h~lib-hexdump
+++ a/include/linux/kernel.h
@@ -213,6 +213,16 @@ extern enum system_states {
 
 extern void dump_stack(void);
 
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen);
+extern void print_hex_dump(const char *level, int prefix_type,
+				void *buf, size_t len);
+#define hextoasc(x)	"0123456789abcdef"[x]
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
@@ -0,0 +1,105 @@
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
+ * hex_dumper - convert a blob of data to "hex ASCII" in memory
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ * @linebuf: where to put the converted data
+ * @linebuflen: total size of @linebuf, including space for terminating NUL
+ *
+ * hex_dumper() works on one "line" of output at a time, i.e.,
+ * 16 bytes of input data converted to hex + ASCII output.
+ *
+ * Given a buffer of u8 data, hex_dumper() converts the input data to a
+ * hex + ASCII dump at the supplied memory location.
+ * The converted output is always NUL-terminated.
+ *
+ * E.g.:
+ *	hex_dumper(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *
+ * Prints the offsets of the block of memory, not addresses:
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ */
+void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen)
+{
+	const u8 *ptr = buf;
+	u8 ch;
+	int j, lx = 0;
+
+	for (j = 0; (j < 16) && (j < len) && (lx + 3) < linebuflen; j++) {
+		if (j && !(j % 4))
+			linebuf[lx++] = ' ';
+		ch = ptr[j];
+		linebuf[lx++] = hextoasc(ch >> 4);
+		linebuf[lx++] = hextoasc(ch & 0x0f);
+	}
+	if (lx < linebuflen)
+		linebuf[lx++] = '-';
+	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++) {
+		linebuf[lx++] = isprint(ptr[j]) ?  ptr[j] : '.';
+		if (j == 7)
+			linebuf[lx++] = ' ';
+	}
+	linebuf[lx++] = '\0';
+}
+EXPORT_SYMBOL(hex_dumper);
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
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ * Example output using %DUMP_PREFIX_ADDRESS:
+ * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.
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
+		hex_dumper(ptr + i, linelen, linebuf, sizeof(linebuf));
+
+		switch (prefix_type)
+		{
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
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-net.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
introduce-a-handy-list_first_entry-macro-v2.patch
add-pci_try_set_mwi.patch
consolidate-asm-consth-to-linux-consth.patch
x86_64-kill-19000-sparse-warnings.patch
move-log_buf_shift-to-a-more-sensible-place.patch
doc-fix-oops-tracing-duplicate.patch
docbook-librs-typo-fixes.patch
lib-hexdump.patch
lib-hexdump-fix.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
