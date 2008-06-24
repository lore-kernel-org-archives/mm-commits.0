From: akpm@linux-foundation.org
Subject: + pci-vt3336-cant-do-msi-either.patch added to -mm tree
Date: Mon, 23 Jun 2008 22:51:58 -0700
Message-ID: <200806240551.m5O5pwwh003001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbYFXFwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 01:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, jbarnes@virtuousgeek.org


The patch titled
     pci: VT3336 can't do MSI either
has been added to the -mm tree.  Its filename is
     pci-vt3336-cant-do-msi-either.patch

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
Subject: pci: VT3336 can't do MSI either
From: Tejun Heo <tj@kernel.org>

It seems VT3336 can't do msi either as with its bro 3351.  Disable it.
Reported in the following SUSE bug.

  https://bugzilla.novell.com/show_bug.cgi?id=300001

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/quirks.c~pci-vt3336-cant-do-msi-either drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-vt3336-cant-do-msi-either
+++ a/drivers/pci/quirks.c
@@ -1745,6 +1745,7 @@ static void __init quirk_disable_all_msi
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
_

Patches currently in -mm which might be from tj@kernel.org are

pci-vt3336-cant-do-msi-either.patch

