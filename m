From: akpm@linux-foundation.org
Subject: [merged] printk-only-look-for-prefix-levels-in-kernel-messages.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:43 -0700
Message-ID: <20120731184943.B409C10007D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2GaStp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:45 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: only look for prefix levels in kernel messages
has been removed from the -mm tree.  Its filename was
     printk-only-look-for-prefix-levels-in-kernel-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: only look for prefix levels in kernel messages

vprintk_emit() prefix parsing should only be done for internal kernel
messages.  This allows existing behavior to be kept in all cases.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN kernel/printk.c~printk-only-look-for-prefix-levels-in-kernel-messages kernel/printk.c
--- a/kernel/printk.c~printk-only-look-for-prefix-levels-in-kernel-messages
+++ a/kernel/printk.c
@@ -1487,7 +1487,6 @@ asmlinkage int vprintk_emit(int facility
 	size_t text_len;
 	enum log_flags lflags = 0;
 	unsigned long flags;
-	int kern_level;
 	int this_cpu;
 	int printed_len = 0;
 
@@ -1543,21 +1542,24 @@ asmlinkage int vprintk_emit(int facility
 		lflags |= LOG_NEWLINE;
 	}
 
-	/* strip syslog prefix and extract log level or control flags */
-	kern_level = printk_get_level(text);
-	if (kern_level) {
-		const char *end_of_header = printk_skip_level(text);
-		switch (kern_level) {
-		case '0' ... '7':
-			if (level == -1)
-				level = kern_level - '0';
-		case 'd':	/* KERN_DEFAULT */
-			lflags |= LOG_PREFIX;
-		case 'c':	/* KERN_CONT */
-			break;
+	/* strip kernel syslog prefix and extract log level or control flags */
+	if (facility == 0) {
+		int kern_level = printk_get_level(text);
+
+		if (kern_level) {
+			const char *end_of_header = printk_skip_level(text);
+			switch (kern_level) {
+			case '0' ... '7':
+				if (level == -1)
+					level = kern_level - '0';
+			case 'd':	/* KERN_DEFAULT */
+				lflags |= LOG_PREFIX;
+			case 'c':	/* KERN_CONT */
+				break;
+			}
+			text_len -= end_of_header - text;
+			text = (char *)end_of_header;
 		}
-		text_len -= end_of_header - text;
-		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

