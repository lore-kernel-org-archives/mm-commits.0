From: akpm@linux-foundation.org
Subject: + drivers-platform-x86-acer-wmic-no-wifi-rfkill-on-lenovo-machines.patch added to -mm tree
Date: Tue, 21 Feb 2012 12:40:05 -0800
Message-ID: <20120221204006.02481A01D6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39830 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2BUUkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 15:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ike.pan@canonical.com, andrey.k.p@gmail.com, jlee@suse.com, jrnieder@gmail.com, mjg@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/platform/x86/acer-wmi.c: no wifi rfkill on Lenovo machines
has been added to the -mm tree.  Its filename is
     drivers-platform-x86-acer-wmic-no-wifi-rfkill-on-lenovo-machines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ike Panhc <ike.pan@canonical.com>
Subject: drivers/platform/x86/acer-wmi.c: no wifi rfkill on Lenovo machines

We have several reports which says acer-wmi is loaded on ideapads and
register rfkill for wifi which can not be unblocked.  Symptom is that wifi
just doesn't work on these machines until the acer-wmi driver is unloaded.
 
Since ideapad-laptop also register rfkill for wifi and it works reliably,
it will be fine acer-wmi is not going to register rfkill for wifi once
VPC2004 is found.

Also put IBM0068/LEN0068 in the list.  Though thinkpad_acpi has no wifi
rfkill capability, there are reports which says acer-wmi also block
wireless on Thinkpad E520/E420.

Addresses http://bugs.debian.org/655941 and
          https://bugzilla.redhat.com/show_bug.cgi?id=674353

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Acked-by: Lee, Chun-Yi <jlee@suse.com>
Tested-by: Andrey <andrey.k.p@gmail.com> # Ideapad Z570
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/acer-wmi.c~drivers-platform-x86-acer-wmic-no-wifi-rfkill-on-lenovo-machines drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~drivers-platform-x86-acer-wmic-no-wifi-rfkill-on-lenovo-machines
+++ a/drivers/platform/x86/acer-wmi.c
@@ -679,6 +679,32 @@ static acpi_status AMW0_find_mailled(voi
 	return AE_OK;
 }
 
+static int AMW0_set_cap_acpi_check_device_found;
+
+static acpi_status AMW0_set_cap_acpi_check_device_cb(acpi_handle handle,
+	u32 level, void *context, void **retval)
+{
+	AMW0_set_cap_acpi_check_device_found = 1;
+	return AE_OK;
+}
+
+static const struct acpi_device_id norfkill_ids[] = {
+	{ "VPC2004", 0},
+	{ "IBM0068", 0},
+	{ "LEN0068", 0},
+	{ "", 0},
+};
+
+static int AMW0_set_cap_acpi_check_device(void)
+{
+	const struct acpi_device_id *id;
+
+	for (id = norfkill_ids; id->id[0]; id++)
+		acpi_get_devices(id->id, AMW0_set_cap_acpi_check_device_cb,
+				NULL, NULL);
+	return AMW0_set_cap_acpi_check_device_found;
+}
+
 static acpi_status AMW0_set_capabilities(void)
 {
 	struct wmab_args args;
@@ -692,7 +718,9 @@ static acpi_status AMW0_set_capabilities
 	 * work.
 	 */
 	if (wmi_has_guid(AMW0_GUID2)) {
-		interface->capability |= ACER_CAP_WIRELESS;
+		if ((quirks != &quirk_unknown) ||
+		    !AMW0_set_cap_acpi_check_device())
+			interface->capability |= ACER_CAP_WIRELESS;
 		return AE_OK;
 	}
 
_
Subject: Subject: drivers/platform/x86/acer-wmi.c: no wifi rfkill on Lenovo machines

Patches currently in -mm which might be from ike.pan@canonical.com are

drivers-platform-x86-acer-wmic-no-wifi-rfkill-on-lenovo-machines.patch

