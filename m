From: akpm@linux-foundation.org
Subject: + tcp-newreno-must-count-every-skb-while-marking-losses.patch added to -mm tree
Date: Thu, 24 Jan 2008 05:30:39 -0800
Message-ID: <200801241330.m0ODUWsl027719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315AbYAXNax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jan 2008 08:30:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, davem@davemloft.net, hidave.darkstar@gmail.com, krkumar2@in.ibm.com


The patch titled
     tcp: NewReno must count every skb while marking losses
has been added to the -mm tree.  Its filename is
     tcp-newreno-must-count-every-skb-while-marking-losses.patch

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

git-net.patch
tcp-newreno-must-count-every-skb-while-marking-losses.patch
git-cryptodev.patch
