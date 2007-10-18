From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-010.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:54 -0700
Message-ID: <200710180659.l9I6xsa4031032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763594AbXJRHQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.10
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-010.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update checkpatch.pl to version 0.10
From: Andy Whitcroft <apw@shadowen.org>

This version brings a number of new checks, and a number of bug
fixes.  Of note:

  - better categorisation and space checks for dual use unary/binary
    operators
  - warn on deprecated use of {SPIN,RW}_LOCK_UNLOCKED
  - check if/for/while with trailing ';' for hanging statements
  - detect DOS line endings
  - detect redundant casts for kalloc()

Andy Whitcroft (18):
      Version: 0.10
      asmlinkage is also a storage type
      pull out inline specifiers
      allow only some operators before a unary operator
      parenthesised values may span line ends
      add additional attribute matching
      handle sparse annotations within pointer type space checks
      support alternative function definition syntax for typedefs
      check if/for/while with trailing ';' for hanging statements
      fix output format for case checks
      deprecate SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED
      allow complex macros with bracketing braces
      detect and report DOS line endings
      fastcall is a valid function attribute
      bracket spacing is ok for 'for'
      categorise operators into unary/binary/definitions
      add heuristic to pick up on unannotated types
      remove spurious warnings from cat_vet

Dave Jones (1):
      Make checkpatch warn about pointless casting of kalloc returns.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  254 ++++++++++++++++++++++++++++++----------
 1 file changed, 196 insertions(+), 58 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-010 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-010
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.09';
+my $V = '0.10';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -212,6 +212,11 @@ sub ctx_block_level {
 
 	return ctx_block_get($linenr, $remain, 0, '{', '}', 0);
 }
+sub ctx_statement_level {
+	my ($linenr, $remain, $off) = @_;
+
+	return ctx_block_get($linenr, $remain, 0, '(', ')', $off);
+}
 
 sub ctx_locate_comment {
 	my ($first_line, $end_line) = @_;
@@ -255,13 +260,42 @@ sub ctx_has_comment {
 	return ($cmt ne '');
 }
 
+sub ctx_expr_before {
+	my ($line) = @_;
+
+	##print "CHECK<$line>\n";
+
+	my $pos = length($line) - 1;
+	my $count = 0;
+	my $c;
+
+	for (; $pos >= 0; $pos--) {
+		$c = substr($line, $pos, 1);
+		##print "CHECK: c<$c> count<$count>\n";
+		if ($c eq ')') {
+			$count++;
+		} elsif ($c eq '(') {
+			last if (--$count == 0);
+		}
+	}
+
+	##print "CHECK: result<" . substr($line, 0, $pos) . ">\n";
+
+	return substr($line, 0, $pos);
+}
+
 sub cat_vet {
 	my ($vet) = @_;
+	my ($res, $coded);
 
-	$vet =~ s/\t/^I/;
-	$vet =~ s/$/\$/;
+	$res = '';
+	while ($vet =~ /([^[:cntrl:]]*)([[:cntrl:]])/g) {
+		$coded = sprintf("^%c", unpack('C', $2) + 64);
+		$res .= $1 . $coded;
+	}
+	$res =~ s/$/\$/;
 
-	return $vet;
+	return $res;
 }
 
 my @report = ();
@@ -310,8 +344,17 @@ sub process {
 	my $first_line = 0;
 
 	my $Ident	= qr{[A-Za-z\d_]+};
-	my $Storage	= qr{extern|static};
-	my $Sparse	= qr{__user|__kernel|__force|__iomem|__must_check|__init_refok};
+	my $Storage	= qr{extern|static|asmlinkage};
+	my $Sparse	= qr{
+				__user|
+				__kernel|
+				__force|
+				__iomem|
+				__must_check|
+				__init_refok|
+				fastcall
+			}x;
+	my $Inline	= qr{inline|__always_inline|noinline};
 	my $NonptrType	= qr{
 				\b
 				(?:const\s+)?
@@ -345,11 +388,18 @@ sub process {
 				(?:\s+$Sparse)*
 			  }x;
 	my $Declare	= qr{(?:$Storage\s+)?$Type};
-	my $Attribute	= qr{const|__read_mostly|__init|__initdata|__meminit};
-
+	my $Attribute	= qr{
+				const|
+				__read_mostly|
+				__(?:mem|cpu|dev|)(?:initdata|init)
+			  }x;
 	my $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 	my $Lval	= qr{$Ident(?:$Member)*};
 
+	# Possible bare types.
+	my @bare = ();
+	my $Bare = $NonptrType;
+
 	# Pre-scan the patch looking for any __setup documentation.
 	my @setup_docs = ();
 	my $setup_docs = 0;
@@ -477,7 +527,11 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #trailing whitespace
-		if ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
+		if ($line =~ /^\+.*\015/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("DOS line endings\n" . $herevet);
+
+		} elsif ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n";
 			ERROR("trailing whitespace\n" . $herevet);
 		}
@@ -509,6 +563,30 @@ sub process {
 # Standardise the strings and chars within the input to simplify matching.
 		$line = sanitise_line($line);
 
+# Check for potential 'bare' types
+		if ($realcnt &&
+		    $line !~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?$Type\b/ &&
+		    $line !~ /$Ident:\s*$/ &&
+		    $line !~ /^.\s*$Ident\s*\(/ &&
+		    ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?($Ident)\b/ ||
+		     $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/)) {
+			my $possible = $1;
+			if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
+			    $possible ne 'goto' && $possible ne 'return' &&
+			    $possible ne 'struct' && $possible ne 'enum' &&
+			    $possible ne 'case' && $possible ne 'else' &&
+			    $possible ne 'typedef') {
+				#print "POSSIBLE<$possible>\n";
+				push(@bare, $possible);
+				my $bare = join("|", @bare);
+				$Bare	= qr{
+						\b(?:$bare)\b
+						(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+						(?:\s+$Sparse)*
+					  }x;
+			}
+		}
+
 #
 # Checks which may be anchored in the context.
 #
@@ -531,18 +609,19 @@ sub process {
 				}
 			}
 			if ($err ne '') {
-				ERROR("switch and case should be at the same indent\n$hereline\n$err\n");
+				ERROR("switch and case should be at the same indent\n$hereline$err");
 			}
 		}
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
 		if ($line =~ /\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
-			my @ctx = ctx_statement($linenr, $realcnt, 0);
+			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
 			my $ctx_ln = $linenr + $#ctx + 1;
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
 
+			# Skip over any removed lines in the context following statement.
 			while ($ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^-/) {
 				$ctx_ln++;
 				$ctx_cnt--;
@@ -553,6 +632,13 @@ sub process {
 				ERROR("That open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$lines[$ctx_ln - 1]");
 			}
+			if ($level == 0 && $ctx =~ /\)\s*\;\s*$/ && defined $lines[$ctx_ln - 1]) {
+				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
+				if ($nindent > $indent) {
+					WARN("Trailing semicolon indicates no statements, indent implies otherwise\n" .
+						"$here\n$ctx\n$lines[$ctx_ln - 1]");
+				}
+			}
 		}
 
 #ignore lines not being added
@@ -619,7 +705,7 @@ sub process {
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
-		    $line !~ /\btypedef\s+$Type\s+\(\s*\*$Ident\s*\)\s*\(/ &&
+		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("do not add new typedefs\n" . $herecurr);
 		}
@@ -633,11 +719,11 @@ sub process {
 			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+$Attribute)?\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+$Attribute)\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 		}
