From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-yet-another-lockdep-issue.patch removed from -mm tree
Date: Tue, 21 Jul 2009 12:59:11 -0700
Message-ID: <200907211959.n6LJxBr8004419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbZGUT7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 15:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: yet another lockdep issue
has been removed from the -mm tree.  Its filename was
     ecryptfs-yet-another-lockdep-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: yet another lockdep issue
From: Roland Dreier <rdreier@cisco.com>

 > And yet another lockdep report from ecryptfs, related to lower_file_mutex:
 >
 > =================================
 > [ INFO: inconsistent lock state ]
 > 2.6.31-2-generic #14~rbd3
 > ---------------------------------
 > inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
 > kswapd0/323 [HC0[0]:SC0[0]:HE1:SE1] takes:
 >  (&inode_info->lower_file_mutex){+.+.?.}, at: [<ffffffff81210d34>] ecryptfs_destroy_inode+0x34/0x100
 > {RECLAIM_FS-ON-W} state was registered at:
 >   [<ffffffff8108c02c>] mark_held_locks+0x6c/0xa0
 >   [<ffffffff8108c10f>] lockdep_trace_alloc+0xaf/0xe0
 >   [<ffffffff81125a51>] kmem_cache_alloc+0x41/0x1a0
 >   [<ffffffff8113117a>] get_empty_filp+0x7a/0x1a0
 >   [<ffffffff8112dd46>] dentry_open+0x36/0xc0
 >   [<ffffffff8121a36c>] ecryptfs_privileged_open+0x5c/0x2e0
 >   [<ffffffff81210283>] ecryptfs_init_persistent_file+0xa3/0xe0
 >   [<ffffffff8120e838>] ecryptfs_lookup_and_interpose_lower+0x278/0x380
 >   [<ffffffff8120f97a>] ecryptfs_lookup+0x12a/0x250
 >   [<ffffffff8113930a>] real_lookup+0xea/0x160
 >   [<ffffffff8113afc8>] do_lookup+0xb8/0xf0
 >   [<ffffffff8113b518>] __link_path_walk+0x518/0x870
 >   [<ffffffff8113bd9c>] path_walk+0x5c/0xc0
 >   [<ffffffff8113be5b>] do_path_lookup+0x5b/0xa0
 >   [<ffffffff8113bfe7>] user_path_at+0x57/0xa0
 >   [<ffffffff811340dc>] vfs_fstatat+0x3c/0x80
 >   [<ffffffff8113424b>] vfs_stat+0x1b/0x20
 >   [<ffffffff81134274>] sys_newstat+0x24/0x50
 >   [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
 >   [<ffffffffffffffff>] 0xffffffffffffffff
 > irq event stamp: 7811
 > hardirqs last  enabled at (7811): [<ffffffff810c037f>] call_rcu+0x5f/0x90
 > hardirqs last disabled at (7810): [<ffffffff810c0353>] call_rcu+0x33/0x90
 > softirqs last  enabled at (3764): [<ffffffff810631da>] __do_softirq+0x14a/0x220
 > softirqs last disabled at (3751): [<ffffffff8101440c>] call_softirq+0x1c/0x30
 >
 > other info that might help us debug this:
 > 2 locks held by kswapd0/323:
 >  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810f67ed>] shrink_slab+0x3d/0x190
 >  #1:  (&type->s_umount_key#35){.+.+..}, at: [<ffffffff811429a1>] prune_dcache+0xd1/0x1b0
 >
 > stack backtrace:
 > Pid: 323, comm: kswapd0 Tainted: G         C 2.6.31-2-generic #14~rbd3
 > Call Trace:
 >  [<ffffffff8108ad6c>] print_usage_bug+0x18c/0x1a0
 >  [<ffffffff8108aff0>] ? check_usage_forwards+0x0/0xc0
 >  [<ffffffff8108bac2>] mark_lock_irq+0xf2/0x280
 >  [<ffffffff8108bd87>] mark_lock+0x137/0x1d0
 >  [<ffffffff81164710>] ? fsnotify_clear_marks_by_inode+0x30/0xf0
 >  [<ffffffff8108bee6>] mark_irqflags+0xc6/0x1a0
 >  [<ffffffff8108d337>] __lock_acquire+0x287/0x430
 >  [<ffffffff8108d585>] lock_acquire+0xa5/0x150
 >  [<ffffffff81210d34>] ? ecryptfs_destroy_inode+0x34/0x100
 >  [<ffffffff8108d2e7>] ? __lock_acquire+0x237/0x430
 >  [<ffffffff815526ad>] __mutex_lock_common+0x4d/0x3d0
 >  [<ffffffff81210d34>] ? ecryptfs_destroy_inode+0x34/0x100
 >  [<ffffffff81164710>] ? fsnotify_clear_marks_by_inode+0x30/0xf0
 >  [<ffffffff81210d34>] ? ecryptfs_destroy_inode+0x34/0x100
 >  [<ffffffff8129a91e>] ? _raw_spin_unlock+0x5e/0xb0
 >  [<ffffffff81552b36>] mutex_lock_nested+0x46/0x60
 >  [<ffffffff81210d34>] ecryptfs_destroy_inode+0x34/0x100
 >  [<ffffffff81145d27>] destroy_inode+0x87/0xd0
 >  [<ffffffff81146b4c>] generic_delete_inode+0x12c/0x1a0
 >  [<ffffffff81145832>] iput+0x62/0x70
 >  [<ffffffff811423c8>] dentry_iput+0x98/0x110
 >  [<ffffffff81142550>] d_kill+0x50/0x80
 >  [<ffffffff81142623>] prune_one_dentry+0xa3/0xc0
 >  [<ffffffff811428b1>] __shrink_dcache_sb+0x271/0x290
 >  [<ffffffff811429d9>] prune_dcache+0x109/0x1b0
 >  [<ffffffff81142abf>] shrink_dcache_memory+0x3f/0x50
 >  [<ffffffff810f68dd>] shrink_slab+0x12d/0x190
 >  [<ffffffff810f9377>] balance_pgdat+0x4d7/0x640
 >  [<ffffffff8104c4c0>] ? finish_task_switch+0x40/0x150
 >  [<ffffffff810f63c0>] ? isolate_pages_global+0x0/0x60
 >  [<ffffffff810f95f7>] kswapd+0x117/0x170
 >  [<ffffffff810777a0>] ? autoremove_wake_function+0x0/0x40
 >  [<ffffffff810f94e0>] ? kswapd+0x0/0x170
 >  [<ffffffff810773be>] kthread+0x9e/0xb0
 >  [<ffffffff8101430a>] child_rip+0xa/0x20
 >  [<ffffffff81013c90>] ? restore_args+0x0/0x30
 >  [<ffffffff81077320>] ? kthread+0x0/0xb0
 >  [<ffffffff81014300>] ? child_rip+0x0/0x20

