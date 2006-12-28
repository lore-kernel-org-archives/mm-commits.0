From: akpm@osdl.org
Subject: + fsaio-rename-__lock_page-to-lock_page_slow.patch added to -mm tree
Date: Thu, 28 Dec 2006 14:53:52 -0800
Message-ID: <200612282253.kBSMrqR8015354@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042AbWL1Wyx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 17:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suparna@in.ibm.com, bcrl@kvack.org, drepper@redhat.com, hch@lst.de, mingo@elte.hu, zach.brown@oracle.com


The patch titled
     fsaio: rename __lock_page to lock_page_blocking
has been added to the -mm tree.  Its filename is
     fsaio-rename-__lock_page-to-lock_page_slow.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fsaio: rename __lock_page to lock_page_blocking
From: Suparna Bhattacharya <suparna@in.ibm.com>

In order to allow for interruptible and asynchronous versions of lock_page in
conjunction with the wait_on_bit changes, we need to define low-level lock
page routines which take an additional argument, i.e a wait queue entry and
may return non-zero status, e.g -EINTR, -EIOCBRETRY, -EWOULDBLOCK etc.  This
patch renames __lock_page to lock_page_blocking, so that __lock_page and
__lock_page_blocking can denote the versions which take a wait queue parameter.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pagemap.h |    4 ++--
 mm/filemap.c            |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/pagemap.h~fsaio-rename-__lock_page-to-lock_page_slow include/linux/pagemap.h
--- a/include/linux/pagemap.h~fsaio-rename-__lock_page-to-lock_page_slow
+++ a/include/linux/pagemap.h
@@ -133,7 +133,7 @@ static inline pgoff_t linear_page_index(
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
-extern void FASTCALL(__lock_page(struct page *page));
+extern void FASTCALL(lock_page_blocking(struct page *page));
 extern void FASTCALL(__lock_page_nosync(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
@@ -144,7 +144,7 @@ static inline void lock_page(struct page
 {
 	might_sleep();
 	if (TestSetPageLocked(page))
-		__lock_page(page);
+		lock_page_blocking(page);
 }
 
 /*
diff -puN mm/filemap.c~fsaio-rename-__lock_page-to-lock_page_slow mm/filemap.c
--- a/mm/filemap.c~fsaio-rename-__lock_page-to-lock_page_slow
+++ a/mm/filemap.c
@@ -556,7 +556,7 @@ void end_page_writeback(struct page *pag
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * __lock_page - get a lock on the page, assuming we need to sleep to get it
+ * lock_page_blocking - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
  *
  * Ugly. Running sync_page() in state TASK_UNINTERRUPTIBLE is scary.  If some
@@ -564,14 +564,14 @@ EXPORT_SYMBOL(end_page_writeback);
  * chances are that on the second loop, the block layer's plug list is empty,
  * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
  */
-void fastcall __lock_page(struct page *page)
+void fastcall lock_page_blocking(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
 	__wait_on_bit_lock(page_waitqueue(page), &wait, sync_page,
 							TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(__lock_page);
+EXPORT_SYMBOL(lock_page_blocking);
 
 /*
  * Variant of lock_page that does not require the caller to hold a reference
@@ -647,7 +647,7 @@ repeat:
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
-			__lock_page(page);
+			lock_page_blocking(page);
 			read_lock_irq(&mapping->tree_lock);
 
 			/* Has the page been truncated while we slept? */
_

Patches currently in -mm which might be from suparna@in.ibm.com are

fix-lock-inversion-aio_kick_handler.patch
fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_slow.patch
fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch

