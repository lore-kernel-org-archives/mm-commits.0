Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1D8417BD2
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 21:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790198572; cv=none; b=VeJ6gTMlA1YdNRLwC3TozoO5PcJrA71cBVlpVmDg9BHPTPHqroiai4/WfVdpXQiI9Ojooya1q2SSP5jwk/ciBXzAjGetcnlPnJeUVXkQZ+WocpSsfUUio11xCnBbOs4iIuYNjmggcqBygdeQnb7qxMajItSS8xeCIRchagoW8xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790198572; c=relaxed/simple;
	bh=wFpfbq0VRI/qgU+pJQ+yPUaIr1JfaYnn+QEtgri3Mfs=;
	h=Date:To:From:Subject:Message-Id; b=Ffv3YSJdtgyGtC5B6SRWBTDxzq6xi995qE4owT4j/trJ96kGgWoPJ5DwTzctRrXGGfB/f4J0i/XoLiNnvAHwnEB3WHjw3maMuQE02lBBM4+J/6D688pKt/Ipi9PjRKFvFBwbMJRHoR/pRIHXsKwqI1N/QmoG5HMBPEaCHuPV+YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=doRugzxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="doRugzxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4930B1F000FF;
	Wed, 23 Sep 2026 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790198567;
	bh=f09lHb3OiGIhhws2pV8yPG1CB5NBRnG7jikrHEdQTvE=;
	h=Date:To:From:Subject;
	b=doRugzxH+gGmke2vtyZu3hR2SI8AOM77rqG30e2AYL+NfSltiai/ZSJwdkkE9x3e7
	 +9dekz+LCERClD19CLhTa9d6JDIZSCYGdYYhKaGoc80SNY1Nl4+Ui09u5Vm+Ua1rvH
	 zMgKXuhS5kQHp9Jkc4zWQ42PdohD9xc5TPKZBzPM=
Date: Wed, 23 Sep 2026 14:22:46 -0700
To: mm-commits@vger.kernel.org,zzzccc427@gmail.com,sashiko-bot@kernel.org,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch added to mm-nonmm-unstable branch
Message-Id: <20260923212247.4930B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2/cluster: hold a reference on the heartbeat thread
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Cen Zhang <zzzccc427@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Assisted-by: LLM
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

docs-mm-ksm-use-the-renamed-ksm-structure-names.patch
mm-secretmem-fix-the-enable-parameter-description.patch
klist-avoid-accesses-after-waking-klist_remove.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch
fork-honor-task_structs-declared-alignment.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch

