From: akpm@linux-foundation.org
Subject: + checkpatch-improve-no-space-after-cast-test.patch added to -mm
 tree
Date: Tue, 11 Jun 2013 15:50:42 -0700
Message-ID: <51b7a9c2.jVYK7CB5spsZ2rml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3FKWun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-improve-no-space-after-cast-test.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:42 -0700


The patch titled
     Subject: checkpatch: improve "no space after cast" test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-no-space-after-cast-test.patch

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
Subject: checkpatch: improve "no space after cast" test

Some false positives exist on this test.

For instance:
	*va_arg(args, signed char *) = val.s;
or
	memset(foo, 0, sizeof(struct bar *) * baz));

Ignore lines that have an arithmetic operator or assignment
after what appears to be a cast to a pointer "(foo *)".

Add $Arithmetic convenience variable.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-no-space-after-cast-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-no-space-after-cast-test
+++ a/scripts/checkpatch.pl
@@ -241,10 +241,11 @@ our $Float	= qr{$Float_hex|$Float_dec|$F
 our $Constant	= qr{$Float|$Binary|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
 our $Compare    = qr{<=|>=|==|!=|<|>};
+our $Arithmetic = qr{\+|-|\*|\/|%};
 our $Operators	= qr{
 			<=|>=|==|!=|
 			=>|->|<<|>>|<|>|!|~|
-			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
+			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
 		  }x;
 
 our $NonptrType;
@@ -1885,7 +1886,7 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+/) {
+		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
 			CHK("SPACING",
 			    "No space is necessary after a cast\n" . $hereprev);
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

