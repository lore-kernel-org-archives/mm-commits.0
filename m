From: akpm@linux-foundation.org
Subject: [nacked] mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch removed from -mm tree
Date: Tue, 12 Jan 2010 13:45:47 -0800
Message-ID: <201001122145.o0CLjll5029481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab0ALVpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 16:45:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, Eric.moore@lsi.com, James.Bottomley@suse.de, kashyap.desai@lsi.com, mm-commits@vger.kernel.org


The patch titled
     mpt2sas: fix &&/|| confusion in _scsih_sas_device_status_change_event()
has been removed from the -mm tree.  Its filename was
     mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpt2sas: fix &&/|| confusion in _scsih_sas_device_status_change_event()
From: Roel Kluin <roel.kluin@gmail.com>

This never evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Eric Moore <Eric.moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_scsih.c~mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c~mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event
+++ a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4363,7 +4363,7 @@ _scsih_sas_device_status_change_event(st
 #endif
 
 	if (!(event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET ||
 	   event_data->ReasonCode ==
 	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
 		return;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
v4l-dvb-wrong-variable-tested.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

