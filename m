From: akpm@linux-foundation.org
Subject: - tty-the-big-operations-rework-isicom-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:14:25 -0700
Message-ID: <200804300614.m3U6EP2V031229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbYD3GOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tty-the-big-operations-rework-isicom-fix
has been removed from the -mm tree.  Its filename was
     tty-the-big-operations-rework-isicom-fix.patch

This patch was dropped because it was folded into tty-the-big-operations-rework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty-the-big-operations-rework-isicom-fix
From: Andrew Morton <akpm@linux-foundation.org>

Now undo what we did to get everything nice.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/char/isicom.c~tty-the-big-operations-rework-isicom-fix drivers/char/isicom.c
--- a/drivers/char/isicom.c~tty-the-big-operations-rework-isicom-fix
+++ a/drivers/char/isicom.c
@@ -1140,28 +1140,29 @@ static int isicom_write(struct tty_struc
 }
 
 /* put_char et all */
-static void isicom_put_char(struct tty_struct *tty, unsigned char ch)
+static int isicom_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct isi_port *port = tty->driver_data;
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_put_char"))
-		return;
+		return 0;
 
 	if (!port->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
-		goto out;
+	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
+		spin_unlock_irqrestore(&card->card_lock, flags);
+		return 0;
+	}
 
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= (SERIAL_XMIT_SIZE - 1);
 	port->xmit_cnt++;
 	spin_unlock_irqrestore(&card->card_lock, flags);
-out:
-	return;
+	return 1;
 }
 
 /* flush_chars et all */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
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

