From: akpm@linux-foundation.org
Subject: + mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:12:37 -0800
Message-ID: <201001272312.o0RNCbAj005831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab0A0XMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tfransosi@gmail.com, balbir@linux.vnet.ibm.com


The patch titled
     mm/memcontrol.c: fix "integer as NULL pointer" sparse warning
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning.patch

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
mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning.patch
kernel-exitc-fix-shadows-sparse-warning.patch
console-vgaconc-mark-file-local-symbol-static.patch

