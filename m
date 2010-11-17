From: akpm@linux-foundation.org
Subject: + writeback-io-less-balance_dirty_pages.patch added to -mm tree
Date: Wed, 17 Nov 2010 15:03:02 -0800
Message-ID: <201011172303.oAHN32jf010571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935678Ab0KQXEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 18:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mrubin@google.com, richard@rsk.demon.co.uk, riel@redhat.com, shaohua.li@intel.com, tytso@mit.edu


The patch titled
     writeback: IO-less balance_dirty_pages()
has been added to the -mm tree.  Its filename is
     writeback-io-less-balance_dirty_pages.patch

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
Subject: writeback: IO-less balance_dirty_pages()
From: Wu Fengguang <fengguang.wu@intel.com>

This patchset is a revised subset of "[RFC] soft and dynamic dirty
throttling limits" <http://thread.gmane.org/gmane.linux.kernel.mm/52966>.

The basic idea is to introduce a small region under the bdi dirty threshold.
The task will be throttled gently when stepping into the bottom of region,
and get throttled more and more aggressively as bdi dirty+writeback pages
goes up closer to the top of region. At some point the application will be
throttled at the right bandwidth that balances with the device write bandwidth.
(the first patch and documentation has more details)

Changes from initial RFC:

- adaptive rate limiting, to reduce overheads when under throttle threshold
- prevent overrunning dirty limit on lots of concurrent dirtiers
- add Documentation/filesystems/writeback-throttling-design.txt
- lower max pause time from 200ms to 100ms; min pause time from 10ms to 1jiffy
- don't drop the laptop mode code
- update and comment the trace event
- benchmarks on concurrent dd and fs_mark covering both large and tiny files
- bdi->write_bandwidth updates should be rate limited on concurrent dirtiers,
  otherwise it will drift fast and fluctuate
- don't call balance_dirty_pages_ratelimit() when writing to already dirtied
  pages, otherwise the task will be throttled too much


It runs smoothly on typical configurations.  Under small memory system the
pause time will fluctuate much more due to the limited range for soft
throttling.

The soft dirty threshold is now lowered to (background + dirty)/2=15%.  So
it will be throttling the applications a bit earlier, and may be perceived
by end users as performance "slow down" if his application happens to
dirty a bit more than 15%.  Note that vanilla kernel also has this limit
at fresh boot: it starts checking bdi limits when exceeding the global
15%, however the bdi limit ramps up pretty slowly in common
configurations, so the task is immediately throttled.

The task's think time is not considered for now when computing the pause
time.  So it will throttle an "scp" over network way harder than a local
"cp".  When to take the user space think time into account and ensure
accurate throttle bandwidth, we will effectively create a simple write I/O
bandwidth controller.

On a simple test of 100 dd, it reduces the CPU %system time from 30% to
3%, and improves IO throughput from 38MB/s to 42MB/s.

The fs_mark benchmark is interesting.  The CPU overheads are almost
reduced by half.  Before patch the benchmark is actually bounded by CPU. 
After patch it's IO bound, but strangely the throughput becomes slightly
slower.

#  ./fs_mark  -D  10000  -S0  -n  100000  -s  1  -L  63  -d  /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d  /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8  -d  /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11 
#       Version 3.3, 12 thread(s) starting at Thu Nov 11 21:01:36 2010
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000 subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 1 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.
#

2.6.36
FSUse%        Count         Size    Files/sec     App Overhead
     0      1200000            1       1261.7        524762513
     0      2400000            1       1195.3        537844546
     0      3600000            1       1231.9        496441566
     1      4800000            1       1175.8        552421522
     1      6000000            1       1191.6        558529735
     1      7200000            1       1165.3        551178395
     2      8400000            1       1175.0        533209632
     2      9600000            1       1200.6        534862246
     2     10800000            1       1181.2        540616486
     2     12000000            1       1137.4        554551797
     3     13200000            1       1143.7        563319651
     3     14400000            1       1169.0        519527533
     3     15600000            1       1184.0        533550370
     4     16800000            1       1161.3        534358727
     4     18000000            1       1193.4        521610050
     4     19200000            1       1177.6        524117437
     5     20400000            1       1172.6        506166634
     5     21600000            1       1172.3        515725633

avg                                    1182.761      533488581.833

