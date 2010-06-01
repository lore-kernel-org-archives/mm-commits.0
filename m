From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-add-missing-spin_unlock-fix.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:14:47 -0700
Message-ID: <201006012114.o51LElRl019016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757238Ab0FAVPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, joerg.roedel@amd.com, julia@diku.dk, mingo@redhat.com, tglx@linutronix.de


The patch titled
     arch-x86-kernel-add-missing-spin_unlock-fix
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-add-missing-spin_unlock-fix.patch

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
Subject: arch-x86-kernel-add-missing-spin_unlock-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid multiple `return' statements

Cc: Julia Lawall <julia@diku.dk>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_iommu.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock-fix arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock-fix
+++ a/arch/x86/kernel/amd_iommu.c
@@ -1487,6 +1487,7 @@ static int __attach_device(struct device
 			   struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data, *alias_data;
+	int ret;
 
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
@@ -1497,18 +1498,17 @@ static int __attach_device(struct device
 	/* lock domain */
 	spin_lock(&domain->lock);
 
+	ret = -EBUSY;
 	/* Some sanity checks */
 	if (alias_data->domain != NULL &&
-	    alias_data->domain != domain) {
-		spin_unlock(&domain->lock);
-		return -EBUSY;
-	}
+	    alias_data->domain != domain)
+		goto out;
 
 	if (dev_data->domain != NULL &&
-	    dev_data->domain != domain) {
-		spin_unlock(&domain->lock);
-		return -EBUSY;
-	}
+	    dev_data->domain != domain)
+		goto out;
+
+	ret = 0;
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
@@ -1526,8 +1526,8 @@ static int __attach_device(struct device
 
 	/* ready */
 	spin_unlock(&domain->lock);
-
-	return 0;
+out:
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
arch-x86-kernel-add-missing-spin_unlock-fix.patch

