From: akpm@linux-foundation.org
Subject: - net-ipv4-correct-rfc-1122-section-reference-in-comment.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:12 -0700
Message-ID: <200805092147.m49LlCId027193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbYEIVrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdassen@debian.org, mm-commits@vger.kernel.org


The patch titled
     net/ipv4: correct RFC 1122 section reference in comment
has been removed from the -mm tree.  Its filename was
     net-ipv4-correct-rfc-1122-section-reference-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

