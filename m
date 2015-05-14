From: akpm@linux-foundation.org
Subject: + printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
 added to -mm tree
Date: Thu, 14 May 2015 13:28:48 -0700
Message-ID: <55550580.27gaprWXeQWm+Vas%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbbENU2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: guard the amount written per line by devkmsg_read()
has been added to the -mm tree.  Its filename is
     printk-guard-the-amount-written-per-line-by-devkmsg_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-guard-the-amount-written-per-line-by-devkmsg_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: printk: guard the amount written per line by devkmsg_read()

This patchset updates netconsole so that it can emit messages with the
same header as used in /dev/kmsg which gives neconsole receiver full
log information which enables things like structured logging and
detection of lost messages.


This patch (of 7):

devkmsg_read() uses 8k buffer and assumes that the formatted output
message won't overrun which seems safe given LOG_LINE_MAX, the current use
of dict and the escaping method being used; however, we're planning to use
devkmsg formatting wider and accounting for the buffer size properly isn't
that complicated.

This patch defines CONSOLE_EXT_LOG_MAX as 8192 and updates devkmsg_read()
so that it limits output accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    2 ++
 kernel/printk/printk.c |   34 ++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff -puN include/linux/printk.h~printk-guard-the-amount-written-per-line-by-devkmsg_read include/linux/printk.h
--- a/include/linux/printk.h~printk-guard-the-amount-written-per-line-by-devkmsg_read
+++ a/include/linux/printk.h
@@ -30,6 +30,8 @@ static inline const char *printk_skip_le
 	return buffer;
 }
 
+#define CONSOLE_EXT_LOG_MAX	8192
+
 /* printk's without a loglevel use this.. */
 #define MESSAGE_LOGLEVEL_DEFAULT CONFIG_MESSAGE_LOGLEVEL_DEFAULT
 
diff -puN kernel/printk/printk.c~printk-guard-the-amount-written-per-line-by-devkmsg_read kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-guard-the-amount-written-per-line-by-devkmsg_read
+++ a/kernel/printk/printk.c
@@ -505,6 +505,11 @@ int check_syslog_permissions(int type, b
 	return security_syslog(type);
 }
 
+static void append_char(char **pp, char *e, char c)
+{
+	if (*pp < e)
+		*(*pp)++ = c;
+}
 
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
@@ -512,7 +517,7 @@ struct devkmsg_user {
 	u32 idx;
 	enum log_flags prev;
 	struct mutex lock;
-	char buf[8192];
+	char buf[CONSOLE_EXT_LOG_MAX];
 };
 
 static ssize_t devkmsg_write(struct kiocb *iocb, struct iov_iter *from)
@@ -570,6 +575,7 @@ static ssize_t devkmsg_read(struct file
 {
 	struct devkmsg_user *user = file->private_data;
 	struct printk_log *msg;
+	char *p, *e;
 	u64 ts_usec;
 	size_t i;
 	char cont = '-';
@@ -579,6 +585,9 @@ static ssize_t devkmsg_read(struct file
 	if (!user)
 		return -EBADF;
 
+	p = user->buf;
+	e = user->buf + sizeof(user->buf);
+
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
@@ -625,9 +634,9 @@ static ssize_t devkmsg_read(struct file
 		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
 		cont = '+';
 
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
-		      (msg->facility << 3) | msg->level,
-		      user->seq, ts_usec, cont);
+	p += scnprintf(p, e - p, "%u,%llu,%llu,%c;",
+		       (msg->facility << 3) | msg->level,
+		       user->seq, ts_usec, cont);
 	user->prev = msg->flags;
 
 	/* escape non-printable characters */
@@ -635,11 +644,11 @@ static ssize_t devkmsg_read(struct file
 		unsigned char c = log_text(msg)[i];
 
 		if (c < ' ' || c >= 127 || c == '\\')
-			len += sprintf(user->buf + len, "\\x%02x", c);
+			p += scnprintf(p, e - p, "\\x%02x", c);
 		else
-			user->buf[len++] = c;
+			append_char(&p, e, c);
 	}
-	user->buf[len++] = '\n';
+	append_char(&p, e, '\n');
 
 	if (msg->dict_len) {
 		bool line = true;
@@ -648,30 +657,31 @@ static ssize_t devkmsg_read(struct file
 			unsigned char c = log_dict(msg)[i];
 
 			if (line) {
-				user->buf[len++] = ' ';
+				append_char(&p, e, ' ');
 				line = false;
 			}
 
 			if (c == '\0') {
-				user->buf[len++] = '\n';
+				append_char(&p, e, '\n');
 				line = true;
 				continue;
 			}
 
 			if (c < ' ' || c >= 127 || c == '\\') {
-				len += sprintf(user->buf + len, "\\x%02x", c);
+				p += scnprintf(p, e - p, "\\x%02x", c);
 				continue;
 			}
 
-			user->buf[len++] = c;
+			append_char(&p, e, c);
 		}
-		user->buf[len++] = '\n';
+		append_char(&p, e, '\n');
 	}
 
 	user->idx = log_next(user->idx);
 	user->seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
 
+	len = p - user->buf;
 	if (len > count) {
 		ret = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

