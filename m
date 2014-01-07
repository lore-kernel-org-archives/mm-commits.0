From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch
 added to -mm tree
Date: Tue, 07 Jan 2014 15:46:18 -0800
Message-ID: <52cc91ca.+KKrM/g6pNPPsMPu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaAGXqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:46:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:46:18 -0800


The patch titled
     Subject: checkpatch: add warning with unnecessary parentheses in if statements
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch

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
Subject: checkpatch: add warning with unnecessary parentheses in if statements

Using doubled parentheses in statements like "if ((foo == bar))" is
unnecessary or may be a sign of an intended single assignment instead of a
comparison.

Bleat a warning message on those uses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements
+++ a/scripts/checkpatch.pl
@@ -3325,6 +3325,13 @@ sub process {
 			}
 		}
 
+# if statements using unnecessary parentheses - ie: if ((foo == bar))
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\bif\s*\(\s*\(\s*$LvalOrFunc\s*$Compare\s*$LvalOrFunc\s*\)\s*\)/) {
+			WARN("UNNECESSARY_PARENTHESES",
+			     "Unnecessary parentheses\n" . $herecurr);
+		}
+
 # Return of what appears to be an errno should normally be -'ve
 		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

