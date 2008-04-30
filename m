From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-018.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:02 -0700
Message-ID: <200804300541.m3U5f2MC029026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756947AbYD3Fly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.18
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-018.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update checkpatch.pl to version 0.18
From: Andy Whitcroft <apw@shadowen.org>

This version brings a few fixes for the extern checks, and a couple of
new checks.

Of note:
 - false is now recognised as a 0 assignment in static/external
   assignments,
 - printf format strings including %L are reported,
 - a number of fixes for the extern in .c file detector which had
   temporarily lost its ability to detect variables; undetected due to
   the loss of its test.

Andy Whitcroft (8):
      Version: 0.18
      false should trip 0 assignment checks
      tests: reinstate missing tests
      tests: allow specification of the file extension for a test
      fix extern checks for variables
      check for and report %Lu, %Ld, and %Li
      ensure we only start a statement on lines with some content
      extern spacing

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-018 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-018
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.17';
+my $V = '0.18';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -1144,7 +1144,7 @@ sub process {
 
 # Check for potential 'bare' types
 		my ($stat, $cond);
-		if ($realcnt) {
+		if ($realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond) = ctx_statement_block($linenr,
 								$realcnt, 0);
 			$stat =~ s/\n./\n /g;
@@ -1316,12 +1316,12 @@ sub process {
 		}
 
 # check for external initialisers.
-		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL);/) {
+		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise externals to 0 or NULL\n" .
 				$herecurr);
 		}
 # check for static initialisers.
-		if ($line =~ /\s*static\s.*=\s*(0|NULL);/) {
+		if ($line =~ /\s*static\s.*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise statics to 0 or NULL\n" .
 				$herecurr);
 		}
@@ -1973,7 +1973,7 @@ sub process {
 
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
-		    $stat =~ /^.(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
 		{
 			my $paren_space = $1;
 
@@ -1988,6 +1988,11 @@ sub process {
 			if ($paren_space =~ /\n/) {
 				WARN("arguments for function declarations should follow identifier\n" . $herecurr);
 			}
+
+		} elsif ($realfile =~ /\.c$/ && defined $stat &&
+		    $stat =~ /^.\s*extern\s+/)
+		{
+			WARN("externs should be avoided in .c files\n" .  $herecurr);
 		}
 
 # checks for new __setup's
@@ -2033,6 +2038,16 @@ sub process {
 		{
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
+
+# check for %L{u,d,i} in strings
+		my $string;
+		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
+			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			if ($string =~ /(?<!%)%L[udi]/) {
+				WARN("\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
+				last;
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
page-owner-tracking-leak-detector.patch

