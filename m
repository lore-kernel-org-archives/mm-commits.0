From: akpm@linux-foundation.org
Subject: [merged] kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:27 -0700
Message-ID: <51ba1617.AFQdsq4bPKUAx9/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3FMS52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, lists@nerdbynature.de, kay@vrfy.org, jwboyer@redhat.com, keescook@chromium.org

Subject: [merged] kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch removed from -mm tree
To: keescook@chromium.org,jwboyer@redhat.com,kay@vrfy.org,lists@nerdbynature.de,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:27 -0700


The patch titled
     Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
has been removed from the -mm tree.  Its filename was
     kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg

The dmesg_restrict sysctl currently covers the syslog method for access
dmesg, however /dev/kmsg isn't covered by the same protections.  Most
people haven't noticed because util-linux dmesg(1) defaults to using the
syslog method for access in older versions.  With util-linux dmesg(1)
defaults to reading directly from /dev/kmsg.

To fix /dev/kmsg, let's compare the existing interfaces and what they allow:

- /proc/kmsg allows:
 - open (SYSLOG_ACTION_OPEN) if CAP_SYSLOG since it uses a destructive
   single-reader interface (SYSLOG_ACTION_READ).
 - everything, after an open.

- syslog syscall allows:
 - anything, if CAP_SYSLOG.
 - SYSLOG_ACTION_READ_ALL and SYSLOG_ACTION_SIZE_BUFFER, if dmesg_restrict==0.
 - nothing else (EPERM).

The use-cases were:
- dmesg(1) needs to do non-destructive SYSLOG_ACTION_READ_ALLs.
- sysklog(1) needs to open /proc/kmsg, drop privs, and still issue the
  destructive SYSLOG_ACTION_READs.

AIUI, dmesg(1) is moving to /dev/kmsg, and systemd-journald doesn't clear
the ring buffer.

Based on the comments in devkmsg_llseek, it sounds like actions besides
reading aren't going to be supported by /dev/kmsg (i.e. 
SYSLOG_ACTION_CLEAR), so we have a strict subset of the non-destructive
syslog syscall actions.

To this end, move the check as Josh had done, but also rename the
constants to reflect their new uses (SYSLOG_FROM_CALL becomes
SYSLOG_FROM_READER, and SYSLOG_FROM_FILE becomes SYSLOG_FROM_PROC). 
SYSLOG_FROM_READER allows non-destructive actions, and SYSLOG_FROM_PROC
allows destructive actions after a capabilities-constrained
SYSLOG_ACTION_OPEN check.

- /dev/kmsg allows:
 - open if CAP_SYSLOG or dmesg_restrict==0
 - reading/polling, after open

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=903192

[akpm@linux-foundation.org: use pr_warn_once()]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Tested-by: Josh Boyer <jwboyer@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kmsg.c         |   10 ++--
 include/linux/syslog.h |    4 -
 kernel/printk.c        |   91 +++++++++++++++++++++------------------
 3 files changed, 57 insertions(+), 48 deletions(-)

diff -puN fs/proc/kmsg.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg fs/proc/kmsg.c
--- a/fs/proc/kmsg.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/fs/proc/kmsg.c
@@ -21,12 +21,12 @@ extern wait_queue_head_t log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
-	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_PROC);
 }
 
 static int kmsg_release(struct inode * inode, struct file * file)
 {
-	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_FILE);
+	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_PROC);
 	return 0;
 }
 
@@ -34,15 +34,15 @@ static ssize_t kmsg_read(struct file *fi
 			 size_t count, loff_t *ppos)
 {
 	if ((file->f_flags & O_NONBLOCK) &&
-	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return -EAGAIN;
-	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_PROC);
 }
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &log_wait, wait);
-	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff -puN include/linux/syslog.h~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg include/linux/syslog.h
--- a/include/linux/syslog.h~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/include/linux/syslog.h
@@ -44,8 +44,8 @@
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
 
-#define SYSLOG_FROM_CALL 0
-#define SYSLOG_FROM_FILE 1
+#define SYSLOG_FROM_READER           0
+#define SYSLOG_FROM_PROC             1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
diff -puN kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg kernel/printk.c
--- a/kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/kernel/printk.c
@@ -363,6 +363,53 @@ static void log_store(int facility, int
 	log_next_seq++;
 }
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
+static int syslog_action_restricted(int type)
+{
+	if (dmesg_restrict)
+		return 1;
+	/*
+	 * Unless restricted, we allow "read all" and "get buffer size"
+	 * for everybody.
+	 */
+	return type != SYSLOG_ACTION_READ_ALL &&
+	       type != SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type != SYSLOG_ACTION_OPEN)
+		return 0;
+
+	if (syslog_action_restricted(type)) {
+		if (capable(CAP_SYSLOG))
+			return 0;
+		/*
+		 * For historical reasons, accept CAP_SYS_ADMIN too, with
+		 * a warning.
+		 */
+		if (capable(CAP_SYS_ADMIN)) {
+			pr_warn_once("%s (%d): Attempt to access syslog with "
+				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
+				     "(deprecated).\n",
+				 current->comm, task_pid_nr(current));
+			return 0;
+		}
+		return -EPERM;
+	}
+	return security_syslog(type);
+}
+
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -620,7 +667,8 @@ static int devkmsg_open(struct inode *in
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+				       SYSLOG_FROM_READER);
 	if (err)
 		return err;
 
@@ -813,45 +861,6 @@ static inline void boot_delay_msec(int l
 }
 #endif
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
-
-static int syslog_action_restricted(int type)
-{
-	if (dmesg_restrict)
-		return 1;
-	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
-	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
-}
-
-static int check_syslog_permissions(int type, bool from_file)
-{
-	/*
-	 * If this is from /proc/kmsg and we've already opened it, then we've
-	 * already done the capabilities checks at open time.
-	 */
-	if (from_file && type != SYSLOG_ACTION_OPEN)
-		return 0;
-
-	if (syslog_action_restricted(type)) {
-		if (capable(CAP_SYSLOG))
-			return 0;
-		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
-		if (capable(CAP_SYS_ADMIN)) {
-			printk_once(KERN_WARNING "%s (%d): "
-				 "Attempt to access syslog with CAP_SYS_ADMIN "
-				 "but no CAP_SYSLOG (deprecated).\n",
-				 current->comm, task_pid_nr(current));
-			return 0;
-		}
-		return -EPERM;
-	}
-	return 0;
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static bool printk_time = 1;
 #else
@@ -1249,7 +1258,7 @@ out:
 
 SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 {
-	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
+	return do_syslog(type, buf, len, SYSLOG_FROM_READER);
 }
 
 /*
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
isdn-clean-up-debug-format-string-usage.patch
block-do-not-pass-disk-names-as-format-strings.patch
crypto-sanitize-argument-for-format-string.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
drivers-avoid-format-string-in-dev_set_name.patch
drivers-avoid-format-strings-in-names-passed-to-alloc_workqueue.patch
drivers-avoid-parsing-names-as-kthread_run-format-strings.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch

