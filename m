From: akpm@linux-foundation.org
Subject: - cgroups-add-the-trigger-callback-to-struct-cftype.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:39 -0700
Message-ID: <200804300542.m3U5gdSY029165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759502AbYD3GMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: add the trigger callback to struct cftype
has been removed from the -mm tree.  Its filename was
     cgroups-add-the-trigger-callback-to-struct-cftype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add the trigger callback to struct cftype
From: Pavel Emelyanov <xemul@openvz.org>

Trigger callback can be used to receive a kick-up from the user space.  The
string written is ignored.

The cftype->private is used for multiplexing events.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    8 ++++++++
 kernel/cgroup.c        |    4 ++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/cgroup.h~cgroups-add-the-trigger-callback-to-struct-cftype include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-the-trigger-callback-to-struct-cftype
+++ a/include/linux/cgroup.h
@@ -243,6 +243,14 @@ struct cftype {
 	 */
 	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
 
+	/*
+	 * trigger() callback can be used to get some kick from the
+	 * userspace, when the actual string written is not important
+	 * at all. The private field can be used to determine the
+	 * kick type for multiplexing.
+	 */
+	int (*trigger)(struct cgroup *cgrp, unsigned int event);
+
 	int (*release) (struct inode *inode, struct file *file);
 };
 
diff -puN kernel/cgroup.c~cgroups-add-the-trigger-callback-to-struct-cftype kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-the-trigger-callback-to-struct-cftype
+++ a/kernel/cgroup.c
@@ -1410,6 +1410,10 @@ static ssize_t cgroup_file_write(struct 
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->write_u64 || cft->write_s64)
 		return cgroup_write_X64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->trigger) {
+		int ret = cft->trigger(cgrp, (unsigned int)cft->private);
+		return ret ? ret : nbytes;
+	}
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
ptrace-allow-to-ptrace-sbin-init.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

