From: akpm@linux-foundation.org
Subject: + sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs.patch added to -mm tree
Date: Thu, 07 Oct 2010 15:43:12 -0700
Message-ID: <201010072243.o97MhCte028752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab0JGWnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 18:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, tony.luck@intel.com


The patch titled
     SGI Altix IA64 mmtimer: eliminate long interval timer holdoffs
has been added to the -mm tree.  Its filename is
     sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs.patch

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
Subject: SGI Altix IA64 mmtimer: eliminate long interval timer holdoffs
From: Dimitri Sivanich <sivanich@sgi.com>

This patch for SGI Altix/IA64 eliminates interval long timer holdoffs in
cases where we don't start an interval timer before the expiration time. 
This sometimes happens when a number of interval timers on the same shub
with the same interval run simultaneously.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mmtimer.c |   55 +++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff -puN drivers/char/mmtimer.c~sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs drivers/char/mmtimer.c
--- a/drivers/char/mmtimer.c~sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs
+++ a/drivers/char/mmtimer.c
@@ -176,9 +176,8 @@ static void mmtimer_setup_int_2(int cpu,
  * in order to insure that the setup succeeds in a deterministic time frame.
  * It will check if the interrupt setup succeeded.
  */
-static int mmtimer_setup(int cpu, int comparator, unsigned long expires)
+static int mmtimer_setup(int cpu, int comparator, unsigned long expires, u64 *r)
 {
-
 	switch (comparator) {
 	case 0:
 		mmtimer_setup_int_0(cpu, expires);
@@ -191,7 +190,8 @@ static int mmtimer_setup(int cpu, int co
 		break;
 	}
 	/* We might've missed our expiration time */
-	if (rtc_time() <= expires)
+	*r = rtc_time();
+	if (*r <= expires)
 		return 1;
 
 	/*
@@ -227,6 +227,8 @@ static int mmtimer_disable_int(long nasi
 #define TIMER_OFF	0xbadcabLL	/* Timer is not setup */
 #define TIMER_SET	0		/* Comparator is set for this timer */
 
+#define MMTIMER_INTRVL_RETRY_INCR_DEFAULT 40
+
 /* There is one of these for each timer */
 struct mmtimer {
 	struct rb_node list;
@@ -242,6 +244,10 @@ struct mmtimer_node {
 };
 static struct mmtimer_node *timers;
 
+static unsigned mmtimer_intrvl_retry_incr = MMTIMER_INTRVL_RETRY_INCR_DEFAULT;
+module_param(mmtimer_intrvl_retry_incr, uint, 0644);
+MODULE_PARM_DESC(mmtimer_intrvl_retry_incr,
+	"RTC ticks to add to expiration on interval retry (default 40)");
 
 /*
  * Add a new mmtimer struct to the node's mmtimer list.
@@ -289,7 +295,8 @@ static void mmtimer_set_next_timer(int n
 	struct mmtimer_node *n = &timers[nodeid];
 	struct mmtimer *x;
 	struct k_itimer *t;
-	int o;
+	u64 expires, exp, r;
+	int i;
 
 restart:
 	if (n->next == NULL)
@@ -300,7 +307,7 @@ restart:
 	if (!t->it.mmtimer.incr) {
 		/* Not an interval timer */
 		if (!mmtimer_setup(x->cpu, COMPARATOR,
-					t->it.mmtimer.expires)) {
+					t->it.mmtimer.expires, &r)) {
 			/* Late setup, fire now */
 			tasklet_schedule(&n->tasklet);
 		}
@@ -308,14 +315,21 @@ restart:
 	}
 
 	/* Interval timer */
-	o = 0;
-	while (!mmtimer_setup(x->cpu, COMPARATOR, t->it.mmtimer.expires)) {
-		unsigned long e, e1;
-		struct rb_node *next;
-		t->it.mmtimer.expires += t->it.mmtimer.incr << o;
-		t->it_overrun += 1 << o;
-		o++;
-		if (o > 20) {
+	i = 0;
+	expires = exp = t->it.mmtimer.expires;
+	while (!mmtimer_setup(x->cpu, COMPARATOR, expires, &r)) {
+		int to;
+
+		i++;
+		expires = r + mmtimer_intrvl_retry_incr + (1 << i);
+		/* Calculate overruns as we go. */
+		to = ((u64)(expires - exp) / t->it.mmtimer.incr);
+		if (to) {
+			t->it_overrun += to;
+			t->it.mmtimer.expires += t->it.mmtimer.incr * to;
+			exp = t->it.mmtimer.expires;
+		}
+		if (i > 20) {
 			printk(KERN_ALERT "mmtimer: cannot reschedule timer\n");
 			t->it.mmtimer.clock = TIMER_OFF;
 			n->next = rb_next(&x->list);
@@ -323,21 +337,6 @@ restart:
 			kfree(x);
 			goto restart;
 		}
-
-		e = t->it.mmtimer.expires;
-		next = rb_next(&x->list);
-
-		if (next == NULL)
-			continue;
