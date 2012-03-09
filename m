From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-use-of-yield.patch added to -mm tree
Date: Thu, 08 Mar 2012 16:33:24 -0800
Message-ID: <20120309003325.36735A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34514 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab2CIAd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 19:33:27 -0500
Received: by faaa19 with SMTP id a19so38468faa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 16:33:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, a.p.zijlstra@chello.nl, apw@canonical.com


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-use-of-yield.patch

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
Subject: checkpatch: Warn on use of yield()

Using yield() is generally wrong.  Warn on its use.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-use-of-yield scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-use-of-yield
+++ a/scripts/checkpatch.pl
@@ -3344,6 +3344,12 @@ sub process {
 			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for use of yield()
+		if ($line =~ /\byield\s*\(\s*\)/) {
+			WARN("YIELD",
+			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
_
Subject: From: Joe Perches <joe@perches.com>

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch

