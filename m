From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-019.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:15 -0700
Message-ID: <200806081947.m58JlFQD017405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbYFHTra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.19
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-019.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update checkpatch.pl to version 0.19
From: Andy Whitcroft <apw@shadowen.org>

This version is a bit of a whopper.  This version brings a few new checks,
improvements to a number of checks mostly through modifications to the
way types are parsed, several fixes to quote/comment handling, as well as
the usual slew of fixes for false positives.

Of note:
 - return is not a function and is now reported,
 - preprocessor directive detection is loosened to match C99 standard,
 - we now intuit new type modifiers, and
 - comment handling is much improved

Andy Whitcroft (18):
      Version: 0.19
      fix up a couple of missing newlines in reports
      colon to parenthesis spacing varies on asm
      values: #include is a preprocessor statement
      quotes: fix single character quotes at line end
      add typedef exception for the non-pointer "function types"
      kerneldoc parameters must be on one line, relax line length
      types: word boundary is not always required
      improved #define bracketing reports
      uninitialized_var is an annotation not a function name
      possible types: add possible modifier handling
      possible types: fastcall is a type modifier
      types: unsigned is not a modifier on all types
      static/external initialisation to zero should allow modifiers
      checkpatch: fix recognition of preprocessor directives -- part 2
      comments: fix inter-hunk comment tracking
      return is not a function
      do not report include/asm/foo.h use in include/linux/foo.h
      return is not a function -- tighten test

[jengelh@computergmbh.de: fix recognition of preprocessor directives]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  284 +++++++++++++++++++++++++---------------
 1 file changed, 182 insertions(+), 102 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-019 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-019
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.18';
+my $V = '0.19';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -115,6 +115,7 @@ our $Attribute	= qr{
 			__kprobes|
 			__(?:mem|cpu|dev|)(?:initdata|init)
 		  }x;
