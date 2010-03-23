From: akpm@linux-foundation.org
Subject: + vt6655-cgi-csi-confusion-in-device_ioctl.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:48:44 -0400
Message-ID: <201003230649.o2N6nZp7019074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab0CWGti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, greg@kroah.com


The patch titled
     vt6655: CGI/CSI confusion in device_ioctl()
has been added to the -mm tree.  Its filename is
     vt6655-cgi-csi-confusion-in-device_ioctl.patch

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
Subject: vt6655: CGI/CSI confusion in device_ioctl()
From: Roel Kluin <roel.kluin@gmail.com>

The wrong messages were printed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/vt6655/device_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/staging/vt6655/device_main.c~vt6655-cgi-csi-confusion-in-device_ioctl drivers/staging/vt6655/device_main.c
--- a/drivers/staging/vt6655/device_main.c~vt6655-cgi-csi-confusion-in-device_ioctl
+++ a/drivers/staging/vt6655/device_main.c
@@ -3327,7 +3327,7 @@ static int  device_ioctl(struct net_devi
 		break;
 
 	case SIOCSIWTXPOW:
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWTXPOW \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWTXPOW \n");
         rc = -EOPNOTSUPP;
 		break;
 
@@ -3405,7 +3405,7 @@ static int  device_ioctl(struct net_devi
 		// Get the spy list
 	case SIOCGIWSPY:
 
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWSPY \n");
+        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSPY \n");
 		rc = -EOPNOTSUPP;
 		break;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
bfa-wrong-fcport-h2i-message-tested-in-bfa_fcport_isr.patch
vt6655-cgi-csi-confusion-in-device_ioctl.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

