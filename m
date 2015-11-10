From: akpm@linux-foundation.org
Subject: + checkpatch-improve-macros-with-flow-control-test.patch added to -mm tree
Date: Tue, 10 Nov 2015 13:31:59 -0800
Message-ID: <5642624f.EWpnjPEqd/chleTx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbKJVcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 16:32:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve macros with flow control test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-macros-with-flow-control-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-macros-with-flow-control-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-macros-with-flow-control-test.patch

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
@@ -4517,7 +4517,7 @@ sub process {
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
 			$has_flow_statement = 1 if ($ctx =~ /\b(goto|return)\b/);
-			$has_arg_concat = 1 if ($ctx =~ /\#\#/);
+			$has_arg_concat = 1 if ($ctx =~ /\#\#/ && $ctx !~ /\#\#\s*(?:__VA_ARGS__|args)\b/);
 
 			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
 			$dstat =~ s/$;//g;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-warn-when-casting-constants-to-c90-int-or-longer-types.patch
checkpatch-improve-macros-with-flow-control-test.patch

