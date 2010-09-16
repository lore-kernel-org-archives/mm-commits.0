From: akpm@linux-foundation.org
Subject: + tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:28:22 -0700
Message-ID: <201009162228.o8GMSMj7017298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754903Ab0IPW3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:29:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     tracing, vmscan: add trace events for LRU list shrinking
has been added to the -mm tree.  Its filename is
     tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracing, vmscan: add trace events for LRU list shrinking
From: Mel Gorman <mel@csn.ul.ie>

There have been numerous reports of stalls that pointed at the problem
being somewhere in the VM.  There are multiple roots to the problems which
means dealing with any of the root problems in isolation is tricky to
justify on their own and they would still need integration testing.  This
patch series puts together two different patch sets which in combination
should tackle some of the root causes of latency problems being reported.

Patch 1 adds a tracepoint for shrink_inactive_list.  For this series, the
most important results is being able to calculate the scanning/reclaim
ratio as a measure of the amount of work being done by page reclaim.

Patch 2 accounts for time spent in congestion_wait.

Patches 3-6 were originally developed by Kosaki Motohiro but reworked for
this series.  It has been noted that lumpy reclaim is far too aggressive
and trashes the system somewhat.  As SLUB uses high-order allocations, a
large cost incurred by lumpy reclaim will be noticeable.  It was also
reported during transparent hugepage support testing that lumpy reclaim
was trashing the system and these patches should mitigate that problem
without disabling lumpy reclaim.

Patch 7 adds wait_iff_congested() and replaces some callers of
congestion_wait().  wait_iff_congested() only sleeps if there is a BDI
that is currently congested.  Patch 8 notes that any BDI being congested
is not necessarily a problem because there could be multiple BDIs of
varying speeds and numberous zones.  It attempts to track when a zone
being reclaimed contains many pages backed by a congested BDI and if so,
reclaimers wait on the congestion queue.

I ran a number of tests with monitoring on X86, X86-64 and PPC64. Each
machine had 3G of RAM and the CPUs were

X86:    Intel P4 2-core
X86-64: AMD Phenom 4-core
PPC64:  PPC970MP

Each used a single disk and the onboard IO controller.  Dirty ratio was
left at 20.  I'm just going to report for X86-64 and PPC64 in a vague
attempt to keep this report short.  Four kernels were tested each based on
v2.6.36-rc4

traceonly-v2r2:     Patches 1 and 2 to instrument vmscan reclaims and congestion_wait
lowlumpy-v2r3:      Patches 1-6 to test if lumpy reclaim is better
waitcongest-v2r3:   Patches 1-7 to only wait on congestion
waitwriteback-v2r4: Patches 1-8 to detect when a zone is congested

nocongest-v1r5: Patches 1-3 for testing wait_iff_congestion
nodirect-v1r5:  Patches 1-10 to disable filesystem writeback for better IO

The tests run were as follows

kernbench
	compile-based benchmark. Smoke test performance

sysbench
	OLTP read-only benchmark. Will be re-run in the future as read-write

micro-mapped-file-stream
	This is a micro-benchmark from Johannes Weiner that accesses a
	large sparse-file through mmap(). It was configured to run in only
	single-CPU mode but can be indicative of how well page reclaim
	identifies suitable pages.

stress-highalloc
	Tries to allocate huge pages under heavy load.

kernbench, iozone and sysbench did not report any performance regression
on any machine.  sysbench did pressure the system lightly and there was
reclaim activity but there were no difference of major interest between
the kernels.

X86-64 micro-mapped-file-stream

                                      traceonly-v2r2           lowlumpy-v2r3        waitcongest-v2r3     waitwriteback-v2r4
pgalloc_dma                       1639.00 (   0.00%)       667.00 (-145.73%)      1167.00 ( -40.45%)       578.00 (-183.56%)
pgalloc_dma32                  2842410.00 (   0.00%)   2842626.00 (   0.01%)   2843043.00 (   0.02%)   2843014.00 (   0.02%)
pgalloc_normal                       0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pgsteal_dma                        729.00 (   0.00%)        85.00 (-757.65%)       609.00 ( -19.70%)       125.00 (-483.20%)
pgsteal_dma32                  2338721.00 (   0.00%)   2447354.00 (   4.44%)   2429536.00 (   3.74%)   2436772.00 (   4.02%)
pgsteal_normal                       0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pgscan_kswapd_dma                 1469.00 (   0.00%)       532.00 (-176.13%)      1078.00 ( -36.27%)       220.00 (-567.73%)
pgscan_kswapd_dma32            4597713.00 (   0.00%)   4503597.00 (  -2.09%)   4295673.00 (  -7.03%)   3891686.00 ( -18.14%)
pgscan_kswapd_normal                 0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pgscan_direct_dma                   71.00 (   0.00%)       134.00 (  47.01%)       243.00 (  70.78%)       352.00 (  79.83%)
pgscan_direct_dma32             305820.00 (   0.00%)    280204.00 (  -9.14%)    600518.00 (  49.07%)    957485.00 (  68.06%)
pgscan_direct_normal                 0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pageoutrun                       16296.00 (   0.00%)     21254.00 (  23.33%)     18447.00 (  11.66%)     20067.00 (  18.79%)
allocstall                         443.00 (   0.00%)       273.00 ( -62.27%)       513.00 (  13.65%)      1568.00 (  71.75%)

These are based on the raw figures taken from /proc/vmstat.  It's a rough
measure of reclaim activity.  Note that allocstall counts are higher
because we are entering direct reclaim more often as a result of not
sleeping in congestion.  In itself, it's not necessarily a bad thing. 
It's easier to get a view of what happened from the vmscan tracepoint
report.

FTrace Reclaim Statistics: vmscan

                                traceonly-v2r2   lowlumpy-v2r3 waitcongest-v2r3 waitwriteback-v2r4
Direct reclaims                                443        273        513       1568 
Direct reclaim pages scanned                305968     280402     600825     957933 
Direct reclaim pages reclaimed               43503      19005      30327     117191 
Direct reclaim write file async I/O              0          0          0          0 
Direct reclaim write anon async I/O              0          3          4         12 
Direct reclaim write file sync I/O               0          0          0          0 
Direct reclaim write anon sync I/O               0          0          0          0 
Wake kswapd requests                        187649     132338     191695     267701 
Kswapd wakeups                                   3          1          4          1 
Kswapd pages scanned                       4599269    4454162    4296815    3891906 
Kswapd pages reclaimed                     2295947    2428434    2399818    2319706 
Kswapd reclaim write file async I/O              1          0          1          1 
Kswapd reclaim write anon async I/O             59        187         41        222 
Kswapd reclaim write file sync I/O               0          0          0          0 
Kswapd reclaim write anon sync I/O               0          0          0          0 
Time stalled direct reclaim (seconds)         4.34       2.52       6.63       2.96 
Time kswapd awake (seconds)                  11.15      10.25      11.01      10.19 

Total pages scanned                        4905237   4734564   4897640   4849839
Total pages reclaimed                      2339450   2447439   2430145   2436897
%age total pages scanned/reclaimed          47.69%    51.69%    49.62%    50.25%
%age total pages scanned/written             0.00%     0.00%     0.00%     0.00%
%age  file pages scanned/written             0.00%     0.00%     0.00%     0.00%
Percentage Time Spent Direct Reclaim        29.23%    19.02%    38.48%    20.25%
Percentage Time kswapd Awake                78.58%    78.85%    76.83%    79.86%

What is interesting here for nocongest in particular is that while direct
reclaim scans more pages, the overall number of pages scanned remains the
same and the ratio of pages scanned to pages reclaimed is more or less the
same.  In other words, while we are sleeping less, reclaim is not doing
more work and as direct reclaim and kswapd is awake for less time, it
would appear to be doing less work.

FTrace Reclaim Statistics: congestion_wait
Direct number congest     waited                87        196         64          0 
Direct time   congest     waited            4604ms     4732ms     5420ms        0ms 
Direct full   congest     waited                72        145         53          0 
Direct number conditional waited                 0          0        324       1315 
Direct time   conditional waited               0ms        0ms        0ms        0ms 
Direct full   conditional waited                 0          0          0          0 
KSwapd number congest     waited                20         10         15          7 
KSwapd time   congest     waited            1264ms      536ms      884ms      284ms 
KSwapd full   congest     waited                10          4          6          2 
KSwapd number conditional waited                 0          0          0          0 
KSwapd time   conditional waited               0ms        0ms        0ms        0ms 
KSwapd full   conditional waited                 0          0          0          0 

The vanilla kernel spent 8 seconds asleep in direct reclaim and no time at
all asleep with the patches.

MMTests Statistics: duration
User/Sys Time Running Test (seconds)         10.51     10.73      10.6     11.66
Total Elapsed Time (seconds)                 14.19     13.00     14.33     12.76

Overall, the tests completed faster. It is interesting to note that backing off further
when a zone is congested and not just a BDI was more efficient overall.

