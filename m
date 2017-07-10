From: akpm@linux-foundation.org
Subject: [patch 100/115] checkpatch: fix stepping through
 statements with $stat and ctx_statement_block
Date: Mon, 10 Jul 2017 15:52:13 -0700
Message-ID: <20170710225213.CRqJ_aSoL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdGJWwO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -3219,7 +3219,7 @@ sub process {
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
 #print "LINE<$line>\n";
-		if ($linenr >= $suppress_statement &&
+		if ($linenr > $suppress_statement &&
 		    $realcnt && $sline =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
_
