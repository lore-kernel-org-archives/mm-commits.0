From: akpm@linux-foundation.org
Subject: + checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:40 -0700
Message-ID: <201008182025.o7IKPebT010370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab0HRU0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: statement/block context analyser should look at sanitised lines
has been added to the -mm tree.  Its filename is
     checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines.patch

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
Subject: checkpatch: statement/block context analyser should look at sanitised lines
From: Andy Whitcroft <apw@canonical.com>

When tracking context to find a block or statement we need to use the
sanitised lines, else perentheses '(' & ')' and braces '{' & '}' can throw
the scanner out.  Also fix up a couple of error outputs which include
those sanitised lines incorrectly.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines
+++ a/scripts/checkpatch.pl
@@ -691,15 +691,15 @@ sub ctx_block_get {
 		$blk .= $rawlines[$line];
 
 		# Handle nested #if/#else.
-		if ($rawlines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
+		if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
 			push(@stack, $level);
-		} elsif ($rawlines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
+		} elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
 			$level = $stack[$#stack - 1];
-		} elsif ($rawlines[$line] =~ /^.\s*#\s*endif\b/) {
+		} elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
 			$level = pop(@stack);
 		}
 
-		foreach my $c (split(//, $rawlines[$line])) {
+		foreach my $c (split(//, $lines[$line])) {
 			##print "C<$c>L<$level><$open$close>O<$off>\n";
 			if ($off > 0) {
 				$off--;
@@ -1652,7 +1652,7 @@ sub process {
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
-					"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
+					"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 			}
 			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
 			    $ctx =~ /\)\s*\;\s*$/ &&
@@ -1661,7 +1661,7 @@ sub process {
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
 					WARN("trailing semicolon indicates no statements, indent implies otherwise\n" .
-						"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
+						"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 				}
 			}
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

checkpatch-fix-regressions-in-fix-handling-of-leading-spaces.patch
checkpatch-types-may-sit-on-a-line-on-their-own.patch
checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate.patch
checkpatch-ensure-we-do-not-collapse-bracketed-sections-into-constants.patch
checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary.patch
checkpatch-returning-errno-typically-should-be-negative.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-simplify-and-consolidate-missing-space-after-checks.patch
checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help.patch
checkpatch-check-for-incorrect-permissions.patch
checkpatch-add-additional-attribute-defines.patch
checkpatch-update-copyright-dates.patch
checkpatch-clean-up-structure-definition-macro-handline.patch
checkpatch-handle-export_symbol-for-device_attr-and-similar.patch
checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines.patch
checkpatch-version-031.patch

