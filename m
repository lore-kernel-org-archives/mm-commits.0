From: akpm@linux-foundation.org
Subject: + fix-virt_to_phys-warnings.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:50:15 -0700
Message-ID: <200907022150.n62LoFAx015944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbZGBVum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cernekee@gmail.com, andi@firstfloor.org, mingo@elte.hu, ralf@linux-mips.org


The patch titled
     Fix virt_to_phys() warnings
has been added to the -mm tree.  Its filename is
     fix-virt_to_phys-warnings.patch

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
Subject: Fix virt_to_phys() warnings
From: Kevin Cernekee <cernekee@gmail.com>

These warnings were observed on MIPS32 using 2.6.31-rc1 and gcc-4.2.0:

mm/page_alloc.c: In function 'alloc_pages_exact':
mm/page_alloc.c:1986: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

drivers/usb/mon/mon_bin.c: In function 'mon_alloc_buff':
drivers/usb/mon/mon_bin.c:1264: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_bin.c |    2 +-
 mm/page_alloc.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/mon/mon_bin.c~fix-virt_to_phys-warnings drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~fix-virt_to_phys-warnings
+++ a/drivers/usb/mon/mon_bin.c
@@ -1251,7 +1251,7 @@ static int mon_alloc_buff(struct mon_pgm
 			return -ENOMEM;
 		}
 		map[n].ptr = (unsigned char *) vaddr;
-		map[n].pg = virt_to_page(vaddr);
+		map[n].pg = virt_to_page((void *) vaddr);
 	}
 	return 0;
 }
diff -puN mm/page_alloc.c~fix-virt_to_phys-warnings mm/page_alloc.c
--- a/mm/page_alloc.c~fix-virt_to_phys-warnings
+++ a/mm/page_alloc.c
@@ -1983,7 +1983,7 @@ void *alloc_pages_exact(size_t size, gfp
 		unsigned long alloc_end = addr + (PAGE_SIZE << order);
 		unsigned long used = addr + PAGE_ALIGN(size);
 
-		split_page(virt_to_page(addr), order);
+		split_page(virt_to_page((void *)addr), order);
 		while (used < alloc_end) {
 			free_page(used);
 			used += PAGE_SIZE;
_

Patches currently in -mm which might be from cernekee@gmail.com are

linux-next.patch
fix-virt_to_phys-warnings.patch
fix-virt_to_phys-warnings-fix.patch

