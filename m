From: akpm@linux-foundation.org
Subject: + usb-storage-add-new-no_read_disc_info-quirk.patch added to -mm tree
Date: Mon, 26 Jul 2010 14:41:25 -0700
Message-ID: <201007262141.o6QLfP2k011369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458Ab0GZVlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 17:41:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hdegoede@redhat.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu


The patch titled
     usb-storage: add new no_read_disc_info quirk
has been added to the -mm tree.  Its filename is
     usb-storage-add-new-no_read_disc_info-quirk.patch

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
Subject: usb-storage: add new no_read_disc_info quirk
From: Hans de Goede <hdegoede@redhat.com>

Appotech ax3003 (the larger brother of the ax203) based devices are even
more buggy then the ax203.  They will go of into lala land when ever they
see a READ_DISC_INFO scsi command.  So add a new US_FL which tells the
scsi sr driver to not issue any READ_DISC_INFO scsi commands.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/scsiglue.c     |    4 ++++
 drivers/usb/storage/unusual_devs.h |    5 +++++
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/usb/storage/scsiglue.c~usb-storage-add-new-no_read_disc_info-quirk drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c~usb-storage-add-new-no_read_disc_info-quirk
+++ a/drivers/usb/storage/scsiglue.c
@@ -253,6 +253,10 @@ static int slave_configure(struct scsi_d
 		 * or to force 192-byte transfer lengths for MODE SENSE.
 		 * But they do need to use MODE SENSE(10). */
 		sdev->use_10_for_ms = 1;
+
+		/* Some (fake) usb cdrom devices don't like READ_DISC_INFO */
+		if (us->fflags & US_FLAG_NO_READ_DISC_INFO)
+			sdev->no_read_disc_info = 1;
 	}
 
 	/* The CB and CBI transports have no way to pass LUN values
diff -puN drivers/usb/storage/unusual_devs.h~usb-storage-add-new-no_read_disc_info-quirk drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-storage-add-new-no_read_disc_info-quirk
+++ a/drivers/usb/storage/unusual_devs.h
@@ -1858,6 +1858,11 @@ UNUSUAL_DEV( 0x1908, 0x1320, 0x0000, 0x0
 		"Photo Frame",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_BAD_SENSE ),
+UNUSUAL_DEV( 0x1908, 0x3335, 0x0200, 0x0200,
+		"BUILDWIN",
+		"Photo Frame",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_NO_READ_DISC_INFO ),
 
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
diff -puN include/linux/usb_usual.h~usb-storage-add-new-no_read_disc_info-quirk include/linux/usb_usual.h
--- a/include/linux/usb_usual.h~usb-storage-add-new-no_read_disc_info-quirk
+++ a/include/linux/usb_usual.h
@@ -58,7 +58,9 @@
 	US_FLAG(CAPACITY_OK,	0x00010000)			\
 		/* READ CAPACITY response is correct */		\
 	US_FLAG(BAD_SENSE,	0x00020000)			\
-		/* Bad Sense (never more than 18 bytes) */
+		/* Bad Sense (never more than 18 bytes) */	\
+	US_FLAG(NO_READ_DISC_INFO,	0x00040000)		\
+		/* cannot handle READ_DISC_INFO */
 
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

