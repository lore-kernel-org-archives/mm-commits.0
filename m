From: akpm@linux-foundation.org
Subject: + checkpatch-improve-the-suspect_code_indent-test.patch added to
 -mm tree
Date: Tue, 02 May 2017 13:23:34 -0700
Message-ID: <5908eac6.E+ObrAMPJziUXTj/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdEBUXf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2017 16:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the SUSPECT_CODE_INDENT test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-suspect_code_indent-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-suspect_code_indent-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-suspect_code_indent-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the SUSPECT_CODE_INDENT test

The current SUSPECT_CODE_INDENT test does not recognize several defective
code style defects where code following a logical test is inappropriately
indented.

Before this patch, for code like:

	if (foo)
	bar();

checkpatch would not emit a warning.

Improve the test to warn when code after a logical test has the
same indentation as the logical test.

Perform the same indentation test for "else" blocks too.

Link: http://lkml.kernel.org/r/df2374b68c4a68af2b7ef08afe486584811f610a.1493683942.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-suspect_code_indent-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-suspect_code_indent-test
+++ a/scripts/checkpatch.pl
@@ -3354,7 +3354,7 @@ sub process {
 		}
 
 # Check relative indent for conditionals and blocks.
-		if ($line =~ /\b(?:(?:if|while|for|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+		if ($line =~ /\b(?:(?:if|while|for|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|(?:do|else)\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0)
 					if (!defined $stat);
@@ -3446,6 +3446,8 @@ sub process {
 			if ($check && $s ne '' &&
 			    (($sindent % 8) != 0 ||
 			     ($sindent < $indent) ||
+			     ($sindent == $indent &&
+			      ($s !~ /^\s*(?:\}|\{|else\b)/)) ||
 			     ($sindent > $indent + 8))) {
 				WARN("SUSPECT_CODE_INDENT",
 				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch
checkpatch-allow-space-leading-blank-lines-in-email-headers.patch
checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch
checkpatch-improve-multistatement_macro_use_do_while-test.patch
checkpatch-clarify-the-embedded_function_name-message.patch
checkpatch-improve-kalloc-with-multiplication-and-sizeof-test.patch
checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch
checkpatch-improve-the-suspect_code_indent-test.patch
treewide-correct-diffrent-and-banlance-typos.patch

