From: akpm@linux-foundation.org
Subject: [merged] proc-faster-proc-pid-lookup.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:50 -0700
Message-ID: <53ea6d86.fCIzSdMIYpmB/p3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:32866 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaHLTjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:51 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1068587igi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: faster /proc/$PID lookup
has been removed from the -mm tree.  Its filename was
     proc-faster-proc-pid-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

