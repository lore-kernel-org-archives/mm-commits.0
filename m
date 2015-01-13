From: akpm@linux-foundation.org
Subject: + checkpatch-add-likely-unlikely-comparison-misuse-test.patch
 added to -mm tree
Date: Mon, 12 Jan 2015 16:27:08 -0800
Message-ID: <54b4665c.cGPsWAGK8o4OFgdc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbAMA1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cj@linux.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add likely/unlikely comparison misuse test
has been added to the -mm tree.  Its filename is
     checkpatch-add-likely-unlikely-comparison-misuse-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-likely-unlikely-comparison-misuse-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-likely-unlikely-comparison-misuse-test.patch

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
Subject: checkpatch: add likely/unlikely comparison misuse test

Add a test for probably likely/unlikely misuses where the comparison is
likely misplaced

	if (likely(foo) > 0)
vs
	if (likely(foo > 0))

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Jaeger <cj@linux.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-likely-unlikely-comparison-misuse-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-likely-unlikely-comparison-misuse-test
+++ a/scripts/checkpatch.pl
@@ -5239,6 +5239,13 @@ sub process {
 			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
 		}
 
+# likely/unlikely comparisons similar to "(likely(foo) > 0)"
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b((?:un)?likely)\s*\(\s*$FuncArg\s*\)\s*$Compare/) {
+			WARN("LIKELY_MISUSE",
+			     "Using $1 should generally have parentheses around the comparison\n" . $herecurr);
+		}
+
 # whine mightly about in_atomic
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {
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
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

