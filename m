From: akpm@linux-foundation.org
Subject: [merged] include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:47 -0800
Message-ID: <201101132007.p0DK7SVB029814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933642Ab1AMUIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:08:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/printk.h lib/hexdump.c: neatening and add CONFIG_PRINTK guard
has been removed from the -mm tree.  Its filename was
     include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/printk.h lib/hexdump.c: neatening and add CONFIG_PRINTK guard
From: Joe Perches <joe@perches.com>

- Move prototypes and align arguments.

- Add CONFIG_PRINTK guard for print_hex functions

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   42 ++++++++++++++++++++++++++-------------
 lib/hexdump.c          |    2 +
 2 files changed, 30 insertions(+), 14 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard
+++ a/include/linux/printk.h
@@ -141,20 +141,6 @@ static inline void log_buf_kexec_setup(v
 
 extern void dump_stack(void) __cold;
 
-enum {
-	DUMP_PREFIX_NONE,
-	DUMP_PREFIX_ADDRESS,
-	DUMP_PREFIX_OFFSET
-};
-extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
-extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
-extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
-
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
@@ -286,4 +272,32 @@ extern void print_hex_dump_bytes(const c
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+			       int rowsize, int groupsize,
+			       char *linebuf, size_t linebuflen, bool ascii);
+#ifdef CONFIG_PRINTK
+extern void print_hex_dump(const char *level, const char *prefix_str,
+			   int prefix_type, int rowsize, int groupsize,
+			   const void *buf, size_t len, bool ascii);
+extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+				 const void *buf, size_t len);
+#else
+static inline void print_hex_dump(const char *level, const char *prefix_str,
+				  int prefix_type, int rowsize, int groupsize,
+				  const void *buf, size_t len, bool ascii)
+{
+}
+static inline void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
+					const void *buf, size_t len)
+{
+}
+
+#endif
+
 #endif
diff -puN lib/hexdump.c~include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard lib/hexdump.c
--- a/lib/hexdump.c~include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard
+++ a/lib/hexdump.c
@@ -154,6 +154,7 @@ nil:
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
+#ifdef CONFIG_PRINTK
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
  * @level: kernel log level (e.g. KERN_DEBUG)
@@ -238,3 +239,4 @@ void print_hex_dump_bytes(const char *pr
 		       buf, len, true);
 }
 EXPORT_SYMBOL(print_hex_dump_bytes);
+#endif
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

