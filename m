From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:24 -0800
Message-ID: <54e25054.3awdOEnptWCtiSi8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbBPUSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add ability to --fix unnecessary blank lines around braces
has been removed from the -mm tree.  Its filename was
     checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add ability to --fix unnecessary blank lines around braces

There's a --strict test for these blank lines.

Add the ability to automatically remove them with --fix.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces
+++ a/scripts/checkpatch.pl
@@ -4461,12 +4461,18 @@ sub process {
 
 # check for unnecessary blank lines around braces
 		if (($line =~ /^.\s*}\s*$/ && $prevrawline =~ /^.\s*$/)) {
-			CHK("BRACES",
-			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
+			if (CHK("BRACES",
+				"Blank lines aren't necessary before a close brace '}'\n" . $hereprev) &&
+			    $fix && $prevrawline =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+			}
 		}
 		if (($rawline =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
-			CHK("BRACES",
-			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
+			if (CHK("BRACES",
+				"Blank lines aren't necessary after an open brace '{'\n" . $hereprev) &&
+			    $fix) {
+				fix_delete_line($fixlinenr, $rawline);
+			}
 		}
 
 # no volatiles please
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

