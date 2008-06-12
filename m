From: akpm@linux-foundation.org
Subject: - do_generic_file_read-s-eintr-eio-if-lock_page_killable-fails.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:13 -0700
Message-ID: <200806122038.m5CKcD2c005519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127AbYFLUjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, dmitry.adamushko@gmail.com, matthew@wil.cx, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_generic_file_read: s/EINTR/EIO/ if lock_page_killable() fails
has been removed from the -mm tree.  Its filename was
     do_generic_file_read-s-eintr-eio-if-lock_page_killable-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_generic_file_read: s/EINTR/EIO/ if lock_page_killable() fails
From: Oleg Nesterov <oleg@tv-sign.ru>

If lock_page_killable() fails because the task was killed by SIGKILL or
any other fatal signal, do_generic_file_read() returns -EIO.

This seems to be OK, because in fact the userspace won't see this error,
the task will dequeue SIGKILL and exit.

However, /sbin/init is different, it will dequeue SIGKILL, ignore it, and
return to the user-space with the bogus -EIO.

Change the code to return the error code from lock_page_killable(), -EINTR.
This doesn't fix the bug, but perhaps makes sense anyway. Imho, with this
change the code looks a bit more logical, and the "good" init should handle
the spurious EINTR or short read.

Afaics we can also change lock_page_killable() to return -ERESTARTNOINTR,
but this can't prevent the short reads.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/filemap.c~do_generic_file_read-s-eintr-eio-if-lock_page_killable-fails mm/filemap.c
--- a/mm/filemap.c~do_generic_file_read-s-eintr-eio-if-lock_page_killable-fails
+++ a/mm/filemap.c
@@ -1000,8 +1000,9 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		if (lock_page_killable(page))
-			goto readpage_eio;
+		error = lock_page_killable(page);
+		if (unlikely(error))
+			goto readpage_error;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -1029,8 +1030,9 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			if (lock_page_killable(page))
-				goto readpage_eio;
+			error = lock_page_killable(page);
+			if (unlikely(error))
+				goto readpage_error;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1042,15 +1044,14 @@ readpage:
 				}
 				unlock_page(page);
 				shrink_readahead_size_eio(filp, ra);
-				goto readpage_eio;
+				error = -EIO;
+				goto readpage_error;
 			}
 			unlock_page(page);
 		}
 
 		goto page_ok;
 
-readpage_eio:
-		error = -EIO;
 readpage_error:
 		/* UHHUH! A synchronous read error occurred. Report it */
 		desc->error = error;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
distinct-tgid-tid-i-o-statistics.patch

