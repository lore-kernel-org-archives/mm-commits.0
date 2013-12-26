From: akpm@linux-foundation.org
Subject: + checkpatch-improve-space-before-tab-fix-option.patch added to
 -mm tree
Date: Thu, 26 Dec 2013 14:16:12 -0800
Message-ID: <52bcaaac.WOCa3yeALNvIQ+mg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3LZWQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: + checkpatch-improve-space-before-tab-fix-option.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:16:12 -0800


The patch titled
     Subject: checkpatch: improve space before tab --fix option
has been added to the -mm tree.  Its filename is
     checkpatch-improve-space-before-tab-fix-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-space-before-tab-fix-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-space-before-tab-fix-option.patch

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
Subject: checkpatch: improve space before tab --fix option

This test should remove all the spaces before a tab not just one space.

Substitute a tab for each 8 space block before a tab and remove less than
8 spaces before a tab.

This SPACE_BEFORE_TAB test is done after CODE_INDENT.

If there are spaces used at the beginning of a line that should be
converted to tabs, please make sure that the CODE_INDENT test and
conversion is done before this SPACE_BEFORE_TAB test and conversion.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-space-before-tab-fix-option scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-space-before-tab-fix-option
+++ a/scripts/checkpatch.pl
@@ -2118,8 +2118,10 @@ sub process {
 			if (WARN("SPACE_BEFORE_TAB",
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
-				    s/(^\+.*) +\t/$1\t/;
+				while ($fixed[$linenr - 1] =~
+					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+				while ($fixed[$linenr - 1] =~
+					   s/(^\+.*) +\t/$1\t/) {}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

