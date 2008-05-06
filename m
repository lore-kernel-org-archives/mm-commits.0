From: akpm@linux-foundation.org
Subject: + uml-fix-bad-ntp-interaction-with-clock.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:27 -0700
Message-ID: <200805062049.m46KnRhs026582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760824AbYEFUtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: fix bad NTP interaction with clock
has been added to the -mm tree.  Its filename is
     uml-fix-bad-ntp-interaction-with-clock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix bad NTP interaction with clock
From: Jeff Dike <jdike@addtoit.com>

UML's supposed nanosecond clock interacts badly with NTP when NTP
decides that the clock has drifted ahead and needs to be slowed down.
Slowing down the clock is done by decrementing the cycle-to-nanosecond
multiplier, which is 1.  Decrementing that gives you 0 and time is
stopped.

This is fixed by switching to a microsecond clock, with a multiplier
of 1000.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/time.c~uml-fix-bad-ntp-interaction-with-clock arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-fix-bad-ntp-interaction-with-clock
+++ a/arch/um/kernel/time.c
@@ -75,7 +75,7 @@ static irqreturn_t um_timer(int irq, voi
 
 static cycle_t itimer_read(void)
 {
-	return os_nsecs();
+	return os_nsecs() / 1000;
 }
 
 static struct clocksource itimer_clocksource = {
@@ -83,7 +83,7 @@ static struct clocksource itimer_clockso
 	.rating		= 300,
 	.read		= itimer_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1,
+	.mult		= 1000,
 	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

