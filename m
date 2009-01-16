From: akpm@linux-foundation.org
Subject: [merged] checkpatch-allow-parentheses-on-return-handle-array-values.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:12 -0800
Message-ID: <200901161917.n0GJHCwe025769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933967AbZAPTRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: allow parentheses on return handle array values
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-parentheses-on-return-handle-array-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: allow parentheses on return handle array values
From: Andy Whitcroft <apw@canonical.com>

When we allow return to have surrounding parentheses when containing
comparison operators we are not correctly handling the case where the
values contain array sufffixes.  Squash them.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-parentheses-on-return-handle-array-values scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-parentheses-on-return-handle-array-values
+++ a/scripts/checkpatch.pl
@@ -2016,7 +2016,11 @@ sub process {
 
 			# Flatten any parentheses
 			$value =~ s/\)\(/\) \(/g;
-			while ($value !~ /(?:$Ident|-?$Constant)\s*$Compare\s*(?:$Ident|-?$Constant)/ && $value =~ s/\([^\(\)]*\)/1/) {
+			while ($value =~ s/\[[^\{\}]*\]/1/ ||
+			       $value !~ /(?:$Ident|-?$Constant)\s*
+					     $Compare\s*
+					     (?:$Ident|-?$Constant)/x &&
+			       $value =~ s/\([^\(\)]*\)/1/) {
 			}
 
 			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