2.6.36+
FSUse%        Count         Size    Files/sec     App Overhead
     0      1200000            1       1125.0        357885976
     0      2400000            1       1155.6        288103795
     0      3600000            1       1172.4        296521755
     1      4800000            1       1136.0        301718887
     1      6000000            1       1156.7        303605077
     1      7200000            1       1102.9        288852150
     2      8400000            1       1140.9        294894485
     2      9600000            1       1148.0        314394450
     2     10800000            1       1099.7        296365560
     2     12000000            1       1153.6        316283083
     3     13200000            1       1087.9        339988006
     3     14400000            1       1183.9        270836344
     3     15600000            1       1122.7        276400918
     4     16800000            1       1132.1        285272223
     4     18000000            1       1154.8        283424055
     4     19200000            1       1202.5        294558877
     5     20400000            1       1158.1        293971332
     5     21600000            1       1159.4        287720335
     5     22800000            1       1150.1        282987509
     5     24000000            1       1150.7        283870613
     6     25200000            1       1123.8        288094185
     6     26400000            1       1152.1        296984323
     6     27600000            1       1190.7        282403174
     7     28800000            1       1088.6        290493643
     7     30000000            1       1144.1        290311419
     7     31200000            1       1186.0        290021271
     7     32400000            1       1213.9        279465138
     8     33600000            1       1117.3        275745401

avg                                    1146.768      294684785.143


I noticed that

1) BdiWriteback can grow very large.  For example, bdi 8:16 has 72960KB
   writeback pages, however the disk IO queue can hold at most
   nr_request*max_sectors_kb=128*512kb=64MB writeback pages.  Maybe xfs
   manages to create perfect sequential layouts and writes, and the other
   8MB writeback pages are flying inside the disk?

	root@wfg-ne02 /cc/fs_mark-3.3/ne02-2.6.36+# g BdiWriteback /debug/bdi/8:*/*
	/debug/bdi/8:0/stats:BdiWriteback:            0 kB
	/debug/bdi/8:112/stats:BdiWriteback:        68352 kB
	/debug/bdi/8:128/stats:BdiWriteback:        62336 kB
	/debug/bdi/8:144/stats:BdiWriteback:        61824 kB
	/debug/bdi/8:160/stats:BdiWriteback:        67328 kB
	/debug/bdi/8:16/stats:BdiWriteback:        72960 kB
	/debug/bdi/8:176/stats:BdiWriteback:        57984 kB
	/debug/bdi/8:192/stats:BdiWriteback:        71936 kB
	/debug/bdi/8:32/stats:BdiWriteback:        68352 kB
	/debug/bdi/8:48/stats:BdiWriteback:        56704 kB
	/debug/bdi/8:64/stats:BdiWriteback:        50304 kB
	/debug/bdi/8:80/stats:BdiWriteback:        68864 kB
	/debug/bdi/8:96/stats:BdiWriteback:         2816 kB

2) the 12 disks are not all 100% utilized.  Not even close: sdd, sdf,
   sdh, sdj are almost idle at the moment.  Dozens of seconds later, some
   other disks become idle.  This happens both before/after patch.  There
   may be some hidden bugs (unrelated to this patchset).

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.17    0.00   97.87    1.08    0.00    0.88

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc               0.00    63.00    0.00  125.00     0.00  1909.33    30.55     3.88   31.65   6.57  82.13
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sde               0.00    19.00    0.00  112.00     0.00  1517.17    27.09     3.95   35.33   8.00  89.60
sdg               0.00    92.67    0.33  126.00     2.67  1773.33    28.12    14.83  120.78   7.73  97.60
sdf               0.00    32.33    0.00   91.67     0.00  1408.17    30.72     4.84   52.97   7.72  70.80
sdh               0.00    17.67    0.00    5.00     0.00   124.00    49.60     0.07   13.33   9.60   4.80
sdi               0.00    44.67    0.00    5.00     0.00   253.33   101.33     0.15   29.33  10.93   5.47
sdl               0.00   168.00    0.00  135.67     0.00  2216.33    32.67     6.41   45.42   5.75  78.00
sdk               0.00   225.00    0.00  123.00     0.00  2355.83    38.31     9.50   73.03   6.94  85.33
sdj               0.00     1.00    0.00    2.33     0.00    26.67    22.86     0.01    2.29   1.71   0.40
sdb               0.00    14.33    0.00  101.67     0.00  1278.00    25.14     2.02   19.95   7.16  72.80
sdm               0.00   150.33    0.00  144.33     0.00  2344.50    32.49     5.43   33.94   5.39  77.73

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.12    0.00   98.63    0.83    0.00    0.42

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdc               0.00   105.67    0.00  127.33     0.00  1810.17    28.43     4.39   32.43   6.67  84.93
sdd               0.00     5.33    0.00   10.67     0.00   128.00    24.00     0.03    2.50   1.25   1.33
sde               0.00   180.33    0.33  107.67     2.67  2109.33    39.11     8.11   73.93   8.99  97.07
sdg               0.00     7.67    0.00   63.67     0.00  1387.50    43.59     1.45   24.29  11.08  70.53
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdi               0.00    62.67    0.00   94.67     0.00  1743.50    36.83     3.28   34.68   8.52  80.67
sdl               0.00   162.00    0.00  141.67     0.00  2295.83    32.41     7.09   51.79   6.14  86.93
sdk               0.00    34.33    0.00  143.67     0.00  1910.17    26.59     5.07   38.90   6.26  90.00
sdj               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00   195.00    0.00   96.67     0.00  1949.50    40.33     5.54   57.23   8.39  81.07
sdm               0.00   155.00    0.00  143.00     0.00  2357.50    32.97     5.21   39.98   5.71  81.60



