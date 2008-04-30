From: akpm@linux-foundation.org
Subject: - tty-the-big-operations-rework-fix-2.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:14:22 -0700
Message-ID: <200804300614.m3U6ENqn031226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586AbYD3GOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty-the-big-operations-rework-fix-2
has been removed from the -mm tree.  Its filename was
     tty-the-big-operations-rework-fix-2.patch

This patch was dropped because it was folded into tty-the-big-operations-rework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty-the-big-operations-rework-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

fs/compat_ioctl.c: In function 'vt_check':
fs/compat_ioctl.c:1056: error: 'struct tty_driver' has no member named 'ioctl'

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat_ioctl.c~tty-the-big-operations-rework-fix-2 fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~tty-the-big-operations-rework-fix-2
+++ a/fs/compat_ioctl.c
@@ -1053,7 +1053,7 @@ static int vt_check(struct file *file)
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 	                                                
-	if (tty->driver->ioctl != vt_ioctl)
+	if (tty->ops->ioctl != vt_ioctl)
 		return -EINVAL;
 
 	vc = (struct vc_data *)tty->driver_data;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
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

