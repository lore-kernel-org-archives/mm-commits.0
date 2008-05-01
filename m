From: akpm@linux-foundation.org
Subject: - isdn-switch-to-int-put_char-method.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:34 -0700
Message-ID: <200805010930.m419UYkg030777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbYEAJbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: switch to int put_char method
has been removed from the -mm tree.  Its filename was
     isdn-switch-to-int-put_char-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: switch to int put_char method
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/capi/capi.c~isdn-switch-to-int-put_char-method drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~isdn-switch-to-int-put_char-method
+++ a/drivers/isdn/capi/capi.c
@@ -1111,11 +1111,12 @@ static int capinc_tty_write(struct tty_s
 	return count;
 }
 
-static void capinc_tty_put_char(struct tty_struct *tty, unsigned char ch)
+static int capinc_tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
 	struct sk_buff *skb;
 	unsigned long flags;
+	int ret = 1;
 
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_put_char(%u)\n", ch);
@@ -1125,7 +1126,7 @@ static void capinc_tty_put_char(struct t
 #ifdef _DEBUG_TTYFUNCS
 		printk(KERN_DEBUG "capinc_tty_put_char: mp or mp->ncci NULL\n");
 #endif
-		return;
+		return 0;
 	}
 
 	spin_lock_irqsave(&workaround_lock, flags);
@@ -1134,7 +1135,7 @@ static void capinc_tty_put_char(struct t
 		if (skb_tailroom(skb) > 0) {
 			*(skb_put(skb, 1)) = ch;
 			spin_unlock_irqrestore(&workaround_lock, flags);
-			return;
+			return 1;
 		}
 		mp->ttyskb = NULL;
 		skb_queue_tail(&mp->outqueue, skb);
@@ -1148,8 +1149,10 @@ static void capinc_tty_put_char(struct t
 		mp->ttyskb = skb;
 	} else {
 		printk(KERN_ERR "capinc_put_char: char %u lost\n", ch);
+		ret = 0;
 	}
 	spin_unlock_irqrestore(&workaround_lock, flags);
+	return ret;
 }
 
 static void capinc_tty_flush_chars(struct tty_struct *tty)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

