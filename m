From: akpm@osdl.org
Subject: + truncate-dirty-memory-accounting-fix.patch added to -mm tree
Date: Thu, 21 Dec 2006 23:46:23 -0800
Message-ID: <200612220746.kBM7kNSU017239@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945957AbWLVHq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 02:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, davem@davemloft.net, torvalds@osdl.org


The patch titled
     truncate: dirty memory accounting fix
has been added to the -mm tree.  Its filename is
     truncate-dirty-memory-accounting-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: truncate: dirty memory accounting fix
From: Andrew Morton <akpm@osdl.org>

Only (un)account for IO and page-dirtying for devices which have real backing
store (ie: not tmpfs or ramdisks).

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/truncate.c~truncate-dirty-memory-accounting-fix mm/truncate.c
--- a/mm/truncate.c~truncate-dirty-memory-accounting-fix
+++ a/mm/truncate.c
@@ -60,7 +60,8 @@ void cancel_dirty_page(struct page *page
 		WARN_ON(++warncount < 5);
 	}
 		
-	if (TestClearPageDirty(page) && account_size) {
+	if (TestClearPageDirty(page) && account_size &&
+			mapping_cap_account_dirty(page->mapping)) {
 		dec_zone_page_state(page, NR_FILE_DIRTY);
 		task_io_account_cancelled_write(account_size);
 	}
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch
truncate-dirty-memory-accounting-fix.patch

