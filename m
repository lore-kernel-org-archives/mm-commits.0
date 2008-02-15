From: akpm@linux-foundation.org
Subject: + arch-um-kernel-memc-fix-a-shadowed-variable.patch added to -mm tree
Date: Thu, 14 Feb 2008 22:40:47 -0800
Message-ID: <200802150640.m1F6el4o024186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbYBOGku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 01:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@linux.intel.com


The patch titled
     arch/um/kernel/mem.c: fix a shadowed variable
has been added to the -mm tree.  Its filename is
     arch-um-kernel-memc-fix-a-shadowed-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/kernel/mem.c: fix a shadowed variable
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix a shadowed variable in arch/um/kernel/mem.c, since there is a global
variable has the same name.

Cc: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/kernel/mem.c~arch-um-kernel-memc-fix-a-shadowed-variable arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~arch-um-kernel-memc-fix-a-shadowed-variable
+++ a/arch/um/kernel/mem.c
@@ -299,7 +299,7 @@ void show_mem(void)
 {
 	int pfn, total = 0, reserved = 0;
 	int shared = 0, cached = 0;
-	int highmem = 0;
+	int high_mem = 0;
 	struct page *page;
 
 	printk(KERN_INFO "Mem-info:\n");
@@ -311,7 +311,7 @@ void show_mem(void)
 		page = pfn_to_page(pfn);
 		total++;
 		if (PageHighMem(page))
-			highmem++;
+			high_mem++;
 		if (PageReserved(page))
 			reserved++;
 		else if (PageSwapCache(page))
@@ -320,7 +320,7 @@ void show_mem(void)
 			shared += page_count(page) - 1;
 	}
 	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", highmem);
+	printk(KERN_INFO "%d pages of HIGHMEM\n", high_mem);
 	printk(KERN_INFO "%d reserved pages\n", reserved);
 	printk(KERN_INFO "%d pages shared\n", shared);
 	printk(KERN_INFO "%d pages swap cached\n", cached);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-fix-initrd-printk.patch
arch-um-kernel-memc-fix-a-shadowed-variable.patch
