From: akpm@linux-foundation.org
Subject: [merged] mm-only-enforce-acpi-resource-conflict-checks.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:54 -0700
Message-ID: <200904061938.n36Jcs5H013564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757723AbZDFTny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, bjorn.helgaas@hp.com, lenb@kernel.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     Enforce ACPI resource conflict checks
has been removed from the -mm tree.  Its filename was
     mm-only-enforce-acpi-resource-conflict-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Enforce ACPI resource conflict checks
From: Jean Delvare <khali@linux-fr.org>

ACPI has a list of resources that it might use at some point in time. 
These resources are not (yet) requested formally, because it is suspected
that in many cases that would prevent other legitimate drivers from
working.  For example, ACPI might list I/O ports, but might not actually
use them.  Or maybe they are used by the ACPI thermal driver, but the use
prefers to use full-featured hardware monitoring drivers.

Still, in some cases, ACPI is really conflicting with native Linux drivers
for I/O ports.  This can cause problems which are hard to diagnose.  So,
as a first step towards solving this problem, we implemented a mechanism
which simply reports such conflicts, with the collaboration of involved
drivers.  To the best of my knowledge, only PC-style i2c bus drivers are
doing it at the moment.  There was a patch to do the same in hwmon drivers
but Linus nacked it.

The default behavior is for the native drivers to check for conflict and
report it if found.  The conflict may or may not be real, but at least if
a problem happens later, whoever investigates it can see the warning
message in the logs.

This behavior can be changed using the boot command line, to either silent
the warnings (acpi_enforce_resources=no) or cause the native drivers to
fail loading (acpi_enforce_resources=strict.) Typically, if a user reports
a problem which we suspect could be a bad interaction between ACPI and a
native driver, we ask him/her to reproduce the problem with
acpi_enforce_resources=strict.

The patch changes the default from lax (warn in the logs if a conflict is
found) to strict (cause the drivers to fail loading.) The idea was to get
more reports about systems which have these conflicts.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~mm-only-enforce-acpi-resource-conflict-checks drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~mm-only-enforce-acpi-resource-conflict-checks
+++ a/drivers/acpi/osl.c
@@ -155,7 +155,7 @@ static struct osi_linux {
 #define ENFORCE_RESOURCES_LAX    1
 #define ENFORCE_RESOURCES_NO     0
 
-static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
 static struct dmi_system_id __initdata acpi_resources_dmi_table[] = {
 	{
 	.ident = "Asus EEEPC-901",
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
dell-laptop-fix-uninitialized-wrong-return-value.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

