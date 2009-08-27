From: akpm@linux-foundation.org
Subject: [merged] acpi-processor-remove-superfluous-warning-message.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:35 -0700
Message-ID: <200908271918.n7RJIZNG010450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbZH0TTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, rjw@sisk.pl, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi processor: remove superfluous warning message
has been removed from the -mm tree.  Its filename was
     acpi-processor-remove-superfluous-warning-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi processor: remove superfluous warning message
From: Frans Pop <elendil@planet.nl>

This failure is very common on many platforms.  Handling it in the ACPI
processor driver is enough, and we don't need a warning message unless
CONFIG_ACPI_DEBUG is set.

Based on a patch from Zhang Rui.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13389

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-processor-remove-superfluous-warning-message drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-processor-remove-superfluous-warning-message
+++ a/drivers/acpi/processor_throttling.c
@@ -840,8 +840,8 @@ static int acpi_processor_get_throttling
 	if (ret >= 0) {
 		state = acpi_get_throttling_state(pr, value);
 		if (state == -1) {
-			ACPI_WARNING((AE_INFO,
-				"Invalid throttling state, reset"));
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				"Invalid throttling state, reset\n"));
 			state = 0;
 			ret = acpi_processor_set_throttling(pr, state, true);
 			if (ret)
_

Patches currently in -mm which might be from elendil@planet.nl are

origin.patch
linux-next.patch

