From: akpm@linux-foundation.org
Subject: - fix-pf_nofreeze-and-freezeable-race-2.patch removed from -mm tree
Date: Fri, 11 May 2007 12:29:10 -0700
Message-ID: <200705111929.l4BJTA4p024585@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759069AbXEKTaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, oleg@tv-sign.ru, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Fix PF_NOFREEZE and freezeable race
has been removed from the -mm tree.  Its filename was
     fix-pf_nofreeze-and-freezeable-race-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix PF_NOFREEZE and freezeable race
From: Gautham R Shenoy <ego@in.ibm.com>

This patch fixes the race pointed out by Oleg Nesterov.

* Freezer marks a thread as freezeable.
* The thread now marks itself PF_NOFREEZE causing it to
  freeze on calling try_to_freeze(). Thus the task is frozen, even though
  it doesn't want to.
* Subsequent thaw_processes() will also fail to thaw the task since it is
  marked PF_NOFREEZE.

Avoid this problem by checking the task's PF_NOFREEZE status in
frozen_processes() before marking the task as frozen.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/freezer.h~fix-pf_nofreeze-and-freezeable-race-2 include/linux/freezer.h
--- a/include/linux/freezer.h~fix-pf_nofreeze-and-freezeable-race-2
+++ a/include/linux/freezer.h
@@ -57,8 +57,10 @@ static inline int thaw_process(struct ta
  */
 static inline void frozen_process(struct task_struct *p)
 {
-	p->flags |= PF_FROZEN;
-	wmb();
+	if (!unlikely(p->flags & PF_NOFREEZE)) {
+		p->flags |= PF_FROZEN;
+		wmb();
+	}
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
_

Patches currently in -mm which might be from ego@in.ibm.com are

origin.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
