From: akpm@linux-foundation.org
Subject: [merged] regulator-suggest-use-of-datasheet-supply-or-pin-names-for-consumers.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:06 -0800
Message-ID: <200902241933.n1OJX6aV004491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760070AbZBXTge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:36:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, mm-commits@vger.kernel.org


The patch titled
     regulator: suggest use of datasheet supply or pin names for consumers
has been removed from the -mm tree.  Its filename was
     regulator-suggest-use-of-datasheet-supply-or-pin-names-for-consumers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: suggest use of datasheet supply or pin names for consumers
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Update the documentation to suggest the use of datasheet names for
the supplies requested by regulator consumers. Doing this makes it
easier to tie the design for a given platform up with the requirements
of the driver for a consumer.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/regulator/core.c~regulator-suggest-use-of-datasheet-supply-or-pin-names-for-consumers drivers/regulator/core.c
--- a/drivers/regulator/core.c~regulator-suggest-use-of-datasheet-supply-or-pin-names-for-consumers
+++ a/drivers/regulator/core.c
@@ -925,9 +925,12 @@ overflow_err:
  * @id: Supply name or regulator ID.
  *
  * Returns a struct regulator corresponding to the regulator producer,
- * or IS_ERR() condition containing errno.  Use of supply names
- * configured via regulator_set_device_supply() is strongly
- * encouraged.
+ * or IS_ERR() condition containing errno.
+ *
+ * Use of supply names configured via regulator_set_device_supply() is
+ * strongly encouraged.  It is recommended that the supply name used
+ * should match the name used for the supply and/or the relevant
+ * device pins in the datasheet.
  */
 struct regulator *regulator_get(struct device *dev, const char *id)
 {
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

