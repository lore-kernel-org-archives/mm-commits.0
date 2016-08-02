From: akpm@linux-foundation.org
Subject: [patch 052/111] checkpatch: yet another commit id improvement
Date: Tue, 02 Aug 2016 14:04:36 -0700
Message-ID: <57a10ae4.5DY8CYDHx4W0YqQf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbcHBVRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, qiuxu.zhuo@intel.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: yet another commit id improvement

Using \b isn't good enough to isolate what appears to be a commit id in a
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
@@ -2459,9 +2459,9 @@ sub process {
 
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
