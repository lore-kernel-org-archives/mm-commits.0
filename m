From: akpm@linux-foundation.org
Subject: - checkpatch-add-tests-for-the-attribute-matcher.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:16 -0700
Message-ID: <200810182313.m9INDGt2028161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbYJRXNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add tests for the attribute matcher
has been removed from the -mm tree.  Its filename was
     checkpatch-add-tests-for-the-attribute-matcher.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add tests for the attribute matcher
From: Andy Whitcroft <apw@shadowen.org>

Add support for direct testing of the attribute matcher, add basic tests
for it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-tests-for-the-attribute-matcher scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tests-for-the-attribute-matcher
+++ a/scripts/checkpatch.pl
@@ -66,6 +66,7 @@ if ($#ARGV < 0) {
 my $dbg_values = 0;
 my $dbg_possible = 0;
 my $dbg_type = 0;
+my $dbg_attr = 0;
 for my $key (keys %debug) {
 	eval "\${dbg_$key} = '$debug{$key}';"
 }
@@ -1367,6 +1368,15 @@ sub process {
 			}
 			next;
 		}
+# TEST: allow direct testing of the attribute matcher.
+		if ($dbg_attr) {
+			if ($line =~ /^.\s*$Attribute\s*$/) {
+				ERROR("TEST: is attr\n" . $herecurr);
+			} elsif ($dbg_attr > 1 && $line =~ /^.+($Attribute)/) {
+				ERROR("TEST: is not attr ($1 is)\n". $herecurr);
+			}
+			next;
+		}
 
 # check for initialisation to aggregates open brace on the next line
 		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