PPC64 micro-mapped-file-stream
pgalloc_dma                    3024660.00 (   0.00%)   3027185.00 (   0.08%)   3025845.00 (   0.04%)   3026281.00 (   0.05%)
pgalloc_normal                       0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pgsteal_dma                    2508073.00 (   0.00%)   2565351.00 (   2.23%)   2463577.00 (  -1.81%)   2532263.00 (   0.96%)
pgsteal_normal                       0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pgscan_kswapd_dma              4601307.00 (   0.00%)   4128076.00 ( -11.46%)   3912317.00 ( -17.61%)   3377165.00 ( -36.25%)
pgscan_kswapd_normal                 0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pgscan_direct_dma               629825.00 (   0.00%)    971622.00 (  35.18%)   1063938.00 (  40.80%)   1711935.00 (  63.21%)
pgscan_direct_normal                 0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)         0.00 (   0.00%)
pageoutrun                       27776.00 (   0.00%)     20458.00 ( -35.77%)     18763.00 ( -48.04%)     18157.00 ( -52.98%)
allocstall                         977.00 (   0.00%)      2751.00 (  64.49%)      2098.00 (  53.43%)      5136.00 (  80.98%)

Similar trends to x86-64. allocstalls are up but it's not necessarily bad.

FTrace Reclaim Statistics: vmscan
Direct reclaims                                977       2709       2098       5136 
Direct reclaim pages scanned                629825     963814    1063938    1711935 
Direct reclaim pages reclaimed               75550     242538     150904     387647 
Direct reclaim write file async I/O              0          0          0          2 
Direct reclaim write anon async I/O              0         10          0          4 
Direct reclaim write file sync I/O               0          0          0          0 
Direct reclaim write anon sync I/O               0          0          0          0 
Wake kswapd requests                        392119    1201712     571935     571921 
Kswapd wakeups                                   3          2          3          3 
Kswapd pages scanned                       4601307    4128076    3912317    3377165 
Kswapd pages reclaimed                     2432523    2318797    2312673    2144616 
Kswapd reclaim write file async I/O             20          1          1          1 
Kswapd reclaim write anon async I/O             57        132         11        121 
Kswapd reclaim write file sync I/O               0          0          0          0 
Kswapd reclaim write anon sync I/O               0          0          0          0 
Time stalled direct reclaim (seconds)         6.19       7.30      13.04      10.88 
Time kswapd awake (seconds)                  21.73      26.51      25.55      23.90 

Total pages scanned                        5231132   5091890   4976255   5089100
Total pages reclaimed                      2508073   2561335   2463577   2532263
%age total pages scanned/reclaimed          47.95%    50.30%    49.51%    49.76%
%age total pages scanned/written             0.00%     0.00%     0.00%     0.00%
%age  file pages scanned/written             0.00%     0.00%     0.00%     0.00%
Percentage Time Spent Direct Reclaim        18.89%    20.65%    32.65%    27.65%
Percentage Time kswapd Awake                72.39%    80.68%    78.21%    77.40%

Again, a similar trend that the congestion_wait changes mean that direct
reclaim scans more pages but the overall number of pages scanned while
slightly reduced, are very similar.  The ratio of scanning/reclaimed
remains roughly similar.  The downside is that kswapd and direct reclaim
was awake longer and for a larger percentage of the overall workload. 
It's possible there were big differences in the amount of time spent
reclaiming slab pages between the different kernels which is plausible
considering that the micro tests runs after fsmark and sysbench.

Trace Reclaim Statistics: congestion_wait
Direct number congest     waited               845       1312        104          0 
Direct time   congest     waited           19416ms    26560ms     7544ms        0ms 
Direct full   congest     waited               745       1105         72          0 
Direct number conditional waited                 0          0       1322       2935 
Direct time   conditional waited               0ms        0ms       12ms      312ms 
Direct full   conditional waited                 0          0          0          3 
KSwapd number congest     waited                39        102         75         63 
KSwapd time   congest     waited            2484ms     6760ms     5756ms     3716ms 
KSwapd full   congest     waited                20         48         46         25 
KSwapd number conditional waited                 0          0          0          0 
KSwapd time   conditional waited               0ms        0ms        0ms        0ms 
KSwapd full   conditional waited                 0          0          0          0 

The vanilla kernel spent 20 seconds asleep in direct reclaim and only
312ms asleep with the patches.  The time kswapd spent congest waited was
also reduced by a large factor.

MMTests Statistics: duration
ser/Sys Time Running Test (seconds)         26.58     28.05      26.9     28.47
Total Elapsed Time (seconds)                 30.02     32.86     32.67     30.88

With all patches applies, the completion times are very similar.


X86-64 STRESS-HIGHALLOC
                traceonly-v2r2     lowlumpy-v2r3  waitcongest-v2r3waitwriteback-v2r4
