From: akpm@linux-foundation.org
Subject: + lockdep-teach-lockdep-about-memalloc_noio_save.patch added to
 -mm tree
Date: Mon, 06 Mar 2017 13:26:07 -0800
Message-ID: <58bdd3ef.J9Q95sNYpomymci6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932389AbdCFVf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nborisov@suse.com, bfoster@redhat.com, clm@fb.com, darrick.wong@oracle.com, david@fromorbit.com, dsterba@suse.cz, jack@suse.cz, mhocko@suse.com, peterz@infradead.org, tytso@mit.edu, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: teach lockdep about memalloc_noio_save
has been added to the -mm tree.  Its filename is
     lockdep-teach-lockdep-about-memalloc_noio_save.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lockdep-teach-lockdep-about-memalloc_noio_save.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lockdep-teach-lockdep-about-memalloc_noio_save.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nikolay Borisov <nborisov@suse.com>
Subject: lockdep: teach lockdep about memalloc_noio_save

Patch series "scope GFP_NOFS api", v5.

This patch (of 7):

Commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O
during memory allocation") added the memalloc_noio_(save|restore)
functions to enable people to modify the MM behavior by disabling I/O
during memory allocation.  This was further extended in Fixes:
934f3072c17c ("mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set"). 
memalloc_noio_* functions prevent allocation paths recursing back into the
filesystem without explicitly changing the flags for every allocation
site.  However, lockdep hasn't been keeping up with the changes and it
entirely misses handling the memalloc_noio adjustments.  Instead, it is
left to the callers of __lockdep_trace_alloc to call the function after
they have shaven the respective GFP flags which can lead to false
positives:

