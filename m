From: akpm@linux-foundation.org
Subject: + net-e100-fix-suspend-of-devices-that-cannot-be-power-managed.patch added to -mm tree
Date: Mon, 15 Jun 2009 12:59:44 -0700
Message-ID: <200906151959.n5FJxi0H009903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbZFOUAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 16:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, andi@lisas.de, bruce.w.allan@intel.com, davem@davemloft.net, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com


The patch titled
     e100: fix suspend of devices that cannot be power managed
has been added to the -mm tree.  Its filename is
     net-e100-fix-suspend-of-devices-that-cannot-be-power-managed.patch

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
Subject: e100: fix suspend of devices that cannot be power managed
From: Rafael J. Wysocki <rjw@sisk.pl>

If the adapter is not power-manageable using either ACPI, or the native
PCI PM interface, __e100_power_off() returns error code, which causes
every attempt to suspend to fail, although it should return 0 in such a
case.  Fix this problem by ignoring the return value of
pci_set_power_state() in __e100_power_off().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Andreas Mohr <andi@lisas.de>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e100.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/net/e100.c~net-e100-fix-suspend-of-devices-that-cannot-be-power-managed drivers/net/e100.c
--- a/drivers/net/e100.c~net-e100-fix-suspend-of-devices-that-cannot-be-power-managed
+++ a/drivers/net/e100.c
@@ -2895,12 +2895,13 @@ static void __e100_shutdown(struct pci_d
 
 static int __e100_power_off(struct pci_dev *pdev, bool wake)
 {
-	if (wake) {
+	if (wake)
 		return pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		return pci_set_power_state(pdev, PCI_D3hot);
-	}
+
+	pci_wake_from_d3(pdev, false);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
net-e100-fix-suspend-of-devices-that-cannot-be-power-managed.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
shrink_slab-handle-bad-shrinkers.patch

