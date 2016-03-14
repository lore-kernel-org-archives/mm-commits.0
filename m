From: akpm@linux-foundation.org
Subject: + checkpatch-fix-left-brace-warning.patch added to -mm tree
Date: Mon, 14 Mar 2016 12:39:40 -0700
Message-ID: <56e7137c.TlApYgfSbQ2RhRs+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbcCNTjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2016 15:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geyslan@gmail.com, ewk@edkovsky.org, joe@perches.com, peter.senna@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix another left brace warning
has been added to the -mm tree.  Its filename is
     checkpatch-fix-left-brace-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-left-brace-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-left-brace-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geyslan G. Bem <geyslan@gmail.com>
Subject: checkpatch: fix another left brace warning

This patch escapes a regex that uses left brace.

Using checkpatch.pl with Perl 5.22.0 generates the warning: "Unescaped
left brace in regex is deprecated, passed through in regex;"

Comment from regcomp.c in Perl source: "Currently we don't warn when the
lbrace is at the start of a construct.  This catches it in the middle of a
literal string, or when it's the first thing after something like "\b"."

This works as a complement to 4e5d56bd ("checkpatch: fix left brace
warning").

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Eddie Kovsky <ewk@edkovsky.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-left-brace-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-left-brace-warning
+++ a/scripts/checkpatch.pl
@@ -4132,7 +4132,7 @@ sub process {
 ## 		}
 
 #need space before brace following if, while, etc
-		if (($line =~ /\(.*\)\{/ && $line !~ /\($Type\){/) ||
+		if (($line =~ /\(.*\)\{/ && $line !~ /\($Type\)\{/) ||
 		    $line =~ /do\{/) {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
_

Patches currently in -mm which might be from geyslan@gmail.com are

checkpatch-fix-left-brace-warning.patch

