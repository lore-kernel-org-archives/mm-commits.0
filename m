From: akpm@linux-foundation.org
Subject: + scsi-sd-add-a-no_read_capacity_16-scsi_device-flag.patch added to -mm tree
Date: Mon, 26 Jul 2010 14:41:28 -0700
Message-ID: <201007262141.o6QLfSci011375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab0GZVlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 17:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hdegoede@redhat.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu


The patch titled
     scsi/sd: add a no_read_capacity_16 scsi_device flag
has been added to the -mm tree.  Its filename is
     scsi-sd-add-a-no_read_capacity_16-scsi_device-flag.patch

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
Subject: scsi/sd: add a no_read_capacity_16 scsi_device flag
From: Hans de Goede <hdegoede@redhat.com>

I seem to have a knack for digging up buggy usb devices which don't work
with Linux, and I'm crazy enough to try to make them work.  So this time a
friend of mine asked me to get an mp4 player (an mp3 player which can play
videos on a small screen) to work with Linux.

It is based on the well known rockbox chipset for which we already have an
unusual devs entries to work around some of its bugs.  But this model
comes with an additional twist.

This model chokes on read_capacity_16 calls.  Now normally we don't make
those calls, but this model comes with an sdcard slot and when there is no
card in there (and shipped from the factory there is none), it reports a
size of 0.  However this time the programmers actually got the
read_capacity_10 response right!  So they substract one from the size as
stored internally in the mp3 player before reporting it back, resulting in
an answer of ...  0xffffffff sectors, causing sd.c to try a
read_capacity_16, on which the device crashes.

This patch adds a flag to scsi_device to indicate that a a device cannot
handle read_capacity_16, and when this flag is set if a device reports an
lba of 0xffffffff as answer to a read_capacity_10, assumes it tries to
report a size of 0.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c          |   12 ++++++++++++
 include/scsi/scsi_device.h |    1 +
 2 files changed, 13 insertions(+)

diff -puN drivers/scsi/sd.c~scsi-sd-add-a-no_read_capacity_16-scsi_device-flag drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-sd-add-a-no_read_capacity_16-scsi_device-flag
+++ a/drivers/scsi/sd.c
@@ -1490,6 +1490,9 @@ static int read_capacity_16(struct scsi_
 	unsigned long long lba;
 	unsigned sector_size;
 
+	if (sdp->no_read_capacity_16)
+		return -EINVAL;
+
 	do {
 		memset(cmd, 0, 16);
 		cmd[0] = SERVICE_ACTION_IN;
@@ -1618,6 +1621,15 @@ static int read_capacity_10(struct scsi_
 	sector_size = get_unaligned_be32(&buffer[4]);
 	lba = get_unaligned_be32(&buffer[0]);
 
+	if (sdp->no_read_capacity_16 && (lba == 0xffffffff)) {
+		/* Some buggy (usb cardreader) devices return an lba of
+		   0xffffffff when the want to report a size of 0 (with
+		   which they really mean no media is present) */
+		sdkp->capacity = 0;
+		sdkp->hw_sector_size = sector_size;
+		return sector_size;
+	}
+
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
diff -puN include/scsi/scsi_device.h~scsi-sd-add-a-no_read_capacity_16-scsi_device-flag include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-sd-add-a-no_read_capacity_16-scsi_device-flag
+++ a/include/scsi/scsi_device.h
@@ -149,6 +149,7 @@ struct scsi_device {
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
+	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
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

