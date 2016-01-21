From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-macros-with-flow-control-test.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:16 -0800
Message-ID: <56a162c4.dQ8oy/6+0I/+Y5jE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbcAUW7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve macros with flow control test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-macros-with-flow-control-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve macros with flow control test

The current test excludes any macro with ## concatenation from being
reported with hidden flow control.

Some macros are used with return or goto statements along with ##args or
##__VA_ARGS__.  A somewhat common case is a logging macro like
pr_info(fmt, ...) then a return or goto statement.

Check the concatenated variable for args or __VA_ARGS__ and allow those
macros to also be reported when they contain a return or goto.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-macros-with-flow-control-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-macros-with-flow-control-test
+++ a/scripts/checkpatch.pl
@@ -4539,7 +4539,7 @@ sub process {
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
 			$has_flow_statement = 1 if ($ctx =~ /\b(goto|return)\b/);
-			$has_arg_concat = 1 if ($ctx =~ /\#\#/);
+			$has_arg_concat = 1 if ($ctx =~ /\#\#/ && $ctx !~ /\#\#\s*(?:__VA_ARGS__|args)\b/);
 
 			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
 			$dstat =~ s/$;//g;
_

Patches currently in -mm which might be from joe@perches.com are


