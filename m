From: akpm@linux-foundation.org
Subject: - tcp-newreno-must-count-every-skb-while-marking-losses.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:27 -0800
Message-ID: <200802012229.m11MTRxg001807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366AbYBAWrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, davem@davemloft.net, hidave.darkstar@gmail.com, krkumar2@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tcp: NewReno must count every skb while marking losses
has been removed from the -mm tree.  Its filename was
     tcp-newreno-must-count-every-skb-while-marking-losses.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: tcp: NewReno must count every skb while marking losses
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

NewReno should add cnt per skb (as with FACK) instead of depending on
SACKED_ACKED bits which won't be set with it at all.  Effectively, NewR=
eno
should always exists after the first iteration anyway (or immediately i=
f
there's already head in lost_out.

This was fixed earlier in net-2.6.25 but got reverted among other stuff=
 and I
didn't notice that this is still necessary (actually wasn't even consid=
ering
this case while trying to figure out the reports because I lived with
different kind of code than it in reality was).

This should solve the WARN_ONs in TCP code that as a result of this tri=
ggered
multiple times in every place we check for this invariant.

Special thanks to Dave Young <hidave.darkstar@gmail.com> and Krishna Ku=
mar2
<krkumar2@in.ibm.com> for trying with my debug patches.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Tested-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/tcp_input.c~tcp-newreno-must-count-every-skb-while-m=
arking-losses net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c~tcp-newreno-must-count-every-skb-while-marki=
ng-losses
+++ a/net/ipv4/tcp_input.c
@@ -2153,7 +2153,7 @@ static void tcp_mark_head_lost(struct so
 		tp->lost_skb_hint =3D skb;
 		tp->lost_cnt_hint =3D cnt;
=20
-		if (tcp_is_fack(tp) ||
+		if (tcp_is_fack(tp) || tcp_is_reno(tp) ||
 		    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
 			cnt +=3D tcp_skb_pcount(skb);
=20
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch
git-v9fs.patch
