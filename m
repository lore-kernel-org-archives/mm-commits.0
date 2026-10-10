Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F386233E36A
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 23:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673597; cv=none; b=BjCwNYXujxbuDxeePA2hvhbiNrNxxkd6yZtBVfUSqY6yncC0jwst05NRk0mFAo0aclr9D9sF30oY77m+4nM1Vg64iKKzkvdM5i/JkTNn8Qdgog6CfV+bhc8kDB5P1AkzaCV3TcwQkZMvuXMMQiYJ8HQlCp0AZpkt1QpgM/qsXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673597; c=relaxed/simple;
	bh=cBamCqkeGeEzIdpQd/9vFYgy+8Rw6QpnSIsIpvkldKY=;
	h=Date:To:From:Subject:Message-Id; b=UQ1yfwankEEXXjnLjaz3/UPbhMDVHJggaYwpvzaRyp4BiBTDZBIutcg5Vs1hVJOAcjYHMewjYc3oNxQtUQnWrZkbUEmZsUA2D4gJpP4vl1q5d4AflsV5FMXflAVd6Vs9n7e3zrwRhMOz13A89BDKiQ1zqiLQd0Axx83G1LrDXm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qlKj/8uG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qlKj/8uG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFA91F000FF;
	Sat, 10 Oct 2026 23:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791673591;
	bh=kHekkrP8fyfocWS5OBduTMTYi8H3QKXrEQYP6q7JtRw=;
	h=Date:To:From:Subject;
	b=qlKj/8uGE/ud8jYi5DLWUwHw+wwNsprnORnzTXf8B/QjVk0VGNLbrP7SqJVubfrU2
	 7tuO7HFD/3ILb4T5JWSxXnX3tBhYrWViLm/rYdqmmgcoAiG1aNy7O/w+ZctOMDVIrH
	 0zBr8ut+Jz0BGFx4Vl3EGZSZlyrmLITAPZobTxv8=
Date: Sat, 10 Oct 2026 16:06:31 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,kurt.hackel@oracle.com,kuba@kernel.org,kees@kernel.org,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-initialize-status-waiters-before-publishing-them.patch added to mm-nonmm-unstable branch
Message-Id: <20261010230631.9AFA91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: initialize status waiters before publishing them
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-initialize-status-waiters-before-publishing-them.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-initialize-status-waiters-before-publishing-them.patch

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
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: initialize status waiters before publishing them
Date: Fri, 09 Oct 2026 09:43:43 +0800

o2net_prep_nsw() publishes its stack waiter in nn_status_idr and
nn_status_list under nn_lock, then initializes the wait queue and
completion status after releasing the lock.  A concurrent disconnect can
find that waiter through o2net_complete_nodes_nsw() and call wake_up()
before the wait queue has a valid lock and list head.  The sender can also
overwrite a completion status with its initial value.

Initialize the wait queue and status before publishing the waiter. 
nn_lock then orders publication against completion, and no reader can
observe a partially initialized object.  Leave the IDR allocation and its
failure handling unchanged.

A controlled case-modified test kernel used a synthetic connection to
enter the real send path and overlap publication with disconnect.  The
candidate completion and wake-up code were unchanged.  Its Oops includes:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:__wake_up_common+0xa0/0x1f0
  Call Trace:
   <TASK>
   __wake_up+0x36/0x60
   o2net_complete_nsw_locked+0x222/0x370
   o2net_set_nn_state+0x917/0xea0
   o2net_disconnect_node+0xd0/0x190
   o2net_validate_control_write+0x454/0x500
   full_proxy_write+0x11f/0x180
   vfs_write+0x25a/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0066-v1-437a0422801b292a2879@gmail.com
Fixes: 98211489d414 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
---

 fs/ocfs2/cluster/tcp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/cluster/tcp.c~ocfs2-initialize-status-waiters-before-publishing-them
+++ a/fs/ocfs2/cluster/tcp.c
@@ -301,6 +301,11 @@ static int o2net_prep_nsw(struct o2net_n
 {
 	int ret;
 
+	/* Initialize all completion-visible state before publishing the waiter. */
+	init_waitqueue_head(&nsw->ns_wq);
+	nsw->ns_sys_status = O2NET_ERR_NONE;
+	nsw->ns_status = 0;
+
 	spin_lock(&nn->nn_lock);
 	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
 	if (ret >= 0) {
@@ -311,9 +316,6 @@ static int o2net_prep_nsw(struct o2net_n
 	if (ret < 0)
 		return ret;
 
-	init_waitqueue_head(&nsw->ns_wq);
-	nsw->ns_sys_status = O2NET_ERR_NONE;
-	nsw->ns_status = 0;
 	return 0;
 }
 
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch
ocfs2-initialize-status-waiters-before-publishing-them.patch

