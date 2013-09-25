From: akpm@linux-foundation.org
Subject: + ocfs2-rollback-transaction-in-ocfs2_group_add.patch added to
 -mm tree
Date: Wed, 25 Sep 2013 15:44:47 -0700
Message-ID: <5243675f.JVlzubS+x+/PNSa8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IYWos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 18:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, younger.liu@huawei.com

Subject: + ocfs2-rollback-transaction-in-ocfs2_group_add.patch added to -mm tree
To: younger.liu@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 15:44:47 -0700


The patch titled
     Subject: ocfs2: rollback transaction in ocfs2_group_add()
has been added to the -mm tree.  Its filename is
     ocfs2-rollback-transaction-in-ocfs2_group_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-rollback-transaction-in-ocfs2_group_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-rollback-transaction-in-ocfs2_group_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: rollback transaction in ocfs2_group_add()

If ocfs2_journal_access_di() fails, group->bg_next_group should rollback. 
Otherwise, there would be a inconsistency between group_bh and main_bm_bh.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/resize.c~ocfs2-rollback-transaction-in-ocfs2_group_add fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-rollback-transaction-in-ocfs2_group_add
+++ a/fs/ocfs2/resize.c
@@ -469,6 +469,7 @@ int ocfs2_group_add(struct inode *inode,
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_chain_rec *cr;
 	u16 cl_bpc;
+	u64 bg_ptr;
 
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
@@ -538,12 +539,14 @@ int ocfs2_group_add(struct inode *inode,
 	}
 
 	group = (struct ocfs2_group_desc *)group_bh->b_data;
+	bg_ptr = le64_to_cpu(group->bg_next_group);
 	group->bg_next_group = cr->c_blkno;
 	ocfs2_journal_dirty(handle, group_bh);
 
 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(main_bm_inode),
 				      main_bm_bh, OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
+		group->bg_next_group = cpu_to_le64(bg_ptr);
 		mlog_errno(ret);
 		goto out_commit;
 	}
_

Patches currently in -mm which might be from younger.liu@huawei.com are

ocfs2-rollback-transaction-in-ocfs2_group_add.patch
ocfs2-do-not-call-brelse-if-group_bh-is-not-initialized-in-ocfs2_group_add.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch

