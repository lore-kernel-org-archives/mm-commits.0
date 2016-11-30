From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree.patch
 added to -mm tree
Date: Wed, 30 Nov 2016 15:03:31 -0800
Message-ID: <583f5ac3.iFONGGy5nNyHnz/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcK3XDP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 18:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ashish.samant@oracle.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, zren@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix double put of recount tree in ocfs2_lock_refcount_tree()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ashish Samant <ashish.samant@oracle.com>
Subject: ocfs2: fix double put of recount tree in ocfs2_lock_refcount_tree()

In ocfs2_lock_refcount_tree, if ocfs2_read_refcount_block() returns error,
we do ocfs2_refcount_tree_put twice (once in ocfs2_unlock_refcount_tree
and once outside it), thereby reducing the refcount of the refcount tree
twice, but we dont delete the tree in this case.  This will make refcnt of
the tree = 0 and the ocfs2_refcount_tree_put will eventually call
ocfs2_mark_lockres_freeing, setting OCFS2_LOCK_FREEING for the
refcount_tree->rf_lockres.

The error returned by ocfs2_read_refcount_block is propagated all the way
back and for next iteration of write, ocfs2_lock_refcount_tree gets the
same tree back from ocfs2_get_refcount_tree because we havent deleted the
tree.  Now we have the same tree, but OCFS2_LOCK_FREEING is set for
rf_lockres and eventually, when _ocfs2_lock_refcount_tree is called in
this iteration, BUG_ON( __ocfs2_cluster_lock:1395 ERROR: Cluster lock
called on freeing lockres T00000000000000000386019775b08d!  flags 0x81) is
triggerred.

Call stack:

(loop16,11155,0):ocfs2_lock_refcount_tree:482 ERROR: status = -5
(loop16,11155,0):ocfs2_refcount_cow_hunk:3497 ERROR: status = -5
(loop16,11155,0):ocfs2_refcount_cow:3560 ERROR: status = -5
(loop16,11155,0):ocfs2_prepare_inode_for_refcount:2111 ERROR: status = -5
(loop16,11155,0):ocfs2_prepare_inode_for_write:2190 ERROR: status = -5
(loop16,11155,0):ocfs2_file_write_iter:2331 ERROR: status = -5
(loop16,11155,0):__ocfs2_cluster_lock:1395 ERROR: bug expression:
lockres->l_flags & OCFS2_LOCK_FREEING

(loop16,11155,0):__ocfs2_cluster_lock:1395 ERROR: Cluster lock called on
freeing lockres T00000000000000000386019775b08d! flags 0x81

------------[ cut here ]------------
kernel BUG at fs/ocfs2/dlmglue.c:1395!

invalid opcode: 0000 [#1] SMP  CPU 0
Modules linked in: tun ocfs2 jbd2 xen_blkback xen_netback xen_gntdev ..
sd_mod crc_t10dif ext3 jbd mbcache

RIP: e030:[<ffffffffa082137c>]  [<ffffffffa082137c>]
__ocfs2_cluster_lock+0x31c/0x740 [ocfs2]
RSP: e02b:ffff88017c0138a0  EFLAGS: 00010086
Process loop16 (pid: 11155, threadinfo ffff88017c010000, task
ffff8801b5374300)
Stack:
 ffff88017bd25880 0000000000000081 000000017c013920 ffff88017c013960
 000000000000001d 0000000000000001 ffff88017bd258b4 0000000000000000
 ffff880172006000 00000000a07fa410 ffff88017bd202b4 0000000000000000
Call Trace:
 [<ffffffffa08227de>] ocfs2_refcount_lock+0xae/0x130 [ocfs2]
 [<ffffffffa0846b89>] ? __ocfs2_lock_refcount_tree+0x29/0xe0 [ocfs2]
 [<ffffffff81509dde>] ? _raw_spin_lock+0xe/0x20
 [<ffffffffa0846b89>] __ocfs2_lock_refcount_tree+0x29/0xe0 [ocfs2]
 [<ffffffffa084d47d>] ocfs2_lock_refcount_tree+0xdd/0x320 [ocfs2]
 [<ffffffffa084de3b>] ocfs2_refcount_cow_hunk+0x1cb/0x440 [ocfs2]
 [<ffffffffa084e159>] ocfs2_refcount_cow+0xa9/0x1d0 [ocfs2]
 [<ffffffffa08291c7>] ? ocfs2_prepare_inode_for_refcount+0x67/0x200 [ocfs2]
 [<ffffffffa0829275>] ocfs2_prepare_inode_for_refcount+0x115/0x200 [ocfs2]
 [<ffffffffa081f394>] ? ocfs2_inode_unlock+0xd4/0x140 [ocfs2]
 [<ffffffffa082969b>] ocfs2_prepare_inode_for_write+0x33b/0x470 [ocfs2]
 [<ffffffffa0822620>] ? ocfs2_rw_lock+0x80/0x190 [ocfs2]
 [<ffffffffa082c150>] ocfs2_file_write_iter+0x220/0x8c0 [ocfs2]
 [<ffffffff81112c67>] ? mempool_free_slab+0x17/0x20
 [<ffffffff8119f2b1>] ? bio_free+0x61/0x70
 [<ffffffff811adece>] ? aio_kernel_free+0xe/0x10
 [<ffffffff811adb1e>] aio_write_iter+0x2e/0x30

Fix this by avoiding the second call to ocfs2_refcount_tree_put()

Link: http://lkml.kernel.org/r/1473984404-32011-1-git-send-email-ashish.samant@oracle.com
Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
Reviewed-by: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree
+++ a/fs/ocfs2/refcounttree.c
@@ -478,7 +478,6 @@ again:
 	if (ret) {
 		mlog_errno(ret);
 		ocfs2_unlock_refcount_tree(osb, tree, rw);
-		ocfs2_refcount_tree_put(tree);
 		goto out;
 	}
 
_

Patches currently in -mm which might be from ashish.samant@oracle.com are

ocfs2-fix-double-put-of-recount-tree-in-ocfs2_lock_refcount_tree.patch

