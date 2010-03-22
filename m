From: akpm@linux-foundation.org
Subject: [merged] pci-kill-off-pci_register_set_vga_state-symbol-export.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:33 -0400
Message-ID: <201003221832.o2MIWNTo020004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992Ab0CVSc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, jbarnes@virtuousgeek.org, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     pci: kill off pci_register_set_vga_state() symbol export.
has been removed from the -mm tree.  Its filename was
     pci-kill-off-pci_register_set_vga_state-symbol-export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: kill off pci_register_set_vga_state() symbol export.
From: Paul Mundt <lethal@linux-sh.org>

When pci_register_set_vga_state() was made __init, the EXPORT_SYMBOL() was
retained, which now leaves us with a section mismatch.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/pci/pci.c~pci-kill-off-pci_register_set_vga_state-symbol-export drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-kill-off-pci_register_set_vga_state-symbol-export
+++ a/drivers/pci/pci.c
@@ -3023,7 +3023,6 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
-EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

linux-next.patch
nommu-allow-private-mappings-of-read-only-devices.patch
improve-sys_personality-for-compat-architectures.patch

