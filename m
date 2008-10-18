From: akpm@linux-foundation.org
Subject: - checkpatch-switch-indent-allow-plain-return.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:14 -0700
Message-ID: <200810182313.m9INDEQH028147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbYJRXNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: switch indent allow plain return
has been removed from the -mm tree.  Its filename was
     checkpatch-switch-indent-allow-plain-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: switch indent allow plain return
From: Andy Whitcroft <apw@shadowen.org>

It is a common and sane idiom to allow a single return on the end of a
case statement:

	switch (...) {
	case foo:	return bar;
	}

Add an exception for this.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-switch-indent-allow-plain-return scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-switch-indent-allow-plain-return
+++ a/scripts/checkpatch.pl
@@ -1295,7 +1295,11 @@ sub process {
 			}
 		}
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
-		    $line !~ /\G(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$/g) {
+		    $line !~ /\G(?:
+			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
+			\s*return\s+
+		    )/xg)
+		{
 			ERROR("trailing statements should be on next line\n" . $herecurr);
 		}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

