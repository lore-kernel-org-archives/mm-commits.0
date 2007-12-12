From: akpm@linux-foundation.org
Subject: + acpi-sbs-return-rate-in-mw-if-capacity-in-mwh.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:44:39 -0800
Message-ID: <200712120544.lBC5idek028091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452AbXLLFpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     ACPI: SBS: Return rate in mW if capacity in mWh
has been added to the -mm tree.  Its filename is
     acpi-sbs-return-rate-in-mw-if-capacity-in-mwh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: SBS: Return rate in mW if capacity in mWh
From: Alexey Starikovskiy <astarikovskiy@suse.de>

klaptopd assumes rate to be in same units as capacity.

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9362

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-sbs-return-rate-in-mw-if-capacity-in-mwh drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-sbs-return-rate-in-mw-if-capacity-in-mwh
+++ a/drivers/acpi/sbs.c
@@ -533,7 +533,7 @@ static struct proc_dir_entry *acpi_batte
 
 static inline char *acpi_battery_units(struct acpi_battery *battery)
 {
-	return acpi_battery_mode(battery) ? " mWh" : " mAh";
+	return acpi_battery_mode(battery) ? " mW" : " mA";
 }
 
 
@@ -550,10 +550,10 @@ static int acpi_battery_read_info(struct
 	if (!battery->present)
 		goto end;
 
-	seq_printf(seq, "design capacity:         %i%s\n",
+	seq_printf(seq, "design capacity:         %i%sh\n",
 		   battery->design_capacity * acpi_battery_scale(battery),
 		   acpi_battery_units(battery));
-	seq_printf(seq, "last full capacity:      %i%s\n",
+	seq_printf(seq, "last full capacity:      %i%sh\n",
 		   battery->full_charge_capacity * acpi_battery_scale(battery),
 		   acpi_battery_units(battery));
 	seq_printf(seq, "battery technology:      rechargeable\n");
@@ -584,7 +584,7 @@ static int acpi_battery_read_state(struc
 {
 	struct acpi_battery *battery = seq->private;
 	struct acpi_sbs *sbs = battery->sbs;
-	int result = 0;
+	int rate;
 
 	mutex_lock(&sbs->lock);
 	seq_printf(seq, "present:                 %s\n",
@@ -598,9 +598,12 @@ static int acpi_battery_read_state(struc
 	seq_printf(seq, "charging state:          %s\n",
 		   (battery->current_now < 0) ? "discharging" :
 		   ((battery->current_now > 0) ? "charging" : "charged"));
-	seq_printf(seq, "present rate:            %d mA\n",
-		   abs(battery->current_now) * acpi_battery_ipscale(battery));
-	seq_printf(seq, "remaining capacity:      %i%s\n",
+	rate = abs(battery->current_now) * acpi_battery_ipscale(battery);
+	rate *= (acpi_battery_mode(battery))?(battery->voltage_now *
+			acpi_battery_vscale(battery)/1000):1;
+	seq_printf(seq, "present rate:            %d%s\n", rate,
+		   acpi_battery_units(battery));
+	seq_printf(seq, "remaining capacity:      %i%sh\n",
 		   battery->capacity_now * acpi_battery_scale(battery),
 		   acpi_battery_units(battery));
 	seq_printf(seq, "present voltage:         %i mV\n",
@@ -608,7 +611,7 @@ static int acpi_battery_read_state(struc
 
       end:
 	mutex_unlock(&sbs->lock);
-	return result;
+	return 0;
 }
 
 static int acpi_battery_state_open_fs(struct inode *inode, struct file *file)
@@ -632,7 +635,7 @@ static int acpi_battery_read_alarm(struc
 	acpi_battery_get_alarm(battery);
 	seq_printf(seq, "alarm:                   ");
 	if (battery->alarm_capacity)
-		seq_printf(seq, "%i%s\n",
+		seq_printf(seq, "%i%sh\n",
 			   battery->alarm_capacity *
 			   acpi_battery_scale(battery),
 			   acpi_battery_units(battery));
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

git-acpi.patch
acpi-sbs-reset-alarm-bit.patch
acpi-sbs-ignore-alarms-coming-from-unknown-devices.patch
acpi-sbs-return-rate-in-mw-if-capacity-in-mwh.patch
