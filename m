From: akpm@linux-foundation.org
Subject: + softirq-cleanup-preempt-check.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:05:11 -0700
Message-ID: <201010051905.o95J5BrS013873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab0JETGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     softirq: cleanup preempt check
has been added to the -mm tree.  Its filename is
     softirq-cleanup-preempt-check.patch

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
Subject: softirq: cleanup preempt check
From: Jiri Slaby <jslaby@suse.cz>

The preempt debugging check in the softirq code is ugly.  The print is
lenghty and spread over several lines which makes the code difficult to
read.  This was also the reason for the wrong spacing in the message.

So move the check into a separate inlined function and make the print text
a one-liner for easier grepping.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN kernel/softirq.c~softirq-cleanup-preempt-check kernel/softirq.c
--- a/kernel/softirq.c~softirq-cleanup-preempt-check
+++ a/kernel/softirq.c
@@ -177,6 +177,17 @@ void local_bh_enable_ip(unsigned long ip
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 
+static inline void softirq_preempt_check(struct softirq_action *h,
+		int prev_count)
+{
+	if (unlikely(prev_count != preempt_count())) {
+		printk(KERN_ERR "huh, entered softirq %td %s %pf with preempt_count %08x, exited with %08x?\n",
+			h - softirq_vec, softirq_to_name[h - softirq_vec],
+			h->action, prev_count, preempt_count());
+		preempt_count() = prev_count;
+	}
+}
+
 /*
  * We restart softirq processing MAX_SOFTIRQ_RESTART times,
  * and we fall back to softirqd after that.
@@ -218,14 +229,8 @@ restart:
 			trace_softirq_entry(h, softirq_vec);
 			h->action(h);
 			trace_softirq_exit(h, softirq_vec);
-			if (unlikely(prev_count != preempt_count())) {
-				printk(KERN_ERR "huh, entered softirq %td %s "
-				       "%pf with preempt_count %08x,"
-				       " exited with %08x?\n", h - softirq_vec,
-				       softirq_to_name[h - softirq_vec],
-				       h->action, prev_count, preempt_count());
-				preempt_count() = prev_count;
-			}
+
+			softirq_preempt_check(h, prev_count);
 
 			rcu_bh_qs(cpu);
 		}
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
drivers-media-ir-ene_irc-fix-null-dereference.patch
softirq-improve-preempt-count-error-message.patch
softirq-cleanup-preempt-check.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
hpet-unmap-unused-i-o-space.patch

