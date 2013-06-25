From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch added to -mm tree
Date: Tue, 25 Jun 2013 16:39:58 -0700
Message-ID: <51ca2a4e.PUHTC/rq68M74+Oi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3FYXj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 19:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: + ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch added to -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 16:39:58 -0700


The patch titled
     Subject: ocfs2: dlmlock_master() should return DLM_NORMAL after adding lock to blocked list
has been added to the -mm tree.  Its filename is
     ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch

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
Subject: ocfs2: dlmlock_master() should return DLM_NORMAL after adding lock to blocked list

dlmlock_master() returns DLM_RECOVERING/DLM_MIGRATING/ DLM_FORWAR after
adding lock to blocked list if lockres has the state
DLM_LOCK_RES_RECOVERING/DLM_LOCK_RES_MIGRATING/ DLM_LOCK_RES_IN_PROGRESS. 
so it will retry in dlmlock().  And this may cause dlm_thread fall into an
infinite loop

	Thread1                                  dlm_thread
calls dlm_lock->dlmlock_master,
if lockresA is in state
DLM_LOCK_RES_RECOVERING, calls
__dlm_wait_on_lockres() and waits
until others threads clear this
state;

If cannot grant this lock,
adding lock to blocked list,
and return DLM_RECOVERING;

                                        Grant this lock and move it to
                                        grant list;

After a while, retry and
calls list_add_tail(), adding lock
to blocked list again.

Granted and blocked list of this lockres will become the following
conditions:

    lock_res->granted.next = dlm_lock->list_head;
    lock_res->blocked.next = dlm_lock->list_head;
    dlm_lock->list_head.next = dlm_lock_resource->blocked;

When dlm_thread traverses the granted list, it will fall into an endless
loop, checking dlm_lock.list_head, dlm_lock->list_head.next
(i.e.lock_res->blocked), lock_res->blocked.next(i.e.dlm_lock.list_head
again) .....

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: jensen <shencanquan@huawei.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmlock.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmlock.c~ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list fs/ocfs2/dlm/dlmlock.c
--- a/fs/ocfs2/dlm/dlmlock.c~ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -178,6 +178,7 @@ static enum dlm_status dlmlock_master(st
 				     lock->ml.node);
 			}
 		} else {
+			status = DLM_NORMAL;
 			dlm_lock_get(lock);
 			list_add_tail(&lock->list, &res->blocked);
 			kick_thread = 1;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

linux-next.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch
ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch

