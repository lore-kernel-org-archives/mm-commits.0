From: akpm@linux-foundation.org
Subject: + checkpatch-add-tests-for-function-pointer-style-misuses.patch
 added to -mm tree
Date: Tue, 07 Jan 2014 15:21:51 -0800
Message-ID: <52cc8c0f.BVimkZCITz1iWp/J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaAGXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, d.roc16@gmail.com, apw@shadowen.org, joe@perches.com

Subject: + checkpatch-add-tests-for-function-pointer-style-misuses.patch added to -mm tree
To: joe@perches.com,apw@shadowen.org,d.roc16@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:21:51 -0800


The patch titled
     Subject: checkpatch: add tests for function pointer style misuses
has been added to the -mm tree.  Its filename is
     checkpatch-add-tests-for-function-pointer-style-misuses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-tests-for-function-pointer-style-misuses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-tests-for-function-pointer-style-misuses.patch

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
Subject: checkpatch: add tests for function pointer style misuses

Kernel style uses function pointers in this form:
	"type (*funcptr)(args...)"

Emit warnings when this function pointer form isn't used.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Derek Perrin <d.roc16@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   59 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-tests-for-function-pointer-style-misuses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tests-for-function-pointer-style-misuses
+++ a/scripts/checkpatch.pl
@@ -2808,6 +2808,65 @@ sub process {
 			}
 		}
 
+# Function pointer declarations
+# check spacing between type, funcptr, and args
+# canonical declaration is "type (*funcptr)(args...)"
+#
+# the $Declare variable will capture all spaces after the type
+# so check it for trailing missing spaces or multiple spaces
+		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)$Ident(\s*)\)(\s*)\(/) {
+			my $declare = $1;
+			my $pre_pointer_space = $2;
+			my $post_pointer_space = $3;
+			my $funcname = $4;
+			my $post_funcname_space = $5;
+			my $pre_args_space = $6;
+
+			if ($declare !~ /\s$/) {
+				WARN("SPACING",
+				     "missing space after return type\n" . $herecurr);
+			}
+
+# unnecessary space "type  (*funcptr)(args...)"
+			elsif ($declare =~ /\s{2,}$/) {
+				WARN("SPACING",
+				     "Multiple spaces after return type\n" . $herecurr);
+			}
+
+# unnecessary space "type ( *funcptr)(args...)"
+			if (defined $pre_pointer_space &&
+			    $pre_pointer_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space after function pointer open parenthesis\n" . $herecurr);
+			}
+
+# unnecessary space "type (* funcptr)(args...)"
+			if (defined $post_pointer_space &&
+			    $post_pointer_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space before function pointer name\n" . $herecurr);
+			}
+
+# unnecessary space "type (*funcptr )(args...)"
+			if (defined $post_funcname_space &&
+			    $post_funcname_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space after function pointer name\n" . $herecurr);
+			}
+
+# unnecessary space "type (*funcptr) (args...)"
+			if (defined $pre_args_space &&
+			    $pre_args_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space before function pointer arguments\n" . $herecurr);
+			}
+
+			if (show_type("SPACING") && $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(.\s*$Declare)\(\s*\*\s*($Ident)\s*\)\s*\(/rtrim($1) . " " . "\(\*$2\)\("/ex;
+			}
+		}
+
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
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
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

