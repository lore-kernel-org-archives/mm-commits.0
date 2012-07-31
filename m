From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-usleep_range-arguments.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:45 -0700
Message-ID: <20120731185145.B298F10007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2GaSvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:46 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, yuvalmin@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check usleep_range() arguments
has been removed from the -mm tree.  Its filename was
     checkpatch-check-usleep_range-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: check usleep_range() arguments

usleep_range() shouldn't use the same args for min and max.

Report it when it happens and when both args are decimal and min > max.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Yuval Mintz <yuvalmin@broadcom.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-usleep_range-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-usleep_range-arguments
+++ a/scripts/checkpatch.pl
@@ -3313,6 +3313,22 @@ sub process {
 			}
 		}
 
+# check usleep_range arguments
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?:.*?)\busleep_range\s*\(\s*($FuncArg)\s*,\s*($FuncArg)\s*\)/) {
+		 	my $min = $1;
+			my $max = $7;
+			if ($min eq $max) {
+				WARN("USLEEP_RANGE",
+				     "usleep_range should not use min == max args; see Documentation/timers/timers-howto.txt\n" . "$here\n$stat\n");
+			} elsif ($min =~ /^\d+$/ && $max =~ /^\d+$/ &&
+				 $min > $max) {
+				WARN("USLEEP_RANGE",
+				     "usleep_range args reversed, use min then max; see Documentation/timers/timers-howto.txt\n" . "$here\n$stat\n");
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

