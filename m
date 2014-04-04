From: akpm@linux-foundation.org
Subject: [merged]
 checkpatchpl-modify-warning-message-for-printk-usage.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:12 -0700
Message-ID: <533f0934.wu28HXORn/TojJWP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaDDTeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, mr.yogesh@gmail.com

Subject: [merged] checkpatchpl-modify-warning-message-for-printk-usage.patch removed from -mm tree
To: mr.yogesh@gmail.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:12 -0700


The patch titled
     Subject: checkpatch.pl: modify warning message for printk usage
has been removed from the -mm tree.  Its filename was
     checkpatchpl-modify-warning-message-for-printk-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Subject: checkpatch.pl: modify warning message for printk usage

Modify warning message when printk is used in a patch.  It mentions to use
subsystem_dbg instead of netdev_dbg as the first preferred format of
logging debug messages.

Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-modify-warning-message-for-printk-usage scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-modify-warning-message-for-printk-usage
+++ a/scripts/checkpatch.pl
@@ -2833,7 +2833,7 @@ sub process {
 			my $level2 = $level;
 			$level2 = "dbg" if ($level eq "debug");
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer netdev_$level2(netdev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
+			     "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
 		}
 
 		if ($line =~ /\bpr_warning\s*\(/) {
_

Patches currently in -mm which might be from mr.yogesh@gmail.com are

origin.patch

