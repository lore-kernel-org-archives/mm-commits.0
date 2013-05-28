From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch removed from -mm tree
Date: Tue, 28 May 2013 12:37:26 -0700
Message-ID: <51a50776.1Ln3ojjd+uUHzcve%akpm__24305.1935373389$1369769868$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3E1Th1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, stable@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: [merged] ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch removed from -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,stable@vger.kernel.org,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:26 -0700


The patch titled
     Subject: ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()
has been removed from the -mm tree.  Its filename was
     ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

Last time we found there is lock/unlock bug in ocfs2_file_aio_write, and
then we did a thorough search for all lock resources in ocfs2_inode_info,
including rw, inode and open lockres and found this bug.  My kernel
version is 3.0.13, and it is also in the lastest version 3.9.  In
ocfs2_fiemap, once ocfs2_get_clusters_nocache failed, it should goto
out_unlock instead of out, because we need release buffer head, up read
alloc sem and unlock inode.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/extent_map.c~ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap
+++ a/fs/ocfs2/extent_map.c
@@ -790,7 +790,7 @@ int ocfs2_fiemap(struct inode *inode, st
 						 &hole_size, &rec, &is_last);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (rec.e_blkno == 0ULL) {
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


