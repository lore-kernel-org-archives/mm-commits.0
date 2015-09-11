From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch removed from
 -mm tree
Date: Fri, 11 Sep 2015 11:12:09 -0700
Message-ID: <55f31979.AjuXhmajX6afllcp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbIKSMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on bare SHA-1 commit IDs in commit logs
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on bare SHA-1 commit IDs in commit logs

Commit IDs should have commit descriptions too.  Warn when a 12 to 40 byte
SHA-1 is used in commit logs.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs
+++ a/scripts/checkpatch.pl
@@ -2317,9 +2317,11 @@ sub process {
 		}
 
 # Check for git id commit length and improperly formed commit descriptions
-		if ($in_commit_log && $line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i) {
-			my $init_char = $1;
-			my $orig_commit = lc($2);
+		if ($in_commit_log &&
+		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
+		     $line =~ /\b[0-9a-f]{12,40}\b/i)) {
+			my $init_char = "c";
+			my $orig_commit = "";
 			my $short = 1;
 			my $long = 0;
 			my $case = 1;
@@ -2330,6 +2332,13 @@ sub process {
 			my $orig_desc = "commit description";
 			my $description = "";
 
+			if ($line =~ /\b(c)ommit\s+([0-9a-f]{5,})\b/i) {
+				$init_char = $1;
+				$orig_commit = lc($2);
+			} elsif ($line =~ /\b([0-9a-f]{12,40})\b/i) {
+				$orig_commit = lc($1);
+			}
+
 			$short = 0 if ($line =~ /\bcommit\s+[0-9a-f]{12,40}/i);
 			$long = 1 if ($line =~ /\bcommit\s+[0-9a-f]{41,}/i);
 			$space = 0 if ($line =~ /\bcommit [0-9a-f]/i);
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

