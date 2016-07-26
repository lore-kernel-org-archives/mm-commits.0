From: akpm@linux-foundation.org
Subject: [patch 008/126] scripts/bloat-o-meter: fix percent on <1% changes
Date: Tue, 26 Jul 2016 15:21:20 -0700
Message-ID: <5797e260.yAg54ELJBIvMr9a7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbcGZWVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, riku.voipio@linaro.org, josh@joshtriplett.org, mmarek@suse.cz, vgupta@synopsys.com

From: Riku Voipio <riku.voipio@linaro.org>
Subject: scripts/bloat-o-meter: fix percent on <1% changes

Python divisions are integer divisions unless at least one parameter is a
float.  The current bloat-o-meter fails to print sub-percentage changes:

Total: Before=10515408, After=10604060, chg 0.000000%

Force float division by using one float and pretty the print to
two significant decimals:

Total: Before=10515408, After=10604060, chg +0.84%

Link: http://lkml.kernel.org/r/1465980311-23814-1-git-send-email-riku.voipio@linaro.org
Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-fix-percent-on-1%-changes scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-fix-percent-on-1%-changes
+++ a/scripts/bloat-o-meter
@@ -67,5 +67,5 @@ print("%-40s %7s %7s %+7s" % ("function"
 for d, n in delta:
     if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
 
-print("Total: Before=%d, After=%d, chg %f%%" % \
-    (otot, ntot, (ntot - otot)*100/otot))
+print("Total: Before=%d, After=%d, chg %+.2f%%" % \
+    (otot, ntot, (ntot - otot)*100.0/otot))
_
