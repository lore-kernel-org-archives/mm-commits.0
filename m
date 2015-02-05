From: akpm@linux-foundation.org
Subject: + checkpatch-try-to-avoid-poor-patch-subject-lines.patch added to -mm tree
Date: Thu, 05 Feb 2015 15:13:15 -0800
Message-ID: <54d3f90b.z2NSrkWJldOAtV3J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbBEXNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2015 18:13:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: try to avoid poor patch subject lines
has been added to the -mm tree.  Its filename is
     checkpatch-try-to-avoid-poor-patch-subject-lines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-try-to-avoid-poor-patch-subject-lines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-try-to-avoid-poor-patch-subject-lines.patch

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
Subject: checkpatch: try to avoid poor patch subject lines

Naming the tool that found an issue in the subject line isn't very useful.
 Emit a warning when a common tool (currently checkpatch, sparse or
smatch) is in the subject line.

Signed-off-by: Joe Perches <joe@perches.com>
Inspired-by: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-try-to-avoid-poor-patch-subject-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-try-to-avoid-poor-patch-subject-lines
+++ a/scripts/checkpatch.pl
@@ -2170,6 +2170,13 @@ sub process {
 			}
 		}
 
+# Check email subject for common tools that don't need to be mentioned
+		if ($in_header_lines &&
+		    $line =~ /^Subject:.*\b(?:checkpatch|sparse|smatch)\b[^:]/i) {
+			WARN("EMAIL_SUBJECT",
+			     "A patch subject line should describe the change not the tool that found it\n" . $herecurr);
+		}
+
 # Check for old stable address
 		if ($line =~ /^\s*cc:\s*.*<?\bstable\@kernel\.org\b>?.*$/i) {
 			ERROR("STABLE_ADDRESS",
_

Patches currently in -mm which might be from joe@perches.com are

kernelh-remove-ancient-__function__-hack.patch
kernelh-remove-ancient-__function__-hack-fix.patch
printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
checkpatch-update-git-commit-message.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
checkpatch-add-types-for-other-os-typedefs.patch
checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
checkpatch-improve-seq_print-seq_puts-suggestion.patch
checkpatch-improve-no-space-necessary-after-cast-test.patch
checkpatch-neaten-printk_ratelimited-message-position.patch
checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
checkpatch-try-to-avoid-poor-patch-subject-lines.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

