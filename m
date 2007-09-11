From: akpm@linux-foundation.org
Subject: + fix-select-on-proc-files-without-poll.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:19:20 -0700
Message-ID: <200709110519.l8B5JKew027039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758770AbXIKFTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:19:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ebiederm@xmission.com, oleg@tv-sign.ru, vahakang@cs.helsinki.fi


The patch titled
     Fix select on /proc files without ->poll
has been added to the -mm tree.  Its filename is
     fix-select-on-proc-files-without-poll.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix select on /proc files without ->poll
From: Alexey Dobriyan <adobriyan@gmail.com>

T Taneli Vahakangas <vahakang@cs.helsinki.fi> reported that
commit 786d7e1612f0b0adb6046f19b906609e4fe8b1ba aka
"Fix rmmod/read/write races in /proc entries"
broke SBCL + SLIME combo.

Old code in do_select() used DEFAULT_POLLMASK, if couldn't find ->poll
handler. New code makes ->poll always there and returns 0 by default,
which is not correct. Return DEFAULT_POLLMASK instead.

Steps to reproduce:

	install emacs, SBCL, SLIME
	emacs
	M-x slime	in *inferior-lisp* buffer
	[watch it doing "Connecting to Swank on port X.."]

Please, apply before 2.6.23.

P.S.: why SBCL can't just read(2) /proc/cpuinfo is a mystery.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: T Taneli Vahakangas <vahakang@cs.helsinki.fi>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c      |    3 ++-
 fs/select.c          |    2 --
 include/linux/poll.h |    2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/inode.c~fix-select-on-proc-files-without-poll fs/proc/inode.c
--- a/fs/proc/inode.c~fix-select-on-proc-files-without-poll
+++ a/fs/proc/inode.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/stat.h>
 #include <linux/completion.h>
+#include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/limits.h>
 #include <linux/init.h>
@@ -232,7 +233,7 @@ static ssize_t proc_reg_write(struct fil
 static unsigned int proc_reg_poll(struct file *file, struct poll_table_struct *pts)
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
-	unsigned int rv = 0;
+	unsigned int rv = DEFAULT_POLLMASK;
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
 
 	spin_lock(&pde->pde_unload_lock);
diff -puN fs/select.c~fix-select-on-proc-files-without-poll fs/select.c
--- a/fs/select.c~fix-select-on-proc-files-without-poll
+++ a/fs/select.c
@@ -26,8 +26,6 @@
 
 #include <asm/uaccess.h>
 
-#define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
-
 struct poll_table_page {
 	struct poll_table_page * next;
 	struct poll_table_entry * entry;
diff -puN include/linux/poll.h~fix-select-on-proc-files-without-poll include/linux/poll.h
--- a/include/linux/poll.h~fix-select-on-proc-files-without-poll
+++ a/include/linux/poll.h
@@ -21,6 +21,8 @@
 #define WQUEUES_STACK_ALLOC	(MAX_STACK_ALLOC - FRONTEND_STACK_ALLOC)
 #define N_INLINE_POLL_ENTRIES	(WQUEUES_STACK_ALLOC / sizeof(struct poll_table_entry))
 
+#define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
+
 struct poll_table_struct;
 
 /* 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fix-select-on-proc-files-without-poll.patch
nfs-fix-oops-re-sysctls-and-v4-support.patch
ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
shrink-struct-task_structoomkilladj.patch
remove-struct-task_structio_wait.patch
drop-some-headers-from-mmh.patch
revert-faster-ext2_clear_inode.patch
