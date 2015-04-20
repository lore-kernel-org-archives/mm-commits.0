From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-return-negative-errno-check.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:59 -0700
Message-ID: <553550ab.n6eO1wLprTsQkVIT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbbDTTKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve return negative errno check
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-return-negative-errno-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve return negative errno check

Add a few conditions to the test to find
	return (ERRNO);

Make the output message a bit less cryptic too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-return-negative-errno-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-return-negative-errno-check
+++ a/scripts/checkpatch.pl
@@ -4009,12 +4009,12 @@ sub process {
 			}
 		}
 
-# Return of what appears to be an errno should normally be -'ve
-		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
+# Return of what appears to be an errno should normally be negative
+		if ($sline =~ /\breturn(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
 			my $name = $1;
 			if ($name ne 'EOF' && $name ne 'ERROR') {
 				WARN("USE_NEGATIVE_ERRNO",
-				     "return of an errno should typically be -ve (return -$1)\n" . $herecurr);
+				     "return of an errno should typically be negative (ie: return -$1)\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

