From: akpm@linux-foundation.org
Subject: - checkpatch-do-not-report-nr_static-as-a-static-declaration.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:04 -0800
Message-ID: <200901072217.n07MH4Ot016753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761570AbZAGWRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: do not report nr_static as a static declaration
has been removed from the -mm tree.  Its filename was
     checkpatch-do-not-report-nr_static-as-a-static-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

