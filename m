From: akpm@linux-foundation.org
Subject: + pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev.patch added to -mm tree
Date: Wed, 27 May 2009 16:43:53 -0700
Message-ID: <200905272343.n4RNhr18013474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797AbZE0Xo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 19:44:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, jbarnes@virtuousgeek.org


The patch titled
     pci: eliminate redundant pci_stop_dev() call from pci_destroy_dev()
has been added to the -mm tree.  Its filename is
     pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev.patch

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
Subject: pci: eliminate redundant pci_stop_dev() call from pci_destroy_dev()
From: Alex Chiang <achiang@hp.com>

We always call pci_stop_bus_device before calling pci_destroy_dev.

Since pci_stop_bus_device calls pci_stop_dev, there is no need
for pci_destroy_dev to repeat the call.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/remove.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/pci/remove.c~pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev drivers/pci/remove.c
--- a/drivers/pci/remove.c~pci-eliminate-redundant-pci_stop_dev-call-from-pci_destroy_dev
+++ a/drivers/pci/remove.c
@@ -32,8 +32,6 @@ static void pci_stop_dev(struct pci_dev 
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
-	pci_stop_dev(dev);
