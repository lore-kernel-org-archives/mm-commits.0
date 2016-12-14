From: akpm@linux-foundation.org
Subject: [patch 002/114] kernel/watchdog: use nmi registers snapshot in
 hardlockup handler
Date: Wed, 14 Dec 2016 15:04:04 -0800
Message-ID: <5851cfe4.ENYe5LTfUKjK7L0Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbcLNXEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, khlebnikov@yandex-team.ru, atomlin@redhat.com, jkosina@suse.cz, stable@vger.kernel.org, uobergfe@redhat.com

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: kernel/watchdog: use nmi registers snapshot in hardlockup handler

NMI handler doesn't call set_irq_regs(), it's set only by normal IRQ. 
Thus get_irq_regs() returns NULL or stale registers snapshot with IP/SP
pointing to the code interrupted by IRQ which was interrupted by NMI. 
NULL isn't a problem: in this case watchdog calls dump_stack() and
prints full stack trace including NMI.  But if we're stuck in IRQ
handler then NMI watchlog will print stack trace without IRQ part at
all.

This patch uses registers snapshot passed into NMI handler as arguments:
these registers point exactly to the instruction interrupted by NMI.

Fixes: 55537871ef66 ("kernel/watchdog.c: perform all-CPU backtrace in case of hard lockup")
Link: http://lkml.kernel.org/r/146771764784.86724.6006627197118544150.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: <stable@vger.kernel.org>	[4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler
+++ a/kernel/watchdog.c
@@ -344,7 +344,6 @@ static void watchdog_overflow_callback(s
 	 */
 	if (is_hardlockup()) {
 		int this_cpu = smp_processor_id();
-		struct pt_regs *regs = get_irq_regs();
 
 		/* only print hardlockups once */
 		if (__this_cpu_read(hard_watchdog_warn) == true)
_
