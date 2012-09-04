From: akpm@linux-foundation.org
Subject: + x86-numa-dont-check-if-node-is-numa_no_node.patch added to -mm tree
Date: Tue, 04 Sep 2012 16:11:12 -0700
Message-ID: <20120904231113.2C53F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36154 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2IDXLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 19:11:16 -0400
Received: by wgbdt11 with SMTP id dt11so375879wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 16:11:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, hpa@zytor.com, len.brown@intel.com, mingo@redhat.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     Subject: x86 numa: don't check if node is NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     x86-numa-dont-check-if-node-is-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: x86 numa: don't check if node is NUMA_NO_NODE

If we aren't debugging per_cpu maps, the cpu's node is stored in per_cpu
variable numa_node.  If `node' is NUMA_NO_NODE, it means the caller wants
to clear the cpu's node.  So we should also call set_cpu_numa_node() in
this case.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/mm/numa.c~x86-numa-dont-check-if-node-is-numa_no_node arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-numa-dont-check-if-node-is-numa_no_node
+++ a/arch/x86/mm/numa.c
@@ -97,8 +97,7 @@ void __cpuinit numa_set_node(int cpu, in
 #endif
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
-	if (node != NUMA_NO_NODE)
-		set_cpu_numa_node(cpu, node);
+	set_cpu_numa_node(cpu, node);
 }
 
 void __cpuinit numa_clear_node(int cpu)
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch

