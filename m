From: akpm@osdl.org
Subject: - jsm_tty-kmalloc-kzalloc-casting-cleanups.patch removed from -mm tree
Date: Mon, 08 Jan 2007 14:36:05 -0800
Message-ID: <200701082236.l08Ma5do021125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977AbXAHWgK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:36:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, mm-commits@vger.kernel.org


The patch titled
     JSM_TTY: kmalloc->kzalloc/Casting cleanups
has been removed from the -mm tree.  Its filename was
     jsm_tty-kmalloc-kzalloc-casting-cleanups.patch

This patch was dropped because it was a dupe

------------------------------------------------------
Subject: JSM_TTY: kmalloc->kzalloc/Casting cleanups
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Signed-off-by: Ahmed Darwish <darwish.07@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/jsm/jsm_tty.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/serial/jsm/jsm_tty.c~jsm_tty-kmalloc-kzalloc-casting-cleanups drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm_tty-kmalloc-kzalloc-casting-cleanups
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -194,31 +194,28 @@ static int jsm_tty_open(struct uart_port
 	/* Drop locks, as malloc with GFP_KERNEL can sleep */
 
 	if (!channel->ch_rqueue) {
-		channel->ch_rqueue = (u8 *) kmalloc(RQUEUESIZE, GFP_KERNEL);
+		channel->ch_rqueue = kzalloc(RQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_rqueue) {
 			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
 				"unable to allocate read queue buf");
 			return -ENOMEM;
 		}
-		memset(channel->ch_rqueue, 0, RQUEUESIZE);
 	}
 	if (!channel->ch_equeue) {
-		channel->ch_equeue = (u8 *) kmalloc(EQUEUESIZE, GFP_KERNEL);
+		channel->ch_equeue = kzalloc(EQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_equeue) {
 			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
 				"unable to allocate error queue buf");
 			return -ENOMEM;
 		}
-		memset(channel->ch_equeue, 0, EQUEUESIZE);
 	}
 	if (!channel->ch_wqueue) {
-		channel->ch_wqueue = (u8 *) kmalloc(WQUEUESIZE, GFP_KERNEL);
+		channel->ch_wqueue = kzalloc(WQUEUESIZE, GFP_KERNEL);
 		if (!channel->ch_wqueue) {
 			jsm_printk(INIT, ERR, &channel->ch_bd->pci_dev,
 				"unable to allocate write queue buf");
 			return -ENOMEM;
 		}
-		memset(channel->ch_wqueue, 0, WQUEUESIZE);
 	}
 
 	channel->ch_flags &= ~(CH_OPENING);
@@ -392,13 +389,12 @@ int jsm_tty_init(struct jsm_board *brd)
 			 * Okay to malloc with GFP_KERNEL, we are not at
 			 * interrupt context, and there are no locks held.
 			 */
-			brd->channels[i] = kmalloc(sizeof(struct jsm_channel), GFP_KERNEL);
+			brd->channels[i] = kzalloc(sizeof(struct jsm_channel), GFP_KERNEL);
 			if (!brd->channels[i]) {
 				jsm_printk(CORE, ERR, &brd->pci_dev,
 					"%s:%d Unable to allocate memory for channel struct\n",
 							 __FILE__, __LINE__);
 			}
-			memset(brd->channels[i], 0, sizeof(struct jsm_channel));
 		}
 	}
 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

cifs-remove-2-unneeded-kzalloc-casts.patch
git-cpufreq.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
jsm_tty-kmalloc-kzalloc-casting-cleanups.patch
