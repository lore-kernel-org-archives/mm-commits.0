From: akpm@linux-foundation.org
Subject: + ocfs2-make-metadata-estimation-accurate-and-clear.patch added
 to -mm tree
Date: Tue, 09 Jan 2018 15:47:55 -0800
Message-ID: <5a5554ab.HHpeOzGeVapyBN11%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbeAIXr6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:47:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, john@nixnuts.net, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: make metadata estimation accurate and clear
has been added to the -mm tree.  Its filename is
     ocfs2-make-metadata-estimation-accurate-and-clear.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-make-metadata-estimation-accurate-and-clear.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-make-metadata-estimation-accurate-and-clear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2: make metadata estimation accurate and clear

Current code assume that ::w_unwritten_list always has only one item on. 
This is not right and hard to get understood.  So improve how to count
unwritten item.

Link: http://lkml.kernel.org/r/1515479070-32653-1-git-send-email-ge.changwei@h3c.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reported-by: John Lightsey <john@nixnuts.net>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/aops.c~ocfs2-make-metadata-estimation-accurate-and-clear fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-make-metadata-estimation-accurate-and-clear
+++ a/fs/ocfs2/aops.c
@@ -797,6 +797,7 @@ struct ocfs2_write_ctxt {
 	struct ocfs2_cached_dealloc_ctxt w_dealloc;
 
 	struct list_head		w_unwritten_list;
+	unsigned int			w_unwritten_count;
 };
 
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
@@ -1386,6 +1387,7 @@ retry:
 	desc->c_clear_unwritten = 0;
 	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
 	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
+	wc->w_unwritten_count++;
 	new = NULL;
 unlock:
 	spin_unlock(&oi->ip_lock);
@@ -2256,7 +2258,7 @@ static int ocfs2_dio_wr_get_block(struct
 		ue->ue_phys = desc->c_phys;
 
 		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
-		dwc->dw_zero_count++;
+		dwc->dw_zero_count += wc->w_unwritten_count;
 	}
 
 	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
_

Patches currently in -mm which might be from ge.changwei@h3c.com are

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
ocfs2-clean-dead-code-in-suballocc.patch
ocfs2-make-metadata-estimation-accurate-and-clear.patch
ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc.patch

