Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB936606A;
	Fri, 28 Aug 2026 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787935949; cv=none; b=f3BUDy9KBBtyBVTKTDQGbIl0EmP6qZts6yKiDSx6TinQ5R9QB7o0x6iICbKlOY8eyo2l2tiijAJ0jx6ylwHSUZ+qoxizQnZStf5AJratx0Rt98jtCPtnxSyV+2BSbLbqOZJfXZ/vKa1a3T2y8vCVVlPAKwFdbqWuTcIKER6mEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787935949; c=relaxed/simple;
	bh=xcFaBX/yGiww1B/zi6hp59SmM4SUpOLpxK8XViOzfO8=;
	h=Date:To:From:Subject:Message-Id; b=J2g6Ec1U0HPtuMrHzI/BAQBH4GTpPBuTdo1sZCUnjiB5Twm0V0URhcm8mSiPvEni48iu0XAlwugAzMoAO4FM898vyDs5bj+saBcG2KDHD2S/RpWCyhgZh+lVhjt6Zrv7nac2S09KvOLUvNBGj3ypgXtgFlRFvMAYF+0Id1JES1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a5Gxi5+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a5Gxi5+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BA81F000E9;
	Fri, 28 Aug 2026 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787935948;
	bh=pf52ODsl1feCknhVqPeO3xiaQTjUuzN0crTPYEgM1Mo=;
	h=Date:To:From:Subject;
	b=a5Gxi5+03WEiv5bZcurrnMRZ/nlpGLZztGZLLdvjkmVHPjUSgk+AHVUWiggfwMg2/
	 gg0vH9N6SQ0J6wdjWsGwHbn9kf0p7wp0cLvv14aMLhXIRH2RI4Sdx6lkBeHLmWBnXR
	 iu+zfQatrNypVdEFSXwfvwVMuSgGQ4mQL6FEEI50=
Date: Fri, 28 Aug 2026 09:52:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-exit-recovery-thread-on-mount-error-path.patch added to mm-nonmm-unstable branch
Message-Id: <20260828165227.D8BA81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: exit recovery thread on mount error path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-exit-recovery-thread-on-mount-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-exit-recovery-thread-on-mount-error-path.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: exit recovery thread on mount error path
Date: Fri, 28 Aug 2026 19:28:23 +0800

When a mount fails after the cluster connection has been established, e.g.
in ocfs2_mount_volume(), ocfs2_fill_super() unwinds via
out_debugfs/out_super and frees the osb without disabling recovery.

A node failure event can concurrently launch the recovery thread, which
blocks in __ocfs2_wait_on_mount() waiting for the volume state to become
VOLUME_MOUNTED or VOLUME_DISABLED.  As the mount error path neither sets
VOLUME_DISABLED nor wakes osb_mount_event, the thread can never make
progress: the kthread leaks and stays blocked on the wait queue embedded
in the freed osb, which may then be accessed as freed memory.

Fix it by setting VOLUME_DISABLED and waking osb_mount_event on this path
so the thread bails out, and replace the plain kfree(osb->recovery_map)
with ocfs2_recovery_exit(), which waits for a running recovery thread to
exit before the recovery map is freed.

Link: https://lore.kernel.org/20260828112825.666097-1-joseph.qi@linux.alibaba.com
Fixes: f1e75d128b46 ("ocfs2: rewrite error handling of ocfs2_fill_super")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/super.c~ocfs2-exit-recovery-thread-on-mount-error-path
+++ a/fs/ocfs2/super.c
@@ -1169,8 +1169,17 @@ out_dismount:
 out_debugfs:
 	debugfs_remove_recursive(osb->osb_debug_root);
 out_super:
+	/*
+	 * A recovery thread launched by a node failure event may still be
+	 * waiting for the volume to be mounted.  Set VOLUME_DISABLED and
+	 * wake it up, then wait for it to exit before osb is freed,
+	 * otherwise the kthread would leak and stay blocked on the wait
+	 * queue embedded in the freed osb.
+	 */
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
 	ocfs2_release_system_inodes(osb);
-	kfree(osb->recovery_map);
+	ocfs2_recovery_exit(osb);
 	ocfs2_delete_osb(osb);
 	kfree(osb);
 out:
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch

