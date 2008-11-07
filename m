From: akpm@linux-foundation.org
Subject: + i5000-edac-hold-reference-to-mci-kobject.patch added to -mm tree
Date: Fri, 07 Nov 2008 11:36:25 -0800
Message-ID: <200811071936.mA7JaPbS010679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYKGTg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 14:36:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, norsk5@yahoo.com


The patch titled
     i5000-edac: hold reference to mci kobject
has been added to the -mm tree.  Its filename is
     i5000-edac-hold-reference-to-mci-kobject.patch

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
Subject: i5000-edac: hold reference to mci kobject
From: "Darrick J. Wong" <djwong@us.ibm.com>

It turns out that edac_mc_del_mc will kobject_put the last kref on the mci
object.  If the timing is just right, that means that the mci object is
freed before before i5000_remove_one has a chance to free the resources
associated with it, causing a null pointer exceptions when unloading the
driver.  Insert a kobject_{get,put} pair so that this doesn't happen.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~i5000-edac-hold-reference-to-mci-kobject drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~i5000-edac-hold-reference-to-mci-kobject
+++ a/drivers/edac/i5000_edac.c
@@ -1381,6 +1381,7 @@ static int i5000_probe1(struct pci_dev *
 	if (mci == NULL)
 		return -ENOMEM;
 
+	kobject_get(&mci->edac_mci_kobj);
 	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
@@ -1453,6 +1454,7 @@ fail1:
 	i5000_put_devices(mci);
 
 fail0:
+	kobject_put(&mci->edac_mci_kobj);
 	edac_mc_free(mci);
 	return -ENODEV;
 }
@@ -1498,7 +1500,7 @@ static void __devexit i5000_remove_one(s
 
 	/* retrieve references to resources, and free those resources */
 	i5000_put_devices(mci);
