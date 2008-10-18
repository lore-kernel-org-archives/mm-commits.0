From: akpm@linux-foundation.org
Subject: - checkpatch-complex-macros-checks-miss-square-brackets.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:10 -0700
Message-ID: <200810182314.m9INEAFP028345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbYJRXOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: complex macros checks miss square brackets
has been removed from the -mm tree.  Its filename was
     checkpatch-complex-macros-checks-miss-square-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: complex macros checks miss square brackets
From: Andy Whitcroft <apw@shadowen.org>

We are missing 'simple' values which include square brackets.  Refactor to
ensure we handle nesting correctly and detect these simple forms.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-complex-macros-checks-miss-square-brackets scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complex-macros-checks-miss-square-brackets
+++ a/scripts/checkpatch.pl
@@ -2142,9 +2142,10 @@ sub process {
 			$dstat =~ s/\s*$//s;
 
 			# Flatten any parentheses and braces
-			while ($dstat =~ s/\([^\(\)]*\)/1/) {
-			}
-			while ($dstat =~ s/\{[^\{\}]*\}/1/) {
+			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
+			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
+			       $dstat =~ s/\[[^\{\}]*\]/1/)
+			{
 			}
 
 			my $exceptions = qr{
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

