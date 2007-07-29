From: akpm@linux-foundation.org
Subject: - lguest-provide-timespec-to-guests-rather-than-jiffies-clock.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:58 -0700
Message-ID: <200707290612.l6T6CwMm011157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbXG2GXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: provide timespec to guests rather than jiffies clock.
has been removed from the -mm tree.  Its filename was
     lguest-provide-timespec-to-guests-rather-than-jiffies-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: provide timespec to guests rather than jiffies clock.
From: Rusty Russell <rusty@rustcorp.com.au>

A non-periodic clock_event_device and the "jiffies" clock don't mix well:
tick_handle_periodic() can go into an infinite loop.

Currently lguest guests use the jiffies clock when the TSC is unusable. 
Instead, make the Host write the current time into the lguest page on every
interrupt.  This doesn't cost much but is more precise and at least as
accurate as the jiffies clock.  It also gets rid of the GET_WALLCLOCK
hypercall.

Also, delay setting sched_clock until our clock is set up, otherwise the
early printk timestamps can go backwards (not harmful, just ugly).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/hypercalls.c           |   21 ++++++---
 drivers/lguest/interrupts_and_traps.c |    7 +++
 drivers/lguest/lg.h                   |    1 
 drivers/lguest/lguest.c               |   52 ++++++++++++++++--------
 include/linux/lguest.h                |    4 +
 5 files changed, 60 insertions(+), 25 deletions(-)

diff -puN drivers/lguest/hypercalls.c~lguest-provide-timespec-to-guests-rather-than-jiffies-clock drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-provide-timespec-to-guests-rather-than-jiffies-clock
+++ a/drivers/lguest/hypercalls.c
@@ -64,14 +64,6 @@ static void do_hcall(struct lguest *lg, 
 		else
 			guest_pagetable_flush_user(lg);
 		break;
-	case LHCALL_GET_WALLCLOCK: {
-		/* The Guest wants to know the real time in seconds since 1970,
-		 * in good Unix tradition. */
-		struct timespec ts;
-		ktime_get_real_ts(&ts);
-		regs->eax = ts.tv_sec;
-		break;
-	}
 	case LHCALL_BIND_DMA:
 		/* BIND_DMA really wants four arguments, but it's the only call
 		 * which does.  So the Guest packs the number of buffers and
@@ -235,6 +227,9 @@ static void initialize(struct lguest *lg
 	    || put_user(lg->guestid, &lg->lguest_data->guestid))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
+	/* We write the current time into the Guest's data page once now. */
+	lguest_write_timestamp(lg);
+
 	/* This is the one case where the above accesses might have been the
 	 * first write to a Guest page.  This may have caused a copy-on-write
 	 * fault, but the Guest might be referring to the old (read-only)
@@ -293,3 +288,13 @@ void do_hypercalls(struct lguest *lg)
 		clear_hcall(lg);
 	}
 }
+
+/* This routine supplies the Guest with time: it's used for wallclock time at
+ * initial boot and as a rough time source if the TSC isn't available. */
+void lguest_write_timestamp(struct lguest *lg)
+{
+	struct timespec now;
+	ktime_get_real_ts(&now);
+	if (put_user(now, &lg->lguest_data->time))
+		kill_guest(lg, "Writing timestamp");
+}
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-provide-timespec-to-guests-rather-than-jiffies-clock drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-provide-timespec-to-guests-rather-than-jiffies-clock
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -175,6 +175,13 @@ void maybe_do_interrupt(struct lguest *l
 		 * the stack as well: virtual interrupts never do. */
 		set_guest_interrupt(lg, idt->a, idt->b, 0);
 	}
+
+	/* Every time we deliver an interrupt, we update the timestamp in the
+	 * Guest's lguest_data struct.  It would be better for the Guest if we
+	 * did this more often, but it can actually be quite slow: doing it
+	 * here is a compromise which means at least it gets updated every
+	 * timer interrupt. */
+	lguest_write_timestamp(lg);
 }
 
 /*H:220 Now we've got the routines to deliver interrupts, delivering traps
diff -puN drivers/lguest/lg.h~lguest-provide-timespec-to-guests-rather-than-jiffies-clock drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-provide-timespec-to-guests-rather-than-jiffies-clock
+++ a/drivers/lguest/lg.h
@@ -256,6 +256,7 @@ unsigned long get_dma_buffer(struct lgue
 
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
+void lguest_write_timestamp(struct lguest *lg);
 
 /*L:035
  * Let's step aside for the moment, to study one important routine that's used
diff -puN drivers/lguest/lguest.c~lguest-provide-timespec-to-guests-rather-than-jiffies-clock drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-provide-timespec-to-guests-rather-than-jiffies-clock
+++ a/drivers/lguest/lguest.c
@@ -643,21 +643,42 @@ static void __init lguest_init_IRQ(void)
  * Time.
  *
  * It would be far better for everyone if the Guest had its own clock, but
- * until then it must ask the Host for the time.
+ * until then the Host gives us the time on every interrupt.
  */
 static unsigned long lguest_get_wallclock(void)
 {
-	return hcall(LHCALL_GET_WALLCLOCK, 0, 0, 0);
+	return lguest_data.time.tv_sec;
 }
 
