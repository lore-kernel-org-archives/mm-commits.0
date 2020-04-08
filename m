From: akpm@linux-foundation.org
Subject: [merged] checkpatch-support-base-commit-format.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:29 -0700
Message-ID: <20200408020129.g1R4vd6uq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHCBb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, corbet@lwn.net, jhubbard@nvidia.com, joe@perches.com, konstantin@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: support "base-commit:" format
has been removed from the -mm tree.  Its filename was
     checkpatch-support-base-commit-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: checkpatch: support "base-commit:" format

In order to support the get-lore-mbox.py tool described in [1], I ran:

    git format-patch --base=<commit> --cover-letter <revrange>

...  which generated a "base-commit: <commit-hash>" tag at the end of the
cover letter.  However, checkpatch.pl generated an error upon encounting
"base-commit:" in the cover letter:

    "ERROR: Please use git commit description style..."

...  because it found the "commit" keyword, and failed to recognize that
it was part of the "base-commit" phrase, and as such, should not be
subjected to the same commit description style rules.

Update checkpatch.pl to include a special case for "base-commit:" (at the
start of the line, possibly with some leading whitespace) so that that tag
no longer generates a checkpatch error.

[1] https://lwn.net/Articles/811528/ "Better tools for kernel
    developers"

Link: http://lkml.kernel.org/r/20200213055004.69235-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-support-base-commit-format
+++ a/scripts/checkpatch.pl
@@ -2780,7 +2780,7 @@ sub process {
 
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
-		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink):/i &&
+		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
 		    $line !~ /^This reverts commit [0-9a-f]{7,40}/ &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
 		     ($line =~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
_

Patches currently in -mm which might be from jhubbard@nvidia.com are
