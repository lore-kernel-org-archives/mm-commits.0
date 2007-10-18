From: akpm@linux-foundation.org
Subject: - ncr53c8xx-remove-deprecated-irq-flags-sa_.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:31 -0700
Message-ID: <200710180701.l9I71Vtc031182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbXJRHcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:32:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, James.Bottomley@steeleye.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     NCR53C8XX: Remove deprecated IRQ flags (SA_*)
has been removed from the -mm tree.  Its filename was
     ncr53c8xx-remove-deprecated-irq-flags-sa_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NCR53C8XX: Remove deprecated IRQ flags (SA_*)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Stop using deprecated IRQ flags in ncr53c8xx documentaion.  The new IRQF_*
macros are used instead.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.ncr53c8xx |    6 +++---
 Documentation/scsi/ncr53c8xx.txt       |   14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/scsi/ChangeLog.ncr53c8xx~ncr53c8xx-remove-deprecated-irq-flags-sa_ Documentation/scsi/ChangeLog.ncr53c8xx
--- a/Documentation/scsi/ChangeLog.ncr53c8xx~ncr53c8xx-remove-deprecated-irq-flags-sa_
+++ a/Documentation/scsi/ChangeLog.ncr53c8xx
@@ -195,9 +195,9 @@ Sun Feb  14:00 1999 Gerard Roudier (grou
 	  Pointed out by Leonard Zubkoff.
 	- Allow to tune request_irq() flags from the boot command line using 
 	  ncr53c8xx=irqm:??, as follows:
-	  a) If bit 0x10 is set in irqm, SA_SHIRQ flag is not used.
-	  b) If bit 0x20 is set in irqm, SA_INTERRUPT flag is not used.
-	  By default the driver uses both SA_SHIRQ and SA_INTERRUPT.
+	  a) If bit 0x10 is set in irqm, IRQF_SHARED flag is not used.
+	  b) If bit 0x20 is set in irqm, IRQF_DISABLED flag is not used.
+	  By default the driver uses both IRQF_SHARED and IRQF_DISABLED.
 	  Option 'ncr53c8xx=irqm:0x20' may be used when an IRQ is shared by 
 	  a 53C8XX adapter and a network board.
 	- Tiny mispelling fixed (ABORT instead of ABRT). Was fortunately 
diff -puN Documentation/scsi/ncr53c8xx.txt~ncr53c8xx-remove-deprecated-irq-flags-sa_ Documentation/scsi/ncr53c8xx.txt
--- a/Documentation/scsi/ncr53c8xx.txt~ncr53c8xx-remove-deprecated-irq-flags-sa_
+++ a/Documentation/scsi/ncr53c8xx.txt
@@ -785,8 +785,8 @@ port address 0x1400.
         irqm:0     always open drain
         irqm:1     same as initial settings (assumed BIOS settings)
         irqm:2     always totem pole
-        irqm:0x10  driver will not use SA_SHIRQ flag when requesting irq
-        irqm:0x20  driver will not use SA_INTERRUPT flag when requesting irq
+        irqm:0x10  driver will not use IRQF_SHARED flag when requesting irq
+        irqm:0x20  driver will not use IRQF_DISABLED flag when requesting irq
 
     (Bits 0x10 and 0x20 can be combined with hardware irq mode option)
 
@@ -1236,15 +1236,15 @@ when the SCSI DATA IN phase is reentered
 When an IRQ is shared by devices that are handled by different drivers, it 
 may happen that one driver complains about the request of the IRQ having 
 failed. Inder Linux-2.0, this may be due to one driver having requested the 
-IRQ using the SA_INTERRUPT flag but some other having requested the same IRQ 
+IRQ using the IRQF_DISABLED flag but some other having requested the same IRQ
 without this flag. Under both Linux-2.0 and linux-2.2, this may be caused by 
-one driver not having requested the IRQ with the SA_SHIRQ flag.
+one driver not having requested the IRQ with the IRQF_SHARED flag.
 
 By default, the ncr53c8xx and sym53c8xx drivers request IRQs with both the 
-SA_INTERRUPT and the SA_SHIRQ flag under Linux-2.0 and with only the SA_SHIRQ 
+IRQF_DISABLED and the IRQF_SHARED flag under Linux-2.0 and with only the IRQF_SHARED
 flag under Linux-2.2.
 
-Under Linux-2.0, you can disable use of SA_INTERRUPT flag from the boot 
+Under Linux-2.0, you can disable use of IRQF_DISABLED flag from the boot
 command line by using the following option:
 
      ncr53c8xx=irqm:0x20   (for the generic ncr53c8xx driver)
@@ -1252,7 +1252,7 @@ command line by using the following opti
 
 If this does not fix the problem, then you may want to check how all other 
 drivers are requesting the IRQ and report the problem. Note that if at least 
-a single driver does not request the IRQ with the SA_SHIRQ flag (share IRQ), 
+a single driver does not request the IRQ with the IRQF_SHARED flag (share IRQ),
 then the request of the IRQ obviously will not succeed for all the drivers.
 
 15. SCSI problem troubleshooting
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
