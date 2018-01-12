From: akpm@linux-foundation.org
Subject: + pipe-sysctl-remove-pipe_proc_fn.patch added to -mm tree
Date: Thu, 11 Jan 2018 16:16:15 -0800
Message-ID: <5a57fe4f.RYDezgt+aO3QXX4C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754006AbeALAQQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 19:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe, sysctl: remove pipe_proc_fn()
has been added to the -mm tree.  Its filename is
     pipe-sysctl-remove-pipe_proc_fn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-sysctl-remove-pipe_proc_fn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-sysctl-remove-pipe_proc_fn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: pipe, sysctl: remove pipe_proc_fn()

pipe_proc_fn() is no longer needed, as it only calls through to
proc_dopipe_max_size().  Just put proc_dopipe_max_size() in the ctl_table
entry directly, and remove the unneeded EXPORT_SYMBOL() and the ENOSYS
stub for it.

(The reason the ENOSYS stub isn't needed is that the pipe-max-size
ctl_table entry is located directly in 'kern_table' rather than being
registered separately.  Therefore, the entry is already only defined when
the kernel is built with sysctl support.)

Link: http://lkml.kernel.org/r/20180111052902.14409-3-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                 |   10 ----------
 include/linux/pipe_fs_i.h |    1 -
 include/linux/sysctl.h    |    3 ---
 kernel/sysctl.c           |   15 +++++----------
 4 files changed, 5 insertions(+), 24 deletions(-)

diff -puN fs/pipe.c~pipe-sysctl-remove-pipe_proc_fn fs/pipe.c
--- a/fs/pipe.c~pipe-sysctl-remove-pipe_proc_fn
+++ a/fs/pipe.c
@@ -1121,16 +1121,6 @@ out_revert_acct:
 }
 
 /*
- * This should work even if CONFIG_PROC_FS isn't set, as proc_dopipe_max_size
- * will return an error.
- */
-int pipe_proc_fn(struct ctl_table *table, int write, void __user *buf,
-		 size_t *lenp, loff_t *ppos)
-{
-	return proc_dopipe_max_size(table, write, buf, lenp, ppos);
-}
-
-/*
  * After the inode slimming patch, i_pipe/i_bdev/i_cdev share the same
  * location, so checking ->i_pipe is not enough to verify that this is a
  * pipe.
diff -puN include/linux/pipe_fs_i.h~pipe-sysctl-remove-pipe_proc_fn include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~pipe-sysctl-remove-pipe_proc_fn
+++ a/include/linux/pipe_fs_i.h
@@ -170,7 +170,6 @@ void pipe_double_lock(struct pipe_inode_
 extern unsigned int pipe_max_size;
 extern unsigned long pipe_user_pages_hard;
 extern unsigned long pipe_user_pages_soft;
-int pipe_proc_fn(struct ctl_table *, int, void __user *, size_t *, loff_t *);
 
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe);
diff -puN include/linux/sysctl.h~pipe-sysctl-remove-pipe_proc_fn include/linux/sysctl.h
--- a/include/linux/sysctl.h~pipe-sysctl-remove-pipe_proc_fn
+++ a/include/linux/sysctl.h
@@ -51,9 +51,6 @@ extern int proc_dointvec_minmax(struct c
 extern int proc_douintvec_minmax(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
-extern int proc_dopipe_max_size(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp,
-				loff_t *ppos);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
diff -puN kernel/sysctl.c~pipe-sysctl-remove-pipe_proc_fn kernel/sysctl.c
--- a/kernel/sysctl.c~pipe-sysctl-remove-pipe_proc_fn
+++ a/kernel/sysctl.c
@@ -218,6 +218,8 @@ static int proc_dointvec_minmax_coredump
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
+static int proc_dopipe_max_size(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
@@ -1812,7 +1814,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &pipe_max_size,
 		.maxlen		= sizeof(pipe_max_size),
 		.mode		= 0644,
-		.proc_handler	= &pipe_proc_fn,
+		.proc_handler	= proc_dopipe_max_size,
 	},
 	{
 		.procname	= "pipe-user-pages-hard",
@@ -2637,8 +2639,8 @@ static int do_proc_dopipe_max_size_conv(
 	return 0;
 }
 
-int proc_dopipe_max_size(struct ctl_table *table, int write,
-			 void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_dopipe_max_size(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return do_proc_douintvec(table, write, buffer, lenp, ppos,
 				 do_proc_dopipe_max_size_conv, NULL);
@@ -3147,12 +3149,6 @@ int proc_douintvec_minmax(struct ctl_tab
 	return -ENOSYS;
 }
 
-int proc_dopipe_max_size(struct ctl_table *table, int write,
-			 void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
