From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch added
 to -mm tree
Date: Thu, 29 May 2014 15:58:20 -0700
Message-ID: <5387bb8c.8X5RvyI8Nj/0vA7P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaE2W6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 18:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 15:58:20 -0700


The patch titled
     Subject: ocfs2: fix incorrect i_size of global bitmap inode after resize
has been added to the -mm tree.  Its filename is
     ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix incorrect i_size of global bitmap inode after resize

Ocfs2 cluster size may be 1MB, which has 20 bits.  When resize, the input
new clusters is mostly the number of clusters in a group
descriptor(32256).

Since the input clusters is defined as type int, so it will overflow when
shift left 20 bits and then lead to incorrect global bitmap i_size.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/resize.c~ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize
+++ a/fs/ocfs2/resize.c
@@ -153,7 +153,7 @@ static int ocfs2_update_last_group_and_i
 
 	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
 	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, new_clusters << osb->s_clustersize_bits);
+	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
 	i_size_write(bm_inode, le64_to_cpu(fe->i_size));
 
@@ -563,7 +563,7 @@ int ocfs2_group_add(struct inode *inode,
 
 	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
 	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
+	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
 	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-limit-printk-when-journal-is-aborted.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super.patch
ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch

