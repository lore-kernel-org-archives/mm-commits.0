From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
 added to -mm tree
Date: Thu, 29 Jan 2015 14:00:00 -0800
Message-ID: <54caad60.+g7VvymA5gbT07Ql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbbA2WAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 17:00:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add ability to --fix unnecessary blank lines around braces
has been added to the -mm tree.  Its filename is
     checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch

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
Subject: checkpatch: add ability to --fix unnecessary blank lines around braces

There's a --strict test for these blank lines.

Add the ability to automatically remove them with --fix.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces
+++ a/scripts/checkpatch.pl
@@ -4461,12 +4461,18 @@ sub process {
 
 # check for unnecessary blank lines around braces
 		if (($line =~ /^.\s*}\s*$/ && $prevrawline =~ /^.\s*$/)) {
-			CHK("BRACES",
-			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
+			if (CHK("BRACES",
+				"Blank lines aren't necessary before a close brace '}'\n" . $hereprev) &&
+			    $fix && $prevrawline =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+			}
 		}
 		if (($rawline =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
-			CHK("BRACES",
-			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
+			if (CHK("BRACES",
+				"Blank lines aren't necessary after an open brace '{'\n" . $hereprev) &&
+			    $fix) {
+				fix_delete_line($fixlinenr, $rawline);
+			}
 		}
 
 # no volatiles please
_

Patches currently in -mm which might be from joe@perches.com are

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
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

