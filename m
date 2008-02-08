From: akpm@linux-foundation.org
Subject: - acpi-remove-duplicated-warning-message.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:23 -0800
Message-ID: <200802080810.m188A46t014907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757618AbYBHITF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mboton@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove duplicated warning message
has been removed from the -mm tree.  Its filename was
     acpi-remove-duplicated-warning-message.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: acpi: remove duplicated warning message
=46rom: Miguel Bot=C3=B3n <mboton@gmail.com>

Remove duplicated warning message in acpi_power_transition()

This warning message is printed by acpi_bus_set_power() so we don't
need to print it again.

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/power.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/acpi/power.c~acpi-remove-duplicated-warning-message d=
rivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-remove-duplicated-warning-message
+++ a/drivers/acpi/power.c
@@ -458,11 +458,9 @@ int acpi_power_transition(struct acpi_de
 	}
=20
      end:
-	if (result) {
+	if (result)
 		device->power.state =3D ACPI_STATE_UNKNOWN;
-		printk(KERN_WARNING PREFIX "Transitioning device [%s] to D%d\n",
-			      device->pnp.bus_id, state);
-	} else {
+	else {
 	/* We shouldn't change the state till all above operations succeed */
 		device->power.state =3D state;
 	}
_

Patches currently in -mm which might be from mboton@gmail.com are

origin.patch
memstick-initial-commit-for-sony-memorystick-support-fix.patch
