From: akpm@linux-foundation.org
Subject: [merged] usb-gadget-read-buffer-overflow.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:41 -0700
Message-ID: <200908101928.n7AJSf9Y028107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbZHJT3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb gadget: Read buffer overflow
has been removed from the -mm tree.  Its filename was
     usb-gadget-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb gadget: Read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/composite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/gadget/composite.c~usb-gadget-read-buffer-overflow drivers/usb/gadget/composite.c
--- a/drivers/usb/gadget/composite.c~usb-gadget-read-buffer-overflow
+++ a/drivers/usb/gadget/composite.c
@@ -602,7 +602,7 @@ static int get_string(struct usb_composi
 			}
 		}
 
-		for (len = 0; s->wData[len] && len <= 126; len++)
+		for (len = 0; len <= 126 && s->wData[len]; len++)
 			continue;
 		if (!len)
 			return -EINVAL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

