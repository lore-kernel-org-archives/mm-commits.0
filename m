From: akpm@linux-foundation.org
Subject: + checkpatch-do-not-report-nr_static-as-a-static-declaration.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:42 -0800
Message-ID: <200812090004.mB904gnF031229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYLIAFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: do not report nr_static as a static declaration
has been added to the -mm tree.  Its filename is
     checkpatch-do-not-report-nr_static-as-a-static-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: do not report nr_static as a static declaration
From: Andy Whitcroft <apw@canonical.com>

Ensure we do not report identifiers containing the word static as static
declarations.  For example this should not be reported as an unecessary
assignement of 0:

	long nr_static = 0;

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-do-not-report-nr_static-as-a-static-declaration scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-do-not-report-nr_static-as-a-static-declaration
+++ a/scripts/checkpatch.pl
@@ -1632,7 +1632,7 @@ sub process {
 				$herecurr);
 		}
 # check for static initialisers.
-		if ($line =~ /\s*static\s.*=\s*(0|NULL|false)\s*;/) {
+		if ($line =~ /\bstatic\s.*=\s*(0|NULL|false)\s*;/) {
 			ERROR("do not initialise statics to 0 or NULL\n" .
 				$herecurr);
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

linux-next.patch
checkpatch-update-copyrights.patch
checkpatch-add-warning-for-p0-patches.patch
checkpatch-allow-parentheses-on-return-for-comparisons.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch
checkpatch-loosen-spacing-on-typedef-function-checks.patch
checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch
checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch
checkpatch-do-not-report-nr_static-as-a-static-declaration.patch
checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch
checkpatch-struct-file_operations-should-normally-be-const.patch
checkpatch-fix-the-perlcritic-errors.patch
checkpatch-version-026.patch

