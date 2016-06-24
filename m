From: akpm@linux-foundation.org
Subject: +
 ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch added to
 -mm tree
Date: Fri, 24 Jun 2016 13:47:45 -0700
Message-ID: <576d9c71.jY0rR5x4l3oeI69x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbcFXUrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup unneeded goto in ocfs2_create_new_inode_locks
has been added to the -mm tree.  Its filename is
     ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch

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
Subject: ocfs2: cleanup unneeded goto in ocfs2_create_new_inode_locks

The last goto is unneeded, so remove it.

Link: http://lkml.kernel.org/r/576213D3.6080002@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks
+++ a/fs/ocfs2/dlmglue.c
@@ -1665,10 +1665,8 @@ int ocfs2_create_new_inode_locks(struct
 	}
 
 	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_open_lockres, 0, 0);
-	if (ret) {
+	if (ret)
 		mlog_errno(ret);
-		goto bail;
-	}
 
 bail:
 	return ret;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch

