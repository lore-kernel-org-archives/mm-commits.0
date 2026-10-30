Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333865;
	b=AqnOt/sWNDYtGr//LPpEBWTskgnMPUu0BEJX+K6WLQLEJoV0IhUSlK/IsTEjEh2J5wc6
	 AokhgoZ8IofOr0Nxl8dqec915lI/7f6rwhn6Z+kCLvNDpOyhY9l3hlgvS1jkr/nPt/KKX
	 egAGrDQU1p2RjTeJQTSLny0Cy8RrR4HrKdNuYVltiqGdyB1k6J7c4+tbsotc1iJovK6iT
	 rqviFHpNYda58Lqg057HN3D1WtAKZewrPDuQP6s9n2vYLp3vWrUTDPE89JzXMRhr0aBzu
	 EW/vKtACTE3EdBbmBDr7Lc1KlFWW+t2LAHigNr5nYvQW628qiLn4Ku9srfq6vChNF0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333865;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=l6dgklAXvNJW7Bicp7o9SsNadCOymnW+JHw1c9oe1B8=;
	b=bMwWAAMyaFdixsD51+L4Gkh/7dvNiQ9XNWv682UzlXrR1lsZdAmqnX6EWAmN9RBU5On/
	 fstya9/B0pkzky6jKF/yG8eB4jH3ovNGCL3O365PUwXnTrAMC4yLRUPxRtk8SJKjRAGCM
	 PIQ222yZbRjeGVFyV0NpYFGomdMmo4sZYPitINLIpemX7PLfQjlnt9asshkoFBSEGmEPU
	 ScOuABJBA5V3Hpxi7t6jCjV11hIuae4zZgz8pEJ3U5vn6x2IEm4KEkBGFz6zQFwKlIsJH
	 iM6y1S3cmQI7On9/uBAdeSxLoBeU45nMGfT7R46bSyEKCzY8TOcdj1ywJctw5wjsdkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GC+ssbcN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC823606A31A;
	Fri, 30 Oct 2026 04:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GC+ssbcN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494641F000C1;
	Fri, 30 Oct 2026 04:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793333864;
	bh=l6dgklAXvNJW7Bicp7o9SsNadCOymnW+JHw1c9oe1B8=;
	h=Date:To:From:Subject;
	b=GC+ssbcNpFwfV4VzxoSGuvmfsYwgn5AM2S7pPq4pT0dmeEfnKj7fyhoryRoH8Yer+
	 7XSi0kNWsm7yQk5TMi94AuO2KUexpFMqdnuPMX1DJPj14BlaszEUr0WOmpYxTjbhJ3
	 DaMP7WwdcJFaMoxE3k3rzuKLbETsbR1nssp2wlac=
Date: Thu, 29 Oct 2026 21:17:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-stop-recovery-before-shutting-down-local-allocators.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261030041744.494641F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: stop recovery before shutting down local allocators
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     ocfs2-stop-recovery-before-shutting-down-local-allocators.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-stop-recovery-before-shutting-down-local-allocators.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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
Subject: ocfs2: stop recovery before shutting down local allocators
Date: Thu, 29 Oct 2026 14:57:35 +0800

Recovery completion needs the local allocators until it has finished
reclaiming a failed node's allocation window and truncate log.  During
unmount, quota recovery is stopped first, but that leaves recovery_state
at OCFS2_REC_QUOTA_DISABLED.  New non-quota recovery can still start.

ocfs2_truncate_log_shutdown() drains existing completion work and releases
osb_tl_bh before ocfs2_recovery_exit() closes that publication path:

  Unmount                             Recovery
  -------                             --------
  stop quota recovery; disable quotas
  truncate_log_shutdown()
    flush existing completion work
                                      recover another failed node
                                        queue completion
    flush local log; release buffer
                                      complete_truncate_log_recovery()
                                        use released osb_tl_bh
  recovery_exit(): disable and drain

An extra buffer reference alone would still let completion append new
records after the final truncate-log flush.

