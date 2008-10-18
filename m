From: akpm@linux-foundation.org
Subject: - checkpatch-perform-indent-checks-on-perl.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:38 -0700
Message-ID: <200810182313.m9INDcKn028230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbYJRXNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: perform indent checks on perl
has been removed from the -mm tree.  Its filename was
     checkpatch-perform-indent-checks-on-perl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: perform indent checks on perl
From: Andy Whitcroft <apw@shadowen.org>

So that we eat our own dog food ensure the indent checks apply to perl
too.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-perform-indent-checks-on-perl scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-perform-indent-checks-on-perl
+++ a/scripts/checkpatch.pl
@@ -1266,8 +1266,8 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
-# check we are in a valid source file *.[hc] if not then ignore this hunk
-		next if ($realfile !~ /\.[hc]$/);
+# check we are in a valid source file C or perl if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c|pl)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
@@ -1277,6 +1277,9 @@ sub process {
 			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
+# check we are in a valid C source file if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c)$/);
+
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

