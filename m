From: akpm@linux-foundation.org
Subject: + add-support-for-deferrable-timers-respun-fix.patch added to -mm tree
Date: Wed, 28 Mar 2007 15:47:28 -0700
Message-ID: <200703282247.l2SMlSvY021966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934065AbXC1WsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 18:48:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de


The patch titled
     Add support for deferrable timers (respun) (fix)
has been added to the -mm tree.  Its filename is
     add-support-for-deferrable-timers-respun-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add support for deferrable timers (respun) (fix)
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

On Wed, Mar 28, 2007 at 01:11:45AM +0400, Oleg Nesterov wrote:
> On 03/27, Venki Pallipadi wrote:
> >
> >  	for (;;) {
> > -		base = timer->base;
> > +		tvec_base_t *prelock_base = timer->base;
> > +		base = timer_get_base(timer);
> >  		if (likely(base != NULL)) {
> >  			spin_lock_irqsave(&base->lock, *flags);
> > -			if (likely(base == timer->base))
> > +			if (likely(prelock_base == timer->base))
> >  				return base;
>
> I don't think this is correct, at least in theory.
>
> Suppose that
>
> 	tvec_base_t *prelock_base = timer->base;
> 	base = timer_get_base(timer);
>
> are re-ordered (the second LOAD happens after the first one), and the timer
> changes its base in between. Now, we lock the old base, and return it because
> "prelock_base == timer->base" == true.
>

Great catch. Yes. this is a theoritical possibility, even though most compilers
would load base only once and use it for prelock_base and 'and' it for
base. Atleast that is what I see on i386/gcc.

Incremental patch below eliminates this race.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/timer.c~add-support-for-deferrable-timers-respun-fix kernel/timer.c
--- a/kernel/timer.c~add-support-for-deferrable-timers-respun-fix
+++ a/kernel/timer.c
@@ -103,9 +103,9 @@ static inline unsigned int timer_get_def
 	return tbase_get_deferrable(timer->base);
 }
 
-static inline struct tvec_t_base_s *timer_get_base(struct timer_list *timer)
+static inline struct tvec_t_base_s *tbase_get_base(struct tvec_t_base_s *base)
 {
-	return ((struct tvec_t_base_s *)((unsigned long)(timer->base) &
+	return ((struct tvec_t_base_s *)((unsigned long)base &
 	                                 ~TBASE_DEFERRABLE_FLAG));
 }
 
@@ -375,7 +375,7 @@ static tvec_base_t *lock_timer_base(stru
 
 	for (;;) {
 		tvec_base_t *prelock_base = timer->base;
-		base = timer_get_base(timer);
+		base = tbase_get_base(prelock_base);
 		if (likely(base != NULL)) {
 			spin_lock_irqsave(&base->lock, *flags);
 			if (likely(prelock_base == timer->base))
@@ -599,7 +599,7 @@ static int cascade(tvec_base_t *base, tv
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(timer_get_base(timer) != base);
+		BUG_ON(tbase_get_base(timer->base) != base);
 		internal_add_timer(base, timer);
 	}
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-fix-boot-hang.patch
cpuidle-unsigned-bitfield.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
