From: akpm@linux-foundation.org
Subject: + mm-use-div_round_up-in-mm-memoryc.patch added to -mm tree
Date: Fri, 18 May 2007 10:30:42 -0700
Message-ID: <200705181730.l4IHUg8k019741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:48046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbXERRdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     MM: use DIV_ROUND_UP() in mm/memory.c
has been added to the -mm tree.  Its filename is
     mm-use-div_round_up-in-mm-memoryc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MM: use DIV_ROUND_UP() in mm/memory.c
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Replace a hand coded version of DIV_ROUND_UP().

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-use-div_round_up-in-mm-memoryc mm/memory.c
--- a/mm/memory.c~mm-use-div_round_up-in-mm-memoryc
+++ a/mm/memory.c
@@ -2653,7 +2653,7 @@ int make_pages_present(unsigned long add
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

mm-use-div_round_up-in-mm-memoryc.patch
