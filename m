From: akpm@linux-foundation.org
Subject: - tty-the-big-operations-rework-vs-kgdb-2.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:14:35 -0700
Message-ID: <200804300614.m3U6EZPM031239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013AbYD3GPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jason.wessel@windriver.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     tty-the-big-operations-rework vs kgdb (2)
has been removed from the -mm tree.  Its filename was
     tty-the-big-operations-rework-vs-kgdb-2.patch

This patch was dropped because it was folded into tty-the-big-operations-rework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty-the-big-operations-rework vs kgdb (2)
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/kgdboc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/serial/kgdboc.c~tty-the-big-operations-rework-vs-kgdb-2 drivers/serial/kgdboc.c
--- a/drivers/serial/kgdboc.c~tty-the-big-operations-rework-vs-kgdb-2
+++ a/drivers/serial/kgdboc.c
@@ -96,12 +96,14 @@ static void cleanup_kgdboc(void)
 
 static int kgdboc_get_char(void)
 {
-	return kgdb_tty_driver->poll_get_char(kgdb_tty_driver, kgdb_tty_line);
+	return kgdb_tty_driver->ops->poll_get_char(kgdb_tty_driver,
+						kgdb_tty_line);
 }
 
 static void kgdboc_put_char(u8 chr)
 {
-	kgdb_tty_driver->poll_put_char(kgdb_tty_driver, kgdb_tty_line, chr);
+	kgdb_tty_driver->ops->poll_put_char(kgdb_tty_driver,
+					kgdb_tty_line, chr);
 }
 
 static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
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

