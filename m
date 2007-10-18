From: akpm@linux-foundation.org
Subject: - pnp-make-pnpacpi_suspend-handle-errors.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:43 -0700
Message-ID: <200710180703.l9I73hWe031462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205AbXJRHiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ambx1@neo.rr.com, bjorn.helgaas@hp.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PNP: make pnpacpi_suspend handle errors
has been removed from the -mm tree.  Its filename was
     pnp-make-pnpacpi_suspend-handle-errors.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: PNP: make pnpacpi_suspend handle errors
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

pnpacpi_suspend() doesn't check the result returned by
acpi_pm_device_sleep_state() before passing it to acpi_bus_set_power(),
which may not be desirable.  =A0Make it select the target power state o=
f the
device using its second argument if acpi_pm_device_sleep_state() fails.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Looks-ok-to: Pavel Machek <pavel@ucw.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/core.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/pnp/pnpacpi/core.c~pnp-make-pnpacpi_suspend-handle-er=
rors drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnp-make-pnpacpi_suspend-handle-errors
+++ a/drivers/pnp/pnpacpi/core.c
@@ -130,11 +130,16 @@ static int pnpacpi_disable_resources(str
 #ifdef CONFIG_ACPI_SLEEP
 static int pnpacpi_suspend(struct pnp_dev *dev, pm_message_t state)
 {
-	return acpi_bus_set_power((acpi_handle) dev->data,
-				  acpi_pm_device_sleep_state(&dev->dev,
-							     device_may_wakeup
-							     (&dev->dev),
-							     NULL));
+	int power_state;
+
+	power_state =3D acpi_pm_device_sleep_state(&dev->dev,
+						device_may_wakeup(&dev->dev),
+						NULL);
+	if (power_state < 0)
+		power_state =3D (state.event =3D=3D PM_EVENT_ON) ?
+				ACPI_STATE_D0 : ACPI_STATE_D3;
+
+	return acpi_bus_set_power((acpi_handle) dev->data, power_state);
 }
=20
 static int pnpacpi_resume(struct pnp_dev *dev)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-rework-struct-platform_suspend_ops-fixup.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on-update.patch
s2ram-kill-old-debugging-junk.patch
revert-x86-save-registers-in-saved_context-during-suspend-and-hibernati=
on.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64=
=2Epatch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.=
patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.=
patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-=
fix.patch
shrink_slab-handle-bad-shrinkers.patch
