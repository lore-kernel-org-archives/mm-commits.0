From: akpm@linux-foundation.org
Subject: - crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:25 -0800
Message-ID: <200711152112.lAFLCPXK015870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219AbXKOVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
has been removed from the -mm tree.  Its filename was
     crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
From: Jesper Nilsson <jesper.nilsson@axis.com>

Scrap the local __INLINE__ macro, and rename timeval_cmp to fasttime_cmp.

Inline macro was completely unnecessary since the macro was defined
locally to be inline.
timeval_cmp was inaccurately named since it does comparison on
struct fasttimer_t and not on struct timeval.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/fasttimer.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/cris/arch-v10/kernel/fasttimer.c~crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better arch/cris/arch-v10/kernel/fasttimer.c
--- a/arch/cris/arch-v10/kernel/fasttimer.c~crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better
+++ a/arch/cris/arch-v10/kernel/fasttimer.c
@@ -46,8 +46,6 @@ static int sanity_failed;
 #define D2(x)
 #define DP(x)
 
-#define __INLINE__ inline
-
 static unsigned int fast_timer_running;
 static unsigned int fast_timers_added;
 static unsigned int fast_timers_started;
@@ -118,13 +116,13 @@ int timer_freq_settings[NUM_TIMER_STATS]
 int timer_delay_settings[NUM_TIMER_STATS];
 
 /* Not true gettimeofday, only checks the jiffies (uptime) + useconds */
-void __INLINE__ do_gettimeofday_fast(struct fasttime_t *tv)
+inline void do_gettimeofday_fast(struct fasttime_t *tv)
 {
 	tv->tv_jiff = jiffies;
 	tv->tv_usec = GET_JIFFIES_USEC();
 }
 
-int __INLINE__ timeval_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
+inline int fasttime_cmp(struct fasttime_t *t0, struct fasttime_t *t1)
 {
 	/* Compare jiffies. Takes care of wrapping */
 	if (time_before(t0->tv_jiff, t1->tv_jiff))
@@ -140,7 +138,7 @@ int __INLINE__ timeval_cmp(struct fastti
 	return 0;
 }
 
-void __INLINE__ start_timer1(unsigned long delay_us)
+inline void start_timer1(unsigned long delay_us)
 {
   int freq_index = 0; /* This is the lowest resolution */
   unsigned long upper_limit = MAX_DELAY_US;
@@ -264,7 +262,7 @@ void start_one_shot_timer(struct fast_ti
   fast_timers_added++;
 
   /* Check if this should timeout before anything else */
-  if (tmp == NULL || timeval_cmp(&t->tv_expires, &tmp->tv_expires) < 0)
+	if (tmp == NULL || fasttime_cmp(&t->tv_expires, &tmp->tv_expires) < 0)
   {
     /* Put first in list and modify the timer value */
     t->prev = NULL;
@@ -280,8 +278,8 @@ void start_one_shot_timer(struct fast_ti
     start_timer1(delay_us);
   } else {
     /* Put in correct place in list */
-    while (tmp->next &&
-           timeval_cmp(&t->tv_expires, &tmp->next->tv_expires) > 0)
+		while (tmp->next && fasttime_cmp(&t->tv_expires,
+				&tmp->next->tv_expires) > 0)
     {
       tmp = tmp->next;
     }
@@ -382,7 +380,7 @@ timer1_handler(int irq, void *dev_id)
 		D1(printk(KERN_DEBUG "t: %is %06ius\n",
 			tv.tv_jiff, tv.tv_usec));
 
-    if (timeval_cmp(&t->tv_expires, &tv) <= 0)
+		if (fasttime_cmp(&t->tv_expires, &tv) <= 0)
     {
       /* Yes it has expired */
 #ifdef FAST_TIMER_LOG
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