@@ -693,7 +779,13 @@ sub process {
 		$opline = expand_tabs($opline);
 		$opline =~ s/^./ /;
 		if (!($line=~/\#\s*include/)) {
-			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|=>|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
+			my $ops = qr{
+				<<=|>>=|<=|>=|==|!=|
+				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
+				=>|->|<<|>>|<|>|=|!|~|
+				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/
+			}x;
+			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
 			for (my $n = 0; $n < $#elements; $n += 2) {
 				$off += length($elements[$n]);
@@ -733,7 +825,60 @@ sub process {
 				my $ptr = (" " x $off) . "^";
 				my $hereptr = "$hereline$ptr\n";
 
-				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
+				# Classify operators into binary, unary, or
+				# definitions (* only) where they have more
+				# than one mode.
+				my $unary_ctx = $prevline . $ca;
+				$unary_ctx =~ s/^./ /;
+				my $is_unary = 0;
+				my $Unary = qr{
+					(?:
+						^|;|,|$ops|\(|\?|:|
+						\(\s*$Type\s*\)|
+						$Type|
+						return|case|else|
+						\{|\}|
+						\[|
+						^.\#\s*define\s+$Ident\s*(?:\([^\)]*\))?|
+						^.\#\s*else|
+						^.\#\s*endif|
+						^.\#\s*(?:if|ifndef|ifdef)\b.*
+					)\s*(?:|\\)\s*$
+				}x;
+				my $UnaryFalse = qr{
+					sizeof\s*\(\s*$Type\s*\)\s*$
+				}x;
+				my $UnaryDefine = qr{
+					 (?:$Type|$Bare)\s*|
+					 (?:$Type|$Bare).*,\s*\**
+				}x;
+				if ($op eq '-' || $op eq '&' || $op eq '*') {
+					# An operator is binary if the left hand
+					# side is a value.  Pick out the known
+					# non-values.
+					if ($unary_ctx =~ /$Unary$/s &&
+					    $unary_ctx !~ /$UnaryFalse$/s) {
+						$is_unary = 1;
+
+					# Special handling for ')' check if this
+					# brace represents a conditional, if so
+					# we are unary.
+					} elsif ($unary_ctx =~ /\)\s*$/) {
+						my $before = ctx_expr_before($unary_ctx);
+						if ($before =~ /(?:for|if|while)\s*$/) {
+							$is_unary = 1;
+						}
+					}
+
+					# Check for type definition for of '*'.
+					if ($op eq '*' && $unary_ctx =~ /$UnaryDefine$/) {
+						$is_unary = 2;
+					}
+				}
+
+				#if ($op eq '-' || $op eq '&' || $op eq '*') {
+				#	print "UNARY: <$is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
+				#}
 
 				# ; should have either the end of line or a space or \ after it
 				if ($op eq ';') {
@@ -757,9 +902,16 @@ sub process {
 						ERROR("need space after that '$op' $at\n" . $hereptr);
 					}
 
-				# unary ! and unary ~ are allowed no space on the right
-				} elsif ($op eq '!' or $op eq '~') {
-					if ($ctx !~ /[WOEB]x./) {
+				# '*' as part of a type definition -- reported already.
+				} elsif ($op eq '*' && $is_unary == 2) {
+					#warn "'*' is part of type\n";
+
+				# unary operators should have a space before and
+				# none after.  May be left adjacent to another
+				# unary operator, or a cast
+				} elsif ($op eq '!' || $op eq '~' ||
+				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
+					if ($ctx !~ /[WEB]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("need space before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /.xW/) {
@@ -775,39 +927,13 @@ sub process {
 						ERROR("no space before that '$op' $at\n" . $hereptr);
 					}
 
-				# & is both unary and binary
-				# unary:
-				# 	a &b
-				# binary (consistent spacing):
-				#	a&b		OK
-				#	a & b		OK
-				#
-				# boiling down to: if there is a space on the right then there
-				# should be one on the left.
-				#
-				# - is the same
-				#
-				} elsif ($op eq '&' or $op eq '-') {
-					if ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]/) {
-						ERROR("need space before that '$op' $at\n" . $hereptr);
-					}
-
-				# * is the same as & only adding:
-				# type:
-				# 	(foo *)
-				#	(foo **)
-				#
-				} elsif ($op eq '*') {
-					if ($ca !~ /$Type$/ && $cb !~ /(\*$;|$;\*)/ &&
-					    $ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]|OxV|WxB|BxB/) {
-						ERROR("need space before that '$op' $at\n" . $hereptr);
-					}
-
 				# << and >> may either have or not have spaces both sides
-				} elsif ($op eq '<<' or $op eq '>>' or $op eq '+' or $op eq '/' or
-					 $op eq '^' or $op eq '|')
+				} elsif ($op eq '<<' or $op eq '>>' or
+					 $op eq '&' or $op eq '^' or $op eq '|' or
+					 $op eq '+' or $op eq '-' or
+					 $op eq '*' or $op eq '/')
 				{
-					if ($ctx !~ /VxV|WxW|VxE|WxE/) {
+					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
@@ -865,10 +991,12 @@ sub process {
 		}
 
 # check spacing on paretheses
-		if ($line =~ /\(\s/ && $line !~ /\(\s*$/) {
+		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
+		    $line !~ /for\s*\(\s+;/) {
 			ERROR("no space after that open parenthesis '('\n" . $herecurr);
 		}
-		if ($line =~ /\s\)/) {
+		if ($line =~ /\s\)/ && $line !~ /^.\s*\)/ &&
+		    $line !~ /for\s*\(.*;\s+\)/) {
 			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
 		}
 
@@ -926,10 +1054,10 @@ sub process {
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known goot container
-		if (($prevline=~/\#define.*\\/) and
-		   !($prevline=~/do\s+{/) and !($prevline=~/\(\{/) and
-		   !($line=~/do.*{/) and !($line=~/\(\{/) and
-		   !($line=~/^.\s*$Declare\s/)) {
+		if ($prevline =~ /\#define.*\\/ &&
+		   $prevline !~/(?:do\s+{|\(\{|\{)/ &&
+		   $line !~ /(?:do\s+{|\(\{|\{)/ &&
+		   $line !~ /^.\s*$Declare\s/) {
 			# Grab the first statement, if that is the entire macro
 			# its ok.  This may start either on the #define line
 			# or the one below.
@@ -1027,6 +1155,11 @@ sub process {
 			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
+# SPIN_LOCK_UNLOCKED & RW_LOCK_UNLOCKED are deprecated
+		if ($line =~ /\b(SPIN_LOCK_UNLOCKED|RW_LOCK_UNLOCKED)/) {
+			ERROR("Use of $1 is deprecated: see Documentation/spinlocks.txt\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.#\s*if\s+0\b/) {
 			CHK("if this code is redundant consider removing it\n" .
@@ -1073,8 +1206,8 @@ sub process {
 
 # check the location of the inline attribute, that it is between
 # storage class and type.
-		if ($line =~ /$Type\s+(?:inline|__always_inline|noinline)\b/ ||
-		    $line =~ /\b(?:inline|__always_inline|noinline)\s+$Storage/) {
+		if ($line =~ /\b$Type\s+$Inline\b/ ||
+		    $line =~ /\b$Inline\s+$Storage\b/) {
 			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
 		}
 
@@ -1091,6 +1224,11 @@ sub process {
 				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
 			}
 		}
+
+# check for pointless casting of kmalloc return
+		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
+			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
+		}
 	}
 
 	if ($chk_patch && !$is_patch) {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
update-checkpatchpl-to-version-011.patch
page-owner-tracking-leak-detector.patch
