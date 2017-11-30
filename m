From: akpm@linux-foundation.org
Subject: [merged] bloat-o-meter-dont-fail-with-division-by-0.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:05 -0800
Message-ID: <20171130201905.KPSjTF0lY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdK3UTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org, v.narang@samsung.com


The patch titled
     Subject: scripts/bloat-o-meter: don't fail with division by 0
has been removed from the -mm tree.  Its filename was
     bloat-o-meter-dont-fail-with-division-by-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: scripts/bloat-o-meter: don't fail with division by 0

Under some circumstances it's possible to get a divider 0 which crashes
the script.

Traceback (most recent call last):
  File "linux/scripts/bloat-o-meter", line 98, in <module>
    print_result("Function", "tTdDbBrR", 2)
  File "linux/scripts/bloat-o-meter", line 87, in print_result
    (otot, ntot, (ntot - otot)*100.0/otot))
ZeroDivisionError: float division by zero

Hide this by checking the divider first.

Link: http://lkml.kernel.org/r/20171123171219.31453-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN scripts/bloat-o-meter~bloat-o-meter-dont-fail-with-division-by-0 scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~bloat-o-meter-dont-fail-with-division-by-0
+++ a/scripts/bloat-o-meter
@@ -83,8 +83,11 @@ def print_result(symboltype, symbolforma
     for d, n in delta:
         if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
 
-    print("Total: Before=%d, After=%d, chg %+.2f%%" % \
-        (otot, ntot, (ntot - otot)*100.0/otot))
+    if otot:
+        percent = (ntot - otot) * 100.0 / otot
+    else:
+        percent = 0
+    print("Total: Before=%d, After=%d, chg %+.2f%%" % (otot, ntot, percent))
 
 if sys.argv[1] == "-c":
     print_result("Function", "tT", 3)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


