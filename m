From: akpm@linux-foundation.org
Subject: + proc-swaps-support-polling.patch added to -mm tree
Date: Tue, 19 Oct 2010 16:39:04 -0700
Message-ID: <201010192339.o9JNd4BW013172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414Ab0JSXji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 19:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, corbet@lwn.net, greg@kroah.com, peterz@infradead.org


The patch titled
     /proc/swaps: support polling
has been added to the -mm tree.  Its filename is
     proc-swaps-support-polling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/swaps: support polling
From: Kay Sievers <kay.sievers@vrfy.org>

System management wants to subscribe to changes in swap configuration. 
Make /proc/swaps pollable like /proc/mounts.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~proc-swaps-support-polling mm/swapfile.c
--- a/mm/swapfile.c~proc-swaps-support-polling
+++ a/mm/swapfile.c
@@ -30,6 +30,7 @@
 #include <linux/capability.h>
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
+#include <linux/poll.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -58,6 +59,9 @@ static struct swap_info_struct *swap_inf
 
 static DEFINE_MUTEX(swapon_mutex);
 
+static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
+static atomic_t proc_poll_event = ATOMIC_INIT(0);
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include SWAP_HAS_CONT flag */
@@ -1680,6 +1684,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	}
 	filp_close(swap_file, NULL);
 	err = 0;
+	atomic_inc(&proc_poll_event);
+	wake_up_interruptible(&proc_poll_wait);
 
 out_dput:
 	filp_close(victim, NULL);
@@ -1688,6 +1694,25 @@ out:
 }
 
 #ifdef CONFIG_PROC_FS
+struct proc_swaps {
+	struct seq_file seq;
+	int event;
+};
+
+static unsigned swaps_poll(struct file *file, poll_table *wait)
+{
+	struct proc_swaps *s = file->private_data;
+
+	poll_wait(file, &proc_poll_wait, wait);
+
+	if (s->event != atomic_read(&proc_poll_event)) {
+		s->event = atomic_read(&proc_poll_event);
+		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
+	}
+
+	return POLLIN | POLLRDNORM;
+}
+
 /* iterator */
 static void *swap_start(struct seq_file *swap, loff_t *pos)
 {
@@ -1771,7 +1796,24 @@ static const struct seq_operations swaps
 
 static int swaps_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &swaps_op);
+	struct proc_swaps *s;
+	int ret;
+
+	s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	file->private_data = s;
+
+	ret = seq_open(file, &swaps_op);
+	if (ret) {
+		kfree(s);
+		return ret;
+	}
+
+	s->seq.private = s;
+	s->event = atomic_read(&proc_poll_event);
+	return ret;
 }
 
 static const struct file_operations proc_swaps_operations = {
@@ -1779,6 +1821,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.poll		= swaps_poll,
 };
 
 static int __init procswaps_init(void)
@@ -2084,6 +2127,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 		swap_info[prev]->next = type;
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
+	atomic_inc(&proc_poll_event);
+	wake_up_interruptible(&proc_poll_wait);
+
 	error = 0;
 	goto out;
 bad_swap:
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

linux-next.patch
proc-swaps-support-polling.patch
proc-swaps-support-polling-fix.patch

