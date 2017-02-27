From: akpm@linux-foundation.org
Subject: [merged] frv-pci-frv-fix-build-warning.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 12:28:18 -0800
Message-ID: <58b48be2.Z9uIRbckmxrqm9Gl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdB0U2Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dhowells@redhat.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/frv/mb93090-mb00/pci-frv.c: fix build warning
has been removed from the -mm tree.  Its filename was
     frv-pci-frv-fix-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: arch/frv/mb93090-mb00/pci-frv.c: fix build warning

The build of frv defconfig gives warning:

arch/frv/mb93090-mb00/pci-frv.c:176:5: warning:
	ignoring return value of 'pci_assign_resource',
		declared with attribute warn_unused_result

Just print an error message to silence the warning. We can not do much
here on error.

Link: http://lkml.kernel.org/r/1484256471-5379-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/pci-frv.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/frv/mb93090-mb00/pci-frv.c~frv-pci-frv-fix-build-warning arch/frv/mb93090-mb00/pci-frv.c
--- a/arch/frv/mb93090-mb00/pci-frv.c~frv-pci-frv-fix-build-warning
+++ a/arch/frv/mb93090-mb00/pci-frv.c
@@ -147,7 +147,7 @@ static void __init pcibios_allocate_reso
 static void __init pcibios_assign_resources(void)
 {
 	struct pci_dev *dev = NULL;
-	int idx;
+	int idx, err;
 	struct resource *r;
 
 	for_each_pci_dev(dev) {
@@ -172,8 +172,13 @@ static void __init pcibios_assign_resour
 			 *  the BIOS forgot to do so or because we have decided the old
 			 *  address was unusable for some reason.
 			 */
-			if (!r->start && r->end)
-				pci_assign_resource(dev, idx);
+			if (!r->start && r->end) {
+				err = pci_assign_resource(dev, idx);
+				if (err)
+					dev_err(&dev->dev,
+						"Failed to assign new address to %d\n",
+						idx);
+			}
 		}
 	}
 }
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


