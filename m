From: akpm@linux-foundation.org
Subject: - wan-protect-cisco-hdlc-state-changes-with-a-spinlock.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:36 -0700
Message-ID: <200805231859.m4NIxaCm004250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876AbYEWS7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     WAN: protect Cisco HDLC state changes with a spinlock
has been removed from the -mm tree.  Its filename was
     wan-protect-cisco-hdlc-state-changes-with-a-spinlock.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: WAN: protect Cisco HDLC state changes with a spinlock
=46rom: Krzysztof Halasa <khc@pm.waw.pl>

Signed-off-by: Krzysztof Ha=B3asa <khc@pm.waw.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc_cisco.c |   82 +++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 33 deletions(-)

diff -puN drivers/net/wan/hdlc_cisco.c~wan-protect-cisco-hdlc-state-cha=
nges-with-a-spinlock drivers/net/wan/hdlc_cisco.c
--- a/drivers/net/wan/hdlc_cisco.c~wan-protect-cisco-hdlc-state-changes=
-with-a-spinlock
+++ a/drivers/net/wan/hdlc_cisco.c
@@ -56,6 +56,7 @@ struct cisco_state {
 	cisco_proto settings;
=20
 	struct timer_list timer;
+	spinlock_t lock;
 	unsigned long last_poll;
 	int up;
 	int request_sent;
@@ -158,6 +159,7 @@ static int cisco_rx(struct sk_buff *skb)
 {
 	struct net_device *dev =3D skb->dev;
 	hdlc_device *hdlc =3D dev_to_hdlc(dev);
+	struct cisco_state *st =3D state(hdlc);
 	struct hdlc_header *data =3D (struct hdlc_header*)skb->data;
 	struct cisco_packet *cisco_data;
 	struct in_device *in_dev;
@@ -220,11 +222,12 @@ static int cisco_rx(struct sk_buff *skb)
 			goto rx_error;
=20
 		case CISCO_KEEPALIVE_REQ:
-			state(hdlc)->rxseq =3D ntohl(cisco_data->par1);
-			if (state(hdlc)->request_sent &&
-			    ntohl(cisco_data->par2) =3D=3D state(hdlc)->txseq) {
-				state(hdlc)->last_poll =3D jiffies;
-				if (!state(hdlc)->up) {
+			spin_lock(&st->lock);
+			st->rxseq =3D ntohl(cisco_data->par1);
+			if (st->request_sent &&
+			    ntohl(cisco_data->par2) =3D=3D st->txseq) {
+				st->last_poll =3D jiffies;
+				if (!st->up) {
 					u32 sec, min, hrs, days;
 					sec =3D ntohl(cisco_data->time) / 1000;
 					min =3D sec / 60; sec -=3D min * 60;
@@ -232,12 +235,12 @@ static int cisco_rx(struct sk_buff *skb)
 					days =3D hrs / 24; hrs -=3D days * 24;
 					printk(KERN_INFO "%s: Link up (peer "
 					       "uptime %ud%uh%um%us)\n",
-					       dev->name, days, hrs,
-					       min, sec);
+					       dev->name, days, hrs, min, sec);
 					netif_dormant_off(dev);
-					state(hdlc)->up =3D 1;
+					st->up =3D 1;
 				}
 			}
+			spin_unlock(&st->lock);
=20
 			dev_kfree_skb_any(skb);
 			return NET_RX_SUCCESS;
@@ -261,24 +264,25 @@ static void cisco_timer(unsigned long ar
 {
 	struct net_device *dev =3D (struct net_device *)arg;
 	hdlc_device *hdlc =3D dev_to_hdlc(dev);
+	struct cisco_state *st =3D state(hdlc);
=20
-	if (state(hdlc)->up &&
-	    time_after(jiffies, state(hdlc)->last_poll +
-		       state(hdlc)->settings.timeout * HZ)) {
-		state(hdlc)->up =3D 0;
+	spin_lock(&st->lock);
+	if (st->up &&
+	    time_after(jiffies, st->last_poll + st->settings.timeout * HZ)) {
+		st->up =3D 0;
 		printk(KERN_INFO "%s: Link down\n", dev->name);
 		netif_dormant_on(dev);
 	}
=20
-	cisco_keepalive_send(dev, CISCO_KEEPALIVE_REQ,
-			     htonl(++state(hdlc)->txseq),
-			     htonl(state(hdlc)->rxseq));
-	state(hdlc)->request_sent =3D 1;
-	state(hdlc)->timer.expires =3D jiffies +
-		state(hdlc)->settings.interval * HZ;
-	state(hdlc)->timer.function =3D cisco_timer;
-	state(hdlc)->timer.data =3D arg;
-	add_timer(&state(hdlc)->timer);
+	cisco_keepalive_send(dev, CISCO_KEEPALIVE_REQ, htonl(++st->txseq),
+			     htonl(st->rxseq));
+	st->request_sent =3D 1;
+	spin_unlock(&st->lock);
+
+	st->timer.expires =3D jiffies + st->settings.interval * HZ;
+	st->timer.function =3D cisco_timer;
+	st->timer.data =3D arg;
+	add_timer(&st->timer);
 }
=20
=20
@@ -286,15 +290,20 @@ static void cisco_timer(unsigned long ar
 static void cisco_start(struct net_device *dev)
 {
 	hdlc_device *hdlc =3D dev_to_hdlc(dev);
-	state(hdlc)->up =3D 0;
-	state(hdlc)->request_sent =3D 0;
-	state(hdlc)->txseq =3D state(hdlc)->rxseq =3D 0;
-
-	init_timer(&state(hdlc)->timer);
-	state(hdlc)->timer.expires =3D jiffies + HZ; /*First poll after 1s*/
-	state(hdlc)->timer.function =3D cisco_timer;
-	state(hdlc)->timer.data =3D (unsigned long)dev;
-	add_timer(&state(hdlc)->timer);
+	struct cisco_state *st =3D state(hdlc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&st->lock, flags);
+	st->up =3D 0;
+	st->request_sent =3D 0;
+	st->txseq =3D st->rxseq =3D 0;
+	spin_unlock_irqrestore(&st->lock, flags);
+
+	init_timer(&st->timer);
+	st->timer.expires =3D jiffies + HZ; /* First poll after 1 s */
+	st->timer.function =3D cisco_timer;
+	st->timer.data =3D (unsigned long)dev;
+	add_timer(&st->timer);
 }
=20
=20
@@ -302,10 +311,16 @@ static void cisco_start(struct net_devic
 static void cisco_stop(struct net_device *dev)
 {
 	hdlc_device *hdlc =3D dev_to_hdlc(dev);
-	del_timer_sync(&state(hdlc)->timer);
+	struct cisco_state *st =3D state(hdlc);
+	unsigned long flags;
+
+	del_timer_sync(&st->timer);
+
+	spin_lock_irqsave(&st->lock, flags);
 	netif_dormant_on(dev);
-	state(hdlc)->up =3D 0;
-	state(hdlc)->request_sent =3D 0;
+	st->up =3D 0;
+	st->request_sent =3D 0;
+	spin_unlock_irqrestore(&st->lock, flags);
 }
=20
=20
@@ -367,6 +382,7 @@ static int cisco_ioctl(struct net_device
 			return result;
=20
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+		spin_lock_init(&state(hdlc)->lock);
 		dev->hard_start_xmit =3D hdlc->xmit;
 		dev->header_ops =3D &cisco_header_ops;
 		dev->type =3D ARPHRD_CISCO;
_

Patches currently in -mm which might be from khc@pm.waw.pl are

git-net.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
