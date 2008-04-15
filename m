From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-018.patch added to -mm tree
Date: Tue, 15 Apr 2008 00:39:10 -0700
Message-ID: <200804150739.m3F7dAC2017333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970AbYDOHje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 03:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mingo@elte.hu


The patch titled
     update checkpatch.pl to version 0.18
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-018.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1966,7 +1966,7 @@ sub process {
 
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
-		    $stat =~ /^.(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
 		{
 			my $paren_space = $1;
 
@@ -1981,6 +1981,11 @@ sub process {
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
@@ -2026,6 +2031,16 @@ sub process {
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

documentation-correct-overcommit-caveat-in-hugetlbpagetxt.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous-v2.patch
mm-make-early_pfn_to_nid-a-c-function.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
update-checkpatchpl-to-version-017.patch
update-checkpatchpl-to-version-018.patch
page-owner-tracking-leak-detector.patch

