From: akpm@linux-foundation.org
Subject: [wrecked] timer-print-function-name-for-timer-callbacks-modifying-preemption-count.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:35:38 -0400
Message-ID: <201004151837.o3FIbGAO024195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab0DOSiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer: print function name for timer callbacks modifying preemptio=
n count
has been removed from the -mm tree.  Its filename was
     timer-print-function-name-for-timer-callbacks-modifying-preemption=
-count.patch

This patch was dropped because other changes were merged, which wrecked=
 this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: timer: print function name for timer callbacks modifying preem=
ption count
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A function scheduled with a timer must not exit with a different preemp=
t
count than it was entered.  To make helping users running into the
corresponding BUG() easier also print the name of the bad function not
only its address.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/timer.c~timer-print-function-name-for-timer-callbacks-=
modifying-preemption-count kernel/timer.c
--- a/kernel/timer.c~timer-print-function-name-for-timer-callbacks-modi=
fying-preemption-count
+++ a/kernel/timer.c
@@ -1085,10 +1085,10 @@ static inline void __run_timers(struct t
 				lock_map_release(&lockdep_map);
=20
 				if (preempt_count !=3D preempt_count()) {
-					printk(KERN_ERR "huh, entered %p "
+					printk(KERN_ERR "huh, entered %p (%pF)"
 					       "with preempt_count %08x, exited"
 					       " with %08x?\n",
-					       fn, preempt_count,
+					       fn, fn, preempt_count,
 					       preempt_count());
 					BUG();
 				}
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
gpiolib-make-names-array-and-its-values-const.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
gpiolib-a-gpio-is-unsigned-so-use-%u-to-print-it.patch
gpiolib-document-that-names-can-contain-printk-format-specifiers.patch
fbdev-section-cleanup-in-arcfb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
