From: akpm@linux-foundation.org
Subject: + mtd-update-sysfs-documentation.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:06:25 -0700
Message-ID: <200904102206.n3AM6PL2014452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbZDJWI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kpc.mtd@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: update sysfs documentation
has been added to the -mm tree.  Its filename is
     mtd-update-sysfs-documentation.patch

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
Subject: mtd: update sysfs documentation
From: Kevin Cernekee <kpc.mtd@gmail.com>

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-mtd |  125 ++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-mtd
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-mtd
@@ -0,0 +1,125 @@
+What:		/sys/class/mtd/
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		The mtd/ class subdirectory belongs to the MTD subsystem
+		(MTD core).
+
+What:		/sys/class/mtd/mtdX/
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		The /sys/class/mtd/mtd{0,1,2,3,...} directories correspond
+		to each /dev/mtdX character device.  These may represent
+		physical/simulated flash devices, partitions on a flash
+		device, or concatenated flash devices.  They exist regardless
+		of whether CONFIG_MTD_CHAR is actually enabled.
+
+What:		/sys/class/mtd/mtdXro/
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		These directories provide the corresponding read-only device
+		nodes for /sys/class/mtd/mtdX/ .  They are only created
+		(for the benefit of udev) if CONFIG_MTD_CHAR is enabled.
+
+What:		/sys/class/mtd/mtdX/dev
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Major and minor numbers of the character device corresponding
+		to this MTD device (in <major>:<minor> format).  This is the
+		read-write device so <minor> will be even.
+
+What:		/sys/class/mtd/mtdXro/dev
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Major and minor numbers of the character device corresponding
+		to the read-only variant of thie MTD device (in
+		<major>:<minor> format).  In this case <minor> will be odd.
+
+What:		/sys/class/mtd/mtdX/erasesize
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		"Major" erase size for the device.  If numeraseregions is
+		zero, this is the eraseblock size for the entire device.
+		Otherwise, the MEMGETREGIONCOUNT/MEMGETREGIONINFO ioctls
+		can be used to determine the actual eraseblock layout.
+
+What:		/sys/class/mtd/mtdX/flags
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		A hexadecimal value representing the device flags, ORed
+		together:
+
+		0x0400: MTD_WRITEABLE - device is writable
+		0x0800: MTD_BIT_WRITEABLE - single bits can be flipped
+		0x1000: MTD_NO_ERASE - no erase necessary
+		0x2000: MTD_POWERUP_LOCK - always locked after reset
+
+What:		/sys/class/mtd/mtdX/name
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		A human-readable ASCII name for the device or partition.
+		This will match the name in /proc/mtd .
+
+What:		/sys/class/mtd/mtdX/numeraseregions
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		For devices that have variable eraseblock sizes, this
+		provides the total number of erase regions.  Otherwise,
+		it will read back as zero.
+
+What:		/sys/class/mtd/mtdX/oobsize
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Number of OOB bytes per page.
+
+What:		/sys/class/mtd/mtdX/size
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Total size of the device/partition, in bytes.
+
+What:		/sys/class/mtd/mtdX/type
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		One of the following ASCII strings, representing the device
+		type:
+
+		absent, ram, rom, nor, nand, dataflash, ubi, unknown
+
+What:		/sys/class/mtd/mtdX/writesize
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Minimal writable flash unit size.  This will always be
+		a positive integer.
+
+		In the case of NOR flash it is 1 (even though individual
+		bits can be cleared).
+
+		In the case of NAND flash it is one NAND page (or a
+		half page, or a quarter page).
+
+		In the case of ECC NOR, it is the ECC block size.
_

Patches currently in -mm which might be from kpc.mtd@gmail.com are

mtd-update-sysfs-documentation.patch
mtd-add-memerase64-ioctl-for-4gib-devices.patch
mtd-compat_ioctl-cleanup.patch
mtd-add-oob-ioctls-for-4gib-devices.patch

