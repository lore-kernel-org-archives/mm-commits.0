Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1E833D503;
	Wed,  7 Oct 2026 02:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338652; cv=none; b=IO8QRNuFcR7heQx+YuiA/otTqJmZN/wWjID+jEB8JcEdDKA9+S6aI4J5a6pTRzLMbTIvkw479AFRVxcUu4WrNLSCPPdsP5SzZ3i7TOP8sgxr6oq50Rxxg/BB+moeTX3ys2hZiNDpY1nsuJNiIVIaX64wexKoX/77G2BA4Y+6hms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338652; c=relaxed/simple;
	bh=MEPnfTXKuNDCf0BxJTuDAheMfXU/OHmCONWr7u+1DwA=;
	h=Date:To:From:Subject:Message-Id; b=n5e2vVPX2rCNVXykEhgd7KivOIOz3xHaKYN0BqSstCg3g7U7u1xf7sdremRgAlWMGitxfP+ZBYTdirLuPF/iiZUDNMkwQVTQckc0Uu/eZSt0A/RSI4G0tGET7VFPIxbMG//4Ldc1pduXLKNZ9WpRcLQuet8weSKWPXfWrIHydoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nliyGYvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nliyGYvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541BC1F0089B;
	Wed,  7 Oct 2026 02:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338651;
	bh=/Nwaz6oFMsX1/VdRYZq/oWLlDkZEBQvnVXJzUdnRfks=;
	h=Date:To:From:Subject;
	b=nliyGYvXUPHsp7R7ydZUQHa+U/H3LX0tJ4hkqnaddxjxRl68XmNu698wD8O+B/xve
	 87k1+P5HoRV97MGuiUcDQAmQEIsW0EQFboma7JMMVL0tiUrOHHy5hg0tli/3ppb8PR
	 IWPvXpvBtn2WhexWNlqvFsotbpTRD7SI4wRyKL8A=
Date: Tue, 06 Oct 2026 19:04:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch removed from -mm tree
Message-Id: <20261007020411.541BC1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: free replay slots in ocfs2_recovery_exit()
has been removed from the -mm tree.  Its filename was
     ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: free replay slots in ocfs2_recovery_exit()
Date: Fri, 28 Aug 2026 19:28:24 +0800

Commit ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
added ocfs2_free_replay_slots() calls to the mount error paths
out_dismount and out_check_volume to fix a leak of osb->replay_map. 
However these calls are unlocked while the bail path of the recovery
thread, which is woken up by out_dismount right before the call, also
frees the replay slots under osb->recovery_lock.  Both sides can thus
observe a non-NULL osb->replay_map and trigger a double free.

Fix this by moving ocfs2_free_replay_slots() into ocfs2_recovery_exit()
after ocfs2_recovery_disable(), which waits for a running recovery thread
to exit under osb->recovery_lock, and drop the unlocked call sites.  Both
ocfs2_dismount_volume() and the out_super path of ocfs2_fill_super() call
ocfs2_recovery_exit(), so the replay slots are freed on every path.  Since
super.c no longer references it, make ocfs2_free_replay_slots() static
again.

Link: https://lore.kernel.org/20260828112825.666097-2-joseph.qi@linux.alibaba.com
Fixes: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
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

 fs/ocfs2/journal.c |    3 ++-
 fs/ocfs2/journal.h |    1 -
 fs/ocfs2/super.c   |    5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-free-replay-slots-in-ocfs2_recovery_exit
+++ a/fs/ocfs2/journal.c
@@ -156,7 +156,7 @@ static void ocfs2_queue_replay_slots(str
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -243,6 +243,7 @@ void ocfs2_recovery_exit(struct ocfs2_su
 	/* XXX: Should we bug if there are dirty entries? */
 
 	kfree(rm);
+	ocfs2_free_replay_slots(osb);
 }
 
 static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
--- a/fs/ocfs2/journal.h~ocfs2-free-replay-slots-in-ocfs2_recovery_exit
+++ a/fs/ocfs2/journal.h
@@ -151,7 +151,6 @@ void ocfs2_recovery_exit(struct ocfs2_su
 void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
-void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
--- a/fs/ocfs2/super.c~ocfs2-free-replay-slots-in-ocfs2_recovery_exit
+++ a/fs/ocfs2/super.c
@@ -1162,7 +1162,6 @@ static int ocfs2_fill_super(struct super
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
-	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1776,14 +1775,12 @@ static int ocfs2_mount_volume(struct sup
 	status = ocfs2_truncate_log_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_check_volume;
+		goto out_system_inodes;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
-out_check_volume:
-	ocfs2_free_replay_slots(osb);
 out_system_inodes:
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