+our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
@@ -144,17 +145,17 @@ our $UTF8	= qr {
 
 our @typeList = (
 	qr{void},
-	qr{char},
-	qr{short},
-	qr{int},
-	qr{long},
+	qr{(?:unsigned\s+)?char},
+	qr{(?:unsigned\s+)?short},
+	qr{(?:unsigned\s+)?int},
+	qr{(?:unsigned\s+)?long},
+	qr{(?:unsigned\s+)?long\s+int},
+	qr{(?:unsigned\s+)?long\s+long},
+	qr{(?:unsigned\s+)?long\s+long\s+int},
 	qr{unsigned},
 	qr{float},
 	qr{double},
 	qr{bool},
-	qr{long\s+int},
-	qr{long\s+long},
-	qr{long\s+long\s+int},
 	qr{(?:__)?(?:u|s|be|le)(?:8|16|32|64)},
 	qr{struct\s+$Ident},
 	qr{union\s+$Ident},
@@ -163,26 +164,29 @@ our @typeList = (
 	qr{${Ident}_handler},
 	qr{${Ident}_handler_fn},
 );
+our @modifierList = (
+	qr{fastcall},
+);
 
 sub build_types {
+	my $mods = "(?:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?:  \n" . join("|\n  ", @typeList) . "\n)";
 	$NonptrType	= qr{
-			\b
 			(?:const\s+)?
-			(?:unsigned\s+)?
+			(?:$mods\s+)?
 			(?:
-				$all|
-				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)
+				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
+				(?:${all}\b)
 			)
 			(?:\s+$Sparse|\s+const)*
-			\b
 		  }x;
 	$Type	= qr{
-			\b$NonptrType\b
+			$NonptrType
 			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-			(?:\s+$Inline|\s+$Sparse|\s+$Attribute)*
+			(?:\s+$Inline|\s+$Sparse|\s+$Attribute|\s+$mods)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
+	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 }
 build_types();
 
@@ -329,7 +333,7 @@ sub sanitise_line {
 			$off++;
 			next;
 		}
-		if (substr($line, $off, 2) eq $sanitise_quote) {
+		if (substr($line, $off, 2) eq '*/') {
 			$sanitise_quote = '';
 			substr($res, $off, 2, "$;$;");
 			$off++;
@@ -366,14 +370,14 @@ sub sanitise_line {
 	}
 
 	# The pathname on a #include may be surrounded by '<' and '>'.
-	if ($res =~ /^.#\s*include\s+\<(.*)\>/) {
+	if ($res =~ /^.\s*\#\s*include\s+\<(.*)\>/) {
 		my $clean = 'X' x length($1);
 		$res =~ s@\<.*\>@<$clean>@;
 
 	# The whole of a #error is a string.
-	} elsif ($res =~ /^.#\s*(?:error|warning)\s+(.*)\b/) {
+	} elsif ($res =~ /^.\s*\#\s*(?:error|warning)\s+(.*)\b/) {
 		my $clean = 'X' x length($1);
-		$res =~ s@(#\s*(?:error|warning)\s+).*@$1$clean@;
+		$res =~ s@(\#\s*(?:error|warning)\s+).*@$1$clean@;
 	}
 
 	return $res;
@@ -715,7 +719,7 @@ sub annotate_values {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
-		} elsif ($cur =~ /^(#\s*define\s*$Ident)(\(?)/o) {
+		} elsif ($cur =~ /^(\#\s*define\s*$Ident)(\(?)/o) {
 			print "DEFINE($1,$2)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
 			push(@av_paren_type, $type);
@@ -724,12 +728,12 @@ sub annotate_values {
 			}
 			$type = 'E';
 
-		} elsif ($cur =~ /^(#\s*undef\s*$Ident)/o) {
+		} elsif ($cur =~ /^(\#\s*(?:undef\s*$Ident|include\b))/o) {
 			print "UNDEF($1)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
 			push(@av_paren_type, $type);
 
-		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if))/o) {
+		} elsif ($cur =~ /^(\#\s*(?:ifdef|ifndef|if))/o) {
 			print "PRE_START($1)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
 
@@ -737,7 +741,7 @@ sub annotate_values {
 			push(@av_paren_type, $type);
 			$type = 'E';
 
-		} elsif ($cur =~ /^(#\s*(?:else|elif))/o) {
+		} elsif ($cur =~ /^(\#\s*(?:else|elif))/o) {
 			print "PRE_RESTART($1)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
 
@@ -745,7 +749,7 @@ sub annotate_values {
 
 			$type = 'E';
 
-		} elsif ($cur =~ /^(#\s*(?:endif))/o) {
+		} elsif ($cur =~ /^(\#\s*(?:endif))/o) {
 			print "PRE_END($1)\n" if ($dbg_values > 1);
 
 			$av_preprocessor = 1;
@@ -837,14 +841,26 @@ sub annotate_values {
 sub possible {
 	my ($possible, $line) = @_;
 
-	#print "CHECK<$possible>\n";
+	print "CHECK<$possible> ($line)\n" if ($dbg_possible > 1);
 	if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
 	    $possible ne 'goto' && $possible ne 'return' &&
-	    $possible ne 'struct' && $possible ne 'enum' &&
 	    $possible ne 'case' && $possible ne 'else' &&
-	    $possible ne 'typedef') {
-		warn "POSSIBLE: $possible ($line)\n" if ($dbg_possible);
-		push(@typeList, $possible);
+	    $possible ne 'asm' &&
+	    $possible !~ /^(typedef|struct|enum)\b/) {
+		# Check for modifiers.
+		$possible =~ s/\s*$Storage\s*//g;
+		$possible =~ s/\s*$Sparse\s*//g;
+		if ($possible =~ /^\s*$/) {
+
+		} elsif ($possible =~ /\s/) {
+			$possible =~ s/\s*$Type\s*//g;
+			warn "MODIFIER: $possible ($line)\n" if ($dbg_possible);
+			push(@modifierList, $possible);
+
+		} else {
+			warn "POSSIBLE: $possible ($line)\n" if ($dbg_possible);
+			push(@typeList, $possible);
+		}
 		build_types();
 	}
 }
@@ -949,6 +965,7 @@ sub process {
 			} else {
 				$realcnt=1+1;
 			}
+			$in_comment = 0;
 
 			# Guestimate if this is a continuing comment.  Run
 			# the context looking for a comment "edge".  If this
@@ -1117,7 +1134,9 @@ sub process {
 			ERROR("trailing whitespace\n" . $herevet);
 		}
 #80 column limit
-		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length > 80) {
+		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
+		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ && $length > 80)
+		{
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
@@ -1159,18 +1178,20 @@ sub process {
 			# Ignore functions being called
 			} elsif ($s =~ /^.\s*$Ident\s*\(/s) {
 
+			# declarations always start with types
+			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))\s*(?:;|=|,|\()/s) {
+				my $type = $1;
+				$type =~ s/\s+/ /g;
+				possible($type, "A:" . $s);
+
 			# definitions in global scope can only start with types
 			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/s) {
-				possible($1, $s);
-
-			# declarations always start with types
-			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=|,)/s) {
-				possible($1, $s);
+				possible($1, "B:" . $s);
 			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
 			while ($s =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/sg) {
-				possible($1, $s);
+				possible($1, "C:" . $s);
 			}
 
 			# Check for any sort of function declaration.
@@ -1184,9 +1205,9 @@ sub process {
 				$ctx =~ s/\)[^\)]*$//;
 
 				for my $arg (split(/\s*,\s*/, $ctx)) {
-					if ($arg =~ /^(?:const\s+)?($Ident)(?:\s+$Sparse)*\s*\**\s*(:?\b$Ident)?$/ || $arg =~ /^($Ident)$/) {
+					if ($arg =~ /^(?:const\s+)?($Ident)(?:\s+$Sparse)*\s*\**\s*(:?\b$Ident)?$/s || $arg =~ /^($Ident)$/s) {
 
-						possible($1, $s);
+						possible($1, "D:" . $s);
 					}
 				}
 			}
@@ -1221,7 +1242,7 @@ sub process {
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
-		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
+		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {
 			my $pre_ctx = "$1$2";
 
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
@@ -1239,7 +1260,7 @@ sub process {
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
-					"$here\n$ctx\n$lines[$ctx_ln - 1]");
+					"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
 			}
 			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
 			    $ctx =~ /\)\s*\;\s*$/ &&
@@ -1248,7 +1269,7 @@ sub process {
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
 					WARN("trailing semicolon indicates no statements, indent implies otherwise\n" .
-						"$here\n$ctx\n$lines[$ctx_ln - 1]");
+						"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
 				}
 			}
 		}
@@ -1284,7 +1305,7 @@ sub process {
 #
 
 # check for malformed paths in #include statements (uses RAW line)
-		if ($rawline =~ m{^.#\s*include\s+[<"](.*)[">]}) {
+		if ($rawline =~ m{^.\s*\#\s*include\s+[<"](.*)[">]}) {
 			my $path = $1;
 			if ($path =~ m{//}) {
 				ERROR("malformed #include filename\n" .
@@ -1316,7 +1337,7 @@ sub process {
 		}
 
 # check for external initialisers.
-		if ($line =~ /^.$Type\s*$Ident\s*=\s*(0|NULL|false)\s*;/) {
+		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise externals to 0 or NULL\n" .
 				$herecurr);
 		}
@@ -1330,6 +1351,7 @@ sub process {
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
 		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
+		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("do not add new typedefs\n" . $herecurr);
 		}
@@ -1388,8 +1410,8 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).*\s{/) and
-		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
+		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
+		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
@@ -1416,10 +1438,10 @@ sub process {
 			# cpp #define statements have non-optional spaces, ie
 			# if there is a space between the name and the open
 			# parenthesis it is simply not a parameter group.
-			} elsif ($ctx_before =~ /^.\#\s*define\s*$/) {
+			} elsif ($ctx_before =~ /^.\s*\#\s*define\s*$/) {
 
 			# cpp #elif statement condition may start with a (
-			} elsif ($ctx =~ /^.\#\s*elif\s*$/) {
+			} elsif ($ctx =~ /^.\s*\#\s*elif\s*$/) {
 
 			# If this whole things ends with a type its most
 			# likely a typedef for a function.
@@ -1625,13 +1647,14 @@ sub process {
 			ERROR("space prohibited before that close square bracket ']'\n" . $herecurr);
 		}
 
-# check spacing on paretheses
+# check spacing on parentheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
 			ERROR("space prohibited after that open parenthesis '('\n" . $herecurr);
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
-		    $line !~ /for\s*\(.*;\s+\)/) {
+		    $line !~ /for\s*\(.*;\s+\)/ &&
+		    $line !~ /:\s+\)/) {
 			ERROR("space prohibited before that close parenthesis ')'\n" . $herecurr);
 		}
 
@@ -1641,6 +1664,23 @@ sub process {
 			WARN("labels should not be indented\n" . $herecurr);
 		}
 
+# Return is not a function.
+		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*);/s) {
+			my $spacing = $1;
+			my $value = $2;
+
+			# Flatten any parentheses and braces
+			while ($value =~ s/\([^\(\)]*\)/1/) {
+			}
+
+			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
+				ERROR("return is not a function, parentheses are not required\n" . $herecurr);
+
+			} elsif ($spacing !~ /\s+/) {
+				ERROR("space required before the open parenthesis '('\n" . $herecurr);
+			}
+		}
+
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
 			ERROR("space required before the open parenthesis '('\n" . $herecurr);
@@ -1660,7 +1700,7 @@ sub process {
 			$s =~ s/\n.*//g;
 			$s =~ s/$;//g; 	# Remove any comments
 			if (length($c) && $s !~ /^\s*({|;|)\s*\\*\s*$/ &&
-			    $c !~ /^.\#\s*if/)
+			    $c !~ /^.\s*\#\s*if/)
 			{
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
@@ -1719,14 +1759,16 @@ sub process {
 #		}
 
 #no spaces allowed after \ in define
-		if ($line=~/\#define.*\\\s$/) {
+		if ($line=~/\#\s*define.*\\\s$/) {
 			WARN("Whitepspace after \\ makes next lines useless\n" . $herecurr);
 		}
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
-		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
-			my $checkfile = "$root/include/linux/$1.h";
-			if (-f $checkfile && $1 ne 'irq') {
+		if ($tree && $rawline =~ m{^.\s*\#\s*include\s*\<asm\/(.*)\.h\>}) {
+			my $checkfile = "include/linux/$1.h";
+			if (-f "$root/$checkfile" && $realfile ne $checkfile &&
+			    $1 ne 'irq')
+			{
 				WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
 					$herecurr);
 			}
@@ -1735,45 +1777,87 @@ sub process {
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known good container
-		if ($prevline =~ /\#define.*\\/ &&
-		   $prevline !~/(?:do\s+{|\(\{|\{)/ &&
-		   $line !~ /(?:do\s+{|\(\{|\{)/ &&
-		   $line !~ /^.\s*$Declare\s/) {
-			# Grab the first statement, if that is the entire macro
-			# its ok.  This may start either on the #define line
-			# or the one below.
+		if ($line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
 			my $ln = $linenr;
 			my $cnt = $realcnt;
-			my $off = 0;
+			my ($off, $dstat, $dcond, $rest);
+			my $ctx = '';
 
-			# If the macro starts on the define line start
-			# grabbing the statement after the identifier
-			$prevline =~ m{^(.#\s*define\s*$Ident(?:\([^\)]*\))?\s*)(.*)\\\s*$};
-			##print "1<$1> 2<$2>\n";
-			if (defined $2 && $2 ne '') {
-				$off = length($1);
-				$ln--;
-				$cnt++;
-				while ($lines[$ln - 1] =~ /^-/) {
-					$ln--;
-					$cnt++;
-				}
+			my $args = defined($1);
+
+			# Find the end of the macro and limit our statement
+			# search to that.
+			while ($cnt > 0 && defined $lines[$ln - 1] &&
+				$lines[$ln - 1] =~ /^(?:-|..*\\$)/)
+			{
+				$ctx .= $rawlines[$ln - 1] . "\n";
+				$ln++;
+				$cnt--;
+			}
+			$ctx .= $rawlines[$ln - 1];
+
+			($dstat, $dcond, $ln, $cnt, $off) =
+				ctx_statement_block($linenr, $ln - $linenr + 1, 0);
+			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
+			#print "LINE<$lines[$ln]> len<" . length($lines[$ln]) . "\n";
+
+			# Extract the remainder of the define (if any) and
+			# rip off surrounding spaces, and trailing \'s.
+			$rest = '';
+			if (defined $lines[$ln - 1] &&
+			    $off > length($lines[$ln - 1]))
+			{
+				$ln++;
+				$cnt--;
+				$off = 0;
+			}
+			while ($cnt > 0) {
+				$rest .= substr($lines[$ln - 1], $off) . "\n";
+				$ln++;
+				$cnt--;
+				$off = 0;
+			}
+			$rest =~ s/\\\n.//g;
+			$rest =~ s/^\s*//s;
+			$rest =~ s/\s*$//s;
+
+			# Clean up the original statement.
+			if ($args) {
+				substr($dstat, 0, length($dcond), '');
+			} else {
+				$dstat =~ s/^.\s*\#\s*define\s+$Ident\s*//;
 			}
-			my @ctx = ctx_statement($ln, $cnt, $off);
-			my $ctx_ln = $ln + $#ctx + 1;
-			my $ctx = join("\n", @ctx);
+			$dstat =~ s/\\\n.//g;
+			$dstat =~ s/^\s*//s;
+			$dstat =~ s/\s*$//s;
 
-			# Pull in any empty extension lines.
-			while ($ctx =~ /\\$/ &&
-			       $lines[$ctx_ln - 1] =~ /^.\s*(?:\\)?$/) {
-				$ctx .= $lines[$ctx_ln - 1];
-				$ctx_ln++;
+			# Flatten any parentheses and braces
+			while ($dstat =~ s/\([^\(\)]*\)/1/) {
+			}
+			while ($dstat =~ s/\{[^\{\}]*\}/1/) {
 			}
 
-			if ($ctx =~ /\\$/) {
-				if ($ctx =~ /;/) {
+			my $exceptions = qr{
+				$Declare|
+				module_param_named|
+				MODULE_PARAM_DESC|
+				DECLARE_PER_CPU|
+				DEFINE_PER_CPU|
+				__typeof__\(
+			}x;
+			if ($rest ne '') {
+				if ($rest !~ /while\s*\(/ &&
+				    $dstat !~ /$exceptions/)
+				{
 					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
-				} else {
+				}
+
+			} elsif ($ctx !~ /;/) {
+				if ($dstat ne '' &&
+				    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&
+				    $dstat !~ /$exceptions/ &&
+				    $dstat =~ /$Operators/)
+				{
 					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
 				}
 			}
@@ -1884,7 +1968,7 @@ sub process {
 
 # don't include deprecated include files (uses RAW line)
 		for my $inc (@dep_includes) {
-			if ($rawline =~ m@\#\s*include\s*\<$inc>@) {
+			if ($rawline =~ m@^.\s*\#\s*include\s*\<$inc>@) {
 				ERROR("Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
 			}
 		}
@@ -1908,7 +1992,7 @@ sub process {
 		}
 
 # warn about #if 0
-		if ($line =~ /^.#\s*if\s+0\b/) {
+		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("if this code is redundant consider removing it\n" .
 				$herecurr);
 		}
@@ -1920,23 +2004,16 @@ sub process {
 				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
 			}
 		}
-# check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
-				WARN("usb_free_urb(NULL) is safe this check is probabally not required\n" . $hereprev);
-			}
-		}
 
 # warn about #ifdefs in C files
-#		if ($line =~ /^.#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
+#		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
 #			print "$herecurr";
 #			$clean = 0;
 #		}
 
 # warn about spacing in #ifdefs
-		if ($line =~ /^.#\s*(ifdef|ifndef|elif)\s\s+/) {
+		if ($line =~ /^.\s*\#\s*(ifdef|ifndef|elif)\s\s+/) {
 			ERROR("exactly one space required after that #$1\n" . $herecurr);
 		}
 
@@ -1955,7 +2032,7 @@ sub process {
 			}
 		}
 # check of hardware specific defines
-		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
+		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
@@ -1973,15 +2050,18 @@ sub process {
 
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
-		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+$Ident(\s*)\(/s)
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
 		{
-			my $paren_space = $1;
+			my $function_name = $1;
+			my $paren_space = $2;
 
 			my $s = $stat;
 			if (defined $cond) {
 				substr($s, 0, length($cond), '');
 			}
-			if ($s =~ /^\s*;/) {
+			if ($s =~ /^\s*;/ &&
+			    $function_name ne 'uninitialized_var')
+			{
 				WARN("externs should be avoided in .c files\n" .  $herecurr);
 			}
 
@@ -2030,8 +2110,8 @@ sub process {
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
 		if ($line =~ /\bNR_CPUS\b/ &&
-		    $line !~ /^.#\s*if\b.*\bNR_CPUS\b/ &&
-		    $line !~ /^.#\s*define\b.*\bNR_CPUS\b/ &&
+		    $line !~ /^.\s*\s*#\s*if\b.*\bNR_CPUS\b/ &&
+		    $line !~ /^.\s*\s*#\s*define\b.*\bNR_CPUS\b/ &&
 		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/ &&
 		    $line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
 		    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

