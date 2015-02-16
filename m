From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-likely-unlikely-comparison-misuse-test.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:17:17 -0800
Message-ID: <54e2504d.xYF4jA1OtVAQblPA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbBPURx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cj@linux.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add likely/unlikely comparison misuse test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-likely-unlikely-comparison-misuse-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

