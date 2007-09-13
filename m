From: akpm@linux-foundation.org
Subject: + pktgen-srcmac-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 00:20:13 -0700
Message-ID: <200709130720.l8D7KDX5007504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbXIMHUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 03:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adit.262@gmail.com, davem@davemloft.net, hadi@cyberus.ca


The patch titled
     Pktgen srcmac fix
has been added to the -mm tree.  Its filename is
     pktgen-srcmac-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Pktgen srcmac fix
From: "Adit Ranadive" <adit.262@gmail.com>

Cc: Jamal Hadi Salim <hadi@cyberus.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/pktgen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN net/core/pktgen.c~pktgen-srcmac-fix net/core/pktgen.c
--- a/net/core/pktgen.c~pktgen-srcmac-fix
+++ a/net/core/pktgen.c
@@ -111,6 +111,9 @@
  *
  * 802.1Q/Q-in-Q support by Francesco Fondelli (FF) <francesco.fondelli@gmail.com>
  *
+ * Fixed src_mac command to set source mac of packet to value specified in
+ * command by Adit Ranadive <adit.262@gmail.com>
+ *
  */
 #include <linux/sys.h>
 #include <linux/types.h>
@@ -1471,8 +1474,11 @@ static ssize_t pktgen_if_write(struct fi
 	}
 	if (!strcmp(name, "src_mac")) {
 		char *v = valstr;
+		unsigned char old_smac[ETH_ALEN];
 		unsigned char *m = pkt_dev->src_mac;
 
+		memcpy(old_smac, pkt_dev->src_mac, ETH_ALEN);
+
 		len = strn_len(&user_buffer[i], sizeof(valstr) - 1);
 		if (len < 0) {
 			return len;
@@ -1501,6 +1507,10 @@ static ssize_t pktgen_if_write(struct fi
 			}
 		}
 
+		/* Set up Src MAC */
+		if (compare_ether_addr(old_smac, pkt_dev->src_mac))
+			memcpy(&(pkt_dev->hh[6]), pkt_dev->src_mac, ETH_ALEN);
+
 		sprintf(pg_result, "OK: srcmac");
 		return count;
 	}
_

Patches currently in -mm which might be from adit.262@gmail.com are

pktgen-srcmac-fix.patch
