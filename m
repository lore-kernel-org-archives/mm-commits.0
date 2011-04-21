From: akpm@linux-foundation.org
Subject: + tmpfs-fix-race-between-umount-and-writepage.patch added to -mm tree
Date: Thu, 21 Apr 2011 12:44:43 -0700
Message-ID: <201104211944.p3LJihqn026328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376Ab1DUTpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Apr 2011 15:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com


The patch titled
     tmpfs: fix race between umount and writepage
has been added to the -mm tree.  Its filename is
     tmpfs-fix-race-between-umount-and-writepage.patch

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
Subject: tmpfs: fix race between umount and writepage
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

The bug is easily reproduced by this script:

for i in {1..300} ; do
	mkdir $i
	while true ; do
		mount -t tmpfs none $i
		dd if=/dev/zero of=$i/test bs=1M count=$(($RANDOM % 100)) status=noxfer
		umount $i
	done &
done

At 6xCPU node with 8Gb RAM. Kernel is very unstable after this accident. =)
Kernel with this patch is working fine for at least an hour.

Kernel log:

[  584.544461] VFS: Busy inodes after unmount of tmpfs. Self-destruct in 5 seconds.  Have a nice day...
[  585.409221] ------------[ cut here ]------------
[  585.409268] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
[  585.409331] Hardware name: System Product Name
[  585.409372] list_del corruption. prev->next should be ffff880222fdaac8, but was           (null)
[  585.409928] Modules linked in: [last unloaded: scsi_wait_scan]
[  585.410279] Pid: 11222, comm: mount.tmpfs Not tainted 2.6.39-rc2+ #4
[  585.410540] Call Trace:
[  585.410819]  [<ffffffff8103b710>] warn_slowpath_common+0x80/0x98
[  585.411113]  [<ffffffff8103b7bc>] warn_slowpath_fmt+0x41/0x43
[  585.411377]  [<ffffffff81227145>] __list_del_entry+0x8d/0x98
[  585.411649]  [<ffffffff810f68af>] evict+0x50/0x113
[  585.411919]  [<ffffffff810f6ce6>] iput+0x138/0x141
...
[  585.416428] ---[ end trace 39cf2c656ee772fe ]---
[  585.416690] BUG: unable to handle kernel paging request at ffffffffffffffff
[  585.417001] IP: [<ffffffff810b946a>] shmem_free_blocks+0x18/0x4c
[  585.417001] PGD 1805067 PUD 1806067 PMD 0
[  585.417001] Oops: 0000 [#1] SMP
[  585.417839] last sysfs file: /sys/kernel/kexec_crash_size
[  585.418156] CPU 1
[  585.418156] Modules linked in: [last unloaded: scsi_wait_scan]
[  585.418851]
[  585.418851] Pid: 10422, comm: dd Tainted: G        W   2.6.39-rc2+ #4 System manufacturer System Product Name/Crosshair IV Formula
[  585.419541] RIP: 0010:[<ffffffff810b946a>]  [<ffffffff810b946a>] shmem_free_blocks+0x18/0x4c
[  585.419857] RSP: 0018:ffff880163e9f4b8  EFLAGS: 00010206
[  585.419857] RAX: ffff88021b513400 RBX: ffff880222fdaa40 RCX: 0000000000000020
[  585.419857] RDX: ffffffffffffffe0 RSI: 000000000000000e RDI: ffffffffffffffff
[  585.419857] RBP: ffff880163e9f4c8 R08: ffffea000653b090 R09: 0000000000014df0
[  585.419857] R10: 0000000000000028 R11: 000000000000002a R12: 000000000000000e
[  585.419857] R13: 000000000003cc76 R14: ffff880222fda970 R15: ffff880202b5d588
[  585.419857] FS:  00007f1c5b0cb700(0000) GS:ffff88024fc40000(0000) knlGS:0000000000000000
[  585.419857] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  585.419857] CR2: ffffffffffffffff CR3: 0000000187431000 CR4: 00000000000006e0
[  585.419857] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  585.419857] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  585.419857] Process dd (pid: 10422, threadinfo ffff880163e9e000, task ffff880098f65700)
[  585.419857] Stack:
[  585.419857]  ffff880222fdaa40 000000000000000e ffff880163e9f4e8 ffffffff810bac88
[  585.419857]  ffff880222fdaa40 ffffea000653b068 ffff880163e9f538 ffffffff810bc216
[  585.419857]  0000000000000000 ffff880163e9f548 0000000000000000 ffffea000653b068
[  585.419857] Call Trace:
[  585.419857]  [<ffffffff810bac88>] shmem_recalc_inode+0x61/0x66
[  585.419857]  [<ffffffff810bc216>] shmem_writepage+0xba/0x1dc
[  585.419857]  [<ffffffff810b6f4a>] pageout+0x13c/0x24c
[  585.419857]  [<ffffffff810b7479>] shrink_page_list+0x28e/0x4be
[  585.419857]  [<ffffffff810b78c8>] shrink_inactive_list+0x21f/0x382
...



shmem_writepage() calls igrab() on the inode for the page which came from
page reclaim to add it later into shmem_swaplist for swap-unuse operation.

This igrab() can race with super-block deactivating process:

shrink_inactive_list()		deactivate_super()
pageout()			tmpfs_fs_type->kill_sb()
shmem_writepage()		kill_litter_super()
				generic_shutdown_super()
				 evict_inodes()
 igrab()
				  atomic_read(&inode->i_count)
				   skip-inode
 iput()
				 if (!list_empty(&sb->s_inodes))
					printk("VFS: Busy inodes after...

This igrap-iput pair was added in commit 1b1b32f2c6f ("tmpfs: fix
shmem_swaplist races") based on an incorrect assumptions:

: Ah, I'd never suspected it, but shmem_writepage's swaplist manipulation
: is unsafe: though still hold page lock, which would hold off inode
: deletion if the page were i pagecache, it doesn't hold off once it's in
: swapcache (free_swap_and_cache doesn't wait on locked pages).  Hmm: we
: could put the the inode on swaplist earlier, but then shmem_unuse_inode
: could never prune unswapped inodes.

The attached locked page actually protects the inode from deletion because
truncate_inode_pages_range() will sleep on this, so an igrab is not
required.  This patch actually revert last hunk from that commit.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-race-between-umount-and-writepage mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-race-between-umount-and-writepage
+++ a/mm/shmem.c
@@ -1084,21 +1084,16 @@ static int shmem_writepage(struct page *
 		delete_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
-		if (list_empty(&info->swaplist))
-			inode = igrab(inode);
-		else
-			inode = NULL;
 		spin_unlock(&info->lock);
-		swap_shmem_alloc(swap);
-		BUG_ON(page_mapped(page));
-		swap_writepage(page, wbc);
-		if (inode) {
+		if (list_empty(&info->swaplist)) {
 			mutex_lock(&shmem_swaplist_mutex);
 			/* move instead of add in case we're racing */
 			list_move_tail(&info->swaplist, &shmem_swaplist);
 			mutex_unlock(&shmem_swaplist_mutex);
-			iput(inode);
 		}
+		swap_shmem_alloc(swap);
+		BUG_ON(page_mapped(page));
+		swap_writepage(page, wbc);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
tmpfs-fix-race-between-umount-and-writepage.patch

