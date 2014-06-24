From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
 added to -mm tree
Date: Tue, 24 Jun 2014 14:32:47 -0700
Message-ID: <53a9ee7f.3JDXj6pULfOOXmoK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFXVcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for blank lines after function/struct/union/enum
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch

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
Subject: checkpatch: add test for blank lines after function/struct/union/enum

Add a --strict test asking for a blank line after
function/struct/union/enum declarations.

Allow exceptions for several attributes and macro uses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-blank-lines-after-function-struct-union-enum scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-blank-lines-after-function-struct-union-enum
+++ a/scripts/checkpatch.pl
@@ -2300,6 +2300,21 @@ sub process {
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
+# check for missing blank lines after struct/union declarations
+# with exceptions for various attributes and macros
+		if ($prevline =~ /^[\+ ]};?\s*$/ &&
+		    !($line =~ /^\+\s*$/ ||
+		      $line =~ /^\+\s*EXPORT_SYMBOL/ ||
+		      $line =~ /^\+\s*MODULE_/i ||
+		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
+		      $line =~ /^\+[a-z_]*init/ ||
+		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
+		      $line =~ /^\+\s*DECLARE/ ||
+		      $line =~ /^\+\s*__setup/)) {
+			CHK("LINE_SPACING",
+			    "Please use a blank line after function/struct/union/enum declarations\n" . $hereprev);
+		}
+
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch

