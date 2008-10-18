From: akpm@linux-foundation.org
Subject: - checkpatch-values-double-ampersand-may-be-unary.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:10 -0700
Message-ID: <200810182313.m9INDAwh028134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYJRXNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: values: double ampersand may be unary
has been removed from the -mm tree.  Its filename was
     checkpatch-values-double-ampersand-may-be-unary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: values: double ampersand may be unary
From: Andy Whitcroft <apw@shadowen.org>

It is possible to use double ampersand (&&) in unary context where it
means the address of a goto label.  Handle spacing for it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-values-double-ampersand-may-be-unary scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-values-double-ampersand-may-be-unary
+++ a/scripts/checkpatch.pl
@@ -858,7 +858,7 @@ sub annotate_values {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
-		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&(?!\&))/o) {
+		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&\&|\&)/o) {
 			my $variant;
 
 			print "OPV($1)\n" if ($dbg_values > 1);
@@ -1634,7 +1634,7 @@ sub process {
 				# unary operator, or a cast
 				} elsif ($op eq '!' || $op eq '~' ||
 					 $opv eq '*U' || $opv eq '-U' ||
-					 $opv eq '&U') {
+					 $opv eq '&U' || $opv eq '&&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

