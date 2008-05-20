From: akpm@linux-foundation.org
Subject: + wan-protect-hdlc-proto-list-while-insmod-rmmod.patch added to -mm tree
Date: Tue, 20 May 2008 01:54:02 -0700
Message-ID: <200805200854.m4K8s2lD014159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbYETIym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net


The patch titled
     wan: protect HDLC proto list while insmod/rmmod
has been added to the -mm tree.  Its filename is
     wan-protect-hdlc-proto-list-while-insmod-rmmod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: wan: protect HDLC proto list while insmod/rmmod
=46rom: Krzysztof Halasa <khc@pm.waw.pl>

WAN: protect protocol list in hdlc.c with RTNL.

Signed-off-by: Krzysztof Ha=B3asa <khc@pm.waw.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/net/wan/hdlc.c~wan-protect-hdlc-proto-list-while-insm=
od-rmmod drivers/net/wan/hdlc.c
--- a/drivers/net/wan/hdlc.c~wan-protect-hdlc-proto-list-while-insmod-r=
mmod
+++ a/drivers/net/wan/hdlc.c
@@ -43,8 +43,7 @@ static const char* version =3D "HDLC suppo
=20
 #undef DEBUG_LINK
=20
-static struct hdlc_proto *first_proto =3D NULL;
-
+static struct hdlc_proto *first_proto;
=20
 static int hdlc_change_mtu(struct net_device *dev, int new_mtu)
 {
@@ -314,21 +313,25 @@ void detach_hdlc_protocol(struct net_dev
=20
 void register_hdlc_protocol(struct hdlc_proto *proto)
 {
+	rtnl_lock();
 	proto->next =3D first_proto;
 	first_proto =3D proto;
+	rtnl_unlock();
 }
=20
=20
 void unregister_hdlc_protocol(struct hdlc_proto *proto)
 {
-	struct hdlc_proto **p =3D &first_proto;
-	while (*p) {
-		if (*p =3D=3D proto) {
-			*p =3D proto->next;
-			return;
-		}
+	struct hdlc_proto **p;
+
+	rtnl_lock();
+	p =3D &first_proto;
+	while (*p !=3D proto) {
+		BUG_ON(!*p);
 		p =3D &((*p)->next);
 	}
+	*p =3D proto->next;
+	rtnl_unlock();
 }
=20
=20
_

Patches currently in -mm which might be from khc@pm.waw.pl are

wan-protect-hdlc-proto-list-while-insmod-rmmod.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
