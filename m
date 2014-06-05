From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:56 -0700
Message-ID: <5390c840.XZ2dcJD1PYy4AEA+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaFETm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:56 -0700


The patch titled
     Subject: ocfs2: fix incorrect i_size of global bitmap inode after resize
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-incorrect-i_size-of-global-bitmap-inode-after-resize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
linux-next.patch

