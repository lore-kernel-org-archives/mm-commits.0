From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:55 -0700
Message-ID: <5591af37.7hKpJCN8ut4zxf7O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbbF2Us4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add multi-line handling for PREFER_ETHER_ADDR_COPY
has been removed from the -mm tree.  Its filename was
     checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Subject: checkpatch: add multi-line handling for PREFER_ETHER_ADDR_COPY

Handle multi-line memcpy() properly.

Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy
+++ a/scripts/checkpatch.pl
@@ -5149,9 +5149,10 @@ sub process {
 
 # Check for memcpy(foo, bar, ETH_ALEN) that could be ether_addr_copy(foo, bar)
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/s) {
+		    defined $stat &&
+		    $stat =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
 			if (WARN("PREFER_ETHER_ADDR_COPY",
-				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . $herecurr) &&
+				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . "$here\n$stat\n") &&
 			    $fix) {
 				$fixed[$fixlinenr] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
 			}
_

Patches currently in -mm which might be from mateusz.kulikowski@gmail.com are

origin.patch

