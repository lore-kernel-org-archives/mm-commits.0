From: akpm@linux-foundation.org
Subject: [merged] mm-un-export-wake_up_page-functions.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:15:48 -0800
Message-ID: <58af5104.U9ZMs/1NVho5uxDb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVPt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, anna.schumaker@netapp.com, trond.myklebust@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: un-export wake_up_page functions
has been removed from the -mm tree.  Its filename was
     mm-un-export-wake_up_page-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: mm: un-export wake_up_page functions

These are no longer used outside mm/filemap.c, so un-export them and make
them static where possible.  These were exported specifically for NFS use
in commit a4796e37c12e ("MM: export page_wakeup functions").

Link: http://lkml.kernel.org/r/20170103182234.30141-3-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++----------
 mm/filemap.c            |   10 ++++++++--
 2 files changed, 10 insertions(+), 12 deletions(-)

diff -puN include/linux/pagemap.h~mm-un-export-wake_up_page-functions include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-un-export-wake_up_page-functions
+++ a/include/linux/pagemap.h
@@ -482,19 +482,11 @@ static inline int lock_page_or_retry(str
 }
 
 /*
- * This is exported only for wait_on_page_locked/wait_on_page_writeback,
- * and for filesystems which need to wait on PG_private.
+ * This is exported only for wait_on_page_locked/wait_on_page_writeback, etc.,
+ * and should not be used directly.
  */
 extern void wait_on_page_bit(struct page *page, int bit_nr);
 extern int wait_on_page_bit_killable(struct page *page, int bit_nr);
-extern void wake_up_page_bit(struct page *page, int bit_nr);
-
-static inline void wake_up_page(struct page *page, int bit)
-{
-	if (!PageWaiters(page))
-		return;
-	wake_up_page_bit(page, bit);
-}
 
 /* 
  * Wait for a page to be unlocked.
diff -puN mm/filemap.c~mm-un-export-wake_up_page-functions mm/filemap.c
--- a/mm/filemap.c~mm-un-export-wake_up_page-functions
+++ a/mm/filemap.c
@@ -788,7 +788,7 @@ static int wake_page_function(wait_queue
 	return autoremove_wake_function(wait, mode, sync, key);
 }
 
-void wake_up_page_bit(struct page *page, int bit_nr)
+static void wake_up_page_bit(struct page *page, int bit_nr)
 {
 	wait_queue_head_t *q = page_waitqueue(page);
 	struct wait_page_key key;
@@ -821,7 +821,13 @@ void wake_up_page_bit(struct page *page,
 	}
 	spin_unlock_irqrestore(&q->lock, flags);
 }
-EXPORT_SYMBOL(wake_up_page_bit);
+
+static void wake_up_page(struct page *page, int bit)
+{
+	if (!PageWaiters(page))
+		return;
+	wake_up_page_bit(page, bit);
+}
 
 static inline int wait_on_page_bit_common(wait_queue_head_t *q,
 		struct page *page, int bit_nr, int state, bool lock)
_

Patches currently in -mm which might be from npiggin@gmail.com are


