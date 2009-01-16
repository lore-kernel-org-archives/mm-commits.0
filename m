From: akpm@linux-foundation.org
Subject: + lock_page_killable-avoid-lost-wakeups.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:44:12 -0800
Message-ID: <200901162244.n0GMiCjw031984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbZAPWof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris.mason@oracle.com, a.p.zijlstra@chello.nl, cel@citi.umich.edu, matthew@wil.cx, nickpiggin@yahoo.com.au, stable@kernel.org


The patch titled
     lock_page_killable(): avoid lost wakeups
has been added to the -mm tree.  Its filename is
     lock_page_killable-avoid-lost-wakeups.patch

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
Subject: lock_page_killable(): avoid lost wakeups
From: Chris Mason <chris.mason@oracle.com>

lock_page and lock_page_killable both call __wait_on_bit_lock, and both
end up using prepare_to_wait_exclusive().  This means that when someone
does finally unlock the page, only one process is going to get woken up.

But lock_page_killable can exit without taking the lock.  If nobody else
comes in and locks the page, any other waiters will wait forever.

For example, procA holding the page lock, procB and procC are waiting on
the lock.

procA: lock_page() // success
procB: lock_page_killable(), sync_page_killable(), io_schedule()
procC: lock_page_killable(), sync_page_killable(), io_schedule()

procA: unlock, wake_up_page(page, PG_locked)
procA: wake up procB

happy admin: kill procB

procB: wakes into sync_page_killable(), notices the signal and returns
-EINTR

procB: __wait_on_bit_lock sees the action() func returns < 0 and does
not take the page lock

procB: lock_page_killable() returns < 0 and exits happily.

procC: sleeping in io_schedule() forever unless someone else locks the
page.

This was seen in production on systems where the database was shutting
down.  Testing shows the patch fixes things.

Chuck Lever did all the hard work here, with a page lock debugging
patch that proved we were missing a wakeup.

Every version of lock_page_killable() should need this.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chuck Lever <cel@citi.umich.edu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~lock_page_killable-avoid-lost-wakeups mm/filemap.c
--- a/mm/filemap.c~lock_page_killable-avoid-lost-wakeups
+++ a/mm/filemap.c
@@ -623,9 +623,20 @@ EXPORT_SYMBOL(__lock_page);
 int __lock_page_killable(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
+	int ret;
 
-	return __wait_on_bit_lock(page_waitqueue(page), &wait,
+	ret = __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sync_page_killable, TASK_KILLABLE);
+	/*
+	 * wait_on_bit_lock uses prepare_to_wait_exclusive, so if multiple
+	 * procs were waiting on this page, we were the only proc woken up.
+	 *
+	 * if ret != 0, we didn't actually get the lock.  We need to
+	 * make sure any other waiters don't sleep forever.
+	 */
+	if (ret)
+		wake_up_page(page, PG_locked);
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from chris.mason@oracle.com are

origin.patch
lock_page_killable-avoid-lost-wakeups.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch

