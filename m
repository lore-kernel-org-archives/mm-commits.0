From: akpm@linux-foundation.org
Subject: [patch 15/18] fs/binfmt_misc.c: node could be NULL when evicting
 inode
Date: Fri, 13 Oct 2017 15:58:18 -0700
Message-ID: <59e1450a.g+WdYPlIdt6rD6Ni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdJMW6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, eguan@redhat.com, oleg@redhat.com, viro@zeniv.linux.org.uk

From: Eryu Guan <eguan@redhat.com>
Subject: fs/binfmt_misc.c: node could be NULL when evicting inode

inode->i_private is assigned by a Node pointer only after registering a
new binary format, so it could be NULL if inode was created by
bm_fill_super() (or iput() was called by the error path in
bm_register_write()), and this could result in NULL pointer dereference
when evicting such an inode.  e.g.  mount binfmt_misc filesystem then
umount it immediately:

  mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc
  umount /proc/sys/fs/binfmt_misc

[ 9379.678259] BUG: unable to handle kernel NULL pointer dereference at 0000000000000013
[ 9379.985952] IP: bm_evict_inode+0x16/0x40 [binfmt_misc]
...
[ 9380.964911] Call Trace:
[ 9380.977633]  evict+0xd3/0x1a0
[ 9380.994449]  iput+0x17d/0x1d0
[ 9381.010306]  dentry_unlink_inode+0xb9/0xf0
[ 9381.034046]  __dentry_kill+0xc7/0x170
[ 9381.055145]  shrink_dentry_list+0x122/0x280
[ 9381.078908]  shrink_dcache_parent+0x39/0x90
[ 9381.103082]  do_one_tree+0x12/0x40
[ 9381.122005]  shrink_dcache_for_umount+0x2d/0x90
[ 9381.146517]  generic_shutdown_super+0x1f/0x120
[ 9381.171644]  kill_litter_super+0x29/0x40
[ 9381.193513]  deactivate_locked_super+0x43/0x70
[ 9381.219177]  deactivate_super+0x45/0x60
[ 9381.240130]  cleanup_mnt+0x3f/0x70
[ 9381.259064]  __cleanup_mnt+0x12/0x20
[ 9381.279802]  task_work_run+0x86/0xa0
[ 9381.299612]  exit_to_usermode_loop+0x6d/0x99
[ 9381.323872]  syscall_return_slowpath+0xba/0xf0
[ 9381.350464]  entry_SYSCALL_64_fastpath+0xa3/0xa

Fix it by making sure Node (e) is not NULL.

Link: http://lkml.kernel.org/r/20171010100642.31786-1-eguan@redhat.com
Fixes: 83f918274e4b ("exec: binfmt_misc: shift filp_close(interp_file) from kill_node() to bm_evict_inode()")
Signed-off-by: Eryu Guan <eguan@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-node-could-be-null-when-evicting-inode fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-node-could-be-null-when-evicting-inode
+++ a/fs/binfmt_misc.c
@@ -596,7 +596,7 @@ static void bm_evict_inode(struct inode
 {
 	Node *e = inode->i_private;
 
-	if (e->flags & MISC_FMT_OPEN_FILE)
+	if (e && e->flags & MISC_FMT_OPEN_FILE)
 		filp_close(e->interp_file, NULL);
 
 	clear_inode(inode);
_
