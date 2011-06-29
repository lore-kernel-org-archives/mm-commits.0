From: akpm@linux-foundation.org
Subject: + checkpatchpl-add-ability-to-ignore-various-messages.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:29:37 -0700
Message-ID: <201106292229.p5TMTbAn016101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab1F2W3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, vapier@gentoo.org


The patch titled
     checkpatch.pl: add ability to ignore various messages
has been added to the -mm tree.  Its filename is
     checkpatchpl-add-ability-to-ignore-various-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch.pl: add ability to ignore various messages
From: Joe Perches <joe@perches.com>

Some users would like the ability to not emit some of the messages that
checkpatch produces.  To make it easier to use checkpatch in other
projects and integrate into scm hook scripts.

Add command line option to "--ignore" various message types.  Add option
--show-types to emit the "type" of each message.  Categorize all ERROR,
WARN and CHK messages with types.

Add optional .checkpatch.conf file to store default options.
3 paths are searched for .checkpatch.conf
    .             customized per-tree configurations
    $HOME         user global configuration when per-tree configs don't exist
    ./scripts     lk defaults to override script
The .conf file can contain any valid command-line argument and
the contents are prepended to any additional command line arguments.
Multiple lines may be used, blank lines are ignored, # is a comment.

Update "false positive" output for readability.

Update version to 0.32

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  498 ++++++++++++++++++++++++++++------------
 1 file changed, 355 insertions(+), 143 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-ability-to-ignore-various-messages scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-ability-to-ignore-various-messages
+++ a/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.31';
+my $V = '0.32';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -26,9 +26,13 @@ my $check = 0;
 my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
+my $show_types = 0;
 my $root;
 my %debug;
+my %ignore_type = ();
+my @ignore = ();
 my $help = 0;
+my $configuration_file = ".checkpatch.conf";
 
 sub help {
 	my ($exitcode) = @_;
@@ -46,6 +50,8 @@ Options:
   --terse                    one line per report
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
+  --ignore TYPE(,TYPE2...)   ignore various comma separated message types
+  --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
   --mailback                 only produce a report in case of warnings/errors
@@ -63,6 +69,32 @@ EOM
 	exit($exitcode);
 }
 
