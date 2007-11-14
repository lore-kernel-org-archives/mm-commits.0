From: akpm@linux-foundation.org
Subject: + crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better.patch added to -mm tree
Date: Wed, 14 Nov 2007 09:28:25 -0800
Message-ID: <200711141728.lAEHSPnc016789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbXKNR3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 12:29:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
has been added to the -mm tree.  Its filename is
     crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-mtd.patch
cris-build-fixes-fix-csum_tcpudp_magic-declaration.patch
cris-build-fixes-add-missing-syscalls.patch
cris-build-fixes-hardirqh-include-asm-irqh.patch
cris-build-fixes-atomich-needs-compilerh.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-irq-fixes.patch
cris-build-fixes-sys_crisc-needs-fsh.patch
cris-build-fixes-add-baud-rate-defines.patch
cris-build-fixes-update-eth_v10c-ethernet-driver.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-corrected-and-improved-nmi-and-irq-handling.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec.patch
cris-build-fixes-setupc-needs-paramh.patch
cris-build-fixes-fix-crisksymsc.patch
cris-build-fixes-defconfig-updates.patch
cris-dont-include-bitopsh-in-posix_typesh.patch
crisv10-serial-driver-rewrite-take-three.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
crisv10-fix-timer-interrupt-parameters.patch
crisv10-improve-and-bugfix-fasttimer.patch
crisv32-add-cache-flush-operations.patch
cris-tlbh-should-include-linux-pagemaph.patch
crisv10-ethernet-declare-mac-fix.patch
crisv10-usercopy-library-add-lineendings-to-asm.patch
crisv10-string-library-add-lineendings-to-asm.patch
crisv10-memset-library-add-lineendings-to-asm.patch
crisv10-fasttimer-scrap-inline-and-name-timeval_cmp-better.patch
