From: akpm@linux-foundation.org
Subject: + proc-pass-fd-by-value-in-proc-fdfdinfo-code.patch added to -mm tree
Date: Thu, 19 Apr 2012 11:50:15 -0700
Message-ID: <20120419185015.6F28CA055E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63367 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2DSSuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 14:50:17 -0400
Received: by wejx9 with SMTP id x9so425541wej.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 11:50:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     Subject: proc: pass "fd" by value in /proc/*/{fd,fdinfo} code
has been added to the -mm tree.  Its filename is
     proc-pass-fd-by-value-in-proc-fdfdinfo-code.patch

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
Subject: proc: pass "fd" by value in /proc/*/{fd,fdinfo} code

Pass "fd" directly, not via pointer -- one less memory read.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-pass-fd-by-value-in-proc-fdfdinfo-code fs/proc/base.c
--- a/fs/proc/base.c~proc-pass-fd-by-value-in-proc-fdfdinfo-code
+++ a/fs/proc/base.c
@@ -1834,7 +1834,7 @@ static const struct dentry_operations ti
 static struct dentry *proc_fd_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(const unsigned *)ptr;
+	unsigned fd = (unsigned long)ptr;
 	struct file *file;
 	struct files_struct *files;
  	struct inode *inode;
@@ -1898,7 +1898,7 @@ static struct dentry *proc_lookupfd_comm
 	if (fd == ~0U)
 		goto out;
 
-	result = instantiate(dir, dentry, task, &fd);
+	result = instantiate(dir, dentry, task, (void *)(unsigned long)fd);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -1950,7 +1950,7 @@ static int proc_readfd_common(struct fil
 				len = snprintf(name, sizeof(name), "%d", fd);
 				rv = proc_fill_cache(filp, dirent, filldir,
 						     name, len, instantiate, p,
-						     &fd);
+						     (void *)(unsigned long)fd);
 				if (rv < 0)
 					goto out_fd_loop;
 				rcu_read_lock();
@@ -2370,7 +2370,7 @@ static const struct inode_operations pro
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(unsigned *)ptr;
+	unsigned fd = (unsigned long)ptr;
  	struct inode *inode;
  	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-ENOENT);
_
Subject: Subject: proc: pass "fd" by value in /proc/*/{fd,fdinfo} code

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrtox-mark-const-init-data-with-__initconst-instead-of-__initdata.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-dont-do-dummy-rcu_read_lock-rcu_read_unlock-on-error-path.patch
proc-pass-fd-by-value-in-proc-fdfdinfo-code.patch
proc-use-is_err_or_null.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

