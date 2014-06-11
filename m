From: akpm@linux-foundation.org
Subject: +
 ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch added to
 -mm tree
Date: Wed, 11 Jun 2014 15:25:15 -0700
Message-ID: <5398d74b.oUADnpQcZfeQhNjn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaFKWZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jiangyiwen@huawei.com, xuejiufei@huawei.com

Subject: + ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch added to -mm tree
To: xuejiufei@huawei.com,jiangyiwen@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:25:15 -0700


The patch titled
     Subject: ocfs2: remove conversion of total_backoff in dlm_join_domain()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: remove conversion of total_backoff in dlm_join_domain()

The unit of total_backoff is msecs not jiffies, so no need to do the
conversion.  Otherwise, the join timeout is not 90 sec.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1923,12 +1923,11 @@ static int dlm_join_domain(struct dlm_ct
 				goto bail;
 			}
 
-			if (total_backoff >
-			    msecs_to_jiffies(DLM_JOIN_TIMEOUT_MSECS)) {
+			if (total_backoff > DLM_JOIN_TIMEOUT_MSECS) {
 				status = -ERESTARTSYS;
 				mlog(ML_NOTICE, "Timed out joining dlm domain "
 				     "%s after %u msecs\n", dlm->name,
-				     jiffies_to_msecs(total_backoff));
+				     total_backoff);
 				goto bail;
 			}
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

