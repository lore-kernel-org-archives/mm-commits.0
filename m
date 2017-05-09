From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-special-audit-for-revert-commit-line.patch removed from -mm tree
Date: Tue, 09 May 2017 11:01:22 -0700
Message-ID: <20170509180122.PG0i3Zuy4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbdEISBX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, wvw@google.com


The patch titled
     Subject: checkpatch: special audit for revert commit line
has been removed from the -mm tree.  Its filename was
     checkpatch-special-audit-for-revert-commit-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Wang <wvw@google.com>
Subject: checkpatch: special audit for revert commit line

Currently checkpatch.pl does not recognize git's default commit revert
message and will complain about the hash format.  Add special audit for
revert commit message line to fix it.

Link: http://lkml.kernel.org/r/20170411191532.74381-1-wvw@google.com
Signed-off-by: Wei Wang <wvw@google.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-special-audit-for-revert-commit-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-special-audit-for-revert-commit-line
+++ a/scripts/checkpatch.pl
@@ -2539,6 +2539,7 @@ sub process {
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
 		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink):/i &&
+		    $line !~ /^This reverts commit [0-9a-f]{7,40}/ &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
 		     ($line =~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
 		      $line !~ /[\<\[][0-9a-f]{12,40}[\>\]]/i &&
_

Patches currently in -mm which might be from wvw@google.com are