Pass 1          82.00 ( 0.00%)    84.00 ( 2.00%)    85.00 ( 3.00%)    85.00 ( 3.00%)
Pass 2          90.00 ( 0.00%)    87.00 (-3.00%)    88.00 (-2.00%)    89.00 (-1.00%)
At Rest         92.00 ( 0.00%)    90.00 (-2.00%)    90.00 (-2.00%)    91.00 (-1.00%)

Success figures across the board are broadly similar.

                traceonly-v2r2     lowlumpy-v2r3  waitcongest-v2r3waitwriteback-v2r4
Direct reclaims                               1045        944        886        887 
Direct reclaim pages scanned                135091     119604     109382     101019 
Direct reclaim pages reclaimed               88599      47535      47863      46671 
Direct reclaim write file async I/O            494        283        465        280 
Direct reclaim write anon async I/O          29357      13710      16656      13462 
Direct reclaim write file sync I/O             154          2          2          3 
Direct reclaim write anon sync I/O           14594        571        509        561 
Wake kswapd requests                          7491        933        872        892 
Kswapd wakeups                                 814        778        731        780 
Kswapd pages scanned                       7290822   15341158   11916436   13703442 
Kswapd pages reclaimed                     3587336    3142496    3094392    3187151 
Kswapd reclaim write file async I/O          91975      32317      28022      29628 
Kswapd reclaim write anon async I/O        1992022     789307     829745     849769 
Kswapd reclaim write file sync I/O               0          0          0          0 
Kswapd reclaim write anon sync I/O               0          0          0          0 
Time stalled direct reclaim (seconds)      4588.93    2467.16    2495.41    2547.07 
Time kswapd awake (seconds)                2497.66    1020.16    1098.06    1176.82 

Total pages scanned                        7425913  15460762  12025818  13804461
Total pages reclaimed                      3675935   3190031   3142255   3233822
%age total pages scanned/reclaimed          49.50%    20.63%    26.13%    23.43%
%age total pages scanned/written            28.66%     5.41%     7.28%     6.47%
%age  file pages scanned/written             1.25%     0.21%     0.24%     0.22%
Percentage Time Spent Direct Reclaim        57.33%    42.15%    42.41%    42.99%
Percentage Time kswapd Awake                43.56%    27.87%    29.76%    31.25%

Scanned/reclaimed ratios again look good with big improvements in
efficiency.  The Scanned/written ratios also look much improved.  With a
better scanned/written ration, there is an expectation that IO would be
more efficient and indeed, the time spent in direct reclaim is much
reduced by the full series and kswapd spends a little less time awake.

Overall, indications here are that allocations were happening much faster
and this can be seen with a graph of the latency figures as the
allocations were taking place
http://www.csn.ul.ie/~mel/postings/vmscanreduce-20101509/highalloc-interlatency-hydra-mean.ps

FTrace Reclaim Statistics: congestion_wait
Direct number congest     waited              1333        204        169          4 
Direct time   congest     waited           78896ms     8288ms     7260ms      200ms 
Direct full   congest     waited               756         92         69          2 
Direct number conditional waited                 0          0         26        186 
Direct time   conditional waited               0ms        0ms        0ms     2504ms 
Direct full   conditional waited                 0          0          0         25 
KSwapd number congest     waited                 4        395        227        282 
KSwapd time   congest     waited             384ms    25136ms    10508ms    18380ms 
KSwapd full   congest     waited                 3        232         98        176 
KSwapd number conditional waited                 0          0          0          0 
KSwapd time   conditional waited               0ms        0ms        0ms        0ms 
KSwapd full   conditional waited                 0          0          0          0 
KSwapd full   conditional waited               318          0        312          9 


Overall, the time spent speeping is reduced.  kswapd is still hitting
congestion_wait() but that is because there are callers remaining where it
wasn't clear in advance if they should be changed to wait_iff_congested()
or not.  Overall the sleep imes are reduced though - from 79ish seconds to
about 19.

MMTests Statistics: duration
User/Sys Time Running Test (seconds)       3415.43   3386.65   3388.39    3377.5
Total Elapsed Time (seconds)               5733.48   3660.33   3689.41   3765.39

With the full series, the time to complete the tests are reduced by 30%

PPC64 STRESS-HIGHALLOC
                traceonly-v2r2     lowlumpy-v2r3  waitcongest-v2r3waitwriteback-v2r4
Pass 1          17.00 ( 0.00%)    34.00 (17.00%)    38.00 (21.00%)    43.00 (26.00%)
Pass 2          25.00 ( 0.00%)    37.00 (12.00%)    42.00 (17.00%)    46.00 (21.00%)
At Rest         49.00 ( 0.00%)    43.00 (-6.00%)    45.00 (-4.00%)    51.00 ( 2.00%)

