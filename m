From: akpm@linux-foundation.org
Subject: + regulator-init-fixes.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:16:54 -0700
Message-ID: <200903122216.n2CMGtNV011000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbZCLWSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, lrg@slimlogic.co.uk


The patch titled
     regulator: init fixes
has been added to the -mm tree.  Its filename is
     regulator-init-fixes.patch

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
Subject: regulator: init fixes
From: David Brownell <dbrownell@users.sourceforge.net>

Make the regulator setup code cope more consistently with regulators
undesirably left enabled by the bootloader.

Building on the previous refcount patch:

* Unless the "boot_on" or "always_on" machine constraints were set,
  disable() the regulator.  This gives drivers a clean start state: enable
  state matches usecount, regardless of boot_on/always_on flag state.

* To help make some integration stages easier, add a new "devmode"
  machine constraint where state the bootloader left isn't touched, but
  enable state and usecount may not match.  (System boots but some drivers
  act odd ...  debuggable.  System dies part way through booting ... 
  often painful.)

Consider a bootloader that leaves an MMC/SD regulator active when it loads
Linux from an SD card.  It may take some time before the MMC/SD driver
gets loaded, if ever ...  to save power, that (LDO) regulator should be
disabled ASAP.  Then later when the MMC driver starts up, the Linux MMC
stack will need to start from a "power off" state.  It can't just

	if (regulator_is_enabled(r))
		regulator_disable(r);

unless enable state and usecount are matched ...  but without this patch,
they *will* be mismatched whenever the bootloader happens to have left
that regulator active!  Similar issues can crop up with almost any
regulator.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/core.c          |   47 ++++++++++++++++++++++------
 include/linux/regulator/machine.h |    3 +
 2 files changed, 40 insertions(+), 10 deletions(-)

diff -puN drivers/regulator/core.c~regulator-init-fixes drivers/regulator/core.c
--- a/drivers/regulator/core.c~regulator-init-fixes
+++ a/drivers/regulator/core.c
@@ -803,18 +803,47 @@ static int set_machine_constraints(struc
 		}
 	}
 
-	/* If the constraints say the regulator should be on at this point
-	 * and we have control then make sure it is enabled.
+	/* During integration, developers may need time to sort out what
+	 * to do with this regulator; leave the bootloader's setting alone.
+	 * Regulator consumers won't get consistent behavior.
+	 *
+	 * Else the constraints say whether it should be on or off; we
+	 * don't leave it in an unknown state.
 	 */
-	if ((constraints->always_on || constraints->boot_on) && ops->enable) {
-		ret = ops->enable(rdev);
-		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s\n",
-			       __func__, name);
-			rdev->constraints = NULL;
-			goto out;
+	if (constraints->devmode) {
+		char *label = "unknown";
+
+		if (ops->is_enabled) {
+			ret = ops->is_enabled(rdev);
+			if (ret == 0)
+				label = "disabled";
+			else if (ret > 0)
+				label = "enabled";
+			ret = 0;
+		}
+		pr_warning("%s: devmode regulator '%s' state is '%s'\n",
+			       __func__, name, label);
+	} else if (constraints->always_on || constraints->boot_on) {
+		if (ops->enable) {
+			ret = ops->enable(rdev);
+			if (ret < 0) {
+				pr_err("%s: failed enabling %s\n",
+				       __func__, name);
+				rdev->constraints = NULL;
+				goto out;
+			}
 		}
 		rdev->use_count = 1;
+	} else {
+		if (ops->disable) {
+			ret = ops->disable(rdev);
+			if (ret < 0) {
+				pr_err("%s: failed disabling %s\n",
+				       __func__, name);
+				rdev->constraints = NULL;
+				goto out;
+			}
+		}
 	}
 
 	print_constraints(rdev);
diff -puN include/linux/regulator/machine.h~regulator-init-fixes include/linux/regulator/machine.h
--- a/include/linux/regulator/machine.h~regulator-init-fixes
+++ a/include/linux/regulator/machine.h
@@ -117,7 +117,8 @@ struct regulation_constraints {
 	/* mode to set on startup */
 	unsigned int initial_mode;
 
-	/* constriant flags */
+	/* constraint flags */
+	unsigned devmode:1;	/* state after setup is indeterminate */
 	unsigned always_on:1;	/* regulator never off when system is on */
 	unsigned boot_on:1;	/* bootloader/firmware enabled regulator */
 	unsigned apply_uV:1;	/* apply uV constraint iff min == max */
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
nand-fix-raw-reads-with-ecc-syndrome-layouts.patch
nand-davinci_nand-driver.patch
nand-fix-broken-debug-messages.patch
mtd-we-dont-need-no-misc-devices.patch
mtd-partitioning-utility-predicates.patch
regulator-refcount-fixes.patch
regulator-init-fixes.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
spi-limit-reaches-1-tested-0.patch
rtc-ds1307-true-smbus-compatibility.patch
gpio-gpio_requestfree-now-required-feature-removal.patch

