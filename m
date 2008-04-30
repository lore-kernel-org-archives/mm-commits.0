From: akpm@linux-foundation.org
Subject: - tty-the-big-operations-rework-simserial-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:14:28 -0700
Message-ID: <200804300614.m3U6ES8n031232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbYD3GOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty-the-big-operations-rework-simserial-fix
has been removed from the -mm tree.  Its filename was
     tty-the-big-operations-rework-simserial-fix.patch

This patch was dropped because it was folded into tty-the-big-operations-rework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty-the-big-operations-rework-simserial-fix
From: Andrew Morton <akpm@linux-foundation.org>

ia64:

arch/ia64/hp/sim/simserial.c: In function `rs_close':
arch/ia64/hp/sim/simserial.c:624: error: structure has no member named `flush_buffer'
arch/ia64/hp/sim/simserial.c:624: error: structure has no member named `flush_buffer'
arch/ia64/hp/sim/simserial.c: At top level:
arch/ia64/hp/sim/simserial.c:942: warning: initialization from incompatible pointer type

and oh dear, I seem to have accidentally fixed the coding style too.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/simserial.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/ia64/hp/sim/simserial.c~tty-the-big-operations-rework-simserial-fix arch/ia64/hp/sim/simserial.c
--- a/arch/ia64/hp/sim/simserial.c~tty-the-big-operations-rework-simserial-fix
+++ a/arch/ia64/hp/sim/simserial.c
@@ -210,21 +210,23 @@ static void do_softint(struct work_struc
 	printk(KERN_ERR "simserial: do_softint called\n");
 }
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct async_struct *info = (struct async_struct *)tty->driver_data;
 	unsigned long flags;
 
-	if (!tty || !info->xmit.buf) return;
+	if (!tty || !info->xmit.buf)
+		return 0;
 
 	local_irq_save(flags);
 	if (CIRC_SPACE(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE) == 0) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 	info->xmit.buf[info->xmit.head] = ch;
 	info->xmit.head = (info->xmit.head + 1) & (SERIAL_XMIT_SIZE-1);
 	local_irq_restore(flags);
+	return 1;
 }
 
 static void transmit_chars(struct async_struct *info, int *intr_done)
@@ -621,7 +623,8 @@ static void rs_close(struct tty_struct *
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	shutdown(info);
-	if (tty->driver->flush_buffer) tty->driver->flush_buffer(tty);
+	if (tty->ops->flush_buffer)
+		tty->ops->flush_buffer(tty);
 	if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
 	info->event = 0;
 	info->tty = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
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

