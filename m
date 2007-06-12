From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-004.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:37 -0700
Message-ID: <200706121857.l5CIvbTl018488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbXFLTH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, jschopp@austin.ibm.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.04
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-004.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update checkpatch.pl to version 0.04
From: Andy Whitcroft <apw@shadowen.org>

This version brings a some new tests, and a host of changes to fix
false positives, of particular note:

  - check for and report #if 0
  - extend checking of line lengths and spacing for .pl, .sh etc
  - extends the pointer type checks to multiple levels
  - updates printk handling to track newlines
  - adds a wrapped patch detector
  - drops the leading component of the filenames
  - extends switch indent handling to switch statmentes rooted in
    the context
  - adds foo * bar single pointer checks

This version of checkpatch.pl can be found at the following URL:

      http://www.shadowen.org/~apw/public/checkpatch/checkpatch.pl-0.04

Full Changelog:

Andy Whitcroft (16):
      allow checking line lengths and spacing on other source files
      clean up that whitespace
      sanitise the input line standardising the content of quotes
      clean up pointer type * and space checks
      fix up the sanitiser so it maintains the line length
      apply the printk facility checks only to the first printk in a set
      switch/case indent checks may anchor in the context
      add a wrapped patch detector
      put the #ifdef in C file checks on ice
      asm volatile is acceptable
      check for and report #if 0
      drop the leading component of the filename as patches are -p1
      use the original line when reporting operator errors
      correct spelling of Joel's name
      Version: 0.04
      add support for struct foo * bar checks

Geert Uytterhoeven (1):
      Fix checkpatch.pl name in usage template

Randy Dunlap (1):
      checkpatch: produce fewer lines of output

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  274 ++++++++++++++++++++++++++++------------
 1 files changed, 193 insertions(+), 81 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-004 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-004
+++ a/scripts/checkpatch.pl
@@ -1,14 +1,15 @@
 #!/usr/bin/perl -w
 # (c) 2001, Dave Jones. <davej@codemonkey.org.uk> (the file handling bit)
-# (c) 2005, Joel Scohpp <jschopp@austin.ibm.com> (the ugly bit)
+# (c) 2005, Joel Schopp <jschopp@austin.ibm.com> (the ugly bit)
 # (c) 2007, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite, etc)
 # Licensed under the terms of the GNU GPL License version 2
 
 use strict;
 
 my $P = $0;
+$P =~ s@.*/@@g;
 
-my $V = '0.03';
+my $V = '0.04';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -26,7 +27,7 @@ GetOptions(
 my $exit = 0;
 
 if ($#ARGV < 0) {
-	print "usage: patchstylecheckemail.pl [options] patchfile\n";
+	print "usage: $P [options] patchfile\n";
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
@@ -59,15 +60,15 @@ if ($tree && -f $removal) {
 	}
 }
 
-my @lines = ();
+my @rawlines = ();
 while (<>) {
 	chomp;
-	push(@lines, $_);
+	push(@rawlines, $_);
 	if (eof(ARGV)) {
-		if (!process($ARGV, @lines)) {
+		if (!process($ARGV, @rawlines)) {
 			$exit = 1;
 		}
-		@lines = ();
+		@rawlines = ();
 	}
 }
 
@@ -118,24 +119,57 @@ sub line_stats {
 	return (length($line), length($white));
 }
 
+sub sanitise_line {
+	my ($line) = @_;
+
+	my $res = '';
+	my $l = '';
+
+	my $quote = '';
+
+	foreach my $c (split(//, $line)) {
+		if ($l ne "\\" && ($c eq "'" || $c eq '"')) {
+			if ($quote eq '') {
+				$quote = $c;
+				$res .= $c;
+				$l = $c;
+				next;
+			} elsif ($quote eq $c) {
+				$quote = '';
+			}
+		}
+		if ($quote && $c ne "\t") {
+			$res .= "X";
+		} else {
+			$res .= $c;
+		}
+
+		$l = $c;
+	}
+
+	return $res;
+}
+
 sub ctx_block_get {
 	my ($linenr, $remain, $outer) = @_;
 	my $line;
 	my $start = $linenr - 1;
-	my $end = $linenr - 1 + $remain;
 	my $blk = '';
 	my @o;
 	my @c;
 	my @res = ();
 
-	for ($line = $start; $line < $end; $line++) {
-		$blk .= $lines[$line];
+	for ($line = $start; $remain > 0; $line++) {
+		next if ($rawlines[$line] =~ /^-/);
+		$remain--;
+
+		$blk .= $rawlines[$line];
 
 		@o = ($blk =~ /\{/g);
 		@c = ($blk =~ /\}/g);
 
 		if (!$outer || (scalar(@o) - scalar(@c)) == 1) {
-			push(@res, $lines[$line]);
+			push(@res, $rawlines[$line]);
 		}
 
 		last if (scalar(@o) == scalar(@c));
@@ -158,7 +192,7 @@ sub ctx_locate_comment {
 	my ($first_line, $end_line) = @_;
 
 	# Catch a comment on the end of the line itself.
-	my ($current_comment) = ($lines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*$@);
+	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*$@);
 	return $current_comment if (defined $current_comment);
 
 	# Look through the context and try and figure out if there is a
@@ -166,8 +200,8 @@ sub ctx_locate_comment {
 	my $in_comment = 0;
 	$current_comment = '';
 	for (my $linenr = $first_line; $linenr < $end_line; $linenr++) {
-		my $line = $lines[$linenr - 1];
-		##warn "           $line\n";
+		my $line = $rawlines[$linenr - 1];
+		#warn "           $line\n";
 		if ($linenr == $first_line and $line =~ m@^.\s*\*@) {
 			$in_comment = 1;
 		}
@@ -190,7 +224,7 @@ sub ctx_has_comment {
 	my ($first_line, $end_line) = @_;
 	my $cmt = ctx_locate_comment($first_line, $end_line);
 
-	##print "LINE: $lines[$end_line - 1 ]\n";
+	##print "LINE: $rawlines[$end_line - 1 ]\n";
 	##print "CMMT: $cmt\n";
 
 	return ($cmt ne '');
@@ -205,10 +239,6 @@ sub cat_vet {
 	return $vet;
 }
 
-sub has_non_quoted {
-	return ($_[0] =~ m{$_[1]} and $_[0] !~ m{\".*$_[1].*\"});
-}
-
 sub process {
 	my $filename = shift;
 	my @lines = @_;
@@ -240,6 +270,7 @@ sub process {
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile=$1;
+			$realfile =~ s@^[^/]*/@@;
 			$in_comment = 0;
 			next;
 		}
@@ -262,7 +293,6 @@ sub process {
 # blank context lines so we need to count that too.
 		if ($line =~ /^( |\+|$)/) {
 			$realline++;
-			$realcnt-- if ($realcnt != 0);
 
 			# track any sort of multi-line comment.  Obviously if
 			# the added text or context do not include the whole
@@ -288,11 +318,13 @@ sub process {
 			($prevline, $stashline) = ($stashline, $line);
 			($previndent, $stashindent) = ($stashindent, $indent);
 		}
+		$realcnt-- if ($realcnt != 0);
 
 #make up the handle for any error we report on this line
 		$here = "#$linenr: ";
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
+		my $hereline = "$here\n$line\n";
 		my $herecurr = "$here\n$line\n\n";
 		my $hereprev = "$here\n$prevline\n$line\n\n";
 
@@ -315,21 +347,28 @@ sub process {
 			}
 		}
 
-#ignore lines not being added
-		if ($line=~/^[^\+]/) {next;}
+# Check for wrappage within a valid hunk of the file
+		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |$)}) {
+			print "patch seems to be corrupt (line wrapped?) [$realcnt]\n";
+			print "$herecurr";
+			$clean = 0;
+		}
 
-# check we are in a valid source file *.[hcsS] if not then ignore this hunk
-		next if ($realfile !~ /\.[hcsS]$/);
+#ignore lines being removed
+		if ($line=~/^-/) {next;}
+
+# check we are in a valid source file if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #trailing whitespace
-		if ($line=~/\S\s+$/) {
+		if ($line=~/\+.*\S\s+$/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
 			print "trailing whitespace\n";
 			print "$herevet";
 			$clean = 0;
 		}
 #80 column limit
-		if (!($prevline=~/\/\*\*/) && $length > 80) {
+		if ($line =~ /^\+/ && !($prevline=~/\/\*\*/) && $length > 80) {
 			print "line over 80 characters\n";
 			print "$herecurr";
 			$clean = 0;
@@ -353,19 +392,59 @@ sub process {
 		#
 		next if ($in_comment);
 
+		# Remove comments from the line before processing.
+		$line =~ s@/\*.*\*/@@g;
+		$line =~ s@/\*.*@@;
+		$line =~ s@.*\*/@@;
+
+		#
+		# Checks which may be anchored in the context.
+		#
+
+		# Check for switch () and associated case and default
+		# statements should be at the same indent.
+		if ($line=~/\bswitch\s*\(.*\)/) {
+			my $err = '';
+			my $sep = '';
+			my @ctx = ctx_block_outer($linenr, $realcnt);
+			shift(@ctx);
+			for my $ctx (@ctx) {
+				my ($clen, $cindent) = line_stats($ctx);
+				if ($ctx =~ /^\+\s*(case\s+|default:)/ &&
+							$indent != $cindent) {
+					$err .= "$sep$ctx\n";
+					$sep = '';
+				} else {
+					$sep = "[...]\n";
+				}
+			}
+			if ($err ne '') {
+				print "switch and case should be at the same indent\n";
+				print "$here\n$line\n$err\n";
+				$clean = 0;
+			}
+		}
+
+#ignore lines not being added
+		if ($line=~/^[^\+]/) {next;}
+
+		#
+		# Checks which are anchored on the added line.
+		#
+
 # no C99 // comments
-		if (has_non_quoted($line, '//')) {
+		if ($line =~ m{//}) {
 			print "do not use C99 // comments\n";
 			print "$herecurr";
 			$clean = 0;
 		}
-
-		# Remove comments from the line before processing.
-		$line =~ s@/\*.*\*/@@g;
-		$line =~ s@/\*.*@@;
-		$line =~ s@.*\*/@@;
+		# Remove C99 comments.
 		$line =~ s@//.*@@;
 
+		# Standardise the strings and chars within the input
+		# to simplify matching.
+		$line = sanitise_line($line);
+
 #EXPORT_SYMBOL should immediately follow its function closing }.
 		if (($line =~ /EXPORT_SYMBOL.*\(.*\)/) ||
 		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\(.*\)/)) {
@@ -393,8 +472,28 @@ sub process {
 		}
 
 # * goes on variable not on type
-		if ($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
-			print "\"foo* bar\" should be \"foo *bar\"\n";
+		my $type = '(?:char|short|int|long|unsigned|float|double|' .
+			   'struct\s+[A-Za-z\d_]+|' .
+			   'union\s+[A-Za-z\d_]+)';
+
+		if ($line =~ m{[A-Za-z\d_]+(\*+) [A-Za-z\d_]+}) {
+			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+		if ($line =~ m{$type (\*) [A-Za-z\d_]+} ||
+		    $line =~ m{[A-Za-z\d_]+ (\*\*+) [A-Za-z\d_]+}) {
+			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+		if ($line =~ m{\([A-Za-z\d_\s]+[A-Za-z\d_](\*+)\)}) {
+			print "\"(foo$1)\" should be \"(foo $1)\"\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+		if ($line =~ m{\([A-Za-z\d_\s]+[A-Za-z\d_]\s+(\*+)\s+\)}) {
+			print "\"(foo $1 )\" should be \"(foo $1)\"\n";
 			print "$herecurr";
 			$clean = 0;
 		}
@@ -406,11 +505,29 @@ sub process {
 # 			$clean = 0;
 # 		}
 
-# printk should use KERN_* levels
+# printk should use KERN_* levels.  Note that follow on printk's on the
+# same line do not need a level, so we use the current block context
+# to try and find and validate the current printk.  In summary the current
+# printk includes all preceeding printk's which have no newline on the end.
+# we assume the first bad printk is the one to report.
 		if ($line =~ /\bprintk\((?!KERN_)/) {
-			print "printk() should include KERN_ facility level\n";
-			print "$herecurr";
-			$clean = 0;
+			my $ok = 0;
+			for (my $ln = $linenr - 1; $ln >= $first_line; $ln--) {
+				#print "CHECK<$lines[$ln - 1]\n";
+				# we have a preceeding printk if it ends
+				# with "\n" ignore it, else it is to blame
+				if ($lines[$ln - 1] =~ m{\bprintk\(}) {
+					if ($rawlines[$ln - 1] !~ m{\\n"}) {
+						$ok = 1;
+					}
+					last;
+				}
+			}
+			if ($ok == 0) {
+				print "printk() should include KERN_ facility level\n";
+				print "$herecurr";
+				$clean = 0;
+			}
 		}
 
 #function brace can't be on same line, except for #defines of do while, or if closed on same line
@@ -425,11 +542,11 @@ sub process {
 		# will therefore also expand that way.
 		my $opline = $line;
 		$opline = expand_tabs($opline);
-		$opline =~ s/^.//;
+		$opline =~ s/^./ /;
 		if (!($line=~/\#\s*include/)) {
 			# Check operator spacing.
 			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
-			my $off = 1;
+			my $off = 0;
 			for (my $n = 0; $n < $#elements; $n += 2) {
 				$off += length($elements[$n]);
 
@@ -452,16 +569,21 @@ sub process {
 					$c = 'E';
 				}
 
+				# Pick up the preceeding and succeeding characters.
+				my $ca = substr($opline, $off - 1, 1);
+				my $cc = '';
+				if (length($opline) > ($off + length($elements[$n]))) {
+					$cc = substr($opline, $off + 1 + length($elements[$n]), 1);
+				}
+
 				my $ctx = "${a}x${c}";
 
 				my $at = "(ctx:$ctx)";
 
 				my $ptr = (" " x $off) . "^";
-				my $hereptr = "$here\n$line\n$ptr\n\n";
+				my $hereptr = "$hereline$ptr\n\n";
 
 				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
-				# Skip things apparently in quotes.
-				next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
 
 				# We need ; as an operator.  // is a comment.
 				if ($op eq ';' or $op eq '//') {
@@ -515,20 +637,26 @@ sub process {
 				#
 				# - is the same
 				#
-				# * is the same only adding:
-				# type:
-				# 	(foo *)
-				#	(foo **)
-				#
 				} elsif ($op eq '&' or $op eq '-') {
-					if ($ctx !~ /VxV|[EWB]x[WE]|[EWB]x[VO]/) {
+					if ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]/) {
 						print "need space before that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
 					}
 
+				# * is the same as & only adding:
+				# type:
+				# 	(foo *)
+				#	(foo **)
+				#
 				} elsif ($op eq '*') {
-					if ($ctx !~ /VxV|[EWB]x[WE]|[EWB]x[VO]|[EWO]x[OBV]/) {
+					if ($ca eq '*') {
+						if ($cc =~ /\s/) {
+							print "no space after that '$op' $at\n";
+							print "$hereptr";
+							$clean = 0;
+						}
+					} elsif ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]|OxV|WxB/) {
 						print "need space before that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -578,6 +706,7 @@ sub process {
 
 # Check for illegal assignment in if conditional.
 		if ($line=~/\b(if|while)\s*\(.*[^<>!=]=[^=].*\)/) {
+			#next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
 			print "do not use assignment in condition\n";
 			print "$herecurr";
 			$clean = 0;
@@ -592,30 +721,6 @@ sub process {
 			$clean = 0;
 		}
 
-		# Check for switch () and associated case and default
-		# statements should be at the same indent.
-		if ($line=~/\bswitch\s*\(.*\)/) {
-			my $err = '';
-			my $sep = '';
-			my @ctx = ctx_block_outer($linenr, $realcnt);
-			shift(@ctx);
-			for my $ctx (@ctx) {
-				my ($clen, $cindent) = line_stats($ctx);
-				if ($ctx =~ /\s*(case\s+|default:)/ &&
-							$indent != $cindent) {
-					$err .= "$sep$ctx\n";
-					$sep = '';
-				} else {
-					$sep = "[...]\n";
-				}
-			}
-			if ($err ne '') {
-				print "switch and case should be at the same indent\n";
-				print "$here\n$line\n$err\n";
-				$clean = 0;
-			}
-		}
-
 #studly caps, commented out until figure out how to distinguish between use of existing and adding new
 #		if (($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
 #		    print "No studly caps, use _\n";
@@ -645,12 +750,12 @@ sub process {
 			my @opened = $prevline=~/\(/g;
 			my @closed = $prevline=~/\)/g;
 			my $nr_line = $linenr;
-			my $remaining = $realcnt;
+			my $remaining = $realcnt - 1;
 			my $next_line = $line;
 			my $extra_lines = 0;
 			my $display_segment = $prevline;
 
-			while ($remaining > 1 && scalar @opened > scalar @closed) {
+			while ($remaining > 0 && scalar @opened > scalar @closed) {
 				$prevline .= $next_line;
 				$display_segment .= "\n" . $next_line;
 				$next_line = $lines[$nr_line];
@@ -689,7 +794,7 @@ sub process {
 
 # don't use deprecated functions
 		for my $func (@dep_functions) {
-			if (has_non_quoted($line, '\b' . $func . '\b')) {
+			if ($line =~ /\b$func\b/) {
 				print "Don't use $func(): see Documentation/feature-removal-schedule.txt\n";
 				print "$herecurr";
 				$clean = 0;
@@ -697,19 +802,26 @@ sub process {
 		}
 
 # no volatiles please
- 		if (has_non_quoted($line, '\bvolatile\b')) {
+		if ($line =~ /\bvolatile\b/ && $line !~ /\basm\s+volatile\b/) {
 			print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";
 			print "$herecurr";
 			$clean = 0;
 		}
 
-# warn about #ifdefs in C files
-		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
-			print "#ifdef in C files should be avoided\n";
+# warn about #if 0
+		if ($line =~ /^.#\s*if\s+0\b/) {
+			print "#if 0 -- if this code redundant remove it\n";
 			print "$herecurr";
 			$clean = 0;
 		}
 
+# warn about #ifdefs in C files
+#		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
+#			print "#ifdef in C files should be avoided\n";
+#			print "$herecurr";
+#			$clean = 0;
+#		}
+
 # check for spinlock_t definitions without a comment.
 		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
 			my $which = $1;
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
group-short-lived-and-reclaimable-kernel-allocations-fix.patch
i386-move-the-kernel-to-16mb-for-numa-q.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
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
