From: akpm@google.com
Subject: + devtmpfsd-fix-task-state-handling.patch added to -mm tree
Date: Tue, 11 Oct 2011 13:23:16 -0700
Message-ID: <201110112023.p9BKNGsv000475@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:22011 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1JKUXW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 16:23:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, greg@kroah.com


The patch titled
     Subject: devtmpfsd: fix task state handling
has been added to the -mm tree.  Its filename is
     devtmpfsd-fix-task-state-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: devtmpfsd: fix task state handling

Patches currently in -mm which might be from consul.kautuk@gmail.com are

linux-next.patch
devtmpfsd-fix-task-state-handling.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch

