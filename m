From: akpm@linux-foundation.org
Subject: + cxgb3-remove-duplicate-tests-in-lro.patch added to -mm tree
Date: Mon, 08 Sep 2008 14:17:30 -0700
Message-ID: <200809082117.m88LHUv9010768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbYIHVSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 17:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: remove duplicate tests in lro
has been added to the -mm tree.  Its filename is
     cxgb3-remove-duplicate-tests-in-lro.patch

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
Subject: cxgb3: remove duplicate tests in lro
From: Divy Le Ray <divy@chelsio.com>

The generic lro code checks TCP flags/options.  Remove duplicate tests
done in the driver.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/sge.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

diff -puN drivers/net/cxgb3/sge.c~cxgb3-remove-duplicate-tests-in-lro drivers/net/cxgb3/sge.c
--- a/drivers/net/cxgb3/sge.c~cxgb3-remove-duplicate-tests-in-lro
+++ a/drivers/net/cxgb3/sge.c
@@ -1937,38 +1937,6 @@ static inline int lro_frame_ok(const str
 		eh->h_proto == htons(ETH_P_IP) && ih->ihl == (sizeof(*ih) >> 2);
 }
 
-#define TCP_FLAG_MASK (TCP_FLAG_CWR | TCP_FLAG_ECE | TCP_FLAG_URG |\
-                       TCP_FLAG_ACK | TCP_FLAG_PSH | TCP_FLAG_RST |\
-		                       TCP_FLAG_SYN | TCP_FLAG_FIN)
-#define TSTAMP_WORD ((TCPOPT_NOP << 24) | (TCPOPT_NOP << 16) |\
-                     (TCPOPT_TIMESTAMP << 8) | TCPOLEN_TIMESTAMP)
-
-/**
- *	lro_segment_ok - check if a TCP segment is eligible for LRO
- *	@tcph: the TCP header of the packet
- *
- *	Returns true if a TCP packet is eligible for LRO.  This requires that
- *	the packet have only the ACK flag set and no TCP options besides
- *	time stamps.
- */
-static inline int lro_segment_ok(const struct tcphdr *tcph)
-{
-	int optlen;
-
-	if (unlikely((tcp_flag_word(tcph) & TCP_FLAG_MASK) != TCP_FLAG_ACK))
-		return 0;
-
-	optlen = (tcph->doff << 2) - sizeof(*tcph);
-	if (optlen) {
-		const u32 *opt = (const u32 *)(tcph + 1);
-
-		if (optlen != TCPOLEN_TSTAMP_ALIGNED ||
-		    *opt != htonl(TSTAMP_WORD) || !opt[2])
-			return 0;
-	}
-	return 1;
-}
-
 static int t3_get_lro_header(void **eh,  void **iph, void **tcph,
 			     u64 *hdr_flags, void *priv)
 {
@@ -1981,9 +1949,6 @@ static int t3_get_lro_header(void **eh, 
 	*iph = (struct iphdr *)((struct ethhdr *)*eh + 1);
 	*tcph = (struct tcphdr *)((struct iphdr *)*iph + 1);
 
-	 if (!lro_segment_ok(*tcph))
-		return -1;
