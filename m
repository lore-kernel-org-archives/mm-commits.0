From: akpm@linux-foundation.org
Subject: - fsaio-rename-__lock_page-to-lock_page_blocking.patch removed from -mm tree
Date: Wed, 09 May 2007 03:04:34 -0700
Message-ID: <200705091004.l49A4YrM020759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbXEIKE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fsaio: rename __lock_page to lock_page_blocking
has been removed from the -mm tree.  Its filename was
     fsaio-rename-__lock_page-to-lock_page_blocking.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fsaio: rename __lock_page to lock_page_blocking
From: Suparna Bhattacharya <suparna@in.ibm.com>

In order to allow for interruptible and asynchronous versions of lock_page in
conjunction with the wait_on_bit changes, we need to define low-level lock
page routines which take an additional argument, i.e a wait queue entry and
may return non-zero status, e.g -EINTR, -EIOCBRETRY, -EWOULDBLOCK etc.  This
patch renames __lock_page to lock_page_blocking, so that it can be later
modified to denote a version which takes a wait queue parameter.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 ++--
 mm/filemap.c            |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/pagemap.h~fsaio-rename-__lock_page-to-lock_page_blocking include/linux/pagemap.h
--- a/include/linux/pagemap.h~fsaio-rename-__lock_page-to-lock_page_blocking
+++ a/include/linux/pagemap.h
@@ -153,7 +153,7 @@ static inline pgoff_t linear_page_index(
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
-extern void FASTCALL(__lock_page(struct page *page));
+extern void FASTCALL(lock_page_blocking(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
 /*
@@ -163,7 +163,7 @@ static inline void lock_page(struct page
 {
 	might_sleep();
 	if (TestSetPageLocked(page))
-		__lock_page(page);
+		lock_page_blocking(page);
 }
 
 /*
diff -puN mm/filemap.c~fsaio-rename-__lock_page-to-lock_page_blocking mm/filemap.c
--- a/mm/filemap.c~fsaio-rename-__lock_page-to-lock_page_blocking
+++ a/mm/filemap.c
@@ -520,17 +520,17 @@ void end_page_writeback(struct page *pag
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * __lock_page - get a lock on the page, assuming we need to sleep to get it
+ * lock_page_blocking - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
  */
-void fastcall __lock_page(struct page *page)
+void fastcall lock_page_blocking(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
 	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
-EXPORT_SYMBOL(__lock_page);
+EXPORT_SYMBOL(lock_page_blocking);
 
 /**
  * find_get_page - find and get a page reference
@@ -575,7 +575,7 @@ repeat:
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
-			__lock_page(page);
+			lock_page_blocking(page);
 			read_lock_irq(&mapping->tree_lock);
 
 			/* Has the page been truncated while we slept? */
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-is-unlikely.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
