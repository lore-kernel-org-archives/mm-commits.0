From: akpm@linux-foundation.org
Subject: [merged] checkpatch-struct-seq_operations-should-normally-be-const.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:16 -0800
Message-ID: <200901161917.n0GJHGnm025839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbZAPTUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:20:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     checkpatch: struct seq_operations should normally be const
has been removed from the -mm tree.  Its filename was
     checkpatch-struct-seq_operations-should-normally-be-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: struct seq_operations should normally be const
From: Andy Whitcroft <apw@canonical.com>

In the general use case struct seq_operations should be a const object. 
Check for and warn where it is not.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-struct-seq_operations-should-normally-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-struct-seq_operations-should-normally-be-const
+++ a/scripts/checkpatch.pl
@@ -2527,9 +2527,10 @@ sub process {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
 # check for struct file_operations, ensure they are const.
-		if ($line =~ /\bstruct\s+file_operations\b/ &&
-		    $line !~ /\bconst\b/) {
-			WARN("struct file_operations should normally be const\n" . $herecurr);
+		if ($line !~ /\bconst\b/ &&
+		    $line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
+			WARN("struct $1 should normally be const\n" .
+				$herecurr);
 		}
 
 # use of NR_CPUS is usually wrong
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

