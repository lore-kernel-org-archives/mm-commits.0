From: akpm@linux-foundation.org
Subject: - mm-oom-killer-kills-more-than-needed.patch removed from -mm tree
Date: Tue, 23 Sep 2008 10:40:56 -0700
Message-ID: <200809231740.m8NHeu9N012710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbYIWRlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 13:41:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chad.zanonie@gmail.com, npiggin@suse.de, oleg@tv-sign.ru, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: oom-killer kills more than needed
has been removed from the -mm tree.  Its filename was
     mm-oom-killer-kills-more-than-needed.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: oom-killer kills more than needed
From: "Chad Zanonie" <chad.zanonie@gmail.com>

Possibility exists for an exiting application to be in between marking its
mm NULL and calling mmput when out_of_memory is invoked. 
select_bad_process() will continue past this process as opposed to
returning -1UL due to its mm being NULL.  This causes the oom killer in
certain scenarios to not only kill the memory culprit, but also kill the
runner up.

EXIT_DEAD seems to be the only flag that guarantees that mmput() has
finished.  Checking for PF_KTHREAD should replace p->mm regardless. 
Adding EXIT_DEAD to the check seems to prevent unnecessary kills in local
testing.

Signed-off-by: Chad Zanonie <chad.zanonie@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom-killer-kills-more-than-needed mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-killer-kills-more-than-needed
+++ a/mm/oom_kill.c
@@ -216,7 +216,7 @@ static struct task_struct *select_bad_pr
 		 * skip kernel threads and tasks which have already released
 		 * their mm.
 		 */
-		if (!p->mm)
+		if (p->flags & PF_KTHREAD || p->flags & EXIT_DEAD)
 			continue;
 		/* skip the init task */
 		if (is_global_init(p))
_

Patches currently in -mm which might be from chad.zanonie@gmail.com are

mm-oom-killer-kills-more-than-needed.patch

