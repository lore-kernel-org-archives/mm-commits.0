From: akpm@linux-foundation.org
Subject: + cpuidle-take2-basic-documentation-for-cpuidle.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:53:32 -0800
Message-ID: <200702272053.l1RKra11028190@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51552 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXB0Uy6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, abelay@novell.com, ak@suse.de, davej@codemonkey.org.uk, lenb@kernel.org, shaohua.li@intel.com


The patch titled
     cpuidle take2: Basic documentation for cpuidle
has been added to the -mm tree.  Its filename is
     cpuidle-take2-basic-documentation-for-cpuidle.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuidle take2: Basic documentation for cpuidle
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Documentation for cpuidle infrastructure

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Adam Belay <abelay@novell.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpuidle/core.txt     |   17 +++++++++++++++++
 Documentation/cpuidle/driver.txt   |   24 ++++++++++++++++++++++++
 Documentation/cpuidle/governor.txt |   24 ++++++++++++++++++++++++
 Documentation/cpuidle/sysfs.txt    |   27 +++++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

diff -puN /dev/null Documentation/cpuidle/core.txt
--- /dev/null
+++ a/Documentation/cpuidle/core.txt
@@ -0,0 +1,17 @@
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle
+
+General Information:
+
+Various CPUs today support multiple idle levels that are differentiated
+by varying exit latencies and power consumption during idle.
+cpuidle is a generic in-kernel infrastructure that separates
+idle policy (governor) from idle mechanism (driver) and provides a
+standardized infrastructure to support independent development of
+governors and drivers.
+
+cpuidle resides under /drivers/cpuidle.
+
+
diff -puN /dev/null Documentation/cpuidle/driver.txt
--- /dev/null
+++ a/Documentation/cpuidle/driver.txt
@@ -0,0 +1,24 @@
+
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle drivers
+
+
+
+
+cpuidle driver supports capability detection for a particular system. The
+init and exit routines will be called for each online CPU, with a percpu
+cpuidle_driver object and driver should fill in cpuidle_states inside
+cpuidle_driver depending on the CPU capability.
+
+Driver can handle dynamic state changes (like battery<->AC), by calling
+force_redetect interface.
+
+It is possible to have more than one driver registered at the same time and
+user can switch between drivers using /sysfs interface.
+
+Interfaces:
+int cpuidle_register_driver(struct cpuidle_driver *drv);
+void cpuidle_unregister_driver(struct cpuidle_driver *drv);
+int cpuidle_force_redetect(struct cpuidle_device *dev);
diff -puN /dev/null Documentation/cpuidle/governor.txt
--- /dev/null
+++ a/Documentation/cpuidle/governor.txt
@@ -0,0 +1,24 @@
+
+
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle governors
+
+
+
+
+cpuidle governor is policy routine that decides what idle state to enter at
+any given time. cpuidle core uses different callbacks to governor while
+handling idle entry.
+* select_state callback where governor can determine next idle state to enter
+* prepare_idle callback is called before entering an idle state
+* scan callback is called after a driver forces redetection of the states
+
+More than one governor can be registered at the same time and
+user can switch between drivers using /sysfs interface.
+
+Interfaces:
+int cpuidle_register_governor(struct cpuidle_governor *gov);
+void cpuidle_unregister_governor(struct cpuidle_governor *gov);
+
diff -puN /dev/null Documentation/cpuidle/sysfs.txt
--- /dev/null
+++ a/Documentation/cpuidle/sysfs.txt
@@ -0,0 +1,27 @@
+
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle sysfs
+
+System global cpuidle information are under
+/sys/devices/system/cpu/cpuidle
+
+The current interfaces in this directory has self-explanatory names:
+* available_drivers
+* available_governors
+* current_driver
+* current_governor
+
+Per logical CPU specific cpuidle information are under
+/sys/devices/system/cpu/cpuX/cpuidle
+for each online cpu X
+
+Under this percpu directory, there is a directory for each idle state supported
+by the driver, which in turn has
+* latency
+* power
+* time
+* usage
+
+
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

cpuidle-take2-core-cpuidle-infrastructure.patch
cpuidle-take2-hookup-acpi-c-states-driver-with-cpuidle.patch
cpuidle-take2-basic-documentation-for-cpuidle.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
