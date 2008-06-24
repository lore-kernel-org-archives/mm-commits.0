From: akpm@linux-foundation.org
Subject: + get_user_pages-fix-possible-page-leak-on-oom.patch added to -mm tree
Date: Tue, 24 Jun 2008 15:50:03 -0700
Message-ID: <200806242250.m5OMo31l010266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbYFXWuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 18:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, npiggin@suse.de


The patch titled
     get_user_pages(): fix possible page leak on oom
has been added to the -mm tree.  Its filename is
     get_user_pages-fix-possible-page-leak-on-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_user_pages(): fix possible page leak on oom
From: Oleg Nesterov <oleg@tv-sign.ru>

get_user_pages() must not return the error when i != 0.  When pages !=
NULL we have i get_page()'ed pages.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~get_user_pages-fix-possible-page-leak-on-oom mm/memory.c
--- a/mm/memory.c~get_user_pages-fix-possible-page-leak-on-oom
+++ a/mm/memory.c
@@ -1151,7 +1151,7 @@ int get_user_pages(struct task_struct *t
 			 * be processed until returning to user space.
 			 */
 			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
-				return -ENOMEM;
+				return i ? i : -ENOMEM;
 
 			if (write)
 				foll_flags |= FOLL_WRITE;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

get_user_pages-fix-possible-page-leak-on-oom.patch
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
include-asm-ptraceh-userspace-headers-cleanup.patch
distinct-tgid-tid-i-o-statistics.patch

