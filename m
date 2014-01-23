From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch removed from
 -mm tree
Date: Thu, 23 Jan 2014 12:42:44 -0800
Message-ID: <52e17ec4.KOGlHn4e3SN5Mv6g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaAWUmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, scameron@beardog.cce.hp.com, axboe@kernel.dk, akpm@linux-foundation.org

Subject: [merged] drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch removed from -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,scameron@beardog.cce.hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:42:44 -0800


The patch titled
     Subject: drivers/block/cciss.c:cciss_init_one(): use proper errnos
has been removed from the -mm tree.  Its filename was
     drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/cciss.c:cciss_init_one(): use proper errnos

pci_driver.probe should return a meaningful errno, not -1.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-cciss_init_one-use-proper-errnos
+++ a/drivers/block/cciss.c
@@ -5004,7 +5004,7 @@ reinit_after_soft_reset:
 
 	i = alloc_cciss_hba(pdev);
 	if (i < 0)
-		return -1;
+		return -ENOMEM;
 
 	h = hba[i];
 	h->pdev = pdev;
@@ -5205,7 +5205,7 @@ clean_no_release_regions:
 	 */
 	pci_set_drvdata(pdev, NULL);
 	free_hba(h);
-	return -1;
+	return -ENODEV;
 }
 
 static void cciss_shutdown(struct pci_dev *pdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

