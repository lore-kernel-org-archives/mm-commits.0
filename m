From: akpm@linux-foundation.org
Subject: + i5000_edac-no-need-to-__stringify-kbuild_basename.patch added to -mm tree
Date: Thu, 25 Oct 2007 16:20:15 -0700
Message-ID: <200710252320.l9PNKFe2029181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbXJYXUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 19:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, norsk5@yahoo.com


The patch titled
     i5000_edac: no need to __stringify() KBUILD_BASENAME
has been added to the -mm tree.  Its filename is
     i5000_edac-no-need-to-__stringify-kbuild_basename.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-hwmon.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
i5000_edac-no-need-to-__stringify-kbuild_basename.patch
