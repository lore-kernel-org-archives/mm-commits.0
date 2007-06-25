From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-005.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:53 -0700
Message-ID: <200706250920.l5P9Krfd031059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbXFYJVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.05
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-005.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update checkpatch.pl to version 0.05
From: Andy Whitcroft <apw@shadowen.org>

This version brings a some new tests, and a host of changes to fix
false positives, of particular note:

 - detect 'var ++;' and 'var --;' as a bad combination
 - multistatement #defines are now checked based on statement count
 - multistatement #defines with initialisation correctly reported
 - checks the location of the inline keywords
 - EXPORT_SYMBOL for variables are now understood
 - typedefs are loosened to handle sparse etc

This version of checkpatch.pl can be found at the following URL:

      http://www.shadowen.org/~apw/public/checkpatch/checkpatch.pl-0.05

Full Changelog:

Andy Whitcroft (18):
      Version: 0.05
      macro definition checks should be for a single statement
      avoid assignements only in if conditionals
      declarations of function pointers need no space
      multiline macros which are purely initialisation cannot be wrapped
      EXPORT_SYMBOL can also directly follow a variable definition
      check on the location of the inline keyword
      EXPORT_SYMBOL needs to allow for attributes
      ensure we do not find C99 // in strings
      handle malformed #include lines
      accept the {0,} form
      typedefs are sensible for defining function pointer parameters
      ensure { handling correctly handles nested switch() statements
      trailing whitespace checks are not anchored
      typedefs for sparse bitwise annotations make sense
      update the type matcher to include sparse annotations
      clean up indent and spacing

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  183 ++++++++++++++++++++++++++++------------
 1 file changed, 129 insertions(+), 54 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-005 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-005
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.04';
+my $V = '0.05';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -17,11 +17,13 @@ my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
+my $tst_type = 0;
 GetOptions(
 	'q|quiet'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
 	'patch!'	=> \$chk_patch,
+	'test-type!'	=> \$tst_type,
 ) or exit;
 
 my $exit = 0;
@@ -151,7 +153,7 @@ sub sanitise_line {
 }
 
 sub ctx_block_get {
-	my ($linenr, $remain, $outer) = @_;
+	my ($linenr, $remain, $outer, $open, $close) = @_;
 	my $line;
 	my $start = $linenr - 1;
 	my $blk = '';
@@ -165,8 +167,8 @@ sub ctx_block_get {
 
 		$blk .= $rawlines[$line];
 
-		@o = ($blk =~ /\{/g);
-		@c = ($blk =~ /\}/g);
+		@o = ($blk =~ /$open/g);
+		@c = ($blk =~ /$close/g);
 
 		if (!$outer || (scalar(@o) - scalar(@c)) == 1) {
 			push(@res, $rawlines[$line]);
@@ -180,12 +182,17 @@ sub ctx_block_get {
 sub ctx_block_outer {
 	my ($linenr, $remain) = @_;
 
-	return ctx_block_get($linenr, $remain, 1);
+	return ctx_block_get($linenr, $remain, 1, '\{', '\}');
 }
 sub ctx_block {
 	my ($linenr, $remain) = @_;
 
-	return ctx_block_get($linenr, $remain, 0);
+	return ctx_block_get($linenr, $remain, 0, '\{', '\}');
+}
+sub ctx_statement {
+	my ($linenr, $remain) = @_;
+
+	return ctx_block_get($linenr, $remain, 0, '\(', '\)');
 }
 
 sub ctx_locate_comment {
@@ -264,9 +271,30 @@ sub process {
 	my $in_comment = 0;
 	my $first_line = 0;
 
+	my $ident	= '[A-Za-z\d_]+';
+	my $storage	= '(?:extern|static)';
+	my $sparse	= '(?:__user|__kernel|__force|__iomem)';
+	my $type	= '(?:unsigned\s+)?' .
+			  '(?:void|char|short|int|long|unsigned|float|double|' .
+			  'long\s+long|' .
+			  "struct\\s+${ident}|" .
+			  "union\\s+${ident}|" .
+			  "${ident}_t)" .
+			  "(?:\\s+$sparse)*" .
+			  '(?:\s*\*+)?';
+	my $attribute	= '(?:__read_mostly|__init|__initdata)';
+
+	my $Ident	= $ident;
+	my $Type	= $type;
+	my $Storage	= $storage;
+	my $Declare	= "(?:$storage\\s+)?$type";
+	my $Attribute	= $attribute;
+
 	foreach my $line (@lines) {
 		$linenr++;
 
+		my $rawline = $line;
+
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile=$1;
@@ -361,7 +389,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #trailing whitespace
-		if ($line=~/\+.*\S\s+$/) {
+		if ($line=~/^\+.*\S\s+$/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
 			print "trailing whitespace\n";
 			print "$herevet";
@@ -392,17 +420,20 @@ sub process {
 		#
 		next if ($in_comment);
 
-		# Remove comments from the line before processing.
+# Remove comments from the line before processing.
 		$line =~ s@/\*.*\*/@@g;
 		$line =~ s@/\*.*@@;
 		$line =~ s@.*\*/@@;
 
-		#
-		# Checks which may be anchored in the context.
-		#
+# Standardise the strings and chars within the input to simplify matching.
+		$line = sanitise_line($line);
+
+#
+# Checks which may be anchored in the context.
+#
 
-		# Check for switch () and associated case and default
-		# statements should be at the same indent.
+# Check for switch () and associated case and default
+# statements should be at the same indent.
 		if ($line=~/\bswitch\s*\(.*\)/) {
 			my $err = '';
 			my $sep = '';
@@ -428,9 +459,30 @@ sub process {
 #ignore lines not being added
 		if ($line=~/^[^\+]/) {next;}
 
-		#
-		# Checks which are anchored on the added line.
-		#
+# TEST: allow direct testing of the type matcher.
+		if ($tst_type && $line =~ /^.$Declare$/) {
+			print "TEST: is type $Declare\n";
+			print "$herecurr";
+			$clean = 0;
+			next;
+		}
+
+#
+# Checks which are anchored on the added line.
+#
+
+# check for malformed paths in #include statements (uses RAW line)
+		if ($rawline =~ m{^.#\s*include\s+[<"](.*)[">]}) {
+			my $path = $1;
+			if ($path =~ m{//}) {
+				print "malformed #include filename\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+			# Sanitise this special form of string.
+			$path = 'X' x length($path);
+			$line =~ s{\<.*\>}{<$path>};
+		}
 
 # no C99 // comments
 		if ($line =~ m{//}) {
@@ -441,47 +493,44 @@ sub process {
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
 
-		# Standardise the strings and chars within the input
-		# to simplify matching.
-		$line = sanitise_line($line);
-
 #EXPORT_SYMBOL should immediately follow its function closing }.
-		if (($line =~ /EXPORT_SYMBOL.*\(.*\)/) ||
-		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\(.*\)/)) {
+		if (($line =~ /EXPORT_SYMBOL.*\((.*)\)/) ||
+		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+			my $name = $1;
 			if (($prevline !~ /^}/) &&
 			   ($prevline !~ /^\+}/) &&
-			   ($prevline !~ /^ }/)) {
-				print "EXPORT_SYMBOL(func); should immediately follow its function\n";
+			   ($prevline !~ /^ }/) &&
+			   ($prevline !~ /\s$name(?:\s+$Attribute)?\s*(?:;|=)/)) {
+				print "EXPORT_SYMBOL(foo); should immediately follow its function/variable\n";
 				print "$herecurr";
 				$clean = 0;
 			}
 		}
 
-		# check for static initialisers.
+# check for static initialisers.
 		if ($line=~/\s*static\s.*=\s+(0|NULL);/) {
 			print "do not initialise statics to 0 or NULL\n";
 			print "$herecurr";
 			$clean = 0;
 		}
 
-		# check for new typedefs.
-		if ($line=~/\s*typedef\s/) {
+# check for new typedefs, only function parameters and sparse annotations
+# make sense.
+		if ($line =~ /\btypedef\s/ &&
+		    $line !~ /\btypedef\s+$Type\s+\(\s*$Ident\s*\)\s*\(/ &&
+		    $line !~ /\b__bitwise(?:__|)\b/) {
 			print "do not add new typedefs\n";
 			print "$herecurr";
 			$clean = 0;
 		}
 
 # * goes on variable not on type
-		my $type = '(?:char|short|int|long|unsigned|float|double|' .
-			   'struct\s+[A-Za-z\d_]+|' .
-			   'union\s+[A-Za-z\d_]+)';
-
 		if ($line =~ m{[A-Za-z\d_]+(\*+) [A-Za-z\d_]+}) {
 			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
 			print "$herecurr";
 			$clean = 0;
 		}
-		if ($line =~ m{$type (\*) [A-Za-z\d_]+} ||
+		if ($line =~ m{$Type (\*) [A-Za-z\d_]+} ||
 		    $line =~ m{[A-Za-z\d_]+ (\*\*+) [A-Za-z\d_]+}) {
 			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
 			print "$herecurr";
@@ -530,13 +579,16 @@ sub process {
 			}
 		}
 
-#function brace can't be on same line, except for #defines of do while, or if closed on same line
+# function brace can't be on same line, except for #defines of do while,
+# or if closed on same line
 		if (($line=~/[A-Za-z\d_]+\**\s+\**[A-Za-z\d_]+\(.*\).* {/) and
 		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
 			print "braces following function declarations go on the next line\n";
 			print "$herecurr";
 			$clean = 0;
 		}
+
+# Check operator spacing.
 		# Note we expand the line with the leading + as the real
 		# line will be displayed with the leading + and the tabs
 		# will therefore also expand that way.
@@ -544,7 +596,6 @@ sub process {
 		$opline = expand_tabs($opline);
 		$opline =~ s/^./ /;
 		if (!($line=~/\#\s*include/)) {
-			# Check operator spacing.
 			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
 			my $off = 0;
 			for (my $n = 0; $n < $#elements; $n += 2) {
@@ -572,8 +623,8 @@ sub process {
 				# Pick up the preceeding and succeeding characters.
 				my $ca = substr($opline, $off - 1, 1);
 				my $cc = '';
-				if (length($opline) > ($off + length($elements[$n]))) {
-					$cc = substr($opline, $off + 1 + length($elements[$n]), 1);
+				if (length($opline) >= ($off + length($elements[$n + 1]))) {
+					$cc = substr($opline, $off + length($elements[$n + 1]), 1);
 				}
 
 				my $ctx = "${a}x${c}";
@@ -598,7 +649,7 @@ sub process {
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
-					if ($ctx !~ /.xW|.xE/) {
+					if ($ctx !~ /.xW|.xE/ && $cc ne '}') {
 						print "need space after that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -619,11 +670,16 @@ sub process {
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
-					if ($ctx !~ /[WOB]x[^W]|[^W]x[WOB]/) {
+					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOB]/) {
 						print "need space one side of that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
 					}
+					if ($ctx =~ /Wx./ && $cc eq ';') {
+						print "no space before that '$op' $at\n";
+						print "$hereptr";
+						$clean = 0;
+					}
 
 				# & is both unary and binary
 				# unary:
@@ -656,7 +712,7 @@ sub process {
 							print "$hereptr";
 							$clean = 0;
 						}
-					} elsif ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]|OxV|WxB/) {
+					} elsif ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]|OxV|WxB|BxB/) {
 						print "need space before that '$op' $at\n";
 						print "$hereptr";
 						$clean = 0;
@@ -705,9 +761,9 @@ sub process {
 		}
 
 # Check for illegal assignment in if conditional.
-		if ($line=~/\b(if|while)\s*\(.*[^<>!=]=[^=].*\)/) {
+		if ($line=~/\bif\s*\(.*[^<>!=]=[^=].*\)/) {
 			#next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
-			print "do not use assignment in condition\n";
+			print "do not use assignment in if condition\n";
 			print "$herecurr";
 			$clean = 0;
 		}
@@ -735,8 +791,8 @@ sub process {
 			$clean = 0;
 		}
 
-#warn if <asm/foo.h> is #included and <linux/foo.h> is available.
-		if ($tree && $line =~ qr|\s*\#\s*include\s*\<asm\/(.*)\.h\>|) {
+#warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
+		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $checkfile = "include/linux/$1.h";
 			if (-f $checkfile) {
 				print "Use #include <linux/$1.h> instead of <asm/$1.h>\n";
@@ -745,7 +801,8 @@ sub process {
 			}
 		}
 
-#if/while/etc brace do not go on next line, unless #defining a do while loop, or if that brace on the next line is for something else
+# if/while/etc brace do not go on next line, unless defining a do while loop,
+# or if that brace on the next line is for something else
 		if ($prevline=~/\b(if|while|for|switch)\s*\(/) {
 			my @opened = $prevline=~/\(/g;
 			my @closed = $prevline=~/\)/g;
@@ -767,25 +824,36 @@ sub process {
 			}
 
 			if (($prevline=~/\b(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
-			   !($next_line=~/\b(if|while|for)/) and !($next_line=~/\#define.*do.*while/)) {
+			   !($next_line=~/\b(if|while|for|switch)/) and !($next_line=~/\#define.*do.*while/)) {
 				print "That { should be on the previous line\n";
 				print "$here\n$display_segment\n$next_line\n\n";
 				$clean = 0;
 			}
 		}
 
-#multiline macros should be enclosed in a do while loop
-		if (($prevline=~/\#define.*\\/) and !($prevline=~/do\s+{/) and
-		   !($prevline=~/\(\{/) and ($line=~/;\s*\\/) and
-		   !($line=~/do.*{/) and !($line=~/\(\{/)) {
-			print "Macros with multiple statements should be enclosed in a do - while loop\n";
-			print "$hereprev";
-			$clean = 0;
+# multi-statement macros should be enclosed in a do while loop, grab the
+# first statement and ensure its the whole macro if its not enclosed
+# in a known goot container
+		if (($prevline=~/\#define.*\\/) and
+		   !($prevline=~/do\s+{/) and !($prevline=~/\(\{/) and
+		   !($line=~/do.*{/) and !($line=~/\(\{/) and
+		   !($line=~/^.\s*$Declare\s/)) {
+			# Grab the first statement, if that is the entire macro
+			# its ok.  This may start either on the #define line
+			# or the one below.
+			my $ctx1 = join('', ctx_statement($linenr - 1, $realcnt + 1));
+			my $ctx2 = join('', ctx_statement($linenr, $realcnt));
+
+			if ($ctx1 =~ /\\$/ && $ctx2 =~ /\\$/) {
+				print "Macros with multiple statements should be enclosed in a do - while loop\n";
+				print "$hereprev";
+				$clean = 0;
+			}
 		}
 
-# don't include deprecated include files
+# don't include deprecated include files (uses RAW line)
 		for my $inc (@dep_includes) {
-			if ($line =~ m@\#\s*include\s*\<$inc>@) {
+			if ($rawline =~ m@\#\s*include\s*\<$inc>@) {
 				print "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n";
 				print "$herecurr";
 				$clean = 0;
@@ -845,6 +913,13 @@ sub process {
 			print "$herecurr";
 			$clean = 0;
 		}
+
+		if ($line =~ /$Type\s+(?:inline|__always_inline)\b/ ||
+		    $line =~ /\b(?:inline|always_inline)\s+$Storage/) {
+			print "inline keyword should sit between storage class and type\n";
+			print "$herecurr";
+			$clean = 0;
+		}
 	}
 
 	if ($chk_patch && !$is_patch) {
_

Patches currently in -mm which might be from apw@shadowen.org are

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
