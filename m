From: akpm@linux-foundation.org
Subject: + round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:52:03 -0700
Message-ID: <200704062252.l36Mq3FB021357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297AbXDFWwJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, davem@davemloft.net, paulus@samba.org


The patch titled
     ROUND_UP macro cleanup in drivers/net/ppp_generic.c
has been added to the -mm tree.  Its filename is
     round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ROUND_UP macro cleanup in drivers/net/ppp_generic.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use DIV_ROUND_UP

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_generic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/ppp_generic.c~round_up-macro-cleanup-in-drivers-net-ppp_genericc drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~round_up-macro-cleanup-in-drivers-net-ppp_genericc
+++ a/drivers/net/ppp_generic.c
@@ -88,8 +88,6 @@ struct ppp_file {
 #define PF_TO_PPP(pf)		PF_TO_X(pf, struct ppp)
 #define PF_TO_CHANNEL(pf)	PF_TO_X(pf, struct channel)
 
-#define ROUNDUP(n, x)		(((n) + (x) - 1) / (x))
-
 /*
  * Data structure describing one ppp unit.
  * A ppp unit corresponds to a ppp network interface device
@@ -1297,7 +1295,7 @@ static int ppp_mp_explode(struct ppp *pp
 	 */
 	fragsize = len;
 	if (nfree > 1)
-		fragsize = ROUNDUP(fragsize, nfree);
+		fragsize = DIV_ROUND_UP(fragsize, nfree);
 	/* nbigger channels get fragsize bytes, the rest get fragsize-1,
 	   except if nbigger==0, then they all get fragsize. */
 	nbigger = len % nfree;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
