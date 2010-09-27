From: akpm@linux-foundation.org
Subject: + reiserfs-fix-unwanted-reiserfs-lock-recursion.patch added to -mm tree
Date: Mon, 27 Sep 2010 11:42:25 -0700
Message-ID: <201009271842.o8RIgQCZ009495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933202Ab0I0Smv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 14:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, jarkao2@gmail.com, jeffm@suse.com, stable@kernel.org


The patch titled
     reiserfs: fix unwanted reiserfs lock recursion
has been added to the -mm tree.  Its filename is
     reiserfs-fix-unwanted-reiserfs-lock-recursion.patch

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
Subject: reiserfs: fix unwanted reiserfs lock recursion
From: Frederic Weisbecker <fweisbec@gmail.com>

Prevent from recursively locking the reiserfs lock in reiserfs_unpack()
because we may call journal_begin() that requires the lock to be taken
only once, otherwise it won't be able to release the lock while taking
other mutexes, ending up in inverted dependencies between the journal
mutex and the reiserfs lock for example.

This fixes:

[   67.110273] =======================================================
[   67.110313] [ INFO: possible circular locking dependency detected ]
[   67.110313] 2.6.35.4.4a #3
[   67.110313] -------------------------------------------------------
[   67.110313] lilo/1620 is trying to acquire lock:
[   67.110313]  (&journal->j_mutex){+.+...}, at: [<d0325bff>] do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]
[   67.110313] but task is already holding lock:
[   67.110313]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a278>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   67.110313]
[   67.110313] which lock already depends on the new lock.
[   67.110313]
[   67.110313]
[   67.110313] the existing dependency chain (in reverse order) is:
[   67.110313]
[   67.110313] -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
[   67.110313]        [<c10562b7>] lock_acquire+0x67/0x80
[   67.110313]        [<c12facad>] __mutex_lock_common+0x4d/0x410
[   67.110313]        [<c12fb0c8>] mutex_lock_nested+0x18/0x20
[   67.110313]        [<d032a278>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   67.110313]        [<d0325c06>] do_journal_begin_r+0x86/0x340 [reiserfs]
[   67.110313]        [<d0325f77>] journal_begin+0x77/0x140 [reiserfs]
[   67.110313]        [<d0315be4>] reiserfs_remount+0x224/0x530 [reiserfs]
[   67.110313]        [<c10b6a20>] do_remount_sb+0x60/0x110
[   67.110313]        [<c10cee25>] do_mount+0x625/0x790
[   67.110313]        [<c10cf014>] sys_mount+0x84/0xb0
[   67.110313]        [<c12fca3d>] syscall_call+0x7/0xb
[   67.110313]
[   67.110313] -> #0 (&journal->j_mutex){+.+...}:
[   67.110313]        [<c10560f6>] __lock_acquire+0x1026/0x1180
[   67.110313]        [<c10562b7>] lock_acquire+0x67/0x80
[   67.110313]        [<c12facad>] __mutex_lock_common+0x4d/0x410
[   67.110313]        [<c12fb0c8>] mutex_lock_nested+0x18/0x20
[   67.110313]        [<d0325bff>] do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]        [<d0325f77>] journal_begin+0x77/0x140 [reiserfs]
[   67.110313]        [<d0326271>] reiserfs_persistent_transaction+0x41/0x90 [reiserfs]
[   67.110313]        [<d030d06c>] reiserfs_get_block+0x22c/0x1530 [reiserfs]
[   67.110313]        [<c10db9db>] __block_prepare_write+0x1bb/0x3a0
[   67.110313]        [<c10dbbe6>] block_prepare_write+0x26/0x40
[   67.110313]        [<d030b738>] reiserfs_prepare_write+0x88/0x170 [reiserfs]
[   67.110313]        [<d03294d6>] reiserfs_unpack+0xe6/0x120 [reiserfs]
[   67.110313]        [<d0329782>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   67.110313]        [<c10c3188>] vfs_ioctl+0x28/0xa0
[   67.110313]        [<c10c3bbd>] do_vfs_ioctl+0x32d/0x5c0
[   67.110313]        [<c10c3eb3>] sys_ioctl+0x63/0x70
[   67.110313]        [<c12fca3d>] syscall_call+0x7/0xb
[   67.110313]
[   67.110313] other info that might help us debug this:
[   67.110313]
[   67.110313] 2 locks held by lilo/1620:
[   67.110313]  #0:  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<d032945a>] reiserfs_unpack+0x6a/0x120 [reiserfs]
[   67.110313]  #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a278>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   67.110313]
[   67.110313] stack backtrace:
[   67.110313] Pid: 1620, comm: lilo Not tainted 2.6.35.4.4a #3
[   67.110313] Call Trace:
[   67.110313]  [<c12f9aba>] ? printk+0x18/0x1e
[   67.110313]  [<c1054182>] print_circular_bug+0xd2/0xe0
[   67.110313]  [<c10560f6>] __lock_acquire+0x1026/0x1180
[   67.110313]  [<c10562b7>] lock_acquire+0x67/0x80
[   67.110313]  [<d0325bff>] ? do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<c12facad>] __mutex_lock_common+0x4d/0x410
[   67.110313]  [<d0325bff>] ? do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<c1055275>] ? __lock_acquire+0x1a5/0x1180
[   67.110313]  [<c10897ae>] ? mempool_alloc_slab+0xe/0x10
[   67.110313]  [<c12fb0c8>] mutex_lock_nested+0x18/0x20
[   67.110313]  [<d0325bff>] ? do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<d0325bff>] do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<c1054bd2>] ? mark_held_locks+0x62/0x80
[   67.110313]  [<c10b163d>] ? kmem_cache_alloc+0x7d/0xb0
[   67.110313]  [<c1054e5c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   67.110313]  [<d0325f77>] journal_begin+0x77/0x140 [reiserfs]
[   67.110313]  [<d0326262>] ? reiserfs_persistent_transaction+0x32/0x90 [reiserfs]
[   67.110313]  [<d0326271>] reiserfs_persistent_transaction+0x41/0x90 [reiserfs]
[   67.110313]  [<d030d06c>] reiserfs_get_block+0x22c/0x1530 [reiserfs]
[   67.110313]  [<c1055275>] ? __lock_acquire+0x1a5/0x1180
[   67.110313]  [<c12fc672>] ? _raw_spin_unlock_irq+0x22/0x50
[   67.110313]  [<c10b163d>] ? kmem_cache_alloc+0x7d/0xb0
[   67.110313]  [<c1054e5c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   67.110313]  [<c102789b>] ? sub_preempt_count+0x7b/0xb0
[   67.110313]  [<c12fc457>] ? _raw_spin_unlock+0x27/0x40
[   67.110313]  [<c10db9db>] __block_prepare_write+0x1bb/0x3a0
[   67.110313]  [<c10dbbe6>] block_prepare_write+0x26/0x40
[   67.110313]  [<d030ce40>] ? reiserfs_get_block+0x0/0x1530 [reiserfs]
[   67.110313]  [<d030b738>] reiserfs_prepare_write+0x88/0x170 [reiserfs]
[   67.110313]  [<d030ce40>] ? reiserfs_get_block+0x0/0x1530 [reiserfs]
[   67.110313]  [<d03294d6>] reiserfs_unpack+0xe6/0x120 [reiserfs]
[   67.110313]  [<d0329782>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   67.110313]  [<d0329510>] ? reiserfs_ioctl+0x0/0x320 [reiserfs]
[   67.110313]  [<c10c3188>] vfs_ioctl+0x28/0xa0
[   67.110313]  [<c10c3bbd>] do_vfs_ioctl+0x32d/0x5c0
[   67.110313]  [<c109a228>] ? might_fault+0x88/0x90
[   67.110313]  [<c109a1e2>] ? might_fault+0x42/0x90
[   67.110313]  [<c10b6588>] ? fget_light+0xf8/0x2f0
[   67.110313]  [<c10c3eb3>] sys_ioctl+0x63/0x70
[   67.110313]  [<c12fca3d>] syscall_call+0x7/0xb
[   67.110313]  [<c12f007b>] ? cookie_v6_check+0x44b/0x630

Reported-by: Jarek Poplawski <jarkao2@gmail.com>
Tested-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: All since 2.6.32 <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/ioctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/ioctl.c~reiserfs-fix-unwanted-reiserfs-lock-recursion fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~reiserfs-fix-unwanted-reiserfs-lock-recursion
+++ a/fs/reiserfs/ioctl.c
@@ -170,6 +170,7 @@ int reiserfs_prepare_write(struct file *
 int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
+	int depth;
 	int index;
 	struct page *page;
 	struct address_space *mapping;
@@ -189,7 +190,7 @@ int reiserfs_unpack(struct inode *inode,
 	 ** us
 	 */
 	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
-	reiserfs_write_lock(inode->i_sb);
+	depth = reiserfs_write_lock_once(inode->i_sb);
 
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
@@ -224,6 +225,6 @@ int reiserfs_unpack(struct inode *inode,
 
       out:
 	mutex_unlock(&inode->i_mutex);
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
 	return retval;
 }
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
reiserfs-fix-dependency-inversion-between-inode-and-reiserfs-mutexes.patch
reiserfs-fix-unwanted-reiserfs-lock-recursion.patch
autofs-only-declare-function-when-config_compat-is-defined.patch

