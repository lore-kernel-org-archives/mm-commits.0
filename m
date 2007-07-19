From: akpm@linux-foundation.org
Subject: - move-page-writeback-acounting-out-of-macros.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:33 -0700
Message-ID: <200707192004.l6JK4XwI019961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760940AbXGSUPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     move page writeback acounting out of macros
has been removed from the -mm tree.  Its filename was
     move-page-writeback-acounting-out-of-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: move page writeback acounting out of macros
From: Andrew Morton <akpm@osdl.org>

page-writeback accounting is presently performed in the page-flags macros. 
This is inconsistent and a bit ugly and makes it awkward to implement
per-backing_dev under-writeback page accounting.

So move this accounting down to the callsite(s).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   38 +++++++----------------------------
 mm/page-writeback.c        |    4 +++
 2 files changed, 12 insertions(+), 30 deletions(-)

diff -puN include/linux/page-flags.h~move-page-writeback-acounting-out-of-macros include/linux/page-flags.h
--- a/include/linux/page-flags.h~move-page-writeback-acounting-out-of-macros
+++ a/include/linux/page-flags.h
@@ -189,37 +189,15 @@ static inline void SetPageUptodate(struc
 #define __SetPagePrivate(page)  __set_bit(PG_private, &(page)->flags)
 #define __ClearPagePrivate(page) __clear_bit(PG_private, &(page)->flags)
 
+/*
+ * Only test-and-set exist for PG_writeback.  The unconditional operators are
+ * risky: they bypass page accounting.
+ */
 #define PageWriteback(page)	test_bit(PG_writeback, &(page)->flags)
-#define SetPageWriteback(page)						\
-	do {								\
-		if (!test_and_set_bit(PG_writeback,			\
-				&(page)->flags))			\
-			inc_zone_page_state(page, NR_WRITEBACK);	\
-	} while (0)
-#define TestSetPageWriteback(page)					\
-	({								\
-		int ret;						\
-		ret = test_and_set_bit(PG_writeback,			\
-					&(page)->flags);		\
-		if (!ret)						\
-			inc_zone_page_state(page, NR_WRITEBACK);	\
-		ret;							\
-	})
-#define ClearPageWriteback(page)					\
-	do {								\
-		if (test_and_clear_bit(PG_writeback,			\
-				&(page)->flags))			\
-			dec_zone_page_state(page, NR_WRITEBACK);	\
-	} while (0)
-#define TestClearPageWriteback(page)					\
-	({								\
-		int ret;						\
-		ret = test_and_clear_bit(PG_writeback,			\
-				&(page)->flags);			\
-		if (ret)						\
-			dec_zone_page_state(page, NR_WRITEBACK);	\
-		ret;							\
-	})
+#define TestSetPageWriteback(page) test_and_set_bit(PG_writeback,	\
+							&(page)->flags)
+#define TestClearPageWriteback(page) test_and_clear_bit(PG_writeback,	\
+							&(page)->flags)
 
 #define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
 #define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
diff -puN mm/page-writeback.c~move-page-writeback-acounting-out-of-macros mm/page-writeback.c
--- a/mm/page-writeback.c~move-page-writeback-acounting-out-of-macros
+++ a/mm/page-writeback.c
@@ -987,6 +987,8 @@ int test_clear_page_writeback(struct pag
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
+	if (ret)
+		dec_zone_page_state(page, NR_WRITEBACK);
 	return ret;
 }
 
@@ -1012,6 +1014,8 @@ int test_set_page_writeback(struct page 
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
+	if (!ret)
+		inc_zone_page_state(page, NR_WRITEBACK);
 	return ret;
 
 }
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
