From: akpm@linux-foundation.org
Subject: + allow-access-to-proc-pid-fd-after-setuid-update.patch added to -mm tree
Date: Fri, 02 Feb 2007 15:05:38 -0800
Message-ID: <200702022305.l12N5cK4020325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946141AbXBBXG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 18:06:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, chrisw@sous-sol.org, dev@openvz.org, drepper@redhat.com, ebiederm@xmission.com, hch@lst.de, jmorris@namei.org, oleg@tv-sign.ru, viro@zeniv.linux.org.uk


The patch titled
     allow-access-to-proc-pid-fd-after-setuid-v2
has been added to the -mm tree.  Its filename is
     allow-access-to-proc-pid-fd-after-setuid-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: allow-access-to-proc-pid-fd-after-setuid-v2
From: Alexey Dobriyan <adobriyan@openvz.org>

crap, Pavel reminded that get_proc_task() can return NULL.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update fs/proc/base.c
--- a/fs/proc/base.c~allow-access-to-proc-pid-fd-after-setuid-update
+++ a/fs/proc/base.c
@@ -1427,9 +1427,11 @@ static int proc_fd_permission(struct ino
 	if (rv == 0)
 		return 0;
 	tsk = get_proc_task(inode);
-	if (tsk == current)
-		rv = 0;
-	put_task_struct(tsk);
+	if (tsk) {
+		if (tsk == current)
+			rv = 0;
+		put_task_struct(tsk);
+	}
 	return rv;
 }
 
_

Patches currently in -mm which might be from adobriyan@openvz.org are

revert-x86_64-mm-msr-on-cpu.patch
rdmsr_on_cpu-wrmsr_on_cpu.patch
p4-clockmod-use-rdmsr_on_cpu-wrmsr_on_cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
