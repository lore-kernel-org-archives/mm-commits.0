From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:03:07 -0700
Message-ID: <573f7b8b.LmdAJaW1sNrsl1I/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETVDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up an unneeded goto in ocfs2_put_slot()
has been removed from the -mm tree.  Its filename was
     ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: clean up an unneeded goto in ocfs2_put_slot()

The goto is not useful in ocfs2_put_slot(), so delete it.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function
+++ a/fs/ocfs2/slot_map.c
@@ -535,12 +535,8 @@ void ocfs2_put_slot(struct ocfs2_super *
 	spin_unlock(&osb->osb_lock);
 
 	status = ocfs2_update_disk_slot(osb, si, slot_num);
-	if (status < 0) {
+	if (status < 0)
 		mlog_errno(status);
-		goto bail;
-	}
 
-bail:
 	ocfs2_free_slot_info(osb);
 }
