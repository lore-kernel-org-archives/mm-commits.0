From: akpm@linux-foundation.org
Subject: + mm-remove-unneeded-kallsyms-include.patch added to -mm tree
Date: Fri, 08 Dec 2017 14:24:48 -0800
Message-ID: <5a2b1130.mxs7J/o0F01DhdYO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752350AbdLHWYu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Dec 2017 17:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, mhocko@suse.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unneeded kallsyms include
has been added to the -mm tree.  Its filename is
     mm-remove-unneeded-kallsyms-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unneeded-kallsyms-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unneeded-kallsyms-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

sched-autogroup-remove-unneeded-kallsyms-include.patch
mm-remove-unneeded-kallsyms-include.patch
power-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
pnp-remove-unneeded-kallsyms-include.patch
workqueue-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

