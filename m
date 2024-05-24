Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8620840861;
	Fri, 24 May 2024 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576955; cv=none; b=PNsIXbLMBhCmwyubjGf3OIrUlMVkUO563Uen+shSnB579zT0VktvEnpeaTdnGHvGevnQjo3tqreIERVOW6RdLlHM/+nIxQ+A5LQQn395k1iJzMBjieuS4a2p/5rOK3aOBQqvqWV+0G7E7vwygG2tG3ZcPFp8Jo672c4LZSdDxXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576955; c=relaxed/simple;
	bh=tKE3st4xotQlWA9peJNnfcdXeE/TkNjJegwrifCxIfk=;
	h=Date:To:From:Subject:Message-Id; b=oOW76mQLOWafzUFzdvwWMrGqR9P+C/sUjvOr2DteVn8ZocKNkqhcqIAl7Cquz5kEVdPnsFDI6aZhhwJiQgPHFLGhDPHf+Ykdruwx3gKqTwFgetpV4FxEkuPUOjbCu42xOjtkhQdZkirqQwmtsj138Mzol8Og5oEUkRcuR7VvNPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kz30vKO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kz30vKO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A757C2BBFC;
	Fri, 24 May 2024 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576955;
	bh=tKE3st4xotQlWA9peJNnfcdXeE/TkNjJegwrifCxIfk=;
	h=Date:To:From:Subject:From;
	b=kz30vKO01acafe36Sm4vinNLXIP+LRXeCgmW/aJw8f5D117peWuaNDZdVPpXp135W
	 vAnnTdhhxxPZ/gY6m62YCIEQNIPObJ08ahE2fRbNBQZdctFdDoe70R5iPCiBUcO/pc
	 D+WNbvmiJGaI/hExMRyOC1O5c0gA2sBrly87lMgc=
Date: Fri, 24 May 2024 11:55:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjb7183@psu.edu,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-unexpected-freezing-of-nilfs_segctor_sync.patch removed from -mm tree
Message-Id: <20240524185555.5A757C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix unexpected freezing of nilfs_segctor_sync()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-unexpected-freezing-of-nilfs_segctor_sync.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix unexpected freezing of nilfs_segctor_sync()
Date: Mon, 20 May 2024 22:26:20 +0900

A potential and reproducible race issue has been identified where
nilfs_segctor_sync() would block even after the log writer thread writes a
checkpoint, unless there is an interrupt or other trigger to resume log
writing.

This turned out to be because, depending on the execution timing of the
log writer thread running in parallel, the log writer thread may skip
responding to nilfs_segctor_sync(), which causes a call to schedule()
waiting for completion within nilfs_segctor_sync() to lose the opportunity
to wake up.

The reason why waking up the task waiting in nilfs_segctor_sync() may be
skipped is that updating the request generation issued using a shared
sequence counter and adding an wait queue entry to the request wait queue
to the log writer, are not done atomically.  There is a possibility that
log writing and request completion notification by nilfs_segctor_wakeup()
may occur between the two operations, and in that case, the wait queue
entry is not yet visible to nilfs_segctor_wakeup() and the wake-up of
nilfs_segctor_sync() will be carried over until the next request occurs.

Fix this issue by performing these two operations simultaneously within
the lock section of sc_state_lock.  Also, following the memory barrier
guidelines for event waiting loops, move the call to set_current_state()
in the same location into the event waiting loop to ensure that a memory
barrier is inserted just before the event condition determination.

Link: https://lkml.kernel.org/r/20240520132621.4054-3-konishi.ryusuke@gmail.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Cc: "Bai, Shuangpeng" <sjb7183@psu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-unexpected-freezing-of-nilfs_segctor_sync
+++ a/fs/nilfs2/segment.c
@@ -2168,19 +2168,28 @@ static int nilfs_segctor_sync(struct nil
 	struct nilfs_segctor_wait_request wait_req;
 	int err = 0;
 
-	spin_lock(&sci->sc_state_lock);
 	init_wait(&wait_req.wq);
 	wait_req.err = 0;
 	atomic_set(&wait_req.done, 0);
+	init_waitqueue_entry(&wait_req.wq, current);
+
+	/*
+	 * To prevent a race issue where completion notifications from the
+	 * log writer thread are missed, increment the request sequence count
+	 * "sc_seq_request" and insert a wait queue entry using the current
+	 * sequence number into the "sc_wait_request" queue at the same time
+	 * within the lock section of "sc_state_lock".
+	 */
+	spin_lock(&sci->sc_state_lock);
 	wait_req.seq = ++sci->sc_seq_request;
+	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
 	spin_unlock(&sci->sc_state_lock);
 
-	init_waitqueue_entry(&wait_req.wq, current);
-	add_wait_queue(&sci->sc_wait_request, &wait_req.wq);
-	set_current_state(TASK_INTERRUPTIBLE);
 	wake_up(&sci->sc_wait_daemon);
 
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		if (atomic_read(&wait_req.done)) {
 			err = wait_req.err;
 			break;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


