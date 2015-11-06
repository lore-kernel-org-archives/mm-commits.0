From: akpm@linux-foundation.org
Subject: [merged] doc-slub-document-slabinfo-gnuplotsh-script.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:58 -0800
Message-ID: <563d0862.UKwmH7nEA7b72ost%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbbKFUG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Doc/slub: document slabinfo-gnuplot.sh script
has been removed from the -mm tree.  Its filename was
     doc-slub-document-slabinfo-gnuplotsh-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Doc/slub: document slabinfo-gnuplot.sh script

Add documentation on how to use slabinfo-gnuplot.sh script.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.txt |   59 ++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN Documentation/vm/slub.txt~doc-slub-document-slabinfo-gnuplotsh-script Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt~doc-slub-document-slabinfo-gnuplotsh-script
+++ a/Documentation/vm/slub.txt
@@ -280,4 +280,63 @@ of other objects.
 
 	slub_debug=FZ,dentry
 
+Extended slabinfo mode and plotting
+-----------------------------------
+
+The slabinfo tool has a special 'extended' ('-X') mode that includes:
+ - Slabcache Totals
+ - Slabs sorted by size (up to -N <num> slabs, default 1)
+ - Slabs sorted by loss (up to -N <num> slabs, default 1)
+
+Additionally, in this mode slabinfo does not dynamically scale sizes (G/M/K)
+and reports everything in bytes (this functionality is also available to
+other slabinfo modes via '-B' option) which makes reporting more precise and
+accurate. Moreover, in some sense the `-X' mode also simplifies the analysis
+of slabs' behaviour, because its output can be plotted using the
+slabinfo-gnuplot.sh script. So it pushes the analysis from looking through
+the numbers (tons of numbers) to something easier -- visual analysis.
+
+To generate plots:
+a) collect slabinfo extended records, for example:
+
+  while [ 1 ]; do slabinfo -X >> FOO_STATS; sleep 1; done
+
+b) pass stats file(-s) to slabinfo-gnuplot.sh script:
+  slabinfo-gnuplot.sh FOO_STATS [FOO_STATS2 .. FOO_STATSN]
+
+The slabinfo-gnuplot.sh script will pre-processes the collected records
+and generates 3 png files (and 3 pre-processing cache files) per STATS
+file:
+ - Slabcache Totals: FOO_STATS-totals.png
+ - Slabs sorted by size: FOO_STATS-slabs-by-size.png
+ - Slabs sorted by loss: FOO_STATS-slabs-by-loss.png
+
+Another use case, when slabinfo-gnuplot can be useful, is when you need
+to compare slabs' behaviour "prior to" and "after" some code modification.
+To help you out there, slabinfo-gnuplot.sh script can 'merge' the
+`Slabcache Totals` sections from different measurements. To visually
+compare N plots:
+
+a) Collect as many STATS1, STATS2, .. STATSN files as you need
+  while [ 1 ]; do slabinfo -X >> STATS<X>; sleep 1; done
+
+b) Pre-process those STATS files
+  slabinfo-gnuplot.sh STATS1 STATS2 .. STATSN
+
+c) Execute slabinfo-gnuplot.sh in '-t' mode, passing all of the
+generated pre-processed *-totals
+  slabinfo-gnuplot.sh -t STATS1-totals STATS2-totals .. STATSN-totals
+
+This will produce a single plot (png file).
+
+Plots, expectedly, can be large so some fluctuations or small spikes
+can go unnoticed. To deal with that, `slabinfo-gnuplot.sh' has two
+options to 'zoom-in'/'zoom-out':
+ a) -s %d,%d  overwrites the default image width and heigh
+ b) -r %d,%d  specifies a range of samples to use (for example,
+              in `slabinfo -X >> FOO_STATS; sleep 1;' case, using
+              a "-r 40,60" range will plot only samples collected
+              between 40th and 60th seconds).
+
 Christoph Lameter, May 30, 2007
+Sergey Senozhatsky, October 23, 2015
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

