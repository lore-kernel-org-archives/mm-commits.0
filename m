From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-constant_comparison-test-for-structure-members.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:51:31 -0700
Message-ID: <57435f43.g/6f/0MHulUN+4P2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcEWTvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve CONSTANT_COMPARISON test for structure members
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-constant_comparison-test-for-structure-members.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-prefer_is_enabled-test.patch
checkpatch-add-test-for-keywords-not-starting-on-tabstops.patch
checkpatch-whine-about-access_once.patch
checkpatch-advertise-the-fix-and-fix-inplace-options-more.patch
checkpatch-add-list-types-to-show-message-types-to-show-or-ignore.patch
checkpatch-reduce-number-of-git-log-calls-with-git.patch
checkpatch-improve-git-commit-count-shortcut.patch

