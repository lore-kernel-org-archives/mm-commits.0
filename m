From: akpm@linux-foundation.org
Subject: + console-flush-log-messages-for-more-cpu-hotplug-events.patch added to -mm tree
Date: Mon, 02 Aug 2010 15:44:39 -0700
Message-ID: <201008022244.o72MidQg015824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053Ab0HBWon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 18:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santosh.shilimkar@ti.com, cernekee@gmail.com


The patch titled
     console: flush log messages for more cpu-hotplug events
has been added to the -mm tree.  Its filename is
     console-flush-log-messages-for-more-cpu-hotplug-events.patch

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
Subject: console: flush log messages for more cpu-hotplug events
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>

When a secondary CPU is being brought up, it is not uncommon for printk()
to be invoked when cpu_online(smp_processor_id()) == 0.  The case that I
witnessed personally was on MIPS:

http://lkml.org/lkml/2010/5/30/4

If (can_use_console() == 0), printk() will spool its output to log_buf and
it will be visible in "dmesg", but that output will NOT be echoed to the
console until somebody calls release_console_sem() from a CPU that is
online.  Therefore, the boot time messages from the new CPU can get stuck
in "limbo" for a long time, and might suddenly appear on the screen when a
completely unrelated event (e.g.  "eth0: link is down") occurs.

This patch modifies the console code so that any pending messages are
automatically flushed out to the console whenever a CPU hotplug operation
completes successfully or aborts.

Cc: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/printk.c~console-flush-log-messages-for-more-cpu-hotplug-events kernel/printk.c
--- a/kernel/printk.c~console-flush-log-messages-for-more-cpu-hotplug-events
+++ a/kernel/printk.c
@@ -1003,6 +1003,9 @@ static int __cpuinit console_cpu_notify(
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+	case CPU_DYING:
+	case CPU_DOWN_FAILED:
 		acquire_console_sem();
 		release_console_sem();
 	}
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

linux-next.patch
console-flush-log-messages-for-more-cpu-hotplug-events.patch

