From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 12:57:10 -0700
Message-ID: <559ed216.m18uW9GkKAQvtVB/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbGIT5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on bare SHA-1 commit IDs in commit logs
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch

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

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