Success rates there are *way* up particularly considering that the 16MB
huge pages on PPC64 mean that it's always much harder to allocate them.

FTrace Reclaim Statistics: vmscan
              stress-highalloc  stress-highalloc  stress-highalloc  stress-highalloc
                traceonly-v2r2     lowlumpy-v2r3  waitcongest-v2r3waitwriteback-v2r4
Direct reclaims                                499        505        564        509 
Direct reclaim pages scanned                223478      41898      51818      45605 
Direct reclaim pages reclaimed              137730      21148      27161      23455 
Direct reclaim write file async I/O            399        136        162        136 
Direct reclaim write anon async I/O          46977       2865       4686       3998 
Direct reclaim write file sync I/O              29          0          1          3 
Direct reclaim write anon sync I/O           31023        159        237        239 
Wake kswapd requests                           420        351        360        326 
Kswapd wakeups                                 185        294        249        277 
Kswapd pages scanned                      15703488   16392500   17821724   17598737 
Kswapd pages reclaimed                     5808466    2908858    3139386    3145435 
Kswapd reclaim write file async I/O         159938      18400      18717      13473 
Kswapd reclaim write anon async I/O        3467554     228957     322799     234278 
Kswapd reclaim write file sync I/O               0          0          0          0 
Kswapd reclaim write anon sync I/O               0          0          0          0 
Time stalled direct reclaim (seconds)      9665.35    1707.81    2374.32    1871.23 
Time kswapd awake (seconds)                9401.21    1367.86    1951.75    1328.88 

Total pages scanned                       15926966  16434398  17873542  17644342
Total pages reclaimed                      5946196   2930006   3166547   3168890
%age total pages scanned/reclaimed          37.33%    17.83%    17.72%    17.96%
%age total pages scanned/written            23.27%     1.52%     1.94%     1.43%
%age  file pages scanned/written             1.01%     0.11%     0.11%     0.08%
Percentage Time Spent Direct Reclaim        44.55%    35.10%    41.42%    36.91%
Percentage Time kswapd Awake                86.71%    43.58%    52.67%    41.14%

While the scanning rates are slightly up, the scanned/reclaimed and
scanned/written figures are much improved.  The time spent in direct
reclaim and with kswapd are massively reduced, mostly by the lowlumpy
patches.

FTrace Reclaim Statistics: congestion_wait
Direct number congest     waited               725        303        126          3 
Direct time   congest     waited           45524ms     9180ms     5936ms      300ms 
Direct full   congest     waited               487        190         52          3 
Direct number conditional waited                 0          0        200        301 
Direct time   conditional waited               0ms        0ms        0ms     1904ms 
Direct full   conditional waited                 0          0          0         19 
KSwapd number congest     waited                 0          2         23          4 
KSwapd time   congest     waited               0ms      200ms      420ms      404ms 
KSwapd full   congest     waited                 0          2          2          4 
KSwapd number conditional waited                 0          0          0          0 
KSwapd time   conditional waited               0ms        0ms        0ms        0ms 
KSwapd full   conditional waited                 0          0          0          0 


Not as dramatic a story here but the time spent asleep is reduced and we
can still see what wait_iff_congested is going to sleep when necessary.

MMTests Statistics: duration
User/Sys Time Running Test (seconds)      12028.09   3157.17   3357.79   3199.16
Total Elapsed Time (seconds)              10842.07   3138.72   3705.54   3229.85

The time to complete this test goes way down.  With the full series, we
are allocating over twice the number of huge pages in 30% of the time and
there is a corresponding impact on the allocation latency graph available
at.

http://www.csn.ul.ie/~mel/postings/vmscanreduce-20101509/highalloc-interlatency-powyah-mean.ps



This patch:

Add a trace event for shrink_inactive_list() and updates the sample
postprocessing script appropriately.  It can be used to determine how many
pages were reclaimed and for non-lumpy reclaim where exactly the pages
were reclaimed from.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/postprocess/trace-vmscan-postprocess.pl |   39 ++++++---
 include/trace/events/vmscan.h                               |   42 ++++++++++
 mm/vmscan.c                                                 |    6 +
 3 files changed, 77 insertions(+), 10 deletions(-)

diff -puN Documentation/trace/postprocess/trace-vmscan-postprocess.pl~tracing-vmscan-add-trace-events-for-lru-list-shrinking Documentation/trace/postprocess/trace-vmscan-postprocess.pl
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl~tracing-vmscan-add-trace-events-for-lru-list-shrinking
+++ a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -46,7 +46,7 @@ use constant HIGH_KSWAPD_LATENCY		=> 20;
 use constant HIGH_KSWAPD_REWAKEUP		=> 21;
 use constant HIGH_NR_SCANNED			=> 22;
 use constant HIGH_NR_TAKEN			=> 23;
