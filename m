From: akpm@linux-foundation.org
Subject: [merged] oom-fix-oom_adjust_write-input-sanity-check.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:27 -0700
Message-ID: <200909222042.n8MKgR3p009608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbZIVUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: fix oom_adjust_write() input sanity check
has been removed from the -mm tree.  Its filename was
     oom-fix-oom_adjust_write-input-sanity-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: fix oom_adjust_write() input sanity check
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Andrew Morton pointed out oom_adjust_write() has very strange EIO
and new line handling. this patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~oom-fix-oom_adjust_write-input-sanity-check fs/proc/base.c
--- a/fs/proc/base.c~oom-fix-oom_adjust_write-input-sanity-check
+++ a/fs/proc/base.c
@@ -1021,21 +1021,24 @@ static ssize_t oom_adjust_write(struct f
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
-	int oom_adjust;
+	char buffer[PROC_NUMBUF];
+	long oom_adjust;
 	unsigned long flags;
+	int err;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	oom_adjust = simple_strtol(buffer, &end, 0);
+
+	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
+	if (err)
+		return -EINVAL;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
 	     oom_adjust != OOM_DISABLE)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
+
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -1054,9 +1057,8 @@ static ssize_t oom_adjust_write(struct f
 
 	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 static const struct file_operations proc_oom_adjust_operations = {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

