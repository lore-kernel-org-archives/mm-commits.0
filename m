From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-relax-check-for-length-of-git-commit-ids.patch removed from -mm
 tree
Date: Wed, 03 Sep 2014 10:57:17 -0700
Message-ID: <5407567d.INRSRo3QwxH+GdZf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaICR5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: relax check for length of git commit IDs
has been removed from the -mm tree.  Its filename was
     checkpatch-relax-check-for-length-of-git-commit-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: relax check for length of git commit IDs

Checkpatch currently warns if a git commit ID (in the changelog, usually)
is less than 12 characters or more than 16.  The "more than 16" is
excessive.  Change the check so we accept IDs from 12 to 40 chars in
length.

Cc: Geert Uytterhoeven <geert@linux-m68k.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-relax-check-for-length-of-git-commit-ids scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-relax-check-for-length-of-git-commit-ids
+++ a/scripts/checkpatch.pl
@@ -2133,7 +2133,7 @@ sub process {
 # Check for improperly formed commit descriptions
 		if ($in_commit_log &&
 		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    $line !~ /\b[Cc]ommit [0-9a-f]{12,16} \("/) {
+		    $line !~ /\b[Cc]ommit [0-9a-f]{12,40} \("/) {
 			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
 			my $init_char = $1;
 			my $orig_commit = lc($2);
@@ -2141,7 +2141,7 @@ sub process {
 			my $desc = 'commit description';
 		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
 			ERROR("GIT_COMMIT_ID",
-			      "Please use 12 to 16 chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
 		}
 
 # Check for added, moved or deleted files
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-spello.patch
checkpatch-remove-debugging-message.patch
checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
checkpatch-enable-whitespace-checks-for-dts-files.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch
linux-next.patch
lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch

