From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-011.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:46 -0700
Message-ID: <200710190341.l9J3fkiP012846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934609AbXJSD4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.11
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-011.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update checkpatch.pl to version 0.11
From: Andy Whitcroft <apw@shadowen.org>

This version brings a more cautious checkpatch.pl by default.  The more
subjective checks are only applied with the --strict option.  It also
brings the usual slew of corrections for false positives.  Of note:

  - new tree detection, the source tree will be found via the executable
  - a major revamp of the unary detection to make it more parser like
  - a new summary at the bottom of the report
  - --strict option for subjective checks
  - --file to enable checking on complete files
  - support for use in emacs "compile" window

Andy Whitcroft (27):
      Version: 0.11
      fix up cat_vet for the case where there are no control characters
      any cast to a pointer introduces a type
      cpp unary operator detection needs to float
      attributes are also valid in type definitions
      sizeof may be a bareword and makes its argument unary
      unary checks for #ifdef et al need to find end of line
      add new --file mode to handle raw source files
      add --strict/--subjective which enables the subjective tests
      add some additional standard type suffixes
      cpp #elif is also a unary prefix
      case is not a function name
      widen asm volatile exceptions
      __kprobes is a type attribute
      typeof is a unary operator
      function open parenthesis checks should check all occurances
      expand sizeof() binary exceptions
      linux/irq.h should not be recommended
      work harder to find the kernel root and add --root=
      fix --emacs mode line numbers and string concatenation warnings
      add a summary to the bottom of the main report
      loosen assignment in if checks
      update operator spacing to maintain tabs in output
      revamp unary detection
      corruption/line wrapped patches need only reporting once
      revamp s/u/be/le 8/16/32/64 bit types
      handle missing ,1 in uni-diff header

Mike D. Day (2):
      Adds support to checkpatch.pl for running in the emacs compile window.
      checkpatch: Fix line number reporting

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  514 ++++++++++++++++++++++++++--------------
 1 file changed, 340 insertions(+), 174 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-011 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-011
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.10';
+my $V = '0.11';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -18,12 +18,21 @@ my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
 my $tst_type = 0;
+my $emacs = 0;
+my $file = 0;
+my $check = 0;
+my $root;
 GetOptions(
-	'q|quiet'	=> \$quiet,
+	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
 	'patch!'	=> \$chk_patch,
 	'test-type!'	=> \$tst_type,
+	'emacs!'	=> \$emacs,
+	'file!'		=> \$file,
+	'subjective!'	=> \$check,
+	'strict!'	=> \$check,
+	'root=s'	=> \$root,
 ) or exit;
 
 my $exit = 0;
@@ -33,19 +42,110 @@ if ($#ARGV < 0) {
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
+	print "         --emacs      => emacs compile window format\n";
+	print "         --file       => check a source file\n";
+	print "         --strict     => enable more subjective tests\n";
+	print "         --root       => path to the kernel tree root\n";
 	exit(1);
 }
 