-/* If the Host tells us we can trust the TSC, we use that, otherwise we simply
- * use the imprecise but reliable "jiffies" counter. */
 static cycle_t lguest_clock_read(void)
 {
+	unsigned long sec, nsec;
+
+	/* If the Host tells the TSC speed, we can trust that. */
 	if (lguest_data.tsc_khz)
 		return native_read_tsc();
-	else
-		return jiffies;
+
+	/* If we can't use the TSC, we read the time value written by the Host.
+	 * Since it's in two parts (seconds and nanoseconds), we risk reading
+	 * it just as it's changing from 99 & 0.999999999 to 100 and 0, and
+	 * getting 99 and 0.  As Linux tends to come apart under the stress of
+	 * time travel, we must be careful: */
+	do {
+		/* First we read the seconds part. */
+		sec = lguest_data.time.tv_sec;
+		/* This read memory barrier tells the compiler and the CPU that
+		 * this can't be reordered: we have to complete the above
+		 * before going on. */
+		rmb();
+		/* Now we read the nanoseconds part. */
+		nsec = lguest_data.time.tv_nsec;
+		/* Make sure we've done that. */
+		rmb();
+		/* Now if the seconds part has changed, try again. */
+	} while (unlikely(lguest_data.time.tv_sec != sec));
+
+	/* Our non-TSC clock is in real nanoseconds. */
+	return sec*1000000000ULL + nsec;
 }
 
 /* This is what we tell the kernel is our clocksource.  */
@@ -665,8 +686,11 @@ static struct clocksource lguest_clock =
 	.name		= "lguest",
 	.rating		= 400,
 	.read		= lguest_clock_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 1,
 };
 
+/* The "scheduler clock" is just our real clock, adjusted to start at zero */
 static unsigned long long lguest_sched_clock(void)
 {
 	return cyc2ns(&lguest_clock, lguest_clock_read() - clock_base);
@@ -742,24 +766,21 @@ static void lguest_time_init(void)
 	set_irq_handler(0, lguest_time_irq);
 
 	/* Our clock structure look like arch/i386/kernel/tsc.c if we can use
-	 * the TSC, otherwise it looks like kernel/time/jiffies.c.  Either way,
-	 * the "rating" is initialized so high that it's always chosen over any
-	 * other clocksource. */
+	 * the TSC, otherwise it's a dumb nanosecond-resolution clock.  Either
+	 * way, the "rating" is initialized so high that it's always chosen
+	 * over any other clocksource. */
 	if (lguest_data.tsc_khz) {
 		lguest_clock.shift = 22;
 		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
 							 lguest_clock.shift);
-		lguest_clock.mask = CLOCKSOURCE_MASK(64);
 		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;
-	} else {
-		/* To understand this, start at kernel/time/jiffies.c... */
-		lguest_clock.shift = 8;
-		lguest_clock.mult = (((u64)NSEC_PER_SEC<<8)/ACTHZ) << 8;
-		lguest_clock.mask = CLOCKSOURCE_MASK(32);
 	}
 	clock_base = lguest_clock_read();
 	clocksource_register(&lguest_clock);
 
+	/* Now we've set up our clock, we can use it as the scheduler clock */
+	paravirt_ops.sched_clock = lguest_sched_clock;
+
 	/* We can't set cpumask in the initializer: damn C limitations!  Set it
 	 * here and register our timer device. */
 	lguest_clockevent.cpumask = cpumask_of_cpu(0);
@@ -996,7 +1017,6 @@ __init void lguest_init(void *boot)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
-	paravirt_ops.sched_clock = lguest_sched_clock;
 	/* Now is a good time to look at the implementations of these functions
 	 * before returning to the rest of lguest_init(). */
 
diff -puN include/linux/lguest.h~lguest-provide-timespec-to-guests-rather-than-jiffies-clock include/linux/lguest.h
--- a/include/linux/lguest.h~lguest-provide-timespec-to-guests-rather-than-jiffies-clock
+++ a/include/linux/lguest.h
@@ -17,7 +17,6 @@
 #define LHCALL_TS		8
 #define LHCALL_SET_CLOCKEVENT	9
 #define LHCALL_HALT		10
-#define LHCALL_GET_WALLCLOCK	11
 #define LHCALL_BIND_DMA		12
 #define LHCALL_SEND_DMA		13
 #define LHCALL_SET_PTE		14
@@ -88,6 +87,9 @@ struct lguest_data
 	 * this address would normally be found. */
 	unsigned long cr2;
 
+	/* Wallclock time set by the Host. */
+	struct timespec time;
+
 	/* Async hypercall ring.  Instead of directly making hypercalls, we can
 	 * place them in here for processing the next time the Host wants.
 	 * This batching can be quite efficient. */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-newsetup-fixup.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
