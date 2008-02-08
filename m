From: akpm@linux-foundation.org
Subject: - char-mxser-reorder-mxser_cardinfo-fields.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:58 -0800
Message-ID: <200802080809.m1889d01014862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761679AbYBHITo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, reorder mxser_cardinfo fields
has been removed from the -mm tree.  Its filename was
     char-mxser-reorder-mxser_cardinfo-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, reorder mxser_cardinfo fields
From: Jiri Slaby <jirislaby@gmail.com>

Reorder fields to save some memory and code on 64bit due to alignment as
suggested by Jan.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   60 ++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser-reorder-mxser_cardinfo-fields drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-reorder-mxser_cardinfo-fields
+++ a/drivers/char/mxser_new.c
@@ -106,41 +106,41 @@ static const struct {
 #define UART_INFO_NUM	ARRAY_SIZE(Gpci_uart_info)
 
 struct mxser_cardinfo {
-	unsigned int nports;
 	char *name;
+	unsigned int nports;
 	unsigned int flags;
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-/* 0*/	{ 8, "C168 series", },
-	{ 4, "C104 series", },
-	{ 4, "CI-104J series", },
-	{ 8, "C168H/PCI series", },
-	{ 4, "C104H/PCI series", },
-/* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
-	{ 4, "CI-132 series", MXSER_HAS2 },
-	{ 4, "CI-134 series", },
-	{ 2, "CP-132 series", },
-	{ 4, "CP-114 series", },
-/*10*/	{ 4, "CT-114 series", },
-	{ 2, "CP-102 series", MXSER_HIGHBAUD },
-	{ 4, "CP-104U series", },
-	{ 8, "CP-168U series", },
-	{ 2, "CP-132U series", },
-/*15*/	{ 4, "CP-134U series", },
-	{ 4, "CP-104JU series", },
-	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
-	{ 8, "CP-118U series", },
-	{ 2, "CP-102UL series", },
-/*20*/	{ 2, "CP-102U series", },
-	{ 8, "CP-118EL series", },
-	{ 8, "CP-168EL series", },
-	{ 4, "CP-104EL series", },
-	{ 8, "CB-108 series", },
-/*25*/	{ 4, "CB-114 series", },
-	{ 4, "CB-134I series", },
-	{ 8, "CP-138U series", },
-	{ 4, "POS-104UL series", }
+/* 0*/	{ "C168 series",	8, },
+	{ "C104 series",	4, },
+	{ "CI-104J series",	4, },
+	{ "C168H/PCI series",	8, },
+	{ "C104H/PCI series",	4, },
+/* 5*/	{ "C102 series",	4, MXSER_HAS2 },	/* C102-ISA */
+	{ "CI-132 series",	4, MXSER_HAS2 },
+	{ "CI-134 series",	4, },
+	{ "CP-132 series",	2, },
+	{ "CP-114 series",	4, },
+/*10*/	{ "CT-114 series",	4, },
+	{ "CP-102 series",	2, MXSER_HIGHBAUD },
+	{ "CP-104U series",	4, },
+	{ "CP-168U series",	8, },
+	{ "CP-132U series",	2, },
+/*15*/	{ "CP-134U series",	4, },
+	{ "CP-104JU series",	4, },
+	{ "Moxa UC7000 Serial",	8, },		/* RC7000 */
+	{ "CP-118U series",	8, },
+	{ "CP-102UL series",	2, },
+/*20*/	{ "CP-102U series",	2, },
+	{ "CP-118EL series",	8, },
+	{ "CP-168EL series",	8, },
+	{ "CP-104EL series",	4, },
+	{ "CB-108 series",	8, },
+/*25*/	{ "CB-114 series",	4, },
+	{ "CB-134I series",	4, },
+	{ "CP-138U series",	8, },
+	{ "POS-104UL series",	4, }
 };
 
 /* driver_data correspond to the lines in the structure above
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
