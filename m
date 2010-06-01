From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-add-missing-spin_unlock-fix2.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:55:02 -0700
Message-ID: <201006012155.o51Lt2YO021102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab0FAVzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, joerg.roedel@amd.com, julia@diku.dk, mingo@redhat.com, tglx@linutronix.de


The patch titled
     arch-x86-kernel-add-missing-spin_unlock-fix
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-add-missing-spin_unlock-fix2.patch

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

doh

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Julia Lawall <julia@diku.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock-fix2 arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock-fix2
+++ a/arch/x86/kernel/amd_iommu.c
@@ -1525,8 +1525,8 @@ static int __attach_device(struct device
 	atomic_inc(&dev_data->bind);
 
 	/* ready */
-	spin_unlock(&domain->lock);
 out:
+	spin_unlock(&domain->lock);
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-x86-kernel-add-missing-spin_unlock-fix2.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
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

