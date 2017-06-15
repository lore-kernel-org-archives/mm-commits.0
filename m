From: akpm@linux-foundation.org
Subject: +
 checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch added to -mm tree
Date: Thu, 15 Jun 2017 15:53:07 -0700
Message-ID: <59430fd3.hOD/IIFI67K4HIlu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdFOWxI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix stepping through statements with $stat and ctx_statement_block
has been added to the -mm tree.  Its filename is
     checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch

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
Subject: checkpatch: fix stepping through statements with $stat and ctx_statement_block

Fix the off-by-one in the suppression of lines in a statement block.

This means that for multiple line statements like

	foo(bar,
	    baz,
	    qux);

$stat has been inspected first correctly for the entire statement,
and subsequently incorrectly just for

	    qux);

This fix will help make tracking appropriate indentation a little easier.

Link: http://lkml.kernel.org/r/71b25979c90412133c717084036c9851cd2b7bcb.1496862585.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block
+++ a/scripts/checkpatch.pl
@@ -3218,7 +3218,7 @@ sub process {
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
 #print "LINE<$line>\n";
-		if ($linenr >= $suppress_statement &&
+		if ($linenr > $suppress_statement &&
 		    $realcnt && $sline =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch

