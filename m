From: akpm@linux-foundation.org
Subject: + sys_execve-and-sys_uselib-do-not-call-into-fsnotify.patch added to -mm tree
Date: Wed, 17 Dec 2008 15:03:07 -0800
Message-ID: <200812172303.mBHN37GK000842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYLQXEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 18:04:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, frederik.deweerdt@xprog.eu, hch@lst.de, kosaki.motohiro@jp.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     sys_execve and sys_uselib do not call into fsnotify
has been added to the -mm tree.  Its filename is
     sys_execve-and-sys_uselib-do-not-call-into-fsnotify.patch

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
Subject: sys_execve and sys_uselib do not call into fsnotify
From: Eric Paris <eparis@redhat.com>

sys_execve and sys_uselib do not call into fsnotify so inotify does not
get open events for these types of syscalls.  This patch simply makes the
requisite fsnotify calls.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/exec.c~sys_execve-and-sys_uselib-do-not-call-into-fsnotify fs/exec.c
--- a/fs/exec.c~sys_execve-and-sys_uselib-do-not-call-into-fsnotify
+++ a/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/audit.h>
 #include <linux/tracehook.h>
 #include <linux/kmod.h>
+#include <linux/fsnotify.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -136,6 +137,8 @@ asmlinkage long sys_uselib(const char __
 	if (IS_ERR(file))
 		goto out;
 
+	fsnotify_open(file->f_path.dentry);
+
 	error = -ENOEXEC;
 	if(file->f_op) {
 		struct linux_binfmt * fmt;
@@ -680,6 +683,8 @@ struct file *open_exec(const char *name)
 	if (IS_ERR(file))
 		return file;
 
+	fsnotify_open(file->f_path.dentry);
+
 	err = deny_write_access(file);
 	if (err) {
 		fput(file);
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
sys_execve-and-sys_uselib-do-not-call-into-fsnotify.patch

