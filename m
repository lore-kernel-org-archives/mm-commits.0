From: akpm@linux-foundation.org
Subject: - allow-access-to-proc-pid-fd-after-setuid-update-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:57:54 -0800
Message-ID: <200703060057.l260vtlW006904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXCFA6A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:58:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Allow access to /proc/$PID/fd after setuid()
has been removed from the -mm tree.  Its filename was
     allow-access-to-proc-pid-fd-after-setuid-update-2.patch

This patch was dropped because it was folded into allow-access-to-proc-pid-fd-after-setuid.patch

------------------------------------------------------
Subject: Allow access to /proc/$PID/fd after setuid()
From: Alexey Dobriyan <adobriyan@openvz.org>

Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update-2 fs/proc/base.c
--- a/fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update-2
+++ a/fs/proc/base.c
@@ -1454,18 +1454,13 @@ static struct file_operations proc_fd_op
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

ia64-sync-compat-getdents-on-ia64-and-parisc.patch
parisc-sync-compat-getdents-on-ia64-and-parisc.patch
x86_64-wire-up-compat-sched_rr_get_interval2.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
