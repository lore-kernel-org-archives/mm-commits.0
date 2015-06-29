From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:53 -0700
Message-ID: <5591af35.DGS4lYCwJ5NBSEHd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbbF2Usx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: suggest using eth_zero_addr() and eth_broadcast_addr()
has been removed from the -mm tree.  Its filename was
     checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Subject: checkpatch: suggest using eth_zero_addr() and eth_broadcast_addr()

Suggest using eth_zero_addr() or eth_broadcast_addr() instead of memset().

Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr
+++ a/scripts/checkpatch.pl
@@ -5165,6 +5165,29 @@ sub process {
 			     "Prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()\n" . "$here\n$stat\n")
 		}
 
+# check for memset(foo, 0x0, ETH_ALEN) that could be eth_zero_addr
+# check for memset(foo, 0xFF, ETH_ALEN) that could be eth_broadcast_addr
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
+
+			my $ms_val = $7;
+
+			if ($ms_val =~ /^(?:0x|)0+$/i) {
+				if (WARN("PREFER_ETH_ZERO_ADDR",
+					 "Prefer eth_zero_addr over memset()\n" . "$here\n$stat\n") &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*,\s*ETH_ALEN\s*\)/eth_zero_addr($2)/;
+				}
+			} elsif ($ms_val =~ /^(?:0xff|255)$/i) {
+				if (WARN("PREFER_ETH_BROADCAST_ADDR",
+					 "Prefer eth_broadcast_addr() over memset()\n" . "$here\n$stat\n") &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*,\s*ETH_ALEN\s*\)/eth_broadcast_addr($2)/;
+				}
+			}
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from mateusz.kulikowski@gmail.com are

origin.patch

