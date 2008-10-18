From: akpm@linux-foundation.org
Subject: - checkpatch-define_-macros-are-real-definitions-for-exports.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:12 -0700
Message-ID: <200810182314.m9INEC6T028348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYJRXOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: DEFINE_ macros are real definitions for exports
has been removed from the -mm tree.  Its filename was
     checkpatch-define_-macros-are-real-definitions-for-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: DEFINE_ macros are real definitions for exports
From: Andy Whitcroft <apw@shadowen.org>

When we want to confirm an export is directly after its definition we need
to allow for DEFINE_ style macros.  Add these to the execeptions. 
Refactor the exceptions.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-define_-macros-are-real-definitions-for-exports scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-define_-macros-are-real-definitions-for-exports
+++ a/scripts/checkpatch.pl
@@ -1573,13 +1573,14 @@ sub process {
 		if (($line =~ /EXPORT_SYMBOL.*\((.*)\)/) ||
 		    ($line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 			my $name = $1;
-			if (($prevline !~ /^}/) &&
-			   ($prevline !~ /^\+}/) &&
-			   ($prevline !~ /^ }/) &&
-			   ($prevline !~ /^.DECLARE_$Ident\(\Q$name\E\)/) &&
-			   ($prevline !~ /^.LIST_HEAD\(\Q$name\E\)/) &&
-			   ($prevline !~ /^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(/) &&
-			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)/)) {
+			if ($prevline !~ /(?:
+				^.}|
+				^.DEFINE_$Ident\(\Q$name\E\)|
+				^.DECLARE_$Ident\(\Q$name\E\)|
+				^.LIST_HEAD\(\Q$name\E\)|
+				^.$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|
+				\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)
+			    )/x) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

