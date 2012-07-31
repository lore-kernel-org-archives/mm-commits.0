From: akpm@linux-foundation.org
Subject: [merged] printk-add-generic-functions-to-find-kern_level-headers.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:22 -0700
Message-ID: <20120731184922.C280810007D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab2GaStX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:23 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay.sievers@vrfy.org, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add generic functions to find KERN_<LEVEL> headers
has been removed from the -mm tree.  Its filename was
     printk-add-generic-functions-to-find-kern_level-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: add generic functions to find KERN_<LEVEL> headers

The current form of a KERN_<LEVEL> is "<.>".

Add printk_get_level and printk_skip_level functions to handle these
formats.

These functions centralize tests of KERN_<LEVEL> so a future modification
can change the KERN_<LEVEL> style and shorten the number of bytes consumed
by these headers.

[akpm@linux-foundation.org: fix build error and warning]
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   26 ++++++++++++++++++++++++++
 kernel/printk.c        |   14 +++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff -puN include/linux/printk.h~printk-add-generic-functions-to-find-kern_level-headers include/linux/printk.h
--- a/include/linux/printk.h~printk-add-generic-functions-to-find-kern_level-headers
+++ a/include/linux/printk.h
@@ -24,6 +24,32 @@ extern const char linux_proc_banner[];
  */
 #define KERN_CONT	"<c>"
 
+static inline int printk_get_level(const char *buffer)
+{
+	if (buffer[0] == '<' && buffer[1] && buffer[2] == '>') {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+		case 'c':	/* KERN_CONT */
+			return buffer[1];
+		}
+	}
+	return 0;
+}
+
+static inline const char *printk_skip_level(const char *buffer)
+{
+	if (printk_get_level(buffer)) {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+		case 'c':	/* KERN_CONT */
+			return buffer + 3;
+		}
+	}
+	return buffer;
+}
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
diff -puN kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers kernel/printk.c
--- a/kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers
+++ a/kernel/printk.c
@@ -1487,6 +1487,7 @@ asmlinkage int vprintk_emit(int facility
 	size_t text_len;
 	enum log_flags lflags = 0;
 	unsigned long flags;
+	int kern_level;
 	int this_cpu;
 	int printed_len = 0;
 
@@ -1543,17 +1544,20 @@ asmlinkage int vprintk_emit(int facility
 	}
 
 	/* strip syslog prefix and extract log level or control flags */
-	if (text[0] == '<' && text[1] && text[2] == '>') {
-		switch (text[1]) {
+	kern_level = printk_get_level(text);
+	if (kern_level) {
+		const char *end_of_header = printk_skip_level(text);
+		switch (kern_level) {
 		case '0' ... '7':
 			if (level == -1)
-				level = text[1] - '0';
+				level = kern_level - '0';
 		case 'd':	/* KERN_DEFAULT */
 			lflags |= LOG_PREFIX;
 		case 'c':	/* KERN_CONT */
-			text += 3;
-			text_len -= 3;
+			break;
 		}
+		text_len -= end_of_header - text;
+		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

