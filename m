From: akpm@linux-foundation.org
Subject: + add-a-trivial-patch-style-checker-v2.patch added to -mm tree
Date: Tue, 29 May 2007 16:10:13 -0700
Message-ID: <200705292310.l4TNADsf014002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbXE2XLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, davej@codemonkey.org.uk, jschopp@austin.ibm.com, rdunlap@xenotime.net


The patch titled
     add a trivial patch style checker
has been added to the -mm tree.  Its filename is
     add-a-trivial-patch-style-checker-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add a trivial patch style checker
From: Andy Whitcroft <apw@shadowen.org>

We are seeing increasing levels of minor patch style violations in submissions
to the mailing lists as well as making it into the tree.  These detract from
the quality of the submission and cause unnessary work for reviewers.

As a first step package up the current state of the patch style checker and
include it in the kernel tree.  Add instructions suggesting running it on
submissions.  This adds version v0.01 of the checkpatch.pl script.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist              |    6 
 Documentation/SubmittingPatches            |   39 -
 Documentation/feature-removal-schedule.txt |    1 
 MAINTAINERS                                |   16 
 scripts/checkpatch.pl                      |  595 +++++++++++++++++++
 5 files changed, 644 insertions(+), 13 deletions(-)

diff -puN Documentation/SubmitChecklist~add-a-trivial-patch-style-checker-v2 Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~add-a-trivial-patch-style-checker-v2
+++ a/Documentation/SubmitChecklist
@@ -84,3 +84,9 @@ kernel patches.
 24: Avoid whitespace damage such as indenting with spaces or whitespace
     at the end of lines.  You can test this by feeding the patch to
     "git apply --check --whitespace=error-all"
+
+25: Check your patch for general style as detailed in
+    Documentation/CodingStyle.  Check for trivial violations with the
+    patch style checker prior to submission (scripts/checkpatch.pl).
+    You should be able to justify all violations that remain in
+    your patch.
diff -puN Documentation/SubmittingPatches~add-a-trivial-patch-style-checker-v2 Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~add-a-trivial-patch-style-checker-v2
+++ a/Documentation/SubmittingPatches
@@ -118,7 +118,20 @@ then only post say 15 or so at a time an
 
 
 
-4) Select e-mail destination.
+4) Style check your changes.
+
+Check your patch for basic style violations, details of which can be
+found in Documentation/CodingStyle.  Failure to do so simply wastes
+the reviewers time and will get your patch rejected, probabally
+without even being read.
+
+At a minimum you should check your patches with the patch style
+checker prior to submission (scripts/patchcheck.pl).  You should
+be able to justify all violations that remain in your patch.
+
+
+
+5) Select e-mail destination.
 
 Look through the MAINTAINERS file and the source code, and determine
 if your change applies to a specific subsystem of the kernel, with
@@ -146,7 +159,7 @@ discussed should the patch then be submi
 
 
 
-5) Select your CC (e-mail carbon copy) list.
+6) Select your CC (e-mail carbon copy) list.
 
 Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
 
@@ -187,8 +200,7 @@ URL: <http://www.kernel.org/pub/linux/ke
 
 
 
-
-6) No MIME, no links, no compression, no attachments.  Just plain text.
+7) No MIME, no links, no compression, no attachments.  Just plain text.
 
 Linus and other kernel developers need to be able to read and comment
 on the changes you are submitting.  It is important for a kernel
@@ -223,9 +235,9 @@ pref("mailnews.display.disable_format_fl
 
 
 
-7) E-mail size.
+8) E-mail size.
 
-When sending patches to Linus, always follow step #6.
+When sending patches to Linus, always follow step #7.
 
 Large changes are not appropriate for mailing lists, and some
 maintainers.  If your patch, uncompressed, exceeds 40 kB in size,
@@ -234,7 +246,7 @@ server, and provide instead a URL (link)
 
 
 
-8) Name your kernel version.
+9) Name your kernel version.
 
 It is important to note, either in the subject line or in the patch
 description, the kernel version to which this patch applies.
@@ -244,7 +256,7 @@ Linus will not apply it.
 
 
 
-9) Don't get discouraged.  Re-submit.
+10) Don't get discouraged.  Re-submit.
 
 After you have submitted your change, be patient and wait.  If Linus
 likes your change and applies it, it will appear in the next version
@@ -270,7 +282,7 @@ When in doubt, solicit comments on linux
 
 
 
-10) Include PATCH in the subject
+11) Include PATCH in the subject
 
 Due to high e-mail traffic to Linus, and to linux-kernel, it is common
 convention to prefix your subject line with [PATCH].  This lets Linus
@@ -279,7 +291,7 @@ e-mail discussions.
 
 
 
-11) Sign your work
+12) Sign your work
 
 To improve tracking of who did what, especially with patches that can
 percolate to their final resting place in the kernel through several
@@ -328,7 +340,8 @@ now, but you can do this to mark interna
 point out some special detail about the sign-off. 
 
 
-12) The canonical patch format
+
+13) The canonical patch format
 
 The canonical patch subject line is:
 
@@ -427,6 +440,10 @@ section Linus Computer Science 101.
 Nuff said.  If your code deviates too much from this, it is likely
 to be rejected without further review, and without comment.
 
+Check your patches with the patch style checker prior to submission
+(scripts/checkpatch.pl).  You should be able to justify all
+violations that remain in your patch.
+
 
 
 2) #ifdefs are ugly
diff -puN Documentation/feature-removal-schedule.txt~add-a-trivial-patch-style-checker-v2 Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~add-a-trivial-patch-style-checker-v2
+++ a/Documentation/feature-removal-schedule.txt
@@ -70,6 +70,7 @@ Who:	David Miller <davem@davemloft.net>
 
 What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
 When:	December 2006
+Files:	include/linux/video_decoder.h
 Why:	V4L1 AP1 was replaced by V4L2 API. during migration from 2.4 to 2.6
 	series. The old API have lots of drawbacks and don't provide enough
 	means to work with all video and audio standards. The newer API is
diff -puN MAINTAINERS~add-a-trivial-patch-style-checker-v2 MAINTAINERS
--- a/MAINTAINERS~add-a-trivial-patch-style-checker-v2
+++ a/MAINTAINERS
@@ -30,8 +30,11 @@ trivial patch so apply some common sense
 	job the maintainers (and especially Linus) do is to keep things
 	looking the same. Sometimes this means that the clever hack in
 	your driver to get around a problem actually needs to become a
-	generalized kernel feature ready for next time. See
-	Documentation/CodingStyle for guidance here.
+	generalized kernel feature ready for next time.
+
+	PLEASE check your patch with the automated style checker
+	(scripts/checkpatch.pl) to catch trival style violations.
+	See Documentation/CodingStyle for guidance here.
 
 	PLEASE try to include any credit lines you want added with the
 	patch. It avoids people being missed off by mistake and makes
