Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA1142DA3D
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757202; cv=none; b=DtL56rcCH8v5U3n5Kiga8XxbCKbfn/MARZfWfjBfgM67+4CfjFrfPWbXXD/xovPdxk+pw0WZ9nHKfDz5eA6Bd8e4tUT0DNdXz5LmeNPrxnq1EJNx1Z6jg7vuu9IOckr9pmY3a0QsLa8WZt8VZQ1Yx8zPig2BVGlK/Eq1IBflJQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757202; c=relaxed/simple;
	bh=WMo1wGOBle/wVzOddtg05qWCGk3xyKLJDlmTtqdGMac=;
	h=Date:To:From:Subject:Message-Id; b=rbyWbFY+77zlmrgSI37+7woSGvipfI/zmrvCopkw4rdizj5yzgu9A7dJsJ81gfoRZN1AP0gL2b+ZWTvUcU97Dro6wio10K2UquK5qYAat5L4KBNkHHZlGCqG3D+DqmbhI8Oiu7BfRt+20L9pO+ygmpeDfKEe8DvKL6lMUlMxDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPSlwR0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPSlwR0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B133D1F0089C;
	Sun, 11 Oct 2026 22:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757200;
	bh=PRqM3MjAZfbSxjL1g9smuNZBxmBtmivT8D2h58iAcu4=;
	h=Date:To:From:Subject;
	b=EPSlwR0Y3SW33XThmmJ47J+PGEABRkScXvFtS+EKoNJXTygAXRmOfEpjx7clfYEwe
	 PsWwqBNuZkwc6AdmB4b8TIyC3lJfuwakkh692Y3m0kVxcEVjjfQTyoSs79kqcWbYhi
	 ncu4Kqg2vgd2DAe0OgJIbH9vdmJZC5OdJLaa4aFw=
Date: Sun, 11 Oct 2026 15:20:00 -0700
To: mm-commits@vger.kernel.org,zzzccc427@gmail.com,sashiko-bot@kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch removed from -mm tree
Message-Id: <20261011222000.B133D1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2/cluster: hold a reference on the heartbeat thread
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: ocfs2/cluster: hold a reference on the heartbeat thread
Date: Wed, 23 Sep 2026 03:01:49 +0200

Since commit 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node
stable"), o2hb_thread() leaves its loop and returns when the local node
changes, for example after "echo 0 > node/<name>/local".  The thread was
started with kthread_run() and nothing holds a reference to its
task_struct, so the task is freed once it exits, while reg->hr_task still
points to it.

Reading the region's pid attribute then reads the freed task, and removing
the region calls kthread_stop() on it:

  BUG: KASAN: slab-use-after-free in o2hb_region_pid_show+0xb3/0xc0
  refcount_t: addition on 0; use-after-free.
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:kthread_stop+0xb1/0x390

The thread could already return by itself before, when heartbeat start was
aborted or on an unclean stop, but the local node change makes it
reachable from userspace at any time.

Create the thread, take a reference on it and only then wake it, so the
reference cannot race with the thread exiting.  Drop it with
kthread_stop_put().

Link: https://lore.kernel.org/20260923010149.14391-1-kmehltretter@gmail.com
Fixes: 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node stable")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260616074931.3774929-1-zzzccc427%40gmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Heming Zhao <heming.zhao@suse.com>
---

 fs/ocfs2/cluster/heartbeat.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1966,18 +1966,22 @@ static ssize_t o2hb_region_dev_store(str
 	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 	o2hb_set_region_stopping(reg, false);
 
-	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
-			      reg->hr_item.ci_name);
+	hb_task = kthread_create(o2hb_thread, reg, "o2hb-%s",
+				 reg->hr_item.ci_name);
 	if (IS_ERR(hb_task)) {
 		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
 		goto out;
 	}
+	/* The thread may exit on its own, so pin it before it can run. */
+	get_task_struct(hb_task);
 
 	spin_lock(&o2hb_live_lock);
 	reg->hr_task = hb_task;
 	spin_unlock(&o2hb_live_lock);
 
+	wake_up_process(hb_task);
+
 	ret = wait_event_interruptible(o2hb_steady_queue,
 				atomic_read(&reg->hr_steady_iterations) == 0 ||
 				reg->hr_node_deleted);
@@ -2022,7 +2026,7 @@ out:
 		spin_unlock(&o2hb_live_lock);
 
 		if (hb_task)
-			kthread_stop(hb_task);
+			kthread_stop_put(hb_task);
 
 		o2hb_unmap_slot_data(reg);
 
@@ -2208,7 +2212,7 @@ static void o2hb_heartbeat_group_drop_it
 	spin_unlock(&o2hb_live_lock);
 
 	if (hb_task)
-		kthread_stop(hb_task);
+		kthread_stop_put(hb_task);
 
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

