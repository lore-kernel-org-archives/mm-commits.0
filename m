From: akpm@linux-foundation.org
Subject: + mm-make-get_user_pages-interruptible.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:38:22 -0800
Message-ID: <200812030838.mB38cMaE020860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbYLCIiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:38:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, nickpiggin@yahoo.com.au, oleg@tv-sign.ru, penberg@cs.helsinki.fi, rientjes@google.com, rohitseth@google.com


The patch titled
     mm: make get_user_pages() interruptible
has been added to the -mm tree.  Its filename is
     mm-make-get_user_pages-interruptible.patch

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
Subject: mm: make get_user_pages() interruptible
From: Ying Han <yinghan@google.com>

The initial implementation of checking TIF_MEMDIE covers the cases of OOM
killing.  If the process has been OOM killed, the TIF_MEMDIE is set and it
return immediately.  This patch includes:

1.  add the case that the SIGKILL is sent by user processes.  The
   process can try to get_user_pages() unlimited memory even if a user
   process has sent a SIGKILL to it(maybe a monitor find the process
   exceed its memory limit and try to kill it).  In the old
   implementation, the SIGKILL won't be handled until the get_user_pages()
   returns.

2.  change the return value to be ERESTARTSYS.  It makes no sense to
   return ENOMEM if the get_user_pages returned by getting a SIGKILL
   signal.  Considering the general convention for a system call
   interrupted by a signal is ERESTARTNOSYS, so the current return value
   is consistant to that.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-make-get_user_pages-interruptible mm/memory.c
--- a/mm/memory.c~mm-make-get_user_pages-interruptible
+++ a/mm/memory.c
@@ -1275,12 +1275,11 @@ int __get_user_pages(struct task_struct 
 			struct page *page;
 
 			/*
-			 * If tsk is ooming, cut off its access to large memory
-			 * allocations. It has a pending SIGKILL, but it can't
-			 * be processed until returning to user space.
+			 * If we have a pending SIGKILL, don't keep
+			 * allocating memory.
 			 */
-			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
-				return i ? i : -ENOMEM;
+			if (unlikely(fatal_signal_pending(current)))
+				return i ? i : -ERESTARTSYS;
 
 			if (write)
 				foll_flags |= FOLL_WRITE;
_

Patches currently in -mm which might be from yinghan@google.com are

mm-make-get_user_pages-interruptible.patch

