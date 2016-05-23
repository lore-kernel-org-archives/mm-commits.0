From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:51:35 -0700
Message-ID: <57435f47.hqNXoB0RKIVEdl8B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbcEWTvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for keywords not starting on tabstops
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

checkpatch-whine-about-access_once.patch
checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
checkpatch-reduce-number-of-git-log-calls-with-git.patch
checkpatch-improve-git-commit-count-shortcut.patch

