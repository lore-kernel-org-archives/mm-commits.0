From: akpm@linux-foundation.org
Subject: + cris-fasttimer-remove-use-of-seq_printf-return-value.patch
 added to -mm tree
Date: Tue, 24 Mar 2015 15:55:17 -0700
Message-ID: <5511eb55.vf0bqcRsJT7MF95m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbCXWzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris fasttimer: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     cris-fasttimer-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-fasttimer-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-fasttimer-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: cris fasttimer: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Miscellanea:

o Coalesce formats, realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/fasttimer.c |   85 +++++++++++-------------
 arch/cris/arch-v32/kernel/fasttimer.c |   85 +++++++++++-------------
 2 files changed, 78 insertions(+), 92 deletions(-)

diff -puN arch/cris/arch-v10/kernel/fasttimer.c~cris-fasttimer-remove-use-of-seq_printf-return-value arch/cris/arch-v10/kernel/fasttimer.c
--- a/arch/cris/arch-v10/kernel/fasttimer.c~cris-fasttimer-remove-use-of-seq_printf-return-value
+++ a/arch/cris/arch-v10/kernel/fasttimer.c
@@ -527,7 +527,8 @@ static int proc_fasttimer_show(struct se
 			i = debug_log_cnt;
 
 		while (i != end_i || debug_log_cnt_wrapped) {
-			if (seq_printf(m, debug_log_string[i], debug_log_value[i]) < 0)
+			seq_printf(m, debug_log_string[i], debug_log_value[i]);
+			if (seq_has_overflowed(m))
 				return 0;
 			i = (i+1) % DEBUG_LOG_MAX;
 		}
@@ -542,24 +543,22 @@ static int proc_fasttimer_show(struct se
 		int cur = (fast_timers_started - i - 1) % NUM_TIMER_STATS;
 
 #if 1 //ndef FAST_TIMER_LOG
-		seq_printf(m, "div: %i freq: %i delay: %i"
-			   "\n",
+		seq_printf(m, "div: %i freq: %i delay: %i\n",
 			   timer_div_settings[cur],
 			   timer_freq_settings[cur],
 			   timer_delay_settings[cur]);
 #endif
 #ifdef FAST_TIMER_LOG
 		t = &timer_started_log[cur];
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 #endif
 	}
@@ -571,16 +570,15 @@ static int proc_fasttimer_show(struct se
 	seq_printf(m, "Timers added: %i\n", fast_timers_added);
 	for (i = 0; i < num_to_show; i++) {
 		t = &timer_added_log[(fast_timers_added - i - 1) % NUM_TIMER_STATS];
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 	}
 	seq_putc(m, '\n');
@@ -590,16 +588,15 @@ static int proc_fasttimer_show(struct se
 	seq_printf(m, "Timers expired: %i\n", fast_timers_expired);
 	for (i = 0; i < num_to_show; i++) {
 		t = &timer_expired_log[(fast_timers_expired - i - 1) % NUM_TIMER_STATS];
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 	}
 	seq_putc(m, '\n');
@@ -611,19 +608,15 @@ static int proc_fasttimer_show(struct se
 	while (t) {
 		nextt = t->next;
 		local_irq_restore(flags);
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-/*                      " func: 0x%08lX" */
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data
-/*                      , t->function */
-			       ) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 		local_irq_save(flags);
 		if (t->next != nextt)
diff -puN arch/cris/arch-v32/kernel/fasttimer.c~cris-fasttimer-remove-use-of-seq_printf-return-value arch/cris/arch-v32/kernel/fasttimer.c
--- a/arch/cris/arch-v32/kernel/fasttimer.c~cris-fasttimer-remove-use-of-seq_printf-return-value
+++ a/arch/cris/arch-v32/kernel/fasttimer.c
@@ -501,7 +501,8 @@ static int proc_fasttimer_show(struct se
 			i = debug_log_cnt;
 
 		while ((i != end_i || debug_log_cnt_wrapped)) {
-			if (seq_printf(m, debug_log_string[i], debug_log_value[i]) < 0)
+			seq_printf(m, debug_log_string[i], debug_log_value[i]);
+			if (seq_has_overflowed(m))
 				return 0;
 			i = (i+1) % DEBUG_LOG_MAX;
 		}
@@ -516,23 +517,21 @@ static int proc_fasttimer_show(struct se
 		int cur = (fast_timers_started - i - 1) % NUM_TIMER_STATS;
 
 #if 1 //ndef FAST_TIMER_LOG
-		seq_printf(m, "div: %i delay: %i"
-			   "\n",
+		seq_printf(m, "div: %i delay: %i\n",
 			   timer_div_settings[cur],
 			   timer_delay_settings[cur]);
 #endif
 #ifdef FAST_TIMER_LOG
 		t = &timer_started_log[cur];
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 #endif
 	}
@@ -544,16 +543,15 @@ static int proc_fasttimer_show(struct se
 	seq_printf(m, "Timers added: %i\n", fast_timers_added);
 	for (i = 0; i < num_to_show; i++) {
 		t = &timer_added_log[(fast_timers_added - i - 1) % NUM_TIMER_STATS];
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 	}
 	seq_putc(m, '\n');
@@ -563,16 +561,15 @@ static int proc_fasttimer_show(struct se
 	seq_printf(m, "Timers expired: %i\n", fast_timers_expired);
 	for (i = 0; i < num_to_show; i++){
 		t = &timer_expired_log[(fast_timers_expired - i - 1) % NUM_TIMER_STATS];
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 	}
 	seq_putc(m, '\n');
@@ -584,19 +581,15 @@ static int proc_fasttimer_show(struct se
 	while (t != NULL){
 		nextt = t->next;
 		local_irq_restore(flags);
-		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			       "d: %6li us data: 0x%08lX"
-/*			" func: 0x%08lX" */
-			       "\n",
-			       t->name,
-			       (unsigned long)t->tv_set.tv_jiff,
-			       (unsigned long)t->tv_set.tv_usec,
-			       (unsigned long)t->tv_expires.tv_jiff,
-			       (unsigned long)t->tv_expires.tv_usec,
-			       t->delay_us,
-			       t->data
-/*                      , t->function */
-			       ) < 0)
+		seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu d: %6li us data: 0x%08lX\n",
+			   t->name,
+			   (unsigned long)t->tv_set.tv_jiff,
+			   (unsigned long)t->tv_set.tv_usec,
+			   (unsigned long)t->tv_expires.tv_jiff,
+			   (unsigned long)t->tv_expires.tv_usec,
+			   t->delay_us,
+			   t->data);
+		if (seq_has_overflowed(m))
 			return 0;
 		local_irq_save(flags);
 		if (t->next != nextt)
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-correct-rtc-armada38x-pattern-entry.patch
hfsplus-fix-b-tree-corruption-after-insertion-at-position-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
adfs-returning-correct-return-values.patch
linux-next.patch

