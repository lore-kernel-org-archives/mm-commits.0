From: akpm@linux-foundation.org
Subject: - hexdump-more-output-formatting.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:35 -0700
Message-ID: <200706121857.l5CIvZ4X018485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbXFLTFn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:05:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     hexdump: more output formatting
has been removed from the -mm tree.  Its filename was
     hexdump-more-output-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hexdump: more output formatting
From: Randy Dunlap <randy.dunlap@oracle.com>

Add a prefix string parameter.  Callers are responsible for any string
length/alignment that they want to see in the output.  I.e., callers should
pad strings to achieve alignment if they want that.

Add rowsize parameter.  This is the number of raw data bytes to be printed
per line.  Must be 16 or 32.

Add a groupsize parameter.  This allows callers to dump values as 1-byte,
2-byte, 4-byte, or 8-byte numbers.  Default is 1-byte numbers.  If the
total length is not an even multiple of groupsize, 1-byte numbers are
printed.

Add an "ascii" output parameter.  This causes ASCII data output following
the hex data output.

Clean up some doc examples.

Align the ASCII output on all lines that are produced by one call.

Add a new interface, print_hex_dump_bytes(), that is a shortcut to
print_hex_dump(), using default parameter values to print 16 bytes in
byte-size chunks of hex + ASCII output, using printk level KERN_DEBUG.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   12 ++-
 lib/hexdump.c          |  149 +++++++++++++++++++++++++++++++--------
 2 files changed, 129 insertions(+), 32 deletions(-)

diff -puN include/linux/kernel.h~hexdump-more-output-formatting include/linux/kernel.h
--- a/include/linux/kernel.h~hexdump-more-output-formatting
+++ a/include/linux/kernel.h
@@ -218,10 +218,14 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
-extern void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
-				size_t linebuflen);
-extern void print_hex_dump(const char *level, int prefix_type,
-				void *buf, size_t len);
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+				int rowsize, int groupsize,
+				char *linebuf, size_t linebuflen, bool ascii);
+extern void print_hex_dump(const char *level, const char *prefix_str,
+				int prefix_type, int rowsize, int groupsize,
+				void *buf, size_t len, bool ascii);
+extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+			void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
diff -puN lib/hexdump.c~hexdump-more-output-formatting lib/hexdump.c
--- a/lib/hexdump.c~hexdump-more-output-formatting
+++ a/lib/hexdump.c
@@ -16,42 +16,98 @@
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
+ * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
+ * @ascii: include ASCII after the hex output
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
- * 16 bytes of input data converted to hex + ASCII output.
+ * 16 or 32 bytes of input data converted to hex + ASCII output.
  *
  * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
  * to a hex + ASCII dump at the supplied memory location.
  * The converted output is always NUL-terminated.
  *
  * E.g.:
