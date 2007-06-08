From: akpm@linux-foundation.org
Subject: + cpuidle-first-round-of-documentation-updates.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:49:04 -0700
Message-ID: <200706080049.l580n4x8014062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966210AbXFHAtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: first round of documentation updates
has been added to the -mm tree.  Its filename is
     cpuidle-first-round-of-documentation-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuidle: first round of documentation updates
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Documentation changes based on Pavel's feedback.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpuidle/core.txt     |    2 +-
 Documentation/cpuidle/driver.txt   |   15 ++++++++++-----
 Documentation/cpuidle/governor.txt |   12 ++++++++----
 Documentation/cpuidle/sysfs.txt    |   18 +++++++++++++-----
 4 files changed, 32 insertions(+), 15 deletions(-)

diff -puN Documentation/cpuidle/core.txt~cpuidle-first-round-of-documentation-updates Documentation/cpuidle/core.txt
--- a/Documentation/cpuidle/core.txt~cpuidle-first-round-of-documentation-updates
+++ a/Documentation/cpuidle/core.txt
@@ -12,6 +12,6 @@ idle policy (governor) from idle mechani
 standardized infrastructure to support independent development of
 governors and drivers.
 
-cpuidle resides under /drivers/cpuidle.
+cpuidle resides under drivers/cpuidle.
 
 
diff -puN Documentation/cpuidle/driver.txt~cpuidle-first-round-of-documentation-updates Documentation/cpuidle/driver.txt
--- a/Documentation/cpuidle/driver.txt~cpuidle-first-round-of-documentation-updates
+++ a/Documentation/cpuidle/driver.txt
@@ -7,16 +7,21 @@
 
 
 
-cpuidle driver supports capability detection for a particular system. The
-init and exit routines will be called for each online CPU, with a percpu
-cpuidle_driver object and driver should fill in cpuidle_states inside
-cpuidle_driver depending on the CPU capability.
+cpuidle driver hooks into the cpuidle infrastructure and does the
+architecture/platform dependent part of CPU idle states. Driver
+provides the platform idle state detection capability and also
+has mechanisms in place to support actusl entry-exit into a CPU idle state.
+
+cpuidle driver supports capability detection for a platform using the
+init and exit routines. They will be called for each online CPU, with a
+percpu cpuidle_driver object and driver should fill in cpuidle_states
+inside cpuidle_driver depending on the CPU capability.
 
 Driver can handle dynamic state changes (like battery<->AC), by calling
 force_redetect interface.
 
 It is possible to have more than one driver registered at the same time and
-user can switch between drivers using /sysfs interface.
+user can switch between drivers using /sysfs interface (when enabled).
 
 Interfaces:
 int cpuidle_register_driver(struct cpuidle_driver *drv);
diff -puN Documentation/cpuidle/governor.txt~cpuidle-first-round-of-documentation-updates Documentation/cpuidle/governor.txt
--- a/Documentation/cpuidle/governor.txt~cpuidle-first-round-of-documentation-updates
+++ a/Documentation/cpuidle/governor.txt
@@ -11,12 +11,16 @@
 cpuidle governor is policy routine that decides what idle state to enter at
 any given time. cpuidle core uses different callbacks to governor while
 handling idle entry.
-* select_state callback where governor can determine next idle state to enter
-* prepare_idle callback is called before entering an idle state
-* scan callback is called after a driver forces redetection of the states
+* select_state() callback where governor can determine next idle state to enter
+* prepare_idle() callback is called before entering an idle state
+* scan() callback is called after a driver forces redetection of the states
 
 More than one governor can be registered at the same time and
-user can switch between drivers using /sysfs interface.
+user can switch between drivers using /sysfs interface (when supported).
+
+More than one governor part is supported for developers to easily experiment
+with different governors. By default, most optimal governor based on your
+kernel configuration and platform will be selected by cpuidle.
 
 Interfaces:
 int cpuidle_register_governor(struct cpuidle_governor *gov);
diff -puN Documentation/cpuidle/sysfs.txt~cpuidle-first-round-of-documentation-updates Documentation/cpuidle/sysfs.txt
--- a/Documentation/cpuidle/sysfs.txt~cpuidle-first-round-of-documentation-updates
+++ a/Documentation/cpuidle/sysfs.txt
@@ -4,14 +4,22 @@
 
 				cpuidle sysfs
 
-System global cpuidle information are under
+System global cpuidle related information and tunables are under
 /sys/devices/system/cpu/cpuidle
 
 The current interfaces in this directory has self-explanatory names:
+* current_driver_ro
+* current_governor_ro
+
+With cpuidle_sysfs_switch boot option (meant for developer testing)
+following objects are visible instead.
 * available_drivers
 * available_governors
 * current_driver
 * current_governor
+In this case user can switch the driver, governor at run time by writing
+onto current_driver and current_governor.
+
 
 Per logical CPU specific cpuidle information are under
 /sys/devices/system/cpu/cpuX/cpuidle
@@ -19,9 +27,9 @@ for each online cpu X
 
 Under this percpu directory, there is a directory for each idle state supported
 by the driver, which in turn has
-* latency
-* power
-* time
-* usage
+* latency : Latency to exit out of this idle state (in microseconds)
+* power : Power consumed while in this idle state (in milliwatts)
+* time : Total time spent in this idle state (in microseconds)
+* usage : Number of times this state was entered (count)
 
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
