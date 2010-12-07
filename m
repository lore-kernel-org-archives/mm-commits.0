From: akpm@linux-foundation.org
Subject: + include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch added to -mm tree
Date: Tue, 07 Dec 2010 15:29:59 -0800
Message-ID: <201012072329.oB7NTxOp014445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab0LGXaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 18:30:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     include/linux/printk.h lib/hexdump.c: neatening and add CONFIG_PRINTK guard
has been added to the -mm tree.  Its filename is
     include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -140,20 +140,6 @@ static inline void log_buf_kexec_setup(v
 
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
@@ -285,4 +271,32 @@ extern void print_hex_dump_bytes(const c
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

linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
include-linux-printkh-move-console-functions-and-variables-together.patch
include-linux-printkh-use-space-after-define.patch
include-linux-printkh-use-and-neaten-no_printk.patch
include-linux-printkh-add-pr_level_once-macros.patch
include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch
include-linux-printkh-organize-printk_ratelimited-macros.patch
include-linux-printkh-use-tab-not-spaces-for-indent.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