The issue here seems to be that in normal use, ecryptfs's
lower_file_mutex is held across GFP_KERNEL allocations, etc.  So it is
not safe to take it in reclaim context (or else we may end up in a
recursive deadlock under memory pressure).  However
ecryptfs_destroy_inode() *does* take the inode's lower_file_mutex, which
causes this warning.

However as far as I can tell, there is no reason to take the mutex while
destroying the inode; if there were any chance that any other context
would be blocked out by holding the lower_file_mutex in the destroy
inode function, then that would be a use-after-free bug, since right
after dropping the mutex, ecryptfs_destroy_inode() does

	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);

Similar reasoning applies to ecryptfs_destroy_crypt_stat() taking
keysig_list_mutex, since there right after the lock is dropped, we do

	memset(crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));

which obviously would cause problems if another thread tried to
mutex_lock() a member of crypt_stat.

If this makes sense I will resend the patch with a proper changelog and
signed-off-by line.

Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 --
 fs/ecryptfs/super.c  |    2 --
 2 files changed, 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-yet-another-lockdep-issue fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-yet-another-lockdep-issue
+++ a/fs/ecryptfs/crypto.c
@@ -245,13 +245,11 @@ void ecryptfs_destroy_crypt_stat(struct 
 		crypto_free_blkcipher(crypt_stat->tfm);
 	if (crypt_stat->hash_tfm)
 		crypto_free_hash(crypt_stat->hash_tfm);
-	mutex_lock(&crypt_stat->keysig_list_mutex);
 	list_for_each_entry_safe(key_sig, key_sig_tmp,
 				 &crypt_stat->keysig_list, crypt_stat_list) {
 		list_del(&key_sig->crypt_stat_list);
 		kmem_cache_free(ecryptfs_key_sig_cache, key_sig);
 	}
-	mutex_unlock(&crypt_stat->keysig_list_mutex);
 	memset(crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));
 }
 
diff -puN fs/ecryptfs/super.c~ecryptfs-yet-another-lockdep-issue fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-yet-another-lockdep-issue
+++ a/fs/ecryptfs/super.c
@@ -77,7 +77,6 @@ static void ecryptfs_destroy_inode(struc
 	struct ecryptfs_inode_info *inode_info;
 
 	inode_info = ecryptfs_inode_to_private(inode);
-	mutex_lock(&inode_info->lower_file_mutex);
 	if (inode_info->lower_file) {
 		struct dentry *lower_dentry =
 			inode_info->lower_file->f_dentry;
@@ -89,7 +88,6 @@ static void ecryptfs_destroy_inode(struc
 			d_drop(lower_dentry);
 		}
 	}
-	mutex_unlock(&inode_info->lower_file_mutex);
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
 	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
 }
_

Patches currently in -mm which might be from rdreier@cisco.com are

linux-next.patch
ecryptfs-another-lockdep-issue.patch

