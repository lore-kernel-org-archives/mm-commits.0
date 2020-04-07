From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 110/166] lib/test_lockup.c: add parameters for
 locking generic vfs locks
Date: Mon, 06 Apr 2020 20:09:54 -0700
Message-ID: <20200407030954.oGSTJTCTN%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgDGDJ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:56 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, gregkh@linuxfoundation.org, keescook@chromium.org, khlebnikov@yandex-team.ru, linux-mm@kvack.org, linux@roeck-us.net, mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sashal@kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: lib/test_lockup.c: add parameters for locking generic vfs locks

file_path=<path>	defines file or directory to open
lock_inode=Y		set lock_rwsem_ptr to inode->i_rwsem
lock_mapping=Y		set lock_rwsem_ptr to mapping->i_mmap_rwsem
lock_sb_umount=Y	set lock_rwsem_ptr to sb->s_umount

This gives safe and simple way to see how system reacts to contention of
common vfs locks and how syscalls depend on them directly or indirectly.

For example to block s_umount for 60 seconds:
# modprobe test_lockup file_path=. lock_sb_umount time_secs=60 state=S

This is useful for checking/testing scalability issues like this:
https://lore.kernel.org/lkml/158497590858.7371.9311902565121473436.stgit@buzz/

Link: http://lkml.kernel.org/r/158498153964.5621.83061779039255681.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_lockup.c |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/lib/test_lockup.c~lib-test_lockup-add-parameters-for-locking-generic-vfs-locks
+++ a/lib/test_lockup.c
@@ -14,6 +14,7 @@
 #include <linux/nmi.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
+#include <linux/file.h>
 
 static unsigned int time_secs;
 module_param(time_secs, uint, 0600);
@@ -140,6 +141,24 @@ static bool reallocate_pages;
 module_param(reallocate_pages, bool, 0400);
 MODULE_PARM_DESC(reallocate_pages, "free and allocate pages between iterations");
 
+struct file *test_file;
+struct inode *test_inode;
+static char test_file_path[256];
+module_param_string(file_path, test_file_path, sizeof(test_file_path), 0400);
+MODULE_PARM_DESC(file_path, "file path to test");
+
+static bool test_lock_inode;
+module_param_named(lock_inode, test_lock_inode, bool, 0400);
+MODULE_PARM_DESC(lock_inode, "lock file -> inode -> i_rwsem");
+
+static bool test_lock_mapping;
+module_param_named(lock_mapping, test_lock_mapping, bool, 0400);
+MODULE_PARM_DESC(lock_mapping, "lock file -> mapping -> i_mmap_rwsem");
+
+static bool test_lock_sb_umount;
+module_param_named(lock_sb_umount, test_lock_sb_umount, bool, 0400);
+MODULE_PARM_DESC(lock_sb_umount, "lock file -> sb -> s_umount");
+
 static atomic_t alloc_pages_failed = ATOMIC_INIT(0);
 
 static atomic64_t max_lock_wait = ATOMIC64_INIT(0);
@@ -490,6 +509,29 @@ static int __init test_lockup_init(void)
 		return -EINVAL;
 	}
 
+	if (test_file_path[0]) {
+		test_file = filp_open(test_file_path, O_RDONLY, 0);
+		if (IS_ERR(test_file)) {
+			pr_err("cannot find file_path\n");
+			return -EINVAL;
+		}
+		test_inode = file_inode(test_file);
+	} else if (test_lock_inode ||
+		   test_lock_mapping ||
+		   test_lock_sb_umount) {
+		pr_err("no file to lock\n");
+		return -EINVAL;
+	}
+
+	if (test_lock_inode && test_inode)
+		lock_rwsem_ptr = (unsigned long)&test_inode->i_rwsem;
+
+	if (test_lock_mapping && test_file && test_file->f_mapping)
+		lock_rwsem_ptr = (unsigned long)&test_file->f_mapping->i_mmap_rwsem;
+
+	if (test_lock_sb_umount && test_inode)
+		lock_rwsem_ptr = (unsigned long)&test_inode->i_sb->s_umount;
+
 	pr_notice("START pid=%d time=%u +%u ns cooldown=%u +%u ns iterations=%u state=%s %s%s%s%s%s%s%s%s%s%s%s\n",
 		  main_task->pid, time_secs, time_nsecs,
 		  cooldown_secs, cooldown_nsecs, iterations, state,
@@ -542,6 +584,9 @@ static int __init test_lockup_init(void)
 
 	pr_notice("FINISH in %llu ns\n", local_clock() - test_start);
 
+	if (test_file)
+		fput(test_file);
+
 	if (signal_pending(main_task))
 		return -EINTR;
 
_
