From: akpm@linux-foundation.org
Subject: + acpi-suspend-enable-acpi-during-resume-if-sci_en-is-not-set.patch added to -mm tree
Date: Fri, 03 Oct 2008 15:49:46 -0700
Message-ID: <200810032249.m93MnkJq019852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYJCWuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 18:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     acpi suspend: enable ACPI during resume if SCI_EN is not set
has been added to the -mm tree.  Its filename is
     acpi-suspend-enable-acpi-during-resume-if-sci_en-is-not-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi suspend: enable ACPI during resume if SCI_EN is not set
From: Rafael J. Wysocki <rjw@sisk.pl>

On some machines, like for example MSI Wind U100, the BIOS doesn't enable
ACPI before returning control to the OS, which sometimes causes resume to
fail.  This is against the ACPI specification, which clearly states that
"When the platform is waking from an S1, S2 or S3 state, OSPM assumes the
hardware is already in the ACPI mode and will not issue an ACPI_ENABLE",
but it won't hurt to check the SCI_EN bit and enable ACPI during resume
from S3 if this bit is not set.

Fortunately, we already have acpi_enable() for that, so use it in the
resume code path, before executing _BFS, in analogy with the
resume-from-hibernation code path.

NOTE: We aren't supposed to set SCI_EN directly, because it's owned by the
hardware.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/sleep/main.c~acpi-suspend-enable-acpi-during-resume-if-sci_en-is-not-set drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-enable-acpi-during-resume-if-sci_en-is-not-set
+++ a/drivers/acpi/sleep/main.c
@@ -233,6 +233,8 @@ static int acpi_suspend_enter(suspend_st
 		break;
 	}
 
+	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
+	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

acpi-make-proc-acpi-wakeup-interface-handle-pci-devices-again.patch
git-ftrace.patch
git-pci.patch
acpi-suspend-enable-acpi-during-resume-if-sci_en-is-not-set.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
shrink_slab-handle-bad-shrinkers.patch

