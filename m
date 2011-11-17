From: akpm@linux-foundation.org
Subject: [merged] devtmpfsd-fix-task-state-handling.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:23 -0800
Message-ID: <201111172021.pAHKLNAh018344@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:64444 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:25 -0500
Received: by qyd20 with SMTP id 20so387688qyd.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: devtmpfsd: fix task state handling
has been removed from the -mm tree.  Its filename was
     devtmpfsd-fix-task-state-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: devtmpfsd: fix task state handling

- Set the state to TASK_INTERRUPTIBLE using __set_current_state()
  instead of set_current_state() as the spin_unlock is an implicit memory
  barrier.

- After return from schedule(), there is no need to set the current
  state to TASK_RUNNING - a call to schedule() always returns in
  TASK_RUNNING state.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/devtmpfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/base/devtmpfs.c~devtmpfsd-fix-task-state-handling drivers/base/devtmpfs.c
--- a/drivers/base/devtmpfs.c~devtmpfsd-fix-task-state-handling
+++ a/drivers/base/devtmpfs.c
@@ -413,10 +413,9 @@ static int devtmpfsd(void *p)
 			}
 			spin_lock(&req_lock);
 		}
-		set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock(&req_lock);
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	return 0;
 out:
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

linux-next.patch

