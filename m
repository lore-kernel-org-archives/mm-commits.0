From: akpm@linux-foundation.org
Subject: + allow-access-to-proc-pid-fd-after-setuid-update-2.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:00:26 -0800
Message-ID: <200702092300.l19N0QUs028662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXBIXA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:00:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ebiederm@xmission.com


The patch titled
     Allow access to /proc/$PID/fd after setuid()
has been added to the -mm tree.  Its filename is
     allow-access-to-proc-pid-fd-after-setuid-update-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow access to /proc/$PID/fd after setuid()
From: Alexey Dobriyan <adobriyan@openvz.org>

Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update-2 fs/proc/base.c
--- a/fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update-2
+++ a/fs/proc/base.c
@@ -1420,18 +1420,13 @@ static struct file_operations proc_fd_op
 static int proc_fd_permission(struct inode *inode, int mask,
 				struct nameidata *nd)
 {
-	struct task_struct *tsk;
 	int rv;
 
 	rv = generic_permission(inode, mask, NULL);
 	if (rv == 0)
 		return 0;
-	tsk = get_proc_task(inode);
-	if (tsk) {
-		if (tsk == current)
-			rv = 0;
-		put_task_struct(tsk);
-	}
+	if (task_pid(current) == proc_pid(inode))
+		rv = 0;
 	return rv;
 }
 
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-net.patch
revert-x86_64-mm-msr-on-cpu.patch
rdmsr_on_cpu-wrmsr_on_cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
