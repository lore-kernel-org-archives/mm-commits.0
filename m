From: akpm@linux-foundation.org
Subject: + minor-updat-to-tlclk-kconfig-entry.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:47:12 -0800
Message-ID: <200703070147.l271lCj6016086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42578 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161172AbXCGBrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, mark.gross@intel.com


The patch titled
     minor updat to tlclk Kconfig entry
has been added to the -mm tree.  Its filename is
     minor-updat-to-tlclk-kconfig-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: minor updat to tlclk Kconfig entry
From: Mark Gross <mgross@linux.intel.com>

The tlclk driver is going on the MPCBL005 so I need to make the Kconfig
more generic.  Just some text changes.

Signed-off-by: Mark Gross <mark.gross@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/char/Kconfig~minor-updat-to-tlclk-kconfig-entry drivers/char/Kconfig
--- a/drivers/char/Kconfig~minor-updat-to-tlclk-kconfig-entry
+++ a/drivers/char/Kconfig
@@ -1026,16 +1026,17 @@ config MMTIMER
 source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
-	tristate "Telecom clock driver for MPBL0010 ATCA SBC"
+	tristate "Telecom clock driver for ATCA SBC"
 	depends on EXPERIMENTAL && X86
 	default n
 	help
-	  The telecom clock device is specific to the MPBL0010 ATCA computer and
-	  allows direct userspace access to the configuration of the telecom clock
-	  configuration settings.  This device is used for hardware synchronization
-	  across the ATCA backplane fabric.  Upon loading, the driver exports a
-	  sysfs directory, /sys/devices/platform/telco_clock, with a number of
-	  files for controlling the behavior of this hardware.
+	  The telecom clock device is specific to the MPCBL0010 and MPCBL0050
+	  ATCA computers and allows direct userspace access to the
+	  configuration of the telecom clock configuration settings.  This
+	  device is used for hardware synchronization across the ATCA backplane
+	  fabric.  Upon loading, the driver exports a sysfs directory,
+	  /sys/devices/platform/telco_clock, with a number of files for
+	  controlling the behavior of this hardware.
 
 endmenu
 
_

Patches currently in -mm which might be from mgross@linux.intel.com are

minor-updat-to-tlclk-kconfig-entry.patch
