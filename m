From: akpm@linux-foundation.org
Subject: - epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:12:38 -0700
Message-ID: <200804300612.m3U6Cc5e031087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760505AbYD3GMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch

This patch was dropped because it was folded into epcac-static-functions-and-integer-as-null-pointer-fixes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#25: FILE: drivers/char/epca.c:926:
+	if ((bc = ch->brdchan) == NULL) {

WARNING: no space between function name and open parenthesis '('
#52: FILE: drivers/char/epca.c:2868:
+static int __init init_PCI (void)

total: 1 errors, 1 warnings, 32 lines checked

./patches/epcac-static-functions-and-integer-as-null-pointer-fixes.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/epca.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/epca.c~epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes drivers/char/epca.c
--- a/drivers/char/epca.c~epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes
+++ a/drivers/char/epca.c
@@ -923,7 +923,8 @@ static int pc_open(struct tty_struct *tt
 		return(-ENODEV);
 	}
 
-	if ((bc = ch->brdchan) == NULL) {
+	bc = ch->brdchan;
+	if (bc == NULL) {
 		tty->driver_data = NULL;
 		return -ENODEV;
 	}
@@ -2865,7 +2866,7 @@ static struct pci_device_id epca_pci_tbl
 
 MODULE_DEVICE_TABLE(pci, epca_pci_tbl);
 
-static int __init init_PCI (void)
+static int __init init_PCI(void)
 {
 	memset (&epca_driver, 0, sizeof (epca_driver));
 	epca_driver.name = "epca";
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

