From: akpm@linux-foundation.org
Subject: - i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp.patch removed from -mm tree
Date: Tue, 29 May 2007 11:52:32 -0700
Message-ID: <200705291852.l4TIqVFO008414@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758396AbXE2SxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     i386, x86-64: show that CONFIG_HOTPLUG_CPU is required for suspend on SMP
has been removed from the -mm tree.  Its filename was
     i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386, x86-64: show that CONFIG_HOTPLUG_CPU is required for suspend on SMP
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

It's not sufficiently documented that CONFIG_HOTPLUG_CPU is required for
suspend/hibernation on SMP.

Point out the non-obvious.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig   |    2 +-
 arch/x86_64/Kconfig |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/i386/Kconfig~i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp arch/i386/Kconfig
--- a/arch/i386/Kconfig~i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp
+++ a/arch/i386/Kconfig
@@ -891,7 +891,7 @@ config PHYSICAL_ALIGN
 	  Don't change this unless you know what you are doing.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
+	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
 	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
diff -puN arch/x86_64/Kconfig~i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~i386-x86-64-show-that-config_hotplug_cpu-is-required-for-suspend-on-smp
+++ a/arch/x86_64/Kconfig
@@ -428,12 +428,15 @@ config NR_CPUS
 	  memory in the static kernel configuration.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
+	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
 	depends on SMP && HOTPLUG && EXPERIMENTAL
 	help
 		Say Y here to experiment with turning CPUs off and on.  CPUs
 		can be controlled through /sys/devices/system/cpu/cpu#.
-		Say N if you want to disable CPU hotplug.
+		This is also required for suspend/hibernation on SMP systems.
+
+		Say N if you want to disable CPU hotplug and don't need to
+		suspend.
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

git-ieee1394.patch
git-scsi-misc.patch
