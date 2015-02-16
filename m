From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-no-space-necessary-after-cast-test.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:17:29 -0800
Message-ID: <54e25059.4IqcW5gHuQzm43JU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbBPUSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve "no space necessary after cast" test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-no-space-necessary-after-cast-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve "no space necessary after cast" test

Code like:
	if (a < sizeof(<type>) &&
and
	{ .len = sizeof(<type>) },

incorrectly emits that warning, so add more exceptions to avoid
the warning.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-no-space-necessary-after-cast-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-no-space-necessary-after-cast-test
+++ a/scripts/checkpatch.pl
@@ -2541,7 +2541,7 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*(\w+\s*)?\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|[,;\({\[\<\>])/ &&
+		if ($line =~ /^\+.*(\w+\s*)?\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|[,;:\?\(\{\}\[\<\>]|&&|\|\||\\$)/ &&
 		    (!defined($1) || $1 !~ /sizeof\s*/)) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

