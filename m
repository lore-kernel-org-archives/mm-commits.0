From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 133/166] checkpatch: add command-line option for
 TAB size
Date: Mon, 06 Apr 2020 20:11:07 -0700
Message-ID: <20200407031107.XWCzbK77b%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgDGDLJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:09 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, borneo.antonio@gmail.com, erik.ahlen@avalonenterprise.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, spen@spen-soft.co.uk, torvalds@linux-foundation.org

=46rom: Antonio Borneo <borneo.antonio@gmail.com>
Subject: checkpatch: add command-line option for TAB size

Linux kernel coding style requires a size of 8 characters for both TAB and
indentation, and such value is embedded as magic value allover the
checkpatch script.

This makes hard to reuse the script by other projects with different
requirements in their coding style (e.g.  OpenOCD [1] requires TAB size of
4 characters [2]).

Replace the magic value 8 with a variable.

Add a command-line option "--tab-size" to let the user select a
TAB size value other than 8.

[1] http://openocd.org/
[2] http://openocd.org/doc/doxygen/html/stylec.html#styleformat

Link: http://lkml.kernel.org/r/20200122163852.124417-3-borneo.antonio@gmail=
.com
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
Signed-off-by: Erik Ahl=C3=A9n <erik.ahlen@avalonenterprise.com>
Signed-off-by: Spencer Oliver <spen@spen-soft.co.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-command-line-option-for-tab-size
+++ a/scripts/checkpatch.pl
@@ -64,6 +64,7 @@ my $color =3D "auto";
 my $allow_c99_comments =3D 1; # Can be overridden by --ignore C99_COMMENT_=
TOLERANCE
 # git output parsing needs US English output, so first set backtick child =
process LANGUAGE
 my $git_command =3D'export LANGUAGE=3Den_US.UTF-8; git';
+my $tabsize =3D 8;
=20
 sub help {
 	my ($exitcode) =3D @_;
@@ -98,6 +99,7 @@ Options:
   --show-types               show the specific message type in the output
   --max-line-length=3Dn        set the maximum line length, if exceeded, w=
arn
   --min-conf-desc-length=3Dn   set the min description length, if shorter,=
 warn
+  --tab-size=3Dn               set the number of spaces for tab (default 8)
   --root=3DPATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
   --mailback                 only produce a report in case of warnings/err=
ors
@@ -215,6 +217,7 @@ GetOptions(
 	'list-types!'	=3D> \$list_types,
 	'max-line-length=3Di' =3D> \$max_line_length,
 	'min-conf-desc-length=3Di' =3D> \$min_conf_desc_length,
+	'tab-size=3Di'	=3D> \$tabsize,
 	'root=3Ds'	=3D> \$root,
 	'summary!'	=3D> \$summary,
 	'mailback!'	=3D> \$mailback,
@@ -267,6 +270,9 @@ if ($color =3D~ /^[01]$/) {
 	die "Invalid color mode: $color\n";
 }
=20
+# skip TAB size 1 to avoid additional checks on $tabsize - 1
+die "Invalid TAB size: $tabsize\n" if ($tabsize < 2);
+
 sub hash_save_array_words {
 	my ($hashRef, $arrayRef) =3D @_;
=20
@@ -1239,7 +1245,7 @@ sub expand_tabs {
 		if ($c eq "\t") {
 			$res .=3D ' ';
 			$n++;
-			for (; ($n % 8) !=3D 0; $n++) {
+			for (; ($n % $tabsize) !=3D 0; $n++) {
 				$res .=3D ' ';
 			}
 			next;
@@ -2252,7 +2258,7 @@ sub string_find_replace {
 sub tabify {
 	my ($leading) =3D @_;
=20
-	my $source_indent =3D 8;
+	my $source_indent =3D $tabsize;
 	my $max_spaces_before_tab =3D $source_indent - 1;
 	my $spaces_to_tab =3D " " x $source_indent;
=20
@@ -3231,7 +3237,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
=20
 # at the beginning of a line any tabs must come first and anything
-# more than 8 must use tabs.
+# more than $tabsize must use tabs.
 		if ($rawline =3D~ /^\+\s* \t\s*\S/ ||
 		    $rawline =3D~ /^\+\s*        \s*/) {
 			my $herevet =3D "$here\n" . cat_vet($rawline) . "\n";
@@ -3250,7 +3256,7 @@ sub process {
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
 				while ($fixed[$fixlinenr] =3D~
-					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
+					   s/(^\+.*) {$tabsize,$tabsize}\t/$1\t\t/) {}
 				while ($fixed[$fixlinenr] =3D~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
@@ -3272,11 +3278,11 @@ sub process {
 		if ($perl_version_ok &&
 		    $sline =3D~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|whil=
e\b|\s*$)|$Declare\s*$Ident\s*[;=3D])/) {
 			my $indent =3D length($1);
-			if ($indent % 8) {
+			if ($indent % $tabsize) {
 				if (WARN("TABSTOP",
 					 "Statements should start on a tabstop\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$fixlinenr] =3D~ s@(^\+\t+) +@$1 . "\t" x ($indent/8)@e;
+					$fixed[$fixlinenr] =3D~ s@(^\+\t+) +@$1 . "\t" x ($indent/$tabsize)@e;
 				}
 			}
 		}
@@ -3294,8 +3300,8 @@ sub process {
 				my $newindent =3D $2;
=20
 				my $goodtabindent =3D $oldindent .
-					"\t" x ($pos / 8) .
-					" "  x ($pos % 8);
+					"\t" x ($pos / $tabsize) .
+					" "  x ($pos % $tabsize);
 				my $goodspaceindent =3D $oldindent . " "  x $pos;
=20
 				if ($newindent ne $goodtabindent &&
@@ -3766,11 +3772,11 @@ sub process {
 			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sinden=
t> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> =
stat_real<$stat_real> stat<$stat>\n";
=20
 			if ($check && $s ne '' &&
-			    (($sindent % 8) !=3D 0 ||
+			    (($sindent % $tabsize) !=3D 0 ||
 			     ($sindent < $indent) ||
 			     ($sindent =3D=3D $indent &&
 			      ($s !~ /^\s*(?:\}|\{|else\b)/)) ||
-			     ($sindent > $indent + 8))) {
+			     ($sindent > $indent + $tabsize))) {
 				WARN("SUSPECT_CODE_INDENT",
 				     "suspect code indent for conditional statements ($indent, $sinden=
t)\n" . $herecurr . "$stat_real\n");
 			}
_
