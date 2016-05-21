From: akpm@linux-foundation.org
Subject: [patch 151/162] checkpatch: add test for keywords not starting on tabstops
Date: Fri, 20 May 2016 17:04:05 -0700
Message-ID: <573fa5f5.oDBigGbUJpe+i40h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEUAEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

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
