From: akpm@linux-foundation.org
Subject: [merged] acpi-sanity-check-_pss-frequency-to-prevent-cpufreq-crash.patch removed from -mm tree
Date: Thu, 28 May 2009 12:26:52 -0700
Message-ID: <200905281926.n4SJQq2W002544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbZE1T1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 15:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: len.brown@intel.com, venkatesh.pallipadi@intel.com, youquan.song@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: sanity check _PSS frequency to prevent cpufreq crash
has been removed from the -mm tree.  Its filename was
     acpi-sanity-check-_pss-frequency-to-prevent-cpufreq-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: sanity check _PSS frequency to prevent cpufreq crash
From: Len Brown <len.brown@intel.com>

When BIOS SETUP is changed to disable EIST, some BIOS hand the OS an
un-initialized _PSS:

        Name (_PSS, Package (0x06)
        {
            Package (0x06)
            {
                0x80000000,	// frequency [MHz]
                0x80000000,	// power [mW]
                0x80000000,	// latency [us]
                0x80000000,	// BM latency [us]
                0x80000000,	// control
                0x80000000	// status
            },
	    ...

These are outrageous values for frequency, power and latency, raising the
question where to draw the line between legal and illegal.  We tend to
survive garbage in the power and latency fields, but we can BUG_ON when
garbage is in the frequency field.

Cpufreq multiplies the frequency by 1000 and stores it in a u32 KHz.  So
disregard a _PSS with a frequency so large that it can't be represented by
cpufreq.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=500311

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Youquan, Song <youquan.song@intel.com>
Cc: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_perflib.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_perflib.c~acpi-sanity-check-_pss-frequency-to-prevent-cpufreq-crash drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~acpi-sanity-check-_pss-frequency-to-prevent-cpufreq-crash
+++ a/drivers/acpi/processor_perflib.c
@@ -309,9 +309,13 @@ static int acpi_processor_get_performanc
 				  (u32) px->bus_master_latency,
 				  (u32) px->control, (u32) px->status));
 
-		if (!px->core_frequency) {
-			printk(KERN_ERR PREFIX
-				    "Invalid _PSS data: freq is zero\n");
+		/*
+ 		 * Check that ACPI's u64 MHz will be valid as u32 KHz in cpufreq
+		 */
+		if (!px->core_frequency ||
+			((u32)(px->core_frequency * 1000) != (px->core_frequency * 1000))) {
+			printk(KERN_ERR FW_BUG PREFIX
+				    "Invalid BIOS _PSS frequency: 0x%llx MHz\n", px->core_frequency);
 			result = -EFAULT;
 			kfree(pr->performance->states);
 			goto end;
_

Patches currently in -mm which might be from len.brown@intel.com are

origin.patch
linux-next.patch
dell-laptop-fix-uninitialized-wrong-return-value.patch
dell-wmi-mask-off-bis-provided-garbage-in-scancode-data.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch

