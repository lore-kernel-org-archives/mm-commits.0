From: akpm@linux-foundation.org
Subject: + kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch added to -mm tree
Date: Wed, 08 May 2013 14:24:53 -0700
Message-ID: <20130508212453.EC1875A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:56789 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3EHVYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 17:24:55 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so227165vea.5
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 14:24:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, jwboyer@redhat.com, kay@vrfy.org, lists@nerdbynature.de, stable@vger.kernel.org


The patch titled
     Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
has been added to the -mm tree.  Its filename is
     kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Kees Cook <keescook@chromium.org>
Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg

The dmesg_restrict sysctl currently covers the syslog method for access
dmesg, however /dev/kmsg isn't covered by the same protections.  Most
people haven't noticed because util-linux dmesg(1) defaults to using th=
e
syslog method for access in older versions.  With util-linux dmesg(1)
defaults to reading directly from /dev/kmsg.

To fix /dev/kmsg, let's compare the existing interfaces and what they a=
llow:

- /proc/kmsg allows:
=A0- open (SYSLOG_ACTION_OPEN) if CAP_SYSLOG since it uses a destructiv=
e
   single-reader interface (SYSLOG_ACTION_READ).
=A0- everything, after an open.

- syslog syscall allows:
=A0- anything, if CAP_SYSLOG.
=A0- SYSLOG_ACTION_READ_ALL and SYSLOG_ACTION_SIZE_BUFFER, if dmesg_res=
trict=3D=3D0.
=A0- nothing else (EPERM).

The use-cases were:
- dmesg(1) needs to do non-destructive SYSLOG_ACTION_READ_ALLs.
- sysklog(1) needs to open /proc/kmsg, drop privs, and still issue the
  destructive SYSLOG_ACTION_READs.

AIUI, dmesg(1) is moving to /dev/kmsg, and systemd-journald doesn't cle=
ar
the ring buffer.

Based on the comments in devkmsg_llseek, it sounds like actions besides
reading aren't going to be supported by /dev/kmsg (i.e.=20
SYSLOG_ACTION_CLEAR), so we have a strict subset of the non-destructive
syslog syscall actions.

To this end, move the check as Josh had done, but also rename the
constants to reflect their new uses (SYSLOG_FROM_CALL becomes
SYSLOG_FROM_READER, and SYSLOG_FROM_FILE becomes SYSLOG_FROM_PROC).=20
SYSLOG_FROM_READER allows non-destructive actions, and SYSLOG_FROM_PROC
allows destructive actions after a capabilities-constrained
SYSLOG_ACTION_OPEN check.

- /dev/kmsg allows:
=A0- open if CAP_SYSLOG or dmesg_restrict=3D=3D0
 - reading/polling, after open

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=3D903192

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

diff -puN fs/proc/kmsg.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg f=
s/proc/kmsg.c
--- a/fs/proc/kmsg.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/fs/proc/kmsg.c
@@ -21,12 +21,12 @@ extern wait_queue_head_t log_wait;
=20
 static int kmsg_open(struct inode * inode, struct file * file)
 {
-	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_PROC);
 }
=20
 static int kmsg_release(struct inode * inode, struct file * file)
 {
-	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_FILE);
+	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_PROC);
 	return 0;
 }
=20
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
=20
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &log_wait, wait);
-	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff -puN include/linux/syslog.h~kmsg-honor-dmesg_restrict-sysctl-on-de=
v-kmsg include/linux/syslog.h
--- a/include/linux/syslog.h~kmsg-honor-dmesg_restrict-sysctl-on-dev-km=
sg
+++ a/include/linux/syslog.h
@@ -44,8 +44,8 @@
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
=20
-#define SYSLOG_FROM_CALL 0
-#define SYSLOG_FROM_FILE 1
+#define SYSLOG_FROM_READER           0
+#define SYSLOG_FROM_PROC             1
=20
 int do_syslog(int type, char __user *buf, int count, bool from_file);
=20
diff -puN kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg =
kernel/printk.c
--- a/kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/kernel/printk.c
@@ -363,6 +363,53 @@ static void log_store(int facility, int
 	log_next_seq++;
 }
=20
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict =3D 1;
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
+	return type !=3D SYSLOG_ACTION_READ_ALL &&
+	       type !=3D SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type !=3D SYSLOG_ACTION_OPEN)
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
+			printk_once(KERN_WARNING "%s (%d): "
+				 "Attempt to access syslog with CAP_SYS_ADMIN "
+				 "but no CAP_SYSLOG (deprecated).\n",
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
 	if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
 		return 0;
=20
-	err =3D security_syslog(SYSLOG_ACTION_READ_ALL);
+	err =3D check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+				       SYSLOG_FROM_READER);
 	if (err)
 		return err;
=20
@@ -813,45 +861,6 @@ static inline void boot_delay_msec(int l
 }
 #endif
=20
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict =3D 1;
-#else
-int dmesg_restrict;
-#endif
-
-static int syslog_action_restricted(int type)
-{
-	if (dmesg_restrict)
-		return 1;
-	/* Unless restricted, we allow "read all" and "get buffer size" for e=
verybody */
-	return type !=3D SYSLOG_ACTION_READ_ALL && type !=3D SYSLOG_ACTION_SI=
ZE_BUFFER;
-}
-
-static int check_syslog_permissions(int type, bool from_file)
-{
-	/*
-	 * If this is from /proc/kmsg and we've already opened it, then we've
-	 * already done the capabilities checks at open time.
-	 */
-	if (from_file && type !=3D SYSLOG_ACTION_OPEN)
-		return 0;
-
-	if (syslog_action_restricted(type)) {
-		if (capable(CAP_SYSLOG))
-			return 0;
-		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning =
*/
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
