From: akpm@linux-foundation.org
Subject: + proc-faster-proc-pid-lookup.patch added to -mm tree
Date: Tue, 08 Jul 2014 15:55:07 -0700
Message-ID: <53bc76cb.y32v7KJA+1j7ELS0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:53956 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaGHWzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 18:55:08 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so1413179oag.1
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 15:55:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: faster /proc/$PID lookup
has been added to the -mm tree.  Its filename is
     proc-faster-proc-pid-lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-faster-proc-pid-lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-faster-proc-pid-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: faster /proc/$PID lookup

Currently lookup for /proc/$PID first goes through spinlock and whole list
of misc /proc entries only to confirm that, yes, /proc/42 can not possibly
match random proc entry.

List is is several dozens entries long (52 entries on my setup).

None of this is necessary.

Try to convert dentry name to integer first.
If it works, it must be /proc/$PID.
If it doesn't, it must be random proc entry.

Based on patch from Al Viro.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 fs/proc/root.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-faster-proc-pid-lookup fs/proc/base.c
--- a/fs/proc/base.c~proc-faster-proc-pid-lookup
+++ a/fs/proc/base.c
@@ -2780,7 +2780,7 @@ out:
 
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsigned int flags)
 {
-	int result = 0;
+	int result = -ENOENT;
 	struct task_struct *task;
 	unsigned tgid;
 	struct pid_namespace *ns;
diff -puN fs/proc/root.c~proc-faster-proc-pid-lookup fs/proc/root.c
--- a/fs/proc/root.c~proc-faster-proc-pid-lookup
+++ a/fs/proc/root.c
@@ -199,10 +199,10 @@ static int proc_root_getattr(struct vfsm
 
 static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, unsigned int flags)
 {
-	if (!proc_lookup(dir, dentry, flags))
+	if (!proc_pid_lookup(dir, dentry, flags))
 		return NULL;
 	
-	return proc_pid_lookup(dir, dentry, flags);
+	return proc_lookup(dir, dentry, flags);
 }
 
 static int proc_root_readdir(struct file *file, struct dir_context *ctx)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
proc-add-and-remove-proc-entry-create-checks.patch
proc-faster-proc-pid-lookup.patch
proc-make-proc_subdir_lock-static.patch
proc-remove-proc_tty_ldisc-variable.patch
proc-remove-proc_tty_ldisc-variable-fix.patch

