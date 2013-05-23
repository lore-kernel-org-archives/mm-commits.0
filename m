From: akpm@linux-foundation.org
Subject: +
 ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch added to -mm tree
Date: Thu, 23 May 2013 16:07:52 -0700
Message-ID: <519ea148.KduBdM6rEQPSqGQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab3EWXHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 19:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 16:07:52 -0700


The patch titled
     Subject: ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()
has been added to the -mm tree.  Its filename is
     ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch

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

ocfs2-unlock-rw-lock-if-inode-lock-failed.patch
ocfs2-goto-out_unlock-if-ocfs2_get_clusters_nocache-failed-in-ocfs2_fiemap.patch