This patch:


As proposed by Chris, Dave and Jan, don't start foreground writeback IO
inside balance_dirty_pages().  Instead, simply let it idle sleep for some
time to throttle the dirtying task.  In the mean while, kick off the
per-bdi flusher thread to do background writeback IO.

This patch introduces the basic framework, which will be further
consolidated by the next patches.

RATIONALES
==========

The current balance_dirty_pages() is rather IO inefficient.

- concurrent writeback of multiple inodes (Dave Chinner)

  If every thread doing writes and being throttled start foreground
  writeback, it leads to N IO submitters from at least N different inodes
  at the same time, end up with N different sets of IO being issued with
  potentially zero locality to each other, resulting in much lower
  elevator sort/merge efficiency and hence we seek the disk all over the
  place to service the different sets of IO.  OTOH, if there is only one
  submission thread, it doesn't jump between inodes in the same way when
  congestion clears - it keeps writing to the same inode, resulting in
  large related chunks of sequential IOs being issued to the disk.  This
  is more efficient than the above foreground writeback because the
  elevator works better and the disk seeks less.

- IO size too small for fast arrays and too large for slow USB sticks

  The write_chunk used by current balance_dirty_pages() cannot be
  directly set to some large value (eg.  128MB) for better IO efficiency. 
  Because it could lead to more than 1 second user perceivable stalls. 
  Even the current 4MB write size may be too large for slow USB sticks. 
  The fact that balance_dirty_pages() starts IO on itself couples the IO
  size to wait time, which makes it hard to do suitable IO size while
  keeping the wait time under control.

For the above two reasons, it's much better to shift IO to the flusher
threads and let balance_dirty_pages() just wait for enough time or
progress.

Jan Kara, Dave Chinner and me explored the scheme to let
balance_dirty_pages() wait for enough writeback IO completions to
safeguard the dirty limit.  However it's found to have two problems:

- in large NUMA systems, the per-cpu counters may have big accounting
  errors, leading to big throttle wait time and jitters.

- NFS may kill large amount of unstable pages with one single COMMIT. 
  Because NFS server serves COMMIT with expensive fsync() IOs, it is
  desirable to delay and reduce the number of COMMITs.  So it's not likely
  to optimize away such kind of bursty IO completions, and the resulted
  large (and tiny) stall times in IO completion based throttling.

So here is a pause time oriented approach, which tries to control the
pause time in each balance_dirty_pages() invocations, by controlling the
number of pages dirtied before calling balance_dirty_pages(), for smooth
and efficient dirty throttling:

- avoid useless (eg. zero pause time) balance_dirty_pages() calls
- avoid too small pause time (less than  10ms, which burns CPU power)
- avoid too large pause time (more than 100ms, which hurts responsiveness)
- avoid big fluctuations of pause times

For example, when doing a simple cp on ext4 with mem=4G HZ=250.

before patch, the pause time fluctuates from 0 to 324ms
(and the stall time may grow very large for slow devices)

[ 1237.139962] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=56
[ 1237.207489] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=0
[ 1237.225190] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=0
[ 1237.234488] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=0
[ 1237.244692] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=0
[ 1237.375231] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=31
[ 1237.443035] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=15
[ 1237.574630] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=31
[ 1237.642394] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=15
[ 1237.666320] balance_dirty_pages: write_chunk=1536 pages_written=57 pause=5
[ 1237.973365] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=81
[ 1238.212626] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=56
[ 1238.280431] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=15
[ 1238.412029] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=31
[ 1238.412791] balance_dirty_pages: write_chunk=1536 pages_written=0 pause=0

