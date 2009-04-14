From: akpm@linux-foundation.org
Subject: [merged] edac-fix-local-pci_write_bits32.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:22 -0700
Message-ID: <200904141950.n3EJoM4Z020109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbZDNTwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jharan@Brocade.COM, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: fix local pci_write_bits32
has been removed from the -mm tree.  Its filename was
     edac-fix-local-pci_write_bits32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: fix local pci_write_bits32
From: Jeff Haran <jharan@Brocade.COM>

Fix the edac local pci_write_bits32 to properly note the 'escape' mask if
all ones in a 32-bit word.

Currently no consumer of this function uses that mask, so there is no
danger to existing code.

Signed-off-by: Jeff Haran <jharan@Brocade.COM>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/edac/edac_core.h~edac-fix-local-pci_write_bits32 drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edac-fix-local-pci_write_bits32
+++ a/drivers/edac/edac_core.h
@@ -767,11 +767,19 @@ static inline void pci_write_bits16(stru
 	pci_write_config_word(pdev, offset, value);
 }
 
-/* write all or some bits in a dword-register*/
+/*
+ * pci_write_bits32
+ *
+ * edac local routine to do pci_write_config_dword, but adds
+ * a mask parameter. If mask is all ones, ignore the mask.
+ * Otherwise utilize the mask to isolate specified bits
+ *
+ * write all or some bits in a dword-register
+ */
 static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 				    u32 value, u32 mask)
 {
-	if (mask != 0xffff) {
+	if (mask != 0xffffffff) {
 		u32 buf;
 
 		pci_read_config_dword(pdev, offset, &buf);
_

Patches currently in -mm which might be from jharan@Brocade.COM are

origin.patch

