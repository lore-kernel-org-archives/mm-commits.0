From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-emit-an-error-on-formats-with-0x%decimal.patch removed from -mm
 tree
Date: Fri, 11 Sep 2015 11:12:25 -0700
Message-ID: <55f31989.2IACoiT9MeNdgg+T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIKSMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit an error on formats with 0x%<decimal>
has been removed from the -mm tree.  Its filename was
     checkpatch-emit-an-error-on-formats-with-0x%decimal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit an error on formats with 0x%<decimal>

Using 0x%d is wrong.  Emit a message when it happens.

Miscellanea:

Improve the %Lu warning to match formats like %16Lu.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-an-error-on-formats-with-0x%decimal scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-an-error-on-formats-with-0x%decimal
+++ a/scripts/checkpatch.pl
@@ -4816,16 +4816,20 @@ sub process {
 			     "Consecutive strings are generally better as a single string\n" . $herecurr);
 		}
 
-# check for %L{u,d,i} in strings
+# check for %L{u,d,i} and 0x%[udi] in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
 			$string =~ s/%%/__/g;
-			if ($string =~ /(?<!%)%L[udi]/) {
+			if ($string =~ /(?<!%)%[\*\d\.\$]*L[udi]/) {
 				WARN("PRINTF_L",
 				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
 				last;
 			}
+			if ($string =~ /0x%[\*\d\.\$\Llzth]*[udi]/) {
+				ERROR("PRINTF_0xDECIMAL",
+				      "Prefixing 0x with decimal output is defective\n" . $herecurr);
+			}
 		}
 
 # check for line continuations in quoted strings with odd counts of "
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

