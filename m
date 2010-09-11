From: akpm@linux-foundation.org
Subject: + softirq-improve-preempt-count-error-message.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:01:14 -0700
Message-ID: <201009110001.o8B01ES5010677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0IKACF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, mingo@elte.hu, tglx@linutronix.de


The patch titled
     softirq: improve preempt count error message
has been added to the -mm tree.  Its filename is
     softirq-improve-preempt-count-error-message.patch

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
Subject: softirq: improve preempt count error message
From: Jiri Slaby <jslaby@suse.cz>

* add a space after the action
* print function name instead of address of action (%p->%pf)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/softirq.c~softirq-improve-preempt-count-error-message kernel/softirq.c
--- a/kernel/softirq.c~softirq-improve-preempt-count-error-message
+++ a/kernel/softirq.c
@@ -219,8 +219,8 @@ restart:
 			h->action(h);
 			trace_softirq_exit(h, softirq_vec);
 			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %td %s %p"
-				       "with preempt_count %08x,"
+				printk(KERN_ERR "huh, entered softirq %td %s "
+				       "%pf with preempt_count %08x,"
 				       " exited with %08x?\n", h - softirq_vec,
 				       softirq_to_name[h - softirq_vec],
 				       h->action, prev_count, preempt_count());
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
hpet-unmap-unused-i-o-space.patch
softirq-improve-preempt-count-error-message.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

