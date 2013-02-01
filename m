From: akpm@linux-foundation.org
Subject: [obsolete] signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4.patch removed from -mm tree
Date: Fri, 01 Feb 2013 15:37:03 -0800
Message-ID: <20130201233703.9C4405A42F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:38799 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab3BAXhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 18:37:06 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so261246vea.4
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 15:37:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, davej@redhat.com, dhowells@redhat.com, gorcunov@openvz.org, mtk.manpages@gmail.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signalfd: add ability to read siginfos without dequeuing signals
has been removed from the -mm tree.  Its filename was
     signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: signalfd: add ability to read siginfos without dequeuing signals

pread(fd, buf, size, pos) with non-zero pos returns siginfos
without dequeuing signals.

A sequence number and a queue are encoded in pos.

pos = seq + SFD_*_OFFSET

seq is a sequence number of a signal in a queue.

SFD_PER_THREAD_QUEUE_OFFSET - read signals from a per-thread queue.
SFD_SHARED_QUEUE_OFFSET - read signals from a shared (process wide) queue.

This functionality is required for checkpointing pending signals.

v2: llseek() can't be used here, because peek_offset/f_pos/whatever
has to be shared with all processes which have this file opened.

Suppose that the task forks after sys_signalfd(). Now if parent or child
do llseek this affects them both. This is insane because signalfd is
"strange" to say at least, fork/dup/etc inherits signalfd_ctx but not
the" source" of the data. // Oleg Nesterov

v3,v4: minor cleanups

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c                 |   45 +++++++++++++++++++++++++++++++-
 include/uapi/linux/signalfd.h |    5 +++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff -puN fs/signalfd.c~signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4 fs/signalfd.c
--- a/fs/signalfd.c~signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4
+++ a/fs/signalfd.c
@@ -51,6 +51,44 @@ struct signalfd_ctx {
 	sigset_t sigmask;
 };
 
+static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
+				siginfo_t *info, loff_t *ppos)
+{
+	struct sigpending *pending;
+	struct sigqueue *q;
+	loff_t seq;
+	int ret = 0;
+
+	if (*ppos >= SFD_SHARED_QUEUE_OFFSET) {
+		pending = &current->signal->shared_pending;
+		seq = *ppos - SFD_SHARED_QUEUE_OFFSET;
+	} else if (*ppos >= SFD_PER_THREAD_QUEUE_OFFSET) {
+		pending = &current->pending;
+		seq = *ppos - SFD_PER_THREAD_QUEUE_OFFSET;
+	} else
+		return -EINVAL;
+
+	spin_lock_irq(&current->sighand->siglock);
+
+	list_for_each_entry(q, &pending->list, list) {
+		if (sigismember(&ctx->sigmask, q->info.si_signo))
+			continue;
+
+		if (seq-- == 0) {
+			copy_siginfo(info, &q->info);
+			ret = info->si_signo;
+			break;
+		}
+	}
+
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (ret)
+		(*ppos)++;
+
+	return ret;
+}
+
 static int signalfd_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
@@ -249,7 +287,11 @@ static ssize_t signalfd_read(struct file
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		if (*ppos == 0)
+			ret = signalfd_dequeue(ctx, &info, nonblock);
+		else
+			ret = signalfd_peek(ctx, &info, ppos);
+
 		if (unlikely(ret <= 0))
 			break;
 
@@ -339,6 +381,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 		}
 
 		file->f_flags |= flags & SFD_RAW;
+		file->f_mode |= FMODE_PREAD;
 
 		fd_install(ufd, file);
 	} else {
diff -puN include/uapi/linux/signalfd.h~signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4 include/uapi/linux/signalfd.h
--- a/include/uapi/linux/signalfd.h~signalfd-add-ability-to-read-siginfo-s-without-dequeuing-signals-v4
+++ a/include/uapi/linux/signalfd.h
@@ -17,6 +17,11 @@
 #define SFD_NONBLOCK O_NONBLOCK
 #define SFD_RAW O_DIRECT
 
+/* Read signals from a shared (process wide) queue */
+#define SFD_SHARED_QUEUE_OFFSET (1LL << 62)
+/* Read signals from a per-thread queue */
+#define SFD_PER_THREAD_QUEUE_OFFSET 1
+
 struct signalfd_siginfo {
 	__u32 ssi_signo;
 	__s32 ssi_errno;
_

Patches currently in -mm which might be from avagin@openvz.org are

signal-allow-to-send-any-siginfo-to-itself.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch

