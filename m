From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-command-line-option-for-tab-size.patch
 added to -mm tree
Date: Mon, 24 Feb 2020 15:40:03 -0800
Message-ID: <20200224234003.88Nf1RU_P%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBXXkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 18:40:05 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borneo.antonio@gmail.com, erik.ahlen@avalonenterprise.com, joe@perches.com, mm-commits@vger.kernel.org, spen@spen-soft.co.uk


The patch titled
     Subject: checkpatch: add command-line option for TAB size
has been added to the -mm tree.  Its filename is
     checkpatch-add-command-line-option-for-tab-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-command-line-op=
tion-for-tab-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-command-line-op=
tion-for-tab-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1253,7 +1259,7 @@ sub expand_tabs {
 		if ($c eq "\t") {
 			$res .=3D ' ';
 			$n++;
-			for (; ($n % 8) !=3D 0; $n++) {
+			for (; ($n % $tabsize) !=3D 0; $n++) {
 				$res .=3D ' ';
 			}
 			next;
@@ -2266,7 +2272,7 @@ sub string_find_replace {
 sub tabify {
 	my ($leading) =3D @_;
=20
-	my $source_indent =3D 8;
+	my $source_indent =3D $tabsize;
 	my $max_spaces_before_tab =3D $source_indent - 1;
 	my $spaces_to_tab =3D " " x $source_indent;
=20
@@ -3245,7 +3251,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
=20
 # at the beginning of a line any tabs must come first and anything
-# more than 8 must use tabs.
+# more than $tabsize must use tabs.
 		if ($rawline =3D~ /^\+\s* \t\s*\S/ ||
 		    $rawline =3D~ /^\+\s*        \s*/) {
 			my $herevet =3D "$here\n" . cat_vet($rawline) . "\n";
@@ -3264,7 +3270,7 @@ sub process {
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
 				while ($fixed[$fixlinenr] =3D~
-					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
+					   s/(^\+.*) {$tabsize,$tabsize}\t/$1\t\t/) {}
 				while ($fixed[$fixlinenr] =3D~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
@@ -3286,11 +3292,11 @@ sub process {
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
@@ -3308,8 +3314,8 @@ sub process {
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
@@ -3780,11 +3786,11 @@ sub process {
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

Patches currently in -mm which might be from borneo.antonio@gmail.com are

checkpatch-fix-minor-typo-and-mixed-spacetab-in-indentation.patch
checkpatch-fix-multiple-const-types.patch
checkpatch-add-command-line-option-for-tab-size.patch
