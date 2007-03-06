From: akpm@linux-foundation.org
Subject: - per-backing_dev-dirty-and-writeback-page-accounting-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:13:33 -0800
Message-ID: <200703060113.l261DY7v007307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44394 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933748AbXCFBNv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomoki.sekiyama.qu@hitachi.com, mm-commits@vger.kernel.org


The patch titled
     mm: Fix dirty page accounting per backing_dev
has been removed from the -mm tree.  Its filename was
     per-backing_dev-dirty-and-writeback-page-accounting-fix.patch

This patch was dropped because it was folded into per-backing_dev-dirty-and-writeback-page-accounting.patch

------------------------------------------------------
Subject: mm: Fix dirty page accounting per backing_dev
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>

I found a suspicious bug of I/O accounting in 2.6.20-rc6-mm3.  The number
of dirty pages per backing_dev available from
/sys/block/<dev>/queue/nr_dirty keeps growing when a file is rapidly
overwritten several times.

For example:
% cat /sys/block/sda/queue/nr_dirty
104
% for i in 1 2; do dd if=/dev/zero of=dummy bs=4096 count=1; done; sync
% cat /sys/block/sda/queue/nr_dirty
105
% for i in 1 2 3; do dd if=/dev/zero of=dummy bs=4096 count=1; done; sync
% cat /sys/block/sda/queue/nr_dirty
107

This patch fixes it.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN mm/truncate.c~per-backing_dev-dirty-and-writeback-page-accounting-fix mm/truncate.c
--- a/mm/truncate.c~per-backing_dev-dirty-and-writeback-page-accounting-fix
+++ a/mm/truncate.c
@@ -70,6 +70,7 @@ void cancel_dirty_page(struct page *page
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
+			atomic_long_dec(&mapping->backing_dev_info->nr_dirty);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
_

Patches currently in -mm which might be from tomoki.sekiyama.qu@hitachi.com are

per-backing_dev-dirty-and-writeback-page-accounting.patch
per-backing_dev-dirty-and-writeback-page-accounting-fix.patch
