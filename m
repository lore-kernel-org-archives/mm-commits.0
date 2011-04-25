From: akpm@linux-foundation.org
Subject: + checkpatch-fix-defect-in-printkkern_level-80-column-exceptions.patch added to -mm tree
Date: Mon, 25 Apr 2011 14:00:24 -0700
Message-ID: <201104252100.p3PL0OSB009258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809Ab1DYVA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 17:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     checkpatch: fix defect in printk(KERN_<LEVEL> 80 column exceptions
has been added to the -mm tree.  Its filename is
     checkpatch-fix-defect-in-printkkern_level-80-column-exceptions.patch

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
Subject: checkpatch: fix defect in printk(KERN_<LEVEL> 80 column exceptions
From: Joe Perches <joe@perches.com>

Currently, printk lines with a only KERN_PREFIX and a quoted string
without a comma or close paren that exceed 80 columns are flagged with a
warning.

ie:
	printk(KERN_WARNING "some long string that extends beond 80 cols..."
	       "and is continued on another line\n");

Allow this form instead of emitting a warning.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-defect-in-printkkern_level-80-column-exceptions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-defect-in-printkkern_level-80-column-exceptions
+++ a/scripts/checkpatch.pl
@@ -1462,7 +1462,7 @@ sub process {
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ ||
+		    !($line =~ /^\+\s*$logFunctions\s*\(\s*(?:(KERN_\S+\s*|[^"]*))?"[X\t]*"\s*(?:|,|\)\s*;)\s*$/ ||
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > 80)
 		{
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-add-check-for-line-continuations-in-quoted-strings.patch
checkpatch-add-foo_level-and-module_bar-to-80-column-exceptions.patch
checkpatch-fix-defect-in-printkkern_level-80-column-exceptions.patch

