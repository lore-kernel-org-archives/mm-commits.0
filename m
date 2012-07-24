From: akpm@linux-foundation.org
Subject: + proc-do-not-allow-negative-offsets-on-proc-pid-environ.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:18:08 -0700
Message-ID: <20120724211809.6B399100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56048 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2GXVSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:18:10 -0400
Received: by yenl3 with SMTP id l3so5567yen.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:18:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tixxdz@opendz.org, keescook@chromium.org, oleg@redhat.com, rientjes@google.com, spender@grsecurity.net


The patch titled
     Subject: proc: do not allow negative offsets on /proc/<pid>/environ
has been added to the -mm tree.  Its filename is
     proc-do-not-allow-negative-offsets-on-proc-pid-environ.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: proc: do not allow negative offsets on /proc/<pid>/environ

Patches currently in -mm which might be from tixxdz@opendz.org are

origin.patch
proc-environ_read-make-sure-offset-points-to-environment-address-range.patch
proc-do-not-allow-negative-offsets-on-proc-pid-environ.patch

