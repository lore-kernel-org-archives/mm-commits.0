From: akpm@linux-foundation.org
Subject: - regulator-documentation-regulator-driver.patch removed from -mm tree
Date: Fri, 30 May 2008 16:08:05 -0700
Message-ID: <200805302308.m4UN85N6016211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbYE3XIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     regulator: documentation - regulator driver
has been removed from the -mm tree.  Its filename was
     regulator-documentation-regulator-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: documentation - regulator driver
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This adds documentation describing the regulator driver interface.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/regulator/regulator.txt |   30 ++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN /dev/null Documentation/power/regulator/regulator.txt
--- /dev/null
+++ a/Documentation/power/regulator/regulator.txt
@@ -0,0 +1,30 @@
+Regulator Driver Interface
+==========================
+
+The regulator driver interface is relatively simple and designed to allow
+regulator drivers to register their services with the core framework.
+
+
+Registration
+============
+
+Drivers can register a regulator by calling :-
+
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data);
+
+This will register the regulators capabilities and operations the regulator
+core. The core does not touch reg_data (private to regulator driver).
+
+Regulators can be unregistered by calling :-
+
+void regulator_unregister(struct regulator_dev *rdev);
+
+
+Regulator Events
+================
+Regulators can send events (e.g. over temp, under voltage, etc) to consumer
+drivers by calling :-
+
+int regulator_notifier_call_chain(struct regulator_dev *rdev,
+				  unsigned long event, void *data);
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

linux-next.patch
git-regulator.patch

