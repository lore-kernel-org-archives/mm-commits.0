From: akpm@linux-foundation.org
Subject: + ocfs2-unlock-rw-lock-if-inode-lock-failed.patch added to -mm tree
Date: Wed, 08 May 2013 12:39:08 -0700
Message-ID: <20130508193908.8457F31C26F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:45174 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3EHTjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 15:39:09 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so215069vcb.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 12:39:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joseph.qi@huawei.com, du.duyongfeng@huawei.com, jlbec@evilplan.org, lizefan@huawei.com, mfasheh@suse.com, sunil.mushran@gmail.com


The patch titled
     Subject: ocfs2: unlock rw lock if inode lock failed
has been added to the -mm tree.  Its filename is
     ocfs2-unlock-rw-lock-if-inode-lock-failed.patch

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
Subject: ocfs2: unlock rw lock if inode lock failed

In ocfs2_file_aio_write(), it does ocfs2_rw_lock() first and then
ocfs2_inode_lock().  But if ocfs2_inode_lock() failed, it goes to out_sems
without unlocking rw lock.  This will cause a bug in ocfs2_lock_res_free()
when testing res->l_ex_holders, which is increased in
__ocfs2_cluster_lock() and decreased in __ocfs2_cluster_unlock().

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: "Duyongfeng (B)" <du.duyongfeng@huawei.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-unlock-rw-lock-if-inode-lock-failed fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-unlock-rw-lock-if-inode-lock-failed
+++ a/fs/ocfs2/file.c
@@ -2288,7 +2288,7 @@ relock:
 		ret = ocfs2_inode_lock(inode, NULL, 1);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out_sems;
+			goto out;
 		}
 
 		ocfs2_inode_unlock(inode, 1);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-unlock-rw-lock-if-inode-lock-failed.patch

