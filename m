From: akpm@linux-foundation.org
Subject: + net-ipv4-correct-rfc-1122-section-reference-in-comment.patch added to -mm tree
Date: Wed, 07 May 2008 14:27:31 -0700
Message-ID: <200805072127.m47LRVDR017266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764163AbYEGV15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdassen@debian.org


The patch titled
     net/ipv4: correct RFC 1122 section reference in comment
has been added to the -mm tree.  Its filename is
     net-ipv4-correct-rfc-1122-section-reference-in-comment.patch

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
Subject: net/ipv4: correct RFC 1122 section reference in comment
From: J.H.M. Dassen (Ray) <jdassen@debian.org>

RFC 1122 does not have a section 3.1.2.2. The requirement to silently
discard datagrams with a bad checksum is in section 3.2.1.2 instead.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=10611

Signed-off-by: J.H.M. Dassen (Ray) <jdassen@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ip_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/ip_input.c~net-ipv4-correct-rfc-1122-section-reference-in-comment net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c~net-ipv4-correct-rfc-1122-section-reference-in-comment
+++ a/net/ipv4/ip_input.c
@@ -397,7 +397,7 @@ int ip_rcv(struct sk_buff *skb, struct n
 	iph = ip_hdr(skb);
 
 	/*
-	 *	RFC1122: 3.1.2.2 MUST silently discard any IP frame that fails the checksum.
+	 *	RFC1122: 3.2.1.2 MUST silently discard any IP frame that fails the checksum.
 	 *
 	 *	Is the datagram acceptable?
 	 *
_

Patches currently in -mm which might be from jdassen@debian.org are

net-ipv4-correct-rfc-1122-section-reference-in-comment.patch

