From: akpm@linux-foundation.org
Subject: + usb-storage-add-new-no_read_capacity_16-quirk.patch added to -mm tree
Date: Mon, 26 Jul 2010 14:41:30 -0700
Message-ID: <201007262141.o6QLfU5e011386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458Ab0GZVlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 17:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hdegoede@redhat.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu


The patch titled
     usb-storage: add new no_read_capacity_16 quirk
has been added to the -mm tree.  Its filename is
     usb-storage-add-new-no_read_capacity_16-quirk.patch

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
Subject: usb-storage: add new no_read_capacity_16 quirk
From: Hans de Goede <hdegoede@redhat.com>

Some Rockbox based mp4 players will crash when ever they see a
read_capacity_16 scsi command.  So add a new US_FL which tells the scsi sd
driver to not issue any read_capacity_16 scsi commands.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/scsiglue.c     |    4 ++++
 drivers/usb/storage/unusual_devs.h |    3 ++-
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/usb/storage/scsiglue.c~usb-storage-add-new-no_read_capacity_16-quirk drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c~usb-storage-add-new-no_read_capacity_16-quirk
+++ a/drivers/usb/storage/scsiglue.c
@@ -209,6 +209,10 @@ static int slave_configure(struct scsi_d
 		if (us->fflags & US_FL_CAPACITY_HEURISTICS)
 			sdev->guess_capacity = 1;
 
+		/* Some devices cannot handle READ_CAPACITY_16 */
+		if (us->fflags & US_FL_NO_READ_CAPACITY_16)
+			sdev->no_read_capacity_16 = 1;
+
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
 			us->fflags |= US_FL_SANE_SENSE;
diff -puN drivers/usb/storage/unusual_devs.h~usb-storage-add-new-no_read_capacity_16-quirk drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-storage-add-new-no_read_capacity_16-quirk
+++ a/drivers/usb/storage/unusual_devs.h
@@ -877,7 +877,8 @@ UNUSUAL_DEV(  0x071b, 0x3203, 0x0000, 0x
 		"RockChip",
 		"MP3",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_NO_WP_DETECT | US_FL_MAX_SECTORS_64),
+		US_FL_NO_WP_DETECT | US_FL_MAX_SECTORS_64 |
+		US_FL_NO_READ_CAPACITY_16),
 
 /* Reported by Jean-Baptiste Onofre <jb@nanthrax.net>
  * Support the following product :
diff -puN include/linux/usb_usual.h~usb-storage-add-new-no_read_capacity_16-quirk include/linux/usb_usual.h
--- a/include/linux/usb_usual.h~usb-storage-add-new-no_read_capacity_16-quirk
+++ a/include/linux/usb_usual.h
@@ -60,7 +60,9 @@
 	US_FLAG(BAD_SENSE,	0x00020000)			\
 		/* Bad Sense (never more than 18 bytes) */	\
 	US_FLAG(NO_READ_DISC_INFO,	0x00040000)		\
-		/* cannot handle READ_DISC_INFO */
+		/* cannot handle READ_DISC_INFO */		\
+	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
+		/* cannot handle READ_CAPACITY_16 */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
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

