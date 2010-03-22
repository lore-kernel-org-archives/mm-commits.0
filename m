From: akpm@linux-foundation.org
Subject: + x86-nosmp-command-line-option-should-force-the-system-into-up-mode.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:52:16 -0700
Message-ID: <201003222352.o2MNqGq9002253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab0CVXwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:52:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: "nosmp" command line option should force the  system into UP mode
has been added to the -mm tree.  Its filename is
     x86-nosmp-command-line-option-should-force-the-system-into-up-mode.patch

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
Subject: x86: "nosmp" command line option should force the  system into UP mode
From: "Jan Beulich" <JBeulich@novell.com>

Bits set in cpu_possible_mask prior to the execution of
prefill_possible_map() (i.e.  when parsing ACPI or MPS tables) would
prevent the SMP alternatives logic from switching to UP mode, plus
unnecessary setup of per-CPU data for CPUs that can never come online.

Additionally, without CONFIG_HOTPLUG_CPU disabled CPUs can never come
online, and hence setting cpu_possible_mask bits for them is again a
simple waste of resources.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~x86-nosmp-command-line-option-should-force-the-system-into-up-mode arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~x86-nosmp-command-line-option-should-force-the-system-into-up-mode
+++ a/arch/x86/kernel/smpboot.c
@@ -1214,9 +1214,17 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
-	else
+	i = setup_max_cpus ?: 1;
+	if (setup_possible_cpus == -1) {
+		possible = num_processors;
+#ifdef CONFIG_HOTPLUG_CPU
+		if (setup_max_cpus)
+			possible += disabled_cpus;
+#else
+		if (possible > i)
+			possible = i;
+#endif
+	} else
 		possible = setup_possible_cpus;
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
@@ -1229,11 +1237,23 @@ __init void prefill_possible_map(void)
 		possible = nr_cpu_ids;
 	}
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if (!setup_max_cpus)
+#endif
+	if (possible > i) {
+		printk(KERN_WARNING
+			"%d Processors exceeds max_cpus limit of %u\n",
+			possible, setup_max_cpus);
+		possible = i;
+	}
+
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));
 
 	for (i = 0; i < possible; i++)
 		set_cpu_possible(i, true);
+	for (; i < NR_CPUS; i++)
+		set_cpu_possible(i, false);
 
 	nr_cpu_ids = possible;
 }
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch
x86-nosmp-command-line-option-should-force-the-system-into-up-mode.patch

