From: akpm@linux-foundation.org
Subject: + zram-user-per-cpu-compression-streams.patch added to -mm tree
Date: Thu, 28 Apr 2016 14:35:11 -0700
Message-ID: <5722820f.IlgxGV27AWz51TeW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbcD1VfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 17:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: user per-cpu compression streams
has been added to the -mm tree.  Its filename is
     zram-user-per-cpu-compression-streams.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-user-per-cpu-compression-streams.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-user-per-cpu-compression-streams.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: user per-cpu compression streams

Remove idle streams list and keep compression streams in per-cpu data. 
This removes two contented spin_lock()/spin_unlock() calls from write path
and also prevent write OP from being preempted while holding the
compression stream, which can cause slow downs.

For instance, let's assume that we have N cpus and N-2
max_comp_streams.TASK1 owns the last idle stream, TASK2-TASK3 come in with
the write requests:

  TASK1            TASK2              TASK3
 zram_bvec_write()
  spin_lock
  find stream
  spin_unlock

  compress

  <<preempted>>   zram_bvec_write()
                   spin_lock
                   find stream
                   spin_unlock
                     no_stream
                       schedule
                                     zram_bvec_write()
                                      spin_lock
                                      find_stream
                                      spin_unlock
                                        no_stream
                                          schedule
   spin_lock
   release stream
   spin_unlock
     wake up TASK2

not only TASK2 and TASK3 will not get the stream, TASK1 will be
preempted in the middle of its operation; while we would prefer
it to finish compression and release the stream.

Test environment: x86_64, 4 CPU box, 3G zram, lzo

The following fio tests were executed:
      read, randread, write, randwrite, rw, randrw
with the increasing number of jobs from 1 to 10.

                4 streams        8 streams       per-cpu
