From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:02:04 -0800
Message-ID: <52e2b8ac.UplLfH09NxfCBCEx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaAXTCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,davem@davemloft.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:04 -0800


The patch titled
     Subject: checkpatch: prefer ether_addr_copy to memcpy(foo, bar, ETH_ALEN)
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer ether_addr_copy to memcpy(foo, bar, ETH_ALEN)

ether_addr_copy was added for kernel version 3.14.  It's slightly
smaller/faster for some arches.  Encourage its use.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-ether_addr_copy-to-memcpyfoo-bar-eth_alen
+++ a/scripts/checkpatch.pl
@@ -4087,6 +4087,16 @@ sub process {
 			}
 		}
 
+# Check for memcpy(foo, bar, ETH_ALEN) that could be ether_addr_copy(foo, bar)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/s) {
+			if (WARN("PREFER_ETHER_ADDR_COPY",
+				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
+			}
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

