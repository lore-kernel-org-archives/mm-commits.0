From: akpm@linux-foundation.org
Subject: +
 checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
 added to -mm tree
Date: Tue, 11 Jun 2013 15:50:40 -0700
Message-ID: <51b7a9c0.o5CclpHgc5fWf56a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3FKWul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:40 -0700


The patch titled
     Subject: checkpatch: don't warn on blank lines before/after braces as often
has been added to the -mm tree.  Its filename is
     checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch

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
Subject: checkpatch: don't warn on blank lines before/after braces as often

Check to make sure the blank lines aren't comment lines like:

bool foo(bool bar)
{
	/* Don't warn on a leading comment */
	return !bar;
	/* Don't warn on a trailing comment either */
}

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often
+++ a/scripts/checkpatch.pl
@@ -3258,11 +3258,11 @@ sub process {
 		}
 
 # check for unnecessary blank lines around braces
-		if (($line =~ /^.\s*}\s*$/ && $prevline =~ /^.\s*$/)) {
+		if (($line =~ /^.\s*}\s*$/ && $prevrawline =~ /^.\s*$/)) {
 			CHK("BRACES",
 			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
 		}
-		if (($line =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
+		if (($rawline =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
 			CHK("BRACES",
 			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
 		}
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

