From: akpm@linux-foundation.org
Subject: - memstick-use-fully-asynchronous-request-processing-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:47:09 -0700
Message-ID: <200807252347.m6PNl9xm005804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYGYXrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick-use-fully-asynchronous-request-processing-fix
has been removed from the -mm tree.  Its filename was
     memstick-use-fully-asynchronous-request-processing-fix.patch

This patch was dropped because it was folded into memstick-use-fully-asynchronous-request-processing.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick-use-fully-asynchronous-request-processing-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/memstick/core/mspro_block.c: In function 'mspro_block_complete_req':
drivers/memstick/core/mspro_block.c:727: warning: comparison of distinct pointer types lacks a cast
drivers/memstick/core/mspro_block.c:771: warning: comparison of distinct pointer types lacks a cast

Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-use-fully-asynchronous-request-processing-fix drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-use-fully-asynchronous-request-processing-fix
+++ a/drivers/memstick/core/mspro_block.c
@@ -722,7 +722,7 @@ static int mspro_block_complete_req(stru
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	int chunk, cnt;
 	unsigned int t_len = 0;
-	unsigned int flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&msb->q_lock, flags);
 	dev_dbg(&card->dev, "complete %d, %d\n", msb->has_request ? 1 : 0,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch
memstick-allow-set_param-method-to-return-an-error-code.patch
memstick-use-fully-asynchronous-request-processing.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

