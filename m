From: akpm@linux-foundation.org
Subject: + reiserfs-dont-lock-root-inode-searching.patch added to -mm tree
Date: Tue, 22 Nov 2011 12:06:35 -0800
Message-ID: <201111222006.pAMK6Zan004788@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:62555 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1KVUGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 15:06:37 -0500
Received: by qyk10 with SMTP id 10so52177qyk.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 12:06:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, Knut_Petersen@t-online.de, hch@lst.de, jeffm@suse.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: reiserfs: don't lock root inode searching
has been added to the -mm tree.  Its filename is
     reiserfs-dont-lock-root-inode-searching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: reiserfs: don't lock root inode searching

Nothing requires that we lock the filesystem until the root inode is
provided.

Also iget5_locked() triggers a warning because we are holding the
filesystem lock while allocating the inode, which result in a lockdep
suspicion that we have a lock inversion against the reclaim path:

[ 1986.896979] =================================
[ 1986.896990] [ INFO: inconsistent lock state ]
[ 1986.896997] 3.1.1-main #8
[ 1986.897001] ---------------------------------
[ 1986.897007] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 1986.897016] kswapd0/16 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1986.897023]  (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c01f8bd4>] reiserfs_write_lock+0x20/0x2a
[ 1986.897044] {RECLAIM_FS-ON-W} state was registered at:
[ 1986.897050]   [<c014a5b9>] mark_held_locks+0xae/0xd0
[ 1986.897060]   [<c014aab3>] lockdep_trace_alloc+0x7d/0x91
[ 1986.897068]   [<c0190ee0>] kmem_cache_alloc+0x1a/0x93
[ 1986.897078]   [<c01e7728>] reiserfs_alloc_inode+0x13/0x3d
[ 1986.897088]   [<c01a5b06>] alloc_inode+0x14/0x5f
[ 1986.897097]   [<c01a5cb9>] iget5_locked+0x62/0x13a
[ 1986.897106]   [<c01e99e0>] reiserfs_fill_super+0x410/0x8b9
[ 1986.897114]   [<c01953da>] mount_bdev+0x10b/0x159
[ 1986.897123]   [<c01e764d>] get_super_block+0x10/0x12
[ 1986.897131]   [<c0195b38>] mount_fs+0x59/0x12d
[ 1986.897138]   [<c01a80d1>] vfs_kern_mount+0x45/0x7a
[ 1986.897147]   [<c01a83e3>] do_kern_mount+0x2f/0xb0
[ 1986.897155]   [<c01a987a>] do_mount+0x5c2/0x612
[ 1986.897163]   [<c01a9a72>] sys_mount+0x61/0x8f
[ 1986.897170]   [<c044060c>] sysenter_do_call+0x12/0x32
[ 1986.897181] irq event stamp: 7509691
[ 1986.897186] hardirqs last  enabled at (7509691): [<c0190f34>] kmem_cache_alloc+0x6e/0x93
[ 1986.897197] hardirqs last disabled at (7509690): [<c0190eea>] kmem_cache_alloc+0x24/0x93
[ 1986.897209] softirqs last  enabled at (7508896): [<c01294bd>] __do_softirq+0xee/0xfd
[ 1986.897222] softirqs last disabled at (7508859): [<c01030ed>] do_softirq+0x50/0x9d
[ 1986.897234]
[ 1986.897235] other info that might help us debug this:
[ 1986.897242]  Possible unsafe locking scenario:
[ 1986.897244]
[ 1986.897250]        CPU0
[ 1986.897254]        ----
[ 1986.897257]   lock(&REISERFS_SB(s)->lock);
[ 1986.897265] <Interrupt>
[ 1986.897269]     lock(&REISERFS_SB(s)->lock);
[ 1986.897276]
[ 1986.897277]  *** DEADLOCK ***
[ 1986.897278]
[ 1986.897286] no locks held by kswapd0/16.
[ 1986.897291]
[ 1986.897292] stack backtrace:
[ 1986.897299] Pid: 16, comm: kswapd0 Not tainted 3.1.1-main #8
[ 1986.897306] Call Trace:
[ 1986.897314]  [<c0439e76>] ? printk+0xf/0x11
[ 1986.897324]  [<c01482d1>] print_usage_bug+0x20e/0x21a
[ 1986.897332]  [<c01479b8>] ? print_irq_inversion_bug+0x172/0x172
[ 1986.897341]  [<c014855c>] mark_lock+0x27f/0x483
[ 1986.897349]  [<c0148d88>] __lock_acquire+0x628/0x1472
[ 1986.897358]  [<c0149fae>] lock_acquire+0x47/0x5e
[ 1986.897366]  [<c01f8bd4>] ? reiserfs_write_lock+0x20/0x2a
[ 1986.897384]  [<c01f8bd4>] ? reiserfs_write_lock+0x20/0x2a
[ 1986.897397]  [<c043b5ef>] mutex_lock_nested+0x35/0x26f
[ 1986.897409]  [<c01f8bd4>] ? reiserfs_write_lock+0x20/0x2a
[ 1986.897421]  [<c01f8bd4>] reiserfs_write_lock+0x20/0x2a
[ 1986.897433]  [<c01e2edd>] map_block_for_writepage+0xc9/0x590
[ 1986.897448]  [<c01b1706>] ? create_empty_buffers+0x33/0x8f
[ 1986.897461]  [<c0121124>] ? get_parent_ip+0xb/0x31
[ 1986.897472]  [<c043ef7f>] ? sub_preempt_count+0x81/0x8e
[ 1986.897485]  [<c043cae0>] ? _raw_spin_unlock+0x27/0x3d
[ 1986.897496]  [<c0121124>] ? get_parent_ip+0xb/0x31
[ 1986.897508]  [<c01e355d>] reiserfs_writepage+0x1b9/0x3e7
[ 1986.897521]  [<c0173b40>] ? clear_page_dirty_for_io+0xcb/0xde
[ 1986.897533]  [<c014a6e3>] ? trace_hardirqs_on_caller+0x108/0x138
[ 1986.897546]  [<c014a71e>] ? trace_hardirqs_on+0xb/0xd
[ 1986.897559]  [<c0177b38>] shrink_page_list+0x34f/0x5e2
[ 1986.897572]  [<c01780a7>] shrink_inactive_list+0x172/0x22c
[ 1986.897585]  [<c0178464>] shrink_zone+0x303/0x3b1
[ 1986.897597]  [<c043cae0>] ? _raw_spin_unlock+0x27/0x3d
[ 1986.897611]  [<c01788c9>] kswapd+0x3b7/0x5f2

