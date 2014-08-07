From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-an-index-variable-for-fixed-lines.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:09:13 -0700
Message-ID: <53e3dce9.5jJag456XGO6a1+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:41683 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:14 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1179007pab.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add an index variable for fixed lines
has been removed from the -mm tree.  Its filename was
     checkpatch-add-an-index-variable-for-fixed-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add an index variable for fixed lines

Make the fix code a bit easier to read.

This should also start to allow an easier mechanism to insert/delete
lines eventually too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  114 +++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 54 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-an-index-variable-for-fixed-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-an-index-variable-for-fixed-lines
+++ a/scripts/checkpatch.pl
@@ -583,6 +583,8 @@ $chk_signoff = 0 if ($file);
 my @rawlines = ();
 my @lines = ();
 my @fixed = ();
+my $fixlinenr = -1;
+
 my $vname;
 for my $filename (@ARGV) {
 	my $FILE;
@@ -611,6 +613,7 @@ for my $filename (@ARGV) {
 	@rawlines = ();
 	@lines = ();
 	@fixed = ();
+	$fixlinenr = -1;
 }
 
 exit($exit);
@@ -1801,8 +1804,10 @@ sub process {
 
 	$realcnt = 0;
 	$linenr = 0;
+	$fixlinenr = -1;
 	foreach my $line (@lines) {
 		$linenr++;
+		$fixlinenr++;
 		my $sline = $line;	#copy of $line
 		$sline =~ s/$;/ /g;	#with comments as spaces
 
@@ -1933,7 +1938,7 @@ sub process {
 				if (WARN("BAD_SIGN_OFF",
 					 "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =
+					$fixed[$fixlinenr] =
 					    "$ucfirst_sign_off $email";
 				}
 			}
@@ -1941,7 +1946,7 @@ sub process {
 				if (WARN("BAD_SIGN_OFF",
 					 "'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =
+					$fixed[$fixlinenr] =
 					    "$ucfirst_sign_off $email";
 				}
 
@@ -1950,7 +1955,7 @@ sub process {
 				if (WARN("BAD_SIGN_OFF",
 					 "Use a single space after $ucfirst_sign_off\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =
+					$fixed[$fixlinenr] =
 					    "$ucfirst_sign_off $email";
 				}
 			}
@@ -2089,14 +2094,14 @@ sub process {
 			if (ERROR("DOS_LINE_ENDINGS",
 				  "DOS line endings\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/[\s\015]+$//;
+				$fixed[$fixlinenr] =~ s/[\s\015]+$//;
 			}
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			if (ERROR("TRAILING_WHITESPACE",
 				  "trailing whitespace\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\s+$//;
+				$fixed[$fixlinenr] =~ s/\s+$//;
 			}
 
 			$rpt_cleaners = 1;
@@ -2235,7 +2240,7 @@ sub process {
 			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
 				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
+				$fixed[$fixlinenr] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
 			}
 
 		}
@@ -2272,7 +2277,7 @@ sub process {
 			if (ERROR("CODE_INDENT",
 				  "code indent should use tabs where possible\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+				$fixed[$fixlinenr] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
 			}
 		}
 
@@ -2282,9 +2287,9 @@ sub process {
 			if (WARN("SPACE_BEFORE_TAB",
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
-				while ($fixed[$linenr - 1] =~
+				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
-				while ($fixed[$linenr - 1] =~
+				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
 		}
@@ -2318,7 +2323,7 @@ sub process {
 					if (CHK("PARENTHESIS_ALIGNMENT",
 						"Alignment should match open parenthesis\n" . $hereprev) &&
 					    $fix && $line =~ /^\+/) {
-						$fixed[$linenr - 1] =~
+						$fixed[$fixlinenr] =~
 						    s/^\+[ \t]*/\+$goodtabindent/;
 					}
 				}
@@ -2329,7 +2334,7 @@ sub process {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/(\(\s*$Type\s*\))[ \t]+/$1/;
 			}
 		}
@@ -2433,7 +2438,7 @@ sub process {
 			if (WARN("LEADING_SPACE",
 				 "please, no spaces at the start of a line\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+				$fixed[$fixlinenr] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
 			}
 		}
 
@@ -2798,10 +2803,10 @@ sub process {
 			if (ERROR("C99_COMMENTS",
 				  "do not use C99 // comments\n" . $herecurr) &&
 			    $fix) {
-				my $line = $fixed[$linenr - 1];
+				my $line = $fixed[$fixlinenr];
 				if ($line =~ /\/\/(.*)$/) {
 					my $comment = trim($1);
-					$fixed[$linenr - 1] =~ s@\/\/(.*)$@/\* $comment \*/@;
+					$fixed[$fixlinenr] =~ s@\/\/(.*)$@/\* $comment \*/@;
 				}
 			}
 		}
@@ -2860,7 +2865,7 @@ sub process {
 				  "do not initialise globals to 0 or NULL\n" .
 				      $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/($Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/($Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/$1;/;
 			}
 		}
 # check for static initialisers.
@@ -2869,7 +2874,7 @@ sub process {
 				  "do not initialise statics to 0 or NULL\n" .
 				      $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(\bstatic\s.*?)\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/(\bstatic\s.*?)\s*=\s*(0|NULL|false)\s*;/$1;/;
 			}
 		}
 
@@ -2899,7 +2904,7 @@ sub process {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",
 				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
+				$fixed[$fixlinenr] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
 			}
 		}
 
@@ -2908,7 +2913,7 @@ sub process {
 			if (WARN("DEFINE_PCI_DEVICE_TABLE",
 				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
+				$fixed[$fixlinenr] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
 			}
 		}
 
@@ -2945,7 +2950,7 @@ sub process {
 					my $sub_from = $ident;
 					my $sub_to = $ident;
 					$sub_to =~ s/\Q$from\E/$to/;
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s@\Q$sub_from\E@$sub_to@;
 				}
 			}
@@ -2973,7 +2978,7 @@ sub process {
 					my $sub_from = $match;
 					my $sub_to = $match;
 					$sub_to =~ s/\Q$from\E/$to/;
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s@\Q$sub_from\E@$sub_to@;
 				}
 			}
@@ -3035,7 +3040,7 @@ sub process {
 			if (WARN("PREFER_PR_LEVEL",
 				 "Prefer pr_warn(... to pr_warning(...\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\bpr_warning\b/pr_warn/;
 			}
 		}
@@ -3069,7 +3074,7 @@ sub process {
 			if (WARN("SPACING",
 				 "missing space after $1 definition\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.\s*(?:typedef\s+)?(?:enum|union|struct)(?:\s+$Ident){1,2})([=\{])/$1 $2/;
 			}
 		}
@@ -3139,7 +3144,7 @@ sub process {
 			}
 
 			if (show_type("SPACING") && $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.\s*)$Declare\s*\(\s*\*\s*$Ident\s*\)\s*\(/$1 . $declare . $post_declare_space . '(*' . $funcname . ')('/ex;
 			}
 		}
@@ -3156,7 +3161,7 @@ sub process {
 				if (ERROR("BRACKET_SPACE",
 					  "space prohibited before open square bracket '['\n" . $herecurr) &&
 				    $fix) {
-				    $fixed[$linenr - 1] =~
+				    $fixed[$fixlinenr] =~
 					s/^(\+.*?)\s+\[/$1\[/;
 				}
 			}
@@ -3191,7 +3196,7 @@ sub process {
 				if (WARN("SPACING",
 					 "space prohibited between function name and open parenthesis '('\n" . $herecurr) &&
 					     $fix) {
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s/\b$name\s+\(/$name\(/;
 				}
 			}
@@ -3459,8 +3464,8 @@ sub process {
 				$fixed_line = $fixed_line . $fix_elements[$#elements];
 			}
 
-			if ($fix && $line_fixed && $fixed_line ne $fixed[$linenr - 1]) {
-				$fixed[$linenr - 1] = $fixed_line;
+			if ($fix && $line_fixed && $fixed_line ne $fixed[$fixlinenr]) {
+				$fixed[$fixlinenr] = $fixed_line;
 			}
 
 
@@ -3471,7 +3476,7 @@ sub process {
 			if (WARN("SPACING",
 				 "space prohibited before semicolon\n" . $herecurr) &&
 			    $fix) {
-				1 while $fixed[$linenr - 1] =~
+				1 while $fixed[$fixlinenr] =~
 				    s/^(\+.*\S)\s+;/$1;/;
 			}
 		}
@@ -3504,7 +3509,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^(\+.*(?:do|\))){/$1 {/;
+				$fixed[$fixlinenr] =~ s/^(\+.*(?:do|\))){/$1 {/;
 			}
 		}
 
@@ -3522,7 +3527,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required after that close brace '}'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/}((?!(?:,|;|\)))\S)/} $1/;
 			}
 		}
@@ -3532,7 +3537,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited after that open square bracket '['\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\[\s+/\[/;
 			}
 		}
@@ -3540,7 +3545,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close square bracket ']'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\s+\]/\]/;
 			}
 		}
@@ -3551,7 +3556,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited after that open parenthesis '('\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\(\s+/\(/;
 			}
 		}
@@ -3561,7 +3566,8 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close parenthesis ')'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				print("fixlinenr: <$fixlinenr> fixed[fixlinenr]: <$fixed[$fixlinenr]>\n");
+				$fixed[$fixlinenr] =~
 				    s/\s+\)/\)/;
 			}
 		}
@@ -3580,7 +3586,7 @@ sub process {
 			if (WARN("INDENTED_LABEL",
 				 "labels should not be indented\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.)\s+/$1/;
 			}
 		}
@@ -3642,7 +3648,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open parenthesis '('\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\b(if|while|for|switch)\(/$1 \(/;
 			}
 		}
@@ -3779,7 +3785,7 @@ sub process {
 					 "Avoid gcc v4.3+ binary constant extension: <$var>\n" . $herecurr) &&
 				    $fix) {
 					my $hexval = sprintf("0x%x", oct($var));
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s/\b$var\b/$hexval/;
 				}
 			}
@@ -3815,7 +3821,7 @@ sub process {
 			if (WARN("WHITESPACE_AFTER_LINE_CONTINUATION",
 				 "Whitespace after \\ makes next lines useless\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\s+$//;
+				$fixed[$fixlinenr] =~ s/\s+$//;
 			}
 		}
 
@@ -4170,7 +4176,7 @@ sub process {
 				      WARN("MISPLACED_INIT",
 					   "$attr should be placed after $var\n" . $herecurr))) &&
 				    $fix) {
-					$fixed[$linenr - 1] =~ s/(\bstatic\s+(?:const\s+)?)(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*([=;])\s*/"$1" . trim(string_find_replace($2, "\\s*$attr\\s*", " ")) . " " . trim(string_find_replace($3, "\\s*$attr\\s*", "")) . " $attr" . ("$4" eq ";" ? ";" : " = ")/e;
+					$fixed[$fixlinenr] =~ s/(\bstatic\s+(?:const\s+)?)(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*([=;])\s*/"$1" . trim(string_find_replace($2, "\\s*$attr\\s*", " ")) . " " . trim(string_find_replace($3, "\\s*$attr\\s*", "")) . " $attr" . ("$4" eq ";" ? ";" : " = ")/e;
 				}
 			}
 		}
@@ -4184,7 +4190,7 @@ sub process {
 			if (ERROR("INIT_ATTRIBUTE",
 				  "Use of const init definition must use ${attr_prefix}initconst\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/$InitAttributeData/${attr_prefix}initconst/;
 			}
 		}
@@ -4195,12 +4201,12 @@ sub process {
 			if (ERROR("INIT_ATTRIBUTE",
 				  "Use of $attr requires a separate use of const\n" . $herecurr) &&
 			    $fix) {
-				my $lead = $fixed[$linenr - 1] =~
+				my $lead = $fixed[$fixlinenr] =~
 				    /(^\+\s*(?:static\s+))/;
 				$lead = rtrim($1);
 				$lead = "$lead " if ($lead !~ /^\+$/);
 				$lead = "${lead}const ";
-				$fixed[$linenr - 1] =~ s/(^\+\s*(?:static\s+))/$lead/;
+				$fixed[$fixlinenr] =~ s/(^\+\s*(?:static\s+))/$lead/;
 			}
 		}
 
@@ -4213,7 +4219,7 @@ sub process {
 			if (WARN("CONSTANT_CONVERSION",
 				 "$constant_func should be $func\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b$constant_func\b/$func/g;
+				$fixed[$fixlinenr] =~ s/\b$constant_func\b/$func/g;
 			}
 		}
 
@@ -4263,7 +4269,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "exactly one space required after that #$1\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.\s*\#\s*(ifdef|ifndef|elif))\s{2,}/$1 /;
 			}
 
@@ -4311,7 +4317,7 @@ sub process {
 			if (WARN("INLINE",
 				 "plain inline is preferred over $1\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b(__inline__|__inline)\b/inline/;
+				$fixed[$fixlinenr] =~ s/\b(__inline__|__inline)\b/inline/;
 
 			}
 		}
@@ -4336,7 +4342,7 @@ sub process {
 			if (WARN("PREFER_PRINTF",
 				 "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.*)\)\s*\)\s*\)/"__printf(" . trim($1) . ")"/ex;
+				$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.*)\)\s*\)\s*\)/"__printf(" . trim($1) . ")"/ex;
 
 			}
 		}
@@ -4347,7 +4353,7 @@ sub process {
 			if (WARN("PREFER_SCANF",
 				 "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\s*,\s*(.*)\)\s*\)\s*\)/"__scanf(" . trim($1) . ")"/ex;
+				$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\s*,\s*(.*)\)\s*\)\s*\)/"__scanf(" . trim($1) . ")"/ex;
 			}
 		}
 
@@ -4362,7 +4368,7 @@ sub process {
 			if (WARN("SIZEOF_PARENTHESIS",
 				 "sizeof $1 should be sizeof($1)\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/"sizeof(" . trim($1) . ")"/ex;
+				$fixed[$fixlinenr] =~ s/\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/"sizeof(" . trim($1) . ")"/ex;
 			}
 		}
 
@@ -4385,7 +4391,7 @@ sub process {
 				if (WARN("PREFER_SEQ_PUTS",
 					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =~ s/\bseq_printf\b/seq_puts/;
+					$fixed[$fixlinenr] =~ s/\bseq_printf\b/seq_puts/;
 				}
 			}
 		}
@@ -4414,7 +4420,7 @@ sub process {
 			if (WARN("PREFER_ETHER_ADDR_COPY",
 				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
+				$fixed[$fixlinenr] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
 			}
 		}
 
@@ -4502,7 +4508,7 @@ sub process {
 			if (CHK("AVOID_EXTERNS",
 				"extern prototypes should be avoided in .h files\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
+				$fixed[$fixlinenr] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
 			}
 		}
 
@@ -4579,7 +4585,7 @@ sub process {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
 
 				}
 			}
@@ -4603,7 +4609,7 @@ sub process {
 			if (WARN("ONE_SEMICOLON",
 				 "Statements terminations use 1 semicolon\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(\s*;\s*){2,}$/;/g;
+				$fixed[$fixlinenr] =~ s/(\s*;\s*){2,}$/;/g;
 			}
 		}
 
@@ -4651,7 +4657,7 @@ sub process {
 			if (WARN("USE_FUNC",
 				 "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b__FUNCTION__\b/__func__/g;
+				$fixed[$fixlinenr] =~ s/\b__FUNCTION__\b/__func__/g;
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
maintainers-remove-two-ancient-eata-sections.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-nomadik-patterns.patch

