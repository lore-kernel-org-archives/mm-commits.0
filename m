From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-test-for-no-space-after-cast.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:24 -0800
Message-ID: <5489eaf4.5bksfaJH81DkrDUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLKTFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kvalo@qca.qualcomm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve test for no space after cast
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-test-for-no-space-after-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve test for no space after cast

sizeof(foo) is not a cast, allow a space after it.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-test-for-no-space-after-cast scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-test-for-no-space-after-cast
+++ a/scripts/checkpatch.pl
@@ -2515,7 +2515,8 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|{)/) {
+		if ($line =~ /^\+.*(\w+\s*)?\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|[,;\({\[\<\>])/ &&
+		    (!defined($1) || $1 !~ /sizeof\s*/)) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

