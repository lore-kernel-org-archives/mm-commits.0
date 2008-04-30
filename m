From: akpm@linux-foundation.org
Subject: - sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:10:53 -0700
Message-ID: <200804300610.m3U6ArUX031021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755957AbYD3GLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sivanich@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix
has been removed from the -mm tree.  Its filename was
     sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch

This patch was dropped because it was folded into sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix
From: Andrew Morton <akpm@linux-foundation.org>

mark things static

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mmtimer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/mmtimer.c~sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix drivers/char/mmtimer.c
--- a/drivers/char/mmtimer.c~sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix
+++ a/drivers/char/mmtimer.c
@@ -241,7 +241,7 @@ static struct mmtimer_node *timers;
  * Add a new mmtimer struct to the node's mmtimer list.
  * This function assumes the struct mmtimer_node is locked.
  */
-void mmtimer_add_list(struct mmtimer *n)
+static void mmtimer_add_list(struct mmtimer *n)
 {
 	int nodeid = n->timer->it.mmtimer.node;
 	unsigned long expires = n->timer->it.mmtimer.expires;
@@ -278,7 +278,7 @@ void mmtimer_add_list(struct mmtimer *n)
  * Set the comparator for the next timer.
  * This function assumes the struct mmtimer_node is locked.
  */
-void mmtimer_set_next_timer(int nodeid)
+static void mmtimer_set_next_timer(int nodeid)
 {
 	struct mmtimer_node *n = &timers[nodeid];
 	struct mmtimer *x;
@@ -539,7 +539,7 @@ mmtimer_interrupt(int irq, void *dev_id)
 	return result;
 }
 
-void mmtimer_tasklet(unsigned long data)
+static void mmtimer_tasklet(unsigned long data)
 {
 	int nodeid = data;
 	struct mmtimer_node *mn = &timers[nodeid];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
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

