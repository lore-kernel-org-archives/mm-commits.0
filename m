From: akpm@linux-foundation.org
Subject: + drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:41:05 -0700
Message-ID: <201003222341.o2MNf59Y001768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653Ab0CVXlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, ak@linux.intel.com, gregkh@suse.de, jbeulich@novell.com, sfr@canb.auug.org.au


The patch titled
     drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline
has been added to the -mm tree.  Its filename is
     drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch

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
Subject: drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline
From: "Jan Beulich" <JBeulich@novell.com>

Without CONFIG_CPUMASK_OFFSTACK, simply inverting cpu_online_mask leads
to CPUs beyond nr_cpu_ids to be displayed twice and CPUs not even
possible to be displayed as offline.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/cpu.c~drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline
+++ a/drivers/base/cpu.c
@@ -185,7 +185,7 @@ static ssize_t print_cpus_offline(struct
 	/* display offline cpus < nr_cpu_ids */
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
-	cpumask_complement(offline, cpu_online_mask);
+	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
 	n = cpulist_scnprintf(buf, len, offline);
 	free_cpumask_var(offline);
 
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch

