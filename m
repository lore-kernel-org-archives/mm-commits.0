From: akpm@linux-foundation.org
Subject: + checkpatch-add-fix-option-for-assign_in_if.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 13:21:17 -0700
Message-ID: <20200624202117.4uCz9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391392AbgFXUVT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 16:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com


The patch titled
     Subject: checkpatch: add --fix option for ASSIGN_IN_IF
has been added to the -mm tree.  Its filename is
     checkpatch-add-fix-option-for-assign_in_if.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-fix-option-for-assign_in_if.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-fix-option-for-assign_in_if.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --fix option for ASSIGN_IN_IF

Add a --fix option for 2 types of single-line assignment in if statements

	if ((foo = bar(...)) < BAZ) {
expands to:
	foo = bar(..);
	if (foo < BAZ) {
and
	if ((foo = bar(...)) {
expands to:
	foo = bar(...);
	if (foo) {

if statements with assignments spanning multiple lines are
not converted with the --fix option.

if statements with additional logic are also not converted.

e.g.:	if ((foo = bar(...)) & BAZ == BAZ) {

Link: http://lkml.kernel.org/r/9bc7c782516f37948f202deba511bc95ed279bbd.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-assign_in_if
+++ a/scripts/checkpatch.pl
@@ -5053,8 +5053,30 @@ sub process {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
-				ERROR("ASSIGN_IN_IF",
-				      "do not use assignment in if condition\n" . $herecurr);
+				if (ERROR("ASSIGN_IN_IF",
+					  "do not use assignment in if condition\n" . $herecurr) &&
+				    $fix && $perl_version_ok) {
+					if ($rawline =~ /^\+(\s+)if\s*\(\s*(\!)?\s*\(\s*(($Lval)\s*=\s*$LvalOrFunc)\s*\)\s*(?:($Compare)\s*($FuncArg))?\s*\)\s*(\{)?\s*$/) {
+						my $space = $1;
+						my $not = $2;
+						my $statement = $3;
+						my $assigned = $4;
+						my $test = $8;
+						my $against = $9;
+						my $brace = $15;
+						fix_delete_line($fixlinenr, $rawline);
+						fix_insert_line($fixlinenr, "$space$statement;");
+						my $newline = "${space}if (";
+						$newline .= '!' if defined($not);
+						$newline .= '(' if (defined $not && defined($test) && defined($against));
+						$newline .= "$assigned";
+						$newline .= " $test $against" if (defined($test) && defined($against));
+						$newline .= ')' if (defined $not && defined($test) && defined($against));
+						$newline .= ')';
+						$newline .= " {" if (defined($brace));
+						fix_insert_line($fixlinenr + 1, $newline);
+					}
+				}
 			}
 
 			# Find out what is on the end of the line after the
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
checkpatch-add-fix-option-for-assign_in_if.patch
