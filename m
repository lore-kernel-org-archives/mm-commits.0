From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:08 -0700
Message-ID: <20120322201908.7A9C4A06FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63714 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab2CVUTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:10 -0400
Received: by vbnl22 with SMTP id l22so199683vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: add thread name and pid to SHM_HUGETLB mlock rlimit warning
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: add thread name and pid to SHM_HUGETLB mlock rlimit warning

Add the thread name and pid of the application that is allocating shm
segments with MAP_HUGETLB without being a part of
/proc/sys/vm/hugetlb_shm_group or having CAP_IPC_LOCK.

This identifies the application so it may be fixed by avoiding using the
deprecated exception (see Documentation/feature-removal-schedule.txt).

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning
+++ a/fs/hugetlbfs/inode.c
@@ -953,7 +953,11 @@ struct file *hugetlb_file_setup(const ch
 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
-			printk_once(KERN_WARNING "Using mlock ulimits for SHM_HUGETLB is deprecated\n");
+			task_lock(current);
+			printk_once(KERN_WARNING
+				"%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
+				current->comm, current->pid);
+			task_unlock(current);
 		} else {
 			*user = NULL;
 			return ERR_PTR(-EPERM);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

