From: akpm@linux-foundation.org
Subject: + sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update.patch added to -mm tree
Date: Fri, 08 Oct 2010 12:03:35 -0700
Message-ID: <201010081903.o98J3ZU1020334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab0JHTDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Oct 2010 15:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, tony.luck@intel.com


The patch titled
     sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update
has been added to the -mm tree.  Its filename is
     sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update.patch

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
Subject: sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update
From: Dimitri Sivanich <sivanich@sgi.com>

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mmtimer.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/char/mmtimer.c~sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update drivers/char/mmtimer.c
--- a/drivers/char/mmtimer.c~sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update
+++ a/drivers/char/mmtimer.c
@@ -176,7 +176,8 @@ static void mmtimer_setup_int_2(int cpu,
  * in order to insure that the setup succeeds in a deterministic time frame.
  * It will check if the interrupt setup succeeded.
  */
-static int mmtimer_setup(int cpu, int comparator, unsigned long expires, u64 *r)
+static int mmtimer_setup(int cpu, int comparator, unsigned long expires,
+	u64 *set_completion_time)
 {
 	switch (comparator) {
 	case 0:
@@ -190,8 +191,8 @@ static int mmtimer_setup(int cpu, int co
 		break;
 	}
 	/* We might've missed our expiration time */
-	*r = rtc_time();
-	if (*r <= expires)
+	*set_completion_time = rtc_time();
+	if (*set_completion_time <= expires)
 		return 1;
 
 	/*
@@ -227,7 +228,7 @@ static int mmtimer_disable_int(long nasi
 #define TIMER_OFF	0xbadcabLL	/* Timer is not setup */
 #define TIMER_SET	0		/* Comparator is set for this timer */
 
-#define MMTIMER_INTRVL_RETRY_INCR_DEFAULT 40
+#define MMTIMER_INTERVAL_RETRY_INCREMENT_DEFAULT 40
 
 /* There is one of these for each timer */
 struct mmtimer {
@@ -244,9 +245,10 @@ struct mmtimer_node {
 };
 static struct mmtimer_node *timers;
 
-static unsigned mmtimer_intrvl_retry_incr = MMTIMER_INTRVL_RETRY_INCR_DEFAULT;
-module_param(mmtimer_intrvl_retry_incr, uint, 0644);
-MODULE_PARM_DESC(mmtimer_intrvl_retry_incr,
+static unsigned mmtimer_interval_retry_increment =
+	MMTIMER_INTERVAL_RETRY_INCREMENT_DEFAULT;
+module_param(mmtimer_interval_retry_increment, uint, 0644);
+MODULE_PARM_DESC(mmtimer_interval_retry_increment,
 	"RTC ticks to add to expiration on interval retry (default 40)");
 
 /*
@@ -295,7 +297,7 @@ static void mmtimer_set_next_timer(int n
 	struct mmtimer_node *n = &timers[nodeid];
 	struct mmtimer *x;
 	struct k_itimer *t;
-	u64 expires, exp, r;
+	u64 expires, exp, set_completion_time;
 	int i;
 
 restart:
@@ -307,7 +309,8 @@ restart:
 	if (!t->it.mmtimer.incr) {
 		/* Not an interval timer */
 		if (!mmtimer_setup(x->cpu, COMPARATOR,
-					t->it.mmtimer.expires, &r)) {
+					t->it.mmtimer.expires,
+					&set_completion_time)) {
 			/* Late setup, fire now */
 			tasklet_schedule(&n->tasklet);
 		}
@@ -317,11 +320,13 @@ restart:
 	/* Interval timer */
 	i = 0;
 	expires = exp = t->it.mmtimer.expires;
-	while (!mmtimer_setup(x->cpu, COMPARATOR, expires, &r)) {
+	while (!mmtimer_setup(x->cpu, COMPARATOR, expires,
+				&set_completion_time)) {
 		int to;
 
 		i++;
-		expires = r + mmtimer_intrvl_retry_incr + (1 << i);
+		expires = set_completion_time +
+				mmtimer_interval_retry_increment + (1 << i);
 		/* Calculate overruns as we go. */
 		to = ((u64)(expires - exp) / t->it.mmtimer.incr);
 		if (to) {
_

Patches currently in -mm which might be from sivanich@sgi.com are

sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs.patch
sgi-altix-ia64-mmtimer-eliminate-long-interval-timer-holdoffs-update.patch

