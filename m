From: akpm@linux-foundation.org
Subject: + regulator-refcount-fixes.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:16:51 -0700
Message-ID: <200903122216.n2CMGpuV010996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbZCLWSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, lrg@slimlogic.co.uk


The patch titled
     regulator: refcount fixes
has been added to the -mm tree.  Its filename is
     regulator-refcount-fixes.patch

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
Subject: regulator: refcount fixes
From: David Brownell <dbrownell@users.sourceforge.net>

Fix some refcounting issues in the regulator framework, supporting
regulator_disable() for regulators that were enabled at boot time via
machine constraints:

 - Update those regulators' usecounts after enabling, so they
   can cleanly be disabled at that level.

 - Remove the problematic per-consumer usecount, so there's
   only one level of enable/disable.

Buggy consumers could notice different bug symptoms.  The main
example would be refcounting bugs; also, any (out-of-tree) users
of the experimental regulator_set_optimum_mode() stuff which
don't call it when they're done using a regulator.

This is a net minor codeshrink.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/core.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff -puN drivers/regulator/core.c~regulator-refcount-fixes drivers/regulator/core.c
--- a/drivers/regulator/core.c~regulator-refcount-fixes
+++ a/drivers/regulator/core.c
@@ -52,7 +52,6 @@ struct regulator {
 	int uA_load;
 	int min_uV;
 	int max_uV;
-	int enabled; /* count of client enables */
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
@@ -815,6 +814,7 @@ static int set_machine_constraints(struc
 			rdev->constraints = NULL;
 			goto out;
 		}
+		rdev->use_count = 1;
 	}
 
 	print_constraints(rdev);
@@ -1068,10 +1068,6 @@ void regulator_put(struct regulator *reg
 	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
 
-	if (WARN(regulator->enabled, "Releasing supply %s while enabled\n",
-			       regulator->supply_name))
-		_regulator_disable(rdev);
-
 	/* remove any sysfs entries */
 	if (regulator->dev) {
 		sysfs_remove_link(&rdev->dev.kobj, regulator->supply_name);
@@ -1146,12 +1142,7 @@ int regulator_enable(struct regulator *r
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	if (regulator->enabled == 0)
-		ret = _regulator_enable(rdev);
-	else if (regulator->enabled < 0)
-		ret = -EIO;
-	if (ret == 0)
-		regulator->enabled++;
+	ret = _regulator_enable(rdev);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
@@ -1162,6 +1153,11 @@ static int _regulator_disable(struct reg
 {
 	int ret = 0;
 
+	if (WARN(rdev->use_count <= 0,
+			"unbalanced disables for %s\n",
+			rdev->desc->name))
+		return -EIO;
+
 	/* are we the last user and permitted to disable ? */
 	if (rdev->use_count == 1 && !rdev->constraints->always_on) {
 
@@ -1210,16 +1206,7 @@ int regulator_disable(struct regulator *
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	if (regulator->enabled == 1) {
-		ret = _regulator_disable(rdev);
-		if (ret == 0)
-			regulator->uA_load = 0;
-	} else if (WARN(regulator->enabled <= 0,
-			"unbalanced disables for supply %s\n",
-			regulator->supply_name))
-		ret = -EIO;
-	if (ret == 0)
-		regulator->enabled--;
+	ret = _regulator_disable(rdev);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
@@ -1266,7 +1253,6 @@ int regulator_force_disable(struct regul
 	int ret;
 
 	mutex_lock(&regulator->rdev->mutex);
-	regulator->enabled = 0;
 	regulator->uA_load = 0;
 	ret = _regulator_force_disable(regulator->rdev);
 	mutex_unlock(&regulator->rdev->mutex);
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