+my $conf = which_conf($configuration_file);
+if (-f $conf) {
+	my @conf_args;
+	open(my $conffile, '<', "$conf")
+	    or warn "$P: Can't find a readable $configuration_file file $!\n";
+
+	while (<$conffile>) {
+		my $line = $_;
+
+		$line =~ s/\s*\n?$//g;
+		$line =~ s/^\s*//g;
+		$line =~ s/\s+/ /g;
+
+		next if ($line =~ m/^\s*#/);
+		next if ($line =~ m/^\s*$/);
+
+		my @words = split(" ", $line);
+		foreach my $word (@words) {
+			last if ($word =~ m/^#/);
+			push (@conf_args, $word);
+		}
+	}
+	close($conffile);
+	unshift(@ARGV, @conf_args) if @conf_args;
+}
+
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -73,6 +105,8 @@ GetOptions(
 	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
+	'ignore=s'	=> \@ignore,
+	'show-types!'	=> \$show_types,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -93,6 +127,19 @@ if ($#ARGV < 0) {
 	exit(1);
 }
 
+@ignore = split(/,/, join(',',@ignore));
+foreach my $word (@ignore) {
+	$word =~ s/\s*\n?$//g;
+	$word =~ s/^\s*//g;
+	$word =~ s/\s+/ /g;
+	$word =~ tr/[a-z]/[A-Z]/;
+
+	next if ($word =~ m/^\s*#/);
+	next if ($word =~ m/^\s*$/);
+
+	$ignore_type{$word}++;
+}
+
 my $dbg_values = 0;
 my $dbg_possible = 0;
 my $dbg_type = 0;
@@ -364,7 +411,7 @@ sub top_of_kernel_tree {
 		}
 	}
 	return 1;
-}
+    }
 
 sub parse_email {
 	my ($formatted_email) = @_;
@@ -436,6 +483,18 @@ sub format_email {
 	return $formatted_email;
 }
 
+sub which_conf {
+	my ($conf) = @_;
+
+	foreach my $path (split(/:/, ".:$ENV{HOME}:.scripts")) {
+		if (-e "$path/$conf") {
+			return "$path/$conf";
+		}
+	}
+
+	return "";
+}
+
 sub expand_tabs {
 	my ($str) = @_;
 
@@ -1181,12 +1240,21 @@ sub possible {
 
 my $prefix = '';
 
+sub show_type {
+       return !defined $ignore_type{$_[0]};
+}
+
 sub report {
-	if (defined $tst_only && $_[0] !~ /\Q$tst_only\E/) {
+	if (!show_type($_[1]) ||
+	    (defined $tst_only && $_[2] !~ /\Q$tst_only\E/)) {
 		return 0;
 	}
-	my $line = $prefix . $_[0];
-
+	my $line;
+	if ($show_types) {
+		$line = "$prefix$_[0]:$_[1]: $_[2]\n";
+	} else {
+		$line = "$prefix$_[0]: $_[2]\n";
+	}
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
 
 	push(our @report, $line);
@@ -1196,20 +1264,21 @@ sub report {
 sub report_dump {
 	our @report;
 }
+
 sub ERROR {
-	if (report("ERROR: $_[0]\n")) {
+	if (report("ERROR", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_error++;
 	}
 }
 sub WARN {
-	if (report("WARNING: $_[0]\n")) {
+	if (report("WARNING", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_warn++;
 	}
 }
 sub CHK {
-	if ($check && report("CHECK: $_[0]\n")) {
+	if ($check && report("CHECK", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_chk++;
 	}
@@ -1238,7 +1307,8 @@ sub check_absolute_file {
 
 	##print "prefix<$prefix>\n";
 	if ($prefix ne ".../") {
-		WARN("use relative pathname instead of absolute in changelog text\n" . $herecurr);
+		WARN("USE_RELATIVE_PATH",
+		     "use relative pathname instead of absolute in changelog text\n" . $herecurr);
 	}
 }
 
@@ -1435,11 +1505,13 @@ sub process {
 			$p1_prefix = $1;
 			if (!$file && $tree && $p1_prefix ne '' &&
 			    -e "$root/$p1_prefix") {
-				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
+				WARN("PATCH_PREFIX",
+				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
 			}
 
 			if ($realfile =~ m@^include/asm/@) {
-				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
+				ERROR("MODIFIED_INCLUDE_ASM",
+				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
 			next;
 		}
@@ -1456,7 +1528,8 @@ sub process {
 		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
 			my $permhere = $here . "FILE: $realfile\n";
 			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
-				ERROR("do not set execute permissions for source files\n" . $permhere);
+				ERROR("EXECUTE_PERMISSIONS",
+				      "do not set execute permissions for source files\n" . $permhere);
 			}
 		}
 
@@ -1474,19 +1547,23 @@ sub process {
 			my $ucfirst_sign_off = ucfirst(lc($sign_off));
 
 			if (defined $space_before && $space_before ne "") {
-				WARN("Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
+				WARN("BAD_SIGN_OFF",
+				     "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
 			}
 			if ($sign_off =~ /-by:$/i && $sign_off ne $ucfirst_sign_off) {
-				WARN("'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
+				WARN("BAD_SIGN_OFF",
+				     "'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
 			}
 			if (!defined $space_after || $space_after ne " ") {
-				WARN("Use a single space after $ucfirst_sign_off\n" . $herecurr);
+				WARN("BAD_SIGN_OFF",
+				     "Use a single space after $ucfirst_sign_off\n" . $herecurr);
 			}
 
 			my ($email_name, $email_address, $comment) = parse_email($email);
 			my $suggested_email = format_email(($email_name, $email_address));
 			if ($suggested_email eq "") {
-				ERROR("Unrecognized email address: '$email'\n" . $herecurr);
+				ERROR("BAD_SIGN_OFF",
+				      "Unrecognized email address: '$email'\n" . $herecurr);
 			} else {
 				my $dequoted = $suggested_email;
 				$dequoted =~ s/^"//;
@@ -1496,14 +1573,16 @@ sub process {
 				if ("$dequoted$comment" ne $email &&
 				    "<$email_address>$comment" ne $email &&
 				    "$suggested_email$comment" ne $email) {
-					WARN("email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
+					WARN("BAD_SIGN_OFF",
+					     "email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
 				}
 			}
 		}
 
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
-			ERROR("patch seems to be corrupt (line wrapped?)\n" .
+			ERROR("CORRUPTED_PATCH",
+			      "patch seems to be corrupt (line wrapped?)\n" .
 				$herecurr) if (!$emitted_corrupt++);
 		}
 
@@ -1530,7 +1609,8 @@ sub process {
 			my $ptr = substr($blank, 0, length($utf8_prefix)) . "^";
 			my $hereptr = "$hereline$ptr\n";
 
-			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
+			ERROR("INVALID_UTF8",
+			      "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
 # ignore non-hunk lines and lines being removed
@@ -1539,11 +1619,13 @@ sub process {
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("DOS line endings\n" . $herevet);
+			ERROR("DOS_LINE_ENDINGS",
+			      "DOS line endings\n" . $herevet);
 
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("trailing whitespace\n" . $herevet);
+			ERROR("TRAILING_WHITESPACE",
+			      "trailing whitespace\n" . $herevet);
 			$rpt_cleaners = 1;
 		}
 
@@ -1574,7 +1656,8 @@ sub process {
 				}
 				$length++;
 			}
-			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
+			WARN("CONFIG_DESCRIPTION",
+			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
 			#print "is_end<$is_end> length<$length>\n";
 		}
 
@@ -1588,28 +1671,33 @@ sub process {
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > 80)
 		{
-			WARN("line over 80 characters\n" . $herecurr);
+			WARN("LONG_LINE",
+			     "line over 80 characters\n" . $herecurr);
 		}
 
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
-			WARN("unnecessary whitespace before a quoted newline\n" . $herecurr);
+			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
+			     "unnecessary whitespace before a quoted newline\n" . $herecurr);
 		}
 
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
-			WARN("adding a line without newline at end of file\n" . $herecurr);
+			WARN("MISSING_EOF_NEWLINE",
+			     "adding a line without newline at end of file\n" . $herecurr);
 		}
 
 # Blackfin: use hi/lo macros
 		if ($realfile =~ m@arch/blackfin/.*\.S$@) {
 			if ($line =~ /\.[lL][[:space:]]*=.*&[[:space:]]*0x[fF][fF][fF][fF]/) {
 				my $herevet = "$here\n" . cat_vet($line) . "\n";
-				ERROR("use the LO() macro, not (... & 0xFFFF)\n" . $herevet);
+				ERROR("LO_MACRO",
+				      "use the LO() macro, not (... & 0xFFFF)\n" . $herevet);
 			}
 			if ($line =~ /\.[hH][[:space:]]*=.*>>[[:space:]]*16/) {
 				my $herevet = "$here\n" . cat_vet($line) . "\n";
-				ERROR("use the HI() macro, not (... >> 16)\n" . $herevet);
+				ERROR("HI_MACRO",
+				      "use the HI() macro, not (... >> 16)\n" . $herevet);
 			}
 		}
 
@@ -1621,14 +1709,16 @@ sub process {
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("code indent should use tabs where possible\n" . $herevet);
+			ERROR("CODE_INDENT",
+			      "code indent should use tabs where possible\n" . $herevet);
 			$rpt_cleaners = 1;
 		}
 
 # check for space before tabs.
 		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("please, no space before tabs\n" . $herevet);
+			WARN("SPACE_BEFORE_TAB",
+			     "please, no space before tabs\n" . $herevet);
 		}
 
 # check for spaces at the beginning of a line.
@@ -1638,7 +1728,8 @@ sub process {
 #  3) hanging labels
 		if ($rawline =~ /^\+ / && $line !~ /\+ *(?:$;|#|$Ident:)/)  {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("please, no spaces at the start of a line\n" . $herevet);
+			WARN("LEADING_SPACE",
+			     "please, no spaces at the start of a line\n" . $herevet);
 		}
 
 # check we are in a valid C source file if not then ignore this hunk
@@ -1646,17 +1737,20 @@ sub process {
 
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
-			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
+			WARN("CVS_KEYWORD",
+			     "CVS style keyword markers, these will _not_ be updated\n". $herecurr);
 		}
 
 # Blackfin: don't use __builtin_bfin_[cs]sync
 		if ($line =~ /__builtin_bfin_csync/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n";
-			ERROR("use the CSYNC() macro in asm/blackfin.h\n" . $herevet);
+			ERROR("CSYNC",
+			      "use the CSYNC() macro in asm/blackfin.h\n" . $herevet);
 		}
 		if ($line =~ /__builtin_bfin_ssync/) {
 			my $herevet = "$here\n" . cat_vet($line) . "\n";
-			ERROR("use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
+			ERROR("SSYNC",
+			      "use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
 		}
 
 # Check for potential 'bare' types
@@ -1745,7 +1839,8 @@ sub process {
 				}
 			}
 			if ($err ne '') {
-				ERROR("switch and case should be at the same indent\n$hereline$err");
+				ERROR("SWITCH_CASE_INDENT_LEVEL",
+				      "switch and case should be at the same indent\n$hereline$err");
 			}
 		}
 
@@ -1773,7 +1868,8 @@ sub process {
 			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
-				ERROR("that open brace { should be on the previous line\n" .
+				ERROR("OPEN_BRACE",
+				      "that open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 			}
 			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
@@ -1782,7 +1878,8 @@ sub process {
 			{
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
-					WARN("trailing semicolon indicates no statements, indent implies otherwise\n" .
+					WARN("TRAILING_SEMICOLON",
+					     "trailing semicolon indicates no statements, indent implies otherwise\n" .
 						"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 				}
 			}
@@ -1870,7 +1967,8 @@ sub process {
 
 			if ($check && (($sindent % 8) != 0 ||
 			    ($sindent <= $indent && $s ne ''))) {
-				WARN("suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
+				WARN("SUSPECT_CODE_INDENT",
+				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
 			}
 		}
 
@@ -1893,18 +1991,22 @@ sub process {
 # TEST: allow direct testing of the type matcher.
 		if ($dbg_type) {
 			if ($line =~ /^.\s*$Declare\s*$/) {
-				ERROR("TEST: is type\n" . $herecurr);
+				ERROR("TEST_TYPE",
+				      "TEST: is type\n" . $herecurr);
 			} elsif ($dbg_type > 1 && $line =~ /^.+($Declare)/) {
-				ERROR("TEST: is not type ($1 is)\n". $herecurr);
+				ERROR("TEST_NOT_TYPE",
+				      "TEST: is not type ($1 is)\n". $herecurr);
 			}
 			next;
 		}
 # TEST: allow direct testing of the attribute matcher.
 		if ($dbg_attr) {
 			if ($line =~ /^.\s*$Modifier\s*$/) {
-				ERROR("TEST: is attr\n" . $herecurr);
+				ERROR("TEST_ATTR",
+				      "TEST: is attr\n" . $herecurr);
 			} elsif ($dbg_attr > 1 && $line =~ /^.+($Modifier)/) {
-				ERROR("TEST: is not attr ($1 is)\n". $herecurr);
+				ERROR("TEST_NOT_ATTR",
+				      "TEST: is not attr ($1 is)\n". $herecurr);
 			}
 			next;
 		}
@@ -1912,7 +2014,8 @@ sub process {
 # check for initialisation to aggregates open brace on the next line
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /(?:^|[^=])=\s*$/) {
-			ERROR("that open brace { should be on the previous line\n" . $hereprev);
+			ERROR("OPEN_BRACE",
+			      "that open brace { should be on the previous line\n" . $hereprev);
 		}
 
 #
@@ -1923,14 +2026,16 @@ sub process {
 		if ($rawline =~ m{^.\s*\#\s*include\s+[<"](.*)[">]}) {
 			my $path = $1;
 			if ($path =~ m{//}) {
-				ERROR("malformed #include filename\n" .
+				ERROR("MALFORMED_INCLUDE",
+				      "malformed #include filename\n" .
 					$herecurr);
 			}
 		}
 
 # no C99 // comments
 		if ($line =~ m{//}) {
-			ERROR("do not use C99 // comments\n" . $herecurr);
+			ERROR("C99_COMMENTS",
+			      "do not use C99 // comments\n" . $herecurr);
 		}
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
@@ -1977,35 +2082,41 @@ sub process {
 		}
 		if (defined $suppress_export{$linenr} &&
 		    $suppress_export{$linenr} == 2) {
-			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
+			WARN("EXPORT_SYMBOL",
+			     "EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 		}
 
 # check for global initialisers.
 		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
-			ERROR("do not initialise globals to 0 or NULL\n" .
+			ERROR("GLOBAL_INITIALISERS",
+			      "do not initialise globals to 0 or NULL\n" .
 				$herecurr);
 		}
 # check for static initialisers.
 		if ($line =~ /\bstatic\s.*=\s*(0|NULL|false)\s*;/) {
-			ERROR("do not initialise statics to 0 or NULL\n" .
+			ERROR("INITIALISED_STATIC",
+			      "do not initialise statics to 0 or NULL\n" .
 				$herecurr);
 		}
 
 # check for static const char * arrays.
 		if ($line =~ /\bstatic\s+const\s+char\s*\*\s*(\w+)\s*\[\s*\]\s*=\s*/) {
-			WARN("static const char * array should probably be static const char * const\n" .
+			WARN("STATIC_CONST_CHAR_ARRAY",
+			     "static const char * array should probably be static const char * const\n" .
 				$herecurr);
                }
 
 # check for static char foo[] = "bar" declarations.
 		if ($line =~ /\bstatic\s+char\s+(\w+)\s*\[\s*\]\s*=\s*"/) {
-			WARN("static char array declaration should probably be static const char\n" .
+			WARN("STATIC_CONST_CHAR_ARRAY",
+			     "static char array declaration should probably be static const char\n" .
 				$herecurr);
                }
 
 # check for declarations of struct pci_device_id
 		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
-			WARN("Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
+			WARN("DEFINE_PCI_DEVICE_TABLE",
+			     "Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
 		}
 
 # check for new typedefs, only function parameters and sparse annotations
@@ -2015,7 +2126,8 @@ sub process {
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
-			WARN("do not add new typedefs\n" . $herecurr);
+			WARN("NEW_TYPEDEFS",
+			     "do not add new typedefs\n" . $herecurr);
 		}
 
 # * goes on variable not on type
@@ -2033,7 +2145,8 @@ sub process {
 
 			#print "from<$from> to<$to>\n";
 			if ($from ne $to) {
-				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
+				ERROR("POINTER_LOCATION",
+				      "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
 		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
 			my ($from, $to, $ident) = ($1, $1, $2);
@@ -2050,7 +2163,8 @@ sub process {
 
 			#print "from<$from> to<$to> ident<$ident>\n";
 			if ($from ne $to && $ident !~ /^$Modifier$/) {
-				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
+				ERROR("POINTER_LOCATION",
+				      "\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
 			}
 		}
 
@@ -2062,12 +2176,14 @@ sub process {
 # 		}
 
 		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
-			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
+			WARN("LINUX_VERSION_CODE",
+			     "LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
 		}
 
 # check for uses of printk_ratelimit
 		if ($line =~ /\bprintk_ratelimit\s*\(/) {
-			WARN("Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
+			WARN("PRINTK_RATELIMITED",
+"Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
 		}
 
 # printk should use KERN_* levels.  Note that follow on printk's on the
@@ -2089,7 +2205,8 @@ sub process {
 				}
 			}
 			if ($ok == 0) {
-				WARN("printk() should include KERN_ facility level\n" . $herecurr);
+				WARN("PRINTK_WITHOUT_KERN_LEVEL",
+				     "printk() should include KERN_ facility level\n" . $herecurr);
 			}
 		}
 
@@ -2097,18 +2214,21 @@ sub process {
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
 		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
-			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
+			ERROR("OPEN_BRACE",
+			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
+			ERROR("OPEN_BRACE",
+			      "open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
 # missing space after union, struct or enum definition
 		if ($line =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?(?:\s+$Ident)?[=\{]/) {
-		    WARN("missing space after $1 definition\n" . $herecurr);
+		    WARN("SPACING",
+			 "missing space after $1 definition\n" . $herecurr);
 		}
 
 # check for spacing round square brackets; allowed:
@@ -2120,7 +2240,8 @@ sub process {
 			if ($prefix !~ /$Type\s+$/ &&
 			    ($where != 0 || $prefix !~ /^.\s+$/) &&
 			    $prefix !~ /{\s+$/) {
-				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
+				ERROR("BRACKET_SPACE",
+				      "space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
 
@@ -2151,7 +2272,8 @@ sub process {
 			} elsif ($ctx =~ /$Type$/) {
 
 			} else {
-				WARN("space prohibited between function name and open parenthesis '('\n" . $herecurr);
+				WARN("SPACING",
+				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Check operator spacing.
@@ -2225,7 +2347,8 @@ sub process {
 				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEBC]/ &&
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
-						ERROR("space required after that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space required after that '$op' $at\n" . $hereptr);
 					}
 
 				# // is a comment
@@ -2236,13 +2359,15 @@ sub process {
 				#   :   when part of a bitfield
 				} elsif ($op eq '->' || $opv eq ':B') {
 					if ($ctx =~ /Wx.|.xW/) {
-						ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "spaces prohibited around that '$op' $at\n" . $hereptr);
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
-						ERROR("space required after that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space required after that '$op' $at\n" . $hereptr);
 					}
 
 				# '*' as part of a type definition -- reported already.
@@ -2256,26 +2381,31 @@ sub process {
 					 $opv eq '*U' || $opv eq '-U' ||
 					 $opv eq '&U' || $opv eq '&&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
-						ERROR("space required before that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space required before that '$op' $at\n" . $hereptr);
 					}
 					if ($op eq '*' && $cc =~/\s*$Modifier\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
 					if ($ctx !~ /[WEOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
-						ERROR("space required one side of that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space required one side of that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /Wx[BE]/ ||
 					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
-						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space prohibited before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /ExW/) {
-						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 
@@ -2287,7 +2417,8 @@ sub process {
 					 $op eq '%')
 				{
 					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
-						ERROR("need consistent spacing around '$op' $at\n" .
+						ERROR("SPACING",
+						      "need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
 
@@ -2295,7 +2426,8 @@ sub process {
 				# terminating a case value or a label.
 				} elsif ($opv eq ':C' || $opv eq ':L') {
 					if ($ctx =~ /Wx./) {
-						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "space prohibited before that '$op' $at\n" . $hereptr);
 					}
 
 				# All the others need spaces both sides.
@@ -2318,7 +2450,8 @@ sub process {
 					}
 
 					if ($ok == 0) {
-						ERROR("spaces required around that '$op' $at\n" . $hereptr);
+						ERROR("SPACING",
+						      "spaces required around that '$op' $at\n" . $hereptr);
 					}
 				}
 				$off += length($elements[$n + 1]);
@@ -2327,7 +2460,8 @@ sub process {
 
 # check for multiple assignments
 		if ($line =~ /^.\s*$Lval\s*=\s*$Lval\s*=(?!=)/) {
-			CHK("multiple assignments should be avoided\n" . $herecurr);
+			CHK("MULTIPLE_ASSIGNMENTS",
+			    "multiple assignments should be avoided\n" . $herecurr);
 		}
 
 ## # check for multiple declarations, allowing for a function declaration
@@ -2341,45 +2475,53 @@ sub process {
 ## 			while ($ln =~ s/\([^\(\)]*\)//g) {
 ## 			}
 ## 			if ($ln =~ /,/) {
-## 				WARN("declaring multiple variables together should be avoided\n" . $herecurr);
+## 				WARN("MULTIPLE_DECLARATION",
+##				     "declaring multiple variables together should be avoided\n" . $herecurr);
 ## 			}
 ## 		}
 
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
-			ERROR("space required before the open brace '{'\n" . $herecurr);
+			ERROR("SPACING",
+			      "space required before the open brace '{'\n" . $herecurr);
 		}
 
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-			ERROR("space required after that close brace '}'\n" . $herecurr);
+			ERROR("SPACING",
+			      "space required after that close brace '}'\n" . $herecurr);
 		}
 
 # check spacing on square brackets
 		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
-			ERROR("space prohibited after that open square bracket '['\n" . $herecurr);
+			ERROR("SPACING",
+			      "space prohibited after that open square bracket '['\n" . $herecurr);
 		}
 		if ($line =~ /\s\]/) {
-			ERROR("space prohibited before that close square bracket ']'\n" . $herecurr);
+			ERROR("SPACING",
+			      "space prohibited before that close square bracket ']'\n" . $herecurr);
 		}
 
 # check spacing on parentheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
-			ERROR("space prohibited after that open parenthesis '('\n" . $herecurr);
+			ERROR("SPACING",
+			      "space prohibited after that open parenthesis '('\n" . $herecurr);
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/ &&
 		    $line !~ /:\s+\)/) {
-			ERROR("space prohibited before that close parenthesis ')'\n" . $herecurr);
+			ERROR("SPACING",
+			      "space prohibited before that close parenthesis ')'\n" . $herecurr);
 		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
-			WARN("labels should not be indented\n" . $herecurr);
+			WARN("INDENTED_LABEL",
+			     "labels should not be indented\n" . $herecurr);
 		}
 
 # Return is not a function.
@@ -2398,17 +2540,20 @@ sub process {
 			}
 #print "value<$value>\n";
 			if ($value =~ /^\s*(?:$Ident|-?$Constant)\s*$/) {
-				ERROR("return is not a function, parentheses are not required\n" . $herecurr);
+				ERROR("RETURN_PARENTHESES",
+				      "return is not a function, parentheses are not required\n" . $herecurr);
 
 			} elsif ($spacing !~ /\s+/) {
-				ERROR("space required before the open parenthesis '('\n" . $herecurr);
+				ERROR("SPACING",
+				      "space required before the open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Return of what appears to be an errno should normally be -'ve
 		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
 			my $name = $1;
 			if ($name ne 'EOF' && $name ne 'ERROR') {
-				WARN("return of an errno should typically be -ve (return -$1)\n" . $herecurr);
+				WARN("USE_NEGATIVE_ERRNO",
+				     "return of an errno should typically be -ve (return -$1)\n" . $herecurr);
 			}
 		}
 
@@ -2435,7 +2580,7 @@ sub process {
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-			ERROR("space required before the open parenthesis '('\n" . $herecurr);
+			ERROR("SPACING", "space required before the open parenthesis '('\n" . $herecurr);
 		}
 
 # Check for illegal assignment in if conditional -- and check for trailing
@@ -2463,7 +2608,8 @@ sub process {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
-				ERROR("do not use assignment in if condition\n" . $herecurr);
+				ERROR("ASSIGN_IN_IF",
+				      "do not use assignment in if condition\n" . $herecurr);
 			}
 
 			# Find out what is on the end of the line after the
@@ -2485,7 +2631,8 @@ sub process {
 					$stat_real = "[...]\n$stat_real";
 				}
 
-				ERROR("trailing statements should be on next line\n" . $herecurr . $stat_real);
+				ERROR("TRAILING_STATEMENTS",
+				      "trailing statements should be on next line\n" . $herecurr . $stat_real);
 			}
 		}
 
@@ -2501,7 +2648,8 @@ sub process {
 				(?:\&\&|\|\||\)|\])
 			)/x)
 		{
-			WARN("boolean test with hexadecimal, perhaps just 1 \& or \|?\n" . $herecurr);
+			WARN("HEXADECIMAL_BOOLEAN_TEST",
+			     "boolean test with hexadecimal, perhaps just 1 \& or \|?\n" . $herecurr);
 		}
 
 # if and else should not have general statements after it
@@ -2509,12 +2657,14 @@ sub process {
 			my $s = $1;
 			$s =~ s/$;//g; 	# Remove any comments
 			if ($s !~ /^\s*(?:\sif|(?:{|)\s*\\?\s*$)/) {
-				ERROR("trailing statements should be on next line\n" . $herecurr);
+				ERROR("TRAILING_STATEMENTS",
+				      "trailing statements should be on next line\n" . $herecurr);
 			}
 		}
 # if should not continue a brace
 		if ($line =~ /}\s*if\b/) {
-			ERROR("trailing statements should be on next line\n" .
+			ERROR("TRAILING_STATEMENTS",
+			      "trailing statements should be on next line\n" .
 				$herecurr);
 		}
 # case and default should not have general statements after them
@@ -2524,14 +2674,16 @@ sub process {
 			\s*return\s+
 		    )/xg)
 		{
-			ERROR("trailing statements should be on next line\n" . $herecurr);
+			ERROR("TRAILING_STATEMENTS",
+			      "trailing statements should be on next line\n" . $herecurr);
 		}
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
 		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
 						$previndent == $indent) {
-			ERROR("else should follow close brace '}'\n" . $hereprev);
+			ERROR("ELSE_AFTER_BRACE",
+			      "else should follow close brace '}'\n" . $hereprev);
 		}
 
 		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ and
@@ -2544,7 +2696,8 @@ sub process {
 			$s =~ s/\n.*//g;
 
 			if ($s =~ /^\s*;/) {
-				ERROR("while should follow close brace '}'\n" . $hereprev);
+				ERROR("WHILE_AFTER_BRACE",
+				      "while should follow close brace '}'\n" . $hereprev);
 			}
 		}
 
@@ -2557,7 +2710,8 @@ sub process {
 
 #no spaces allowed after \ in define
 		if ($line=~/\#\s*define.*\\\s$/) {
-			WARN("Whitepspace after \\ makes next lines useless\n" . $herecurr);
+			WARN("WHITESPACE_AFTER_LINE_CONTINUATION",
+			     "Whitepspace after \\ makes next lines useless\n" . $herecurr);
 		}
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
@@ -2569,9 +2723,11 @@ sub process {
 			    $1 !~ /$allowed_asm_includes/)
 			{
 				if ($realfile =~ m{^arch/}) {
-					CHK("Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+					CHK("ARCH_INCLUDE_LINUX",
+					    "Consider using #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
 				} else {
-					WARN("Use #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
+					WARN("INCLUDE_LINUX",
+					     "Use #include <linux/$file> instead of <asm/$file>\n" . $herecurr);
 				}
 			}
 		}
@@ -2655,7 +2811,8 @@ sub process {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
 				{
-					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
+					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
+					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
 				}
 
 			} elsif ($ctx !~ /;/) {
@@ -2665,7 +2822,8 @@ sub process {
 				    $dstat !~ /^\.$Ident\s*=/ &&
 				    $dstat =~ /$Operators/)
 				{
-					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
+					ERROR("COMPLEX_MACRO",
+					      "Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
 				}
 			}
 		}
@@ -2676,7 +2834,8 @@ sub process {
 #	ALIGN(...)
 #	VMLINUX_SYMBOL(...)
 		if ($realfile eq 'vmlinux.lds.h' && $line =~ /(?:(?:^|\s)$Ident\s*=|=\s*$Ident(?:\s|$))/) {
-			WARN("vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible symbols\n" . $herecurr);
+			WARN("MISSING_VMLINUX_SYMBOL",
+			     "vmlinux.lds.h needs VMLINUX_SYMBOL() around C-visible symbols\n" . $herecurr);
 		}
 
 # check for redundant bracing round if etc
@@ -2724,7 +2883,8 @@ sub process {
 					}
 				}
 				if ($seen && !$allowed) {
-					WARN("braces {} are not necessary for any arm of this statement\n" . $herectx);
+					WARN("BRACES",
+					     "braces {} are not necessary for any arm of this statement\n" . $herectx);
 				}
 			}
 		}
@@ -2778,33 +2938,38 @@ sub process {
 					$herectx .= raw_line($linenr, $n) . "\n";;
 				}
 
-				WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
+				WARN("BRACES",
+				     "braces {} are not necessary for single statement blocks\n" . $herectx);
 			}
 		}
 
 # don't include deprecated include files (uses RAW line)
 		for my $inc (@dep_includes) {
 			if ($rawline =~ m@^.\s*\#\s*include\s*\<$inc>@) {
-				ERROR("Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
+				ERROR("DEPRECATED_INCLUDE",
+				      "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
 			}
 		}
 
 # don't use deprecated functions
 		for my $func (@dep_functions) {
 			if ($line =~ /\b$func\b/) {
-				ERROR("Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
+				ERROR("DEPRECATED_FUNCTION",
+				      "Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
 			}
 		}
 
 # no volatiles please
 		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
 		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {
-			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
+			WARN("VOLATILE",
+			     "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
-			CHK("if this code is redundant consider removing it\n" .
+			CHK("REDUNDANT_CODE",
+			    "if this code is redundant consider removing it\n" .
 				$herecurr);
 		}
 
@@ -2812,14 +2977,16 @@ sub process {
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
 			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("kfree(NULL) is safe this check is probably not required\n" . $hereprev);
+				WARN("NEEDLESS_KFREE",
+				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 # check for needless usb_free_urb() checks
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
 			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
-				WARN("usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
+				WARN("NEEDLESS_USB_FREE_URB",
+				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 
@@ -2827,14 +2994,16 @@ sub process {
 		if ($line =~ /\budelay\s*\(\s*(\w+)\s*\)/) {
 			# ignore udelay's < 10, however
 			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
-				CHK("usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
+				CHK("USLEEP_RANGE",
+				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
 			}
 		}
 
 # warn about unexpectedly long msleep's
 		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
 			if ($1 < 20) {
-				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
+				WARN("MSLEEP",
+				     "msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
 			}
 		}
 
@@ -2847,7 +3016,8 @@ sub process {
 
 # warn about spacing in #ifdefs
 		if ($line =~ /^.\s*\#\s*(ifdef|ifndef|elif)\s\s+/) {
-			ERROR("exactly one space required after that #$1\n" . $herecurr);
+			ERROR("SPACING",
+			      "exactly one space required after that #$1\n" . $herecurr);
 		}
 
 # check for spinlock_t definitions without a comment.
@@ -2855,55 +3025,65 @@ sub process {
 		    $line =~ /^.\s*(DEFINE_MUTEX)\s*\(/) {
 			my $which = $1;
 			if (!ctx_has_comment($first_line, $linenr)) {
-				CHK("$1 definition without comment\n" . $herecurr);
+				CHK("UNCOMMENTED_DEFINITION",
+				    "$1 definition without comment\n" . $herecurr);
 			}
 		}
 # check for memory barriers without a comment.
 		if ($line =~ /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/) {
 			if (!ctx_has_comment($first_line, $linenr)) {
-				CHK("memory barrier without comment\n" . $herecurr);
+				CHK("MEMORY_BARRIER",
+				    "memory barrier without comment\n" . $herecurr);
 			}
 		}
 # check of hardware specific defines
 		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
-			CHK("architecture specific defines should be avoided\n" .  $herecurr);
+			CHK("ARCH_DEFINES",
+			    "architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
 # Check that the storage class is at the beginning of a declaration
 		if ($line =~ /\b$Storage\b/ && $line !~ /^.\s*$Storage\b/) {
-			WARN("storage class should be at the beginning of the declaration\n" . $herecurr)
+			WARN("STORAGE_CLASS",
+			     "storage class should be at the beginning of the declaration\n" . $herecurr)
 		}
 
 # check the location of the inline attribute, that it is between
 # storage class and type.
 		if ($line =~ /\b$Type\s+$Inline\b/ ||
 		    $line =~ /\b$Inline\s+$Storage\b/) {
-			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
+			ERROR("INLINE_LOCATION",
+			      "inline keyword should sit between storage class and type\n" . $herecurr);
 		}
 
 # Check for __inline__ and __inline, prefer inline
 		if ($line =~ /\b(__inline__|__inline)\b/) {
-			WARN("plain inline is preferred over $1\n" . $herecurr);
+			WARN("INLINE",
+			     "plain inline is preferred over $1\n" . $herecurr);
 		}
 
 # Check for __attribute__ packed, prefer __packed
 		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
-			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
+			WARN("PREFER_PACKED",
+			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
 # Check for __attribute__ aligned, prefer __aligned
 		if ($line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
-			WARN("__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
+			WARN("PREFER_ALIGNED",
+			     "__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
 		}
 
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
-			WARN("sizeof(& should be avoided\n" . $herecurr);
+			WARN("SIZEOF_ADDRESS",
+			     "sizeof(& should be avoided\n" . $herecurr);
 		}
 
 # check for line continuations in quoted strings with odd counts of "
 		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
-			WARN("Avoid line continuations in quoted strings\n" . $herecurr);
+			WARN("LINE_CONTINUATIONS",
+			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
 # check for new externs in .c files.
@@ -2920,17 +3100,20 @@ sub process {
 			if ($s =~ /^\s*;/ &&
 			    $function_name ne 'uninitialized_var')
 			{
-				WARN("externs should be avoided in .c files\n" .  $herecurr);
+				WARN("AVOID_EXTERNS",
+				     "externs should be avoided in .c files\n" .  $herecurr);
 			}
 
 			if ($paren_space =~ /\n/) {
-				WARN("arguments for function declarations should follow identifier\n" . $herecurr);
+				WARN("FUNCTION_ARGUMENTS",
+				     "arguments for function declarations should follow identifier\n" . $herecurr);
 			}
 
 		} elsif ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*extern\s+/)
 		{
-			WARN("externs should be avoided in .c files\n" .  $herecurr);
+			WARN("AVOID_EXTERNS",
+			     "externs should be avoided in .c files\n" .  $herecurr);
 		}
 
 # checks for new __setup's
@@ -2938,37 +3121,44 @@ sub process {
 			my $name = $1;
 
 			if (!grep(/$name/, @setup_docs)) {
-				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
+				CHK("UNDOCUMENTED_SETUP",
+				    "__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
 			}
 		}
 
 # check for pointless casting of kmalloc return
 		if ($line =~ /\*\s*\)\s*[kv][czm]alloc(_node){0,1}\b/) {
-			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
+			WARN("UNNECESSARY_CASTS",
+			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
-		    WARN("Statements terminations use 1 semicolon\n" . $herecurr);
+		    WARN("ONE_SEMICOLON",
+			 "Statements terminations use 1 semicolon\n" . $herecurr);
 		}
 
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
-			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
+			WARN("USE_FUNC",
+			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
-			WARN("consider using a completion\n" . $herecurr);
+			WARN("CONSIDER_COMPLETION",
+			     "consider using a completion\n" . $herecurr);
 
 		}
 # recommend kstrto* over simple_strto*
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
-			WARN("consider using kstrto* in preference to simple_$1\n" . $herecurr);
+			WARN("CONSIDER_KSTRTO",
+			     "consider using kstrto* in preference to simple_$1\n" . $herecurr);
 		}
 # check for __initcall(), use device_initcall() explicitly please
 		if ($line =~ /^.\s*__initcall\s*\(/) {
-			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
+			WARN("USE_DEVICE_INITCALL",
+			     "please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
 # check for various ops structs, ensure they are const.
 		my $struct_ops = qr{acpi_dock_ops|
@@ -3010,7 +3200,8 @@ sub process {
 				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
 		    $line =~ /\bstruct\s+($struct_ops)\b/) {
-			WARN("struct $1 should normally be const\n" .
+			WARN("CONST_STRUCT",
+			     "struct $1 should normally be const\n" .
 				$herecurr);
 		}
 
@@ -3023,7 +3214,8 @@ sub process {
 		    $line !~ /\[[^\]]*\.\.\.[^\]]*NR_CPUS[^\]]*\]/ &&
 		    $line !~ /\[[^\]]*NR_CPUS[^\]]*\.\.\.[^\]]*\]/)
 		{
-			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
+			WARN("NR_CPUS",
+			     "usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
 
 # check for %L{u,d,i} in strings
@@ -3032,7 +3224,8 @@ sub process {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
 			$string =~ s/%%/__/g;
 			if ($string =~ /(?<!%)%L[udi]/) {
-				WARN("\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
+				WARN("PRINTF_L",
+				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
 				last;
 			}
 		}
@@ -3040,9 +3233,11 @@ sub process {
 # whine mightly about in_atomic
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {
-				ERROR("do not use in_atomic in drivers\n" . $herecurr);
+				ERROR("IN_ATOMIC",
+				      "do not use in_atomic in drivers\n" . $herecurr);
 			} elsif ($realfile !~ m@^kernel/@) {
-				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
+				WARN("IN_ATOMIC",
+				     "use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
 			}
 		}
 
@@ -3052,18 +3247,21 @@ sub process {
 			if ($realfile !~ m@^kernel/lockdep@ &&
 			    $realfile !~ m@^include/linux/lockdep@ &&
 			    $realfile !~ m@^drivers/base/core@) {
-				ERROR("lockdep_no_validate class is reserved for device->mutex.\n" . $herecurr);
+				ERROR("LOCKDEP",
+				      "lockdep_no_validate class is reserved for device->mutex.\n" . $herecurr);
 			}
 		}
 
 		if ($line =~ /debugfs_create_file.*S_IWUGO/ ||
 		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
-			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
+			WARN("EXPORTED_WORLD_WRITABLE",
+			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
 
 		# Check for memset with swapped arguments
 		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
-			ERROR("memset size is 3rd argument, not the second.\n" . $herecurr);
+			ERROR("MEMSET",
+			      "memset size is 3rd argument, not the second.\n" . $herecurr);
 		}
 	}
 
@@ -3086,10 +3284,12 @@ sub process {
 	}
 
 	if (!$is_patch) {
-		ERROR("Does not appear to be a unified-diff format patch\n");
+		ERROR("NOT_UNIFIED_DIFF",
+		      "Does not appear to be a unified-diff format patch\n");
 	}
 	if ($is_patch && $chk_signoff && $signoff == 0) {
-		ERROR("Missing Signed-off-by: line(s)\n");
+		ERROR("MISSING_SIGN_OFF",
+		      "Missing Signed-off-by: line(s)\n");
 	}
 
 	print report_dump();
@@ -3111,13 +3311,25 @@ sub process {
 		}
 	}
 
+	if (keys %ignore_type) {
+	    print "NOTE: Ignored message types:";
+	    foreach my $ignore (sort keys %ignore_type) {
+		print " $ignore";
+	    }
+	    print "\n";
+	    print "\n" if ($quiet == 0);
+	}
+
 	if ($clean == 1 && $quiet == 0) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
 	if ($clean == 0 && $quiet == 0) {
-		print "$vname has style problems, please review.  If any of these errors\n";
-		print "are false positives report them to the maintainer, see\n";
-		print "CHECKPATCH in MAINTAINERS.\n";
+		print << "EOM";
+$vname has style problems, please review.
+
+If any of these errors are false positives, please report
+them to the maintainer, see CHECKPATCH in MAINTAINERS.
+EOM
 	}
 
 	return $clean;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
get_maintainerspl-improve-mailmap-parsing.patch
maintainers-update-high-resolution-timers-patterns.patch
maintainers-remove-section-usb-se401-driver.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch
checkpatch-add-a-prefer-__aligned-check.patch
checkpatchpl-add-ability-to-ignore-various-messages.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

