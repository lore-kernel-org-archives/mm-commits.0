From: akpm@osdl.org
Subject: - fsaio-enable-asynchronous-wait-page-and-lock-page.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:16:37 -0800
Message-ID: <200701032216.l03MGbpX000607@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbXACWR0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:17:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suparna@in.ibm.com, bcrl@kvack.org, drepper@redhat.com, hch@lst.de, mingo@elte.hu, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fsaio: enable asynchronous wait page and lock page
has been removed from the -mm tree.  Its filename was
     fsaio-enable-asynchronous-wait-page-and-lock-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fsaio: enable asynchronous wait page and lock page
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
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pagemap.h |   38 ++++++++++++++++++++++++++++++--------
 include/linux/sched.h   |    1 +
 kernel/sched.c          |   13 +++++++++++++
 mm/filemap.c            |    2 +-
 4 files changed, 45 insertions(+), 9 deletions(-)

diff -puN include/linux/pagemap.h~fsaio-enable-asynchronous-wait-page-and-lock-page include/linux/pagemap.h
--- a/include/linux/pagemap.h~fsaio-enable-asynchronous-wait-page-and-lock-page
+++ a/include/linux/pagemap.h
@@ -144,24 +144,37 @@ static inline pgoff_t linear_page_index(
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
-extern void FASTCALL(lock_page_blocking(struct page *page));
+extern int FASTCALL(__lock_page_blocking(struct page *page,
+					wait_queue_t *wait));
 extern void FASTCALL(unlock_page(struct page *page));
 
 /*
  * lock_page may only be called if we have the page's inode pinned.
  */
-static inline void lock_page(struct page *page)
+static inline int __lock_page(struct page *page, wait_queue_t *wait)
 {
 	might_sleep();
 	if (TestSetPageLocked(page))
-		lock_page_blocking(page);
+		return __lock_page_blocking(page, wait);
+	return 0;
+}
+
+static inline int lock_page(struct page *page)
+{
+	return __lock_page(page, &current->__wait.wait);
+}
+
+static inline int lock_page_blocking(struct page *page)
+{
+	return __lock_page_blocking(page, &current->__wait.wait);
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
@@ -170,21 +183,30 @@ extern void FASTCALL(wait_on_page_bit(st
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
 }
 
+#define wait_on_page_locked(page) \
+	__wait_on_page_locked(page, &current->__wait.wait)
+
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
 }
 
+#define wait_on_page_writeback(page) \
+	__wait_on_page_writeback(page, &current->__wait.wait)
+
 extern void end_page_writeback(struct page *page);
 
 /*
diff -puN include/linux/sched.h~fsaio-enable-asynchronous-wait-page-and-lock-page include/linux/sched.h
--- a/include/linux/sched.h~fsaio-enable-asynchronous-wait-page-and-lock-page
+++ a/include/linux/sched.h
@@ -216,6 +216,7 @@ extern void show_stack(struct task_struc
 
 void io_schedule(void);
 long io_schedule_timeout(long timeout);
+int io_wait_schedule(wait_queue_t *wait);
 
 extern void cpu_init (void);
 extern void trap_init(void);
diff -puN kernel/sched.c~fsaio-enable-asynchronous-wait-page-and-lock-page kernel/sched.c
--- a/kernel/sched.c~fsaio-enable-asynchronous-wait-page-and-lock-page
+++ a/kernel/sched.c
@@ -4754,6 +4754,19 @@ long __sched io_schedule_timeout(long ti
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
+EXPORT_SYMBOL(io_wait_schedule);
+
 /**
  * sys_sched_get_priority_max - return maximum RT priority.
  * @policy: scheduling class.
diff -puN mm/filemap.c~fsaio-enable-asynchronous-wait-page-and-lock-page mm/filemap.c
--- a/mm/filemap.c~fsaio-enable-asynchronous-wait-page-and-lock-page
+++ a/mm/filemap.c
@@ -520,7 +520,7 @@ void end_page_writeback(struct page *pag
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * lock_page_blocking - get a lock on the page, assuming we need to sleep to get it
+ * __lock_page_blocking: get a lock on the page, assuming we need to wait to get it
  * @page: the page to lock
  */
 void fastcall lock_page_blocking(struct page *page)
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-filesystem-aio-read-tidy.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
