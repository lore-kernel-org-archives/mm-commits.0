From: akpm@linux-foundation.org
Subject: + acpi-acpica-do-not-check-reference-counters-in-acpi_ev_enable_gpe.patch added to -mm tree
Date: Mon, 22 Mar 2010 12:58:43 -0700
Message-ID: <201003221958.o2MJwhlF024127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab0CVT7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 15:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, mjg59@srcf.ucam.org, robert.moore@intel.com


The patch titled
     acpi/acpica: do not check reference counters in acpi_ev_enable_gpe()
has been added to the -mm tree.  Its filename is
     acpi-acpica-do-not-check-reference-counters-in-acpi_ev_enable_gpe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi/acpica: do not check reference counters in acpi_ev_enable_gpe()
From: Rafael J. Wysocki <rjw@sisk.pl>

acpi_ev_enable_gpe() should enable the GPE at the hardware level
regardless of the value of the GPE's runtime reference counter.

There are only two callers of acpi_ev_enable_gpe(), acpi_enable_gpe() and
acpi_set_gpe().  The first one checks the GPE's runtime reference counter
itself and only calls acpi_ev_enable_gpe() if it's equal to one, and the
other one is supposed to enable the GPE unconditionally (if called with
ACPI_GPE_ENABLE).

This change fixes the problem in acpi_enable_wakeup_device() where the GPE
will not be enabled for wakeup if it's runtime reference counter is zero,
which is a regression from 2.6.33.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Robert Moore <robert.moore@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpica/evgpe.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN drivers/acpi/acpica/evgpe.c~acpi-acpica-do-not-check-reference-counters-in-acpi_ev_enable_gpe drivers/acpi/acpica/evgpe.c
--- a/drivers/acpi/acpica/evgpe.c~acpi-acpica-do-not-check-reference-counters-in-acpi_ev_enable_gpe
+++ a/drivers/acpi/acpica/evgpe.c
@@ -117,19 +117,14 @@ acpi_status acpi_ev_enable_gpe(struct ac
 	if (ACPI_FAILURE(status))
 		return_ACPI_STATUS(status);
 
-	/* Mark wake-enabled or HW enable, or both */
-
-	if (gpe_event_info->runtime_count) {
-		/* Clear the GPE (of stale events), then enable it */
-		status = acpi_hw_clear_gpe(gpe_event_info);
-		if (ACPI_FAILURE(status))
-			return_ACPI_STATUS(status);
