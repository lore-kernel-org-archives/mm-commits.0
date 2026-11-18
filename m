Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980508;
	b=OCbNOKchJOtetB5uHJ9wV6vuTnkr60Op5RPPrwLfnRA1G7REf7P/mRRT8gYEeD7eJIwn
	 CKD1fdlKSHYiZl1HpK5Mmjfx3B81OK0iWKPiEpWwOvgIOfPuv3b+/UwJgz7v0wB9QphJk
	 8jBkcWDab8PVPVIzioru+64+HPSbx4/cFk9EBRzmWR6OBkgMEr2Eu8ZtwR0myQi76XYaw
	 ck2OV8Kewaz6bbF9jXH8cnPGYgO6xb7MKTwXMNHoGgwRo8h+bzOje4HA1iDb5q2/ynGOc
	 AeRZUSC+BShjQ0zxJZGflaXecSziZKypg6HuILI8oH8B9SAtF3LZeVYt++og5vXSdPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980508;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=loLwCsz1xrmJHHsuUmOZAIMI2vOlrr1n61+Yg7pdZg4=;
	b=Q/UMujN6c8F8G2UWE/g0va8FJ+9C/wfErp7xdFLd66P0Ud8gouzm8662nGkiAH/WqcrQ
	 D434LxqeDb6e8RT7cTfkhX4efS+k+rVffal0Gs04IceVSKJ60y+8WqCbai1zKN7e8k+J6
	 C9aoNAGh/xely8CIX0MSlR8RPUisAlQYm1sxdXWH1PfqXWQmQtRPsBgTTAwt2F9NjsWM3
	 wfHPgjLbo3vkWo3Qo2YgchlmAEuLrn3GMKUJ93enS3B6QePCAlkAGpTDrSKFAzgfia4iP
	 YLY4zkmtQChrskT9YksOPbiIBs2r41Fay/aW78C9UiN6kkqZLgcjJpbqM1CkThNrMMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YMTsqWrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1285F606A31C;
	Wed, 18 Nov 2026 05:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YMTsqWrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4091F000C6;
	Wed, 18 Nov 2026 05:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980507;
	bh=loLwCsz1xrmJHHsuUmOZAIMI2vOlrr1n61+Yg7pdZg4=;
	h=Date:To:From:Subject;
	b=YMTsqWrxQWlV6lMZLJV64GJXr1urIwFjusLUGaVM0wGcP/jf9VKya190Y5poTwLK4
	 VEI+n/+lvLzW0T/T8d8pPUgfD4uvU02qi0NIJVeQT1SgylEqqKUrqNzxrE0lAMbkqe
	 l/tBopRyucfVGe/PUjs9k2/jJuvhv6wk+LGVurPk=
Date: Tue, 17 Nov 2026 21:41:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-dlmfs-keep-the-superblock-alive-during-lock-work.patch removed from -mm tree
Message-Id: <20261118054147.CE4091F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2/dlmfs: keep the superblock alive during lock work
has been removed from the -mm tree.  Its filename was
     ocfs2-dlmfs-keep-the-superblock-alive-during-lock-work.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/dlmfs: keep the superblock alive during lock work
Date: Thu, 29 Oct 2026 15:00:13 +0800

Queued dlmfs lock work holds an inode reference, but no active reference
to its superblock.  The workqueue is drained on module exit rather than on
each dlmfs unmount, and an inode reference does not stop superblock
shutdown: generic_shutdown_super() reports the busy inode and goes on.

  DLM callback / worker               Unmount
  ---------------------               -------
  queue lock work; igrab(inode)
  worker delayed
                                      drop last active superblock ref
                                      kill_anon_super()
                                        report the busy inode
                                        free the superblock
  finish lock work
  iput(inode)
    access the inode's freed superblock

Flushing the workqueue from a dlmfs kill_sb would not be enough: a
blocking AST can queue new work for an inode that is still alive after the
flush and before eviction, and that work again holds only an inode
reference.

Take an active superblock reference before acquiring the queued inode
reference, with the atomic_inc_not_zero() on s_active that grab_super()
and the NFS and procfs superblock walkers use.  Decline to queue if the
superblock is already shutting down; the inode is then being evicted and
user_dlm_destroy_lock() tears the lock down.  The existing l_lock and
USER_LOCK_QUEUED flag serialize this with other queue attempts.  Each
execution drops its inode reference before releasing the active superblock
reference, outside l_lock.  If that releases the last active reference,
the unmount completes on the worker; it only waits for DLM replies and
never for this workqueue.

Only the relevant frames of the report are kept:

Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000026: 0000 [#1] SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0xdead000000000130-0xdead000000000137]
Workqueue: user_dlm user_dlm_unblock_lock
RIP: 0010:iput+0x246/0xc10
Call Trace:
 <TASK>
 user_dlm_unblock_lock+0x503/0xa50
 process_one_work+0x9a8/0x1b40
 worker_thread+0x65c/0xe40
 </TASK>

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0054-v6-c3887cceae3b039e591e@gmail.com
Fixes: 8df08c89c668 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>

 fs/ocfs2/dlmfs/userdlm.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dlmfs/userdlm.c~ocfs2-dlmfs-keep-the-superblock-alive-during-lock-work
+++ a/fs/ocfs2/dlmfs/userdlm.c
@@ -162,7 +162,13 @@ static void user_dlm_unblock_lock(struct
 
 static void __user_dlm_queue_lockres(struct user_lock_res *lockres)
 {
+	struct inode *inode = user_dlm_inode_from_user_lockres(lockres);
+
 	if (!(lockres->l_flags & USER_LOCK_QUEUED)) {
+		/* Pin the superblock through the worker's iput(). */
+		if (!atomic_inc_not_zero(&inode->i_sb->s_active))
+			return;
+
 		user_dlm_grab_inode_ref(lockres);
 
 		INIT_WORK(&lockres->l_work, user_dlm_unblock_lock);
@@ -275,9 +281,11 @@ static struct ocfs2_locking_protocol use
 
 static inline void user_dlm_drop_inode_ref(struct user_lock_res *lockres)
 {
-	struct inode *inode;
-	inode = user_dlm_inode_from_user_lockres(lockres);
+	struct inode *inode = user_dlm_inode_from_user_lockres(lockres);
+	struct super_block *sb = inode->i_sb;
+
 	iput(inode);
+	deactivate_super(sb);
 }
 
 static void user_dlm_unblock_lock(struct work_struct *work)
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker.patch