after patch, the pause time remains stable around 32ms

cp-2687  [002]  1452.237012: balance_dirty_pages: weight=56% dirtied=128 pause=8
cp-2687  [002]  1452.246157: balance_dirty_pages: weight=56% dirtied=128 pause=8
cp-2687  [006]  1452.253043: balance_dirty_pages: weight=56% dirtied=128 pause=8
cp-2687  [006]  1452.261899: balance_dirty_pages: weight=57% dirtied=128 pause=8
cp-2687  [006]  1452.268939: balance_dirty_pages: weight=57% dirtied=128 pause=8
cp-2687  [002]  1452.276932: balance_dirty_pages: weight=57% dirtied=128 pause=8
cp-2687  [002]  1452.285889: balance_dirty_pages: weight=57% dirtied=128 pause=8

CONTROL SYSTEM
==============

The current task_dirty_limit() adjusts bdi_dirty_limit to get
task_dirty_limit according to the dirty "weight" of the current task,
which is the percent of pages recently dirtied by the task.  If 100% pages
are recently dirtied by the task, it will lower bdi_dirty_limit by 1/8. 
If only 1% pages are dirtied by the task, it will return almost unmodified
bdi_dirty_limit.  In this way, a heavy dirtier will get blocked at
task_dirty_limit=(bdi_dirty_limit-bdi_dirty_limit/8) while allowing a
light dirtier to progress (the latter won't be blocked because R << B in
fig.1).

Fig.1 before patch, a heavy dirtier and a light dirtier
                                                R
 ---------------------------------------------+-o---------------------------*--|
                                              L A                           B  T
  T: bdi_dirty_limit, as returned by bdi_dirty_limit()
  L: T - T/8

  R: bdi_reclaimable + bdi_writeback

  A: task_dirty_limit for a heavy dirtier ~= R ~= L
  B: task_dirty_limit for a light dirtier ~= T

Since each process has its own dirty limit, we reuse A/B for the tasks as
well as their dirty limits.

If B is a newly started heavy dirtier, then it will slowly gain weight and
A will lose weight.  The task_dirty_limit for A and B will be approaching
the center of region (L, T) and eventually stabilize there.

Fig.2 before patch, two heavy dirtiers converging to the same threshold
                                                             R
 ---------------------------------------------+--------------o-*---------------|
                                              L              A B               T

Fig.3 after patch, one heavy dirtier
                                                |
    throttle_bandwidth ~= bdi_bandwidth  =>     o
                                                | o
                                                |   o
                                                |     o
                                                |       o
                                                |         o
                                              La|           o
 ---------------------------------------------+-+-------------o----------------|
                                                R             A                T
  T: bdi_dirty_limit
  A: task_dirty_limit      = T - Wa * T/16
  La: task_throttle_thresh = A - A/16

  R: bdi_dirty_pages = bdi_reclaimable + bdi_writeback ~= La

Now for IO-less balance_dirty_pages(), let's do it in a "bandwidth
control" way.  In fig.3, a soft dirty limit region (La, A) is introduced. 
When R enters this region, the task may be throttled for J jiffies on
every N pages it dirtied.  Let's call (N/J) the "throttle bandwidth".  It
is computed by the following formula:

        throttle_bandwidth = bdi_bandwidth * (A - R) / (A - La)
where
	A = T - Wa * T/16
        La = A - A/16

where Wa is task weight for A.  It's 0 for very light dirtier and 1 for
the one heavy dirtier (that consumes 100% bdi write bandwidth).  The task
weight will be updated independently by task_dirty_inc() at
set_page_dirty() time.

When R < La, we don't throttle it at all.
When R > A, the code will detect the negativeness and choose to pause
100ms (the upper pause boundary), then loop over again.

PSEUDO CODE
===========

balance_dirty_pages():

	/* soft throttling */
	if (task_throttle_thresh exceeded)
		sleep (task_dirtied_pages / throttle_bandwidth)

	/* hard throttling */
	while (task_dirty_limit exceeded) {
		sleep 100ms
		if (bdi_dirty_pages dropped more than task_dirtied_pages)
			break
	}

	/* global hard limit */
	while (dirty_limit exceeded)
		sleep 100ms

Basically there are three level of throttling now.

- normally the dirtier will be adaptively throttled with good timing

- when task_dirty_limit is exceeded, the task will be throttled until
  bdi dirty/writeback pages go down reasonably large

