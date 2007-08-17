From: akpm@linux-foundation.org
Subject: + pnp-make-pnpacpi_suspend-handle-errors.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:09:53 -0700
Message-ID: <200708172109.l7HL9rD8029550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756926AbXHQVK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ambx1@neo.rr.com, bjorn.helgaas@hp.com, pavel@ucw.cz


The patch titled
     PNP: make pnpacpi_suspend handle errors
has been added to the -mm tree.  Its filename is
     pnp-make-pnpacpi_suspend-handle-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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
 1 files changed, 10 insertions(+), 5 deletions(-)

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

pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x=
=2Epatch
enable-gpes-before-calling-_wak-on-resume.patch
uli526x-add-suspend-and-resume-routines.patch
x86_64-save-registers-in-saved_context-during-suspend-and-hibernation.p=
atch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
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
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-opti=
on-update.patch
s2ram-kill-old-debugging-junk.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch
