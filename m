From: akpm@linux-foundation.org
Subject: [merged] checkpatch-dont-test-for-prefer-ether_addr_foo.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:07 -0700
Message-ID: <57fe8d9b.oce4ybtdoLFJbTe5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33271 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755985AbcJLTYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, gvrose8192@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't test for prefer ether_addr_<foo>
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-test-for-prefer-ether_addr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: don't test for prefer ether_addr_<foo>

< sigh > Comment these tests out.

These are just too enticing to people that don't verify that
both source and dest addresses really must be __aligned(2).

It helps make Dan Carpenter happy too.

Link: http://lkml.kernel.org/r/dc32ec66d24647f4cdf824c8dfbbc59aa7ce7b7d.1472665676.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg <gvrose8192@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   70 ++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-test-for-prefer-ether_addr_foo scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-test-for-prefer-ether_addr_foo
+++ a/scripts/checkpatch.pl
@@ -5554,46 +5554,46 @@ sub process {
 		}
 
 # Check for memcpy(foo, bar, ETH_ALEN) that could be ether_addr_copy(foo, bar)
-		if ($^V && $^V ge 5.10.0 &&
-		    defined $stat &&
-		    $stat =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
-			if (WARN("PREFER_ETHER_ADDR_COPY",
-				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . "$here\n$stat\n") &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
-			}
-		}
+#		if ($^V && $^V ge 5.10.0 &&
+#		    defined $stat &&
+#		    $stat =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
+#			if (WARN("PREFER_ETHER_ADDR_COPY",
+#				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . "$here\n$stat\n") &&
+#			    $fix) {
+#				$fixed[$fixlinenr] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
+#			}
+#		}
 
 # Check for memcmp(foo, bar, ETH_ALEN) that could be ether_addr_equal*(foo, bar)
-		if ($^V && $^V ge 5.10.0 &&
-		    defined $stat &&
-		    $stat =~ /^\+(?:.*?)\bmemcmp\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
-			WARN("PREFER_ETHER_ADDR_EQUAL",
-			     "Prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()\n" . "$here\n$stat\n")
-		}
+#		if ($^V && $^V ge 5.10.0 &&
+#		    defined $stat &&
+#		    $stat =~ /^\+(?:.*?)\bmemcmp\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
+#			WARN("PREFER_ETHER_ADDR_EQUAL",
+#			     "Prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()\n" . "$here\n$stat\n")
+#		}
 
 # check for memset(foo, 0x0, ETH_ALEN) that could be eth_zero_addr
 # check for memset(foo, 0xFF, ETH_ALEN) that could be eth_broadcast_addr
-		if ($^V && $^V ge 5.10.0 &&
-		    defined $stat &&
-		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
-
-			my $ms_val = $7;
-
-			if ($ms_val =~ /^(?:0x|)0+$/i) {
-				if (WARN("PREFER_ETH_ZERO_ADDR",
-					 "Prefer eth_zero_addr over memset()\n" . "$here\n$stat\n") &&
-				    $fix) {
-					$fixed[$fixlinenr] =~ s/\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*,\s*ETH_ALEN\s*\)/eth_zero_addr($2)/;
-				}
-			} elsif ($ms_val =~ /^(?:0xff|255)$/i) {
-				if (WARN("PREFER_ETH_BROADCAST_ADDR",
-					 "Prefer eth_broadcast_addr() over memset()\n" . "$here\n$stat\n") &&
-				    $fix) {
-					$fixed[$fixlinenr] =~ s/\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*,\s*ETH_ALEN\s*\)/eth_broadcast_addr($2)/;
-				}
-			}
-		}
+#		if ($^V && $^V ge 5.10.0 &&
+#		    defined $stat &&
+#		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/) {
+#
+#			my $ms_val = $7;
+#
+#			if ($ms_val =~ /^(?:0x|)0+$/i) {
+#				if (WARN("PREFER_ETH_ZERO_ADDR",
+#					 "Prefer eth_zero_addr over memset()\n" . "$here\n$stat\n") &&
+#				    $fix) {
+#					$fixed[$fixlinenr] =~ s/\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*,\s*ETH_ALEN\s*\)/eth_zero_addr($2)/;
+#				}
+#			} elsif ($ms_val =~ /^(?:0xff|255)$/i) {
+#				if (WARN("PREFER_ETH_BROADCAST_ADDR",
+#					 "Prefer eth_broadcast_addr() over memset()\n" . "$here\n$stat\n") &&
+#				    $fix) {
+#					$fixed[$fixlinenr] =~ s/\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*,\s*ETH_ALEN\s*\)/eth_broadcast_addr($2)/;
+#				}
+#			}
+#		}
 
 # typecasts on min/max could be min_t/max_t
 		if ($^V && $^V ge 5.10.0 &&
_

Patches currently in -mm which might be from joe@perches.com are


