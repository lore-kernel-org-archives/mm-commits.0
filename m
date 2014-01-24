From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:45 -0800
Message-ID: <52e2b899.M0gXeKvjl8ROkM+2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaAXTBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, joe@perches.com

Subject: [merged] checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch removed from -mm tree
To: joe@perches.com,dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:45 -0800


The patch titled
     Subject: checkpatch: warn only on "space before semicolon" at end of line
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn only on "space before semicolon" at end of line

The "space before a non-naked semicolon" test has unwanted output when
used in "for ( ;; )" loops.

Make the test work only on end-of-line statement
termination semicolons.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-only-on-space-before-semicolon-at-end-of-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-only-on-space-before-semicolon-at-end-of-line
+++ a/scripts/checkpatch.pl
@@ -3121,7 +3121,7 @@ sub process {
 		}
 
 # check for whitespace before a non-naked semicolon
-		if ($line =~ /^\+.*\S\s+;/) {
+		if ($line =~ /^\+.*\S\s+;\s*$/) {
 			if (WARN("SPACING",
 				 "space prohibited before semicolon\n" . $herecurr) &&
 			    $fix) {
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

