From: akpm@linux-foundation.org
Subject: + checkpatch-suggest-using-ether_addr_equal.patch added to -mm
 tree
Date: Wed, 10 Jun 2015 13:46:50 -0700
Message-ID: <5578a23a.bZ6ZKgVYSNbapKi1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbbFJUqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 16:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: suggest using ether_addr_equal*()
has been added to the -mm tree.  Its filename is
     checkpatch-suggest-using-ether_addr_equal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-suggest-using-ether_addr_equal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-suggest-using-ether_addr_equal.patch

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

checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
linux-next.patch

