From: akpm@linux-foundation.org
Subject: + checkpatchpl-modify-warning-message-for-printk-usage.patch
 added to -mm tree
Date: Wed, 05 Mar 2014 13:39:49 -0800
Message-ID: <531799a5.kbQT3rj7keUCLu7g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCEVju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 16:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, mr.yogesh@gmail.com

Subject: + checkpatchpl-modify-warning-message-for-printk-usage.patch added to -mm tree
To: mr.yogesh@gmail.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 13:39:49 -0800


The patch titled
     Subject: checkpatch.pl: modify warning message for printk usage
has been added to the -mm tree.  Its filename is
     checkpatchpl-modify-warning-message-for-printk-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-modify-warning-message-for-printk-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-modify-warning-message-for-printk-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatchpl-modify-warning-message-for-printk-usage.patch

