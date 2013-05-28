From: akpm@linux-foundation.org
Subject: + ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch
 added to -mm tree
Date: Tue, 28 May 2013 15:35:27 -0700
Message-ID: <51a5312f.vZqzDvmi++UZKl5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab3E1Wf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 18:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, joe.jin@oracle.com, jlbec@evilplan.org, xiaowei.hu@oracle.com

Subject: + ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch added to -mm tree
To: xiaowei.hu@oracle.com,jlbec@evilplan.org,joe.jin@oracle.com,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 15:35:27 -0700


The patch titled
     Subject: ocfs2: ocfs2_prep_new_orphaned_file() should return ret
has been added to the -mm tree.  Its filename is
     ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-ocfs2_prep_new_orphaned_file-should-return-ret.patch

