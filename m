From: akpm@linux-foundation.org
Subject: [merged] checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:52 -0700
Message-ID: <200909222045.n8MKjqcb016570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbZIVUqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, daikerjohn@gmail.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: indent checks -- stop when we run out of continuation lines
has been removed from the -mm tree.  Its filename was
     checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: indent checks -- stop when we run out of continuation lines
From: Andy Whitcroft <apw@canonical.com>

Ensure we terminate when there are no futher continuation lines when
trying to determine relative indent of conditionals and their blocks.

Reported-by: John Daiker <daikerjohn@gmail.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines
+++ a/scripts/checkpatch.pl
@@ -1547,8 +1547,9 @@ sub process {
 				    $s =~ /^\s*#\s*?/ ||
 				    $s =~ /^\s*$Ident\s*:/) {
 					$continuation = ($s =~ /^.*?\\\n/) ? 1 : 0;
-					$s =~ s/^.*?\n//;
-					$cond_lines++;
+					if ($s =~ s/^.*?\n//) {
+						$cond_lines++;
+					}
 				}
 			}
 
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

