From: akpm@linux-foundation.org
Subject: [merged] scripts-bloat-o-meter-print-percent-change.patch removed from -mm tree
Date: Fri, 20 May 2016 14:02:32 -0700
Message-ID: <573f7b68.N8iK+WZdv/c2Jl6V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, josh@joshtriplett.org, mmarek@suse.cz, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/bloat-o-meter: print percent change
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-print-percent-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: scripts/bloat-o-meter: print percent change

This adds an additional line of output (to reduce the chances of breaking
any existing output parsers) which prints the total size before and after
and the relative difference.

add/remove: 39/0 grow/shrink: 12408/55 up/down: 362227/-1430 (360797)
function                                     old     new   delta
ext4_fill_super                            10556   12590   +2034
_fpadd_parts                                   -    1186   +1186
ntfs_fill_super                             5340    6164    +824
...
...
__divdf3                                     752     386    -366
unlzma                                      3682    3274    -408
Total: Before=5023101, After=5383898, chg 7.000000%
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Link: http://lkml.kernel.org/r/1463124110-30314-1-git-send-email-vgupta@synopsys.com
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-print-percent-change scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-print-percent-change
+++ a/scripts/bloat-o-meter
@@ -32,18 +32,21 @@ old = getsizes(sys.argv[1])
 new = getsizes(sys.argv[2])
 grow, shrink, add, remove, up, down = 0, 0, 0, 0, 0, 0
 delta, common = [], {}
+otot, ntot = 0, 0
 
 for a in old:
     if a in new:
         common[a] = 1
 
 for name in old:
+    otot += old[name]
     if name not in common:
         remove += 1
         down += old[name]
         delta.append((-old[name], name))
 
 for name in new:
+    ntot += new[name]
     if name not in common:
         add += 1
         up += new[name]
@@ -63,3 +66,6 @@ print("add/remove: %s/%s grow/shrink: %s
 print("%-40s %7s %7s %+7s" % ("function", "old", "new", "delta"))
 for d, n in delta:
     if d: print("%-40s %7s %7s %+7d" % (n, old.get(n,"-"), new.get(n,"-"), d))
+
+print("Total: Before=%d, After=%d, chg %f%%" % \
+    (otot, ntot, (ntot - otot)*100/otot))
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are


