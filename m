From: akpm@linux-foundation.org
Subject: + forcedeth-add-pci_enable_device-to-nv_resume.patch added to -mm tree
Date: Mon, 18 Aug 2008 13:52:14 -0700
Message-ID: <200808182052.m7IKqE3l012132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYHRUxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 16:53:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, aabdulla@nvidia.com, jgarzik@redhat.com, ranma+kernel@tdiedrich.de


The patch titled
     forcedeth: add pci_enable_device() to nv_resume()
has been added to the -mm tree.  Its filename is
     forcedeth-add-pci_enable_device-to-nv_resume.patch

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
Subject: forcedeth: add pci_enable_device() to nv_resume()
From: Simon Arlott <simon@fire.lp0.eu>

My NIC stops working after resuming from standby, it's not receiving any
interrupts.

Commit 25d90810ff49d2a63475776f24c74c6bb49b045f ([netdrvr] forcedeth:
reorder suspend/resume code) introduces pci_disable_device to nv_suspend,
but there's no corresponding pci_enable_device in nv_resume - so I added
one (copied from e1000).  This results in interrupts being re-enabled
after suspend.

However, the NIC (10de:0373) still doesn't work after resume.

Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-add-pci_enable_device-to-nv_resume drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-add-pci_enable_device-to-nv_resume
+++ a/drivers/net/forcedeth.c
@@ -5960,6 +5960,13 @@ static int nv_resume(struct pci_dev *pde
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		printk(KERN_ERR "forcedeth: Cannot enable PCI device from suspend\n");
+		return rc;
+	}
+	pci_set_master(pdev);
+
 	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, PCI_D0, 0);
 
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

origin.patch
v4l-link-tuner-before-saa7134.patch
forcedeth-add-pci_enable_device-to-nv_resume.patch

