From: akpm@linux-foundation.org
Subject: + hpsa-make-hpsa_sdev_attrs-static.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:44 -0800
Message-ID: <200911122253.nACMri7C006495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbZKLW4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Make hpsa_sdev_attrs static
has been added to the -mm tree.  Its filename is
     hpsa-make-hpsa_sdev_attrs-static.patch

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
Subject: hpsa: Make hpsa_sdev_attrs static
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Make hpsa_sdev_attrs static

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hpsa.c~hpsa-make-hpsa_sdev_attrs-static drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-make-hpsa_sdev_attrs-static
+++ a/drivers/scsi/hpsa.c
@@ -155,7 +155,7 @@ DEVICE_ATTR(lunid, S_IRUGO, lunid_show, 
 DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
-struct device_attribute *hpsa_sdev_attrs[] = {
+static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
 	&dev_attr_lunid,
 	&dev_attr_unique_id,
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

