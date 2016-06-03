From: akpm@linux-foundation.org
Subject: [patch 07/11] checkpatch: reduce git commit description style
 false positives
Date: Fri, 03 Jun 2016 14:55:49 -0700
Message-ID: <5751fce5.Yt3fxFiBNZrlMbeg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbcFCVz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: reduce git commit description style false positives

Some lines in a commit log appear to be commit SHA1 ids like:

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
Link: http://lkml.kernel.org/r/40e03fd7aaf1f55c75d787128d6d17c5a71226c2.1464358556.git.vdavydov@virtuozzo.com

Reduce the false positives.

Link: http://lkml.kernel.org/r/eda977eaa8328fef42bb3c87935d97e10ea8ff67.1464384023.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-git-commit-description-style-false-positives scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-git-commit-description-style-false-positives
+++ a/scripts/checkpatch.pl
@@ -2454,6 +2454,7 @@ sub process {
 
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
+		    $line !~ /^\s*(?:Link|Patchwork|http|BugLink):/i &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
 		     ($line =~ /\b[0-9a-f]{12,40}\b/i &&
 		      $line !~ /[\<\[][0-9a-f]{12,40}[\>\]]/i &&
_
