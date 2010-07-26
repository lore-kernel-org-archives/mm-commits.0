From: akpm@linux-foundation.org
Subject: + scsi-sr-add-no_read_disc_info-scsi_device-flag.patch added to -mm tree
Date: Mon, 26 Jul 2010 14:41:22 -0700
Message-ID: <201007262141.o6QLfNLx011363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab0GZVlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 17:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hdegoede@redhat.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu


The patch titled
     scsi/sr: add no_read_disc_info scsi_device flag
has been added to the -mm tree.  Its filename is
     scsi-sr-add-no_read_disc_info-scsi_device-flag.patch

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
Subject: scsi/sr: add no_read_disc_info scsi_device flag
From: Hans de Goede <hdegoede@redhat.com>

Some USB devices emulate a usb-mass-storage attached (scsi) cdrom device,
usually this fake cdrom contains the windows software for the device. 
While working on supporting Appotech ax3003 based photoframes, which do
this I discovered that they will go of into lala land when ever they see a
READ_DISC_INFO scsi command.

Thus this patch adds a scsi_device flag (which can then be set by the
usb-storage driver through an unsual-devs entry), to indicate this, and
makes the sr driver honor this flag.

I know this sucks, but as discussed on linux-scsi list there is no other
way to make this device work properly.

Looking at usb traces made under windows, windows never sends a
READ_DISC_INFO during normal interactions with a usb cdrom device.  So as
this cdrom emulation thingie becomes more common we might see more of this
problem.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr.c          |    8 +++++++-
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sr.c~scsi-sr-add-no_read_disc_info-scsi_device-flag drivers/scsi/sr.c
--- a/drivers/scsi/sr.c~scsi-sr-add-no_read_disc_info-scsi_device-flag
+++ a/drivers/scsi/sr.c
@@ -862,10 +862,16 @@ static void get_capabilities(struct scsi
 static int sr_packet(struct cdrom_device_info *cdi,
 		struct packet_command *cgc)
 {
+	struct scsi_cd *cd = cdi->handle;
+	struct scsi_device *sdev = cd->device;
+
+	if (cgc->cmd[0] == GPCMD_READ_DISC_INFO && sdev->no_read_disc_info)
+		return -EDRIVE_CANT_DO_THIS;
+
 	if (cgc->timeout <= 0)
 		cgc->timeout = IOCTL_TIMEOUT;
 
-	sr_do_ioctl(cdi->handle, cgc);
+	sr_do_ioctl(cd, cgc);
 
 	return cgc->stat;
 }
diff -puN include/scsi/scsi_device.h~scsi-sr-add-no_read_disc_info-scsi_device-flag include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-sr-add-no_read_disc_info-scsi_device-flag
+++ a/include/scsi/scsi_device.h
@@ -148,6 +148,7 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
_

Patches currently in -mm which might be from hdegoede@redhat.com are

linux-next.patch
scsi-sr-add-no_read_disc_info-scsi_device-flag.patch
usb-storage-add-new-no_read_disc_info-quirk.patch
scsi-sd-add-a-no_read_capacity_16-scsi_device-flag.patch
usb-storage-add-new-no_read_capacity_16-quirk.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch
hwmon-update-maintainers-for-smm665-driver.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors-v3.patch

