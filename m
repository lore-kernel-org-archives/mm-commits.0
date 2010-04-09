From: akpm@linux-foundation.org
Subject: [merged] x25-attempts-to-negotiate-invalid-throughput.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:39 -0400
Message-ID: <201004091754.o39HsATB002171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab0DIRy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john@calva.com, davem@davemloft.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     x.25 attempts to negotiate invalid throughput
has been removed from the -mm tree.  Its filename was
     x25-attempts-to-negotiate-invalid-throughput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x.25 attempts to negotiate invalid throughput
From: John Hughes <john@calva.com>

The current (2.6.34) x.25 code doesn't seem to know that the X.25
throughput facility includes two values, one for the required throughput
outbound, one for inbound.

This causes it to attempt to negotiate throughput 0x0A, which is
throughput 9600 inbound and the illegal value "0" for inbound throughput.

Because of this some X.25 devices (e.g.  Cisco 1600) refuse to connect to
Linux X.25.

The patch fixes this behaviour.  Unless the user specifies a required
throughput it does not attempt to negotiate.  If the user does not specify
a throughput it accepts the suggestion of the remote X.25 system.  If the
user requests a throughput then it validates both the input and output
throughputs and correctly negotiates them with the remote end.

Signed-off-by: John Hughes <john@calva.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/x25/af_x25.c         |   20 ++++++++++++++++----
 net/x25/x25_facilities.c |   15 ++++++++++++---
 2 files changed, 28 insertions(+), 7 deletions(-)

diff -puN net/x25/af_x25.c~x25-attempts-to-negotiate-invalid-throughput net/x25/af_x25.c
--- a/net/x25/af_x25.c~x25-attempts-to-negotiate-invalid-throughput
+++ a/net/x25/af_x25.c
@@ -554,7 +554,8 @@ static int x25_create(struct net *net, s
 	x25->facilities.winsize_out = X25_DEFAULT_WINDOW_SIZE;
 	x25->facilities.pacsize_in  = X25_DEFAULT_PACKET_SIZE;
 	x25->facilities.pacsize_out = X25_DEFAULT_PACKET_SIZE;
-	x25->facilities.throughput  = X25_DEFAULT_THROUGHPUT;
+	x25->facilities.throughput  = 0;	/* by default don't negotiate
+						   throughput */
 	x25->facilities.reverse     = X25_DEFAULT_REVERSE;
 	x25->dte_facilities.calling_len = 0;
 	x25->dte_facilities.called_len = 0;
@@ -1415,9 +1416,20 @@ static int x25_ioctl(struct socket *sock
 			if (facilities.winsize_in < 1 ||
 			    facilities.winsize_in > 127)
 				break;
-			if (facilities.throughput < 0x03 ||
-			    facilities.throughput > 0xDD)
-				break;
+			if (facilities.throughput) {
+				int out = facilities.throughput & 0xf0;
+				int in  = facilities.throughput & 0x0f;
+				if (!out)
+					facilities.throughput |=
+						X25_DEFAULT_THROUGHPUT << 4;
+				else if (out < 0x30 || out > 0xD0)
+					break;
+				if (!in)
+					facilities.throughput |=
+						X25_DEFAULT_THROUGHPUT;
+				else if (in < 0x03 || in > 0x0D)
+					break;
+			}
 			if (facilities.reverse &&
 				(facilities.reverse & 0x81) != 0x81)
 				break;
diff -puN net/x25/x25_facilities.c~x25-attempts-to-negotiate-invalid-throughput net/x25/x25_facilities.c
--- a/net/x25/x25_facilities.c~x25-attempts-to-negotiate-invalid-throughput
+++ a/net/x25/x25_facilities.c
@@ -259,9 +259,18 @@ int x25_negotiate_facilities(struct sk_b
 	new->reverse = theirs.reverse;
 
 	if (theirs.throughput) {
-		if (theirs.throughput < ours->throughput) {
-			SOCK_DEBUG(sk, "X.25: throughput negotiated down\n");
-			new->throughput = theirs.throughput;
+		int theirs_in =  theirs.throughput & 0x0f;
+		int theirs_out = theirs.throughput & 0xf0;
+		int ours_in  = ours->throughput & 0x0f;
+		int ours_out = ours->throughput & 0xf0;
+		if (!ours_in || theirs_in < ours_in) {
+			SOCK_DEBUG(sk, "X.25: inbound throughput negotiated\n");
+			new->throughput = (new->throughput & 0xf0) | theirs_in;
+		}
+		if (!ours_out || theirs_out < ours_out) {
+			SOCK_DEBUG(sk,
+				"X.25: outbound throughput negotiated\n");
+			new->throughput = (new->throughput & 0x0f) | theirs_out;
 		}
 	}
 
_

Patches currently in -mm which might be from john@calva.com are

linux-next.patch