-use constant HIGH_NR_RECLAIM			=> 24;
+use constant HIGH_NR_RECLAIMED			=> 24;
 use constant HIGH_NR_CONTIG_DIRTY		=> 25;
 
 my %perprocesspid;
@@ -58,11 +58,13 @@ my $opt_read_procstat;
 my $total_wakeup_kswapd;
 my ($total_direct_reclaim, $total_direct_nr_scanned);
 my ($total_direct_latency, $total_kswapd_latency);
+my ($total_direct_nr_reclaimed);
 my ($total_direct_writepage_file_sync, $total_direct_writepage_file_async);
 my ($total_direct_writepage_anon_sync, $total_direct_writepage_anon_async);
 my ($total_kswapd_nr_scanned, $total_kswapd_wake);
 my ($total_kswapd_writepage_file_sync, $total_kswapd_writepage_file_async);
 my ($total_kswapd_writepage_anon_sync, $total_kswapd_writepage_anon_async);
+my ($total_kswapd_nr_reclaimed);
 
 # Catch sigint and exit on request
 my $sigint_report = 0;
@@ -104,7 +106,7 @@ my $regex_kswapd_wake_default = 'nid=([0
 my $regex_kswapd_sleep_default = 'nid=([0-9]*)';
 my $regex_wakeup_kswapd_default = 'nid=([0-9]*) zid=([0-9]*) order=([0-9]*)';
 my $regex_lru_isolate_default = 'isolate_mode=([0-9]*) order=([0-9]*) nr_requested=([0-9]*) nr_scanned=([0-9]*) nr_taken=([0-9]*) contig_taken=([0-9]*) contig_dirty=([0-9]*) contig_failed=([0-9]*)';
-my $regex_lru_shrink_inactive_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) priority=([0-9]*)';
+my $regex_lru_shrink_inactive_default = 'nid=([0-9]*) zid=([0-9]*) nr_scanned=([0-9]*) nr_reclaimed=([0-9]*) priority=([0-9]*) flags=([A-Z_|]*)';
 my $regex_lru_shrink_active_default = 'lru=([A-Z_]*) nr_scanned=([0-9]*) nr_rotated=([0-9]*) priority=([0-9]*)';
 my $regex_writepage_default = 'page=([0-9a-f]*) pfn=([0-9]*) flags=([A-Z_|]*)';
 
@@ -203,8 +205,8 @@ $regex_lru_shrink_inactive = generate_tr
 			"vmscan/mm_vmscan_lru_shrink_inactive",
 			$regex_lru_shrink_inactive_default,
 			"nid", "zid",
