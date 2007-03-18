From: akpm@linux-foundation.org
Subject: - oom-fix-prevent-oom-from-killing-a-process-with-children-sibling-unkillable.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:11 -0800
Message-ID: <200703180910.l2I9ABOa020072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60494 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbXCRJKW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ankita@in.ibm.com, npiggin@suse.de, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     oom fix: prevent oom from killing a process with children/sibling unkillable
has been removed from the -mm tree.  Its filename was
     oom-fix-prevent-oom-from-killing-a-process-with-children-sibling-unkillable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom fix: prevent oom from killing a process with children/sibling unkillable
From: Ankita Garg <ankita@in.ibm.com>

Looking at oom_kill.c, found that the intention to not kill the selected
process if any of its children/siblings has OOM_DISABLE set, is not being
met.

Signed-off-by: Ankita Garg <ankita@in.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: William Irwin <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-fix-prevent-oom-from-killing-a-process-with-children-sibling-unkillable mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-prevent-oom-from-killing-a-process-with-children-sibling-unkillable
+++ a/mm/oom_kill.c
@@ -320,7 +320,7 @@ static int oom_kill_task(struct task_str
 	 * Don't kill the process if any threads are set to OOM_DISABLE
 	 */
 	do_each_thread(g, q) {
-		if (q->mm == mm && p->oomkilladj == OOM_DISABLE)
+		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
 			return 1;
 	} while_each_thread(g, q);
 
_

Patches currently in -mm which might be from ankita@in.ibm.com are

origin.patch
