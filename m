From: akpm@linux-foundation.org
Subject: + timer-warn-when-del_timer_sync-used-in-hardirq-context.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:09:10 -0700
Message-ID: <201009242209.o8OM9AZN028186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab0IXWJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang@windriver.com, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com


The patch titled
     timer: warn when del_timer_sync() used in hardirq context
has been added to the -mm tree.  Its filename is
     timer-warn-when-del_timer_sync-used-in-hardirq-context.patch

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
Subject: timer: warn when del_timer_sync() used in hardirq context
From: Yong Zhang <yong.zhang@windriver.com>

Add explict warning to prevent del_timer_sync() from using in hardirq
context.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/timer.c~timer-warn-when-del_timer_sync-used-in-hardirq-context kernel/timer.c
--- a/kernel/timer.c~timer-warn-when-del_timer_sync-used-in-hardirq-context
+++ a/kernel/timer.c
@@ -994,7 +994,11 @@ int del_timer_sync(struct timer_list *ti
 	lock_map_release(&timer->lockdep_map);
 	local_bh_enable();
 #endif
