From: akpm@linux-foundation.org
Subject: [merged] mm-swap-unlock-swapfile-inode-mutex-before-closing-file-on-bad-swapfiles.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:32:39 -0700
Message-ID: <201103232036.p2NKaFQE028092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310Ab1CWUgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hughd@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: swap: unlock swapfile inode mutex before closing file on bad swapfiles
has been removed from the -mm tree.  Its filename was
     mm-swap-unlock-swapfile-inode-mutex-before-closing-file-on-bad-swapfiles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: swap: unlock swapfile inode mutex before closing file on bad swapfiles
From: Mel Gorman <mgorman@suse.de>

If an administrator tries to swapon a file backed by NFS, the inode mutex is
taken (as it is for any swapfile) but later identified to be a bad swapfile
due to the lack of bmap and tries to cleanup. During cleanup, an attempt is
made to close the file but with inode->i_mutex still held. Closing an NFS
file syncs it which tries to acquire the inode mutex leading to deadlock. If
lockdep is enabled the following appears on the console;

[  120.968832] =============================================
[  120.972757] [ INFO: possible recursive locking detected ]
[  120.972757] 2.6.38-rc8-autobuild #1
[  120.972757] ---------------------------------------------
[  120.972757] swapon/2192 is trying to acquire lock:
[  120.972757]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81130652>] vfs_fsync_range+0x47/0x7c
[  120.972757]
[  120.972757] but task is already holding lock:
[  120.972757]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f9405>] sys_swapon+0x28d/0xae7
[  120.972757]
[  120.972757] other info that might help us debug this:
[  120.972757] 1 lock held by swapon/2192:
[  120.972757]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff810f9405>] sys_swapon+0x28d/0xae7
[  120.972757]
[  120.972757] stack backtrace:
[  120.972757] Pid: 2192, comm: swapon Not tainted 2.6.38-rc8-autobuild #1
[  120.972757] Call Trace:
[  120.972757]  [<ffffffff81075ca8>] ? __lock_acquire+0x2eb/0x1623
[  120.972757]  [<ffffffff810cd5ad>] ? find_get_pages_tag+0x14a/0x174
[  120.972757]  [<ffffffff810d6d01>] ? pagevec_lookup_tag+0x25/0x2e
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffff810770b3>] ? lock_acquire+0xd3/0x100
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffffa03df8ab>] ? nfs_flush_one+0x0/0xdf [nfs]
[  120.972757]  [<ffffffff81309cdf>] ? mutex_lock_nested+0x40/0x2b1
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffff81130652>] ? vfs_fsync_range+0x47/0x7c
[  120.972757]  [<ffffffff811306e6>] ? vfs_fsync+0x1c/0x1e
[  120.972757]  [<ffffffffa03d0c87>] ? nfs_file_flush+0x64/0x69 [nfs]
[  120.972757]  [<ffffffff811097c9>] ? filp_close+0x43/0x72
[  120.972757]  [<ffffffff810f9bb1>] ? sys_swapon+0xa39/0xae7
[  120.972757]  [<ffffffff81002b7a>] ? sysret_check+0x2e/0x69
[  120.972757]  [<ffffffff81002b42>] ? system_call_fastpath+0x16/0x1b

This patch releases the mutex if its held before calling filep_close()
so swapon fails as expected without deadlock when the swapfile is backed
by NFS.  If accepted for 2.6.39, it should also be considered a -stable
candidate for 2.6.38 and 2.6.37.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@kernel.org>		[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-unlock-swapfile-inode-mutex-before-closing-file-on-bad-swapfiles mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-unlock-swapfile-inode-mutex-before-closing-file-on-bad-swapfiles
+++ a/mm/swapfile.c
@@ -2149,8 +2149,13 @@ bad_swap_2:
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	if (swap_file)
+	if (swap_file) {
+		if (did_down) {
+			mutex_unlock(&inode->i_mutex);
+			did_down = 0;
+		}
 		filp_close(swap_file, NULL);
+	}
 out:
 	if (page && !IS_ERR(page)) {
 		kunmap(page);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

