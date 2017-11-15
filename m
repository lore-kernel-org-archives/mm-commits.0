From: akpm@linux-foundation.org
Subject: +
 ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it.patch added to -mm tree
Date: Wed, 15 Nov 2017 11:28:16 -0800
Message-ID: <5a0c9550.3Qd5SgTeHqRrlR1y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757599AbdKOT27 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 14:28:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded goto in ocfs2_reserve_cluster_bitmap_bits()
has been added to the -mm tree.  Its filename is
     ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from guozhonghua@h3c.com are

ocfs2-remove-unused-function-ocfs2_publish_get_mount_state.patch
ocfs2-the-goto-is-not-useful-in-the-function-ocfs2_reserve_cluster_bitmap_bits-so-remove-it.patch