[  644.173373] =================================
[  644.174012] [ INFO: inconsistent lock state ]
[  644.174012] 4.10.0-nbor #134 Not tainted
[  644.174012] ---------------------------------
[  644.174012] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[  644.174012] fsstress/3365 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  644.174012]  (&xfs_nondir_ilock_class){++++?.}, at: [<ffffffff8136f231>] xfs_ilock+0x141/0x230
[  644.174012] {IN-RECLAIM_FS-W} state was registered at:
[  644.174012]   __lock_acquire+0x62a/0x17c0
[  644.174012]   lock_acquire+0xc5/0x220
[  644.174012]   down_write_nested+0x4f/0x90
[  644.174012]   xfs_ilock+0x141/0x230
[  644.174012]   xfs_reclaim_inode+0x12a/0x320
[  644.174012]   xfs_reclaim_inodes_ag+0x2c8/0x4e0
[  644.174012]   xfs_reclaim_inodes_nr+0x33/0x40
[  644.174012]   xfs_fs_free_cached_objects+0x19/0x20
[  644.174012]   super_cache_scan+0x191/0x1a0
[  644.174012]   shrink_slab+0x26f/0x5f0
[  644.174012]   shrink_node+0xf9/0x2f0
[  644.174012]   kswapd+0x356/0x920
[  644.174012]   kthread+0x10c/0x140
[  644.174012]   ret_from_fork+0x31/0x40
[  644.174012] irq event stamp: 173777
[  644.174012] hardirqs last  enabled at (173777): [<ffffffff8105b440>] __local_bh_enable_ip+0x70/0xc0
[  644.174012] hardirqs last disabled at (173775): [<ffffffff8105b407>] __local_bh_enable_ip+0x37/0xc0
[  644.174012] softirqs last  enabled at (173776): [<ffffffff81357e2a>] _xfs_buf_find+0x67a/0xb70
[  644.174012] softirqs last disabled at (173774): [<ffffffff81357d8b>] _xfs_buf_find+0x5db/0xb70
[  644.174012]
[  644.174012] other info that might help us debug this:
[  644.174012]  Possible unsafe locking scenario:
[  644.174012]
[  644.174012]        CPU0
[  644.174012]        ----
[  644.174012]   lock(&xfs_nondir_ilock_class);
[  644.174012]   <Interrupt>
[  644.174012]     lock(&xfs_nondir_ilock_class);
[  644.174012]
[  644.174012]  *** DEADLOCK ***
[  644.174012]
[  644.174012] 4 locks held by fsstress/3365:
[  644.174012]  #0:  (sb_writers#10){++++++}, at: [<ffffffff81208d04>] mnt_want_write+0x24/0x50
[  644.174012]  #1:  (&sb->s_type->i_mutex_key#12){++++++}, at: [<ffffffff8120ea2f>] vfs_setxattr+0x6f/0xb0
[  644.174012]  #2:  (sb_internal#2){++++++}, at: [<ffffffff8138185c>] xfs_trans_alloc+0xfc/0x140
[  644.174012]  #3:  (&xfs_nondir_ilock_class){++++?.}, at: [<ffffffff8136f231>] xfs_ilock+0x141/0x230
[  644.174012]
[  644.174012] stack backtrace:
[  644.174012] CPU: 0 PID: 3365 Comm: fsstress Not tainted 4.10.0-nbor #134
[  644.174012] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  644.174012] Call Trace:
[  644.174012]  dump_stack+0x85/0xc9
[  644.174012]  print_usage_bug.part.37+0x284/0x293
[  644.174012]  ? print_shortest_lock_dependencies+0x1b0/0x1b0
[  644.174012]  mark_lock+0x27e/0x660
[  644.174012]  mark_held_locks+0x66/0x90
[  644.174012]  lockdep_trace_alloc+0x6f/0xd0
[  644.174012]  kmem_cache_alloc_node_trace+0x3a/0x2c0
[  644.174012]  ? vm_map_ram+0x2a1/0x510
[  644.174012]  vm_map_ram+0x2a1/0x510
[  644.174012]  ? vm_map_ram+0x46/0x510
[  644.174012]  _xfs_buf_map_pages+0x77/0x140
[  644.174012]  xfs_buf_get_map+0x185/0x2a0
[  644.174012]  xfs_attr_rmtval_set+0x233/0x430
[  644.174012]  xfs_attr_leaf_addname+0x2d2/0x500
[  644.174012]  xfs_attr_set+0x214/0x420
[  644.174012]  xfs_xattr_set+0x59/0xb0
[  644.174012]  __vfs_setxattr+0x76/0xa0
[  644.174012]  __vfs_setxattr_noperm+0x5e/0xf0
[  644.174012]  vfs_setxattr+0xae/0xb0
[  644.174012]  ? __might_fault+0x43/0xa0
[  644.174012]  setxattr+0x15e/0x1a0
[  644.174012]  ? __lock_is_held+0x53/0x90
[  644.174012]  ? rcu_read_lock_sched_held+0x93/0xa0
[  644.174012]  ? rcu_sync_lockdep_assert+0x2f/0x60
[  644.174012]  ? __sb_start_write+0x130/0x1d0
[  644.174012]  ? mnt_want_write+0x24/0x50
[  644.174012]  path_setxattr+0x8f/0xc0
[  644.174012]  SyS_lsetxattr+0x11/0x20
[  644.174012]  entry_SYSCALL_64_fastpath+0x23/0xc6

Let's fix this by making lockdep explicitly do the shaving of respective
GFP flags.

Fixes: 934f3072c17c ("mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set")
Link: http://lkml.kernel.org/r/20170306131408.9828-2-mhocko@kernel.org
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/lockdep.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/locking/lockdep.c~lockdep-teach-lockdep-about-memalloc_noio_save kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~lockdep-teach-lockdep-about-memalloc_noio_save
+++ a/kernel/locking/lockdep.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/task.h>
+#include <linux/sched/mm.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
@@ -2863,6 +2864,8 @@ static void __lockdep_trace_alloc(gfp_t
 	if (unlikely(!debug_locks))
 		return;
 
+	gfp_mask = memalloc_noio_flags(gfp_mask);
+
 	/* no reclaim without waiting on it */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return;
@@ -3854,7 +3857,7 @@ EXPORT_SYMBOL_GPL(lock_unpin_lock);
 
 void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
 {
-	current->lockdep_reclaim_gfp = gfp_mask;
+	current->lockdep_reclaim_gfp = memalloc_noio_flags(gfp_mask);
 }
 
 void lockdep_clear_current_reclaim_state(void)
_

Patches currently in -mm which might be from nborisov@suse.com are

lockdep-teach-lockdep-about-memalloc_noio_save.patch

