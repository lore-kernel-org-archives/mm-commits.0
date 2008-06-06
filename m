From: akpm@linux-foundation.org
Subject: + usb-digi_accelportc-trivial-sparse-lock-annotation.patch added to -mm tree
Date: Fri, 06 Jun 2008 13:28:18 -0700
Message-ID: <200806062028.m56KSIDN017620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbYFFU2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 16:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     usb: digi_accelport.c trivial sparse lock annotation
has been added to the -mm tree.  Its filename is
     usb-digi_accelportc-trivial-sparse-lock-annotation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: digi_accelport.c trivial sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/digi_acceleport.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/serial/digi_acceleport.c~usb-digi_accelportc-trivial-sparse-lock-annotation drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~usb-digi_accelportc-trivial-sparse-lock-annotation
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -571,6 +571,7 @@ static struct usb_serial_driver digi_acc
 static long cond_wait_interruptible_timeout_irqrestore(
 	wait_queue_head_t *q, long timeout,
 	spinlock_t *lock, unsigned long flags)
+__releases(lock)
 {
 	DEFINE_WAIT(wait);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

lib-export-bitrev16.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch
usb-speedtchc-fix-sparse-shadowed-variable-warning.patch
usb-digi_accelportc-trivial-sparse-lock-annotation.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

