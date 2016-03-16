From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-left-brace-warning.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:34 -0700
Message-ID: <56e9baae.IoetrqoJjuoT8uw+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbcCPT5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geyslan@gmail.com, ewk@edkovsky.org, joe@perches.com, peter.senna@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix another left brace warning
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-left-brace-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


