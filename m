From: akpm@linux-foundation.org
Subject: + checkpatch-complain-about-executable-files.patch added to -mm tree
Date: Tue, 19 Mar 2013 15:44:30 -0700
Message-ID: <20130319224430.6EB515A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:65299 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3CSWob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 18:44:31 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so101346vbb.4
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 15:44:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, sboyd@codeaurora.org


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     checkpatch-complain-about-executable-files.patch

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
Subject: checkpatch: Complain about executable files

Complain about files with an executable bit set that are not in a scripts/
directory and are not type .pl, .py, .awk, or .sh

Based on an initial patch from Stephen.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-complain-about-executable-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complain-about-executable-files
+++ a/scripts/checkpatch.pl
@@ -1583,7 +1583,8 @@ sub process {
 # Check for incorrect file permissions
 		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
 			my $permhere = $here . "FILE: $realfile\n";
-			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+			if ($realfile !~ m@scripts/@ &&
+			    $realfile !~ /\.(py|pl|awk|sh)$/) {
 				ERROR("EXECUTE_PERMISSIONS",
 				      "do not set execute permissions for source files\n" . $permhere);
 			}
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
checkpatch-prefer-seq_puts-to-seq_printf.patch
checkpatch-complain-about-executable-files.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

