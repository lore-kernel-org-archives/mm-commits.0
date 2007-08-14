From: akpm@linux-foundation.org
Subject: - usb-enable-hcd-support-on-sh-unconditionally.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:38 -0700
Message-ID: <200708141913.l7EJDc9S016526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765571AbXHNTUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: enable hcd support on SH unconditionally.
has been removed from the -mm tree.  Its filename was
     usb-enable-hcd-support-on-sh-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: enable hcd support on SH unconditionally.
From: Paul Mundt <lethal@linux-sh.org>

Previous boards were likely seeing USB_ARCH_HAS_HCD selected by way of
PCMCIA or PCI, though none of those are required for hcd support on SH. 
Enable support unconditionally.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/Kconfig~usb-enable-hcd-support-on-sh-unconditionally drivers/usb/Kconfig
--- a/drivers/usb/Kconfig~usb-enable-hcd-support-on-sh-unconditionally
+++ a/drivers/usb/Kconfig
@@ -18,6 +18,7 @@ config USB_ARCH_HAS_HCD
 	default y if USB_ARCH_HAS_EHCI
 	default y if PCMCIA && !M32R			# sl811_cs
 	default y if ARM				# SL-811
+	default y if SUPERH				# r8a66597-hcd
 	default PCI
 
 # many non-PCI SOC chips embed OHCI
_

Patches currently in -mm which might be from lethal@linux-sh.org are

apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-sh.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
