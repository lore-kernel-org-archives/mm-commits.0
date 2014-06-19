From: akpm@linux-foundation.org
Subject: +
 checkpatch-reduce-false-positives-when-checking-void-function-return-statements.patch added to -mm tree
Date: Thu, 19 Jun 2014 13:18:46 -0700
Message-ID: <53a345a6.MvFJ9yMTEbEhWbhN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145AbaFSUSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 16:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, anish@chelsio.com, joe@perches.com


The patch titled
     Subject: checkpatch: reduce false positives when checking void function return statements
has been added to the -mm tree.  Its filename is
     checkpatch-reduce-false-positives-when-checking-void-function-return-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-reduce-false-positives-when-checking-void-function-return-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-reduce-false-positives-when-checking-void-function-return-statements.patch

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
Subject: checkpatch: reduce false positives when checking void function return statements

The previous patch had a few too many false positives on styles that
should be acceptable.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-false-positives-when-checking-void-function-return-statements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-false-positives-when-checking-void-function-return-statements
+++ a/scripts/checkpatch.pl
@@ -3484,12 +3484,17 @@ sub process {
 			}
 		}
 
-# unnecessary return in a void function? (a single leading tab, then return;)
-		if ($sline =~ /^\+\treturn\s*;\s*$/ &&
-		    $prevline =~ /^\+/) {
+# unnecessary return in a void function
+# at end-of-function, with the previous line a single leading tab, then return;
+# and the line before that not a goto label target like "out:"
+		if ($sline =~ /^[ \+]}\s*$/ &&
+		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
+		    $linenr >= 3 &&
+		    $lines[$linenr - 3] =~ /^[ +]/ &&
+		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
 			WARN("RETURN_VOID",
-			     "void function return statements are not generally useful\n" . $herecurr);
-		}
+			     "void function return statements are not generally useful\n" . $hereprev);
+               }
 
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
 		if ($^V && $^V ge 5.10.0 &&
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-check-git-commit-descriptions.patch
checkpatch-reduce-false-positives-when-checking-void-function-return-statements.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch

