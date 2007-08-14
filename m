From: akpm@linux-foundation.org
Subject: - acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:11:55 -0700
Message-ID: <200708141911.l7EJBtIV016336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934769AbXHNTMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: us15@os.inf.tu-dresden.de, lenb@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ACPI: move timer broadcast and pmtimer access before C3 arbiter shutdown
has been removed from the -mm tree.  Its filename was
     acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: move timer broadcast and pmtimer access before C3 arbiter shutdown
From: Udo A. Steinberg <us15@os.inf.tu-dresden.de>

The chipset doc for IHC4 tells us:

1.In general, software should not attempt any non-posted accesses during
arbiter disable except to the ICH4's power management registers.  This implies
that interrupt handlers for any unmasked hardware interrupts and SMI/NMI
should check ARB_DIS status before reading from ICH devices.

So it's not a good idea to access ICH devices after arbiter shut down.

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/processor_idle.c~acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown
+++ a/drivers/acpi/processor_idle.c
@@ -1009,6 +1009,12 @@ static int acpi_idle_enter_c3(struct cpu
 		return 0;
 	}
 
+	/*
+	 * Must be done before busmaster disable as we might need to
+	 * access HPET!
+	 */
+	acpi_state_timer_broadcast(pr, cx, 1);
+
 	/* disable bus master */
 	if (pr->flags.bm_check) {
 		spin_lock(&c3_lock);
@@ -1028,7 +1034,6 @@ static int acpi_idle_enter_c3(struct cpu
 
 	/* Get start time (ticks) */
 	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-	acpi_state_timer_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
_

Patches currently in -mm which might be from us15@os.inf.tu-dresden.de are
