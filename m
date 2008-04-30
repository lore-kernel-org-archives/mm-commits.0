From: akpm@linux-foundation.org
Subject: - sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:10:55 -0700
Message-ID: <200804300610.m3U6Atxv031024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758023AbYD3GL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sivanich@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2
has been removed from the -mm tree.  Its filename was
     sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch

This patch was dropped because it was folded into sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mmtimer.c~sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2 drivers/char/mmtimer.c
--- a/drivers/char/mmtimer.c~sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2
+++ a/drivers/char/mmtimer.c
@@ -604,7 +604,7 @@ static int sgi_timer_del(struct k_itimer
 	if (timr->it.mmtimer.clock != TIMER_OFF) {
 		unsigned long expires = timr->it.mmtimer.expires;
 		struct rb_node *n = timers[nodeid].timer_head.rb_node;
-		struct mmtimer *t;
+		struct mmtimer *uninitialized_var(t);
 		int r = 0;
 
 		timr->it.mmtimer.clock = TIMER_OFF;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
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

