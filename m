From: akpm@linux-foundation.org
Subject: - tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:14:19 -0700
Message-ID: <200804300614.m3U6EJbQ031223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757630AbYD3GOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty-the-big-operations-rework-broke-wan x25_asy fix
has been removed from the -mm tree.  Its filename was
     tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch

This patch was dropped because it was folded into tty-the-big-operations-rework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty-the-big-operations-rework-broke-wan x25_asy fix
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Coding Style
- Correct printks
- Printk levels
- Switch to ->ops

Replaces Andrews && BROKEN quick fix

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/x25_asy.c |  277 +++++++++++++++++-------------------
 1 file changed, 134 insertions(+), 143 deletions(-)

diff -puN drivers/net/wan/x25_asy.c~tty-the-big-operations-rework-broke-wan-x25_asy-fix drivers/net/wan/x25_asy.c
--- a/drivers/net/wan/x25_asy.c~tty-the-big-operations-rework-broke-wan-x25_asy-fix
+++ a/drivers/net/wan/x25_asy.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 
 #include <asm/system.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
 #include <linux/mm.h>
@@ -95,7 +95,7 @@ static struct x25_asy *x25_asy_alloc(voi
 			x25_asy_devs[i] = dev;
 			return sl;
 		} else {
-			printk("x25_asy_alloc() - register_netdev() failure.\n");
+			printk(KERN_WARNING "x25_asy_alloc() - register_netdev() failure.\n");
 			free_netdev(dev);
 		}
 	}
