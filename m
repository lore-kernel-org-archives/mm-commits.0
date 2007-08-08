From: akpm@linux-foundation.org
Subject: + usb-r8a66597-hcd-clean-up-error-path.patch added to -mm tree
Date: Tue, 07 Aug 2007 18:25:15 -0700
Message-ID: <200708080125.l781PFW6014508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935182AbXHHBZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 21:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, greg@kroah.com, shimoda.yoshihiro@renesas.com, stern@rowland.harvard.edu


The patch titled
     usb: r8a66597-hcd: Clean up error path.
has been added to the -mm tree.  Its filename is
     usb-r8a66597-hcd-clean-up-error-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: r8a66597-hcd: Clean up error path.
From: Paul Mundt <lethal@linux-sh.org>

Currently when registration fails we're left with a stray reference to
release_mem_region(), this leads to the following case:

    r8a66597_hcd r8a66597_hcd: irq 13, io base 0x18040000
    drivers/usb/host/r8a66597-hcd.c: register access fail.
    r8a66597_hcd r8a66597_hcd: startup error -6
    r8a66597_hcd r8a66597_hcd: USB bus 1 deregistered
    drivers/usb/host/r8a66597-hcd.c: Failed to add hcd
    Trying to free nonexistent resource <0000000018040000-0000000018040000>

This fixes it up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/r8a66597-hcd.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/usb/host/r8a66597-hcd.c~usb-r8a66597-hcd-clean-up-error-path drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~usb-r8a66597-hcd-clean-up-error-path
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -2208,8 +2208,6 @@ static int __init r8a66597_probe(struct 
 clean_up:
 	if (reg)
 		iounmap(reg);
-	if (res)
-		release_mem_region(res->start, 1);
 
 	return ret;
 }
_

Patches currently in -mm which might be from lethal@linux-sh.org are

pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
net-smc91x-build-fixes-for-general-sh-boards.patch
git-sh.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
usb-enable-hcd-support-on-sh-unconditionally.patch
usb-r8a66597-hcd-clean-up-error-path.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
