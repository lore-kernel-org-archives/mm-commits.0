From: akpm@linux-foundation.org
Subject: [merged]
 printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:12:14 -0700
Message-ID: <57a233fe.u52VHyMHArqo5pAO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbcHCSN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, dyoung@redhat.com, fbui@suse.com, gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add kernel parameter to control writes to /dev/kmsg
has been removed from the -mm tree.  Its filename was
     printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: printk: add kernel parameter to control writes to /dev/kmsg

Add a "printk.devkmsg" kernel command line parameter which controls how
userspace writes into /dev/kmsg.  It has three options:

* ratelimit - ratelimit logging from userspace.
* on  - unlimited logging from userspace
* off - logging from userspace gets ignored

The default setting is to ratelimit the messages written to it.

This changes the kernel default setting of "on" to "ratelimit" and we do
that because we want to keep userspace spamming /dev/kmsg to sane levels. 
This is especially moot when a small kernel log buffer wraps around and
messages get lost.  So the ratelimiting setting should be a sane setting
where kernel messages should have a bit higher chance of survival from all
the spamming.

It additionally does not limit logging to /dev/kmsg while the system is
booting if we haven't disabled it on the command line.

Furthermore, we can control the logging from a lower priority sysctl
interface - kernel.printk_devkmsg.

That interface will succeed only if printk.devkmsg *hasn't* been supplied
on the command line.  If it has, then printk.devkmsg is a one-time setting
which remains for the duration of the system lifetime.  This "locking" of
the setting is to prevent userspace from changing the logging on us
through sysctl(2).

This patch is based on previous patches from Linus and Steven.

[bp@suse.de: fixes]
  Link: http://lkml.kernel.org/r/20160719072344.GC25563@nazgul.tnic
Link: http://lkml.kernel.org/r/20160716061745.15795-3-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: Franck Bui <fbui@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +
 Documentation/sysctl/kernel.txt     |   14 ++
 include/linux/printk.h              |    9 +
 kernel/printk/printk.c              |  142 ++++++++++++++++++++++++--
 kernel/sysctl.c                     |    7 +
 5 files changed, 171 insertions(+), 8 deletions(-)

diff -puN Documentation/kernel-parameters.txt~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg
+++ a/Documentation/kernel-parameters.txt
@@ -3173,6 +3173,13 @@ bytes respectively. Such letter suffixes
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
+	printk.devkmsg={on,off,ratelimit}
+			Control writing to /dev/kmsg.
+			on - unlimited logging to /dev/kmsg from userspace
+			off - logging to /dev/kmsg disabled
+			ratelimit - ratelimit the logging
+			Default: ratelimit
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff -puN Documentation/sysctl/kernel.txt~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg
+++ a/Documentation/sysctl/kernel.txt
@@ -764,6 +764,20 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+printk_devkmsg:
+
+Control the logging to /dev/kmsg from userspace:
+
+ratelimit: default, ratelimited
+on: unlimited logging to /dev/kmsg from userspace
+off: logging to /dev/kmsg disabled
+
+The kernel command line parameter printk.devkmsg= overrides this and is
+a one-time setting until next reboot: once set, it cannot be changed by
+this sysctl interface anymore.
+
+==============================================================
+
 randomize_va_space:
 
 This option can be used to select the type of process address
diff -puN include/linux/printk.h~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg include/linux/printk.h
--- a/include/linux/printk.h~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg
+++ a/include/linux/printk.h
@@ -61,6 +61,11 @@ static inline void console_verbose(void)
 		console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 }
 
+/* strlen("ratelimit") + 1 */
+#define DEVKMSG_STR_MAX_SIZE 10
+extern char devkmsg_log_str[];
+struct ctl_table;
+
 struct va_format {
 	const char *fmt;
 	va_list *va;
@@ -175,6 +180,10 @@ extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
 
+extern int
+devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write, void __user *buf,
+			  size_t *lenp, loff_t *ppos);
+
 extern void wake_up_klogd(void);
 
 char *log_buf_addr_get(void);
diff -puN kernel/printk/printk.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg
+++ a/kernel/printk/printk.c
@@ -85,6 +85,111 @@ static struct lockdep_map console_lock_d
 };
 #endif
 
+enum devkmsg_log_bits {
+	__DEVKMSG_LOG_BIT_ON = 0,
+	__DEVKMSG_LOG_BIT_OFF,
+	__DEVKMSG_LOG_BIT_LOCK,
+};
+
+enum devkmsg_log_masks {
+	DEVKMSG_LOG_MASK_ON             = BIT(__DEVKMSG_LOG_BIT_ON),
+	DEVKMSG_LOG_MASK_OFF            = BIT(__DEVKMSG_LOG_BIT_OFF),
+	DEVKMSG_LOG_MASK_LOCK           = BIT(__DEVKMSG_LOG_BIT_LOCK),
+};
+
+/* Keep both the 'on' and 'off' bits clear, i.e. ratelimit by default: */
+#define DEVKMSG_LOG_MASK_DEFAULT	0
+
+static unsigned int __read_mostly devkmsg_log = DEVKMSG_LOG_MASK_DEFAULT;
+
+static int __control_devkmsg(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strncmp(str, "on", 2)) {
+		devkmsg_log = DEVKMSG_LOG_MASK_ON;
+		return 2;
+	} else if (!strncmp(str, "off", 3)) {
+		devkmsg_log = DEVKMSG_LOG_MASK_OFF;
+		return 3;
+	} else if (!strncmp(str, "ratelimit", 9)) {
+		devkmsg_log = DEVKMSG_LOG_MASK_DEFAULT;
+		return 9;
+	}
+	return -EINVAL;
+}
+
+static int __init control_devkmsg(char *str)
+{
+	if (__control_devkmsg(str) < 0)
+		return 1;
+
+	/*
+	 * Set sysctl string accordingly:
+	 */
+	if (devkmsg_log == DEVKMSG_LOG_MASK_ON) {
+		memset(devkmsg_log_str, 0, DEVKMSG_STR_MAX_SIZE);
+		strncpy(devkmsg_log_str, "on", 2);
+	} else if (devkmsg_log == DEVKMSG_LOG_MASK_OFF) {
+		memset(devkmsg_log_str, 0, DEVKMSG_STR_MAX_SIZE);
+		strncpy(devkmsg_log_str, "off", 3);
+	}
+	/* else "ratelimit" which is set by default. */
+
+	/*
+	 * Sysctl cannot change it anymore. The kernel command line setting of
+	 * this parameter is to force the setting to be permanent throughout the
+	 * runtime of the system. This is a precation measure against userspace
+	 * trying to be a smarta** and attempting to change it up on us.
+	 */
+	devkmsg_log |= DEVKMSG_LOG_MASK_LOCK;
+
+	return 0;
+}
+__setup("printk.devkmsg=", control_devkmsg);
+
+char devkmsg_log_str[DEVKMSG_STR_MAX_SIZE] = "ratelimit";
+
+int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
+			      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	char old_str[DEVKMSG_STR_MAX_SIZE];
+	unsigned int old;
+	int err;
+
+	if (write) {
+		if (devkmsg_log & DEVKMSG_LOG_MASK_LOCK)
+			return -EINVAL;
+
+		old = devkmsg_log;
+		strncpy(old_str, devkmsg_log_str, DEVKMSG_STR_MAX_SIZE);
+	}
+
+	err = proc_dostring(table, write, buffer, lenp, ppos);
+	if (err)
+		return err;
+
+	if (write) {
+		err = __control_devkmsg(devkmsg_log_str);
+
+		/*
+		 * Do not accept an unknown string OR a known string with
+		 * trailing crap...
+		 */
+		if (err < 0 || (err + 1 != *lenp)) {
+
+			/* ... and restore old setting. */
+			devkmsg_log = old;
+			strncpy(devkmsg_log_str, old_str, DEVKMSG_STR_MAX_SIZE);
+
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Number of registered extended console drivers.
  *
@@ -613,6 +718,7 @@ struct devkmsg_user {
 	u64 seq;
 	u32 idx;
 	enum log_flags prev;
+	struct ratelimit_state rs;
 	struct mutex lock;
 	char buf[CONSOLE_EXT_LOG_MAX];
 };
@@ -622,11 +728,24 @@ static ssize_t devkmsg_write(struct kioc
 	char *buf, *line;
 	int level = default_message_loglevel;
 	int facility = 1;	/* LOG_USER */
+	struct file *file = iocb->ki_filp;
+	struct devkmsg_user *user = file->private_data;
 	size_t len = iov_iter_count(from);
 	ssize_t ret = len;
 
-	if (len > LOG_LINE_MAX)
+	if (!user || len > LOG_LINE_MAX)
 		return -EINVAL;
+
+	/* Ignore when user logging is disabled. */
+	if (devkmsg_log & DEVKMSG_LOG_MASK_OFF)
+		return len;
+
+	/* Ratelimit when not explicitly enabled. */
+	if (!(devkmsg_log & DEVKMSG_LOG_MASK_ON)) {
+		if (!___ratelimit(&user->rs, current->comm))
+			return ret;
+	}
+
 	buf = kmalloc(len+1, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
@@ -799,19 +918,24 @@ static int devkmsg_open(struct inode *in
 	struct devkmsg_user *user;
 	int err;
 
-	/* write-only does not need any file context */
-	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		return 0;
+	if (devkmsg_log & DEVKMSG_LOG_MASK_OFF)
+		return -EPERM;
 
-	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
-				       SYSLOG_FROM_READER);
-	if (err)
-		return err;
+	/* write-only does not need any file context */
+	if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
+		err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+					       SYSLOG_FROM_READER);
+		if (err)
+			return err;
+	}
 
 	user = kmalloc(sizeof(struct devkmsg_user), GFP_KERNEL);
 	if (!user)
 		return -ENOMEM;
 
+	ratelimit_default_init(&user->rs);
+	ratelimit_set_flags(&user->rs, RATELIMIT_MSG_ON_RELEASE);
+
 	mutex_init(&user->lock);
 
 	raw_spin_lock_irq(&logbuf_lock);
@@ -830,6 +954,8 @@ static int devkmsg_release(struct inode
 	if (!user)
 		return 0;
 
+	ratelimit_state_exit(&user->rs);
+
 	mutex_destroy(&user->lock);
 	kfree(user);
 	return 0;
diff -puN kernel/sysctl.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg kernel/sysctl.c
--- a/kernel/sysctl.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg
+++ a/kernel/sysctl.c
@@ -814,6 +814,13 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &ten_thousand,
 	},
 	{
+		.procname	= "printk_devkmsg",
+		.data		= devkmsg_log_str,
+		.maxlen		= DEVKMSG_STR_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= devkmsg_sysctl_set_loglvl,
+	},
+	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
_

Patches currently in -mm which might be from bp@suse.de are


