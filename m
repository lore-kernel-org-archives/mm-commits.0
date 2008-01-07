From: akpm@linux-foundation.org
Subject: + reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case.patch added to -mm tree
Date: Sun, 06 Jan 2008 23:18:57 -0800
Message-ID: <200801070718.m077IbME014020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYAGHTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 02:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, arjan@infradead.org, lenb@kernel.org, lkml@rtr.ca, mingo@elte.hu, rjw@sisk.pl


The patch titled
     Reintroduce run time configurable max_cstate for !CPU_IDLE case
has been added to the -mm tree.  Its filename is
     reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Reintroduce run time configurable max_cstate for !CPU_IDLE case
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

This was writeable in 2.6.23 but the cpuidle merge made it read-only.  But
some people's scripts (ie: Mark's) were writing to it.

As an unhappy compromise, make max_cstate writeable again if the kernel was
configured without CONFIG_CPU_IDLE.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Mark Lord <lkml@rtr.ca>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/acpi/processor_idle.c~reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case
+++ a/drivers/acpi/processor_idle.c
@@ -76,7 +76,11 @@ static void (*pm_idle_save) (void) __rea
 #define PM_TIMER_TICKS_TO_US(p)		(((p) * 1000)/(PM_TIMER_FREQUENCY/1000))
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
+#ifdef CONFIG_CPU_IDLE
 module_param(max_cstate, uint, 0000);
+#else
+module_param(max_cstate, uint, 0644);
+#endif
 static unsigned int nocst __read_mostly;
 module_param(nocst, uint, 0000);
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case.patch
git-cpufreq.patch
git-x86.patch
cpufreq-initialise-default-governor-before-use.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
pm-qos-remove-locks-around-blocking-notifier.patch
