From: akpm@linux-foundation.org
Subject: [merged]
 mm-hotplug-x86-disable-arch_memory_probe-by-default.patch removed from -mm
 tree
Date: Wed, 31 Jul 2013 11:30:58 -0700
Message-ID: <51f957e2.9ThdkT/a3fNVurKc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab3GaSa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jul 2013 14:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, dave@sr71.net, toshi.kani@hp.com

Subject: [merged] mm-hotplug-x86-disable-arch_memory_probe-by-default.patch removed from -mm tree
To: toshi.kani@hp.com,dave@sr71.net,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mingo@elte.hu,tangchen@cn.fujitsu.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 31 Jul 2013 11:30:58 -0700


The patch titled
     Subject: mm/hotplug, x86: disable ARCH_MEMORY_PROBE by default
has been removed from the -mm tree.  Its filename was
     mm-hotplug-x86-disable-arch_memory_probe-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm/hotplug, x86: disable ARCH_MEMORY_PROBE by default

CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
interface, which allows a given memory address to be hot-added as follows.
 (See Documentation/memory-hotplug.txt for more detail.)

# echo start_address_of_new_memory > /sys/devices/system/memory/probe

This probe interface is required on powerpc.  On x86, however, ACPI
notifies a memory hotplug event to the kernel, which performs its hotplug
operation as the result.  Therefore, regular users do not need this
interface on x86.  This probe interface is also error-prone and misleading
that the kernel blindly adds a given memory address without checking if
the memory is present on the system; no probing is done despite of its
name.  The kernel crashes when a user requests to online a memory block
that is not present on the system.  This interface is currently used for
testing as it can fake a hotplug event.

This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86, adds its
Kconfig menu entry on x86, and clarifies its use in Documentation/
memory-hotplug.txt.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   14 ++++++++------
 arch/x86/Kconfig                 |    7 ++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff -puN Documentation/memory-hotplug.txt~mm-hotplug-x86-disable-arch_memory_probe-by-default Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~mm-hotplug-x86-disable-arch_memory_probe-by-default
+++ a/Documentation/memory-hotplug.txt
@@ -210,13 +210,15 @@ If memory device is found, memory hotplu
 
 4.2 Notify memory hot-add event by hand
 ------------
-In some environments, especially virtualized environment, firmware will not
-notify memory hotplug event to the kernel. For such environment, "probe"
-interface is supported. This interface depends on CONFIG_ARCH_MEMORY_PROBE.
+On powerpc, the firmware does not notify a memory hotplug event to the kernel.
+Therefore, "probe" interface is supported to notify the event to the kernel.
+This interface depends on CONFIG_ARCH_MEMORY_PROBE.
 
-Now, CONFIG_ARCH_MEMORY_PROBE is supported only by powerpc but it does not
-contain highly architecture codes. Please add config if you need "probe"
-interface.
+CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
+option is disabled by default since ACPI notifies a memory hotplug event to
+the kernel, which performs its hotplug operation as the result. Please
+enable this option if you need the "probe" interface for testing purposes
+on x86.
 
 Probe interface is located at
 /sys/devices/system/memory/probe
diff -puN arch/x86/Kconfig~mm-hotplug-x86-disable-arch_memory_probe-by-default arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-hotplug-x86-disable-arch_memory_probe-by-default
+++ a/arch/x86/Kconfig
@@ -1344,8 +1344,13 @@ config ARCH_SELECT_MEMORY_MODEL
 	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
-	def_bool y
+	bool "Enable sysfs memory/probe interface"
+	default n
 	depends on X86_64 && MEMORY_HOTPLUG
+	help
+	  This option enables a sysfs memory/probe interface for testing.
+	  See Documentation/memory-hotplug.txt for more information.
+	  If you are unsure how to answer this question, answer N.
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch

