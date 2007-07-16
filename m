From: akpm@linux-foundation.org
Subject: - mm-use-div_round_up-in-mm-memoryc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:44 -0700
Message-ID: <200707162048.l6GKmieH001090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758817AbXGPUs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     MM: use DIV_ROUND_UP() in mm/memory.c
has been removed from the -mm tree.  Its filename was
     mm-use-div_round_up-in-mm-memoryc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MM: use DIV_ROUND_UP() in mm/memory.c
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Replace a hand coded version of DIV_ROUND_UP().

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-use-div_round_up-in-mm-memoryc mm/memory.c
--- a/mm/memory.c~mm-use-div_round_up-in-mm-memoryc
+++ a/mm/memory.c
@@ -2673,7 +2673,7 @@ int make_pages_present(unsigned long add
 	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
-	len = (end+PAGE_SIZE-1)/PAGE_SIZE-addr/PAGE_SIZE;
+	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
 	if (ret < 0)
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch
git-r8169.patch