- *	hex_dump_to_buffer(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *   hex_dump_to_buffer(frame->data, frame->len, 16, 1,
+ *			linebuf, sizeof(linebuf), 1);
  *
  * example output buffer:
- * 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
+ * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
  */
-void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
-			size_t linebuflen)
+void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
+			int groupsize, char *linebuf, size_t linebuflen,
+			bool ascii)
 {
 	const u8 *ptr = buf;
 	u8 ch;
 	int j, lx = 0;
+	int ascii_column;
 
-	for (j = 0; (j < 16) && (j < len) && (lx + 3) < linebuflen; j++) {
-		if (j && !(j % 4))
+	if (rowsize != 16 && rowsize != 32)
+		rowsize = 16;
+
+	if (!len)
+		goto nil;
+	if (len > rowsize)		/* limit to one line at a time */
+		len = rowsize;
+	if ((len % groupsize) != 0)	/* no mixed size output */
+		groupsize = 1;
+
+	switch (groupsize) {
+	case 8: {
+		const u64 *ptr8 = buf;
+		int ngroups = len / groupsize;
+
+		for (j = 0; j < ngroups; j++)
+			lx += scnprintf(linebuf + lx, linebuflen - lx,
+				"%16.16llx ", (unsigned long long)*(ptr8 + j));
+		ascii_column = 17 * ngroups + 2;
+		break;
+	}
+
+	case 4: {
+		const u32 *ptr4 = buf;
+		int ngroups = len / groupsize;
+
+		for (j = 0; j < ngroups; j++)
+			lx += scnprintf(linebuf + lx, linebuflen - lx,
+				"%8.8x ", *(ptr4 + j));
+		ascii_column = 9 * ngroups + 2;
+		break;
+	}
+
+	case 2: {
+		const u16 *ptr2 = buf;
+		int ngroups = len / groupsize;
+
+		for (j = 0; j < ngroups; j++)
+			lx += scnprintf(linebuf + lx, linebuflen - lx,
+				"%4.4x ", *(ptr2 + j));
+		ascii_column = 5 * ngroups + 2;
+		break;
+	}
+
+	default:
+		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
+		     j++) {
+			ch = ptr[j];
+			linebuf[lx++] = hex_asc(ch >> 4);
+			linebuf[lx++] = hex_asc(ch & 0x0f);
 			linebuf[lx++] = ' ';
-		ch = ptr[j];
-		linebuf[lx++] = hex_asc(ch >> 4);
-		linebuf[lx++] = hex_asc(ch & 0x0f);
+		}
+		ascii_column = 3 * rowsize + 2;
+		break;
 	}
-	if ((lx + 2) < linebuflen) {
-		linebuf[lx++] = ' ';
+	if (!ascii)
+		goto nil;
+
+	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
 		linebuf[lx++] = ' ';
-	}
-	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
+	for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
 		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
+nil:
 	linebuf[lx++] = '\0';
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
@@ -59,46 +115,83 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
  * @level: kernel log level (e.g. KERN_DEBUG)
+ * @prefix_str: string to prefix each line with;
+ *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
  *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
+ * @ascii: include ASCII after the hex output
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
  * leading prefix.
  *
+ * print_hex_dump() works on one "line" of output at a time, i.e.,
+ * 16 or 32 bytes of input data converted to hex + ASCII output.
+ * print_hex_dump() iterates over the entire input @buf, breaking it into
+ * "line size" chunks to format and print.
+ *
  * E.g.:
- *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
+ *   print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
+ *		16, 1, frame->data, frame->len, 1);
  *
- * Example output using %DUMP_PREFIX_OFFSET:
- * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
- * Example output using %DUMP_PREFIX_ADDRESS:
- * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f  pqrstuvwxyz{|}~.
+ * Example output using %DUMP_PREFIX_OFFSET and 1-byte mode:
+ * 0009ab42: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
+ * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
+ * ffffffff88089af0: 73727170 77767574 7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
  */
-void print_hex_dump(const char *level, int prefix_type, void *buf, size_t len)
+void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
+			int rowsize, int groupsize,
+			void *buf, size_t len, bool ascii)
 {
 	u8 *ptr = buf;
 	int i, linelen, remaining = len;
-	unsigned char linebuf[100];
+	unsigned char linebuf[200];
 
-	for (i = 0; i < len; i += 16) {
-		linelen = min(remaining, 16);
-		remaining -= 16;
-		hex_dump_to_buffer(ptr + i, linelen, linebuf, sizeof(linebuf));
+	if (rowsize != 16 && rowsize != 32)
+		rowsize = 16;
+
+	for (i = 0; i < len; i += rowsize) {
+		linelen = min(remaining, rowsize);
+		remaining -= rowsize;
+		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
+				linebuf, sizeof(linebuf), ascii);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
-			printk("%s%*p: %s\n", level,
+			printk("%s%s%*p: %s\n", level, prefix_str,
 				(int)(2 * sizeof(void *)), ptr + i, linebuf);
 			break;
 		case DUMP_PREFIX_OFFSET:
-			printk("%s%.8x: %s\n", level, i, linebuf);
+			printk("%s%s%.8x: %s\n", level, prefix_str, i, linebuf);
 			break;
 		default:
-			printk("%s%s\n", level, linebuf);
+			printk("%s%s%s\n", level, prefix_str, linebuf);
 			break;
 		}
 	}
 }
 EXPORT_SYMBOL(print_hex_dump);
+
+/**
+ * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * @prefix_str: string to prefix each line with;
+ *  caller supplies trailing spaces for alignment if desired
+ * @prefix_type: controls whether prefix of an offset, address, or none
+ *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ *
+ * Calls print_hex_dump(), with log level of KERN_DEBUG,
+ * rowsize of 16, groupsize of 1, and ASCII output included.
+ */
+void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+			void *buf, size_t len)
+{
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
+			buf, len, 1);
+}
+EXPORT_SYMBOL(print_hex_dump_bytes);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
toshica_acpi-fix-section-mismatch-in-allyesconfig.patch
git-acpi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-wireless.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
x86_64-use-null-for-pointer.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
