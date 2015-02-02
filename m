From: akpm@linux-foundation.org
Subject: + checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
 added to -mm tree
Date: Mon, 02 Feb 2015 15:21:30 -0800
Message-ID: <54d0067a.aBi8JZhVPCRMK7nK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbBBXVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 18:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for spaces around arithmetic
has been added to the -mm tree.  Its filename is
     checkpatch-add-strict-test-for-spaces-around-arithmetic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-strict-test-for-spaces-around-arithmetic.patch

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
Subject: checkpatch: add --strict test for spaces around arithmetic

Some prefer code to have spaces around arithmetic so instead of:
        a = b*c+d;
suggest
        a = b * c + d;

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-spaces-around-arithmetic scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-spaces-around-arithmetic
+++ a/scripts/checkpatch.pl
@@ -3689,7 +3689,22 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
+					if ($check) {
+						if (defined $fix_elements[$n + 2] && $ctx !~ /[EW]x[EW]/) {
+							if (CHK("SPACING",
+								"spaces preferred around that '$op' $at\n" . $hereptr)) {
+								$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+								$fix_elements[$n + 2] =~ s/^\s+//;
+								$line_fixed = 1;
+							}
+						} elsif (!defined $fix_elements[$n + 2] && $ctx !~ /Wx[OE]/) {
+							if (CHK("SPACING",
+								"space preferred before that '$op' $at\n" . $hereptr)) {
+								$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]);
+								$line_fixed = 1;
+							}
+						}
+					} elsif ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						if (ERROR("SPACING",
 							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
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
checkpatch-improve-seq_print-seq_puts-suggestion.patch
checkpatch-improve-no-space-necessary-after-cast-test.patch
checkpatch-neaten-printk_ratelimited-message-position.patch
checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