@@ -972,6 +975,15 @@ M:	johannes@sipsolutions.net
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 
+CHECKPATCH
+P:	Andy Whitcroft
+M:	apw@shadowen.org
+P:	Randy Dunlap
+M:	rdunlap@xenotime.net
+P:	Joel Schopp
+M:	jschopp@austin.ibm.com
+S:	Supported
+
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
diff -puN /dev/null scripts/checkpatch.pl
--- /dev/null
+++ a/scripts/checkpatch.pl
@@ -0,0 +1,595 @@
+#!/usr/bin/perl -w
+# (c) 2001, Dave Jones. <davej@codemonkey.org.uk> (the file handling bit)
+# (c) 2005, Joel Scohpp <jschopp@austin.ibm.com> (the ugly bit)
+# (c) 2007, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite, etc)
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+
+my $P = $0;
+
+my $V = '0.01';
+
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $quiet = 0;
+my $tree = 1;
+my $chk_signoff = 1;
+my $chk_patch = 1;
+GetOptions(
+	'q|quiet'	=> \$quiet,
+	'tree!'		=> \$tree,
+	'signoff!'	=> \$chk_signoff,
+	'patch!'	=> \$chk_patch,
+) or exit;
+
+my $exit = 0;
+
+if ($#ARGV < 0) {
+	print "usage: patchstylecheckemail.pl [options] patchfile\n";
+	print "version: $V\n";
+	print "options: -q           => quiet\n";
+	print "         --no-tree    => run without a kernel tree\n";
+	exit(1);
+}
+
+if ($tree && !top_of_kernel_tree()) {
+	print "Must be run from the top-level dir. of a kernel tree\n";
+	exit(2);
+}
+
+my @deprecated = ();
+my $removal = 'Documentation/feature-removal-schedule.txt';
+if ($tree && -f $removal) {
+	open(REMOVE, "<$removal") || die "$P: $removal: open failed - $!\n";
+	while (<REMOVE>) {
+		if (/^Files:\s+(.*\S)/) {
+			for my $file (split(/[, ]+/, $1)) {
+				if ($file =~ m@include/(.*)@) {
+					push(@deprecated, $1);
+				}
+			}
+		}
+	}
+}
+
+my @lines = ();
+while (<>) {
+	chomp;
+	push(@lines, $_);
+	if (eof(ARGV)) {
+		if (!process($ARGV, @lines)) {
+			$exit = 1;
+		}
+		@lines = ();
+	}
+}
+
+exit($exit);
+
+sub top_of_kernel_tree {
+	if ((-f "COPYING") && (-f "CREDITS") && (-f "Kbuild") &&
+	    (-f "MAINTAINERS") && (-f "Makefile") && (-f "README") &&
+	    (-d "Documentation") && (-d "arch") && (-d "include") &&
+	    (-d "drivers") && (-d "fs") && (-d "init") && (-d "ipc") &&
+	    (-d "kernel") && (-d "lib") && (-d "scripts")) {
+		return 1;
+	}
+	return 0;
+}
+
+sub expand_tabs {
+	my ($str) = @_;
+
+	my $res = '';
+	my $n = 0;
+	for my $c (split(//, $str)) {
+		if ($c eq "\t") {
+			$res .= ' ';
+			$n++;
+			for (; ($n % 8) != 0; $n++) {
+				$res .= ' ';
+			}
+			next;
+		}
+		$res .= $c;
+		$n++;
+	}
+
+	return $res;
+}
+
+sub cat_vet {
+	my ($vet) = @_;
+
+	$vet =~ s/\t/^I/;
+	$vet =~ s/$/\$/;
+
+	return $vet;
+}
+
+sub process {
+	my $filename = shift;
+	my @lines = @_;
+
+	my $linenr=0;
+	my $prevline="";
+	my $stashline="";
+
+	my $lineforcounting='';
+	my $indent;
+	my $previndent=0;
+	my $stashindent=0;
+
+	my $clean = 1;
+	my $signoff = 0;
+	my $is_patch = 0;
+
+	# Trace the real file/line as we go.
+	my $realfile = '';
+	my $realline = 0;
+	my $realcnt = 0;
+	my $here = '';
+	my $in_comment = 0;
+	my $first_line = 0;
+
+	foreach my $line (@lines) {
+		$linenr++;
+
+#extract the filename as it passes
+		if ($line=~/^\+\+\+\s+(\S+)/) {
+			$realfile=$1;
+			$in_comment = 0;
+			next;
+		}
+#extract the line range in the file after the patch is applied
+		if ($line=~/^\@\@ -\d+,\d+ \+(\d+)(,(\d+))? \@\@/) {
+			$is_patch = 1;
+			$first_line = 1;
+			$in_comment = 0;
+			$realline=$1-1;
+			if (defined $2) {
+				$realcnt=$3+1;
+			} else {
+				$realcnt=1+1;
+			}
+			next;
+		}
+
+#track the line number as we move through the hunk
+		if ($line=~/^[ \+]/) {
+			$realline++;
+			$realcnt-- if ($realcnt != 0);
+
+			# track any sort of multi-line comment.  Obviously if
+			# the added text or context do not include the whole
+			# comment we will not see it. Such is life.
+			#
+			# Guestimate if this is a continuing comment.  If this
+			# is the start of a diff block and this line starts
+			# ' *' then it is very likely a comment.
+			if ($first_line and $line =~ m@^.\s*\*@) {
+				$in_comment = 1;
+			}
+			if ($line =~ m@/\*@) {
+				$in_comment = 1;
+			}
+			if ($line =~ m@\*/@) {
+				$in_comment = 0;
+			}
+
+			$lineforcounting = $line;
+			$lineforcounting =~ s/^\+//;
+			$lineforcounting = expand_tabs($lineforcounting);
+
+			my ($white) = ($lineforcounting =~ /^(\s*)/);
+			$indent = length($white);
+
+			# Track the previous line.
+			($prevline, $stashline) = ($stashline, $line);
+			($previndent, $stashindent) = ($stashindent, $indent);
+			$first_line = 0;
+		}
+
+#make up the handle for any error we report on this line
+		$here = "PATCH: $ARGV:$linenr:";
+		$here .= "\nFILE: $realfile:$realline:" if ($realcnt != 0);
+
+		my $herecurr = "$here\n$line\n\n";
+		my $hereprev = "$here\n$prevline\n$line\n\n";
+
+#check the patch for a signoff:
+		if ($line =~ /^\s*Signed-off-by:\s/) {
+			$signoff++;
+
+		} elsif ($line =~ /^\s*signed-off-by:/i) {
+			if (!($line =~ /^\s*Signed-off-by:/)) {
+				print "use Signed-off-by:\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+			if ($line =~ /^\s*signed-off-by:\S/i) {
+				print "need space after Signed-off-by:\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+		}
+
+#ignore lines not being added
+		if ($line=~/^[^\+]/) {next;}
+
+# check we are in a valid source file *.[hcsS] if not then ignore this hunk
+		next if ($realfile !~ /\.[hcsS]$/);
+
+#trailing whitespace
+		if ($line=~/\S\s+$/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
+			print "trailing whitespace\n";
+			print "$herevet";
+			$clean = 0;
+		}
+#80 column limit
+		if (!($prevline=~/\/\*\*/) && length($lineforcounting) > 80) {
+			print "line over 80 characters\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# check we are in a valid source file *.[hc] if not then ignore this hunk
+		next if ($realfile !~ /\.[hc]$/);
+
+# at the beginning of a line any tabs must come first and anything
+# more than 8 must use tabs.
+		if ($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {
+			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
+			print "use tabs not spaces\n";
+			print "$herevet";
+			$clean = 0;
+		}
+
+		#
+		# The rest of our checks refer specifically to C style
+		# only apply those _outside_ comments.
+		#
+		next if ($in_comment);
+
+# no C99 // comments
+		if ($line =~ m@//@ and !($line =~ m@\".*//.*\"@)) {
+			print "do not use C99 // comments\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+		# Remove comments from the line before processing.
+		$line =~ s@/\*.*\*/@@g;
+		$line =~ s@/\*.*@@;
+		$line =~ s@.*\*/@@;
+		$line =~ s@//.*@@;
+
+#EXPORT_SYMBOL should immediately follow its function closing }.
+		if (($line =~ /EXPORT_SYMBOL.*\(.*\)/) ||
+		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\(.*\)/)) {
+			if (($prevline !~ /^}/) &&
+			   ($prevline !~ /^\+}/) &&
+			   ($prevline !~ /^ }/)) {
+				print "EXPORT_SYMBOL(func); should immediately follow its function\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+		}
+
+		# check for static initialisers.
+		if ($line=~/\s*static\s.*=\s+(0|NULL);/) {
+			print "do not initialise statics to 0 or NULL\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+		# check for new typedefs.
+		if ($line=~/\s*typedef\s/) {
+			print "do not add new typedefs\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# * goes on variable not on type
+		if ($line=~/[A-Za-z\d_]+\* [A-Za-z\d_]+/) {
+			print "\"foo* bar\" should be \"foo *bar\"\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# # no BUG() or BUG_ON()
+# 		if ($line =~ /\b(BUG|BUG_ON)\b/) {
+# 			print "Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n";
+# 			print "$herecurr";
+# 			$clean = 0;
+# 		}
+
+# printk should use KERN_* levels
+		if ($line =~ /\bprintk\((?!KERN_)/) {
+			print "printk() should include KERN_ facility level\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+#function brace can't be on same line, except for #defines of do while, or if closed on same line
+		if (($line=~/[A-Za-z\d_]+\**\s+\**[A-Za-z\d_]+\(.*\).* {/) and
+		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
+			print "braces following function declarations go on the next line\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+		my $opline = $line;
+		$opline =~ s/^.//;
+		if (!($line=~/\#\s*include/)) {
+			# Check operator spacing.
+			my @elements = split(/(<<=|>>=|<=|>=|==|!=|\+=|-=|\*=|\/=|%=|\^=|\|=|&=|->|<<|>>|<|>|=|!|~|&&|\|\||,|\^|\+\+|--|;|&|\||\+|-|\*|\/\/|\/)/, $opline);
+			for (my $n = 0; $n < $#elements; $n += 2) {
+				# $wN says we have white-space before or after
+				# $sN says we have a separator before or after
+				# $oN says we have another operator before or after
+				my $w1 = $elements[$n] =~ /\s$/;
+				my $s1 = $elements[$n] =~ /(\[|\(|\s)$/;
+				my $o1 = $elements[$n] eq '';
+				my $op = $elements[$n + 1];
+				my $w2 = 1;
+				my $s2 = 1;
+				my $o2 = 0;
+				# If we have something after the operator handle it.
+				if (defined $elements[$n + 2]) {
+					$w2 = $elements[$n + 2] =~ /^\s/;
+					$s2 = $elements[$n + 2] =~ /^(\s|\)|\]|;)/;
+					$o2 = $elements[$n + 2] eq '';
+				}
+
+				# Generate the context.
+				my $at = "here: ";
+				for (my $m = $n; $m >= 0; $m--) {
+					if ($elements[$m] ne '') {
+						$at .= $elements[$m];
+						last;
+					}
+				}
+				$at .= $op;
+				for (my $m = $n + 2; defined $elements[$m]; $m++) {
+					if ($elements[$m] ne '') {
+						$at .= $elements[$m];
+						last;
+					}
+				}
+
+				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
+				# Skip things apparently in quotes.
+				next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
+
+				# We need ; as an operator.  // is a comment.
+				if ($op eq ';' or $op eq '//') {
+
+				# -> should have no spaces
+				} elsif ($op eq '->') {
+					if ($s1 or $s2) {
+						print "no spaces around that '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+
+				# , must have a space on the right.
+				} elsif ($op eq ',') {
+					if (!$s2) {
+						print "need space after that '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+
+				# unary ! and unary ~ are allowed no space on the right
+				} elsif ($op eq '!' or $op eq '~') {
+					if (!$s1 && !$o1) {
+						print "need space before that '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+					if ($s2) {
+						print "no space after that '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+
+				# unary ++ and unary -- are allowed no space on one side.
+				} elsif ($op eq '++' or $op eq '--') {
+					if (($s1 && $s2) || ((!$s1 && !$o1) && (!$s2 && !$o2))) {
+						print "need space one side of that '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+
+				# & is both unary and binary
+				# unary:
+				# 	a &b
+				# binary (consistent spacing):
+				#	a&b		OK
+				#	a & b		OK
+				#
+				# boiling down to: if there is a space on the right then there
+				# should be one on the left.
+				#
+				# - is the same
+				#
+				# * is the same only adding:
+				# type:
+				# 	(foo *)
+				#	(foo **)
+				#
+				} elsif ($op eq '&' or $op eq '-' or $op eq '*') {
+					if ($w2 and !$w1) {
+						print "need space before that '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+
+				# << and >> may either have or not have spaces both sides
+				} elsif ($op eq '<<' or $op eq '>>' or $op eq '+' or $op eq '/' or
+					 $op eq '^' or $op eq '|')
+				{
+					if ($s1 != $s2) {
+						print "need consistent spacing around '$op' $at\n";
+						print "$herecurr";
+						$clean = 0;
+					}
+
+				# All the others need spaces both sides.
+				} elsif (!$s1 or !$s2) {
+					print "need spaces around that '$op' $at\n";
+					print "$herecurr";
+					$clean = 0;
+				}
+			}
+		}
+
+#need space before brace following if, while, etc
+		if ($line=~/\(.*\){/) {
+			print "need a space before the brace\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+#goto labels aren't indented, allow a single space however
+		if ($line=~/^.\s+[A-Za-z\d_]+:/ and
+		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
+			print "labels should not be indented\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# Need a space before open parenthesis after if, while etc
+		if ($line=~/(if|while|for|switch)\(/) {
+			print "need a space before the open parenthesis\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+# Check for illegal assignment in if conditional.
+		if ($line=~/(if|while)\s*\(.*[^<>!=]=[^=].*\)/) {
+			print "do not use assignment in if condition\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+
+		# Check for }<nl>else {, these must be at the same
+		# indent level to be relevant to each other.
+		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
+						$previndent == $indent) {
+			print "else should follow close brace\n";
+			print "$hereprev";
+			$clean = 0;
+		}
+
+		# Check for switch () {<nl>case, these must be at the
+		# same indent.  We will only catch the first one, as our
+		# context is very small but people tend to be consistent
+		# so we will catch them out more often than not.
+		if ($prevline=~/\s*switch\s*\(.*\)/ and $line=~/\s*case\s+/
+						and $previndent != $indent) {
+			print "switch and case should be at the same indent\n";
+			print "$hereprev";
+			$clean = 0;
+		}
+
+#studly caps, commented out until figure out how to distinguish between use of existing and adding new
+#		if (($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
+#		    print "No studly caps, use _\n";
+#		    print "$herecurr";
+#		    $clean = 0;
+#		}
+
+#no spaces allowed after \ in define
+		if ($line=~/\#define.*\\\s$/) {
+			print("Whitepspace after \\ makes next lines useless\n");
+			print "$herecurr";
+			$clean = 0;
+		}
+
+#warn if <asm/foo.h> is #included and <linux/foo.h> is available.
+		if ($tree && $line =~ qr|\s*\#\s*include\s*\<asm\/(.*)\.h\>|) {
+			my $checkfile = "include/linux/$1.h";
+			if (-f $checkfile) {
+				print "Use #include <linux/$1.h> instead of <asm/$1.h>\n";
+				print $herecurr;
+				$clean = 0;
+			}
+		}
+
+#if/while/etc brace do not go on next line, unless #defining a do while loop, or if that brace on the next line is for something else
+		if ($prevline=~/(if|while|for|switch)\s*\(/) {
+			my @opened = $prevline=~/\(/g;
+			my @closed = $prevline=~/\)/g;
+			my $nr_line = $linenr;
+			my $remaining = $realcnt;
+			my $next_line = $line;
+			my $extra_lines = 0;
+			my $display_segment = $prevline;
+
+			while ($remaining > 0 && scalar @opened > scalar @closed) {
+				$prevline .= $next_line;
+				$display_segment .= "\n" . $next_line;
+				$next_line = $lines[$nr_line];
+				$nr_line++;
+				$remaining--;
+
+				@opened = $prevline=~/\(/g;
+				@closed = $prevline=~/\)/g;
+			}
+
+			if (($prevline=~/(if|while|for|switch)\s*\(.*\)\s*$/) and ($next_line=~/{/) and
+			   !($next_line=~/(if|while|for)/) and !($next_line=~/\#define.*do.*while/)) {
+				print "That { should be on the previous line\n";
+				print "$display_segment\n$next_line\n\n";
+				$clean = 0;
+			}
+		}
+
+#multiline macros should be enclosed in a do while loop
+		if (($prevline=~/\#define.*\\/) and !($prevline=~/do\s+{/) and
+		   !($prevline=~/\(\{/) and ($line=~/;\s*\\/) and
+		   !($line=~/do.*{/) and !($line=~/\(\{/)) {
+			print "Macros with multiple statements should be enclosed in a do - while loop\n";
+			print "$hereprev";
+			$clean = 0;
+		}
+
+# don't include deprecated include files
+		for my $inc (@deprecated) {
+			if ($line =~ m@\#\s*include\s*\<$inc>@) {
+				print "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n";
+				print "$herecurr";
+				$clean = 0;
+			}
+		}
+
+# don't use kernel_thread()
+		if ($line =~ /\bkernel_thread\b/) {
+			print "Don't use kernel_thread(), use kthread(): see Documentation/feature-removal-schedule.txt\n";
+			print "$herecurr";
+			$clean = 0;
+		}
+	}
+
+	if ($chk_patch && !$is_patch) {
+		$clean = 0;
+		print "Does not appear to be a unified-diff format patch\n";
+	}
+	if ($is_patch && $chk_signoff && $signoff == 0) {
+		$clean = 0;
+		print "Missing Signed-off-by: line(s)\n";
+	}
+
+	if ($clean == 1 && $quiet == 0) {
+		print "Your patch has no obvious style problems and is ready for submission.\n"
+	}
+	if ($clean == 0 && $quiet == 0) {
+		print "Your patch has style problems, please review.  If any of these errors\n";
+		print "are false positives report them to the maintainer, see\n";
+		print "CHECKPATCH in MAINTAINERS.\n";
+	}
+	return $clean;
+}
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
add-a-trivial-patch-style-checker-v2.patch
move-three-functions-that-are-only-needed-for.patch
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
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