- when dirty_thresh is exceeded, the task can be throttled for arbitrary
  long time

BEHAVIOR CHANGE
===============

Users will notice that the applications will get throttled once the
crossing the global (background + dirty)/2=15% threshold.  For a single
"cp", it could be soft throttled at 8*bdi->write_bandwidth around 15%
dirty pages, and be balanced at speed bdi->write_bandwidth around 17.5%
dirty pages.  Before patch, the behavior is to just throttle it at 17.5%
dirty pages.

Since the task will be soft throttled earlier than before, it may be
perceived by end users as performance "slow down" if his application
happens to dirty more than ~15% memory.

BENCHMARKS
==========

The test box has a 4-core 3.2GHz CPU, 4GB mem and a SATA disk.

For each filesystem, the following command is run 3 times.

time (dd if=/dev/zero of=/tmp/10G bs=1M count=10240; sync); rm /tmp/10G

	    2.6.36-rc2-mm1	2.6.36-rc2-mm1+balance_dirty_pages
average real time
ext2        236.377s            232.144s              -1.8%
ext3        226.245s            225.751s              -0.2%
ext4        178.742s            179.343s              +0.3%
xfs         183.562s            179.808s              -2.0%
btrfs       179.044s            179.461s              +0.2%
NFS         645.627s            628.937s              -2.6%

average system time
ext2         22.142s             19.656s             -11.2%
ext3         34.175s             32.462s              -5.0%
ext4         23.440s             21.162s              -9.7%
xfs          19.089s             16.069s             -15.8%
btrfs        12.212s             11.670s              -4.4%
NFS          16.807s             17.410s              +3.6%

total user time
sum           0.136s              0.084s             -38.2%

In a more recent run of the tests, it's in fact slightly slower.

ext2         49.500 MB/s         49.200 MB/s          -0.6%
ext3         50.133 MB/s         50.000 MB/s          -0.3%
ext4         64.000 MB/s         63.200 MB/s          -1.2%
xfs          63.500 MB/s         63.167 MB/s          -0.5%
btrfs        63.133 MB/s         63.033 MB/s          -0.2%
NFS          16.833 MB/s         16.867 MB/s          +0.2%

In general there are no big IO performance changes for desktop users,
except for some noticeable reduction of CPU overheads.  It mainly benefits
file servers with heavy concurrent writers on fast storage arrays.  As can
be demonstrated by 10/100 concurrent dd's on xfs:

- 1 dirtier case:    the same
- 10 dirtiers case:  CPU system time is reduced to 50%
- 100 dirtiers case: CPU system time is reduced to 10%, IO size and throughput
  increases by 10%

			2.6.37-rc2				2.6.37-rc1-next-20101115+
        ----------------------------------------        ----------------------------------------
	%system		wkB/s		avgrq-sz	%system		wkB/s		avgrq-sz
100dd	30.916		37843.000	748.670		3.079		41654.853	822.322
100dd	30.501		37227.521	735.754		3.744		41531.725	820.360

10dd	39.442		47745.021	900.935		20.756		47951.702	901.006
10dd	39.204		47484.616	899.330		20.550		47970.093	900.247

1dd	13.046		57357.468	910.659		13.060		57632.715	909.212
1dd	12.896		56433.152	909.861		12.467		56294.440	909.644

The CPU overheads in 2.6.37-rc1-next-20101115+ is higher than
2.6.36-rc2-mm1+balance_dirty_pages, this may be due to the pause time
stablizing at lower values due to some algorithm adjustments (eg.  reduce
the minimal pause time from 10ms to 1jiffy in new version) leading to much
more balance_dirty_pages() calls.  The different pause time also explains
the different system time for 1/10/100dd cases on the same
2.6.37-rc1-next-20101115+.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/writeback-throttling-design.txt |  210 ++++++++++
 include/linux/writeback.h                                 |   10 
 mm/page-writeback.c                                       |   85 +---
 3 files changed, 249 insertions(+), 56 deletions(-)

