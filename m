From: akpm@osdl.org
Subject: - fsaio-aio-wait-page.patch removed from -mm tree
Date: Wed, 10 Jan 2007 23:22:09 -0800
Message-ID: <200701110722.l0B7M9RX019323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38316 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965329AbXAKHXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fsaio: aio wait page
has been removed from the -mm tree.  Its filename was
     fsaio-aio-wait-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fsaio: aio wait page
From: Suparna Bhattacharya <suparna@in.ibm.com>

Define low-level page wait and lock page routines which take a wait queue
entry pointer as an additional parameter and return status (which may be
non-zero when the wait queue parameter signifies an asynchronous wait,
typically during AIO).

Synchronous IO waits become a special case where the wait queue parameter is
the running task's default io wait context.  Asynchronous IO waits happen when
the wait queue parameter is the io wait context of a kiocb.  Code paths which
choose to execute synchronous or asynchronous behaviour depending on the
called context specify the current io wait context (which points to sync or
async context as the case may be) as the wait parameter.  

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pagemap.h |   36 ++++++++++++++++++++++++++++--------
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   14 ++++++++++++++
 mm/filemap.c            |   36 ++++++++++++++++++++++++------------
 4 files changed, 67 insertions(+), 20 deletions(-)

diff -puN include/linux/pagemap.h~fsaio-aio-wait-page include/linux/pagemap.h
--- a/include/linux/pagemap.h~fsaio-aio-wait-page
+++ a/include/linux/pagemap.h
@@ -144,24 +144,31 @@ static inline pgoff_t linear_page_index(
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
-extern void FASTCALL(lock_page_blocking(struct page *page));
+extern int FASTCALL(lock_page_blocking(struct page *page, wait_queue_t *wait));
 extern void FASTCALL(unlock_page(struct page *page));
 
 /*
  * lock_page may only be called if we have the page's inode pinned.
  */
-static inline void lock_page(struct page *page)
+static inline int lock_page_async(struct page *page, wait_queue_t *wait)
 {
 	might_sleep();
 	if (TestSetPageLocked(page))
-		lock_page_blocking(page);
+		return lock_page_blocking(page, wait);
+	return 0;
+}
+
+static inline void lock_page(struct page *page)
+{
+	lock_page_async(page, &current->__wait.wait);
 }
 
 /*
  * This is exported only for wait_on_page_locked/wait_on_page_writeback.
  * Never use this directly!
  */
-extern void FASTCALL(wait_on_page_bit(struct page *page, int bit_nr));
+extern int FASTCALL(wait_on_page_bit(struct page *page, int bit_nr,
+			wait_queue_t *wait));
 
 /* 
  * Wait for a page to be unlocked.
@@ -170,19 +177,32 @@ extern void FASTCALL(wait_on_page_bit(st
  * ie with increased "page->count" so that the page won't
  * go away during the wait..
  */
-static inline void wait_on_page_locked(struct page *page)
+static inline int __wait_on_page_locked(struct page *page, wait_queue_t *wait)
 {
 	if (PageLocked(page))
-		wait_on_page_bit(page, PG_locked);
+		return wait_on_page_bit(page, PG_locked, wait);
+	return 0;
+}
+
+static inline void wait_on_page_locked(struct page *page)
+{
+	__wait_on_page_locked(page, &current->__wait.wait);
 }
 
 /* 
  * Wait for a page to complete writeback
  */
-static inline void wait_on_page_writeback(struct page *page)
+static inline int __wait_on_page_writeback(struct page *page,
+					wait_queue_t *wait)
 {
 	if (PageWriteback(page))
-		wait_on_page_bit(page, PG_writeback);
+		return wait_on_page_bit(page, PG_writeback, wait);
+	return 0;
+}
+
+static inline void wait_on_page_writeback(struct page *page)
+{
+	__wait_on_page_writeback(page, &current->__wait.wait);
 }
 
 extern void end_page_writeback(struct page *page);
diff -puN include/linux/sched.h~fsaio-aio-wait-page include/linux/sched.h
--- a/include/linux/sched.h~fsaio-aio-wait-page
+++ a/include/linux/sched.h
@@ -216,6 +216,7 @@ extern void show_stack(struct task_struc
 
 void io_schedule(void);
 long io_schedule_timeout(long timeout);
+int io_wait_schedule(wait_queue_t *wait);
 
 extern void cpu_init (void);
 extern void trap_init(void);
diff -puN kernel/sched.c~fsaio-aio-wait-page kernel/sched.c
--- a/kernel/sched.c~fsaio-aio-wait-page
+++ a/kernel/sched.c
@@ -4754,6 +4754,20 @@ long __sched io_schedule_timeout(long ti
 	return ret;
 }
 
+/*
+ * Sleep only if the wait context passed is not async,
+ * otherwise return so that a retry can be issued later.
+ */
+int __sched io_wait_schedule(wait_queue_t *wait)
+{
+	if (!is_sync_wait(wait))
+		return -EIOCBRETRY;
+	io_schedule();
+	return 0;
+}
+
+EXPORT_SYMBOL(io_wait_schedule);
+
 /**
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
diff -puN mm/filemap.c~fsaio-aio-wait-page mm/filemap.c
--- a/mm/filemap.c~fsaio-aio-wait-page
+++ a/mm/filemap.c
@@ -135,8 +135,7 @@ void remove_from_page_cache(struct page 
 
 static int sleep_on_page(void *word, wait_queue_t *wait)
 {
-	io_schedule();
-	return 0;
+	return io_wait_schedule(wait);
 }
 
 /**
@@ -470,13 +469,17 @@ static inline void wake_up_page(struct p
 	__wake_up_bit(page_waitqueue(page), &page->flags, bit);
 }
 
-void fastcall wait_on_page_bit(struct page *page, int bit_nr)
+int fastcall wait_on_page_bit(struct page *page, int bit_nr,
+					wait_queue_t *wait)
 {
-	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
-
-	if (test_bit(bit_nr, &page->flags))
-		__wait_on_bit(page_waitqueue(page), &wait, sleep_on_page,
+	if (test_bit(bit_nr, &page->flags)) {
+		struct wait_bit_queue *wait_bit
+			= container_of(wait, struct wait_bit_queue, wait);
+		init_wait_bit_key(wait_bit, &page->flags, bit_nr);
+		return __wait_on_bit(page_waitqueue(page), wait_bit, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
+	}
+	return 0;
 }
 EXPORT_SYMBOL(wait_on_page_bit);
 
@@ -520,14 +523,23 @@ void end_page_writeback(struct page *pag
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * lock_page_blocking - get a lock on the page, assuming we need to sleep to get it
+ * lock_page_blocking: get a lock on the page, assuming we need to wait to get it
  * @page: the page to lock
+ * @wait: wait queue entry to notify when lock is available; if this is a
+ * synchronous wait queue entry then the routine blocks until the lock is
+ * obtained.
+ * The wait queue entry is expected to be embedded in a wait bit structure.
+ *
+ * Returns 0 if the lock has been acquired, -EIOCBRETRY if an async wakeup
+ * has been queued for activation when the lock will be available.
  */
-void fastcall lock_page_blocking(struct page *page)
+int fastcall lock_page_blocking(struct page *page, wait_queue_t *wait)
 {
-	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
+	struct wait_bit_queue *wait_bit
+		= container_of(wait, struct wait_bit_queue, wait);
 
-	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
+	init_wait_bit_key(wait_bit, &page->flags, PG_locked);
+	return __wait_on_bit_lock(page_waitqueue(page), wait_bit, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(lock_page_blocking);
@@ -595,7 +607,7 @@ repeat:
 		page_cache_get(page);
 		if (TestSetPageLocked(page)) {
 			read_unlock_irq(&mapping->tree_lock);
-			lock_page_blocking(page);
+			lock_page_blocking(page, &current->__wait.wait);
 			read_lock_irq(&mapping->tree_lock);
 
 			/* Has the page been truncated while we slept? */
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
