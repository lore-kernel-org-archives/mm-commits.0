From: akpm@linux-foundation.org
Subject: + dnotify-move-dir_notify_enable-declaration.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:55:00 -0800
Message-ID: <201001262155.o0QLt0DP022814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588Ab0AZVzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, eparis@redhat.com


The patch titled
     dnotify: move dir_notify_enable declaration
has been added to the -mm tree.  Its filename is
     dnotify-move-dir_notify_enable-declaration.patch

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
Subject: dnotify: move dir_notify_enable declaration
From: Alexey Dobriyan <adobriyan@gmail.com>

Move dir_notify_enable() declaration to where it belongs: dnotify.h.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dnotify.h |    1 +
 include/linux/fs.h      |    3 ---
 kernel/sysctl.c         |    1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/dnotify.h~dnotify-move-dir_notify_enable-declaration include/linux/dnotify.h
--- a/include/linux/dnotify.h~dnotify-move-dir_notify_enable-declaration
+++ a/include/linux/dnotify.h
@@ -28,6 +28,7 @@ struct dnotify_struct {
 			    FS_CREATE | FS_DN_RENAME |\
 			    FS_MOVED_FROM | FS_MOVED_TO)
 
+extern int dir_notify_enable;
 extern void dnotify_flush(struct file *, fl_owner_t);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
 
diff -puN include/linux/fs.h~dnotify-move-dir_notify_enable-declaration include/linux/fs.h
--- a/include/linux/fs.h~dnotify-move-dir_notify_enable-declaration
+++ a/include/linux/fs.h
@@ -407,9 +407,6 @@ extern int get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
-#ifdef CONFIG_DNOTIFY
-extern int dir_notify_enable;
-#endif
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff -puN kernel/sysctl.c~dnotify-move-dir_notify_enable-declaration kernel/sysctl.c
--- a/kernel/sysctl.c~dnotify-move-dir_notify_enable-declaration
+++ a/kernel/sysctl.c
@@ -42,6 +42,7 @@
 #include <linux/times.h>
 #include <linux/limits.h>
 #include <linux/dcache.h>
+#include <linux/dnotify.h>
 #include <linux/syscalls.h>
 #include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
dnotify-move-dir_notify_enable-declaration.patch
mpt-fusion-convert-to-seq_file.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

