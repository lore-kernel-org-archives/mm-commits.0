From: akpm@linux-foundation.org
Subject: - hexdump-use-const-notation.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:22:53 -0700
Message-ID: <200708092022.l79KMrFg017681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXHIUXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dedekind@yandex.ru, Artem.Bityutskiy@nokia.com, mm-commits@vger.kernel.org


The patch titled
     hexdump: use const notation
has been removed from the -mm tree.  Its filename was
     hexdump-use-const-notation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: hexdump: use const notation
From: Artem Bityutskiy <dedekind@yandex.ru>

Mark the buffer to hexdump as const so callers could avoid casting their
const buffers when calling print_hex_dump().

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~hexdump-use-const-notation include/linux/kernel.h
--- a/include/linux/kernel.h~hexdump-use-const-notation
+++ a/include/linux/kernel.h
@@ -229,7 +229,7 @@ extern void hex_dump_to_buffer(const voi
 				char *linebuf, size_t linebuflen, bool ascii);
 extern void print_hex_dump(const char *level, const char *prefix_str,
 				int prefix_type, int rowsize, int groupsize,
-				void *buf, size_t len, bool ascii);
+				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
diff -puN lib/hexdump.c~hexdump-use-const-notation lib/hexdump.c
--- a/lib/hexdump.c~hexdump-use-const-notation
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
 
_

Patches currently in -mm which might be from dedekind@yandex.ru are

hexdump-use-const-notation.patch