===========================================================
jobs1
READ:           2520.1MB/s       2566.5MB/s      2491.5MB/s
READ:           2102.7MB/s       2104.2MB/s      2091.3MB/s
WRITE:          1355.1MB/s       1320.2MB/s      1378.9MB/s
WRITE:          1103.5MB/s       1097.2MB/s      1122.5MB/s
READ:           434013KB/s       435153KB/s      439961KB/s
WRITE:          433969KB/s       435109KB/s      439917KB/s
READ:           403166KB/s       405139KB/s      403373KB/s
WRITE:          403223KB/s       405197KB/s      403430KB/s
jobs2
READ:           7958.6MB/s       8105.6MB/s      8073.7MB/s
READ:           6864.9MB/s       6989.8MB/s      7021.8MB/s
WRITE:          2438.1MB/s       2346.9MB/s      3400.2MB/s
WRITE:          1994.2MB/s       1990.3MB/s      2941.2MB/s
READ:           981504KB/s       973906KB/s      1018.8MB/s
WRITE:          981659KB/s       974060KB/s      1018.1MB/s
READ:           937021KB/s       938976KB/s      987250KB/s
WRITE:          934878KB/s       936830KB/s      984993KB/s
jobs3
READ:           13280MB/s        13553MB/s       13553MB/s
READ:           11534MB/s        11785MB/s       11755MB/s
WRITE:          3456.9MB/s       3469.9MB/s      4810.3MB/s
WRITE:          3029.6MB/s       3031.6MB/s      4264.8MB/s
READ:           1363.8MB/s       1362.6MB/s      1448.9MB/s
WRITE:          1361.9MB/s       1360.7MB/s      1446.9MB/s
READ:           1309.4MB/s       1310.6MB/s      1397.5MB/s
WRITE:          1307.4MB/s       1308.5MB/s      1395.3MB/s
jobs4
READ:           20244MB/s        20177MB/s       20344MB/s
READ:           17886MB/s        17913MB/s       17835MB/s
WRITE:          4071.6MB/s       4046.1MB/s      6370.2MB/s
WRITE:          3608.9MB/s       3576.3MB/s      5785.4MB/s
READ:           1824.3MB/s       1821.6MB/s      1997.5MB/s
WRITE:          1819.8MB/s       1817.4MB/s      1992.5MB/s
READ:           1765.7MB/s       1768.3MB/s      1937.3MB/s
WRITE:          1767.5MB/s       1769.1MB/s      1939.2MB/s
jobs5
READ:           18663MB/s        18986MB/s       18823MB/s
READ:           16659MB/s        16605MB/s       16954MB/s
WRITE:          3912.4MB/s       3888.7MB/s      6126.9MB/s
WRITE:          3506.4MB/s       3442.5MB/s      5519.3MB/s
READ:           1798.2MB/s       1746.5MB/s      1935.8MB/s
WRITE:          1792.7MB/s       1740.7MB/s      1929.1MB/s
READ:           1727.6MB/s       1658.2MB/s      1917.3MB/s
WRITE:          1726.5MB/s       1657.2MB/s      1916.6MB/s
jobs6
READ:           21017MB/s        20922MB/s       21162MB/s
READ:           19022MB/s        19140MB/s       18770MB/s
WRITE:          3968.2MB/s       4037.7MB/s      6620.8MB/s
WRITE:          3643.5MB/s       3590.2MB/s      6027.5MB/s
READ:           1871.8MB/s       1880.5MB/s      2049.9MB/s
WRITE:          1867.8MB/s       1877.2MB/s      2046.2MB/s
READ:           1755.8MB/s       1710.3MB/s      1964.7MB/s
WRITE:          1750.5MB/s       1705.9MB/s      1958.8MB/s
jobs7
READ:           21103MB/s        20677MB/s       21482MB/s
READ:           18522MB/s        18379MB/s       19443MB/s
WRITE:          4022.5MB/s       4067.4MB/s      6755.9MB/s
WRITE:          3691.7MB/s       3695.5MB/s      5925.6MB/s
READ:           1841.5MB/s       1933.9MB/s      2090.5MB/s
WRITE:          1842.7MB/s       1935.3MB/s      2091.9MB/s
READ:           1832.4MB/s       1856.4MB/s      1971.5MB/s
WRITE:          1822.3MB/s       1846.2MB/s      1960.6MB/s
jobs8
READ:           20463MB/s        20194MB/s       20862MB/s
READ:           18178MB/s        17978MB/s       18299MB/s
WRITE:          4085.9MB/s       4060.2MB/s      7023.8MB/s
WRITE:          3776.3MB/s       3737.9MB/s      6278.2MB/s
READ:           1957.6MB/s       1944.4MB/s      2109.5MB/s
WRITE:          1959.2MB/s       1946.2MB/s      2111.4MB/s
READ:           1900.6MB/s       1885.7MB/s      2082.1MB/s
WRITE:          1896.2MB/s       1881.4MB/s      2078.3MB/s
jobs9
READ:           19692MB/s        19734MB/s       19334MB/s
READ:           17678MB/s        18249MB/s       17666MB/s
WRITE:          4004.7MB/s       4064.8MB/s      6990.7MB/s
WRITE:          3724.7MB/s       3772.1MB/s      6193.6MB/s
READ:           1953.7MB/s       1967.3MB/s      2105.6MB/s
WRITE:          1953.4MB/s       1966.7MB/s      2104.1MB/s
READ:           1860.4MB/s       1897.4MB/s      2068.5MB/s
WRITE:          1858.9MB/s       1895.9MB/s      2066.8MB/s
jobs10
READ:           19730MB/s        19579MB/s       19492MB/s
READ:           18028MB/s        18018MB/s       18221MB/s
WRITE:          4027.3MB/s       4090.6MB/s      7020.1MB/s
WRITE:          3810.5MB/s       3846.8MB/s      6426.8MB/s
READ:           1956.1MB/s       1994.6MB/s      2145.2MB/s
WRITE:          1955.9MB/s       1993.5MB/s      2144.8MB/s
READ:           1852.8MB/s       1911.6MB/s      2075.8MB/s
WRITE:          1855.7MB/s       1914.6MB/s      2078.1MB/s

perf stat

                                4 streams                       8 streams                       per-cpu
====================================================================================================================
jobs1
stalled-cycles-frontend      23,174,811,209 (  38.21%)     23,220,254,188 (  38.25%)       23,061,406,918 (  38.34%)
stalled-cycles-backend       11,514,174,638 (  18.98%)     11,696,722,657 (  19.27%)       11,370,852,810 (  18.90%)
instructions                 73,925,005,782 (    1.22)     73,903,177,632 (    1.22)       73,507,201,037 (    1.22)
branches                     14,455,124,835 ( 756.063)     14,455,184,779 ( 755.281)       14,378,599,509 ( 758.546)
branch-misses                    69,801,336 (   0.48%)         80,225,529 (   0.55%)           72,044,726 (   0.50%)
jobs2
stalled-cycles-frontend      49,912,741,782 (  46.11%)     50,101,189,290 (  45.95%)       32,874,195,633 (  35.11%)
stalled-cycles-backend       27,080,366,230 (  25.02%)     27,949,970,232 (  25.63%)       16,461,222,706 (  17.58%)
instructions                122,831,629,690 (    1.13)    122,919,846,419 (    1.13)      121,924,786,775 (    1.30)
branches                     23,725,889,239 ( 692.663)     23,733,547,140 ( 688.062)       23,553,950,311 ( 794.794)
branch-misses                    90,733,041 (   0.38%)         96,320,895 (   0.41%)           84,561,092 (   0.36%)
jobs3
stalled-cycles-frontend      66,437,834,608 (  45.58%)     63,534,923,344 (  43.69%)       42,101,478,505 (  33.19%)
stalled-cycles-backend       34,940,799,661 (  23.97%)     34,774,043,148 (  23.91%)       21,163,324,388 (  16.68%)
instructions                171,692,121,862 (    1.18)    171,775,373,044 (    1.18)      170,353,542,261 (    1.34)
branches                     32,968,962,622 ( 628.723)     32,987,739,894 ( 630.512)       32,729,463,918 ( 717.027)
branch-misses                   111,522,732 (   0.34%)        110,472,894 (   0.33%)           99,791,291 (   0.30%)
jobs4
stalled-cycles-frontend      98,741,701,675 (  49.72%)     94,797,349,965 (  47.59%)       54,535,655,381 (  33.53%)
stalled-cycles-backend       54,642,609,615 (  27.51%)     55,233,554,408 (  27.73%)       27,882,323,541 (  17.14%)
instructions                220,884,807,851 (    1.11)    220,930,887,273 (    1.11)      218,926,845,851 (    1.35)
branches                     42,354,518,180 ( 592.105)     42,362,770,587 ( 590.452)       41,955,552,870 ( 716.154)
branch-misses                   138,093,449 (   0.33%)        131,295,286 (   0.31%)          121,794,771 (   0.29%)
jobs5
stalled-cycles-frontend     116,219,747,212 (  48.14%)    110,310,397,012 (  46.29%)       66,373,082,723 (  33.70%)
stalled-cycles-backend       66,325,434,776 (  27.48%)     64,157,087,914 (  26.92%)       32,999,097,299 (  16.76%)
instructions                270,615,008,466 (    1.12)    270,546,409,525 (    1.14)      268,439,910,948 (    1.36)
branches                     51,834,046,557 ( 599.108)     51,811,867,722 ( 608.883)       51,412,576,077 ( 729.213)
branch-misses                   158,197,086 (   0.31%)        142,639,805 (   0.28%)          133,425,455 (   0.26%)
jobs6
stalled-cycles-frontend     138,009,414,492 (  48.23%)    139,063,571,254 (  48.80%)       75,278,568,278 (  32.80%)
stalled-cycles-backend       79,211,949,650 (  27.68%)     79,077,241,028 (  27.75%)       37,735,797,899 (  16.44%)
instructions                319,763,993,731 (    1.12)    319,937,782,834 (    1.12)      316,663,600,784 (    1.38)
branches                     61,219,433,294 ( 595.056)     61,250,355,540 ( 598.215)       60,523,446,617 ( 733.706)
branch-misses                   169,257,123 (   0.28%)        154,898,028 (   0.25%)          141,180,587 (   0.23%)
jobs7
stalled-cycles-frontend     162,974,812,119 (  49.20%)    159,290,061,987 (  48.43%)       88,046,641,169 (  33.21%)
stalled-cycles-backend       92,223,151,661 (  27.84%)     91,667,904,406 (  27.87%)       44,068,454,971 (  16.62%)
instructions                369,516,432,430 (    1.12)    369,361,799,063 (    1.12)      365,290,380,661 (    1.38)
branches                     70,795,673,950 ( 594.220)     70,743,136,124 ( 597.876)       69,803,996,038 ( 732.822)
branch-misses                   181,708,327 (   0.26%)        165,767,821 (   0.23%)          150,109,797 (   0.22%)
jobs8
stalled-cycles-frontend     185,000,017,027 (  49.30%)    182,334,345,473 (  48.37%)       99,980,147,041 (  33.26%)
stalled-cycles-backend      105,753,516,186 (  28.18%)    107,937,830,322 (  28.63%)       51,404,177,181 (  17.10%)
instructions                418,153,161,055 (    1.11)    418,308,565,828 (    1.11)      413,653,475,581 (    1.38)
branches                     80,035,882,398 ( 592.296)     80,063,204,510 ( 589.843)       79,024,105,589 ( 730.530)
branch-misses                   199,764,528 (   0.25%)        177,936,926 (   0.22%)          160,525,449 (   0.20%)
jobs9
stalled-cycles-frontend     210,941,799,094 (  49.63%)    204,714,679,254 (  48.55%)      114,251,113,756 (  33.96%)
stalled-cycles-backend      122,640,849,067 (  28.85%)    122,188,553,256 (  28.98%)       58,360,041,127 (  17.35%)
instructions                468,151,025,415 (    1.10)    467,354,869,323 (    1.11)      462,665,165,216 (    1.38)
branches                     89,657,067,510 ( 585.628)     89,411,550,407 ( 588.990)       88,360,523,943 ( 730.151)
branch-misses                   218,292,301 (   0.24%)        191,701,247 (   0.21%)          178,535,678 (   0.20%)
jobs10
stalled-cycles-frontend     233,595,958,008 (  49.81%)    227,540,615,689 (  49.11%)      160,341,979,938 (  43.07%)
stalled-cycles-backend      136,153,676,021 (  29.03%)    133,635,240,742 (  28.84%)       65,909,135,465 (  17.70%)
instructions                517,001,168,497 (    1.10)    516,210,976,158 (    1.11)      511,374,038,613 (    1.37)
branches                     98,911,641,329 ( 585.796)     98,700,069,712 ( 591.583)       97,646,761,028 ( 728.712)
branch-misses                   232,341,823 (   0.23%)        199,256,308 (   0.20%)          183,135,268 (   0.19%)

per-cpu streams tend to cause significantly less stalled cycles;
execute less branches and hit less branch-misses.

perf stat reported execution time

                        4 streams        8 streams       per-cpu
====================================================================
jobs1
seconds elapsed        20.909073870     20.875670495    20.817838540
jobs2
seconds elapsed        18.529488399     18.720566469    16.356103108
jobs3
seconds elapsed        18.991159531     18.991340812    16.766216066
jobs4
seconds elapsed        19.560643828     19.551323547    16.246621715
jobs5
seconds elapsed        24.746498464     25.221646740    20.696112444
jobs6
seconds elapsed        28.258181828     28.289765505    22.885688857
jobs7
seconds elapsed        32.632490241     31.909125381    26.272753738
jobs8
seconds elapsed        35.651403851     36.027596308    29.108024711
jobs9
seconds elapsed        40.569362365     40.024227989    32.898204012
jobs10
seconds elapsed        44.673112304     43.874898137    35.632952191

Please see
  Link: http://marc.info/?l=linux-kernel&m=146166970727530
  Link: http://marc.info/?l=linux-kernel&m=146174716719650
for more test results (under low memory conditions).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |  293 ++++++++------------------------
 drivers/block/zram/zcomp.h    |   12 -
 drivers/block/zram/zram_drv.c |   34 +++
 3 files changed, 112 insertions(+), 227 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-user-per-cpu-compression-streams drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-user-per-cpu-compression-streams
