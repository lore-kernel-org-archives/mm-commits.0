From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-space-before-tab-fix-option.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:53 -0800
Message-ID: <52e2b8a1.pIBvhHrNh04cr2iC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaAXTBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-improve-space-before-tab-fix-option.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:53 -0800


The patch titled
     Subject: checkpatch: improve space before tab --fix option
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-space-before-tab-fix-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve space before tab --fix option

This test should remove all the spaces before a tab not just one space.

Substitute a tab for each 8 space block before a tab and remove less than
8 spaces before a tab.

This SPACE_BEFORE_TAB test is done after CODE_INDENT.

If there are spaces used at the beginning of a line that should be
converted to tabs, please make sure that the CODE_INDENT test and
conversion is done before this SPACE_BEFORE_TAB test and conversion.

Reported-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-space-before-tab-fix-option scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-space-before-tab-fix-option
+++ a/scripts/checkpatch.pl
@@ -2118,8 +2118,10 @@ sub process {
 			if (WARN("SPACE_BEFORE_TAB",
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
-				    s/(^\+.*) +\t/$1\t/;
+				while ($fixed[$linenr - 1] =~
+					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+				while ($fixed[$linenr - 1] =~
+					   s/(^\+.*) +\t/$1\t/) {}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

