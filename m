From: akpm@linux-foundation.org
Subject: - pfkey-sending-an-sadb_get-responds-with-an-sadb_get.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:26 -0800
Message-ID: <200711272033.lARKXQMJ028979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbXK0Udc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chardin@2wire.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     pfkey: sending an SADB_GET responds with an SADB_GET
has been removed from the -mm tree.  Its filename was
     pfkey-sending-an-sadb_get-responds-with-an-sadb_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pfkey: sending an SADB_GET responds with an SADB_GET
From: Charles Hardin <chardin@2wire.com>

Kernel needs to respond to an SADB_GET with the same message type to
conform to the RFC 2367 Section 3.1.5

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/key/af_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/key/af_key.c~pfkey-sending-an-sadb_get-responds-with-an-sadb_get net/key/af_key.c
--- a/net/key/af_key.c~pfkey-sending-an-sadb_get-responds-with-an-sadb_get
+++ a/net/key/af_key.c
@@ -1552,7 +1552,7 @@ static int pfkey_get(struct sock *sk, st
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = hdr->sadb_msg_version;
-	out_hdr->sadb_msg_type = SADB_DUMP;
+	out_hdr->sadb_msg_type = SADB_GET;
 	out_hdr->sadb_msg_satype = pfkey_proto2satype(proto);
 	out_hdr->sadb_msg_errno = 0;
 	out_hdr->sadb_msg_reserved = 0;
_

Patches currently in -mm which might be from chardin@2wire.com are

origin.patch
