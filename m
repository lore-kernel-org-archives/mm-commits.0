From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch
 added to -mm tree
Date: Wed, 01 Oct 2014 15:56:05 -0700
Message-ID: <542c8685.gGfSAoQsfHA0p/WB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaJAW4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: call dlm_lockres_put without resource spinlock
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2/dlm: call dlm_lockres_put without resource spinlock

dlm_lockres_put() should be called without &res->spinlock, otherwise a
deadlock case may happen.

spin_lock(&res->spinlock)
...
dlm_lockres_put
  ->dlm_lockres_release
    ->dlm_print_one_lock_resource
      ->spin_lock(&res->spinlock)

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1710,9 +1710,12 @@ int dlm_master_requery_handler(struct o2
 				BUG();
 			} else
 				__dlm_lockres_grab_inflight_worker(dlm, res);
-		} else /* put.. incase we are not the master */
+			spin_unlock(&res->spinlock);
+		} else {
+			/* put.. incase we are not the master */
+			spin_unlock(&res->spinlock);
 			dlm_lockres_put(res);
-		spin_unlock(&res->spinlock);
+		}
 	}
 	spin_unlock(&dlm->spinlock);
 
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch
ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch
ocfs2-fix-shift-left-operations-overflow.patch
ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order-fix.patch

