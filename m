From: akpm@linux-foundation.org
Subject: [patch 032/114] checkpatch: improve the
 SUSPECT_CODE_INDENT test
Date: Mon, 08 May 2017 15:56:05 -0700
Message-ID: <20170508225605.o-UpKr0DT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdEHW4H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
