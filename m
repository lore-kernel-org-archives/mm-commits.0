From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-006.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:47:06 -0700
Message-ID: <200706231647.l5NGl3CB019466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbXFWQro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, rdunlap@xenotime.net


The patch titled
     update checkpatch.pl to version 0.06
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-006.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update checkpatch.pl to version 0.06
From: Andy Whitcroft <apw@shadowen.org>

Update to checkpatch.pl v0.06.  Of note:

 - do { and else handled correctly as control structures for { matching
 - trailing whitespace correctly tripped when line otherwise empty
 - support for const, including const foo * const bar
 - multiline macros defining values correctly reported

This version of checkpatch.pl can be found at the following URL:

http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-0.06

Full Changelog:

Andy Whitcroft (14):
      Version: 0.06
      cleanup the Type regular expression declarations
      fix up block counting
      end of line counts as a space for ++ and --
      do { needs the same checks as if, for et al
      handle "const foo * const a" as a valid type
      add spacing checks following ;
      complete whitespace lines should trip trailing whitespace check
      else is also a block control structure
      badly formatted else can trip function declaration
      detect and report trailing statements after else
      types need to be terminated by a boundary
      multiline macros defining values should be surrounded by parentheses
      soften the wording of the Signed-off-by: warnings

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  145 +++++++++++++++++++++++++---------------
 1 file changed, 92 insertions(+), 53 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-006 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-006
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.05';
+my $V = '0.06';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -271,24 +271,38 @@ sub process {
 	my $in_comment = 0;
 	my $first_line = 0;
 
-	my $ident	= '[A-Za-z\d_]+';
-	my $storage	= '(?:extern|static)';
-	my $sparse	= '(?:__user|__kernel|__force|__iomem)';
-	my $type	= '(?:unsigned\s+)?' .
-			  '(?:void|char|short|int|long|unsigned|float|double|' .
-			  'long\s+long|' .
-			  "struct\\s+${ident}|" .
-			  "union\\s+${ident}|" .
-			  "${ident}_t)" .
-			  "(?:\\s+$sparse)*" .
-			  '(?:\s*\*+)?';
-	my $attribute	= '(?:__read_mostly|__init|__initdata)';
-
-	my $Ident	= $ident;
-	my $Type	= $type;
-	my $Storage	= $storage;
-	my $Declare	= "(?:$storage\\s+)?$type";
-	my $Attribute	= $attribute;
+	my $Ident	= qr{[A-Za-z\d_]+};
+	my $Storage	= qr{extern|static};
+	my $Sparse	= qr{__user|__kernel|__force|__iomem};
+	my $NonptrType	= qr{
+				\b
+				(?:const\s+)?
+				(?:unsigned\s+)?
+				(?:
+					void|
+					char|
+					short|
+					int|
+					long|
+					unsigned|
+					float|
+					double|
+					long\s+int|
+					long\s+long|
+					long\s+long\s+int|
+					struct\s+$Ident|
+					union\s+$Ident|
+					${Ident}_t
+				)
+				(?:\s+$Sparse)*
+				\b
+			  }x;
+	my $Type	= qr{
+				\b$NonptrType\b
+				(?:\s*\*+\s*const|\s*\*+)?
+			  }x;
+	my $Declare	= qr{(?:$Storage\s+)?$Type};
+	my $Attribute	= qr{__read_mostly|__init|__initdata};
 
 	foreach my $line (@lines) {
 		$linenr++;
@@ -321,6 +335,7 @@ sub process {
 # blank context lines so we need to count that too.
 		if ($line =~ /^( |\+|$)/) {
 			$realline++;
+			$realcnt-- if ($realcnt != 0);
 
 			# track any sort of multi-line comment.  Obviously if
 			# the added text or context do not include the whole
@@ -345,8 +360,9 @@ sub process {
 			# Track the previous line.
 			($prevline, $stashline) = ($stashline, $line);
 			($previndent, $stashindent) = ($stashindent, $indent);
+		} elsif ($realcnt == 1) {
+			$realcnt--;
 		}
-		$realcnt-- if ($realcnt != 0);
 
 #make up the handle for any error we report on this line
 		$here = "#$linenr: ";
@@ -357,14 +373,11 @@ sub process {
 		my $hereprev = "$here\n$prevline\n$line\n\n";
 
 #check the patch for a signoff:
-		if ($line =~ /^\s*Signed-off-by:\s/) {
-			$signoff++;
-
-		} elsif ($line =~ /^\s*signed-off-by:/i) {
+		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
 			$signoff++;
 			if (!($line =~ /^\s*Signed-off-by:/)) {
-				print "use Signed-off-by:\n";
+				print "Signed-off-by: is the preferred form\n";
 				print "$herecurr";
 				$clean = 0;
 			}
@@ -389,7 +402,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #trailing whitespace
-		if ($line=~/^\+.*\S\s+$/) {
+		if ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
 			print "trailing whitespace\n";
 			print "$herevet";
@@ -525,24 +538,23 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line =~ m{[A-Za-z\d_]+(\*+) [A-Za-z\d_]+}) {
-			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
+		if ($line =~ m{\($NonptrType(\*+)(?:\s+const)?\)}) {
+			print "\"(foo$1)\" should be \"(foo $1)\"\n";
 			print "$herecurr";
 			$clean = 0;
-		}
-		if ($line =~ m{$Type (\*) [A-Za-z\d_]+} ||
-		    $line =~ m{[A-Za-z\d_]+ (\*\*+) [A-Za-z\d_]+}) {
-			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
+
+		} elsif ($line =~ m{\($NonptrType\s+(\*+)(?!\s+const)\s+\)}) {
+			print "\"(foo $1 )\" should be \"(foo $1)\"\n";
 			print "$herecurr";
 			$clean = 0;
-		}
-		if ($line =~ m{\([A-Za-z\d_\s]+[A-Za-z\d_](\*+)\)}) {
-			print "\"(foo$1)\" should be \"(foo $1)\"\n";
+
+		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+const)?\s+[A-Za-z\d_]+}) {
+			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
 			print "$herecurr";
 			$clean = 0;
-		}
-		if ($line =~ m{\([A-Za-z\d_\s]+[A-Za-z\d_]\s+(\*+)\s+\)}) {
-			print "\"(foo $1 )\" should be \"(foo $1)\"\n";
+
+		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+const)\s+[A-Za-z\d_]+}) {
+			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
 			print "$herecurr";
 			$clean = 0;
 		}
@@ -581,7 +593,7 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/[A-Za-z\d_]+\**\s+\**[A-Za-z\d_]+\(.*\).* {/) and
+		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).* {/) and
 		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
 			print "braces following function declarations go on the next line\n";
 			print "$herecurr";
@@ -624,7 +636,7 @@ sub process {
 				my $ca = substr($opline, $off - 1, 1);
 				my $cc = '';
 				if (length($opline) >= ($off + length($elements[$n + 1]))) {
-					$cc = substr($opline, $off + length($elements[$n + 1]), 1);
+					$cc = substr($opline, $off + length($elements[$n + 1]));
 				}
 
 				my $ctx = "${a}x${c}";
@@ -636,8 +648,16 @@ sub process {
 
 				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
 
-				# We need ; as an operator.  // is a comment.
-				if ($op eq ';' or $op eq '//') {
+				# ; should have either the end of line or a space or \ after it
+				if ($op eq ';') {
+					if ($ctx !~ /.x[WE]/ && $cc !~ /^\\/) {
+						print "need space after that '$op' $at\n";
+						print "$hereptr";
+						$clean = 0;
+					}
+
+				# // is a comment
+				} elsif ($op eq '//') {
 
 				# -> should have no spaces
 				} elsif ($op eq '->') {
@@ -649,7 +669,7 @@ sub process {
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
-					if ($ctx !~ /.xW|.xE/ && $cc ne '}') {
+					if ($ctx !~ /.xW|.xE/ && $cc !~ /^}/) {
 						print "need space after that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -670,12 +690,12 @@ sub process {
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
-					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOB]/) {
+					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOBE]/) {
 						print "need space one side of that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
 					}
-					if ($ctx =~ /Wx./ && $cc eq ';') {
+					if ($ctx =~ /Wx./ && $cc =~ /^;/) {
 						print "no space before that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -707,7 +727,7 @@ sub process {
 				#
 				} elsif ($op eq '*') {
 					if ($ca eq '*') {
-						if ($cc =~ /\s/) {
+						if ($cc =~ /^\s(?!\s*const)/) {
 							print "no space after that '$op' $at\n";
 							print "$hereptr";
 							$clean = 0;
@@ -803,7 +823,7 @@ sub process {
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
-		if ($prevline=~/\b(if|while|for|switch)\s*\(/) {
+		if ($prevline=~/\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/) {
 			my @opened = $prevline=~/\(/g;
 			my @closed = $prevline=~/\)/g;
 			my $nr_line = $linenr;
@@ -823,14 +843,22 @@ sub process {
 				@closed = $prevline=~/\)/g;
 			}
 
-			if (($prevline=~/\b(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
-			   !($next_line=~/\b(if|while|for|switch)/) and !($next_line=~/\#define.*do.*while/)) {
+			if (($prevline=~/\b(?:(if|while|for|switch)\s*\(.*\)|do|else)\s*$/) and ($next_line=~/{/) and
+			   !($next_line=~/\b(?:if|while|for|switch|do|else)\b/) and !($next_line=~/\#define.*do.*while/)) {
 				print "That { should be on the previous line\n";
 				print "$here\n$display_segment\n$next_line\n\n";
 				$clean = 0;
 			}
 		}
 
+# if and else should not have general statements after it
+		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
+		    $1 !~ /^\s*(?:\sif|{|$)/) {
+			print "trailing statements should be on next line\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known goot container
@@ -841,11 +869,22 @@ sub process {
 			# Grab the first statement, if that is the entire macro
 			# its ok.  This may start either on the #define line
 			# or the one below.
-			my $ctx1 = join('', ctx_statement($linenr - 1, $realcnt + 1));
-			my $ctx2 = join('', ctx_statement($linenr, $realcnt));
+			my $ln = $linenr;
+			my $cnt = $realcnt;
 
-			if ($ctx1 =~ /\\$/ && $ctx2 =~ /\\$/) {
-				print "Macros with multiple statements should be enclosed in a do - while loop\n";
+			# If the macro starts on the define line start there.
+			if ($prevline !~ m{^.#\s*define\s*$Ident(?:\([^\)]*\))?\s*\\\s*$}) {
+				$ln--;
+				$cnt++;
+			}
+			my $ctx = join('', ctx_statement($ln, $cnt));
+
+			if ($ctx =~ /\\$/) {
+				if ($ctx =~ /;/) {
+					print "Macros with multiple statements should be enclosed in a do - while loop\n";
+				} else {
+					print "Macros with complex values should be enclosed in parenthesis\n";
+				}
 				print "$hereprev";
 				$clean = 0;
 			}
_

Patches currently in -mm which might be from apw@shadowen.org are

update-checkpatchpl-to-version-005.patch
update-checkpatchpl-to-version-006.patch
i386-move-the-kernel-to-16mb-for-numa-q.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
allow-page_owner-to-be-set-on-any-architecture.patch
