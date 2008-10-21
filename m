From: akpm@linux-foundation.org
Subject: + pci-use-pci_ioremap_bar-in-drivers-edac.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:16:43 -0700
Message-ID: <200810212116.m9LLGhxl021671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbYJUVQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, norsk5@yahoo.com


The patch titled
     pci: use pci_ioremap_bar() in drivers/edac
has been added to the -mm tree.  Its filename is
     pci-use-pci_ioremap_bar-in-drivers-edac.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use pci_ioremap_bar() in drivers/edac
From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/edac. 
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~pci-use-pci_ioremap_bar-in-drivers-edac drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~pci-use-pci_ioremap_bar-in-drivers-edac
+++ a/drivers/edac/i82875p_edac.c
@@ -312,9 +312,7 @@ static int i82875p_setup_overfl_dev(stru
 	}
 
 	/* cache is irrelevant for PCI bus reads/writes */
-	window = ioremap_nocache(pci_resource_start(dev, 0),
-				 pci_resource_len(dev, 0));
