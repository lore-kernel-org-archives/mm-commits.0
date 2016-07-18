From: akpm@linux-foundation.org
Subject: + checkpatch-yet-another-commit-id-improvement.patch added to -mm tree
Date: Mon, 18 Jul 2016 12:36:33 -0700
Message-ID: <578d2fc1.QW54/E7Binckkv0c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbcGRTge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2016 15:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, qiuxu.zhuo@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Yet another commit id improvement
has been added to the -mm tree.  Its filename is
     checkpatch-yet-another-commit-id-improvement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-yet-another-commit-id-improvement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-yet-another-commit-id-improvement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Yet another commit id improvement

Using b isn't good enough to isolate what appears to be a commit id in a
commit message.

Make sure there is a space or a quote like character after a continuous
run of hexadecimal characters that could be a commit id.

Link: http://lkml.kernel.org/r/fdd22b47463a21c21132edbb8aa35e372950a1e6.1468869915.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-yet-another-commit-id-improvement scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-yet-another-commit-id-improvement
+++ a/scripts/checkpatch.pl
@@ -2454,9 +2454,9 @@ sub process {
 
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
-		    $line !~ /^\s*(?:Link|Patchwork|http|BugLink):/i &&
+		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink):/i &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
-		     ($line =~ /\b[0-9a-f]{12,40}\b/i &&
+		     ($line =~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
 		      $line !~ /[\<\[][0-9a-f]{12,40}[\>\]]/i &&
 		      $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
 			my $init_char = "c";
_

Patches currently in -mm which might be from joe@perches.com are

printk-create-pr_level-functions.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch
checkpatch-yet-another-commit-id-improvement.patch

