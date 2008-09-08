From: akpm@linux-foundation.org
Subject: + bfs-lockdep-warning.patch added to -mm tree
Date: Mon, 08 Sep 2008 16:50:19 -0700
Message-ID: <200809082350.m88NoKC1016526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbYIHXuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 19:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, tigran@aivazian.fsnet.co.uk


The patch titled
     bfs: fix Lockdep warning
has been added to the -mm tree.  Its filename is
     bfs-lockdep-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfs: fix Lockdep warning


[ 2585.162442] =============================================
[ 2585.162639] [ INFO: possible recursive locking detected ]
[ 2585.162736] 2.6.27-rc5-00283-g70bb089 #68
[ 2585.162822] ---------------------------------------------
[ 2585.162992] touch/6855 is trying to acquire lock:
[ 2585.163014]  (&info->bfs_lock){--..}, at: [<c02262f5>]
bfs_delete_inode+0x9e/0x18c
[ 2585.163014]
[ 2585.163014] but task is already holding lock:
[ 2585.163014]  (&info->bfs_lock){--..}, at: [<c0226c00>]
bfs_create+0x45/0x187
[ 2585.163014]
[ 2585.163014] other info that might help us debug this:
[ 2585.163014] 2 locks held by touch/6855:
[ 2585.163014]  #0:  (&type->i_mutex_dir_key#5){--..}, at: [<c018ad13>]
do_filp_open+0x10b/0x62f
[ 2585.163014]  #1:  (&info->bfs_lock){--..}, at: [<c0226c00>]
bfs_create+0x45/0x187
[ 2585.163014]
[ 2585.163014] stack backtrace:
[ 2585.163014] Pid: 6855, comm: touch Not tainted
2.6.27-rc5-00283-g70bb089 #68
[ 2585.163014]  [<c013e769>] validate_chain+0x458/0x9f4
[ 2585.163014]  [<c013bece>] ? trace_hardirqs_off+0xb/0xd
[ 2585.163014]  [<c013f36b>] __lock_acquire+0x666/0x6e0
[ 2585.163014]  [<c013f440>] lock_acquire+0x5b/0x77
[ 2585.163014]  [<c02262f5>] ? bfs_delete_inode+0x9e/0x18c
[ 2585.163014]  [<c06aab74>] mutex_lock_nested+0xbc/0x234
[ 2585.163014]  [<c02262f5>] ? bfs_delete_inode+0x9e/0x18c
[ 2585.163014]  [<c02262f5>] ? bfs_delete_inode+0x9e/0x18c
[ 2585.163014]  [<c02262f5>] bfs_delete_inode+0x9e/0x18c
[ 2585.163014]  [<c0226257>] ? bfs_delete_inode+0x0/0x18c
[ 2585.163014]  [<c01925e1>] generic_delete_inode+0x94/0xfe
[ 2585.163014]  [<c019265d>] generic_drop_inode+0x12/0x12f
[ 2585.163014]  [<c0191b7e>] iput+0x4b/0x4e
[ 2585.163014]  [<c0226d1e>] bfs_create+0x163/0x187
[ 2585.163014]  [<c0188b42>] vfs_create+0xa6/0x114
[ 2585.163014]  [<c018adb5>] do_filp_open+0x1ad/0x62f
[ 2585.163014]  [<c0107cdc>] ? native_sched_clock+0x82/0x96
[ 2585.163014]  [<c06ac309>] ? _spin_unlock+0x27/0x3c
[ 2585.163014]  [<c019379e>] ? alloc_fd+0xbf/0xc9
[ 2585.163014]  [<c06ae2f4>] ? sub_preempt_count+0x9d/0xab
[ 2585.163014]  [<c019379e>] ? alloc_fd+0xbf/0xc9
[ 2585.163014]  [<c0180391>] do_sys_open+0x42/0xb8
[ 2585.163014]  [<c041d564>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 2585.163014]  [<c0180449>] sys_open+0x1e/0x26
[ 2585.163014]  [<c01038bd>] sysenter_do_call+0x12/0x31
[ 2585.163014]  =======================

The problem is that we don't unlock the bfs->lock mutex before calling
iput (we do in the other cases).

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bfs/dir.c~bfs-lockdep-warning fs/bfs/dir.c
--- a/fs/bfs/dir.c~bfs-lockdep-warning
+++ a/fs/bfs/dir.c
@@ -125,8 +125,8 @@ static int bfs_create(struct inode *dir,
 							inode->i_ino);
 	if (err) {
 		inode_dec_link_count(inode);
-		iput(inode);
 		mutex_unlock(&info->bfs_lock);
+		iput(inode);
 		return err;
 	}
 	mutex_unlock(&info->bfs_lock);
_

Patches currently in -mm which might be from snakebyte@gmx.de are

bfs-lockdep-warning.patch
linux-next.patch
hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
hfsplus-check-read_mapping_page-return-value.patch
hfsplus-fix-another-bug-when-reading-a-corrupted-image.patch
hfsplus-check-hfs_bnode_find-return-value.patch

