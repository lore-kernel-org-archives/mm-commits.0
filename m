From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning.patch added to -mm tree
Date: Thu, 08 Mar 2012 11:59:29 -0800
Message-ID: <20120308195929.AAE47A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:38806 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752905Ab2CHT7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:59:32 -0500
Received: by laai8 with SMTP id i8so30717laa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:59:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, davej@redhat.com


The patch titled
     Subject: mm, hugetlb: add thread name and pid to SHM_HUGETLB mlock rlimit warning
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -944,7 +944,11 @@ struct file *hugetlb_file_setup(const ch
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
Subject: Subject: mm, hugetlb: add thread name and pid to SHM_HUGETLB mlock rlimit warning

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
slab-introduce-kmalloc_array.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
rmap-remove-__anon_vma_link.patch
mm-oom-force-oom-kill-on-sysrqf.patch
mm-memcg-pass-charge-order-to-oom-killer.patch
cpuset-mm-reduce-large-amounts-of-memory-barrier-related-damage-v3.patch
mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch
mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch
mm-hugetlb-add-thread-name-and-pid-to-shm_hugetlb-mlock-rlimit-warning.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
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

