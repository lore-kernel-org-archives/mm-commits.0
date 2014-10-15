From: akpm@linux-foundation.org
Subject: + checkpatch-improve-test-for-no-space-after-cast.patch added to
 -mm tree
Date: Wed, 15 Oct 2014 14:59:28 -0700
Message-ID: <543eee40.FdvZybF1qwvLqoAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaJOV72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 17:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kvalo@qca.qualcomm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve test for no space after cast
has been added to the -mm tree.  Its filename is
     checkpatch-improve-test-for-no-space-after-cast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-test-for-no-space-after-cast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-test-for-no-space-after-cast.patch

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
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

