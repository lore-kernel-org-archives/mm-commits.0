From: akpm@linux-foundation.org
Subject: + regulator-documentation-machine.patch added to -mm tree
Date: Fri, 02 May 2008 16:57:58 -0700
Message-ID: <200805022357.m42NvwZV021843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758419AbYEBX6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     regulator: documentation - machine
has been added to the -mm tree.  Its filename is
     regulator-documentation-machine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: documentation - machine
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This adds documentation describing the regulator machine interface.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/regulator/machine.txt |  101 ++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff -puN /dev/null Documentation/power/regulator/machine.txt
--- /dev/null
+++ a/Documentation/power/regulator/machine.txt
@@ -0,0 +1,101 @@
+Regulator Machine Driver Interface
+===================================
+
+The regulator machine driver interface is intended for board/machine specific
+initialisation code to configure the regulator subsystem. Typical things that
+machine drivers would do are :-
+
+ 1. Regulator -> Device mapping.
+ 2. Regulator supply configuration.
+ 3. Power Domain constraint setting.
+
+
+
+1. Regulator -> device mapping
+==============================
+Consider the following machine :-
+
+  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
+               |
+               +-> [Consumer B @ 3.3V]
+
+The drivers for consumers A & B must be mapped to the correct regulator in
+order to control their power supply. This mapping can be achieved in machine
+initialisation code by calling :-
+
+int regulator_set_device_supply(const char *regulator, struct device *dev,
+				const char *supply);
+
+and is shown with the following code :-
+
+regulator_set_device_supply("Regulator-1", devB, "Vcc");
+regulator_set_device_supply("Regulator-2", devA, "Vcc");
+
+This maps Regulator-1 to the 'Vcc' supply for Consumer B and maps Regulator-2
+to the 'Vcc' supply for Consumer A.
+
+
+2. Regulator supply configuration.
+==================================
+Consider the following machine (again) :-
+
+  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
+               |
+               +-> [Consumer B @ 3.3V]
+
+Regulator-1 supplies power to Regulator-2. This relationship must be registered
+with the core so that Regulator-1 is also enabled when Consumer A enables it's
+supply (Regulator-2).
+
+This relationship can be register with the core via :-
+
+int regulator_set_supply(const char *regulator, const char *regulator_supply);
+
+In this example we would use the following code :-
+
+regulator_set_supply("Regulator-2", "Regulator-1");
+
+Relationships can be queried by calling :-
+
+const char *regulator_get_supply(const char *regulator);
+
+
+3. Power Domain constraint setting.
+===================================
+Each power domain within a system has physical constraints on voltage and
+current. This must be defined in software so that the power domain is always
+operated within specifications.
+
+Consider the following machine (again) :-
+
+  Regulator-1 -+-> Regulator-2 --> [Consumer A @ 1.8 - 2.0V]
+               |
+               +-> [Consumer B @ 3.3V]
+
+This gives us two regulators and two power domains:
+
+                   Domain 1: Regulator-2, Consumer B.
+                   Domain 2: Consumer A.
+
+Constraints can be registered by calling :-
+
+int regulator_set_platform_constraints(const char *regulator,
+	struct regulation_constraints *constraints);
+
+The example is defined as follows :-
+
+struct regulation_constraints domain_1 = {
+	.min_uV = 3300000,
+	.max_uV = 3300000,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+struct regulation_constraints domain_2 = {
+	.min_uV = 1800000,
+	.max_uV = 2000000,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+regulator_set_platform_constraints("Regulator-1", &domain_1);
+regulator_set_platform_constraints("Regulator-2", &domain_2);
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

regulator-consumer-device-interface.patch
regulator-regulator-driver-interface.patch
regulator-machine-driver-interface.patch
regulator-fixed-regulator-interface.patch
regulator-regulator-framework-core.patch
regulator-add-support-for-fixed-regulators.patch
regulator-regulator-test-harness.patch
regulator-core-kbuild-files.patch
regulator-documentation-overview.patch
regulator-documentation-consumer-interface.patch
regulator-documentation-regulator-driver.patch
regulator-documentation-machine.patch
regulator-documentation-abi.patch

