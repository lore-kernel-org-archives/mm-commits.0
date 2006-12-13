From: akpm@osdl.org
Subject: - be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:14 -0800
Message-ID: <200612130656.kBD6uEpo030707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965043AbWLMG4Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Be a bit defensive in quirk_nvidia_ck804() so we don't risk dereferencing a NULL pdev.
has been removed from the -mm tree.  Its filename was
     be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Be a bit defensive in quirk_nvidia_ck804() so we don't risk dereferencing a NULL pdev.
From: Jesper Juhl <jesper.juhl@gmail.com>

pci_get_slot() may return NULL if nothing was found.  quirk_nvidia_ck804()
does not check the value returned from pci_get_slot(), so it may end up
causing a NULL pointer deref.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pci/quirks.c~be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~be-a-bit-defensive-in-quirk_nvidia_ck804-so-we-dont-risk-dereferencing-a-null-pdev
+++ a/drivers/pci/quirks.c
@@ -1743,6 +1743,8 @@ static void __devinit quirk_nvidia_ck804
 	 * a single one having MSI is enough to be sure that MSI are supported.
 	 */
 	pdev = pci_get_slot(dev->bus, 0);
+	if (!pdev)
+		return;
 	if (!msi_ht_cap_enabled(dev) && !msi_ht_cap_enabled(pdev)) {
 		printk(KERN_WARNING "PCI: MSI quirk detected. "
 		       "MSI disabled on chipset %s.\n",
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-acpi.patch
nfs-kill-obsolete-nfs_paranoia.patch
debug-shared-irqs.patch

