From: akpm@linux-foundation.org
Subject: + mm-add-account_page_writeback.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:51 -0700
Message-ID: <201009132248.o8DMmpHC025726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0IMWtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrubin@google.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, jir@unicus.jp, konishi.ryusuke@lab.ntt.co.jp, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     mm: add account_page_writeback()
has been added to the -mm tree.  Its filename is
     mm-add-account_page_writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add account_page_writeback()
From: Michael Rubin <mrubin@google.com>

This allows code outside of the mm core to safely manipulate page
writeback state and not worry about the other accounting.  Not using these
routines means that some code will lose track of the accounting and we get
bugs.

Modify nilfs2 to use interface.

Signed-off-by: Michael Rubin <mrubin@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: Jiro SEKIBA <jir@unicus.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    2 +-
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   13 ++++++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/segment.c~mm-add-account_page_writeback fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~mm-add-account_page_writeback
+++ a/fs/nilfs2/segment.c
@@ -1607,7 +1607,7 @@ nilfs_copy_replace_page_buffers(struct p
 	kunmap_atomic(kaddr, KM_USER0);
 
 	if (!TestSetPageWriteback(clone_page))
-		inc_zone_page_state(clone_page, NR_WRITEBACK);
+		account_page_writeback(clone_page);
 	unlock_page(clone_page);
 
 	return 0;
diff -puN include/linux/mm.h~mm-add-account_page_writeback include/linux/mm.h
--- a/include/linux/mm.h~mm-add-account_page_writeback
+++ a/include/linux/mm.h
@@ -860,6 +860,7 @@ int __set_page_dirty_no_writeback(struct
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
+void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff -puN mm/page-writeback.c~mm-add-account_page_writeback mm/page-writeback.c
--- a/mm/page-writeback.c~mm-add-account_page_writeback
+++ a/mm/page-writeback.c
@@ -1130,6 +1130,17 @@ void account_page_dirtied(struct page *p
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
+ * Helper function for set_page_writeback family.
+ * NOTE: Unlike account_page_dirtied this does not rely on being atomic
+ * wrt interrupts.
+ */
+void account_page_writeback(struct page *page)
+{
+	inc_zone_page_state(page, NR_WRITEBACK);
+}
+EXPORT_SYMBOL(account_page_writeback);
+
+/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
@@ -1367,7 +1378,7 @@ int test_set_page_writeback(struct page 
 		ret = TestSetPageWriteback(page);
 	}
 	if (!ret)
-		inc_zone_page_state(page, NR_WRITEBACK);
+		account_page_writeback(page);
 	return ret;
 
 }
_

Patches currently in -mm which might be from mrubin@google.com are

vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-export-account_page_dirty.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch

