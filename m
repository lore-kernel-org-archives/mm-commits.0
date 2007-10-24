From: akpm@linux-foundation.org
Subject: + bogus-kern_alert-on-oops.patch added to -mm tree
Date: Wed, 24 Oct 2007 00:09:20 -0700
Message-ID: <200710240709.l9O79K3s027941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbXJXHKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 03:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Bogus KERN_ALERT on oops
has been added to the -mm tree.  Its filename is
     bogus-kern_alert-on-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Bogus KERN_ALERT on oops
From: Alexey Dobriyan <adobriyan@sw.ru>

printing eip: f881b9f3 *pdpt = 0000000000003001 <1>*pde = 000000000480a067 *pte = 0000000000000000
						^^^
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/fault_32.c~bogus-kern_alert-on-oops arch/x86/mm/fault_32.c
--- a/arch/x86/mm/fault_32.c~bogus-kern_alert-on-oops
+++ a/arch/x86/mm/fault_32.c
@@ -550,7 +550,7 @@ no_context:
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
 			                                         & (PTRS_PER_PMD - 1)];
-			printk(KERN_ALERT "*pde = %016Lx ", page);
+			printk("*pde = %016Lx ", page);
 			page &= ~_PAGE_NX;
 		}
 #else
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
bogus-kern_alert-on-oops.patch
single_open-seq_release-leak-diagnostics.patch
