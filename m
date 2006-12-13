From: akpm@osdl.org
Subject: - dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:33 -0800
Message-ID: <200612132248.kBDMmXXO023089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52844 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbWLMWtF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cotte@de.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     remove incorrect warning in kernel/timer.c:688
has been removed from the -mm tree.  Its filename was
     dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: remove incorrect warning in kernel/timer.c:688
From: Carsten Otte <cotte@de.ibm.com>

the following patch in your broken-out series produces an incorrect
warning on s390:
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch

I get plenty of those on my syslog with 2.6.19-rc2-mm1:
Oct 18 17:13:19 t6360021 klogd: BUG: warning at kernel/timer.c:688/__next_timer_interrupt()
Oct 18 17:13:19 t6360021 klogd: 0000000000103502 000000001ff8dc20 0000000000000002 0000000000000000
Oct 18 17:13:19 t6360021 klogd:        000000001ff8dcc0 000000001ff8dc38 000000001ff8dc38 0000000000103574
Oct 18 17:13:19 t6360021 klogd:        0000000000000000 0000000000000000 0000000000000000 0000000000000000
Oct 18 17:13:19 t6360021 klogd:        000000001ff8dc20 000000000000000c 000000001ff8dc20 000000001ff8dc90
Oct 18 17:13:19 t6360021 klogd:        00000000004221e8 0000000000103574 000000001ff8dc20 000000001ff8dc70
Oct 18 17:13:19 t6360021 klogd: Call Trace:
Oct 18 17:13:19 t6360021 klogd: ([<0000000000103502>] show_trace+0x166/0x16c)
Oct 18 17:13:19 t6360021 klogd:  [<00000000001035ce>] show_stack+0xc6/0xf8
Oct 18 17:13:19 t6360021 klogd:  [<000000000010362e>] dump_stack+0x2e/0x3c
Oct 18 17:13:19 t6360021 klogd:  [<0000000000137104>] __next_timer_interrupt+0x13c/0x270
Oct 18 17:13:19 t6360021 klogd:  [<00000000001372da>] next_timer_interrupt+0xa2/0x124
Oct 18 17:13:19 t6360021 klogd:  [<0000000000105568>] nohz_idle_notify+0x17c/0x244
Oct 18 17:13:19 t6360021 klogd:  [<000000000041ce4c>] notifier_call_chain+0x64/0x88
Oct 18 17:13:19 t6360021 klogd:  [<000000000041ceb0>] atomic_notifier_call_chain+0x40/0x8c
Oct 18 17:13:19 t6360021 klogd:  [<0000000000105dde>] cpu_idle+0x82/0x1fc
Oct 18 17:13:19 t6360021 klogd:  [<0000000000110104>] start_secondary+0xb0/0xc4
Oct 18 17:13:19 t6360021 klogd:  [<0000000000000000>] 0x0
Oct 18 17:13:19 t6360021 klogd:  [<0000000000000000>] 0x0

Problem is, that the warning assumes that there are always pending timer
events on a system when a CPU is going idle.  But this is not true in
general, the system may be waiting for an I/O interruption, or the CPU may
wait for an interprocessor signal.  The patch below removes the warning,
please apply.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/timer.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN kernel/timer.c~dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc kernel/timer.c
--- a/kernel/timer.c~dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc
+++ a/kernel/timer.c
@@ -526,7 +526,6 @@ found:
 			}
 		}
 	}
-	WARN_ON(!found);
 
 	return expires;
 }
_

Patches currently in -mm which might be from cotte@de.ibm.com are

dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch

