From: akpm@linux-foundation.org
Subject: +
 kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler.patch
 added to -mm tree
Date: Fri, 08 Jul 2016 14:03:09 -0700
Message-ID: <5780150d.KQdmiSu2SLjTHWaQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbcGHVDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, atomlin@redhat.com, jkosina@suse.cz, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: use nmi registers snapshot in hardlockup handler
has been added to the -mm tree.  Its filename is
     kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: kernel/watchdog: use nmi registers snapshot in hardlockup handler

NMI handler doesn't call set_irq_regs(), so get_irq_regs() returns NULL or
stale snapshot from beginning of IRQ interrupted by NMI.  Registers from
argument are always here and points to interrupted instruction and state.

Link: http://lkml.kernel.org/r/146771764784.86724.6006627197118544150.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
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

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-use-nmi-registers-snapshot-in-hardlockup-handler.patch

