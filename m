From: akpm@linux-foundation.org
Subject: + checkpatch-special-audit-for-revert-commit-line.patch added to
 -mm tree
Date: Tue, 11 Apr 2017 14:48:23 -0700
Message-ID: <58ed4f27.OMXC5x1x41a+fZaf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdDKVsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 17:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wvw@google.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: special audit for revert commit line
has been added to the -mm tree.  Its filename is
     checkpatch-special-audit-for-revert-commit-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-special-audit-for-revert-commit-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-special-audit-for-revert-commit-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-special-audit-for-revert-commit-line.patch