Split stopping and draining recovery from freeing its state. Stop all
recovery producers and drain completion work before shutting down either
local allocator. Keep recovery-state release at its existing later point,
so its lifetime relative to other teardown users stays unchanged. The
second stop at recovery_exit() is harmless once recovery is disabled.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_truncate_log_needs_flush+0x23d/0x360
    Read of size 8 at addr ffff8881093711e8 by task kworker/u16:3/53
    
    CPU: 0 UID: 0 PID: 53 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy) 
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: ocfs2_wq ocfs2_complete_recovery
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_truncate_log_needs_flush+0x23d/0x360
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_truncate_log_needs_flush+0x23d/0x360
     kasan_report+0xe0/0x110
     ? ocfs2_truncate_log_needs_flush+0x23d/0x360
     ocfs2_truncate_log_needs_flush+0x23d/0x360
     ? __pfx_ocfs2_truncate_log_needs_flush+0x10/0x10
     ? __pfx_down_write+0x10/0x10
     ocfs2_complete_truncate_log_recovery+0x315/0x780
     ? trace_hardirqs_on+0x18/0x160
     ? __pfx_ocfs2_complete_truncate_log_recovery+0x10/0x10
     ? ocfs2_complete_recovery+0x666/0x11b0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kfree+0x308/0x580
     ocfs2_complete_recovery+0x676/0x11b0
     ? __pfx_ocfs2_complete_recovery+0x10/0x10
     ? reacquire_held_locks+0xdd/0x200
     ? process_one_work+0x7c8/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_acquire+0x190/0x300
     ? __pfx_autoremove_wake_function+0x10/0x10
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    
    Allocated by task 538:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_noprof+0x20b/0x5c0
     alloc_buffer_head+0x26/0x120
     folio_alloc_buffers+0x122/0x1d0
     bdev_getblk+0x299/0x4f0
     ocfs2_read_blocks_sync+0x513/0xbc0
     ocfs2_iget+0x9cd/0x1a00
     ocfs2_get_system_file_inode+0x25e/0x7a0
     ocfs2_fill_super+0x1b05/0x3930
     get_tree_bdev_flags+0x35d/0x5f0
     vfs_get_tree+0x93/0x320
     fc_mount+0x1d/0x200
     path_mount+0x592/0x1e00
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    Freed by task 553:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kmem_cache_free+0x242/0x580
     free_buffer_head+0x4b/0xc0
     try_to_free_buffers+0x1dc/0x330
     ocfs2_truncate_log_shutdown+0x789/0x1290
     ocfs2_dismount_volume+0x1da/0x940
     generic_shutdown_super+0x15f/0x490
     kill_block_super+0x40/0xa0
     deactivate_locked_super+0xae/0x120
     deactivate_super+0xa2/0xc0
     cleanup_mnt+0x217/0x450
     task_work_run+0x144/0x230
     exit_to_user_mode_loop+0x17d/0x570
     do_syscall_64+0x4d1/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    The buggy address belongs to the object at ffff8881093711c0
     which belongs to the cache buffer_head of size 160
    The buggy address is located 40 bytes inside of
     freed 160-byte region [ffff8881093711c0, ffff888109371260)
    
    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109371
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000000 ffff8881008883c0 dead000000000100 dead000000000122
    raw: 0000000000000000 0000000000120012 00000000f5000000 0000000000000000
    page dumped because: kasan: bad access detected
    
    Memory state around the buggy address:
     ffff888109371080: 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00 00
     ffff888109371100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    >ffff888109371180: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                              ^
     ffff888109371200: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
     ffff888109371280: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
    ==================================================================

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0019-v8-574dd69fd3f47f56348b@gmail.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/journal.c |   15 ++++++++++++---
 fs/ocfs2/journal.h |    1 +
 fs/ocfs2/super.c   |    3 +++
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-stop-recovery-before-shutting-down-local-allocators
+++ a/fs/ocfs2/journal.c
@@ -227,13 +227,22 @@ void ocfs2_recovery_disable_quota(struct
 	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
 }
 
+/* Stop producers and drain completion work without freeing recovery state. */
+void ocfs2_recovery_stop(struct ocfs2_super *osb)
+{
+	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
+}
+
 void ocfs2_recovery_exit(struct ocfs2_super *osb)
 {
 	struct ocfs2_recovery_map *rm;
 
-	/* disable any new recovery threads and wait for any currently
-	 * running ones to exit. Do this before setting the vol_state. */
-	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
+	/*
+	 * Disable producers and drain work before freeing recovery state.
+	 * Do this before setting vol_state to VOLUME_DISMOUNTED: completion
+	 * work may still be waiting in __ocfs2_wait_on_mount().
+	 */
+	ocfs2_recovery_stop(osb);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
--- a/fs/ocfs2/journal.h~ocfs2-stop-recovery-before-shutting-down-local-allocators
+++ a/fs/ocfs2/journal.h
@@ -147,6 +147,7 @@ void ocfs2_complete_recovery(struct work
 void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 
 int ocfs2_recovery_init(struct ocfs2_super *osb);
+void ocfs2_recovery_stop(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
--- a/fs/ocfs2/super.c~ocfs2-stop-recovery-before-shutting-down-local-allocators
+++ a/fs/ocfs2/super.c
@@ -1831,6 +1831,9 @@ static void ocfs2_dismount_volume(struct
 	/* Wait for worker to be done with the work structure in osb */
 	cancel_work_sync(&osb->dquot_drop_work);
 
+	/* Stop recovery producers before releasing their local allocators. */
+	ocfs2_recovery_stop(osb);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-validate-move-extents-against-a-stable-eof.patch
ocfs2-keep-locking_state-within-the-cluster-connection-lifetime.patch
ocfs2-dlm-serialize-migration-mle-cleanup-on-failure.patch
ocfs2-stop-recovery-before-shutting-down-local-allocators.patch
ocfs2-wait-for-filecheck-kobject-release-after-a-failed-add.patch
ocfs2-cache-the-mount-context-for-dentry-lock-callbacks.patch

