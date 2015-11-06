From: akpm@linux-foundation.org
Subject: [merged]
 tools-vm-slabinfo-use-getopt-no_argument-optional_argument.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:06:41 -0800
Message-ID: <563d0851.WVpsmz0deTRMqbr+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033394AbbKFUGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: use getopt no_argument/optional_argument
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-use-getopt-no_argument-optional_argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/vm/slabinfo: use getopt no_argument/optional_argument

This patchset adds 'extended' slabinfo mode that provides additional
information:

 -- totals summary
 -- slabs sorted by size
 -- slabs sorted by loss (waste)

The patches also introduces several new slabinfo options to limit the
number of slabs reported, sort slabs by loss (waste); and some fixes.


Extended output example (slabinfo -X -N 2):

 Slabcache Totals
 ----------------
 Slabcaches :              91   Aliases  :         119->69   Active:     63
 Memory used:       199798784   # Loss   :        10689376   MRatio:     5%
 # Objects  :          324301   # PartObj:           18151   ORatio:     5%
    
 Per Cache         Average              Min              Max            Total
 ----------------------------------------------------------------------------
 #Objects             5147                1            89068           324301
 #Slabs                199                1             3886            12537
 #PartSlab              12                0              240              778
 %PartSlab             32%               0%             100%               6%
 PartObjs                5                0             4569            18151
 % PartObj             26%               0%             100%               5%
 Memory            3171409             8192        127336448        199798784
 Used              3001736              160        121429728        189109408
 Loss               169672                0          5906720         10689376
    
 Per Object        Average              Min              Max
 -----------------------------------------------------------
 Memory                585                8             8192
 User                  583                8             8192
 Loss                    2                0               64
    
 Slabs sorted by size
 --------------------
 Name                   Objects Objsize           Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
 ext4_inode_cache         69948    1736       127336448      3871/0/15   18 3   0  95 a
 dentry                   89068     288        26058752      3164/0/17   28 1   0  98 a
    
 Slabs sorted by loss
 --------------------
 Name                   Objects Objsize            Loss Slabs/Part/Cpu  O/S O %Fr %Ef Flg
 ext4_inode_cache         69948    1736         5906720      3871/0/15   18 3   0  95 a
 inode_cache              11628     864          537472        642/0/4   18 2   0  94 a



The last patch in the series addresses Linus' comment from
http://marc.info/?l=linux-mm&m=144148518703321&w=2

(well, it's been some time. sorry.)


gnuplot script takes the slabinfo records file, where every record is a `slabinfo -X'
output. So the basic workflow is, for example, as follows:

	while [ 1 ]; do slabinfo -X -N 2 >> stats; sleep 1; done
	^C
	slabinfo-gnuplot.sh stats

The last command will produce 3 png files (and 3 stats files)
-- graph of slabinfo totals
-- graph of slabs by size
-- graph of slabs by loss


It's also possible to select a range of records for plotting (a range of collected
slabinfo outputs) via `-r 10,100` (for example); and compare totals from several
measurements (to visially compare slabs behaviour (10,50 range)) using
pre-parsed totals files:
	slabinfo-gnuplot.sh -r 10,50 -t stats-totals1 .. stats-totals2


This also, technically, supports ktest. Upload new slabinfo to target,
collect the stats and give the resulting stats file to slabinfo-gnuplot


This patch (of 8):

Use getopt constants in `struct option' ->has_arg instead of numerical
representations.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-use-getopt-no_argument-optional_argument tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-use-getopt-no_argument-optional_argument
+++ a/tools/vm/slabinfo.c
@@ -1268,23 +1268,23 @@ static void output_slabs(void)
 }
 
 struct option opts[] = {
-	{ "aliases", 0, NULL, 'a' },
-	{ "activity", 0, NULL, 'A' },
-	{ "debug", 2, NULL, 'd' },
-	{ "display-activity", 0, NULL, 'D' },
-	{ "empty", 0, NULL, 'e' },
-	{ "first-alias", 0, NULL, 'f' },
-	{ "help", 0, NULL, 'h' },
-	{ "inverted", 0, NULL, 'i'},
-	{ "numa", 0, NULL, 'n' },
-	{ "ops", 0, NULL, 'o' },
-	{ "report", 0, NULL, 'r' },
-	{ "shrink", 0, NULL, 's' },
-	{ "slabs", 0, NULL, 'l' },
-	{ "track", 0, NULL, 't'},
-	{ "validate", 0, NULL, 'v' },
-	{ "zero", 0, NULL, 'z' },
-	{ "1ref", 0, NULL, '1'},
+	{ "aliases", no_argument, NULL, 'a' },
+	{ "activity", no_argument, NULL, 'A' },
+	{ "debug", optional_argument, NULL, 'd' },
+	{ "display-activity", no_argument, NULL, 'D' },
+	{ "empty", no_argument, NULL, 'e' },
+	{ "first-alias", no_argument, NULL, 'f' },
+	{ "help", no_argument, NULL, 'h' },
+	{ "inverted", no_argument, NULL, 'i'},
+	{ "numa", no_argument, NULL, 'n' },
+	{ "ops", no_argument, NULL, 'o' },
+	{ "report", no_argument, NULL, 'r' },
+	{ "shrink", no_argument, NULL, 's' },
+	{ "slabs", no_argument, NULL, 'l' },
+	{ "track", no_argument, NULL, 't'},
+	{ "validate", no_argument, NULL, 'v' },
+	{ "zero", no_argument, NULL, 'z' },
+	{ "1ref", no_argument, NULL, '1'},
 	{ NULL, 0, NULL, 0 }
 };
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

