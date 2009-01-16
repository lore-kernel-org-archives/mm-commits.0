From: akpm@linux-foundation.org
Subject: [merged] checkpatch-if-should-not-continue-a-preceeding-brace.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:14 -0800
Message-ID: <200901161917.n0GJHEZI025774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbZAPTS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: if should not continue a preceeding brace
has been removed from the -mm tree.  Its filename was
     checkpatch-if-should-not-continue-a-preceeding-brace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: if should not continue a preceeding brace
From: Andy Whitcroft <apw@canonical.com>

We should not be continuing a braced section with an if, for example:

	if (...) {
	} if (...) {
	}

Detect this and suggest adding a newline.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-if-should-not-continue-a-preceeding-brace scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-if-should-not-continue-a-preceeding-brace
+++ a/scripts/checkpatch.pl
@@ -2108,6 +2108,11 @@ sub process {
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
+# if should not continue a brace
+		if ($line =~ /}\s*if\b/) {
+			ERROR("trailing statements should be on next line\n" .
+				$herecurr);
+		}
 # case and default should not have general statements after them
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
 		    $line !~ /\G(?:
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

