From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch
 added to -mm tree
Date: Wed, 27 May 2020 15:55:05 -0700
Message-ID: <20200527225505.R0QsiA6q4%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0WzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 18:55:07 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: fix ocfs2 corrupt when iputting an inode
has been added to the -mm tree.  Its filename is
     ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wangyan <wangyan122@huawei.com>
Subject: ocfs2: fix ocfs2 corrupt when iputting an inode

In this condition, it will cause an bug on error.
ocfs2_mkdir()
  ->ocfs2_mknod()
    ->ocfs2_mknod_locked()
      ->__ocfs2_mknod_locked()
        //Assume inode->i_generation is genN.
        ->inode->i_generation = osb->s_next_generation++;
        // The inode lockres has been initialized.
        ->ocfs2_populate_inode()
        ->ocfs2_create_new_inode_locks()
            ->An error happened, returned value is non-zero
      // free the start_bit x in bg_blkno
      ->ocfs2_free_suballoc_bits()
    ->...  /* Another process execute mkdir success in this place,
              and it occupied the start_bit x in bg_blkno
              which has been freed before. Its inode->i_generation
              is genN + 1 */
    ->iput(inode)
      ->evict()
        ->ocfs2_evict_inode()
          ->ocfs2_delete_inode()
            ->ocfs2_inode_lock()
              ->ocfs2_inode_lock_update()
                /* Bug on here, genN != genN + 1 */
                ->mlog_bug_on_msg(inode->i_generation !=
                  le32_to_cpu(fe->i_generation))

So, we need not to reclaim the inode when the inode->ip_inode_lockres
has been initialized. It will be freed in iput().

Link: http://lkml.kernel.org/r/ef080ca3-5d74-e276-17a1-d9e7c7e662c9@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/namei.c~ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode
+++ a/fs/ocfs2/namei.c
@@ -640,7 +640,8 @@ static int ocfs2_mknod_locked(struct ocf
 	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
+	if (status < 0 && !(OCFS2_I(inode)->ip_inode_lockres.l_flags &
+				OCFS2_LOCK_INITIALIZED)) {
 		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
 		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
 				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
_

Patches currently in -mm which might be from wangyan122@huawei.com are

ocfs2-clear-links-count-in-ocfs2_mknod-if-an-error-occurs.patch
ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch
