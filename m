From: akpm@linux-foundation.org
Subject: + ssb-add-ssb_pcihost_set_power_state-function.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:42:34 -0800
Message-ID: <200801120142.m0C1gYxs008289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762613AbYALBnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:43:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mboton@gmail.com, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     ssb: add 'ssb_pcihost_set_power_state' function
has been added to the -mm tree.  Its filename is
     ssb-add-ssb_pcihost_set_power_state-function.patch

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
Subject: ssb: add 'ssb_pcihost_set_power_state' function
From: Miguel Boton <mboton@gmail.com>

Add the 'ssb_pcihost_set_power_state' function.

This function allows us to set the power state of a PCI device (for example
b44 ethernet device).

Signed-off-by: Miguel Boton <mboton@gmail.com>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ssb/ssb.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/ssb/ssb.h~ssb-add-ssb_pcihost_set_power_state-function include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~ssb-add-ssb_pcihost_set_power_state-function
+++ a/include/linux/ssb/ssb.h
@@ -349,6 +349,13 @@ static inline void ssb_pcihost_unregiste
 {
 	pci_unregister_driver(driver);
 }
+
+static inline
+void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_t state)
+{
+	if (sdev->bus->bustype == SSB_BUSTYPE_PCI)
+		pci_set_power_state(sdev->bus->host_pci, state);
+}
 #endif /* CONFIG_SSB_PCIHOST */
 
 
_

Patches currently in -mm which might be from mboton@gmail.com are

acpi-remove-duplicated-warning-message.patch
git-netdev-all.patch
ssb-add-ssb_pcihost_set_power_state-function.patch
b44-power-down-phy-when-interface-down.patch
