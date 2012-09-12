From: akpm@linux-foundation.org
Subject: + checkpatch-update-suggested-printk-conversions.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:08:59 -0700
Message-ID: <20120912210859.A53A71E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54186 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2ILVJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:09:00 -0400
Received: by ghbz15 with SMTP id z15so55173ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:09:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org


The patch titled
     Subject: checkpatch: update suggested printk conversions
has been added to the -mm tree.  Its filename is
     checkpatch-update-suggested-printk-conversions.patch

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
Subject: checkpatch: update suggested printk conversions

Direct conversion of printk(KERN_<LEVEL>...  to pr_<level> isn't the
preferred conversion when a struct net_device or struct device is
available.

Hint that using netdev_<level> or dev_<level> is preferred to using
pr_<level>.  Add netdev_dbg and dev_dbg variants too.

Miscellaneous whitespace neatening of a misplaced close brace.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-suggested-printk-conversions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-suggested-printk-conversions
+++ a/scripts/checkpatch.pl
@@ -421,7 +421,7 @@ sub top_of_kernel_tree {
 		}
 	}
 	return 1;
-    }
+}
 
 sub parse_email {
 	my ($formatted_email) = @_;
@@ -2399,8 +2399,10 @@ sub process {
 			my $orig = $1;
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
+			my $level2 = $level;
+			$level2 = "dbg" if ($level eq "debug");
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer pr_$level(... to printk(KERN_$1, ...\n" . $herecurr);
+			     "Prefer netdev_$level2(netdev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
 		}
 
 		if ($line =~ /\bpr_warning\s*\(/) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-gianfar_ptp-after-renaming.patch
checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch
checkpatch-update-suggested-printk-conversions.patch

