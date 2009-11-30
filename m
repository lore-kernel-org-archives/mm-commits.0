From: akpm@linux-foundation.org
Subject: [merged] thinkpad-acpi-fix-detection-of-old-thinkpads.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:17 -0800
Message-ID: <200911302033.nAUKXHN1020667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbZK3UeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmh@hmh.eng.br, bjorn.helgaas@hp.com, kimoto@lightlink.com, lenb@kernel.org, rjw@sisk.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     thinkpad-acpi: fix detection of old ThinkPads
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-fix-detection-of-old-thinkpads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thinkpad-acpi: fix detection of old ThinkPads
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

There is a problem in the quirk tables used by tpacpi_is_fw_known() and
tpacpi_check_outdated_fw(), which causes outdated BIOSes that are lacking
the EC firmware ID DMI field to never match.

This breaks module loading on, e.g.  a T23 with outdated BIOS, and the
module will refuse to load unless the "force_load=1" parameter is given.

Fix the quirk tables so that they can also match the outdated BIOSes,
which in turn will both fix the module loading, and also warn the user
that he is using outdated firmware and should upgrade.

This fixes a serious regression, introduced by commit
e675abafcc0df38125e6e94a9ba91c92fe774f52, "thinkpad-acpi: be more strict
when detecting a ThinkPad".

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14597

Reported-by: Paul Kimoto <kimoto@lightlink.com>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Tested-by: Paul Kimoto <kimoto@lightlink.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-fix-detection-of-old-thinkpads drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-fix-detection-of-old-thinkpads
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -1680,36 +1680,48 @@ static void tpacpi_remove_driver_attribu
 			  | (__bv1) << 8 | (__bv2) }
 
 #define TPV_Q_X(__v, __bid1, __bid2, __bv1, __bv2,	\
-		__eid1, __eid2, __ev1, __ev2)		\
+		__eid, __ev1, __ev2)			\
 	{ .vendor	= (__v),			\
 	  .bios		= TPID(__bid1, __bid2),		\
-	  .ec		= TPID(__eid1, __eid2),		\
+	  .ec		= __eid,			\
 	  .quirks	= (__ev1) << 24 | (__ev2) << 16 \
 			  | (__bv1) << 8 | (__bv2) }
 
 #define TPV_QI0(__id1, __id2, __bv1, __bv2) \
 	TPV_Q(PCI_VENDOR_ID_IBM, __id1, __id2, __bv1, __bv2)
 
+/* Outdated IBM BIOSes often lack the EC id string */
 #define TPV_QI1(__id1, __id2, __bv1, __bv2, __ev1, __ev2) \
 	TPV_Q_X(PCI_VENDOR_ID_IBM, __id1, __id2, 	\
-		__bv1, __bv2, __id1, __id2, __ev1, __ev2)
+		__bv1, __bv2, TPID(__id1, __id2),	\
+		__ev1, __ev2),				\
+	TPV_Q_X(PCI_VENDOR_ID_IBM, __id1, __id2, 	\
+		__bv1, __bv2, TPACPI_MATCH_UNKNOWN,	\
+		__ev1, __ev2)
 
+/* Outdated IBM BIOSes often lack the EC id string */
 #define TPV_QI2(__bid1, __bid2, __bv1, __bv2,		\
 		__eid1, __eid2, __ev1, __ev2) 		\
 	TPV_Q_X(PCI_VENDOR_ID_IBM, __bid1, __bid2, 	\
-		__bv1, __bv2, __eid1, __eid2, __ev1, __ev2)
+		__bv1, __bv2, TPID(__eid1, __eid2),	\
+		__ev1, __ev2),				\
+	TPV_Q_X(PCI_VENDOR_ID_IBM, __bid1, __bid2, 	\
+		__bv1, __bv2, TPACPI_MATCH_UNKNOWN,	\
+		__ev1, __ev2)
 
 #define TPV_QL0(__id1, __id2, __bv1, __bv2) \
 	TPV_Q(PCI_VENDOR_ID_LENOVO, __id1, __id2, __bv1, __bv2)
 
 #define TPV_QL1(__id1, __id2, __bv1, __bv2, __ev1, __ev2) \
 	TPV_Q_X(PCI_VENDOR_ID_LENOVO, __id1, __id2, 	\
-		__bv1, __bv2, __id1, __id2, __ev1, __ev2)
+		__bv1, __bv2, TPID(__id1, __id2),	\
+		__ev1, __ev2)
 
 #define TPV_QL2(__bid1, __bid2, __bv1, __bv2,		\
 		__eid1, __eid2, __ev1, __ev2) 		\
 	TPV_Q_X(PCI_VENDOR_ID_LENOVO, __bid1, __bid2, 	\
-		__bv1, __bv2, __eid1, __eid2, __ev1, __ev2)
+		__bv1, __bv2, TPID(__eid1, __eid2),	\
+		__ev1, __ev2)
 
 static const struct tpacpi_quirk tpacpi_bios_version_qtable[] __initconst = {
 	/*  Numeric models ------------------ */
_

Patches currently in -mm which might be from hmh@hmh.eng.br are

linux-next.patch

