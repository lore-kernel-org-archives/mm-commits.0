From: akpm@linux-foundation.org
Subject: + checkpatch-remove-quote-from-camelcase-test.patch added to -mm
 tree
Date: Tue, 11 Jun 2013 15:50:32 -0700
Message-ID: <51b7a9b8.2wbpp8TubDMmF9NS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3FKWud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-remove-quote-from-camelcase-test.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:32 -0700


The patch titled
     Subject: checkpatch: remove quote from CamelCase test
has been added to the -mm tree.  Its filename is
     checkpatch-remove-quote-from-camelcase-test.patch

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
Subject: checkpatch: remove quote from CamelCase test

commit be987d9f80 ("checkpatch: improve CamelCase test for Page")
added it but it shouldn't be there.  Must have been my fault.

Make sure that the tested variable doesn't contain a constant.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-quote-from-camelcase-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-quote-from-camelcase-test
+++ a/scripts/checkpatch.pl
@@ -2949,9 +2949,9 @@ sub process {
 			}
 
 #CamelCase
-			if ($var !~ /$Constant/ &&
+			if ($var !~ /^$Constant$/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
-			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				CHK("CAMELCASE",
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

