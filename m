From: akpm@linux-foundation.org
Subject: [folded-merged] checkpatchpl-warn-against-using-%z-fix.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 14:20:06 -0800
Message-ID: <58b4a616.hP0hgIJ2XKEBHO6T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48074 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdB0X0R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 18:26:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatchpl-warn-against-using-%z-fix
has been removed from the -mm tree.  Its filename was
     checkpatchpl-warn-against-using-%z-fix.patch

This patch was dropped because it was folded into checkpatchpl-warn-against-using-%z.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatchpl-warn-against-using-%z-fix

vsnprintf extension %Z<foo> is non-standard C.
Suggest the use of %z instead.

Miscellanea:

o Correct the misuse of type string PRINTF_0xDECIMAL
  type strings are supposed to be uppercase only.
  Fix this and add tr/[a-z]/[A-Z] to the type check in case
  I forget this again sometime in the future.
o Improve the mechanism to find these defects so all
  3 current checks are done on the format string

Link: http://lkml.kernel.org/r/4e3ad74b0c9dc229b06018a2d79655308ddbbebd.1484014173.git.joe@perches.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-warn-against-using-%z-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-warn-against-using-%z-fix
+++ a/scripts/checkpatch.pl
@@ -1848,6 +1848,8 @@ my $prefix = '';
 sub show_type {
 	my ($type) = @_;
 
+	$type =~ tr/[a-z]/[A-Z]/;
+
 	return defined $use_type{$type} if (scalar keys %use_type > 0);
 
 	return !defined $ignore_type{$type};
@@ -5204,24 +5206,27 @@ sub process {
 			     "Consecutive strings are generally better as a single string\n" . $herecurr);
 		}
 
-# check for %L{u,d,i} and 0x%[udi] in strings
-		my $string;
+# check for non-standard and hex prefixed decimal printf formats
+		my $show_L = 1;	#don't show the same defect twice
+		my $show_Z = 1;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
-			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			my $string = substr($rawline, $-[1], $+[1] - $-[1]);
 			$string =~ s/%%/__/g;
-			if ($string =~ /(?<!%)%[\*\d\.\$]*L[udi]/) {
+			# check for %L
+			if ($show_L && $string =~ /%[\*\d\.\$]*L([diouxX])/) {
 				WARN("PRINTF_L",
-				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
-				last;
+				     "\%L$1 is non-standard C, use %ll$1\n" . $herecurr);
+				$show_L = 0;
 			}
 			# check for %Z
-			if ($string =~ /(?<!%)%[\*\d\.\$]*Z[diouxX]/) {
+			if ($show_Z && $string =~ /%[\*\d\.\$]*Z([diouxX])/) {
 				WARN("PRINTF_Z",
-				     "%Z is non-standard C, use %z\n" . $herecurr);
-				last;
+				     "%Z$1 is non-standard C, use %z$1\n" . $herecurr);
+				$show_Z = 0;
 			}
-			if ($string =~ /0x%[\*\d\.\$\Llzth]*[udi]/) {
-				ERROR("PRINTF_0xDECIMAL",
+			# check for 0x<decimal>
+			if ($string =~ /0x%[\*\d\.\$\Llzth]*[diou]/) {
+				ERROR("PRINTF_0XDECIMAL",
 				      "Prefixing 0x with decimal output is defective\n" . $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatchpl-warn-against-using-%z.patch

