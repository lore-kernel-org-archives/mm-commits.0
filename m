From: akpm@linux-foundation.org
Subject: - add-lock_page_killable.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:15 -0800
Message-ID: <200802012230.m11MUFIf001891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310AbYBAWsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, bfields@fieldses.org, nickpiggin@yahoo.com.au, trond.myklebust@fys.uio.no, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Add lock_page_killable()
has been removed from the -mm tree.  Its filename was
     add-lock_page_killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add lock_page_killable()
From: Matthew Wilcox <matthew@wil.cx>

Add associated infrastructure such as sync_page_killable and
fatal_signal_pending.  Use lock_page_killable in do_generic_mapping_read()
to allow us to kill `cat' of a file on an NFS-mounted filesystem.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   14 ++++++++++++++
 include/linux/sched.h   |    9 ++++++++-
 kernel/signal.c         |    5 +++++
 mm/filemap.c            |   25 +++++++++++++++++++++----
 4 files changed, 48 insertions(+), 5 deletions(-)

diff -puN include/linux/pagemap.h~add-lock_page_killable include/linux/pagemap.h
--- a/include/linux/pagemap.h~add-lock_page_killable
+++ a/include/linux/pagemap.h
@@ -157,6 +157,7 @@ static inline pgoff_t linear_page_index(
 }
 
 extern void FASTCALL(__lock_page(struct page *page));
+extern int FASTCALL(__lock_page_killable(struct page *page));
 extern void FASTCALL(__lock_page_nosync(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
@@ -171,6 +172,19 @@ static inline void lock_page(struct page
 }
 
 /*
+ * lock_page_killable is like lock_page but can be interrupted by fatal
+ * signals.  It returns 0 if it locked the page and -EINTR if it was
+ * killed while waiting.
+ */
+static inline int lock_page_killable(struct page *page)
+{
+	might_sleep();
+	if (TestSetPageLocked(page))
+		return __lock_page_killable(page);
+	return 0;
+}
+
+/*
  * lock_page_nosync should only be used if we can't pin the page's inode.
  * Doesn't play quite so well with block device plugging.
  */
diff -puN include/linux/sched.h~add-lock_page_killable include/linux/sched.h
--- a/include/linux/sched.h~add-lock_page_killable
+++ a/include/linux/sched.h
@@ -1917,7 +1917,14 @@ static inline int signal_pending(struct 
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
-  
+
+extern int FASTCALL(__fatal_signal_pending(struct task_struct *p));
+
+static inline int fatal_signal_pending(struct task_struct *p)
+{
+	return signal_pending(p) && __fatal_signal_pending(p);
+}
+
 static inline int need_resched(void)
 {
 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
diff -puN kernel/signal.c~add-lock_page_killable kernel/signal.c
--- a/kernel/signal.c~add-lock_page_killable
+++ a/kernel/signal.c
@@ -972,6 +972,11 @@ void zap_other_threads(struct task_struc
 	}
 }
 
+int fastcall __fatal_signal_pending(struct task_struct *tsk)
+{
+	return sigismember(&tsk->pending.signal, SIGKILL);
+}
+
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
  */
diff -puN mm/filemap.c~add-lock_page_killable mm/filemap.c
--- a/mm/filemap.c~add-lock_page_killable
+++ a/mm/filemap.c
@@ -184,6 +184,12 @@ static int sync_page(void *word)
 	return 0;
 }
 
+static int sync_page_killable(void *word)
+{
+	sync_page(word);
+	return fatal_signal_pending(current) ? -EINTR : 0;
+}
+
 /**
  * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
  * @mapping:	address space structure to write
@@ -588,6 +594,14 @@ void __lock_page(struct page *page)
 }
 EXPORT_SYMBOL(__lock_page);
 
+int fastcall __lock_page_killable(struct page *page)
+{
+	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
+
+	return __wait_on_bit_lock(page_waitqueue(page), &wait,
+					sync_page_killable, TASK_KILLABLE);
+}
+
 /*
  * Variant of lock_page that does not require the caller to hold a reference
  * on the page's mapping.
@@ -979,7 +993,8 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		lock_page(page);
+		if (lock_page_killable(page))
+			goto readpage_eio;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -1007,7 +1022,8 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			lock_page(page);
+			if (lock_page_killable(page))
+				goto readpage_eio;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1018,15 +1034,16 @@ readpage:
 					goto find_page;
 				}
 				unlock_page(page);
-				error = -EIO;
 				shrink_readahead_size_eio(filp, ra);
-				goto readpage_error;
+				goto readpage_eio;
 			}
 			unlock_page(page);
 		}
 
 		goto page_ok;
 
+readpage_eio:
+		error = -EIO;
 readpage_error:
 		/* UHHUH! A synchronous read error occurred. Report it */
 		desc->error = error;
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
hash-add-explicit-u32-and-u64-versions-of-hash.patch
make-sure-nobodys-leaking-resources.patch
