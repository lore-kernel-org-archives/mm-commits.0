From: akpm@linux-foundation.org
Subject: [merged] proc-do-not-allow-negative-offsets-on-proc-pid-environ.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:49 -0700
Message-ID: <20120731185349.CA3E21E007A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2GaSxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:51 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tixxdz@opendz.org, keescook@chromium.org, oleg@redhat.com, rientjes@google.com, spender@grsecurity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: do not allow negative offsets on /proc/<pid>/environ
has been removed from the -mm tree.  Its filename was
     proc-do-not-allow-negative-offsets-on-proc-pid-environ.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: proc: do not allow negative offsets on /proc/<pid>/environ

__mem_open() which is called by both /proc/<pid>/environ and
/proc/<pid>/mem ->open() handlers will allow the use of negative offsets.
/proc/<pid>/mem has negative offsets but not /proc/<pid>/environ.

Clean this by moving the 'force FMODE_UNSIGNED_OFFSET flag' to mem_open()
to allow negative offsets only on /proc/<pid>/mem.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-do-not-allow-negative-offsets-on-proc-pid-environ fs/proc/base.c
--- a/fs/proc/base.c~proc-do-not-allow-negative-offsets-on-proc-pid-environ
+++ a/fs/proc/base.c
@@ -695,8 +695,6 @@ static int __mem_open(struct inode *inod
 		mmput(mm);
 	}
 
-	/* OK to pass negative loff_t, we can catch out-of-range */
-	file->f_mode |= FMODE_UNSIGNED_OFFSET;
 	file->private_data = mm;
 
 	return 0;
@@ -704,7 +702,12 @@ static int __mem_open(struct inode *inod
 
 static int mem_open(struct inode *inode, struct file *file)
 {
-	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
+	int ret = __mem_open(inode, file, PTRACE_MODE_ATTACH);
+
+	/* OK to pass negative loff_t, we can catch out-of-range */
+	file->f_mode |= FMODE_UNSIGNED_OFFSET;
+
+	return ret;
 }
 
 static ssize_t mem_rw(struct file *file, char __user *buf,
_

Patches currently in -mm which might be from tixxdz@opendz.org are

origin.patch

