From: akpm@linux-foundation.org
Subject: [patch 087/114] mm: remove unneeded kallsyms include
Date: Tue, 06 Feb 2018 15:41:06 -0800
Message-ID: <20180206234106.pdy_ytUEW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: mm: remove unneeded kallsyms include

The file was converted from print_symbol() to %pSR a while ago in
071361d3473ebb814 ("mm: Convert print_symbol to %pSR").  kallsyms does not
seem to be needed anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-3-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memory.c~mm-remove-unneeded-kallsyms-include mm/memory.c
--- a/mm/memory.c~mm-remove-unneeded-kallsyms-include
+++ a/mm/memory.c
@@ -59,7 +59,6 @@
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
-#include <linux/kallsyms.h>
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
@@ -767,9 +766,6 @@ static void print_bad_pte(struct vm_area
 		dump_page(page, "bad pte");
 	pr_alert("addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
 		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
-	/*
-	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
-	 */
 	pr_alert("file:%pD fault:%pf mmap:%pf readpage:%pf\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,
_
