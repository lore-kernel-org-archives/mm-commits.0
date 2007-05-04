From: akpm@linux-foundation.org
Subject: + lib-hexdump-update-on-feedback.patch added to -mm tree
Date: Fri, 04 May 2007 15:03:16 -0700
Message-ID: <200705042203.l44M3GcV020003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422772AbXEDWDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 18:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     lib/hexdump update on feedback
has been added to the -mm tree.  Its filename is
     lib-hexdump-update-on-feedback.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib/hexdump update on feedback
From: Randy Dunlap <randy.dunlap@oracle.com>

Rename hex_dumper() to hex_dump_to_buffer().
Rename hextoasc() macro to hex_asc()
	[remove conflicts with sky/skfp/skge drivers].
Change output format to remove '-' in middle of ASCII output and
	add space between hex and ASCII output.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 +--
 lib/hexdump.c          |   40 +++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff -puN include/linux/kernel.h~lib-hexdump-update-on-feedback include/linux/kernel.h
--- a/include/linux/kernel.h~lib-hexdump-update-on-feedback
+++ a/include/linux/kernel.h
@@ -218,11 +218,11 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
-extern void hex_dumper(const void *buf, size_t len, char *linebuf,
+extern void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
 				size_t linebuflen);
 extern void print_hex_dump(const char *level, int prefix_type,
 				void *buf, size_t len);
-#define hextoasc(x)	"0123456789abcdef"[x]
+#define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
diff -puN lib/hexdump.c~lib-hexdump-update-on-feedback lib/hexdump.c
--- a/lib/hexdump.c~lib-hexdump-update-on-feedback
+++ a/lib/hexdump.c
@@ -13,26 +13,27 @@
 #include <linux/module.h>
 
 /**
- * hex_dumper - convert a blob of data to "hex ASCII" in memory
+ * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  *
- * hex_dumper() works on one "line" of output at a time, i.e.,
+ * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
  * 16 bytes of input data converted to hex + ASCII output.
  *
- * Given a buffer of u8 data, hex_dumper() converts the input data to a
- * hex + ASCII dump at the supplied memory location.
+ * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
+ * to a hex + ASCII dump at the supplied memory location.
  * The converted output is always NUL-terminated.
  *
  * E.g.:
- *	hex_dumper(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *	hex_dump_to_buffer(frame->data, frame->len, linebuf, sizeof(linebuf));
  *
- * Prints the offsets of the block of memory, not addresses:
- * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ * example output buffer:
+ * 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
  */
-void hex_dumper(const void *buf, size_t len, char *linebuf, size_t linebuflen)
+void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
+			size_t linebuflen)
 {
 	const u8 *ptr = buf;
 	u8 ch;
@@ -42,19 +43,18 @@ void hex_dumper(const void *buf, size_t 
 		if (j && !(j % 4))
 			linebuf[lx++] = ' ';
 		ch = ptr[j];
-		linebuf[lx++] = hextoasc(ch >> 4);
-		linebuf[lx++] = hextoasc(ch & 0x0f);
+		linebuf[lx++] = hex_asc(ch >> 4);
+		linebuf[lx++] = hex_asc(ch & 0x0f);
 	}
-	if (lx < linebuflen)
-		linebuf[lx++] = '-';
-	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++) {
-		linebuf[lx++] = isprint(ptr[j]) ?  ptr[j] : '.';
-		if (j == 7)
-			linebuf[lx++] = ' ';
+	if ((lx + 2) < linebuflen) {
+		linebuf[lx++] = ' ';
+		linebuf[lx++] = ' ';
 	}
+	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
+		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
 	linebuf[lx++] = '\0';
 }
-EXPORT_SYMBOL(hex_dumper);
+EXPORT_SYMBOL(hex_dump_to_buffer);
 
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
@@ -72,9 +72,9 @@ EXPORT_SYMBOL(hex_dumper);
  *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
  *
  * Example output using %DUMP_PREFIX_OFFSET:
- * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
  * Example output using %DUMP_PREFIX_ADDRESS:
- * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.
+ * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f  pqrstuvwxyz{|}~.
  */
 void print_hex_dump(const char *level, int prefix_type, void *buf, size_t len)
 {
@@ -85,7 +85,7 @@ void print_hex_dump(const char *level, i
 	for (i = 0; i < len; i += 16) {
 		linelen = min(remaining, 16);
 		remaining -= 16;
-		hex_dumper(ptr + i, linelen, linebuf, sizeof(linebuf));
+		hex_dump_to_buffer(ptr + i, linelen, linebuf, sizeof(linebuf));
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
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
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
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
lib-hexdump-update-on-feedback.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
