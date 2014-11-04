From: akpm@linux-foundation.org
Subject: +
 printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch
 added to -mm tree
Date: Tue, 04 Nov 2014 13:57:48 -0800
Message-ID: <54594bdc.mWoOAMUwsF+KKdLI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaKDV5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 16:57:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, jbaron@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add and use LOGLEVEL_<level> defines for KERN_<LEVEL> equivalents
has been added to the -mm tree.  Its filename is
     printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: add and use LOGLEVEL_<level> defines for KERN_<LEVEL> equivalents

Use #defines instead of magic values.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/debug.c |    2 +-
 include/linux/kern_levels.h |   13 +++++++++++++
 kernel/printk/printk.c      |   28 +++++++++++++---------------
 lib/dynamic_debug.c         |    4 ++--
 4 files changed, 29 insertions(+), 18 deletions(-)

diff -puN drivers/usb/storage/debug.c~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents drivers/usb/storage/debug.c
--- a/drivers/usb/storage/debug.c~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents
+++ a/drivers/usb/storage/debug.c
@@ -186,7 +186,7 @@ int usb_stor_dbg(const struct us_data *u
 
 	va_start(args, fmt);
 
-	r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
+	r = dev_vprintk_emit(LOGLEVEL_DEBUG, &us->pusb_dev->dev, fmt, args);
 
 	va_end(args);
 
diff -puN include/linux/kern_levels.h~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents include/linux/kern_levels.h
--- a/include/linux/kern_levels.h~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents
+++ a/include/linux/kern_levels.h
@@ -22,4 +22,17 @@
  */
 #define KERN_CONT	""
 
+/* integer equivalents of KERN_<LEVEL> */
+#define LOGLEVEL_SCHED		-2	/* Deferred messages from sched code
+					 * are set to this special level */
+#define LOGLEVEL_DEFAULT	-1	/* default (or last) loglevel */
+#define LOGLEVEL_EMERG		0	/* system is unusable */
+#define LOGLEVEL_ALERT		1	/* action must be taken immediately */
+#define LOGLEVEL_CRIT		2	/* critical conditions */
+#define LOGLEVEL_ERR		3	/* error conditions */
+#define LOGLEVEL_WARNING	4	/* warning conditions */
+#define LOGLEVEL_NOTICE		5	/* normal but significant condition */
+#define LOGLEVEL_INFO		6	/* informational */
+#define LOGLEVEL_DEBUG		7	/* debug-level messages */
+
 #endif
diff -puN kernel/printk/printk.c~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents
+++ a/kernel/printk/printk.c
@@ -62,9 +62,6 @@ int console_printk[4] = {
 	CONSOLE_LOGLEVEL_DEFAULT,	/* default_console_loglevel */
 };
 
-/* Deferred messaged from sched code are marked by this special level */
-#define SCHED_MESSAGE_LOGLEVEL -2
-
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -1259,7 +1256,7 @@ static int syslog_print_all(char __user
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	bool clear = false;
-	static int saved_console_loglevel = -1;
+	static int saved_console_loglevel = LOGLEVEL_DEFAULT;
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -1316,15 +1313,15 @@ int do_syslog(int type, char __user *buf
 		break;
 	/* Disable logging to console */
 	case SYSLOG_ACTION_CONSOLE_OFF:
-		if (saved_console_loglevel == -1)
+		if (saved_console_loglevel == LOGLEVEL_DEFAULT)
 			saved_console_loglevel = console_loglevel;
 		console_loglevel = minimum_console_loglevel;
 		break;
 	/* Enable logging to console */
 	case SYSLOG_ACTION_CONSOLE_ON:
-		if (saved_console_loglevel != -1) {
+		if (saved_console_loglevel != LOGLEVEL_DEFAULT) {
 			console_loglevel = saved_console_loglevel;
-			saved_console_loglevel = -1;
+			saved_console_loglevel = LOGLEVEL_DEFAULT;
 		}
 		break;
 	/* Set level of messages printed to console */
@@ -1336,7 +1333,7 @@ int do_syslog(int type, char __user *buf
 			len = minimum_console_loglevel;
 		console_loglevel = len;
 		/* Implicitly re-enable logging to console */
-		saved_console_loglevel = -1;
+		saved_console_loglevel = LOGLEVEL_DEFAULT;
 		error = 0;
 		break;
 	/* Number of chars in the log buffer */
@@ -1629,8 +1626,8 @@ asmlinkage int vprintk_emit(int facility
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
-	if (level == SCHED_MESSAGE_LOGLEVEL) {
-		level = -1;
+	if (level == LOGLEVEL_SCHED) {
+		level = LOGLEVEL_DEFAULT;
 		in_sched = true;
 	}
 
@@ -1695,8 +1692,9 @@ asmlinkage int vprintk_emit(int facility
 			const char *end_of_header = printk_skip_level(text);
 			switch (kern_level) {
 			case '0' ... '7':
-				if (level == -1)
+				if (level == LOGLEVEL_DEFAULT)
 					level = kern_level - '0';
+				/* fallthrough */
 			case 'd':	/* KERN_DEFAULT */
 				lflags |= LOG_PREFIX;
 			}
@@ -1710,7 +1708,7 @@ asmlinkage int vprintk_emit(int facility
 		}
 	}
 
-	if (level == -1)
+	if (level == LOGLEVEL_DEFAULT)
 		level = default_message_loglevel;
 
 	if (dict)
@@ -1788,7 +1786,7 @@ EXPORT_SYMBOL(vprintk_emit);
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	return vprintk_emit(0, -1, NULL, 0, fmt, args);
+	return vprintk_emit(0, LOGLEVEL_DEFAULT, NULL, 0, fmt, args);
 }
 EXPORT_SYMBOL(vprintk);
 
@@ -1842,7 +1840,7 @@ asmlinkage __visible int printk(const ch
 	}
 #endif
 	va_start(args, fmt);
-	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+	r = vprintk_emit(0, LOGLEVEL_DEFAULT, NULL, 0, fmt, args);
 	va_end(args);
 
 	return r;
@@ -2631,7 +2629,7 @@ int printk_deferred(const char *fmt, ...
 
 	preempt_disable();
 	va_start(args, fmt);
-	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
+	r = vprintk_emit(0, LOGLEVEL_SCHED, NULL, 0, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
diff -puN lib/dynamic_debug.c~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents
+++ a/lib/dynamic_debug.c
@@ -576,7 +576,7 @@ void __dynamic_dev_dbg(struct _ddebug *d
 	} else {
 		char buf[PREFIX_SIZE];
 
-		dev_printk_emit(7, dev, "%s%s %s: %pV",
+		dev_printk_emit(LOGLEVEL_DEBUG, dev, "%s%s %s: %pV",
 				dynamic_emit_prefix(descriptor, buf),
 				dev_driver_string(dev), dev_name(dev),
 				&vaf);
@@ -605,7 +605,7 @@ void __dynamic_netdev_dbg(struct _ddebug
 	if (dev && dev->dev.parent) {
 		char buf[PREFIX_SIZE];
 
-		dev_printk_emit(7, dev->dev.parent,
+		dev_printk_emit(LOGLEVEL_DEBUG, dev->dev.parent,
 				"%s%s %s %s%s: %pV",
 				dynamic_emit_prefix(descriptor, buf),
 				dev_driver_string(dev->dev.parent),
_

Patches currently in -mm which might be from joe@perches.com are

printk-remove-used-once-early_vprintk.patch
tile-neaten-early_printk-uses.patch
tile-use-pr_warn-instead-of-pr_warning.patch
printk-add-and-use-loglevel_level-defines-for-kern_level-equivalents.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

