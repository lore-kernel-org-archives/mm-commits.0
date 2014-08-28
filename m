From: akpm@linux-foundation.org
Subject: +
 checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
 added to -mm tree
Date: Thu, 28 Aug 2014 16:24:24 -0700
Message-ID: <53ffba28.Mtw5bvthEO1JsbtX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:48699 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaH2FZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 01:25:05 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so484949igd.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 22:25:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, joe.lawrence@stratus.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow commit descriptions on separate line from commit id
has been added to the -mm tree.  Its filename is
     checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch

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

checkpatch-relax-check-for-length-of-git-commit-ids.patch
checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
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
mm-utilc-add-kstrimdup.patch
checkpatch-fix-spello.patch
checkpatch-remove-debugging-message.patch
checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
checkpatch-enable-whitespace-checks-for-dts-files.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch
linux-next.patch

