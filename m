From: akpm@linux-foundation.org
Subject: - i5000_edac-no-need-to-__stringify-kbuild_basename.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:14 -0800
Message-ID: <200711152110.lAFLAE41015539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761341AbXKOVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     i5000_edac: no need to __stringify() KBUILD_BASENAME
has been removed from the -mm tree.  Its filename was
     i5000_edac-no-need-to-__stringify-kbuild_basename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i5000_edac: no need to __stringify() KBUILD_BASENAME
From: "Darrick J. Wong" <djwong@us.ibm.com>

The i5000_edac driver's PCI registration structure has the name
""i5000_edac"" (with extra set of double-quotes) which is probably not
intentional.  Get rid of __stringify.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~i5000_edac-no-need-to-__stringify-kbuild_basename drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~i5000_edac-no-need-to-__stringify-kbuild_basename
+++ a/drivers/edac/i5000_edac.c
@@ -1462,7 +1462,7 @@ MODULE_DEVICE_TABLE(pci, i5000_pci_tbl);
  *
  */
 static struct pci_driver i5000_driver = {
-	.name = __stringify(KBUILD_BASENAME),
+	.name = KBUILD_BASENAME,
 	.probe = i5000_init_one,
 	.remove = __devexit_p(i5000_remove_one),
 	.id_table = i5000_pci_tbl,
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
libsas-convert-sas_proto-users-to-sas_protocol.patch
libsas-fix-various-sparse-complaints.patch
