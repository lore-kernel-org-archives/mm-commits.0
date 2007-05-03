From: akpm@linux-foundation.org
Subject: - ata_timing-ensure-t-cycle-is-always-correct.patch removed from -mm tree
Date: Thu, 03 May 2007 14:19:39 -0700
Message-ID: <200705032122.l43LMTMM020287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993188AbXECVnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 17:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ata_timing: ensure t->cycle is always correct
has been removed from the -mm tree.  Its filename was
     ata_timing-ensure-t-cycle-is-always-correct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata_timing: ensure t->cycle is always correct
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Russell King hit a case where quantisation errors accumulated such that the
cycle time was shorter than rather than equal to the active/recovery time. 
The code already knows how to stretch times to fit the cycle time but does
not know about the reverse.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/ata/libata-core.c~ata_timing-ensure-t-cycle-is-always-correct drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata_timing-ensure-t-cycle-is-always-correct
+++ a/drivers/ata/libata-core.c
@@ -2977,6 +2977,12 @@ int ata_busy_sleep(struct ata_port *ap,
 		return -EBUSY;
 	}
 
+	/* In a few cases quantisation may produce enough errors to
+	   leave t->cycle too low for the sum of active and recovery
+	   if so we must correct this */
+	if (t->active + t->recover > t->cycle)
+		t->cycle = t->active + t->recover;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
driver_bfin_serial_core.patch
git-agpgart.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-pata_qdic-probe-code.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
upper-32-bits.patch
console-utf-8-fixes.patch
add-pci_try_set_mwi.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
