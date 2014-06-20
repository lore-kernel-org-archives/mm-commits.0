From: akpm@linux-foundation.org
Subject: + checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 15:29:16 -0700
Message-ID: <53a4b5bc.zzDS+JoJ2cFBT+OG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220AbaFTW3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:29:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, linux@rasmusvillemoes.dk


The patch titled
     Subject: checkpatch.pl: also suggest 'else if' when if follows brace
has been added to the -mm tree.  Its filename is
     checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: checkpatch.pl: also suggest 'else if' when if follows brace

This might help a kernel hacker think twice before blindly adding a
newline.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-also-suggest-else-if-when-if-follows-brace scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-also-suggest-else-if-when-if-follows-brace
+++ a/scripts/checkpatch.pl
@@ -3629,7 +3629,7 @@ sub process {
 # if should not continue a brace
 		if ($line =~ /}\s*if\b/) {
 			ERROR("TRAILING_STATEMENTS",
-			      "trailing statements should be on next line\n" .
+			      "trailing statements should be on next line (or did you mean 'else if'?)\n" .
 				$herecurr);
 		}
 # case and default should not have general statements after them
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch

