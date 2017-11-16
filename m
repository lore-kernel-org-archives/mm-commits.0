From: akpm@linux-foundation.org
Subject: [patch 012/131] ocfs2: remove unneeded goto in
 ocfs2_reserve_cluster_bitmap_bits()
Date: Wed, 15 Nov 2017 17:31:55 -0800
Message-ID: <20171116013155.pl6Y66jQL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933442AbdKPBb5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:31:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: remove unneeded goto in ocfs2_reserve_cluster_bitmap_bits()

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4F3CDE3A9@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it
+++ a/fs/ocfs2/suballoc.c
@@ -1147,12 +1147,9 @@ int ocfs2_reserve_cluster_bitmap_bits(st
 					     GLOBAL_BITMAP_SYSTEM_INODE,
 					     OCFS2_INVALID_SLOT, NULL,
 					     ALLOC_NEW_GROUP);
-	if (status < 0 && status != -ENOSPC) {
+	if (status < 0 && status != -ENOSPC)
 		mlog_errno(status);
-		goto bail;
-	}
 
-bail:
 	return status;
 }
 
_
