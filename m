From: akpm@linux-foundation.org
Subject: +
 checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch added to -mm tree
Date: Wed, 11 Jun 2014 16:27:02 -0700
Message-ID: <5398e5c6.4Rm0LFiD9e035/3+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFKX1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, bruce.w.allan@intel.com, joe@perches.com

Subject: + checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch added to -mm tree
To: joe@perches.com,bruce.w.allan@intel.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:27:02 -0700


The patch titled
     Subject: checkpatch: fix function pointers in blank line needed after declarations test
has been added to the -mm tree.  Its filename is
     checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch

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
Subject: checkpatch: fix function pointers in blank line needed after declarations test

Add a function pointer declaration check to the test for blank line needed
after declarations.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Bruce W Allan <bruce.w.allan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test
+++ a/scripts/checkpatch.pl
@@ -2303,6 +2303,8 @@ sub process {
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
 		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+			# function pointer declarations
+		     $prevline =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2315,6 +2317,8 @@ sub process {
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
 		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
+			# function pointer declarations
+		      $sline =~ /^\+\s+$Declare\s*\(\s*\*\s*$Ident\s*\)\s*[=,;:\[\(]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
linux-next.patch

