From: akpm@linux-foundation.org
Subject: [folded] atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:22:53 -0800
Message-ID: <201101132322.p0DNMrGC006752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887Ab1AMXXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arkadiusz.bubala@gmail.com, claudio@evidence.eu.com, greg@kroah.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch

This patch was dropped because it was folded into atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix
From: Andrew Morton <akpm@linux-foundation.org>

simplify code

Cc: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>
Cc: Greg KH <greg@kroah.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix
+++ a/drivers/serial/atmel_serial.c
@@ -1733,12 +1733,8 @@ static int __devinit atmel_serial_probe(
 	platform_set_drvdata(pdev, port);
 
 	if (port->rs485.flags & SER_RS485_ENABLED) {
-		unsigned int control = 0;
-		unsigned int mode = 0;
-		control |= ATMEL_US_RTSEN;
-		mode |= ATMEL_US_USMODE_NORMAL;
-		UART_PUT_MR(&port->uart, mode);
-		UART_PUT_CR(&port->uart, control);
+		UART_PUT_MR(&port->uart, ATMEL_US_USMODE_NORMAL);
+		UART_PUT_CR(&port->uart, ATMEL_US_RTSEN);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

