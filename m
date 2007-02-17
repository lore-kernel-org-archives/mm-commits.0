From: akpm@linux-foundation.org
Subject: + sis900-warning-fixes.patch added to -mm tree
Date: Sat, 17 Feb 2007 03:02:57 -0800
Message-ID: <200702171104.l1HB4FDI025314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56228 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946646AbXBQLE3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 06:04:29 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1HB4FhB029824
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 17 Feb 2007 03:04:16 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     sis900 warning fixes
has been added to the -mm tree.  Its filename is
     sis900-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sis900 warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/sis900.c: In function 'sis900_reset_phy':
drivers/net/sis900.c:972: warning: 'status' may be used uninitialized in this function
drivers/net/sis900.c: In function 'sis900_check_mode':
drivers/net/sis900.c:1431: warning: 'status' may be used uninitialized in this function
drivers/net/sis900.c: In function 'sis900_timer':
drivers/net/sis900.c:1467: warning: 'status' may be used uninitialized in this function


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sis900.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/sis900.c~sis900-warning-fixes drivers/net/sis900.c
--- a/drivers/net/sis900.c~sis900-warning-fixes
+++ a/drivers/net/sis900.c
@@ -968,10 +968,10 @@ static void mdio_write(struct net_device
 
 static u16 sis900_reset_phy(struct net_device *net_dev, int phy_addr)
 {
-	int i = 0;
+	int i;
 	u16 status;
 
-	while (i++ < 2)
+	for (i = 0; i < 2; i++)
 		status = mdio_read(net_dev, phy_addr, MII_STATUS);
 
 	mdio_write( net_dev, phy_addr, MII_CONTROL, MII_CNTL_RESET );
@@ -1430,7 +1430,7 @@ static void sis900_auto_negotiate(struct
 	int i = 0;
 	u32 status;
 
-	while (i++ < 2)
+	for (i = 0; i < 2; i++)
 		status = mdio_read(net_dev, phy_addr, MII_STATUS);
 
 	if (!(status & MII_STAT_LINK)){
@@ -1466,9 +1466,9 @@ static void sis900_read_mode(struct net_
 	int phy_addr = sis_priv->cur_phy;
 	u32 status;
 	u16 autoadv, autorec;
-	int i = 0;
+	int i;
 
-	while (i++ < 2)
+	for (i = 0; i < 2; i++)
 		status = mdio_read(net_dev, phy_addr, MII_STATUS);
 
 	if (!(status & MII_STAT_LINK))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
onenand_base-warning-fix.patch
sc520cdp-warning-fix.patch
netsc520-warning-fix.patch
ck804xrom-warning-fix.patch
esb2rom-warning-fixes.patch
amd76xrom-warning-fix.patch
ichxrom-warning-fix.patch
jffs2-warning-fixes.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
git-gccbug-fixup.patch
