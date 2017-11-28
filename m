From: akpm@linux-foundation.org
Subject: + bloat-o-meter-dont-fail-with-division-by-0.patch added to -mm
 tree
Date: Mon, 27 Nov 2017 16:44:35 -0800
Message-ID: <5a1cb173.n7azPS2HtHkInMlg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752536AbdK1Aog (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, adobriyan@gmail.com, v.narang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: don't fail with division by 0
has been added to the -mm tree.  Its filename is
     bloat-o-meter-dont-fail-with-division-by-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bloat-o-meter-dont-fail-with-division-by-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bloat-o-meter-dont-fail-with-division-by-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

bloat-o-meter-dont-fail-with-division-by-0.patch