The deadlock shouldn't happen since we are doing that allocation in the
mount path, the filesystem is not available for any reclaim.  Still the
warning is annoying.

To solve this, acquire the lock later only where we need it, right before
calling reiserfs_read_locked_inode() that wants to lock to walk the tree.

Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN fs/reiserfs/super.c~reiserfs-dont-lock-root-inode-searching fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-dont-lock-root-inode-searching
+++ a/fs/reiserfs/super.c
@@ -1428,9 +1428,7 @@ static int read_super_block(struct super
 static int reread_meta_blocks(struct super_block *s)
 {
 	ll_rw_block(READ, 1, &(SB_BUFFER_WITH_SB(s)));
-	reiserfs_write_unlock(s);
 	wait_on_buffer(SB_BUFFER_WITH_SB(s));
-	reiserfs_write_lock(s);
 	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
 		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
 		return 1;
@@ -1738,24 +1736,14 @@ static int reiserfs_fill_super(struct su
 				 */
 	}
 
-	/*
-	 * This path assumed to be called with the BKL in the old times.
-	 * Now we have inherited the big reiserfs lock from it and many
-	 * reiserfs helpers called in the mount path and elsewhere require
-	 * this lock to be held even if it's not always necessary. Let's be
-	 * conservative and hold it early. The window can be reduced after
-	 * careful review of the code.
-	 */
-	reiserfs_write_lock(s);
-
 	if (reread_meta_blocks(s)) {
 		SWARN(silent, s, "jmacd-9",
 		      "unable to reread meta blocks after journal init");
-		goto error;
+		goto error_unlocked;
 	}
 
 	if (replay_only(s))
-		goto error;
+		goto error_unlocked;
 
 	if (bdev_read_only(s->s_bdev) && !(s->s_flags & MS_RDONLY)) {
 		SWARN(silent, s, "clm-7000",
@@ -1769,9 +1757,19 @@ static int reiserfs_fill_super(struct su
 			 reiserfs_init_locked_inode, (void *)(&args));
 	if (!root_inode) {
 		SWARN(silent, s, "jmacd-10", "get root inode failed");
-		goto error;
+		goto error_unlocked;
 	}
 
+	/*
+	 * This path assumed to be called with the BKL in the old times.
+	 * Now we have inherited the big reiserfs lock from it and many
+	 * reiserfs helpers called in the mount path and elsewhere require
+	 * this lock to be held even if it's not always necessary. Let's be
+	 * conservative and hold it early. The window can be reduced after
+	 * careful review of the code.
+	 */
+	reiserfs_write_lock(s);
+
 	if (root_inode->i_state & I_NEW) {
 		reiserfs_read_locked_inode(root_inode, &args);
 		unlock_new_inode(root_inode);
_
Subject: Subject: reiserfs: don't lock root inode searching

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch

