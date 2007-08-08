From: akpm@linux-foundation.org
Subject: + i386-pci_get_device-called-from-interrupt-in-reboot-fixups.patch added to -mm tree
Date: Tue, 07 Aug 2007 18:20:43 -0700
Message-ID: <200708080120.l781KhZt014272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757805AbXHHBUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 21:20:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, ak@suse.de, greg@kroah.com


The patch titled
     i386: pci_get_device() called from interrupt in reboot fixups
has been added to the -mm tree.  Its filename is
     i386-pci_get_device-called-from-interrupt-in-reboot-fixups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: pci_get_device() called from interrupt in reboot fixups
From: "Denis V. Lunev" <den@openvz.org>

The following calltrace is possible now:
 handle_sysrq
   machine_emergency_restart
     mach_reboot_fixups
       pci_get_device
         pci_get_subsys
	   down_read
The patch skips reboot fixup if called from sysrq-B code.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot_fixups.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/reboot_fixups.c~i386-pci_get_device-called-from-interrupt-in-reboot-fixups arch/i386/kernel/reboot_fixups.c
--- a/arch/i386/kernel/reboot_fixups.c~i386-pci_get_device-called-from-interrupt-in-reboot-fixups
+++ a/arch/i386/kernel/reboot_fixups.c
@@ -11,6 +11,7 @@
 
 #include <asm/delay.h>
 #include <linux/pci.h>
+#include <linux/interrupt.h>
 #include <asm/reboot_fixups.h>
 #include <asm/msr.h>
 
@@ -56,6 +57,11 @@ void mach_reboot_fixups(void)
 	struct pci_dev *dev;
 	int i;
 
+	/* we can be called from sysrq-B code. In such a case it is
+	 * prohibited to dig PCI */
+	if (in_interrupt())
+		return;
+
 	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
 		cur = &(fixups_table[i]);
 		dev = pci_get_device(cur->vendor, cur->device, NULL);
@@ -65,4 +71,3 @@ void mach_reboot_fixups(void)
 		cur->reboot_fixup(dev);
 	}
 }
-
_

Patches currently in -mm which might be from den@openvz.org are

i386-pci_get_device-called-from-interrupt-in-reboot-fixups.patch
