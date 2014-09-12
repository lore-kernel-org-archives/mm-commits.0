From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
 removed from -mm tree
Date: Fri, 12 Sep 2014 13:13:04 -0700
Message-ID: <541353d0.Y6oBo8q/L+ZDbQSC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaILUNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, joe.lawrence@stratus.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow commit descriptions on separate line from commit id
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow commit descriptions on separate line from commit id

The general form for commit id and description is

'Commit <12+hexdigits> ("commit description/subject line")'

But commit logs often have relatively long commit ids and the commit
description is on a separate line like:

Some explanation as to why commit <12+hexdigits> ("commit
description/subject line") is improved.

Allow this form.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Joe Lawrence <joe.lawrence@stratus.com>
Tested-by: Joe Lawrence <joe.lawrence@stratus.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id
+++ a/scripts/checkpatch.pl
@@ -2133,7 +2133,10 @@ sub process {
 # Check for improperly formed commit descriptions
 		if ($in_commit_log &&
 		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    $line !~ /\b[Cc]ommit [0-9a-f]{12,40} \("/) {
+		    !($line =~ /\b[Cc]ommit [0-9a-f]{12,40} \("/ ||
+		      ($line =~ /\b[Cc]ommit [0-9a-f]{12,40}\s*$/ &&
+		       defined $rawlines[$linenr] &&
+		       $rawlines[$linenr] =~ /^\s*\("/))) {
 			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
 			my $init_char = $1;
 			my $orig_commit = lc($2);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-spello.patch
checkpatch-remove-debugging-message.patch
checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
checkpatch-enable-whitespace-checks-for-dts-files.patch
checkpatch-allow-optional-shorter-config-descriptions.patch
checkpatch-allow-optional-shorter-config-descriptions-v4.patch
checkpatch-add-strict-test-for-concatenated-string-elements.patch
checkpatch-remove-unnecessary-after-88.patch
checkpatch-warn-on-macros-with-flow-control-statements.patch
checkpatch-look-for-common-misspellings.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch
linux-next.patch
lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch

