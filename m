From: akpm@linux-foundation.org
Subject: + 80211core-fix-confusion.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:46:52 -0800
Message-ID: <201001070046.o070kqB4028433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932549Ab0AGAqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, devel@driverdev.osuosl.org, greg@kroah.com


The patch titled
     80211core: fix &&/|| confusion
has been added to the -mm tree.  Its filename is
     80211core-fix-confusion.patch

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
Subject: 80211core: fix &&/|| confusion
From: Roel Kluin <roel.kluin@gmail.com>

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: <devel@driverdev.osuosl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/otus/80211core/cmmsta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/otus/80211core/cmmsta.c~80211core-fix-confusion drivers/staging/otus/80211core/cmmsta.c
--- a/drivers/staging/otus/80211core/cmmsta.c~80211core-fix-confusion
+++ a/drivers/staging/otus/80211core/cmmsta.c
@@ -2808,7 +2808,7 @@ void zfStaProcessProbeReq(zdev_t* dev, z
     zmw_get_wlan_dev(dev);
 
     /* check mode : AP/IBSS */
-    if ((wd->wlanMode != ZM_MODE_AP) || (wd->wlanMode != ZM_MODE_IBSS))
+    if ((wd->wlanMode != ZM_MODE_AP) && (wd->wlanMode != ZM_MODE_IBSS))
     {
         zm_msg0_mm(ZM_LV_3, "Ignore probe req");
         return;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drm-kms-fix-confusion-in-drm_fb_helper_connector_parse_command_line.patch
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

