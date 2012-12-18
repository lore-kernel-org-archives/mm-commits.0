From: akpm@linux-foundation.org
Subject: [merged] fs-epoll-add-procfs-fdinfo-helper-v2.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:33 -0800
Message-ID: <20121218201234.A089720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64063 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2LRUMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:38 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so63387fae.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, epoll: add procfs fdinfo helper
has been removed from the -mm tree.  Its filename was
     fs-epoll-add-procfs-fdinfo-helper-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, epoll: add procfs fdinfo helper

This allows us to print out eventpoll target file descriptor, events and
data, the /proc/pid/fdinfo/fd consists of

 | pos:	0
 | flags:	02
 | tfd:        5 events:       1d data: ffffffffffffffff enabled: 1

[avagin@: fix for unitialized ret variable]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c          |   28 ++++++++++++++++++++++++++++
 fs/proc/array.c         |    2 +-
 fs/signalfd.c           |   18 ++++++++++++++++++
 include/linux/proc_fs.h |    3 +++
 4 files changed, 50 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper-v2 fs/eventpoll.c
--- a/fs/eventpoll.c~fs-epoll-add-procfs-fdinfo-helper-v2
+++ a/fs/eventpoll.c
@@ -38,6 +38,8 @@
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <linux/atomic.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 /*
  * LOCKING:
@@ -783,8 +785,34 @@ static unsigned int ep_eventpoll_poll(st
 	return pollflags != -1 ? pollflags : 0;
 }
 
+#ifdef CONFIG_PROC_FS
+static int ep_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct eventpoll *ep = f->private_data;
+	struct rb_node *rbp;
+	int ret = 0;
+
+	mutex_lock(&ep->mtx);
+	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
+		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
+
+		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+				 epi->ffd.fd, epi->event.events,
+				 (long long)epi->event.data);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&ep->mtx);
+
+	return ret;
+}
+#endif
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= ep_show_fdinfo,
+#endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,
 	.llseek		= noop_llseek,
diff -puN fs/proc/array.c~fs-epoll-add-procfs-fdinfo-helper-v2 fs/proc/array.c
--- a/fs/proc/array.c~fs-epoll-add-procfs-fdinfo-helper-v2
+++ a/fs/proc/array.c
@@ -220,7 +220,7 @@ static inline void task_state(struct seq
 	seq_putc(m, '\n');
 }
 
-static void render_sigset_t(struct seq_file *m, const char *header,
+void render_sigset_t(struct seq_file *m, const char *header,
 				sigset_t *set)
 {
 	int i;
diff -puN fs/signalfd.c~fs-epoll-add-procfs-fdinfo-helper-v2 fs/signalfd.c
--- a/fs/signalfd.c~fs-epoll-add-procfs-fdinfo-helper-v2
+++ a/fs/signalfd.c
@@ -29,6 +29,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
+#include <linux/proc_fs.h>
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
@@ -227,7 +228,24 @@ static ssize_t signalfd_read(struct file
 	return total ? total: ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct signalfd_ctx *ctx = f->private_data;
+	sigset_t sigmask;
+
+	sigmask = ctx->sigmask;
+	signotset(&sigmask);
+	render_sigset_t(m, "sigmask:\t", &sigmask);
+
+	return 0;
+}
+#endif
+
 static const struct file_operations signalfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= signalfd_show_fdinfo,
+#endif
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
diff -puN include/linux/proc_fs.h~fs-epoll-add-procfs-fdinfo-helper-v2 include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fs-epoll-add-procfs-fdinfo-helper-v2
+++ a/include/linux/proc_fs.h
@@ -290,4 +290,7 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
+#include <linux/signal.h>
+
+void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
 #endif /* _LINUX_PROC_FS_H */
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

