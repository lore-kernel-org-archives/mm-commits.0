From: akpm@linux-foundation.org
Subject: [merged] proc-pass-fd-by-value-in-proc-fdfdinfo-code.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:56 -0700
Message-ID: <20120601193356.5356AA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40431 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086Ab2FATd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:57 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so138654bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: pass "fd" by value in /proc/*/{fd,fdinfo} code
has been removed from the -mm tree.  Its filename was
     proc-pass-fd-by-value-in-proc-fdfdinfo-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1848,7 +1848,7 @@ static const struct dentry_operations ti
 static struct dentry *proc_fd_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(const unsigned *)ptr;
+	unsigned fd = (unsigned long)ptr;
  	struct inode *inode;
  	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-ENOENT);
@@ -1885,7 +1885,7 @@ static struct dentry *proc_lookupfd_comm
 	if (fd == ~0U)
 		goto out;
 
-	result = instantiate(dir, dentry, task, &fd);
+	result = instantiate(dir, dentry, task, (void *)(unsigned long)fd);
 out:
 	put_task_struct(task);
 out_no_task:
@@ -1937,7 +1937,7 @@ static int proc_readfd_common(struct fil
 				len = snprintf(name, sizeof(name), "%d", fd);
 				rv = proc_fill_cache(filp, dirent, filldir,
 						     name, len, instantiate, p,
-						     &fd);
+						     (void *)(unsigned long)fd);
 				if (rv < 0)
 					goto out_fd_loop;
 				rcu_read_lock();
@@ -2353,7 +2353,7 @@ static const struct inode_operations pro
 static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(unsigned *)ptr;
+	unsigned fd = (unsigned long)ptr;
  	struct inode *inode;
  	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-ENOENT);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

