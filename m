From: akpm@linux-foundation.org
Subject: [merged] drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:23 -0800
Message-ID: <201002182045.o1IKjNEQ002731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab0BRUqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, achiang@hp.com, akwatts@ymail.com, bjorn.helgaas@hp.com, jimis@gmx.net, lenb@kernel.org, ming.m.lin@intel.com, rjw@sisk.pl, stable@kernel.org, venkatesh.pallipa


The patch titled
     drivers/acpi/processor_idle.c: add two laptops to the C-state DMI table
has been removed from the -mm tree.  Its filename was
     drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/acpi/processor_idle.c: add two laptops to the C-state DMI table
From: Arjan van de Ven <arjan@linux.intel.com>

Since the rewrite of the CPU idle governor in 2.6.32, two laptops have
surfaced where the BIOS advertises a C2 power state, but for some reason
this state is not functioning (as verified in both cases by powertop
before the patch in .32).

The old governor had the accidental behavior that if a non-working state
was chosen too many times, it would end up falling back to C1.  The new
governor works differently and this accidental behavior is no longer
there; the result is a high temperature on these two machines.

This patch adds these 2 machines to the DMI table for C state anomalies;
by just not using C2 both these machines are better off (the TSC can be
used instead of the pm timer, giving a performance boost for example).

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14742

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Reported-by: <akwatts@ymail.com>
Cc: Dimitrios Apostolou <jimis@gmx.net>
Cc: Alex Chiang <achiang@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/acpi/processor_idle.c~drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table
+++ a/drivers/acpi/processor_idle.c
@@ -110,6 +110,14 @@ static struct dmi_system_id __cpuinitdat
 	  DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"SHE845M0.86C.0013.D.0302131307")},
 	 (void *)2},
+	{ set_max_cstate, "Pavilion zv5000", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"Pavilion zv5000 (DS502A#ABA)")},
+	 (void *)1},
+	{ set_max_cstate, "Asus L8400B", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
+	 (void *)1},
 	{},
 };
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
timers-introduce-the-concept-of-timer-slack-for-legacy-timers.patch
cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch

