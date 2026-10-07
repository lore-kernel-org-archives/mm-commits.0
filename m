Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A83346A6;
	Wed,  7 Oct 2026 02:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338651; cv=none; b=gZjyc/HAoIuAz6iknt+AC8API92z/sjjBHI+OUXd/oHCyVQTIXb5MrzOlKEsgyB7OGWuhgtAGvVUaNcUYvzUhn4G4QcrBaXpg8P9UQbJx45pIDZs9eNrSyfSZxU0a3tyOTsujLJ9JpF71fEFpDD8yHKqR2MoCqJ/rfGD7OxtyB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338651; c=relaxed/simple;
	bh=uJ1RgXdWWEShC4JU9dpOZFla18TMYFszoqnBYvonFQw=;
	h=Date:To:From:Subject:Message-Id; b=pB0JCQR5EjeD8Qc8OYUp+/PKrLPI5SooJuJPxnm6nNgQ1dJ4w69V5a+VoJr9VN7L34jyV7I60YRUxT6/Yzh+oZAGeq36e4uHhJPotEiPmLUeCkBK6VEMpgl7RfIqPcAr8LglD1HjJBj70nkG02DY4RF2majpc7gUBfnbTedpXW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EygL2zEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EygL2zEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3DB1F0089C;
	Wed,  7 Oct 2026 02:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338650;
	bh=jSMXwHaKmPIfP7Y88hOpe26rewh+r8icedeyKDbG+Q0=;
	h=Date:To:From:Subject;
	b=EygL2zEB1Lep+/CqTohKrjD2ah4ChDQPljkGCkzm3unOiHTiiKFIv0rBx0xbXTpSD
	 EOxQXD6AYVk1F6RYEwMsVT/2qevhXO7HuYkrSztilpe0mb5ZCBymTk74gYUTCVv0aw
	 s6IWtR1t/6PBkamdjCasKNcMUs4M231aUM+B2xMc=
Date: Tue, 06 Oct 2026 19:04:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-exit-recovery-thread-on-mount-error-path.patch removed from -mm tree
Message-Id: <20261007020410.2D3DB1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: exit recovery thread on mount error path
has been removed from the -mm tree.  Its filename was
     ocfs2-exit-recovery-thread-on-mount-error-path.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
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

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

