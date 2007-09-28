From: akpm@linux-foundation.org
Subject: + hugetlb-fix-clear_user_highpage-arguments.patch added to -mm tree
Date: Fri, 28 Sep 2007 11:45:30 -0700
Message-ID: <200709281845.l8SIjU6B012247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbXI1SqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 14:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     hugetlb: fix clear_user_highpage arguments
has been added to the -mm tree.  Its filename is
     hugetlb-fix-clear_user_highpage-arguments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix clear_user_highpage arguments
From: Ralf Baechle <ralf@linux-mips.org>

The virtual address space argument of clear_user_highpage is supposed to be
the virtual address where the page being cleared will eventually be mapped.
 This allows architectures with virtually indexed caches a few clever
tricks.  That sort of trick falls over in painful ways if the virtual
address argument is wrong.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-fix-clear_user_highpage-arguments mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-clear_user_highpage-arguments
+++ a/mm/hugetlb.c
@@ -42,7 +42,7 @@ static void clear_huge_page(struct page 
 	might_sleep();
 	for (i = 0; i < (HPAGE_SIZE/PAGE_SIZE); i++) {
 		cond_resched();
-		clear_user_highpage(page + i, addr);
+		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
 	}
 }
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

hugetlb-fix-clear_user_highpage-arguments.patch
clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch
fix-amd-mips-alchemy-au1550-i2c-interface.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
mips-remove-deprecated-irq-flags-sa_.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
