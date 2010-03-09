From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:04 -0800
Message-ID: <201003091904.o29J44E3031014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809Ab0CITEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tfransosi@gmail.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm/memcontrol.c: fix "integer as NULL pointer" sparse warning
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memcontrol.c: fix "integer as NULL pointer" sparse warning
From: Thiago Farina <tfransosi@gmail.com>

mm/memcontrol.c:2548:32: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning
+++ a/mm/memcontrol.c
@@ -2545,7 +2545,7 @@ static int mem_cgroup_force_empty_list(s
 		pc = list_entry(list->prev, struct page_cgroup, lru);
 		if (busy == pc) {
 			list_move(&pc->lru, list);
-			busy = 0;
+			busy = NULL;
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
 			continue;
 		}
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch

