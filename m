From: akpm@linux-foundation.org
Subject: + hex_dump-add-missing-const-qualifiers.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:24:06 -0700
Message-ID: <200708092024.l79KO6bN017804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbXHIU0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, Artem.Bityutskiy@nokia.com


The patch titled
     hex_dump: add missing "const" qualifiers
has been added to the -mm tree.  Its filename is
     hex_dump-add-missing-const-qualifiers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hex_dump: add missing "const" qualifiers
From: Alan Stern <stern@rowland.harvard.edu>

Add a couple of missing "const" qualifiers to the print_hex_dump library
routines.

(akpm: rumoured to fix some compile warning somewhere)

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 lib/hexdump.c          |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/kernel.h~hex_dump-add-missing-const-qualifiers include/linux/kernel.h
--- a/include/linux/kernel.h~hex_dump-add-missing-const-qualifiers
+++ a/include/linux/kernel.h
@@ -224,9 +224,9 @@ extern void hex_dump_to_buffer(const voi
 				char *linebuf, size_t linebuflen, bool ascii);
 extern void print_hex_dump(const char *level, const char *prefix_str,
 				int prefix_type, int rowsize, int groupsize,
-				void *buf, size_t len, bool ascii);
+				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			void *buf, size_t len);
+			const void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
diff -puN lib/hexdump.c~hex_dump-add-missing-const-qualifiers lib/hexdump.c
--- a/lib/hexdump.c~hex_dump-add-missing-const-qualifiers
+++ a/lib/hexdump.c
@@ -145,9 +145,9 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  */
 void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 			int rowsize, int groupsize,
-			void *buf, size_t len, bool ascii)
+			const void *buf, size_t len, bool ascii)
 {
-	u8 *ptr = buf;
+	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
 	unsigned char linebuf[200];
 
@@ -189,7 +189,7 @@ EXPORT_SYMBOL(print_hex_dump);
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			void *buf, size_t len)
+			const void *buf, size_t len)
 {
 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
 			buf, len, 1);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

hex_dump-add-missing-const-qualifiers.patch
nikon-d50-is-an-unusual-device.patch
usb-enable-hcd-support-on-sh-unconditionally.patch
usb-r8a66597-hcd-clean-up-error-path.patch
