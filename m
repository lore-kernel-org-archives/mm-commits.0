From: akpm@linux-foundation.org
Subject: + m68knommu-add-info-about-removing-mcfserial.patch added to -mm tree
Date: Mon, 12 May 2008 17:35:03 -0700
Message-ID: <200805130035.m4D0Z3oi016943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496AbYEMAfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@linutronix.de, alan@redhat.com, gerg@uclinux.org


The patch titled
     m68knommu: add info about removing mcfserial
has been added to the -mm tree.  Its filename is
     m68knommu-add-info-about-removing-mcfserial.patch

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
Subject: m68knommu: add info about removing mcfserial
From: Sebastian Siewior <bigeasy@linutronix.de>

Schedule a removal for this driver. Alternative driver is available for
a while now.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Greg Ungerer <gerg@uclinux.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/serial/Kconfig                     |    6 +++++-
 drivers/serial/mcfserial.c                 |    1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/feature-removal-schedule.txt~m68knommu-add-info-about-removing-mcfserial Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~m68knommu-add-info-about-removing-mcfserial
+++ a/Documentation/feature-removal-schedule.txt
@@ -282,6 +282,14 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
 ---------------------------
 
+What:	old style serial driver for ColdFire (CONFIG_SERIAL_COLDFIRE)
+When:	2.6.28
+Why:	This driver still uses the old interface and has been replaced
+	by CONFIG_SERIAL_MCF.
+Who:	Sebastian Siewior <sebastian@breakpoint.cc>
+
+---------------------------
+
 What:	/sys/o2cb symlink
 When:	January 2010
 Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
diff -puN drivers/serial/Kconfig~m68knommu-add-info-about-removing-mcfserial drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~m68knommu-add-info-about-removing-mcfserial
+++ a/drivers/serial/Kconfig
@@ -976,11 +976,15 @@ config SERIAL_68328_RTS_CTS
 	depends on SERIAL_68328
 
 config SERIAL_COLDFIRE
-	bool "ColdFire serial support"
+	bool "ColdFire serial support (DEPRECATED)"
 	depends on COLDFIRE
 	help
 	  This driver supports the built-in serial ports of the Motorola ColdFire
 	  family of CPUs.
+	  This driver is deprecated because it supports only the old interface
+	  for serial drivers and features like magic keys are not working.
+	  Please switch to the new style driver because this driver will be
+	  removed soon.
 
 config SERIAL_MCF
 	bool "Coldfire serial support (new style driver)"
diff -puN drivers/serial/mcfserial.c~m68knommu-add-info-about-removing-mcfserial drivers/serial/mcfserial.c
--- a/drivers/serial/mcfserial.c~m68knommu-add-info-about-removing-mcfserial
+++ a/drivers/serial/mcfserial.c
@@ -1,3 +1,4 @@
+#warning This driver is deprecated. Check Kconfig for details.
 /*
  * mcfserial.c -- serial driver for ColdFire internal UARTS.
  *
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

m68knommu-coldfire-add-support-for-kernel-preemption-missing-chunk.patch
linux-next.patch
m68knommu-add-info-about-removing-mcfserial.patch
add-the-carmine-fb-driver.patch
add-the-carmine-fb-driver-update.patch

