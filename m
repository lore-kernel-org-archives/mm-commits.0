From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:18 -0700
Message-ID: <51db11a6.Ii86/xjJd53le8J4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3GHTXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: [merged] ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch removed from -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:18 -0700


The patch titled
     Subject: ocfs2: dlmlock_master() should return DLM_NORMAL after adding lock to blocked list
has been removed from the -mm tree.  Its filename was
     ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
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

origin.patch
linux-next.patch

