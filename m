From: akpm@linux-foundation.org
Subject: + net-msg_errqueue-messages-do-not-pass-to-connected-raw-sockets.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:23:51 -0700
Message-ID: <200707131823.l6DINqoF010635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933499AbXGMSYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry@butskoy.name


The patch titled
     net: MSG_ERRQUEUE messages do not pass to connected raw sockets
has been added to the -mm tree.  Its filename is
     net-msg_errqueue-messages-do-not-pass-to-connected-raw-sockets.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net: MSG_ERRQUEUE messages do not pass to connected raw sockets
From: Dmitry Butskoy <dmitry@butskoy.name>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8747

Problem Description:

It is related to the possibility to obtain MSG_ERRQUEUE messages from the udp
and raw sockets, both connected and unconnected.

There is a little typo in net/ipv6/icmp.c code, which prevents such messages
to be delivered to the errqueue of the correspond raw socket, when the socket
is CONNECTED.  The typo is due to swap of local/remote addresses.

Consider __raw_v6_lookup() function from net/ipv6/raw.c. When a raw socket is
looked up usual way, it is something like:

sk = __raw_v6_lookup(sk, nexthdr, daddr, saddr, IP6CB(skb)->iif);

where "daddr" is a destination address of the incoming packet (IOW our local
address), "saddr" is a source address of the incoming packet (the remote end).

But when the raw socket is looked up for some icmp error report, in
net/ipv6/icmp.c:icmpv6_notify() , daddr/saddr are obtained from the echoed
fragment of the "bad" packet, i.e.  "daddr" is the original destination
address of that packet, "saddr" is our local address.  Hence, for
icmpv6_notify() must use "saddr, daddr" in its arguments, not "daddr, saddr"
...

Steps to reproduce:

Create some raw socket, connect it to an address, and cause some error
situation: f.e. set ttl=1 where the remote address is more than 1 hop to reach.
Set IPV6_RECVERR .
Then send something and wait for the error (f.e. poll() with POLLERR|POLLIN).
You should receive "time exceeded" icmp message (because of "ttl=1"), but the
socket do not receive it.

If you do not connect your raw socket, you will receive MSG_ERRQUEUE
successfully.  (The reason is that for unconnected socket there are no actual
checks for local/remote addresses).


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/icmp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv6/icmp.c~net-msg_errqueue-messages-do-not-pass-to-connected-raw-sockets net/ipv6/icmp.c
--- a/net/ipv6/icmp.c~net-msg_errqueue-messages-do-not-pass-to-connected-raw-sockets
+++ a/net/ipv6/icmp.c
@@ -604,7 +604,7 @@ static void icmpv6_notify(struct sk_buff
 
 	read_lock(&raw_v6_lock);
 	if ((sk = sk_head(&raw_v6_htable[hash])) != NULL) {
-		while((sk = __raw_v6_lookup(sk, nexthdr, daddr, saddr,
+		while ((sk = __raw_v6_lookup(sk, nexthdr, saddr, daddr,
 					    IP6CB(skb)->iif))) {
 			rawv6_err(sk, skb, NULL, type, code, inner_offset, info);
 			sk = sk_next(sk);
_

Patches currently in -mm which might be from dmitry@butskoy.name are

net-msg_errqueue-messages-do-not-pass-to-connected-raw-sockets.patch
