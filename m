From: akpm@linux-foundation.org
Subject: [merged] drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:56:43 -0400
Message-ID: <201004292058.o3TKwFVf011777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649Ab0D3RJ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, ak@linux.intel.com, gregkh@suse.de, jbeulich@novell.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline
has been removed from the -mm tree.  Its filename was
     drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -186,7 +186,7 @@ static ssize_t print_cpus_offline(struct
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
x86-nosmp-command-line-option-should-force-the-system-into-up-mode.patch

