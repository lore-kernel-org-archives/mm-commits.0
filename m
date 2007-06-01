From: akpm@linux-foundation.org
Subject: - fix-pci_find_present.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:53 -0700
Message-ID: <200706010706.l5176qf9004741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018AbXFAHG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:06:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gardner.ben@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Fix pci_find_present
has been removed from the -mm tree.  Its filename was
     fix-pci_find_present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix pci_find_present
From: "Ben Gardner" <gardner.ben@gmail.com>

pci_find_present() is only matching the last item in the list of ids.

The break after the match is found only escapes the for loop, not the
while loop, so found gets reset to NULL on the next pass.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/search.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/pci/search.c~fix-pci_find_present drivers/pci/search.c
--- a/drivers/pci/search.c~fix-pci_find_present
+++ a/drivers/pci/search.c
@@ -403,10 +403,11 @@ const struct pci_device_id *pci_find_pre
 	while (ids->vendor || ids->subvendor || ids->class_mask) {
 		list_for_each_entry(dev, &pci_devices, global_list) {
 			if ((found = pci_match_one_device(ids, dev)) != NULL)
-				break;
+				goto exit;
 		}
 		ids++;
 	}
+exit:
 	up_read(&pci_bus_sem);
 	return found;
 }
_

Patches currently in -mm which might be from gardner.ben@gmail.com are

origin.patch