-if ($tree && !top_of_kernel_tree()) {
-	print "Must be run from the top-level dir. of a kernel tree\n";
-	exit(2);
+if ($tree) {
+	if (defined $root) {
+		if (!top_of_kernel_tree($root)) {
+			die "$P: $root: --root does not point at a valid tree\n";
+		}
+	} else {
+		if (top_of_kernel_tree('.')) {
+			$root = '.';
+		} elsif ($0 =~ m@(.*)/scripts/[^/]*$@ &&
+						top_of_kernel_tree($1)) {
+			$root = $1;
+		}
+	}
+
+	if (!defined $root) {
+		print "Must be run from the top-level dir. of a kernel tree\n";
+		exit(2);
+	}
 }
 
+my $emitted_corrupt = 0;
+
+our $Ident       = qr{[A-Za-z_][A-Za-z\d_]*};
+our $Storage	= qr{extern|static|asmlinkage};
+our $Sparse	= qr{
+			__user|
+			__kernel|
+			__force|
+			__iomem|
+			__must_check|
+			__init_refok|
+			__kprobes|
+			fastcall
+		}x;
+our $Attribute	= qr{
+			const|
+			__read_mostly|
+			__kprobes|
+			__(?:mem|cpu|dev|)(?:initdata|init)
+		  }x;
+our $Inline	= qr{inline|__always_inline|noinline};
+our $NonptrType	= qr{
+			\b
+			(?:const\s+)?
+			(?:unsigned\s+)?
+			(?:
+				void|
+				char|
+				short|
+				int|
+				long|
+				unsigned|
+				float|
+				double|
+				bool|
+				long\s+int|
+				long\s+long|
+				long\s+long\s+int|
+				(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
+				struct\s+$Ident|
+				union\s+$Ident|
+				enum\s+$Ident|
+				${Ident}_t|
+				${Ident}_handler|
+				${Ident}_handler_fn
+			)
+			(?:\s+$Sparse)*
+			\b
+		  }x;
+
+our $Type	= qr{
+			\b$NonptrType\b
+			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+			(?:\s+$Sparse|\s+$Attribute)*
+		  }x;
+our $Declare	= qr{(?:$Storage\s+)?$Type};
+our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
+our $Lval	= qr{$Ident(?:$Member)*};
+
+our $Constant	= qr{(?:[0-9]+|0x[0-9a-fA-F]+)[UL]*};
+our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
+our $Operators	= qr{
+			<=|>=|==|!=|
+			=>|->|<<|>>|<|>|!|~|
+			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/
+		  }x;
+
+our $Bare = '';
+
+$chk_signoff = 0 if ($file);
+
 my @dep_includes = ();
 my @dep_functions = ();
-my $removal = 'Documentation/feature-removal-schedule.txt';
-if ($tree && -f $removal) {
-	open(REMOVE, "<$removal") || die "$P: $removal: open failed - $!\n";
+my $removal = "Documentation/feature-removal-schedule.txt";
+if ($tree && -f "$root/$removal") {
+	open(REMOVE, "<$root/$removal") ||
+				die "$P: $removal: open failed - $!\n";
 	while (<REMOVE>) {
 		if (/^Check:\s+(.*\S)/) {
 			for my $entry (split(/[, ]+/, $1)) {
@@ -61,28 +161,42 @@ if ($tree && -f $removal) {
 }
 
 my @rawlines = ();
-while (<>) {
-	chomp;
-	push(@rawlines, $_);
-	if (eof(ARGV)) {
-		if (!process($ARGV, @rawlines)) {
-			$exit = 1;
-		}
-		@rawlines = ();
+for my $filename (@ARGV) {
+	if ($file) {
+		open(FILE, "diff -u /dev/null $filename|") ||
+			die "$P: $filename: diff failed - $!\n";
+	} else {
+		open(FILE, "<$filename") ||
+			die "$P: $filename: open failed - $!\n";
+	}
+	while (<FILE>) {
+		chomp;
+		push(@rawlines, $_);
+	}
+	close(FILE);
+	if (!process($filename, @rawlines)) {
+		$exit = 1;
 	}
+	@rawlines = ();
 }
 
 exit($exit);
 
 sub top_of_kernel_tree {
-	if ((-f "COPYING") && (-f "CREDITS") && (-f "Kbuild") &&
-	    (-f "MAINTAINERS") && (-f "Makefile") && (-f "README") &&
-	    (-d "Documentation") && (-d "arch") && (-d "include") &&
-	    (-d "drivers") && (-d "fs") && (-d "init") && (-d "ipc") &&
-	    (-d "kernel") && (-d "lib") && (-d "scripts")) {
-		return 1;
+	my ($root) = @_;
+
+	my @tree_check = (
+		"COPYING", "CREDITS", "Kbuild", "MAINTAINERS", "Makefile",
+		"README", "Documentation", "arch", "include", "drivers",
+		"fs", "init", "ipc", "kernel", "lib", "scripts",
+	);
+
+	foreach my $check (@tree_check) {
+		if (! -e $root . '/' . $check) {
+			return 0;
+		}
 	}
-	return 0;
+	return 1;
 }
 
 sub expand_tabs {
@@ -105,6 +219,20 @@ sub expand_tabs {
 
 	return $res;
 }
+sub copy_spacing {
+	my ($str) = @_;
+
+	my $res = '';
+	for my $c (split(//, $str)) {
+		if ($c eq "\t") {
+			$res .= $c;
+		} else {
+			$res .= ' ';
+		}
+	}
+
+	return $res;
+}
 
 sub line_stats {
 	my ($line) = @_;
@@ -260,47 +388,138 @@ sub ctx_has_comment {
 	return ($cmt ne '');
 }
 
-sub ctx_expr_before {
-	my ($line) = @_;
-
-	##print "CHECK<$line>\n";
-
-	my $pos = length($line) - 1;
-	my $count = 0;
-	my $c;
+sub cat_vet {
+	my ($vet) = @_;
+	my ($res, $coded);
 
-	for (; $pos >= 0; $pos--) {
-		$c = substr($line, $pos, 1);
-		##print "CHECK: c<$c> count<$count>\n";
-		if ($c eq ')') {
-			$count++;
-		} elsif ($c eq '(') {
-			last if (--$count == 0);
+	$res = '';
+	while ($vet =~ /([^[:cntrl:]]*)([[:cntrl:]]|$)/g) {
+		$res .= $1;
+		if ($2 ne '') {
+			$coded = sprintf("^%c", unpack('C', $2) + 64);
+			$res .= $coded;
 		}
 	}
+	$res =~ s/$/\$/;
 
-	##print "CHECK: result<" . substr($line, 0, $pos) . ">\n";
-
-	return substr($line, 0, $pos);
+	return $res;
 }
 
-sub cat_vet {
-	my ($vet) = @_;
-	my ($res, $coded);
+sub annotate_values {
+	my ($stream, $type) = @_;
 
-	$res = '';
-	while ($vet =~ /([^[:cntrl:]]*)([[:cntrl:]])/g) {
-		$coded = sprintf("^%c", unpack('C', $2) + 64);
-		$res .= $1 . $coded;
+	my $res;
+	my $cur = $stream;
+
+	my $debug = 0;
+
+	print "$stream\n" if ($debug);
+
+	##my $type = 'N';
+	my $pos = 0;
+	my $preprocessor = 0;
+	my $paren = 0;
+	my @paren_type;
+
+	# Include any user defined types we may have found as we went.
+	my $type_match = "(?:$Type$Bare)";
+
+	while (length($cur)) {
+		print " <$type> " if ($debug);
+		if ($cur =~ /^(\s+)/o) {
+			print "WS($1)\n" if ($debug);
+			if ($1 =~ /\n/ && $preprocessor) {
+				$preprocessor = 0;
+				$type = 'N';
+			}
+
+		} elsif ($cur =~ /^($type_match)/) {
+			print "DECLARE($1)\n" if ($debug);
+			$type = 'T';
+
+		} elsif ($cur =~ /^(#\s*define\s*$Ident)(\(?)/o) {
+			print "DEFINE($1)\n" if ($debug);
+			$preprocessor = 1;
+			$paren_type[$paren] = 'N';
+
+		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|endif))/o) {
+			print "PRE($1)\n" if ($debug);
+			$preprocessor = 1;
+			$type = 'N';
+
+		} elsif ($cur =~ /^(\\\n)/o) {
+			print "PRECONT($1)\n" if ($debug);
+
+		} elsif ($cur =~ /^(sizeof)\s*(\()?/o) {
+			print "SIZEOF($1)\n" if ($debug);
+			if (defined $2) {
+				$paren_type[$paren] = 'V';
+			}
+			$type = 'N';
+
+		} elsif ($cur =~ /^(if|while|typeof)\b/o) {
+			print "COND($1)\n" if ($debug);
+			$paren_type[$paren] = 'N';
+			$type = 'N';
+
+		} elsif ($cur =~/^(return|case|else)/o) {
+			print "KEYWORD($1)\n" if ($debug);
+			$type = 'N';
+
+		} elsif ($cur =~ /^(\()/o) {
+			print "PAREN('$1')\n" if ($debug);
+			$paren++;
+			$type = 'N';
+
+		} elsif ($cur =~ /^(\))/o) {
+			$paren-- if ($paren > 0);
+			if (defined $paren_type[$paren]) {
+				$type = $paren_type[$paren];
+				undef $paren_type[$paren];
+				print "PAREN('$1') -> $type\n" if ($debug);
+			} else {
+				print "PAREN('$1')\n" if ($debug);
+			}
+
+		} elsif ($cur =~ /^($Ident)\(/o) {
+			print "FUNC($1)\n" if ($debug);
+			$paren_type[$paren] = 'V';
+
+		} elsif ($cur =~ /^($Ident|$Constant)/o) {
+			print "IDENT($1)\n" if ($debug);
+			$type = 'V';
+
+		} elsif ($cur =~ /^($Assignment)/o) {
+			print "ASSIGN($1)\n" if ($debug);
+			$type = 'N';
+
+		} elsif ($cur =~ /^(;|{|}|\?|:|\[)/o) {
+			print "END($1)\n" if ($debug);
+			$type = 'N';
+
+		} elsif ($cur =~ /^($Operators)/o) {
+			print "OP($1)\n" if ($debug);
+			if ($1 ne '++' && $1 ne '--') {
+				$type = 'N';
+			}
+
+		} elsif ($cur =~ /(^.)/o) {
+			print "C($1)\n" if ($debug);
+		}
+		if (defined $1) {
+			$cur = substr($cur, length($1));
+			$res .= $type x length($1);
+		}
 	}
-	$res =~ s/$/\$/;
 
 	return $res;
 }
 
+my $prefix = '';
+
 my @report = ();
 sub report {
-	push(@report, $_[0]);
+	push(@report, $prefix . $_[0]);
 }
 sub report_dump {
 	@report;
@@ -308,14 +527,19 @@ sub report_dump {
 sub ERROR {
 	report("ERROR: $_[0]\n");
 	our $clean = 0;
+	our $cnt_error++;
 }
 sub WARN {
 	report("WARNING: $_[0]\n");
 	our $clean = 0;
+	our $cnt_warn++;
 }
 sub CHK {
-	report("CHECK: $_[0]\n");
-	our $clean = 0;
+	if ($check) {
+		report("CHECK: $_[0]\n");
+		our $clean = 0;
+		our $cnt_chk++;
+	}
 }
 
 sub process {
@@ -335,6 +559,11 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
+	our $cnt_lines = 0;
+	our $cnt_error = 0;
+	our $cnt_warn = 0;
+	our $cnt_chk = 0;
+
 	# Trace the real file/line as we go.
 	my $realfile = '';
 	my $realline = 0;
@@ -343,62 +572,10 @@ sub process {
 	my $in_comment = 0;
 	my $first_line = 0;
 
-	my $Ident	= qr{[A-Za-z\d_]+};
-	my $Storage	= qr{extern|static|asmlinkage};
-	my $Sparse	= qr{
-				__user|
-				__kernel|
-				__force|
-				__iomem|
-				__must_check|
-				__init_refok|
-				fastcall
-			}x;
-	my $Inline	= qr{inline|__always_inline|noinline};
-	my $NonptrType	= qr{
-				\b
-				(?:const\s+)?
-				(?:unsigned\s+)?
-				(?:
-					void|
-					char|
-					short|
-					int|
-					long|
-					unsigned|
-					float|
-					double|
-					bool|
-					long\s+int|
-					long\s+long|
-					long\s+long\s+int|
-					u8|u16|u32|u64|
-					s8|s16|s32|s64|
-					struct\s+$Ident|
-					union\s+$Ident|
-					enum\s+$Ident|
-					${Ident}_t
-				)
-				(?:\s+$Sparse)*
-				\b
-			  }x;
-	my $Type	= qr{
-				\b$NonptrType\b
-				(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-				(?:\s+$Sparse)*
-			  }x;
-	my $Declare	= qr{(?:$Storage\s+)?$Type};
-	my $Attribute	= qr{
-				const|
-				__read_mostly|
-				__(?:mem|cpu|dev|)(?:initdata|init)
-			  }x;
-	my $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
-	my $Lval	= qr{$Ident(?:$Member)*};
+	my $prev_values = 'N';
 
 	# Possible bare types.
 	my @bare = ();
-	my $Bare = $NonptrType;
 
 	# Pre-scan the patch looking for any __setup documentation.
 	my @setup_docs = ();
@@ -417,11 +594,14 @@ sub process {
 		}
 	}
 
+	$prefix = '';
+
 	foreach my $line (@lines) {
 		$linenr++;
 
 		my $rawline = $line;
 
+
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile=$1;
@@ -430,7 +610,7 @@ sub process {
 			next;
 		}
 #extract the line range in the file after the patch is applied
-		if ($line=~/^\@\@ -\d+,\d+ \+(\d+)(,(\d+))? \@\@/) {
+		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$is_patch = 1;
 			$first_line = $linenr + 1;
 			$in_comment = 0;
@@ -440,6 +620,7 @@ sub process {
 			} else {
 				$realcnt=1+1;
 			}
+			$prev_values = 'N';
 			next;
 		}
 
@@ -473,18 +654,24 @@ sub process {
 			# Track the previous line.
 			($prevline, $stashline) = ($stashline, $line);
 			($previndent, $stashindent) = ($stashindent, $indent);
+
 		} elsif ($realcnt == 1) {
 			$realcnt--;
 		}
 
 #make up the handle for any error we report on this line
-		$here = "#$linenr: ";
+		$here = "#$linenr: " if (!$file);
+		$here = "#$realline: " if ($file);
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
 		my $hereline = "$here\n$line\n";
 		my $herecurr = "$here\n$line\n";
 		my $hereprev = "$here\n$prevline\n$line\n";
 
+		$prefix = "$filename:$realline: " if ($emacs && $file);
+		$prefix = "$filename:$linenr: " if ($emacs && !$file);
+		$cnt_lines++ if ($realcnt != 0);
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
@@ -502,7 +689,7 @@ sub process {
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |$)}) {
 			ERROR("patch seems to be corrupt (line wrapped?)\n" .
-				$herecurr);
+				$herecurr) if (!$emitted_corrupt++);
 		}
 
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
@@ -568,8 +755,12 @@ sub process {
 		    $line !~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?$Type\b/ &&
 		    $line !~ /$Ident:\s*$/ &&
 		    $line !~ /^.\s*$Ident\s*\(/ &&
+		     # definitions in global scope can only start with types
 		    ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?($Ident)\b/ ||
-		     $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/)) {
+		     # declarations always start with types
+		     $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/) ||
+		     # any (foo ... *) is a pointer cast, and foo is a type
+		     $line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/) {
 			my $possible = $1;
 			if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
 			    $possible ne 'goto' && $possible ne 'return' &&
@@ -579,7 +770,7 @@ sub process {
 				#print "POSSIBLE<$possible>\n";
 				push(@bare, $possible);
 				my $bare = join("|", @bare);
-				$Bare	= qr{
+				$Bare	= '|' . qr{
 						\b(?:$bare)\b
 						(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
 						(?:\s+$Sparse)*
@@ -641,6 +832,14 @@ sub process {
 			}
 		}
 
+		# Track the 'values' across context and added lines.
+		my $opline = $line; $opline =~ s/^./ /;
+		my $curr_values = annotate_values($opline . "\n", $prev_values);
+		$curr_values = $prev_values . $curr_values;
+		#warn "--> $opline\n";
+		#warn "--> $curr_values ($prev_values)\n";
+		$prev_values = substr($curr_values, -1);
+
 #ignore lines not being added
 		if ($line=~/^[^\+]/) {next;}
 
@@ -678,6 +877,7 @@ sub process {
 		}
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
+		$opline =~ s@//.*@@;
 
 #EXPORT_SYMBOL should immediately follow its function closing }.
 		if (($line =~ /EXPORT_SYMBOL.*\((.*)\)/) ||
@@ -766,18 +966,13 @@ sub process {
 		}
 
 # check for spaces between functions and their parentheses.
-		if ($line =~ /($Ident)\s+\(/ &&
-		    $1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright)$/ &&
-		    $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
-			WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+		while ($line =~ /($Ident)\s+\(/g) {
+			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
+		            $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
+				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+			}
 		}
 # Check operator spacing.
-		# Note we expand the line with the leading + as the real
-		# line will be displayed with the leading + and the tabs
-		# will therefore also expand that way.
-		my $opline = $line;
-		$opline = expand_tabs($opline);
-		$opline =~ s/^./ /;
 		if (!($line=~/\#\s*include/)) {
 			my $ops = qr{
 				<<=|>>=|<=|>=|==|!=|
@@ -787,6 +982,9 @@ sub process {
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
+
+			my $blank = copy_spacing($opline);
+
 			for (my $n = 0; $n < $#elements; $n += 2) {
 				$off += length($elements[$n]);
 
@@ -822,62 +1020,24 @@ sub process {
 
 				my $at = "(ctx:$ctx)";
 
-				my $ptr = (" " x $off) . "^";
+				my $ptr = substr($blank, 0, $off) . "^";
 				my $hereptr = "$hereline$ptr\n";
 
 				# Classify operators into binary, unary, or
 				# definitions (* only) where they have more
 				# than one mode.
-				my $unary_ctx = $prevline . $ca;
-				$unary_ctx =~ s/^./ /;
-				my $is_unary = 0;
-				my $Unary = qr{
-					(?:
-						^|;|,|$ops|\(|\?|:|
-						\(\s*$Type\s*\)|
-						$Type|
-						return|case|else|
-						\{|\}|
-						\[|
-						^.\#\s*define\s+$Ident\s*(?:\([^\)]*\))?|
-						^.\#\s*else|
-						^.\#\s*endif|
-						^.\#\s*(?:if|ifndef|ifdef)\b.*
-					)\s*(?:|\\)\s*$
-				}x;
-				my $UnaryFalse = qr{
-					sizeof\s*\(\s*$Type\s*\)\s*$
-				}x;
-				my $UnaryDefine = qr{
-					 (?:$Type|$Bare)\s*|
-					 (?:$Type|$Bare).*,\s*\**
-				}x;
-				if ($op eq '-' || $op eq '&' || $op eq '*') {
-					# An operator is binary if the left hand
-					# side is a value.  Pick out the known
-					# non-values.
-					if ($unary_ctx =~ /$Unary$/s &&
-					    $unary_ctx !~ /$UnaryFalse$/s) {
-						$is_unary = 1;
-
-					# Special handling for ')' check if this
-					# brace represents a conditional, if so
-					# we are unary.
-					} elsif ($unary_ctx =~ /\)\s*$/) {
-						my $before = ctx_expr_before($unary_ctx);
-						if ($before =~ /(?:for|if|while)\s*$/) {
-							$is_unary = 1;
-						}
-					}
-
-					# Check for type definition for of '*'.
-					if ($op eq '*' && $unary_ctx =~ /$UnaryDefine$/) {
-						$is_unary = 2;
-					}
+				my $op_type = substr($curr_values, $off + 1, 1);
+				my $op_left = substr($curr_values, $off, 1);
+				my $is_unary;
+				if ($op_type eq 'T') {
+					$is_unary = 2;
+				} elsif ($op_left eq 'V') {
+					$is_unary = 0;
+				} else {
+					$is_unary = 1;
 				}
-
 				#if ($op eq '-' || $op eq '&' || $op eq '*') {
-				#	print "UNARY: <$is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
+				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
 				#}
 
 				# ; should have either the end of line or a space or \ after it
@@ -952,7 +1112,7 @@ sub process {
 
 # check for multiple assignments
 		if ($line =~ /^.\s*$Lval\s*=\s*$Lval\s*=(?!=)/) {
-			WARN("multiple assignments should be avoided\n" . $herecurr);
+			CHK("multiple assignments should be avoided\n" . $herecurr);
 		}
 
 ## # check for multiple declarations, allowing for a function declaration
@@ -1012,7 +1172,7 @@ sub process {
 		}
 
 # Check for illegal assignment in if conditional.
-		if ($line=~/\bif\s*\(.*[^<>!=]=[^=].*\)/) {
+		if ($line=~/\bif\s*\(.*[^<>!=]=[^=]/) {
 			#next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
 			ERROR("do not use assignment in if condition\n" . $herecurr);
 		}
@@ -1038,8 +1198,8 @@ sub process {
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
-			my $checkfile = "include/linux/$1.h";
-			if (-f $checkfile) {
+			my $checkfile = "$root/include/linux/$1.h";
+			if (-f $checkfile && $1 ne 'irq.h') {
 				CHK("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
 					$herecurr);
 			}
@@ -1151,7 +1311,8 @@ sub process {
 		}
 
 # no volatiles please
-		if ($line =~ /\bvolatile\b/ && $line !~ /\basm\s+volatile\b/) {
+		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
+		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {
 			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
@@ -1240,6 +1401,11 @@ sub process {
 
 	if ($clean == 0 && ($chk_patch || $is_patch)) {
 		print report_dump();
+		if ($quiet < 2) {
+			print "total: $cnt_error errors, $cnt_warn warnings, " .
+				(($check)? "$cnt_chk checks, " : "") .
+				"$cnt_lines lines checked\n";
+		}
 	}
 	if ($clean == 1 && $quiet == 0) {
 		print "Your patch has no obvious style problems and is ready for submission.\n"
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
page-owner-tracking-leak-detector.patch
