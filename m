From: akpm@linux-foundation.org
Subject: + exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:57:42 -0700
Message-ID: <200907212357.n6LNvgg3021606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbZGUX6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, earl_chew@agilent.com, oleg@tv-sign.ru


The patch titled
     exec: allow do_coredump() to wait for user space pipe readers to complete
has been added to the -mm tree.  Its filename is
     exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

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
Subject: exec: allow do_coredump() to wait for user space pipe readers to complete
From: Neil Horman <nhorman@tuxdriver.com>

Allow core_pattern pipes to wait for user space to complete

One of the things that user space processes like to do is look at metadata
for a crashing process in their /proc/<pid> directory.  this is racy
however, since do_coredump in the kernel doesn't wait for the user space
process to complete before it reaps the crashing process.  This patch
corrects that.  Allowing the kernel to wait for the user space process to
complete before cleaning up the crashing process.  This is a bit tricky to
do for a few reasons:

1) The user space process isn't our child, so we can't sys_wait4 on it
2) We need to close the pipe before waiting for the user process to complete,
since the user process may rely on an EOF condition

I've discussed several solutions with Oleg Nesterov off-list about this,
and this is the one we've come up with.  We add ourselves as a pipe reader
(to prevent premature cleanup of the pipe_inode_info), and remove
ourselves as a writer (to provide an EOF condition to the writer in user
space), then we iterate until the user space process exits (which we
detect by pipe->readers == 1, hence the > 1 check in the loop).  When we
exit the loop, we restore the proper reader/writer values, then we return
and let filp_close in do_coredump clean up the pipe data properly.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/exec.c~exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9 fs/exec.c
--- a/fs/exec.c~exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9
+++ a/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/kmod.h>
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
+#include <linux/pipe_fs_i.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1718,6 +1719,29 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
+static void wait_for_dump_helpers(struct file *file)
+{
+	struct pipe_inode_info *pipe;
+
+	pipe = file->f_path.dentry->d_inode->i_pipe;
+
+	pipe_lock(pipe);
+	pipe->readers++;
+	pipe->writers--;
+
+	while ((pipe->readers > 1) && (!signal_pending(current))) {
+		wake_up_interruptible_sync(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+		pipe_wait(pipe);
+	}
+
+	pipe->readers--;
+	pipe->writers++;
+	pipe_unlock(pipe);
+
+}
+
+
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
@@ -1875,6 +1899,8 @@ void do_coredump(long signr, int exit_co
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
+	if (ispipe && core_pipe_limit)
+		wait_for_dump_helpers(file);
 	filp_close(file, NULL);
 fail_dropcount:
 	if (dump_count)
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
kmod-fix-race-in-usermodehelper-code.patch
proc-fix-reported-unit-for-rlimit_cpu.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

