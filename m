From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch added
 to -mm tree
Date: Wed, 10 Jun 2015 13:46:56 -0700
Message-ID: <5578a240.m8KlnYYaAwqcEFJg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbbFJUq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 16:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add multi-line handling for PREFER_ETHER_ADDR_COPY
has been added to the -mm tree.  Its filename is
     checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
linux-next.patch

