From: akpm@linux-foundation.org
Subject: - checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:06 -0800
Message-ID: <200901072217.n07MH6cU016756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758461AbZAGWRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: ensure we actually detect if assignments split across lines
has been removed from the -mm tree.  Its filename was
     checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: ensure we actually detect if assignments split across lines
From: Andy Whitcroft <apw@canonical.com>

When checking for assignments within if conditionals we check the whole of
the condition, but the match is performed using a line constrained regular
expression.  This means we can miss split conditionals or those on the
second line.  Allow the check to span lines.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines
+++ a/scripts/checkpatch.pl
@@ -2048,7 +2048,7 @@ sub process {
 		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
-			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
+			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
 				ERROR("do not use assignment in if condition\n" . $herecurr);
 			}
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch

