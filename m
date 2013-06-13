From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:30 -0700
Message-ID: <51ba161a.f6Tyq2YByTtvazbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab3FMS5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, joe.jin@oracle.com, jlbec@evilplan.org, xiaowei.hu@oracle.com

Subject: [merged] ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch removed from -mm tree
To: xiaowei.hu@oracle.com,jlbec@evilplan.org,joe.jin@oracle.com,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:30 -0700


The patch titled
     Subject: ocfs2: ocfs2_prep_new_orphaned_file() should return ret
has been removed from the -mm tree.  Its filename was
     ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
Subject: ocfs2: ocfs2_prep_new_orphaned_file() should return ret

If an error occurs, for example an EIO in __ocfs2_prepare_orphan_dir,
ocfs2_prep_new_orphaned_file will release the inode_ac, then when the
caller of ocfs2_prep_new_orphaned_file gets a 0 return, it will refer to a
NULL ocfs2_alloc_context struct in the following functions.  A kernel
panic happens.

Signed-off-by: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
Reviewed-by: shencanquan <shencanquan@huawei.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret
+++ a/fs/ocfs2/namei.c
@@ -2216,7 +2216,7 @@ out:
 
 	brelse(orphan_dir_bh);
 
-	return 0;
+	return ret;
 }
 
 int ocfs2_create_inode_in_orphan(struct inode *dir,
_

Patches currently in -mm which might be from xiaowei.hu@oracle.com are

origin.patch

