From: akpm@linux-foundation.org
Subject: [merged] cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:51 -0800
Message-ID: <20130225205051.DF5B35A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49152 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:53 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so346953ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lenb@kernel.org, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu-hotplug, memory-hotplug: try offlining the node when hotremoving a cpu
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: cpu-hotplug, memory-hotplug: try offlining the node when hotremoving a cpu

The node will be offlined when all memory/cpu on the node is hotremoved. 
So we should try offline the node when hotremoving a cpu on the node.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_driver.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/processor_driver.c~cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu drivers/acpi/processor_driver.c
--- a/drivers/acpi/processor_driver.c~cpu-hotplug-memory-hotplug-try-offline-the-node-when-hotremoving-a-cpu
+++ a/drivers/acpi/processor_driver.c
@@ -45,6 +45,7 @@
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/memory_hotplug.h>
 
 #include <asm/io.h>
 #include <asm/cpu.h>
@@ -641,6 +642,7 @@ static int acpi_processor_remove(struct 
 
 	per_cpu(processors, pr->id) = NULL;
 	per_cpu(processor_device_array, pr->id) = NULL;
+	try_offline_node(cpu_to_node(pr->id));
 
 free:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

