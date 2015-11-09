From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-reduce-size_class-memory-usage.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:16 -0800
Message-ID: <5640f7cc.0K214AtOATU2cqlP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbKITpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: reduce size_class memory usage
has been removed from the -mm tree.  Its filename was
     zsmalloc-reduce-size_class-memory-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zsmalloc: reduce size_class memory usage

Each `struct size_class' contains `struct zs_size_stat': an array of
NR_ZS_STAT_TYPE `unsigned long'.  For zsmalloc built with no
CONFIG_ZSMALLOC_STAT this results in a waste of `2 * sizeof(unsigned
long)' per-class.

The patch removes unneeded `struct zs_size_stat' members by redefining
NR_ZS_STAT_TYPE (max stat idx in array).

Since both NR_ZS_STAT_TYPE and zs_stat_type are compile time constants,
GCC can eliminate zs_stat_inc()/zs_stat_dec() calls that use zs_stat_type
larger than NR_ZS_STAT_TYPE: CLASS_ALMOST_EMPTY and CLASS_ALMOST_FULL at
the moment.

./scripts/bloat-o-meter mm/zsmalloc.o.old mm/zsmalloc.o.new
add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-39 (-39)
function                                     old     new   delta
fix_fullness_group                            97      94      -3
insert_zspage                                100      86     -14
remove_zspage                                141     119     -22

To summarize:
a) each class now uses less memory
b) we avoid a number of dec/inc stats (a minor optimization,
   but still).

The gain will increase once we introduce additional stats.

A simple IO test.

iozone -t 4 -R -r 32K -s 60M -I +Z
                        patched                 base
"  Initial write "       4145599.06              4127509.75
"        Rewrite "       4146225.94              4223618.50
"           Read "      17157606.00             17211329.50
"        Re-read "      17380428.00             17267650.50
"   Reverse Read "      16742768.00             16162732.75
"    Stride read "      16586245.75             16073934.25
"    Random read "      16349587.50             15799401.75
" Mixed workload "      10344230.62              9775551.50
"   Random write "       4277700.62              4260019.69
"         Pwrite "       4302049.12              4313703.88
"          Pread "       6164463.16              6126536.72
"         Fwrite "       7131195.00              6952586.00
"          Fread "      12682602.25             12619207.50

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-reduce-size_class-memory-usage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-reduce-size_class-memory-usage
+++ a/mm/zsmalloc.c
@@ -167,9 +167,14 @@ enum zs_stat_type {
 	OBJ_USED,
 	CLASS_ALMOST_FULL,
 	CLASS_ALMOST_EMPTY,
-	NR_ZS_STAT_TYPE,
 };
 
+#ifdef CONFIG_ZSMALLOC_STAT
+#define NR_ZS_STAT_TYPE	(CLASS_ALMOST_EMPTY + 1)
+#else
+#define NR_ZS_STAT_TYPE	(OBJ_USED + 1)
+#endif
+
 struct zs_size_stat {
 	unsigned long objs[NR_ZS_STAT_TYPE];
 };
@@ -448,19 +453,23 @@ static int get_size_class_index(int size
 static inline void zs_stat_inc(struct size_class *class,
 				enum zs_stat_type type, unsigned long cnt)
 {
-	class->stats.objs[type] += cnt;
+	if (type < NR_ZS_STAT_TYPE)
+		class->stats.objs[type] += cnt;
 }
 
 static inline void zs_stat_dec(struct size_class *class,
 				enum zs_stat_type type, unsigned long cnt)
 {
-	class->stats.objs[type] -= cnt;
+	if (type < NR_ZS_STAT_TYPE)
+		class->stats.objs[type] -= cnt;
 }
 
 static inline unsigned long zs_stat_get(struct size_class *class,
 				enum zs_stat_type type)
 {
-	return class->stats.objs[type];
+	if (type < NR_ZS_STAT_TYPE)
+		return class->stats.objs[type];
+	return 0;
 }
 
 #ifdef CONFIG_ZSMALLOC_STAT
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are


