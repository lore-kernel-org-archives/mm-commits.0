From: akpm@linux-foundation.org
Subject: - arch-um-kernel-memc-fix-a-shadowed-variable.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:04 -0800
Message-ID: <200802250044.m1P0i4RQ006054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbYBYAoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/um/kernel/mem.c: fix a shadowed variable
has been removed from the -mm tree.  Its filename was
     arch-um-kernel-memc-fix-a-shadowed-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

arch-um-kernel-um_archc-some-small-improvements.patch
fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
