From: akpm@linux-foundation.org
Subject: - kconfig-cleanup-block-kconfig-help-descriptions.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:23 -0700
Message-ID: <200804261642.m3QGgNQT031196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757892AbYDZQmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick@nick-andrew.net, jens.axboe@oracle.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Kconfig: clean up block/Kconfig help descriptions
has been removed from the -mm tree.  Its filename was
     kconfig-cleanup-block-kconfig-help-descriptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kconfig: clean up block/Kconfig help descriptions
From: Nick Andrew <nick@nick-andrew.net>

Modify the help descriptions of block/Kconfig for clarity, accuracy and
consistency.

Refactor the BLOCK description a bit.  The wording "This permits ...  to be
removed" isn't quite right; the block layer is removed when the option is
disabled, whereas most descriptions talk about what happens when the option is
enabled.  Reformat the list of what is affected by disabling the block layer.

Add more examples of large block devices to LBD and strive for technical
accuracy; block devices of size _exactly_ 2TB require CONFIG_LBD, not only
"bigger than 2TB".  Also try to say (perhaps not very clearly) that the config
option is only needed when you want to have individual block devices of size
>= 2TB, for example if you had 3 x 1TB disks in your computer you'd have a
total storage size of 3TB but you wouldn't need the option unless you want to
aggregate those disks into a RAID or LVM.

Improve terminology and grammar on BLK_DEV_IO_TRACE.

I also added the boilerplate "If unsure, say N" to most options.

Precisely say "2TB and larger" for LSF.

Indent the help text for BLK_DEV_BSG by 2 spaces in accordance with the
standard.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig |   65 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 23 deletions(-)

diff -puN block/Kconfig~kconfig-cleanup-block-kconfig-help-descriptions block/Kconfig
--- a/block/Kconfig~kconfig-cleanup-block-kconfig-help-descriptions
+++ a/block/Kconfig
@@ -5,14 +5,18 @@ menuconfig BLOCK
        bool "Enable the block layer" if EMBEDDED
        default y
        help
-	 This permits the block layer to be removed from the kernel if it's not
-	 needed (on some embedded devices for example).  If this option is
-	 disabled, then blockdev files will become unusable and some
-	 filesystems (such as ext3) will become unavailable.
-
-	 This option will also disable SCSI character devices and USB storage
-	 since they make use of various block layer definitions and
-	 facilities.
+	 Provide block layer support for the kernel.
+
+	 Disable this option to remove the block layer support from the
+	 kernel. This may be useful for embedded devices.
+
+	 If this option is disabled:
+
+	   - block device files will become unusable
+	   - some filesystems (such as ext3) will become unavailable.
+
+	 Also, SCSI character devices and USB storage will be disabled since
+	 they make use of various block layer definitions and facilities.
 
 	 Say Y here unless you know you really don't want to mount disks and
 	 suchlike.
@@ -23,9 +27,20 @@ config LBD
 	bool "Support for Large Block Devices"
 	depends on !64BIT
 	help
-	  Say Y here if you want to attach large (bigger than 2TB) discs to
-	  your machine, or if you want to have a raid or loopback device
-	  bigger than 2TB.  Otherwise say N.
+	  Enable block devices of size 2TB and larger.
+
+	  This option is required to support the full capacity of large
+	  (2TB+) block devices, including RAID, disk, Network Block Device,
+	  Logical Volume Manager (LVM) and loopback.
+
+	  For example, RAID devices are frequently bigger than the capacity
+	  of the largest individual hard drive.
+
+	  This option is not required if you have individual disk drives
+	  which total 2TB+ and you are not aggregating the capacity into
+	  a large block device (e.g. using RAID or LVM).
+
+	  If unsure, say N.
 
 config BLK_DEV_IO_TRACE
 	bool "Support for tracing block io actions"
@@ -33,19 +48,21 @@ config BLK_DEV_IO_TRACE
 	select RELAY
 	select DEBUG_FS
 	help
-	  Say Y here, if you want to be able to trace the block layer actions
+	  Say Y here if you want to be able to trace the block layer actions
 	  on a given queue. Tracing allows you to see any traffic happening
-	  on a block device queue. For more information (and the user space
-	  support tools needed), fetch the blktrace app from:
+	  on a block device queue. For more information (and the userspace
+	  support tools needed), fetch the blktrace tools from:
 
 	  git://git.kernel.dk/blktrace.git
 
+	  If unsure, say N.
+
 config LSF
 	bool "Support for Large Single Files"
 	depends on !64BIT
 	help
-	  Say Y here if you want to be able to handle very large files (bigger
-	  than 2TB), otherwise say N.
+	  Say Y here if you want to be able to handle very large files (2TB
+	  and larger), otherwise say N.
 
 	  If unsure, say Y.
 
@@ -53,14 +70,16 @@ config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	---help---
-	Saying Y here will enable generic SG (SCSI generic) v4 support
-	for any block device.
+	  Saying Y here will enable generic SG (SCSI generic) v4 support
+	  for any block device.
+
+	  Unlike SG v3 (aka block/scsi_ioctl.c drivers/scsi/sg.c), SG v4
+	  can handle complicated SCSI commands: tagged variable length cdbs
+	  with bidirectional data transfers and generic request/response
+	  protocols (e.g. Task Management Functions and SMP in Serial
+	  Attached SCSI).
 
-	Unlike SG v3 (aka block/scsi_ioctl.c drivers/scsi/sg.c), SG v4
-	can handle complicated SCSI commands: tagged variable length cdbs
-	with bidirectional data transfers and generic request/response
-	protocols (e.g. Task Management Functions and SMP in Serial
-	Attached SCSI).
+	  If unsure, say N.
 
 endif # BLOCK
 
_

Patches currently in -mm which might be from nick@nick-andrew.net are

origin.patch
raid-remove-leading-tab-on-printk-messages.patch

