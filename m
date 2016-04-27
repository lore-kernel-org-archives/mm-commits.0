From: akpm@linux-foundation.org
Subject: +
 ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch added to
 -mm tree
Date: Wed, 27 Apr 2016 14:22:07 -0700
Message-ID: <57212d7f.AbduCBIIouKEjySr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbcD0VWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up an unneeded goto in ocfs2_put_slot()
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch

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
Subject: ocfs2: clean up an unneeded goto in ocfs2_put_slot()

The goto is not useful in ocfs2_put_slot(), so delete it.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function
+++ a/fs/ocfs2/slot_map.c
@@ -535,12 +535,9 @@ void ocfs2_put_slot(struct ocfs2_super *
 	spin_unlock(&osb->osb_lock);
 
 	status = ocfs2_update_disk_slot(osb, si, slot_num);
-	if (status < 0) {
+       if (status < 0)
 		mlog_errno(status);
-		goto bail;
-	}
 
-bail:
 	ocfs2_free_slot_info(osb);
 }
 
_

Patches currently in -mm which might be from guozhonghua@h3c.com are

ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch
ocfs2-clean-up-an-unuseful-goto-in-ocfs2_put_slot-function.patch