-			"lru",
-			"nr_scanned", "nr_reclaimed", "priority");
+			"nr_scanned", "nr_reclaimed", "priority",
+			"flags");
 $regex_lru_shrink_active = generate_traceevent_regex(
 			"vmscan/mm_vmscan_lru_shrink_active",
 			$regex_lru_shrink_active_default,
@@ -375,6 +377,16 @@ EVENT_PROCESS:
 			my $nr_contig_dirty = $7;
 			$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
 			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
+		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
+			$details = $5;
+			if ($details !~ /$regex_lru_shrink_inactive/o) {
+				print "WARNING: Failed to parse mm_vmscan_lru_shrink_inactive as expected\n";
+				print "         $details\n";
+				print "         $regex_lru_shrink_inactive/o\n";
+				next;
+			}
+			my $nr_reclaimed = $4;
+			$perprocesspid{$process_pid}->{HIGH_NR_RECLAIMED} += $nr_reclaimed;
 		} elsif ($tracepoint eq "mm_vmscan_writepage") {
 			$details = $5;
 			if ($details !~ /$regex_writepage/o) {
@@ -464,8 +476,8 @@ sub dump_stats {
 
 	# Print out process activity
 	printf("\n");
-	printf("%-" . $max_strlen . "s %8s %10s   %8s   %8s %8s %8s %8s\n", "Process", "Direct",  "Wokeup", "Pages",   "Pages",   "Pages",     "Time");
-	printf("%-" . $max_strlen . "s %8s %10s   %8s   %8s %8s %8s %8s\n", "details", "Rclms",   "Kswapd", "Scanned", "Sync-IO", "ASync-IO",  "Stalled");
+	printf("%-" . $max_strlen . "s %8s %10s   %8s %8s  %8s %8s %8s %8s\n", "Process", "Direct",  "Wokeup", "Pages",   "Pages",   "Pages",   "Pages",     "Time");
+	printf("%-" . $max_strlen . "s %8s %10s   %8s %8s  %8s %8s %8s %8s\n", "details", "Rclms",   "Kswapd", "Scanned", "Rclmed",  "Sync-IO", "ASync-IO",  "Stalled");
 	foreach $process_pid (keys %stats) {
 
 		if (!$stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN}) {
@@ -475,6 +487,7 @@ sub dump_stats {
 		$total_direct_reclaim += $stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN};
 		$total_wakeup_kswapd += $stats{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD};
 		$total_direct_nr_scanned += $stats{$process_pid}->{HIGH_NR_SCANNED};
+		$total_direct_nr_reclaimed += $stats{$process_pid}->{HIGH_NR_RECLAIMED};
 		$total_direct_writepage_file_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
 		$total_direct_writepage_anon_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
 		$total_direct_writepage_file_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
@@ -489,11 +502,12 @@ sub dump_stats {
 			$index++;
 		}
 
-		printf("%-" . $max_strlen . "s %8d %10d   %8u   %8u %8u %8.3f",
+		printf("%-" . $max_strlen . "s %8d %10d   %8u %8u  %8u %8u %8.3f",
 			$process_pid,
 			$stats{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN},
 			$stats{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD},
 			$stats{$process_pid}->{HIGH_NR_SCANNED},
+			$stats{$process_pid}->{HIGH_NR_RECLAIMED},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC},
 			$this_reclaim_delay / 1000);
@@ -529,8 +543,8 @@ sub dump_stats {
 
 	# Print out kswapd activity
 	printf("\n");
-	printf("%-" . $max_strlen . "s %8s %10s   %8s   %8s %8s %8s\n", "Kswapd",   "Kswapd",  "Order",     "Pages",   "Pages",  "Pages");
-	printf("%-" . $max_strlen . "s %8s %10s   %8s   %8s %8s %8s\n", "Instance", "Wakeups", "Re-wakeup", "Scanned", "Sync-IO", "ASync-IO");
+	printf("%-" . $max_strlen . "s %8s %10s   %8s   %8s %8s %8s\n", "Kswapd",   "Kswapd",  "Order",     "Pages",   "Pages",   "Pages",  "Pages");
+	printf("%-" . $max_strlen . "s %8s %10s   %8s   %8s %8s %8s\n", "Instance", "Wakeups", "Re-wakeup", "Scanned", "Rclmed",  "Sync-IO", "ASync-IO");
 	foreach $process_pid (keys %stats) {
 
 		if (!$stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE}) {
@@ -539,16 +553,18 @@ sub dump_stats {
 
 		$total_kswapd_wake += $stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE};
 		$total_kswapd_nr_scanned += $stats{$process_pid}->{HIGH_NR_SCANNED};
+		$total_kswapd_nr_reclaimed += $stats{$process_pid}->{HIGH_NR_RECLAIMED};
 		$total_kswapd_writepage_file_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
 		$total_kswapd_writepage_anon_sync += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
 		$total_kswapd_writepage_file_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
 		$total_kswapd_writepage_anon_async += $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC};
 
-		printf("%-" . $max_strlen . "s %8d %10d   %8u   %8i %8u",
+		printf("%-" . $max_strlen . "s %8d %10d   %8u %8u  %8i %8u",
 			$process_pid,
 			$stats{$process_pid}->{MM_VMSCAN_KSWAPD_WAKE},
 			$stats{$process_pid}->{HIGH_KSWAPD_REWAKEUP},
 			$stats{$process_pid}->{HIGH_NR_SCANNED},
+			$stats{$process_pid}->{HIGH_NR_RECLAIMED},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC},
 			$stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} + $stats{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_ASYNC});
 
@@ -579,6 +595,7 @@ sub dump_stats {
 	print "\nSummary\n";
 	print "Direct reclaims:     			$total_direct_reclaim\n";
 	print "Direct reclaim pages scanned:		$total_direct_nr_scanned\n";
+	print "Direct reclaim pages reclaimed:		$total_direct_nr_reclaimed\n";
 	print "Direct reclaim write file sync I/O:	$total_direct_writepage_file_sync\n";
 	print "Direct reclaim write anon sync I/O:	$total_direct_writepage_anon_sync\n";
 	print "Direct reclaim write file async I/O:	$total_direct_writepage_file_async\n";
@@ -588,6 +605,7 @@ sub dump_stats {
 	print "\n";
 	print "Kswapd wakeups:				$total_kswapd_wake\n";
 	print "Kswapd pages scanned:			$total_kswapd_nr_scanned\n";
+	print "Kswapd pages reclaimed:			$total_kswapd_nr_reclaimed\n";
 	print "Kswapd reclaim write file sync I/O:	$total_kswapd_writepage_file_sync\n";
 	print "Kswapd reclaim write anon sync I/O:	$total_kswapd_writepage_anon_sync\n";
 	print "Kswapd reclaim write file async I/O:	$total_kswapd_writepage_file_async\n";
@@ -612,6 +630,7 @@ sub aggregate_perprocesspid() {
 		$perprocess{$process}->{MM_VMSCAN_WAKEUP_KSWAPD} += $perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD};
 		$perprocess{$process}->{HIGH_KSWAPD_REWAKEUP} += $perprocesspid{$process_pid}->{HIGH_KSWAPD_REWAKEUP};
 		$perprocess{$process}->{HIGH_NR_SCANNED} += $perprocesspid{$process_pid}->{HIGH_NR_SCANNED};
+		$perprocess{$process}->{HIGH_NR_RECLAIMED} += $perprocesspid{$process_pid}->{HIGH_NR_RECLAIMED};
 		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_SYNC};
 		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_ANON_SYNC};
 		$perprocess{$process}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC} += $perprocesspid{$process_pid}->{MM_VMSCAN_WRITEPAGE_FILE_ASYNC};
diff -puN include/trace/events/vmscan.h~tracing-vmscan-add-trace-events-for-lru-list-shrinking include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~tracing-vmscan-add-trace-events-for-lru-list-shrinking
+++ a/include/trace/events/vmscan.h
@@ -10,6 +10,7 @@
 
 #define RECLAIM_WB_ANON		0x0001u
 #define RECLAIM_WB_FILE		0x0002u
+#define RECLAIM_WB_MIXED	0x0010u
 #define RECLAIM_WB_SYNC		0x0004u
 #define RECLAIM_WB_ASYNC	0x0008u
 
@@ -17,6 +18,7 @@
 	(flags) ? __print_flags(flags, "|",			\
 		{RECLAIM_WB_ANON,	"RECLAIM_WB_ANON"},	\
 		{RECLAIM_WB_FILE,	"RECLAIM_WB_FILE"},	\
+		{RECLAIM_WB_MIXED,	"RECLAIM_WB_MIXED"},	\
 		{RECLAIM_WB_SYNC,	"RECLAIM_WB_SYNC"},	\
 		{RECLAIM_WB_ASYNC,	"RECLAIM_WB_ASYNC"}	\
 		) : "RECLAIM_WB_NONE"
@@ -26,6 +28,12 @@
 	(sync == PAGEOUT_IO_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC)   \
 	)
 
+#define trace_shrink_flags(file, sync) ( \
+	(sync == PAGEOUT_IO_SYNC ? RECLAIM_WB_MIXED : \
+			(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON)) |  \
+	(sync == PAGEOUT_IO_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC) \
+	)
+
 TRACE_EVENT(mm_vmscan_kswapd_sleep,
 
 	TP_PROTO(int nid),
@@ -269,6 +277,40 @@ TRACE_EVENT(mm_vmscan_writepage,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
+TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
+
+	TP_PROTO(int nid, int zid,
+			unsigned long nr_scanned, unsigned long nr_reclaimed,
+			int priority, int reclaim_flags),
+
+	TP_ARGS(nid, zid, nr_scanned, nr_reclaimed, priority, reclaim_flags),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, zid)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_reclaimed)
+		__field(int, priority)
+		__field(int, reclaim_flags)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->zid = zid;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->priority = priority;
+		__entry->reclaim_flags = reclaim_flags;
+	),
+
+	TP_printk("nid=%d zid=%d nr_scanned=%ld nr_reclaimed=%ld priority=%d flags=%s",
+		__entry->nid, __entry->zid,
+		__entry->nr_scanned, __entry->nr_reclaimed,
+		__entry->priority,
+		show_reclaim_flags(__entry->reclaim_flags))
+);
+
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff -puN mm/vmscan.c~tracing-vmscan-add-trace-events-for-lru-list-shrinking mm/vmscan.c
--- a/mm/vmscan.c~tracing-vmscan-add-trace-events-for-lru-list-shrinking
+++ a/mm/vmscan.c
@@ -1358,6 +1358,12 @@ shrink_inactive_list(unsigned long nr_to
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
 	putback_lru_pages(zone, sc, nr_anon, nr_file, &page_list);
+
+	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
+		zone_idx(zone),
+		nr_scanned, nr_reclaimed,
+		priority,
+		trace_shrink_flags(file, sc->lumpy_reclaim_mode));
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch
mm-compaction-fix-compactpagefailed-counting.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
mm-fix-typo-in-mmh-when-node_not_in_page_flags.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

