From: akpm@linux-foundation.org
Subject: - advansys-warning-workaround.patch removed from -mm tree
Date: Wed, 09 May 2007 15:25:17 -0700
Message-ID: <200705092225.l49MPHx0004223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991AbXEIWZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:20 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l49MPHq1009933
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 9 May 2007 15:25:18 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     advansys-warning-workaround
has been removed from the -mm tree.  Its filename was
     advansys-warning-workaround.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: advansys-warning-workaround
From: Andrew Morton <akpm@osdl.org>


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/advansys.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/advansys.c~advansys-warning-workaround drivers/scsi/advansys.c
--- devel/drivers/scsi/advansys.c~advansys-warning-workaround	2006-04-20 00:46:42.000000000 -0700
+++ devel-akpm/drivers/scsi/advansys.c	2006-04-20 00:46:42.000000000 -0700
@@ -2056,11 +2056,12 @@ STATIC ASC_DCNT  AscGetMaxDmaCount(ushor
 /*
  * Define Adv Library required memory access macros.
  */
-#define ADV_MEM_READB(addr) readb(addr)
-#define ADV_MEM_READW(addr) readw(addr)
-#define ADV_MEM_WRITEB(addr, byte) writeb(byte, addr)
-#define ADV_MEM_WRITEW(addr, word) writew(word, addr)
-#define ADV_MEM_WRITEDW(addr, dword) writel(dword, addr)
+#warning these typecasts need to go away
+#define ADV_MEM_READB(addr) readb((void __iomem *)addr)
+#define ADV_MEM_READW(addr) readw((void __iomem *)addr)
+#define ADV_MEM_WRITEB(addr, byte) writeb(byte, (void __iomem *)addr)
+#define ADV_MEM_WRITEW(addr, word) writew(word, (void __iomem *)addr)
+#define ADV_MEM_WRITEDW(addr, dword) writel(dword, (void __iomem *)addr)
 
 #define ADV_CARRIER_COUNT (ASC_DEF_MAX_HOST_QNG + 15)
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
