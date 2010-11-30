From: akpm@linux-foundation.org
Subject: + timers-use-this_cpu_read.patch added to -mm tree
Date: Tue, 30 Nov 2010 13:49:30 -0800
Message-ID: <201011302149.oAULnU9M012167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0K3VuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 16:50:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux.com, eric.dumazet@gmail.com, mathieu.desnoyers@efficios.com, penberg@cs.helsinki.fi, tglx@linutronix.de, tj@kernel.org


The patch titled
     timers: use this_cpu_read()
has been added to the -mm tree.  Its filename is
     timers-use-this_cpu_read.patch

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
Subject: timers: use this_cpu_read()
From: Christoph Lameter <cl@linux.com>

Eric asked for this.

(akpm: generates better code, saves 20 bytes of text on x86_64).

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/timer.c~timers-use-this_cpu_read kernel/timer.c
--- a/kernel/timer.c~timers-use-this_cpu_read
+++ a/kernel/timer.c
@@ -1227,7 +1227,7 @@ static unsigned long cmp_next_hrtimer_ev
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 	unsigned long expires;
 
 	spin_lock(&base->lock);
@@ -1270,7 +1270,7 @@ void update_process_times(int user_tick)
  */
 static void run_timer_softirq(struct softirq_action *h)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 
 	hrtimer_run_pending();
 
_

Patches currently in -mm which might be from cl@linux.com are

linux-next.patch
irq-use-per_cpu-kstat_irqs.patch
timers-use-this_cpu_read.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
percpucounter-optimize-__percpu_counter_add-a-bit-through-the-use-of-this_cpu-operations.patch

