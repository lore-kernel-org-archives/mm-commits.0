From: akpm@linux-foundation.org
Subject: + checkpatch-add-a-strict-test-for-comparison-to-true-false.patch added to -mm tree
Date: Tue, 11 Jun 2013 15:50:41 -0700
Message-ID: <51b7a9c1.cXywnDEis+xJsu1q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3FKWum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-a-strict-test-for-comparison-to-true-false.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:41 -0700


The patch titled
     Subject: checkpatch: add a --strict test for comparison to true/false
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-strict-test-for-comparison-to-true-false.patch

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
Subject: checkpatch: add a --strict test for comparison to true/false

Comparing to true or false is error prone.

Add tests for the various forms of (foo == true) && (false != bar)
that are only reported with --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-strict-test-for-comparison-to-true-false scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-strict-test-for-comparison-to-true-false
+++ a/scripts/checkpatch.pl
@@ -3588,6 +3588,33 @@ sub process {
 			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
 		}
 
+# check for comparisons against true and false
+		if ($line =~ /\+\s*(.*?)\b(true|false|$Lval)\s*(==|\!=)\s*(true|false|$Lval)\b(.*)$/i) {
+			my $lead = $1;
+			my $arg = $2;
+			my $test = $3;
+			my $otype = $4;
+			my $trail = $5;
+			my $op = "!";
+
+			($arg, $otype) = ($otype, $arg) if ($arg =~ /^(?:true|false)$/i);
+
+			my $type = lc($otype);
+			if ($type =~ /^(?:true|false)$/) {
+				if (("$test" eq "==" && "$type" eq "true") ||
+				    ("$test" eq "!=" && "$type" eq "false")) {
+					$op = "";
+				}
+
+				CHK("BOOL_COMPARISON",
+				    "Using comparison to $otype is error prone\n" . $herecurr);
+
+## maybe suggesting a correct construct would better
+##				    "Using comparison to $otype is error prone.  Perhaps use '${lead}${op}${arg}${trail}'\n" . $herecurr);
+
+			}
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch

