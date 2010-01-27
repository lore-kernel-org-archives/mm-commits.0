From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-add-the-hp-pavilion-zv5000-to-the-power-dmi-table.patch removed from -mm tree
Date: Wed, 27 Jan 2010 15:23:56 -0800
Message-ID: <201001272323.o0RNNu10006402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209Ab0A0XYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:24:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, akwatts@ymail.com, arjan@linux.intel.com, lenb@kernel.org, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: add the HP Pavilion zv5000 to the power DMI table
has been removed from the -mm tree.  Its filename was
     acpi-add-the-hp-pavilion-zv5000-to-the-power-dmi-table.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add the HP Pavilion zv5000 to the power DMI table
From: Arjan van de Ven <arjan@infradead.org>

The HP Pavilion zv5000 is reported to not work well in C2; in fact the
system exits C2 immediately.

This patch adds a DMI entry for this system so that C2 is not used on this
machine.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14742

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Reported-by: <akwatts@ymail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/acpi/processor_idle.c~acpi-add-the-hp-pavilion-zv5000-to-the-power-dmi-table drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-add-the-hp-pavilion-zv5000-to-the-power-dmi-table
+++ a/drivers/acpi/processor_idle.c
@@ -110,6 +110,10 @@ static struct dmi_system_id __cpuinitdat
 	  DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"SHE845M0.86C.0013.D.0302131307")},
 	 (void *)2},
+	{ set_max_cstate, "Pavilion zv5000", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"Pavilion zv5000 (DS502A#ABA)")},
+	 (void *)1},
 	{},
 };
 
_

Patches currently in -mm which might be from arjan@infradead.org are

acpi-add-the-hp-pavilion-zv5000-to-the-power-dmi-table.patch
checkpatchpl-extend-list-of-expected-to-be-const-structures.patch

