From: akpm@linux-foundation.org
Subject: + isicomc-use-pr_fmt-and-pr_level.patch added to -mm tree
Date: Thu, 08 Oct 2009 14:27:51 -0700
Message-ID: <200910082127.n98LRpIv010813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144AbZJHV2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 17:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jirislaby@gmail.com


The patch titled
     isicom.c: use pr_fmt and pr_<level>
has been added to the -mm tree.  Its filename is
     isicomc-use-pr_fmt-and-pr_level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: isicom.c: use pr_fmt and pr_<level>
=46rom: Joe Perches <joe@perches.com>

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Convert printks to pr_<level>
Convert some embedded function names to %s...__func__
Remove a period after exclamation points.
Remove #define pr_dbg which could be used by future kernel.h includes

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/isicom.c~isicomc-use-pr_fmt-and-pr_level drivers=
/char/isicom.c
--- a/drivers/char/isicom.c~isicomc-use-pr_fmt-and-pr_level
+++ a/drivers/char/isicom.c
@@ -113,6 +113,8 @@
  *		64-bit verification
  */
=20
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/kernel.h>
@@ -140,7 +142,6 @@
 #define InterruptTheCard(base) outw(0, (base) + 0xc)
 #define ClearInterrupt(base) inw((base) + 0x0a)
=20
-#define pr_dbg(str...) pr_debug("ISICOM: " str)
 #ifdef DEBUG
 #define isicom_paranoia_check(a, b, c) __isicom_paranoia_check((a), (b=
), (c))
 #else
@@ -249,8 +250,7 @@ static int lock_card(struct isi_board *c
 		spin_unlock_irqrestore(&card->card_lock, card->flags);
 		msleep(10);
 	}
-	printk(KERN_WARNING "ISICOM: Failed to lock Card (0x%lx)\n",
-		card->base);
+	pr_warning("Failed to lock Card (0x%lx)\n", card->base);
=20
 	return 0;	/* Failed to acquire the card! */
 }
@@ -379,13 +379,13 @@ static inline int __isicom_paranoia_chec
 	char *name, const char *routine)
 {
 	if (!port) {
-		printk(KERN_WARNING "ISICOM: Warning: bad isicom magic for "
-			"dev %s in %s.\n", name, routine);
+		pr_warning("Warning: bad isicom magic for dev %s in %s.\n",
+			   name, routine);
 		return 1;
 	}
 	if (port->magic !=3D ISICOM_MAGIC) {
-		printk(KERN_WARNING "ISICOM: Warning: NULL isicom port for "
-			"dev %s in %s.\n", name, routine);
+		pr_warning("Warning: NULL isicom port for dev %s in %s.\n",
+			   name, routine);
 		return 1;
 	}
=20
@@ -450,8 +450,8 @@ static void isicom_tx(unsigned long _dat
 		if (!(inw(base + 0x02) & (1 << port->channel)))
 			continue;
=20
-		pr_dbg("txing %d bytes, port%d.\n", txcount,
-			port->channel + 1);
+		pr_debug("txing %d bytes, port%d.\n",
+			 txcount, port->channel + 1);
 		outw((port->channel << isi_card[card].shift_count) | txcount,
 			base);
 		residue =3D NO;
@@ -547,8 +547,8 @@ static irqreturn_t isicom_interrupt(int=20
 	byte_count =3D header & 0xff;
=20
 	if (channel + 1 > card->port_count) {
-		printk(KERN_WARNING "ISICOM: isicom_interrupt(0x%lx): "
-			"%d(channel) > port_count.\n", base, channel+1);
+		pr_warning("%s(0x%lx): %d(channel) > port_count.\n",
+			   __func__, base, channel+1);
 		outw(0x0000, base+0x04); /* enable interrupts */
 		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
@@ -582,14 +582,15 @@ static irqreturn_t isicom_interrupt(int=20
 				if (port->status & ISI_DCD) {
 					if (!(header & ISI_DCD)) {
 					/* Carrier has been lost  */
-						pr_dbg("interrupt: DCD->low.\n"
-							);
+						pr_debug("%s: DCD->low.\n",
+							 __func__);
 						port->status &=3D ~ISI_DCD;
 						tty_hangup(tty);
 					}
 				} else if (header & ISI_DCD) {
 				/* Carrier has been detected */
-					pr_dbg("interrupt: DCD->high.\n");
+					pr_debug("%s: DCD->high.\n",
+						__func__);
 					port->status |=3D ISI_DCD;
 					wake_up_interruptible(&port->port.open_wait);
 				}
@@ -641,17 +642,19 @@ static irqreturn_t isicom_interrupt(int=20
 			break;
=20
 		case 2:	/* Statistics		 */
-			pr_dbg("isicom_interrupt: stats!!!.\n");
+			pr_debug("%s: stats!!!\n", __func__);
 			break;
=20
 		default:
-			pr_dbg("Intr: Unknown code in status packet.\n");
+			pr_debug("%s: Unknown code in status packet.\n",
+				 __func__);
 			break;
 		}
 	} else {				/* Data   Packet */
=20
 		count =3D tty_prepare_flip_string(tty, &rp, byte_count & ~1);
-		pr_dbg("Intr: Can rx %d of %d bytes.\n", count, byte_count);
+		pr_debug("%s: Can rx %d of %d bytes.\n",
+			 __func__, count, byte_count);
 		word_count =3D count >> 1;
 		insw(base, rp, word_count);
 		byte_count -=3D (word_count << 1);
@@ -661,8 +664,8 @@ static irqreturn_t isicom_interrupt(int=20
 			byte_count -=3D 2;
 		}
 		if (byte_count > 0) {
-			pr_dbg("Intr(0x%lx:%d): Flip buffer overflow! dropping "
-				"bytes...\n", base, channel + 1);
+			pr_debug("%s(0x%lx:%d): Flip buffer overflow! dropping bytes...\n",
+				 __func__, base, channel + 1);
 		/* drain out unread xtra data */
 		while (byte_count > 0) {
 				inw(base);
@@ -939,8 +942,8 @@ static void isicom_shutdown_port(struct=20
 		set_bit(TTY_IO_ERROR, &tty->flags);
=20
 	if (--card->count < 0) {
-		pr_dbg("isicom_shutdown_port: bad board(0x%lx) count %d.\n",
-			card->base, card->count);
+		pr_debug("%s: bad board(0x%lx) count %d.\n",
+			 __func__, card->base, card->count);
 		card->count =3D 0;
 	}
=20
@@ -1746,13 +1749,13 @@ static int __init isicom_init(void)
=20
 	retval =3D tty_register_driver(isicom_normal);
 	if (retval) {
-		pr_dbg("Couldn't register the dialin driver\n");
+		pr_debug("Couldn't register the dialin driver\n");
 		goto err_puttty;
 	}
=20
 	retval =3D pci_register_driver(&isicom_driver);
 	if (retval < 0) {
-		printk(KERN_ERR "ISICOM: Unable to register pci driver.\n");
+		pr_err("Unable to register pci driver.\n");
 		goto err_unrtty;
 	}
=20
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
