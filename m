From: akpm@linux-foundation.org
Subject: + checkpatchpl-warn-against-using-%z-fix.patch added to -mm tree
Date: Tue, 10 Jan 2017 15:27:29 -0800
Message-ID: <58756de1.Ij3o+IueHb1Quw9g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753606AbdAJX1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 18:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatchpl-warn-against-using-%z-fix
has been added to the -mm tree.  Its filename is
     checkpatchpl-warn-against-using-%z-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-warn-against-using-%25z-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-warn-against-using-%25z-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5197,24 +5199,27 @@ sub process {
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

checkpatch-warn-on-embedded-function-names.patch
checkpatch-warn-on-logging-continuations.patch
checkpatchpl-warn-against-using-%z-fix.patch

