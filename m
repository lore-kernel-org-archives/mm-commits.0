From: akpm@linux-foundation.org
Subject: [failures] kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:11:40 -0700
Message-ID: <20130430181145.70C9B31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39793 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801Ab3D3SLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:11:46 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so71519veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:11:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@redhat.com, eparis@redhat.com, keescook@chromium.org, lists@nerdbynature.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
has been removed from the -mm tree.  Its filename was
     kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Josh Boyer <jwboyer@redhat.com>
Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg

The dmesg_restrict sysctl currently covers the syslog method for access
dmesg, however /dev/kmsg isn't covered by the same protections.  Most
people haven't noticed because util-linux dmesg(1) defaults to using the
syslog method for access in older versions.  With util-linux dmesg(1)
defaults to reading directly from /dev/kmsg.

Fix this by reworking all of the access methods to use the
check_syslog_permissions function and adding checks to devkmsg_open and
devkmsg_read.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=903192

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   91 +++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 44 deletions(-)

diff -puN kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg kernel/printk.c
--- a/kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/kernel/printk.c
@@ -361,6 +361,46 @@ static void log_store(int facility, int
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
+	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
+	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type != SYSLOG_ACTION_OPEN)
+		goto ok;
+
+	if (syslog_action_restricted(type)) {
+		if (capable(CAP_SYSLOG))
+			goto ok;
+		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
+		if (capable(CAP_SYS_ADMIN)) {
+			printk_once(KERN_WARNING "%s (%d): "
+				 "Attempt to access syslog with CAP_SYS_ADMIN "
+				 "but no CAP_SYSLOG (deprecated).\n",
+				 current->comm, task_pid_nr(current));
+			goto ok;
+		}
+		return -EPERM;
+	}
+ok:
+	return security_syslog(type);
+}
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -436,10 +476,16 @@ static ssize_t devkmsg_read(struct file
 	char cont = '-';
 	size_t len;
 	ssize_t ret;
+	int err;
 
 	if (!user)
 		return -EBADF;
 
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+		SYSLOG_FROM_FILE);
+	if (err)
+		return err;
+
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
@@ -618,7 +664,7 @@ static int devkmsg_open(struct inode *in
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_OPEN, SYSLOG_FROM_FILE);
 	if (err)
 		return err;
 
@@ -811,45 +857,6 @@ static inline void boot_delay_msec(int l
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
@@ -1125,10 +1132,6 @@ int do_syslog(int type, char __user *buf
 	if (error)
 		goto out;
 
-	error = security_syslog(type);
-	if (error)
-		return error;
