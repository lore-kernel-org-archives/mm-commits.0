From: akpm@linux-foundation.org
Subject: + net-af_packet-remove-unused-variable.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:06:53 -0700
Message-ID: <200803142006.m2EK6rhl017118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091AbYCNUHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:07:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, davem@davemloft.net


The patch titled
     net: af_packet: remove unused variable
has been added to the -mm tree.  Its filename is
     net-af_packet-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: af_packet: remove unused variable
From: Jiri Olsa <olsajiri@gmail.com>

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/packet/af_packet.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/packet/af_packet.c~net-af_packet-remove-unused-variable net/packet/af_packet.c
--- a/net/packet/af_packet.c~net-af_packet-remove-unused-variable
+++ a/net/packet/af_packet.c
@@ -1658,7 +1658,7 @@ static int packet_set_ring(struct sock *
 	int err = 0;
 
 	if (req->tp_block_nr) {
-		int i, l;
+		int i;
 
 		/* Sanity tests and some calculations */
 
@@ -1687,7 +1687,6 @@ static int packet_set_ring(struct sock *
 		if (unlikely(!pg_vec))
 			goto out;
 
-		l = 0;
 		for (i = 0; i < req->tp_block_nr; i++) {
 			char *ptr = pg_vec[i];
 			struct tpacket_hdr *header;
_

Patches currently in -mm which might be from olsajiri@gmail.com are

fs-remove-unused-fops-from-struct-char_device_struct.patch
net-af_packet-remove-unused-variable.patch

