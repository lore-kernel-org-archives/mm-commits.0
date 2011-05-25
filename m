From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-defect-in-printkkern_level-80-column-exceptions.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:30 -0700
Message-ID: <201105252030.p4PKUrVq015003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932326Ab1EYUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix defect in printk(KERN_<LEVEL> 80 column exceptions
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-defect-in-printkkern_level-80-column-exceptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
checkpatch-suggest-using-min_t-or-max_t.patch