@@ -112,23 +112,22 @@ static void x25_asy_free(struct x25_asy 
 	kfree(sl->xbuff);
 	sl->xbuff = NULL;
 
-	if (!test_and_clear_bit(SLF_INUSE, &sl->flags)) {
-		printk("%s: x25_asy_free for already free unit.\n", sl->dev->name);
-	}
+	if (!test_and_clear_bit(SLF_INUSE, &sl->flags))
+		printk(KERN_ERR "%s: x25_asy_free for already free unit.\n",
+			sl->dev->name);
 }
 
 static int x25_asy_change_mtu(struct net_device *dev, int newmtu)
 {
 	struct x25_asy *sl = dev->priv;
 	unsigned char *xbuff, *rbuff;
-	int len = 2* newmtu;
+	int len = 2 * newmtu;
 
 	xbuff = kmalloc(len + 4, GFP_ATOMIC);
 	rbuff = kmalloc(len + 4, GFP_ATOMIC);
 
-	if (xbuff == NULL || rbuff == NULL)  
-	{
-		printk("%s: unable to grow X.25 buffers, MTU change cancelled.\n",
+	if (xbuff == NULL || rbuff == NULL) {
+		printk(KERN_WARNING "%s: unable to grow X.25 buffers, MTU change cancelled.\n",
 		       dev->name);
 		kfree(xbuff);
 		kfree(rbuff);
@@ -193,25 +192,23 @@ static void x25_asy_bump(struct x25_asy 
 	int err;
 
 	count = sl->rcount;
-	sl->stats.rx_bytes+=count;
-	
+	sl->stats.rx_bytes += count;
+
 	skb = dev_alloc_skb(count+1);
-	if (skb == NULL)  
-	{
-		printk("%s: memory squeeze, dropping packet.\n", sl->dev->name);
+	if (skb == NULL) {
+		printk(KERN_WARNING "%s: memory squeeze, dropping packet.\n",
+			sl->dev->name);
 		sl->stats.rx_dropped++;
 		return;
 	}
-	skb_push(skb,1);	/* LAPB internal control */
-	memcpy(skb_put(skb,count), sl->rbuff, count);
+	skb_push(skb, 1);	/* LAPB internal control */
+	memcpy(skb_put(skb, count), sl->rbuff, count);
 	skb->protocol = x25_type_trans(skb, sl->dev);
-	if((err=lapb_data_received(skb->dev, skb))!=LAPB_OK)
-	{
+	err = lapb_data_received(skb->dev, skb);
+	if (err != LAPB_OK) {
 		kfree_skb(skb);
-		printk(KERN_DEBUG "x25_asy: data received err - %d\n",err);
-	}
-	else
-	{
+		printk(KERN_DEBUG "x25_asy: data received err - %d\n", err);
+	} else {
 		netif_rx(skb);
 		sl->dev->last_rx = jiffies;
 		sl->stats.rx_packets++;
@@ -224,10 +221,11 @@ static void x25_asy_encaps(struct x25_as
 	unsigned char *p;
 	int actual, count, mtu = sl->dev->mtu;
 
-	if (len > mtu) 
-	{		/* Sigh, shouldn't occur BUT ... */
+	if (len > mtu) {
+		/* Sigh, shouldn't occur BUT ... */
 		len = mtu;
-		printk ("%s: truncating oversized transmit packet!\n", sl->dev->name);
+		printk(KERN_DEBUG "%s: truncating oversized transmit packet!\n",
+					sl->dev->name);
 		sl->stats.tx_dropped++;
 		x25_asy_unlock(sl);
 		return;
@@ -245,7 +243,7 @@ static void x25_asy_encaps(struct x25_as
 	 *       14 Oct 1994  Dmitry Gorodchanin.
 	 */
 	sl->tty->flags |= (1 << TTY_DO_WRITE_WAKEUP);
-	actual = sl->tty->driver->write(sl->tty, sl->xbuff, count);
+	actual = sl->tty->ops->write(sl->tty, sl->xbuff, count);
 	sl->xleft = count - actual;
 	sl->xhead = sl->xbuff + actual;
 	/* VSV */
@@ -265,8 +263,7 @@ static void x25_asy_write_wakeup(struct 
 	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
 		return;
 
-	if (sl->xleft <= 0)  
-	{
+	if (sl->xleft <= 0) {
 		/* Now serial buffer is almost free & we can start
 		 * transmission of another packet */
 		sl->stats.tx_packets++;
@@ -275,14 +272,14 @@ static void x25_asy_write_wakeup(struct 
 		return;
 	}
 
-	actual = tty->driver->write(tty, sl->xhead, sl->xleft);
+	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
 	sl->xleft -= actual;
 	sl->xhead += actual;
 }
 
 static void x25_asy_timeout(struct net_device *dev)
 {
-	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
+	struct x25_asy *sl = dev->priv;
 
 	spin_lock(&sl->lock);
 	if (netif_queue_stopped(dev)) {
@@ -290,7 +287,7 @@ static void x25_asy_timeout(struct net_d
 		 *      14 Oct 1994 Dmitry Gorodchanin.
 		 */
 		printk(KERN_WARNING "%s: transmit timed out, %s?\n", dev->name,
-		       (sl->tty->driver->chars_in_buffer(sl->tty) || sl->xleft) ?
+		       (tty_chars_in_buffer(sl->tty) || sl->xleft) ?
 		       "bad line quality" : "driver error");
 		sl->xleft = 0;
 		sl->tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
@@ -303,31 +300,34 @@ static void x25_asy_timeout(struct net_d
 
 static int x25_asy_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
+	struct x25_asy *sl = dev->priv;
 	int err;
 
 	if (!netif_running(sl->dev)) {
-		printk("%s: xmit call when iface is down\n", dev->name);
+		printk(KERN_ERR "%s: xmit call when iface is down\n",
+			dev->name);
 		kfree_skb(skb);
 		return 0;
 	}
-	
-	switch(skb->data[0])
-	{
-		case 0x00:break;
-		case 0x01: /* Connection request .. do nothing */
-			if((err=lapb_connect_request(dev))!=LAPB_OK)
-				printk(KERN_ERR "x25_asy: lapb_connect_request error - %d\n", err);
-			kfree_skb(skb);
-			return 0;
-		case 0x02: /* Disconnect request .. do nothing - hang up ?? */
-			if((err=lapb_disconnect_request(dev))!=LAPB_OK)
-				printk(KERN_ERR "x25_asy: lapb_disconnect_request error - %d\n", err);
-		default:
-			kfree_skb(skb);
-			return  0;
+
+	switch (skb->data[0]) {
+	case 0x00:
+		break;
+	case 0x01: /* Connection request .. do nothing */
+		err = lapb_connect_request(dev);
+		if (err != LAPB_OK)
+			printk(KERN_ERR "x25_asy: lapb_connect_request error - %d\n", err);
+		kfree_skb(skb);
+		return 0;
+	case 0x02: /* Disconnect request .. do nothing - hang up ?? */
+		err = lapb_disconnect_request(dev);
+		if (err != LAPB_OK)
+			printk(KERN_ERR "x25_asy: lapb_disconnect_request error - %d\n", err);
+	default:
+		kfree_skb(skb);
+		return  0;
 	}
-	skb_pull(skb,1);	/* Remove control byte */
+	skb_pull(skb, 1);	/* Remove control byte */
 	/*
 	 * If we are busy already- too bad.  We ought to be able
 	 * to queue things at this point, to allow for a little
@@ -338,10 +338,10 @@ static int x25_asy_xmit(struct sk_buff *
 	 * So, no queues !
 	 *        14 Oct 1994  Dmitry Gorodchanin.
 	 */
-	
-	if((err=lapb_data_request(dev,skb))!=LAPB_OK)
-	{
-		printk(KERN_ERR "lapbeth: lapb_data_request error - %d\n", err);
+
+	err = lapb_data_request(dev, skb);
+	if (err != LAPB_OK) {
+		printk(KERN_ERR "x25_asy: lapb_data_request error - %d\n", err);
 		kfree_skb(skb);
 		return 0;
 	}
@@ -357,7 +357,7 @@ static int x25_asy_xmit(struct sk_buff *
  *	Called when I frame data arrives. We did the work above - throw it
  *	at the net layer.
  */
-  
+
 static int x25_asy_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
 	skb->dev->last_rx = jiffies;
@@ -369,24 +369,22 @@ static int x25_asy_data_indication(struc
  *	busy cases too well. Its tricky to see how to do this nicely -
  *	perhaps lapb should allow us to bounce this ?
  */
- 
+
 static void x25_asy_data_transmit(struct net_device *dev, struct sk_buff *skb)
 {
-	struct x25_asy *sl=dev->priv;
-	
+	struct x25_asy *sl = dev->priv;
+
 	spin_lock(&sl->lock);
-	if (netif_queue_stopped(sl->dev) || sl->tty == NULL)
-	{
+	if (netif_queue_stopped(sl->dev) || sl->tty == NULL) {
 		spin_unlock(&sl->lock);
 		printk(KERN_ERR "x25_asy: tbusy drop\n");
 		kfree_skb(skb);
 		return;
 	}
 	/* We were not busy, so we are now... :-) */
-	if (skb != NULL) 
-	{
+	if (skb != NULL) {
 		x25_asy_lock(sl);
-		sl->stats.tx_bytes+=skb->len;
+		sl->stats.tx_bytes += skb->len;
 		x25_asy_encaps(sl, skb->data, skb->len);
 		dev_kfree_skb(skb);
 	}
@@ -396,15 +394,16 @@ static void x25_asy_data_transmit(struct
 /*
  *	LAPB connection establish/down information.
  */
- 
+
 static void x25_asy_connected(struct net_device *dev, int reason)
 {
 	struct x25_asy *sl = dev->priv;
 	struct sk_buff *skb;
 	unsigned char *ptr;
 
-	if ((skb = dev_alloc_skb(1)) == NULL) {
-		printk(KERN_ERR "lapbeth: out of memory\n");
+	skb = dev_alloc_skb(1);
+	if (skb == NULL) {
+		printk(KERN_ERR "x25_asy: out of memory\n");
 		return;
 	}
 
@@ -422,7 +421,8 @@ static void x25_asy_disconnected(struct 
 	struct sk_buff *skb;
 	unsigned char *ptr;
 
-	if ((skb = dev_alloc_skb(1)) == NULL) {
+	skb = dev_alloc_skb(1);
+	if (skb == NULL) {
 		printk(KERN_ERR "x25_asy: out of memory\n");
 		return;
 	}
@@ -449,7 +449,7 @@ static struct lapb_register_struct x25_a
 /* Open the low-level part of the X.25 channel. Easy! */
 static int x25_asy_open(struct net_device *dev)
 {
-	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
+	struct x25_asy *sl = dev->priv;
 	unsigned long len;
 	int err;
 
@@ -466,13 +466,11 @@ static int x25_asy_open(struct net_devic
 	len = dev->mtu * 2;
 
 	sl->rbuff = kmalloc(len + 4, GFP_KERNEL);
-	if (sl->rbuff == NULL)   {
+	if (sl->rbuff == NULL)
 		goto norbuff;
-	}
 	sl->xbuff = kmalloc(len + 4, GFP_KERNEL);
-	if (sl->xbuff == NULL)   {
+	if (sl->xbuff == NULL)
 		goto noxbuff;
-	}
 
 	sl->buffsize = len;
 	sl->rcount   = 0;
@@ -480,11 +478,12 @@ static int x25_asy_open(struct net_devic
 	sl->flags   &= (1 << SLF_INUSE);      /* Clear ESCAPE & ERROR flags */
 
 	netif_start_queue(dev);
-			
+
 	/*
 	 *	Now attach LAPB
 	 */
-	if((err=lapb_register(dev, &x25_asy_callbacks))==LAPB_OK)
+	err = lapb_register(dev, &x25_asy_callbacks);
+	if (err == LAPB_OK)
 		return 0;
 
 	/* Cleanup */
@@ -499,18 +498,20 @@ norbuff:
 /* Close the low-level part of the X.25 channel. Easy! */
 static int x25_asy_close(struct net_device *dev)
 {
-	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
+	struct x25_asy *sl = dev->priv;
 	int err;
 
 	spin_lock(&sl->lock);
-	if (sl->tty) 
+	if (sl->tty)
 		sl->tty->flags &= ~(1 << TTY_DO_WRITE_WAKEUP);
 
 	netif_stop_queue(dev);
 	sl->rcount = 0;
 	sl->xleft  = 0;
-	if((err=lapb_unregister(dev))!=LAPB_OK)
-		printk(KERN_ERR "x25_asy_close: lapb_unregister error -%d\n",err);
+	err = lapb_unregister(dev);
+	if (err != LAPB_OK)
+		printk(KERN_ERR "x25_asy_close: lapb_unregister error -%d\n",
+			err);
 	spin_unlock(&sl->lock);
 	return 0;
 }
@@ -521,8 +522,9 @@ static int x25_asy_close(struct net_devi
  * a block of X.25 data has been received, which can now be decapsulated
  * and sent on to some IP layer for further processing.
  */
- 
-static void x25_asy_receive_buf(struct tty_struct *tty, const unsigned char *cp, char *fp, int count)
+
+static void x25_asy_receive_buf(struct tty_struct *tty,
+				const unsigned char *cp, char *fp, int count)
 {
 	struct x25_asy *sl = (struct x25_asy *) tty->disc_data;
 
@@ -533,9 +535,8 @@ static void x25_asy_receive_buf(struct t
 	/* Read the characters out of the buffer */
 	while (count--) {
 		if (fp && *fp++) {
-			if (!test_and_set_bit(SLF_ERROR, &sl->flags))  {
+			if (!test_and_set_bit(SLF_ERROR, &sl->flags))
 				sl->stats.rx_errors++;
-			}
 			cp++;
 			continue;
 		}
@@ -556,31 +557,31 @@ static int x25_asy_open_tty(struct tty_s
 	struct x25_asy *sl = (struct x25_asy *) tty->disc_data;
 	int err;
 
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
 	/* First make sure we're not already connected. */
-	if (sl && sl->magic == X25_ASY_MAGIC) {
+	if (sl && sl->magic == X25_ASY_MAGIC)
 		return -EEXIST;
-	}
 
 	/* OK.  Find a free X.25 channel to use. */
-	if ((sl = x25_asy_alloc()) == NULL) {
+	sl = x25_asy_alloc();
+	if (sl == NULL)
 		return -ENFILE;
-	}
 
 	sl->tty = tty;
 	tty->disc_data = sl;
 	tty->receive_room = 65536;
-	if (tty->driver->flush_buffer)  {
-		tty->driver->flush_buffer(tty);
-	}
+	tty_driver_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	/* Restore default settings */
 	sl->dev->type = ARPHRD_X25;
-	
+
 	/* Perform the low-level X.25 async init */
-	if ((err = x25_asy_open(sl->dev)))
+	err = x25_asy_open(sl->dev);
+	if (err)
 		return err;
-
 	/* Done.  We have linked the TTY line to a channel. */
 	return sl->dev->base_addr;
 }
@@ -601,9 +602,7 @@ static void x25_asy_close_tty(struct tty
 		return;
 
 	if (sl->dev->flags & IFF_UP)
-	{
-		(void) dev_close(sl->dev);
-	}
+		dev_close(sl->dev);
 
 	tty->disc_data = NULL;
 	sl->tty = NULL;
@@ -613,8 +612,7 @@ static void x25_asy_close_tty(struct tty
 
 static struct net_device_stats *x25_asy_get_stats(struct net_device *dev)
 {
-	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
-
+	struct x25_asy *sl = dev->priv;
 	return &sl->stats;
 }
 
@@ -641,21 +639,19 @@ int x25_asy_esc(unsigned char *s, unsign
 	 * character sequence, according to the X.25 protocol.
 	 */
 
-	while (len-- > 0) 
-	{
-		switch(c = *s++) 
-		{
-			case X25_END:
-				*ptr++ = X25_ESC;
-				*ptr++ = X25_ESCAPE(X25_END);
-				break;
-			case X25_ESC:
-				*ptr++ = X25_ESC;
-				*ptr++ = X25_ESCAPE(X25_ESC);
-				break;
-			 default:
-				*ptr++ = c;
-				break;
+	while (len-- > 0) {
+		switch (c = *s++) {
+		case X25_END:
+			*ptr++ = X25_ESC;
+			*ptr++ = X25_ESCAPE(X25_END);
+			break;
+		case X25_ESC:
+			*ptr++ = X25_ESC;
+			*ptr++ = X25_ESCAPE(X25_ESC);
+			break;
+		default:
+			*ptr++ = c;
+			break;
 		}
 	}
 	*ptr++ = X25_END;
@@ -665,31 +661,25 @@ int x25_asy_esc(unsigned char *s, unsign
 static void x25_asy_unesc(struct x25_asy *sl, unsigned char s)
 {
 
-	switch(s) 
-	{
-		case X25_END:
-			if (!test_and_clear_bit(SLF_ERROR, &sl->flags) && (sl->rcount > 2))  
-			{
-				x25_asy_bump(sl);
-			}
-			clear_bit(SLF_ESCAPE, &sl->flags);
-			sl->rcount = 0;
-			return;
-
-		case X25_ESC:
-			set_bit(SLF_ESCAPE, &sl->flags);
-			return;
-			
-		case X25_ESCAPE(X25_ESC):
-		case X25_ESCAPE(X25_END):
-			if (test_and_clear_bit(SLF_ESCAPE, &sl->flags))
-				s = X25_UNESCAPE(s);
-			break;
+	switch (s) {
+	case X25_END:
+		if (!test_and_clear_bit(SLF_ERROR, &sl->flags)
+			&& sl->rcount > 2)
+			x25_asy_bump(sl);
+		clear_bit(SLF_ESCAPE, &sl->flags);
+		sl->rcount = 0;
+		return;
+	case X25_ESC:
+		set_bit(SLF_ESCAPE, &sl->flags);
+		return;
+	case X25_ESCAPE(X25_ESC):
+	case X25_ESCAPE(X25_END):
+		if (test_and_clear_bit(SLF_ESCAPE, &sl->flags))
+			s = X25_UNESCAPE(s);
+		break;
 	}
-	if (!test_bit(SLF_ERROR, &sl->flags))  
-	{
-		if (sl->rcount < sl->buffsize)  
-		{
+	if (!test_bit(SLF_ERROR, &sl->flags)) {
+		if (sl->rcount < sl->buffsize) {
 			sl->rbuff[sl->rcount++] = s;
 			return;
 		}
@@ -709,7 +699,7 @@ static int x25_asy_ioctl(struct tty_stru
 	if (!sl || sl->magic != X25_ASY_MAGIC)
 		return -EINVAL;
 
-	switch(cmd) {
+	switch (cmd) {
 	case SIOCGIFNAME:
 		if (copy_to_user((void __user *)arg, sl->dev->name,
 					strlen(sl->dev->name) + 1))
@@ -724,8 +714,8 @@ static int x25_asy_ioctl(struct tty_stru
 
 static int x25_asy_open_dev(struct net_device *dev)
 {
-	struct x25_asy *sl = (struct x25_asy*)(dev->priv);
-	if(sl->tty==NULL)
+	struct x25_asy *sl = dev->priv;
+	if (sl->tty == NULL)
 		return -ENODEV;
 	return 0;
 }
@@ -741,9 +731,9 @@ static void x25_asy_setup(struct net_dev
 	set_bit(SLF_INUSE, &sl->flags);
 
 	/*
-	 *	Finish setting up the DEVICE info. 
+	 *	Finish setting up the DEVICE info.
 	 */
-	 
+
 	dev->mtu		= SL_MTU;
 	dev->hard_start_xmit	= x25_asy_xmit;
 	dev->tx_timeout		= x25_asy_timeout;
@@ -778,9 +768,10 @@ static int __init init_x25_asy(void)
 		x25_asy_maxdev = 4; /* Sanity */
 
 	printk(KERN_INFO "X.25 async: version 0.00 ALPHA "
-			"(dynamic channels, max=%d).\n", x25_asy_maxdev );
+			"(dynamic channels, max=%d).\n", x25_asy_maxdev);
 
-	x25_asy_devs = kcalloc(x25_asy_maxdev, sizeof(struct net_device*), GFP_KERNEL);
+	x25_asy_devs = kcalloc(x25_asy_maxdev, sizeof(struct net_device *),
+				GFP_KERNEL);
 	if (!x25_asy_devs) {
 		printk(KERN_WARNING "X25 async: Can't allocate x25_asy_ctrls[] "
 				"array! Uaargh! (-> No X.25 available)\n");
@@ -802,7 +793,7 @@ static void __exit exit_x25_asy(void)
 			struct x25_asy *sl = dev->priv;
 
 			spin_lock_bh(&sl->lock);
-			if (sl->tty) 
+			if (sl->tty)
 				tty_hangup(sl->tty);
 
 			spin_unlock_bh(&sl->lock);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
maintainers-sort-ordering.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
istallion-tiocg-ssoftcar-handling-removal.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
strip-fix-up-strip-for-the-new-order.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

