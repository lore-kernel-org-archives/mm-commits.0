From: akpm@linux-foundation.org
Subject: [withdrawn]
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 removed from -mm tree
Date: Wed, 07 May 2014 11:58:04 -0700
Message-ID: <536a823c.SAce7eNI8MuZRA71%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGS6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 14:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, kay@vrfy.org, jack@suse.cz, will.deacon@arm.com

Subject: [withdrawn] printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch removed from -mm tree
To: will.deacon@arm.com,jack@suse.cz,kay@vrfy.org,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 11:58:04 -0700


The patch titled
     Subject: printk: print initial logbuf contents before re-enabling interrupts
has been removed from the -mm tree.  Its filename was
     printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: printk: print initial logbuf contents before re-enabling interrupts

When running on a hideously slow system (~10Mhz FPGA) with a bunch of
debug printk invocations on the timer interrupt path, we end up filling
the log buffer faster than we can drain it.

The reason is that console_unlock (which is responsible for moving
messages out of logbuf to hand over to the console driver) removes one
message at a time, briefly re-enabling interrupts between each of them. 
If the interrupt path prints more than a single message, then we can
easily generate more messages than we can print for a regular, recurring
interrupt (e.g.  a 1khz timer).  This results in messages getting silently
dropped, leading to counter-intuitive, incomplete printk traces on the
console.

Rather than run the console_unlock loop with interrupts disabled (which
has obvious latency problems), this patch records the sequence number of
the last message in the log buffer after taking the logbuf_lock.  We can
then print this fixed amount of work before re-enabling interrupts again,
making sure we keep up with ourself.  Other CPUs could still potentially
flood the buffer, but there's little that we can do to protect against
that.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/printk/printk.c~printk-print-initial-logbuf-contents-before-re-enabling-interrupts kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-print-initial-logbuf-contents-before-re-enabling-interrupts
+++ a/kernel/printk/printk.c
@@ -2147,10 +2147,13 @@ void console_unlock(void)
 again:
 	for (;;) {
 		struct printk_log *msg;
+		u64 console_end_seq;
 		size_t len;
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		console_end_seq = log_next_seq;
+again_noirq:
 		if (seen_seq != log_next_seq) {
 			wake_klogd = true;
 			seen_seq = log_next_seq;
@@ -2195,6 +2198,12 @@ skip:
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
+
+		if (console_seq < console_end_seq) {
+			raw_spin_lock(&logbuf_lock);
+			goto again_noirq;
+		}
+
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
_

Patches currently in -mm which might be from will.deacon@arm.com are

printk-report-dropping-of-messages-from-logbuf.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

