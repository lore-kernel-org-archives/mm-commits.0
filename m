From: akpm@linux-foundation.org
Subject: [merged] edac-add-__init-to-i7core_xeon_pci_fixup.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:57 -0400
Message-ID: <201005191733.o4JHXNv7025813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab0ESRdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mchehab@redhat.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: add __init to i7core_xeon_pci_fixup()
has been removed from the -mm tree.  Its filename was
     edac-add-__init-to-i7core_xeon_pci_fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: add __init to i7core_xeon_pci_fixup()
From: Jiri Slaby <jslaby@suse.cz>

It's called only from an __init function and is the only user of
pcibios_scan_specific_bus which shall be marked as __devinit to resolve
section mismatches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i7core_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i7core_edac.c~edac-add-__init-to-i7core_xeon_pci_fixup drivers/edac/i7core_edac.c
--- a/drivers/edac/i7core_edac.c~edac-add-__init-to-i7core_xeon_pci_fixup
+++ a/drivers/edac/i7core_edac.c
@@ -1141,7 +1141,7 @@ static void i7core_put_all_devices(void)
 		i7core_put_devices(i7core_dev);
 }
 
-static void i7core_xeon_pci_fixup(int dev_id)
+static void __init i7core_xeon_pci_fixup(int dev_id)
 {
 	struct pci_dev *pdev = NULL;
 	int i;
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch

