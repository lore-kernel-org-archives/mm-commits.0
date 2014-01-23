From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-flush-conflicting-continuation-line-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:22:39 -0800
Message-ID: <52e1a43f.+hL+p2Ao2ArCOfVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAWXWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:22:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paul.gortmaker@windriver.com, kay@vrfy.org, joe@perches.com, getarunks@gmail.com, fweisbec@gmail.com, arunks.linux@gmail.com, arun.ks@broadcom.com, akpm@linux-foundation.org

Subject: [folded-merged] printk-flush-conflicting-continuation-line-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,arun.ks@broadcom.com,arunks.linux@gmail.com,fweisbec@gmail.com,getarunks@gmail.com,joe@perches.com,kay@vrfy.org,paul.gortmaker@windriver.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:22:39 -0800


The patch titled
     Subject: printk-flush-conflicting-continuation-line-fix
has been removed from the -mm tree.  Its filename was
     printk-flush-conflicting-continuation-line-fix.patch

This patch was dropped because it was folded into printk-flush-conflicting-continuation-line.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-flush-conflicting-continuation-line-fix

simplify and condense the code

Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Arun KS <arun.ks@broadcom.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Arun KS <getarunks@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/printk/printk.c~printk-flush-conflicting-continuation-line-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-flush-conflicting-continuation-line-fix
+++ a/kernel/printk/printk.c
@@ -1595,15 +1595,15 @@ asmlinkage int vprintk_emit(int facility
 		 * either merge it with the current buffer and flush, or if
 		 * there was a race with interrupts (prefix == true) then just
 		 * flush it out and store this line separately.
+		 * If the preceding printk was from a different task and missed
+		 * a newline, flush and append the newline.
 		 */
-		if (cont.len && cont.owner == current) {
-			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
-			cont_flush(LOG_NEWLINE);
-		/* Flush conflicting buffer. An earlier newline was missing
-		* and current print is from different task */
-		} else if (cont.len && cont.owner != current)
+		if (cont.len) {
+			if (cont.owner == current && !(lflags & LOG_PREFIX))
+				stored = cont_add(facility, level, text,
+						  text_len);
 			cont_flush(LOG_NEWLINE);
+		}
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
numa-add-a-sysctl-for-numa_balancing.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-improve-documentation-of-page_order-v2.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

