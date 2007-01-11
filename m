From: akpm@osdl.org
Subject: + fsaio-filesystem-aio-read.patch added to -mm tree
Date: Wed, 10 Jan 2007 23:21:28 -0800
Message-ID: <200701110721.l0B7LSZB019305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965318AbXAKHWH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suparna@in.ibm.com, mingo@elte.hu


The patch titled
     fsaio: filesystem aio read
has been added to the -mm tree.  Its filename is
     fsaio-filesystem-aio-read.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fsaio: filesystem aio read
From: Suparna Bhattacharya <suparna@in.ibm.com>

Converts the wait for page to become uptodate (lock page)
after readahead/readpage (in do_generic_mapping_read) to a retry
exit, to make buffered filesystem AIO reads actually synchronous.

The patch avoids exclusive wakeups with AIO, a problem originally
spotted by Chris Mason, though the reasoning for why it is an
issue is now much clearer (see explanation in the comment below
in aio.c), and the solution is perhaps slightly simpler.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c              |   11 ++++++++++-
 include/linux/aio.h   |    5 +++++
 include/linux/sched.h |   10 ++++++++++
 mm/filemap.c          |   18 +++++++++++++++---
 4 files changed, 40 insertions(+), 4 deletions(-)

diff -puN fs/aio.c~fsaio-filesystem-aio-read fs/aio.c
--- a/fs/aio.c~fsaio-filesystem-aio-read
+++ a/fs/aio.c
@@ -1525,7 +1525,16 @@ static int aio_wake_function(wait_queue_
 
 	list_del_init(&wait->task_list);
 	kick_iocb(iocb);
-	return 1;
+	/*
+	 * Avoid exclusive wakeups with retries since an exclusive wakeup
+	 * may involve implicit expectations of waking up the next waiter
+	 * and there is no guarantee that the retry will take a path that
+	 * would do so. For example if a page has become up-to-date, then
+	 * a retried read may end up straightaway performing a copyout
+	 * and not go through a lock_page - unlock_page that would have
+	 * passed the baton to the next waiter.
+	 */
+	return 0;
 }
 
 int fastcall io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
diff -puN include/linux/aio.h~fsaio-filesystem-aio-read include/linux/aio.h
--- a/include/linux/aio.h~fsaio-filesystem-aio-read
+++ a/include/linux/aio.h
@@ -34,21 +34,26 @@ struct kioctx;
 /* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
+#define KIF_RESTARTED		3
 
 #define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
+#define kiocbTryRestart(iocb)	test_and_set_bit(KIF_RESTARTED, &(iocb)->ki_flags)
 
 #define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbSetRestarted(iocb)	set_bit(KIF_RESTARTED, &(iocb)->ki_flags)
 
 #define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbClearRestarted(iocb)	clear_bit(KIF_RESTARTED, &(iocb)->ki_flags)
 
 #define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
+#define kiocbIsRestarted(iocb)	test_bit(KIF_RESTARTED, &(iocb)->ki_flags)
 
 /* is there a better place to document function pointer methods? */
 /**
diff -puN include/linux/sched.h~fsaio-filesystem-aio-read include/linux/sched.h
--- a/include/linux/sched.h~fsaio-filesystem-aio-read
+++ a/include/linux/sched.h
@@ -1281,6 +1281,16 @@ extern void switch_uid(struct user_struc
 
 #include <asm/current.h>
 
+/* Are we in the context of a restarted AIO ? */
+static inline int aio_restarted(void)
+{
+	wait_queue_t *wait = current->io_wait;
+
+	if (!is_sync_wait(wait) && kiocbTryRestart(io_wait_to_kiocb(wait)))
+		return 1;
+	return 0;
+}
+
 extern void do_timer(unsigned long ticks);
 
 extern int FASTCALL(wake_up_state(struct task_struct * tsk, unsigned int state));
diff -puN mm/filemap.c~fsaio-filesystem-aio-read mm/filemap.c
--- a/mm/filemap.c~fsaio-filesystem-aio-read
+++ a/mm/filemap.c
@@ -866,6 +866,9 @@ void do_generic_mapping_read(struct addr
 	if (!isize)
 		goto out;
 
+	if (unlikely(aio_restarted()))
+		next_index = last_index; /* Avoid repeat readahead */
+
 	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
 	for (;;) {
 		struct page *page;
@@ -935,7 +938,10 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		lock_page(page);
+
+		error = lock_page_async(page, current->io_wait);
+		if (error)
+			goto readpage_error;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -963,7 +969,9 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			lock_page(page);
+			error = lock_page_async(page, current->io_wait);
+			if (error)
+				goto readpage_error;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1009,7 +1017,11 @@ readpage:
 		goto page_ok;
 
 readpage_error:
-		/* UHHUH! A synchronous read error occurred. Report it */
+		/* We don't have uptodate data in the page yet */
+		/* Could be due to an error or because we need to
+		 * retry when we get an async i/o notification.
+		 * Report the reason.
+		 */
 		desc->error = error;
 		page_cache_release(page);
 		goto out;
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