+++ a/drivers/block/zram/zcomp.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
 
 #include "zcomp.h"
 #include "zcomp_lzo.h"
@@ -20,29 +21,6 @@
 #include "zcomp_lz4.h"
 #endif
 
-/*
- * single zcomp_strm backend
- */
-struct zcomp_strm_single {
-	struct mutex strm_lock;
-	struct zcomp_strm *zstrm;
-};
-
-/*
- * multi zcomp_strm backend
- */
-struct zcomp_strm_multi {
-	/* protect strm list */
-	spinlock_t strm_lock;
-	/* max possible number of zstrm streams */
-	int max_strm;
-	/* number of available zstrm streams */
-	int avail_strm;
-	/* list of available strms */
-	struct list_head idle_strm;
-	wait_queue_head_t strm_wait;
-};
-
 static struct zcomp_backend *backends[] = {
 	&zcomp_lzo,
 #ifdef CONFIG_ZRAM_LZ4_COMPRESS
@@ -93,188 +71,6 @@ static struct zcomp_strm *zcomp_strm_all
 	return zstrm;
 }
 
-/*
- * get idle zcomp_strm or wait until other process release
- * (zcomp_strm_release()) one for us
- */
-static struct zcomp_strm *zcomp_strm_multi_find(struct zcomp *comp)
-{
-	struct zcomp_strm_multi *zs = comp->stream;
-	struct zcomp_strm *zstrm;
-
-	while (1) {
-		spin_lock(&zs->strm_lock);
-		if (!list_empty(&zs->idle_strm)) {
-			zstrm = list_entry(zs->idle_strm.next,
-					struct zcomp_strm, list);
-			list_del(&zstrm->list);
-			spin_unlock(&zs->strm_lock);
-			return zstrm;
-		}
-		/* zstrm streams limit reached, wait for idle stream */
-		if (zs->avail_strm >= zs->max_strm) {
-			spin_unlock(&zs->strm_lock);
-			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
-			continue;
-		}
-		/* allocate new zstrm stream */
-		zs->avail_strm++;
-		spin_unlock(&zs->strm_lock);
-		/*
-		 * This function can be called in swapout/fs write path
-		 * so we can't use GFP_FS|IO. And it assumes we already
-		 * have at least one stream in zram initialization so we
-		 * don't do best effort to allocate more stream in here.
-		 * A default stream will work well without further multiple
-		 * streams. That's why we use NORETRY | NOWARN.
-		 */
-		zstrm = zcomp_strm_alloc(comp, GFP_NOIO | __GFP_NORETRY |
-					__GFP_NOWARN);
-		if (!zstrm) {
-			spin_lock(&zs->strm_lock);
-			zs->avail_strm--;
-			spin_unlock(&zs->strm_lock);
-			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
-			continue;
-		}
-		break;
-	}
-	return zstrm;
-}
-
-/* add stream back to idle list and wake up waiter or free the stream */
-static void zcomp_strm_multi_release(struct zcomp *comp, struct zcomp_strm *zstrm)
-{
-	struct zcomp_strm_multi *zs = comp->stream;
-
-	spin_lock(&zs->strm_lock);
-	if (zs->avail_strm <= zs->max_strm) {
-		list_add(&zstrm->list, &zs->idle_strm);
-		spin_unlock(&zs->strm_lock);
-		wake_up(&zs->strm_wait);
-		return;
-	}
-
-	zs->avail_strm--;
-	spin_unlock(&zs->strm_lock);
-	zcomp_strm_free(comp, zstrm);
-}
-
-/* change max_strm limit */
-static bool zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
-{
-	struct zcomp_strm_multi *zs = comp->stream;
-	struct zcomp_strm *zstrm;
-
-	spin_lock(&zs->strm_lock);
-	zs->max_strm = num_strm;
-	/*
-	 * if user has lowered the limit and there are idle streams,
-	 * immediately free as much streams (and memory) as we can.
-	 */
-	while (zs->avail_strm > num_strm && !list_empty(&zs->idle_strm)) {
-		zstrm = list_entry(zs->idle_strm.next,
-				struct zcomp_strm, list);
-		list_del(&zstrm->list);
-		zcomp_strm_free(comp, zstrm);
-		zs->avail_strm--;
-	}
-	spin_unlock(&zs->strm_lock);
-	return true;
-}
-
-static void zcomp_strm_multi_destroy(struct zcomp *comp)
-{
-	struct zcomp_strm_multi *zs = comp->stream;
-	struct zcomp_strm *zstrm;
-
-	while (!list_empty(&zs->idle_strm)) {
-		zstrm = list_entry(zs->idle_strm.next,
-				struct zcomp_strm, list);
-		list_del(&zstrm->list);
-		zcomp_strm_free(comp, zstrm);
-	}
-	kfree(zs);
-}
-
-static int zcomp_strm_multi_create(struct zcomp *comp, int max_strm)
-{
-	struct zcomp_strm *zstrm;
-	struct zcomp_strm_multi *zs;
-
-	comp->destroy = zcomp_strm_multi_destroy;
-	comp->strm_find = zcomp_strm_multi_find;
-	comp->strm_release = zcomp_strm_multi_release;
-	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
-	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
-	if (!zs)
-		return -ENOMEM;
-
-	comp->stream = zs;
-	spin_lock_init(&zs->strm_lock);
-	INIT_LIST_HEAD(&zs->idle_strm);
-	init_waitqueue_head(&zs->strm_wait);
-	zs->max_strm = max_strm;
-	zs->avail_strm = 1;
-
-	zstrm = zcomp_strm_alloc(comp, GFP_KERNEL);
-	if (!zstrm) {
-		kfree(zs);
-		return -ENOMEM;
-	}
-	list_add(&zstrm->list, &zs->idle_strm);
-	return 0;
-}
-
-static struct zcomp_strm *zcomp_strm_single_find(struct zcomp *comp)
-{
-	struct zcomp_strm_single *zs = comp->stream;
-	mutex_lock(&zs->strm_lock);
-	return zs->zstrm;
-}
-
-static void zcomp_strm_single_release(struct zcomp *comp,
-		struct zcomp_strm *zstrm)
-{
-	struct zcomp_strm_single *zs = comp->stream;
-	mutex_unlock(&zs->strm_lock);
-}
-
-static bool zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
-{
-	/* zcomp_strm_single support only max_comp_streams == 1 */
-	return false;
-}
-
-static void zcomp_strm_single_destroy(struct zcomp *comp)
-{
-	struct zcomp_strm_single *zs = comp->stream;
-	zcomp_strm_free(comp, zs->zstrm);
-	kfree(zs);
-}
-
-static int zcomp_strm_single_create(struct zcomp *comp)
-{
-	struct zcomp_strm_single *zs;
-
-	comp->destroy = zcomp_strm_single_destroy;
-	comp->strm_find = zcomp_strm_single_find;
-	comp->strm_release = zcomp_strm_single_release;
-	comp->set_max_streams = zcomp_strm_single_set_max_streams;
-	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
-	if (!zs)
-		return -ENOMEM;
-
-	comp->stream = zs;
-	mutex_init(&zs->strm_lock);
-	zs->zstrm = zcomp_strm_alloc(comp, GFP_KERNEL);
-	if (!zs->zstrm) {
-		kfree(zs);
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 /* show available compressors */
 ssize_t zcomp_available_show(const char *comp, char *buf)
 {
@@ -301,17 +97,17 @@ bool zcomp_available_algorithm(const cha
 
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
 {
-	return comp->set_max_streams(comp, num_strm);
+	return true;
 }
 
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
-	return comp->strm_find(comp);
+	return *get_cpu_ptr(comp->stream);
 }
 
 void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
-	comp->strm_release(comp, zstrm);
+	put_cpu_ptr(comp->stream);
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
@@ -327,9 +123,83 @@ int zcomp_decompress(struct zcomp *comp,
 	return comp->backend->decompress(src, src_len, dst);
 }
 
+static int __zcomp_cpu_notifier(struct zcomp *comp,
+		unsigned long action, unsigned long cpu)
+{
+	struct zcomp_strm *zstrm;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		if (WARN_ON(*per_cpu_ptr(comp->stream, cpu)))
+			break;
+		zstrm = zcomp_strm_alloc(comp, GFP_KERNEL);
+		if (IS_ERR_OR_NULL(zstrm)) {
+			pr_err("Can't allocate a compression stream\n");
+			return NOTIFY_BAD;
+		}
+		*per_cpu_ptr(comp->stream, cpu) = zstrm;
+		break;
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+		zstrm = *per_cpu_ptr(comp->stream, cpu);
+		if (!IS_ERR_OR_NULL(zstrm))
+			zcomp_strm_free(comp, zstrm);
+		*per_cpu_ptr(comp->stream, cpu) = NULL;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static int zcomp_cpu_notifier(struct notifier_block *nb,
+		unsigned long action, void *pcpu)
+{
+	unsigned long cpu = (unsigned long)pcpu;
+	struct zcomp *comp = container_of(nb, typeof(*comp), notifier);
+
+	return __zcomp_cpu_notifier(comp, action, cpu);
+}
+
+static int zcomp_init(struct zcomp *comp)
+{
+	unsigned long cpu;
+	int ret;
+
+	comp->notifier.notifier_call = zcomp_cpu_notifier;
+
+	comp->stream = alloc_percpu(struct zcomp_strm *);
+	if (!comp->stream)
+		return -ENOMEM;
+
+	cpu_notifier_register_begin();
+	for_each_online_cpu(cpu) {
+		ret = __zcomp_cpu_notifier(comp, CPU_UP_PREPARE, cpu);
+		if (ret == NOTIFY_BAD)
+			goto cleanup;
+	}
+	__register_cpu_notifier(&comp->notifier);
+	cpu_notifier_register_done();
+	return 0;
+
+cleanup:
+	for_each_online_cpu(cpu)
+		__zcomp_cpu_notifier(comp, CPU_UP_CANCELED, cpu);
+	cpu_notifier_register_done();
+	return -ENOMEM;
+}
+
 void zcomp_destroy(struct zcomp *comp)
 {
-	comp->destroy(comp);
+	unsigned long cpu;
+
+	cpu_notifier_register_begin();
+	for_each_online_cpu(cpu)
+		__zcomp_cpu_notifier(comp, CPU_UP_CANCELED, cpu);
+	__unregister_cpu_notifier(&comp->notifier);
+	cpu_notifier_register_done();
+
+	free_percpu(comp->stream);
 	kfree(comp);
 }
 
@@ -356,10 +226,7 @@ struct zcomp *zcomp_create(const char *c
 		return ERR_PTR(-ENOMEM);
 
 	comp->backend = backend;
-	if (max_strm > 1)
-		error = zcomp_strm_multi_create(comp, max_strm);
-	else
-		error = zcomp_strm_single_create(comp);
+	error = zcomp_init(comp);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
diff -puN drivers/block/zram/zcomp.h~zram-user-per-cpu-compression-streams drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-user-per-cpu-compression-streams
+++ a/drivers/block/zram/zcomp.h
@@ -10,8 +10,6 @@
 #ifndef _ZCOMP_H_
 #define _ZCOMP_H_
 
-#include <linux/mutex.h>
-
 struct zcomp_strm {
 	/* compression/decompression buffer */
 	void *buffer;
@@ -21,8 +19,6 @@ struct zcomp_strm {
 	 * working memory)
 	 */
 	void *private;
-	/* used in multi stream backend, protected by backend strm_lock */
-	struct list_head list;
 };
 
 /* static compression backend */
@@ -41,13 +37,9 @@ struct zcomp_backend {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	void *stream;
+	struct zcomp_strm * __percpu *stream;
 	struct zcomp_backend *backend;
-
-	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
-	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
-	bool (*set_max_streams)(struct zcomp *comp, int num_strm);
-	void (*destroy)(struct zcomp *comp);
+	struct notifier_block notifier;
 };
 
 ssize_t zcomp_available_show(const char *comp, char *buf);
diff -puN drivers/block/zram/zram_drv.c~zram-user-per-cpu-compression-streams drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-user-per-cpu-compression-streams
+++ a/drivers/block/zram/zram_drv.c
@@ -650,7 +650,7 @@ static int zram_bvec_write(struct zram *
 {
 	int ret = 0;
 	size_t clen;
-	unsigned long handle;
+	unsigned long handle = 0;
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
@@ -673,9 +673,8 @@ static int zram_bvec_write(struct zram *
 			goto out;
 	}
 
-	zstrm = zcomp_strm_find(zram->comp);
+compress_again:
 	user_mem = kmap_atomic(page);
-
 	if (is_partial_io(bvec)) {
 		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
 		       bvec->bv_len);
@@ -699,6 +698,7 @@ static int zram_bvec_write(struct zram *
 		goto out;
 	}
 
+	zstrm = zcomp_strm_find(zram->comp);
 	ret = zcomp_compress(zram->comp, zstrm, uncmem, &clen);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
@@ -710,6 +710,7 @@ static int zram_bvec_write(struct zram *
 		pr_err("Compression failed! err=%d\n", ret);
 		goto out;
 	}
+
 	src = zstrm->buffer;
 	if (unlikely(clen > max_zpage_size)) {
 		clen = PAGE_SIZE;
@@ -717,8 +718,33 @@ static int zram_bvec_write(struct zram *
 			src = uncmem;
 	}
 
-	handle = zs_malloc(meta->mem_pool, clen, GFP_NOIO | __GFP_HIGHMEM);
+	/*
+	 * handle allocation has 2 paths:
+	 * a) fast path is executed with preemption disabled (for
+	 *  per-cpu streams) and has __GFP_DIRECT_RECLAIM bit clear,
+	 *  since we can't sleep;
+	 * b) slow path enables preemption and attempts to allocate
+	 *  the page with __GFP_DIRECT_RECLAIM bit set. we have to
+	 *  put per-cpu compression stream and, thus, to re-do
+	 *  the compression once handle is allocated.
+	 *
+	 * if we have a 'non-null' handle here then we are coming
+	 * from the slow path and handle has already been allocated.
+	 */
+	if (!handle)
+		handle = zs_malloc(meta->mem_pool, clen,
+				__GFP_KSWAPD_RECLAIM |
+				__GFP_NOWARN |
+				__GFP_HIGHMEM);
 	if (!handle) {
+		zcomp_strm_release(zram->comp, zstrm);
+		zstrm = NULL;
+
+		handle = zs_malloc(meta->mem_pool, clen,
+				GFP_NOIO | __GFP_HIGHMEM);
+		if (handle)
+			goto compress_again;
+
 		pr_err("Error allocating memory for compressed page: %u, size=%zu\n",
 			index, clen);
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-require-gfp-in-zs_malloc.patch
zram-user-per-cpu-compression-streams.patch

