From: akpm@linux-foundation.org
Subject: + pci-kill-off-pci_register_set_vga_state-symbol-export.patch added to -mm tree
Date: Tue, 02 Mar 2010 15:08:47 -0800
Message-ID: <201003022308.o22N8lf3002784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab0CBXJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 18:09:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, jbarnes@virtuousgeek.org, travis@sgi.com


The patch titled
     pci: kill off pci_register_set_vga_state() symbol export.
has been added to the -mm tree.  Its filename is
     pci-kill-off-pci_register_set_vga_state-symbol-export.patch

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
@@ -3052,7 +3052,6 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
-EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
pci-kill-off-pci_register_set_vga_state-symbol-export.patch
add-generic-sys_old_select.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch

