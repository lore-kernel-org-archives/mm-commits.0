From: akpm@linux-foundation.org
Subject: [patch 150/162] checkpatch: improve CONSTANT_COMPARISON test for
 structure members
Date: Fri, 20 May 2016 17:04:02 -0700
Message-ID: <573fa5f2.kAJbpoTRLQRY13ud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEUAEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve CONSTANT_COMPARISON test for structure members

A "." dereference to an all uppercase structure member can be
incorrectly reported as a CONSTANT_COMPARISON.

ie: "if (table[i].PANELID == tempdx)"

Fix it by checking for "." before the constant test.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-constant_comparison-test-for-structure-members scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-constant_comparison-test-for-structure-members
+++ a/scripts/checkpatch.pl
@@ -4291,7 +4291,7 @@ sub process {
 			my $comp = $3;
 			my $to = $4;
 			my $newcomp = $comp;
-			if ($lead !~ /$Operators\s*$/ &&
+			if ($lead !~ /(?:$Operators|\.)\s*$/ &&
 			    $to !~ /^(?:Constant|[A-Z_][A-Z0-9_]*)$/ &&
 			    WARN("CONSTANT_COMPARISON",
 				 "Comparisons should place the constant on the right side of the test\n" . $herecurr) &&
_