diff -puN /dev/null Documentation/filesystems/writeback-throttling-design.txt
--- /dev/null
+++ a/Documentation/filesystems/writeback-throttling-design.txt
@@ -0,0 +1,210 @@
+writeback throttling design
+---------------------------
+
+introduction to dirty throttling
+--------------------------------
+
+The write(2) is normally buffered write that creates dirty page cache pages
+for holding the data and return immediately. The dirty pages will eventually
+be written to disk, or be dropped by unlink()/truncate().
+
+The delayed writeback of dirty pages enables the kernel to optimize the IO:
+
+- turn IO into async ones, which avoids blocking the tasks
+- submit IO as a batch for better throughput
+- avoid IO at all for temp files
+
+However, there have to be some limits on the number of allowable dirty pages.
+Typically applications are able to dirty pages more quickly than storage
+devices can write them. When approaching the dirty limits, the dirtier tasks
+will be throttled (put to brief sleeps from time to time) by
+balance_dirty_pages() in order to balance the dirty speed and writeback speed.
+
+dirty limits
+------------
+
+The dirty limit defaults to 20% reclaimable memory, and can be tuned via one of
+the following sysctl interfaces:
+
+	/proc/sys/vm/dirty_ratio
+	/proc/sys/vm/dirty_bytes
+
+The ultimate goal of balance_dirty_pages() is to keep the global dirty pages
+under control.
+
+	dirty_limit = dirty_ratio * free_reclaimable_pages
+
+However a global threshold may create deadlock for stacked BDIs (loop, FUSE and
+local NFS mounts). When A writes to B, and A generates enough dirty pages to
+get throttled, B will never start writeback until the dirty pages go away.
+
+Another problem is inter device starvation. When there are concurrent writes to
+a slow device and a fast one, the latter may well be starved due to unnecessary
+throttling on its dirtier tasks, leading to big IO performance drop.
+
+The solution is to split the global dirty limit into per-bdi limits among all
+the backing devices and scale writeback cache per backing device, proportional
+to its writeout speed.
+
+	bdi_dirty_limit = bdi_weight * dirty_limit
+
+where bdi_weight (ranging from 0 to 1) reflects the recent writeout speed of
+the BDI.
+
+We further scale the bdi dirty limit inversly with the task's dirty rate.
+This makes heavy writers have a lower dirty limit than the occasional writer,
+to prevent a heavy dd from slowing down all other light writers in the system.
+
+	task_dirty_limit = bdi_dirty_limit - task_weight * bdi_dirty_limit/16
+
+pause time
+----------
+
+The main task of dirty throttling is to determine when and how long to pause
+the current dirtier task.  Basically we want to
+
+- avoid too small pause time (less than 1 jiffy, which burns CPU power)
+- avoid too large pause time (more than 100ms, which hurts responsiveness)
+- avoid big fluctuations of pause times
+
+To smoothly control the pause time, we do soft throttling in a small region
+under task_dirty_limit, starting from
+
+	task_throttle_thresh = task_dirty_limit - task_dirty_limit/16
+
+In fig.1, when bdi_dirty_pages falls into
+
+    [0, La]:    do nothing
+    [La, A]:    do soft throttling
+    [A, inf]:   do hard throttling
+
+Where hard throttling is to wait until bdi_dirty_pages falls more than
+task_dirtied_pages (the pages dirtied by the task since its last throttle
+time). It's "hard" because it may end up waiting for long time.
+
+Fig.1 dirty throttling regions
+                                              o
+                                                o
+                                                  o
+                                                    o
+                                                      o
+                                                        o
+                                                          o
+                                                            o
+----------------------------------------------+---------------o----------------|
+                                              La              A                T
+                no throttle                     soft throttle   hard throttle
+  T: bdi_dirty_limit
+  A: task_dirty_limit      = T - task_weight * T/16
+  La: task_throttle_thresh = A - A/16
+
+Soft dirty throttling is to pause the dirtier task for J:pause_time jiffies on
+every N:task_dirtied_pages pages it dirtied.  Let's call (N/J) the "throttle
+bandwidth". It is computed by the following formula:
+
+                                     task_dirty_limit - bdi_dirty_pages
+throttle_bandwidth = bdi_bandwidth * ----------------------------------
+                                           task_dirty_limit/16
+
+where bdi_bandwidth is the BDI's estimated write speed.
+
+Given the throttle_bandwidth for a task, we select a suitable N, so that when
+the task dirties so much pages, it enters balance_dirty_pages() to sleep for
+roughly J jiffies. N is adaptive to storage and task write speeds, so that the
+task always get suitable (not too long or small) pause time.
+
+dynamics
+--------
+
+When there is one heavy dirtier, bdi_dirty_pages will keep growing until
+exceeding the low threshold of the task's soft throttling region [La, A].
+At which point (La) the task will be controlled under speed
+throttle_bandwidth=bdi_bandwidth (fig.2) and remain stable there.
+
+Fig.2 one heavy dirtier
+
+    throttle_bandwidth ~= bdi_bandwidth  =>   o
+                                              | o
+                                              |   o
+                                              |     o
+                                              |       o
+                                              |         o
+                                              |           o
+                                            La|             o
+----------------------------------------------+---------------o----------------|
+                                              R               A                T
+  R: bdi_dirty_pages ~= La
+
+When there comes a new dd task B, task_weight_B will gradually grow from 0 to
+50% while task_weight_A will decrease from 100% to 50%.  When task_weight_B is
+still small, B is considered a light dirtier and is allowed to dirty pages much
+faster than the bdi write bandwidth. In fact initially it won't be throttled at
+all when R < Lb where Lb = B - B/16 and B ~= T.
+
+Fig.3 an old dd (A) + a newly started dd (B)
+
+                      throttle bandwidth  =>    *
+                                                | *
+                                                |   *
+                                                |     *
+                                                |       *
+                                                |         *
+                                                |           *
+                                                |             *
+                      throttle bandwidth  =>    o               *
+                                                | o               *
+                                                |   o               *
+                                                |     o               *
+                                                |       o               *
+                                                |         o               *
+                                                |           o               *
+------------------------------------------------+-------------o---------------*|
+                                                R             A               BT
+
+So R:bdi_dirty_pages will grow large. As task_weight_A and task_weight_B
+converge to 50%, the points A, B will go towards each other (fig.4) and
+eventually coincide with each other. R will stabilize around A-A/32 where
+A=B=T-0.5*T/16.  throttle_bandwidth will stabilize around bdi_bandwidth/2.
+
+Note that the application "think+dirty time" is ignored for simplicity in the
+above discussions. With non-zero user space think time, the balance point will
+slightly drift and not a big deal otherwise.
+
+Fig.4 the two dd's converging to the same bandwidth
+
+                                                         |
+                                 throttle bandwidth  =>  *
+                                                         | *
+                                 throttle bandwidth  =>  o   *
+                                                         | o   *
+                                                         |   o   *
+                                                         |     o   *
+                                                         |       o   *
+                                                         |         o   *
+---------------------------------------------------------+-----------o---*-----|
+                                                         R           A   B     T
+
+There won't be big oscillations between A and B, because as soon as A coincides
+with B, their throttle_bandwidth and hence dirty speed will be equal, A's
+weight will stop decreasing and B's weight will stop growing, so the two points
+won't keep moving and cross each other.
+
+Sure there are always oscillations of bdi_dirty_pages as long as the dirtier
+task alternatively do dirty and pause. But it will be bounded. When there is 1
+heavy dirtier, the error bound will be (pause_time * bdi_bandwidth). When there
+are 2 heavy dirtiers, the max error is 2 * (pause_time * bdi_bandwidth/2),
+which remains the same as 1 dirtier case (given the same pause time). In fact
+the more dirtier tasks, the less errors will be, since the dirtier tasks are
+not likely going to sleep at the same time.
+
+References
+----------
+
+Smarter write throttling
+http://lwn.net/Articles/245600/
+
+Flushing out pdflush
+http://lwn.net/Articles/326552/
+
+Dirty throttling slides
+http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling.pdf
diff -puN include/linux/writeback.h~writeback-io-less-balance_dirty_pages include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-io-less-balance_dirty_pages
+++ a/include/linux/writeback.h
@@ -12,6 +12,16 @@ struct backing_dev_info;
 extern spinlock_t inode_lock;
 
 /*
+ * The 1/8 region under the bdi dirty threshold is set aside for elastic
+ * throttling. In rare cases when the threshold is exceeded, more rigid
+ * throttling will be imposed, which will inevitably stall the dirtier task
+ * for seconds (or more) at _one_ time. The rare case could be a fork bomb
+ * where every new task dirties some more pages.
+ */
+#define BDI_SOFT_DIRTY_LIMIT	8
+#define TASK_SOFT_DIRTY_LIMIT	(BDI_SOFT_DIRTY_LIMIT * 2)
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
diff -puN mm/page-writeback.c~writeback-io-less-balance_dirty_pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-io-less-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -42,20 +42,6 @@
  */
 static long ratelimit_pages = 32;
 
-/*
- * When balance_dirty_pages decides that the caller needs to perform some
- * non-background writeback, this is how many pages it will attempt to write.
- * It should be somewhat larger than dirtied pages to ensure that reasonably
- * large amounts of I/O are submitted.
- */
-static inline long sync_writeback_pages(unsigned long dirtied)
-{
-	if (dirtied < ratelimit_pages)
-		dirtied = ratelimit_pages;
-
-	return dirtied + dirtied / 2;
-}
-
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
@@ -279,7 +265,7 @@ static unsigned long task_dirty_limit(st
 {
 	long numerator, denominator;
 	unsigned long dirty = bdi_dirty;
-	u64 inv = dirty >> 3;
+	u64 inv = dirty / TASK_SOFT_DIRTY_LIMIT;
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
 	inv *= numerator;
@@ -473,26 +459,25 @@ unsigned long bdi_dirty_limit(struct bac
  * perform some writeout.
  */
 static void balance_dirty_pages(struct address_space *mapping,
-				unsigned long write_chunk)
+				unsigned long pages_dirtied)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-	unsigned long pages_written = 0;
-	unsigned long pause = 1;
+	unsigned long bw;
+	unsigned long pause;
 	bool dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
 	for (;;) {
-		struct writeback_control wbc = {
-			.sync_mode	= WB_SYNC_NONE,
-			.older_than_this = NULL,
-			.nr_to_write	= write_chunk,
-			.range_cyclic	= 1,
-		};
-
+		/*
+		 * Unstable writes are a feature of certain networked
+		 * filesystems (i.e. NFS) in which data may have been
+		 * written to the server's write cache, but has not yet
+		 * been flushed to permanent storage.
+		 */
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
 		nr_writeback = global_page_state(NR_WRITEBACK);
@@ -529,6 +514,23 @@ static void balance_dirty_pages(struct a
 			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
+		if (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh) {
+			pause = HZ/10;
+			goto pause;
+		}
+
+		bw = 100 << 20; /* use static 100MB/s for the moment */
+
+		bw = bw * (bdi_thresh - (bdi_nr_reclaimable + bdi_nr_writeback));
+		bw = bw / (bdi_thresh / TASK_SOFT_DIRTY_LIMIT + 1);
+
+		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);
+		pause = clamp_val(pause, 1, HZ/10);
+
+pause:
+		__set_current_state(TASK_INTERRUPTIBLE);
+		io_schedule_timeout(pause);
+
 		/*
 		 * The bdi thresh is somehow "soft" limit derived from the
 		 * global "hard" limit. The former helps to prevent heavy IO
@@ -544,35 +546,6 @@ static void balance_dirty_pages(struct a
 
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
-
-		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
-		 * Unstable writes are a feature of certain networked
-		 * filesystems (i.e. NFS) in which data may have been
-		 * written to the server's write cache, but has not yet
-		 * been flushed to permanent storage.
-		 * Only move pages to writeback if this bdi is over its
-		 * threshold otherwise wait until the disk writes catch
-		 * up.
-		 */
-		trace_wbc_balance_dirty_start(&wbc, bdi);
-		if (bdi_nr_reclaimable > bdi_thresh) {
-			writeback_inodes_wb(&bdi->wb, &wbc);
-			pages_written += write_chunk - wbc.nr_to_write;
-			trace_wbc_balance_dirty_written(&wbc, bdi);
-			if (pages_written >= write_chunk)
-				break;		/* We've done our duty */
-		}
-		trace_wbc_balance_dirty_wait(&wbc, bdi);
-		__set_current_state(TASK_INTERRUPTIBLE);
-		io_schedule_timeout(pause);
-
-		/*
-		 * Increase the delay for each loop, up to our previous
-		 * default of taking a 100ms nap.
-		 */
-		pause <<= 1;
-		if (pause > HZ / 10)
-			pause = HZ / 10;
 	}
 
 	if (!dirty_exceeded && bdi->dirty_exceeded)
@@ -589,7 +562,7 @@ static void balance_dirty_pages(struct a
 	 * In normal mode, we start background writeout at the lower
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
-	if ((laptop_mode && pages_written) ||
+	if ((laptop_mode && dirty_exceeded) ||
 	    (!laptop_mode && (nr_reclaimable > background_thresh)))
 		bdi_start_background_writeback(bdi);
 }
@@ -638,7 +611,7 @@ void balance_dirty_pages_ratelimited_nr(
 	p =  &__get_cpu_var(bdp_ratelimits);
 	*p += nr_pages_dirtied;
 	if (unlikely(*p >= ratelimit)) {
-		ratelimit = sync_writeback_pages(*p);
+		ratelimit = *p;
 		*p = 0;
 		preempt_enable();
 		balance_dirty_pages(mapping, ratelimit);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

