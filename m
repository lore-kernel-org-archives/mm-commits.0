From: akpm@linux-foundation.org
Subject: [patch 028/114] checkpatch: special audit for revert
 commit line
Date: Mon, 08 May 2017 15:55:54 -0700
Message-ID: <20170508225554.L4YuQuwgP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdEHWzz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, wvw@google.com

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
