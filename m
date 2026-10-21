Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560638;
	b=1aFHfq3spbMbrMlt94vln2S2s5tUP8im07p4n7esDIVrVr4/8HYHE0g1DUllkDBW//Fl
	 UzCzcb/G+3rhtW9zO3PvlJ4ce2Cw9Rhr0kWqzwTuAvIWYgjosRw2AQRjgbThImz5S9ff+
	 k+f75IGn5GT3W9nVPHgLeEzU1KzsEaK98HXp51sQ41n8zMgNwETDB8QSq6mfQLwOksqQm
	 ns+oRZADWX270ceZwg2FRlANyRZ1HCIvzjzOuEsZCpe93wnKtPSBWeUXKrBseaeNpR4z7
	 h2ZVOMjR8QQIxrbMJrEZvldKapH/8SigF3ZKJ53gr9EaHvECIQY5FLrEhb9HJZSN61Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560638;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ezjjgdVUalHMYQ8R+yomutb3EERlvlvKCYs+JkQUlDQ=;
	b=4e5s1nQ2Q0tIXreRe0gn/A+ATN8TL7wPcOq45hVJMz9qp1EBmqjBNvR8xH5BMVBDVGFa
	 TUdwQetKzvs1vE6C1LacxXL/CK0moJfsdZQhTMxsaEzJN6fMbuq7zqN4z+sp9QirsDn3w
	 AhrYAeFJsTTUFa1B1OKGwD8njMhAhUwZleVXXlSkEegHq9DlLJ75Amt48i13qkXqhFHk0
	 3XUIeYa7ocelRiP2SphFTqop+d4D+c9f1kBcLmyHni9cZWWJYEV34xVJ0q/4da82qE5tY
	 ji6IwsngWsnr+1s1FlDYLEHD3pbZYU2FzGXV8tE/tM3XOYKHaQ0Ko7lJ8k4r/OdAVOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="KP21vn/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F53E606A319
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KP21vn/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B281F000C9;
	Wed, 21 Oct 2026 05:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560638;
	bh=ezjjgdVUalHMYQ8R+yomutb3EERlvlvKCYs+JkQUlDQ=;
	h=Date:To:From:Subject;
	b=KP21vn/HucjjaQnj41QoyVIb5XH9jSINlNo7kNO6DittUeGXlET/H9oxAXfPGXPKO
	 l5veZzj/SvcyaWXqXabJXmkEQKalKk20Hr6Y8v5TzFefQQ/peO4g8aONihq9cs9d3A
	 NQzfRvWzDlXBGYuVEmJh2Uu5R+wLyYQXix+Y0uls=
Date: Tue, 20 Oct 2026 22:30:37 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,kurt.hackel@oracle.com,kuba@kernel.org,kees@kernel.org,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-initialize-status-waiters-before-publishing-them.patch removed from -mm tree
Message-Id: <20261021053038.28B281F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: initialize status waiters before publishing them
has been removed from the -mm tree.  Its filename was
     ocfs2-initialize-status-waiters-before-publishing-them.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


