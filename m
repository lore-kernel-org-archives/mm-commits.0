From: akpm@linux-foundation.org
Subject: + mm-print-out-meminit-for-memmap.patch added to -mm tree
Date: Thu, 02 Oct 2008 16:24:33 -0700
Message-ID: <200810022324.m92NOXlv032095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbYJBXZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 19:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, mingo@elte.hu


The patch titled
     mm: print out meminit for memmap
has been added to the -mm tree.  Its filename is
     mm-print-out-meminit-for-memmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: print out meminit for memmap
From: Yinghai Lu <yhlu.kernel@gmail.com>

Improve debuggability of memory setup problems.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-print-out-meminit-for-memmap mm/page_alloc.c
--- a/mm/page_alloc.c~mm-print-out-meminit-for-memmap
+++ a/mm/page_alloc.c
@@ -3517,8 +3517,8 @@ static void __paginginit free_area_init_
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
-			mminit_dprintk(MMINIT_TRACE, "memmap_init",
-				"%s zone: %lu pages used for memmap\n",
+			printk(KERN_DEBUG
+				"  %s zone: %lu pages used for memmap\n",
 				zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
@@ -3528,8 +3528,7 @@ static void __paginginit free_area_init_
 		/* Account for reserved pages */
 		if (j == 0 && realsize > dma_reserve) {
 			realsize -= dma_reserve;
-			mminit_dprintk(MMINIT_TRACE, "memmap_init",
-					"%s zone: %lu pages reserved\n",
+			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
 					zone_names[0], dma_reserve);
 		}
 
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

git-x86.patch
git-timers-fix-printk-errors-clean-up.patch
git-pci.patch
git-acpi.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
acpi-dont-load-acpi_cpufreq-if-acpi=off.patch
mm-print-out-meminit-for-memmap.patch

