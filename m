From: akpm@linux-foundation.org
Subject: + printk-add-interfaces-for-external-access-to-the-log-buffer.patch added to -mm tree
Date: Tue, 31 Jul 2007 11:38:24 -0700
Message-ID: <200707311838.l6VIcO0s016441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56716 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932129AbXGaSjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 14:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, gerg@snapgear.com, lethal@linux-sh.org, rgetz@blackfin.uclinux.org, rmk@arm.linux.org.uk, tim.bird@am.sony.com, vapier@gentoo.org


The patch titled
     printk: add interfaces for external access to the log buffer
has been added to the -mm tree.  Its filename is
     printk-add-interfaces-for-external-access-to-the-log-buffer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: printk: add interfaces for external access to the log buffer
From: Mike Frysinger <vapier.adi@gmail.com>

Add two new functions for reading the kernel log buffer.  The intention is for
them to be used by recovery/dump/debug code so the kernel log can be easily
retrieved/parsed in a crash scenario, but they are generic enough for other
people to dream up other fun uses.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++
 kernel/printk.c        |   49 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff -puN include/linux/kernel.h~printk-add-interfaces-for-external-access-to-the-log-buffer include/linux/kernel.h
--- a/include/linux/kernel.h~printk-add-interfaces-for-external-access-to-the-log-buffer
+++ a/include/linux/kernel.h
@@ -157,6 +157,9 @@ asmlinkage int vprintk(const char *fmt, 
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
+extern int log_buf_get_len(void);
+extern int log_buf_read(int idx);
+extern int log_buf_copy(char *dest, int idx, int len);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -164,6 +167,9 @@ static inline int vprintk(const char *s,
 static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
+static inline int log_buf_get_len(void) { return 0; }
+static inline int log_buf_read(int idx); { return 0; }
+static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
 #endif
 
 unsigned long int_sqrt(unsigned long);
diff -puN kernel/printk.c~printk-add-interfaces-for-external-access-to-the-log-buffer kernel/printk.c
--- a/kernel/printk.c~printk-add-interfaces-for-external-access-to-the-log-buffer
+++ a/kernel/printk.c
@@ -220,6 +220,55 @@ static inline void boot_delay_msec(void)
 #endif
 
 /*
+ * Return the number of unread characters in the log buffer.
+ */
+int log_buf_get_len(void)
+{
+	return log_end - log_start;
+}
+
+/*
+ * Copy a range of characters from the log buffer.
+ */
+int log_buf_copy(char *dest, int idx, int len)
+{
+	int ret, max;
+
+	if (!oops_in_progress)
+		spin_lock_irq(&logbuf_lock);
+
+	max = log_buf_get_len();
+	if (idx < 0 || idx >= max)
+		ret = -1;
+	else {
+		if (len > max)
+			len = max;
+		ret = len;
+		while (len-- > 0) {
+			*dest = LOG_BUF(idx++);
+			++dest;
+		}
+	}
+
+	if (!oops_in_progress)
+		spin_unlock_irq(&logbuf_lock);
+
+	return ret;
+}
+
+/*
+ * Extract a single character from the log buffer.
+ */
+int log_buf_read(int idx)
+{
+	char ret;
+	if (log_buf_copy(&ret, idx, 1) == 1)
+		return ret;
+	else
+		return -1;
+}
+
+/*
  * Commands to do_syslog:
  *
  * 	0 -- Close the log.  Currently a NOP.
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
