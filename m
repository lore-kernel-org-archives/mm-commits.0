From: akpm@linux-foundation.org
Subject: + checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch added to -mm tree
Date: Thu, 21 Apr 2016 14:47:36 -0700
Message-ID: <57194a78.t05ckfY7qTAF7mnk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbcDUVrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 17:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for keywords not starting on tabstops
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch

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
Subject: checkpatch: add test for keywords not starting on tabstops

It's somewhat common and in general a defect for c90 keywords to
not start on a tabstop.

Add a test for this condition and warn when it occurs.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-keywords-not-starting-on-tabstops scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-keywords-not-starting-on-tabstops
+++ a/scripts/checkpatch.pl
@@ -2755,6 +2755,19 @@ sub process {
 			    "Logical continuations should be on the previous line\n" . $hereprev);
 		}
 
+# check indentation starts on a tab stop
+		if ($^V && $^V ge 5.10.0 &&
+		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$))/) {
+			my $indent = length($1);
+			if ($indent % 8) {
+				if (WARN("TABSTOP",
+					 "Statements should start on a tabstop\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s@(^\+\t+) +@$1 . "\t" x ($indent/8)@e;
+				}
+			}
+		}
+
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
 		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-improve-constant_comparison-test-for-structure-members.patch
checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch

