From: akpm@linux-foundation.org
Subject: [merged] checkpatch-suggest-using-ether_addr_equal.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:48:49 -0700
Message-ID: <5591af31.ih+u23lI7unMisGl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbbF2Ust (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: suggest using ether_addr_equal*()
has been removed from the -mm tree.  Its filename was
     checkpatch-suggest-using-ether_addr_equal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Subject: checkpatch: suggest using ether_addr_equal*()

Check if memcmp() is used to compare ethernet addresses and suggest using
ether_addr_equal() or ether_addr_equal_unaligned()

Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suggest-using-ether_addr_equal scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suggest-using-ether_addr_equal
+++ a/scripts/checkpatch.pl
@@ -5157,6 +5157,14 @@ sub process {
 			}
 		}
 
+# Check for memcmp(foo, bar, ETH_ALEN) that could be ether_addr_equal*(foo, bar)
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?:.*?)\bmemcmp\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
+			WARN("PREFER_ETHER_ADDR_EQUAL",
+			     "Prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()\n" . "$here\n$stat\n")
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from mateusz.kulikowski@gmail.com are

origin.patch

