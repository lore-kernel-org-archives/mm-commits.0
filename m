Return-Path: <mm-commits-owner@kernel.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2869CC433FE
	for <mm-commits@archiver.kernel.org>; Sun,  5 Sep 2021 12:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE1D360C51
	for <mm-commits@archiver.kernel.org>; Sun,  5 Sep 2021 12:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhIEM2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 5 Sep 2021 08:28:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:15495 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhIEM2Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 5 Sep 2021 08:28:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10097"; a="216625042"
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="yaml'?scan'208";a="216625042"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 05:27:18 -0700
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="yaml'?scan'208";a="535912118"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.41])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 05:27:12 -0700
Date:   Sun, 5 Sep 2021 20:44:39 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     0day robot <lkp@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hillf Danton <hdanton@sina.com>,
        Huang Ying <ying.huang@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject: [memcg]  45208c9105:  aim7.jobs-per-min -14.0% regression
Message-ID: <20210905124439.GA15026@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902215504.dSSfDKJZu%akpm@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit



Greeting,

FYI, we noticed a -14.0% regression of aim7.jobs-per-min due to commit:


commit: 45208c9105bd96015b98cdf31fbd6a3bcff234b6 ("[patch 097/212] memcg: infrastructure to flush memcg stats")
url: https://github.com/0day-ci/linux/commits/Andrew-Morton/ia64-fix-typo-in-a-comment/20210903-065028


in testcase: aim7
on test machine: 128 threads 2 sockets Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz with 256G memory
with following parameters:

	disk: 1BRD_48G
	fs: xfs
	test: disk_rr
	load: 3000
	cpufreq_governor: performance
	ucode: 0xd000280

test-description: AIM7 is a traditional UNIX system level benchmark suite which is used to test and measure the performance of multiuser system.
test-url: https://sourceforge.net/projects/aimbench/files/aim-suite7/

In addition to that, the commit also has significant impact on the following tests:

+------------------+-------------------------------------------------------------------------------------+
| testcase: change | reaim: reaim.jobs_per_min -10.0% regression                                         |
| test machine     | 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory |
| test parameters  | cpufreq_governor=performance                                                        |
|                  | nr_task=100%                                                                        |
|                  | runtime=300s                                                                        |
|                  | test=compute                                                                        |
|                  | ucode=0x5003006                                                                     |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops -29.8% regression                      |
| test machine     | 104 threads 2 sockets Skylake with 192G memory                                      |
| test parameters  | cpufreq_governor=performance                                                        |
|                  | mode=process                                                                        |
|                  | nr_task=100%                                                                        |
|                  | test=fallocate2                                                                     |
|                  | ucode=0x2006a0a                                                                     |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | fio-basic: fio.read_iops -20.5% regression                                          |
| test machine     | 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory      |
| test parameters  | bs=4k                                                                               |
|                  | cpufreq_governor=performance                                                        |
|                  | disk=2pmem                                                                          |
|                  | fs=xfs                                                                              |
|                  | ioengine=mmap                                                                       |
|                  | nr_task=50%                                                                         |
|                  | runtime=200s                                                                        |
|                  | rw=read                                                                             |
|                  | test_size=200G                                                                      |
|                  | time_based=tb                                                                       |
|                  | ucode=0x5003006                                                                     |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops -9.2% regression                       |
| test machine     | 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory     |
| test parameters  | cpufreq_governor=performance                                                        |
|                  | mode=process                                                                        |
|                  | nr_task=50%                                                                         |
|                  | test=page_fault3                                                                    |
|                  | ucode=0x42e                                                                         |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops -2.3% regression                        |
| test machine     | 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H CPU @ 2.50GHz with 128G memory    |
| test parameters  | cpufreq_governor=performance                                                        |
|                  | mode=thread                                                                         |
|                  | nr_task=100%                                                                        |
|                  | test=tlb_flush1                                                                     |
|                  | ucode=0x700001e                                                                     |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops -8.9% regression                        |
| test machine     | 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H CPU @ 2.50GHz with 128G memory    |
| test parameters  | cpufreq_governor=performance                                                        |
|                  | mode=thread                                                                         |
|                  | nr_task=16                                                                          |
|                  | test=tlb_flush1                                                                     |
|                  | ucode=0x700001e                                                                     |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops -6.4% regression                       |
| test machine     | 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory     |
| test parameters  | cpufreq_governor=performance                                                        |
|                  | mode=process                                                                        |
|                  | nr_task=50%                                                                         |
|                  | test=page_fault2                                                                    |
|                  | ucode=0x42e                                                                         |
+------------------+-------------------------------------------------------------------------------------+
| testcase: change | netperf: netperf.Throughput_Mbps 89.8% improvement                                  |
| test machine     | 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory |
| test parameters  | cluster=cs-localhost                                                                |
|                  | cpufreq_governor=performance                                                        |
|                  | ip=ipv4                                                                             |
|                  | nr_threads=200%                                                                     |
|                  | runtime=900s                                                                        |
|                  | test=TCP_MAERTS                                                                     |
|                  | ucode=0x5003006                                                                     |
+------------------+-------------------------------------------------------------------------------------+


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


Details are as below:
-------------------------------------------------------------------------------------------------->


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install                job.yaml  # job file is attached in this email
        bin/lkp split-job --compatible job.yaml  # generate the yaml file for lkp run
        bin/lkp run                    generated-yaml-file

=========================================================================================
compiler/cpufreq_governor/disk/fs/kconfig/load/rootfs/tbox_group/test/testcase/ucode:
  gcc-9/performance/1BRD_48G/xfs/x86_64-rhel-8.3/3000/debian-10.4-x86_64-20200603.cgz/lkp-icl-2sp2/disk_rr/aim7/0xd000280

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    589279           -14.0%     506860        aim7.jobs-per-min
      2510 ±  5%   +1075.4%      29509 ±  5%  aim7.time.involuntary_context_switches
    594.27 ±  2%    +265.5%       2172 ±  2%  aim7.time.system_time
    953353            -6.3%     893500        aim7.time.voluntary_context_switches
 3.783e+09 ±  5%     -27.7%  2.736e+09 ±  5%  cpuidle..time
   8575835 ±  4%     -23.3%    6576912 ±  4%  cpuidle..usage
     85.15           -34.4%      55.89 ±  2%  iostat.cpu.idle
     13.77 ±  4%    +212.8%      43.07 ±  3%  iostat.cpu.system
     84.38           -30.7       53.71 ±  3%  mpstat.cpu.all.idle%
      0.09 ±  3%      -0.0        0.06        mpstat.cpu.all.soft%
     13.63 ±  4%     +30.8       44.40 ±  3%  mpstat.cpu.all.sys%
     84.83           -34.8%      55.33 ±  2%  vmstat.cpu.id
     17.50 ±  4%    +221.0%      56.17 ±  4%  vmstat.procs.r
    295154            +9.7%     323704 ±  3%  vmstat.system.in
      7265 ± 17%     -62.1%       2752 ± 10%  softirqs.CPU11.RCU
      7329 ± 18%     -56.2%       3211 ± 33%  softirqs.CPU7.RCU
      7291 ± 24%     -63.4%       2671 ± 15%  softirqs.CPU76.RCU
    814854 ±  2%     -58.7%     336317 ±  6%  softirqs.RCU
    416.83 ±  4%    +188.2%       1201 ±  3%  turbostat.Avg_MHz
     16.05 ±  4%     +30.2       46.27 ±  3%  turbostat.Busy%
   8580008 ±  4%     -23.6%    6558461 ±  4%  turbostat.C1
     85.14           -30.7       54.48 ±  3%  turbostat.C1%
  10650547 ±  3%     +23.2%   13120314 ±  4%  turbostat.IRQ
     22456 ±  5%    +270.7%      83244 ±  3%  meminfo.Active
     15681 ± 10%    +239.8%      53290 ±  3%  meminfo.Active(anon)
      6773 ±  8%    +342.2%      29953 ± 11%  meminfo.Active(file)
    378124           +10.7%     418453 ±  2%  meminfo.Inactive(anon)
     44735           +92.1%      85948 ±  6%  meminfo.Mapped
     37940 ±  3%    +186.6%     108723 ±  3%  meminfo.Shmem
      0.03 ±147%     -74.4%       0.01 ± 16%  perf-sched.sch_delay.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      3.28           +62.6%       5.33 ± 22%  perf-sched.sch_delay.max.ms.worker_thread.kthread.ret_from_fork
    583.33 ±  5%     +77.5%       1035 ± 12%  perf-sched.total_wait_and_delay.count.ms
      1.38 ± 21%     -81.7%       0.25 ± 24%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork
     50.17 ± 11%    +917.6%     510.50 ± 20%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork
      1.31 ± 21%     -83.7%       0.21 ± 21%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork
      3290 ±  8%     +17.7%       3873 ±  7%  slabinfo.kmalloc-cg-1k.active_objs
      3290 ±  8%     +17.7%       3873 ±  7%  slabinfo.kmalloc-cg-1k.num_objs
     50845           +23.7%      62890        slabinfo.radix_tree_node.active_objs
    908.17           +24.2%       1128        slabinfo.radix_tree_node.active_slabs
     50876           +24.3%      63221        slabinfo.radix_tree_node.num_objs
    908.17           +24.2%       1128        slabinfo.radix_tree_node.num_slabs
      6342 ± 29%    +165.1%      16811 ± 13%  numa-meminfo.node0.Active
      3683 ± 13%    +287.3%      14266 ± 13%  numa-meminfo.node0.Active(file)
     31786 ± 40%     +61.2%      51254 ±  2%  numa-meminfo.node0.Mapped
     93423 ±  5%     -67.2%      30632 ±133%  numa-meminfo.node0.PageTables
     16014 ± 19%    +313.9%      66284 ±  3%  numa-meminfo.node1.Active
     13022 ± 22%    +289.8%      50755 ±  3%  numa-meminfo.node1.Active(anon)
      2991 ± 17%    +419.1%      15528 ± 12%  numa-meminfo.node1.Active(file)
    481048 ±  3%     +10.8%     533239 ±  3%  numa-meminfo.node1.Dirty
    564411 ±  8%     +23.2%     695626 ± 13%  numa-meminfo.node1.Inactive
     84926 ± 46%     +98.5%     168539 ± 56%  numa-meminfo.node1.Inactive(anon)
    840.17 ± 23%   +7571.8%      64455 ± 69%  numa-meminfo.node1.PageTables
     23552 ± 31%    +297.9%      93724 ±  7%  numa-meminfo.node1.Shmem
    154648 ± 22%     +47.6%     228217 ± 23%  numa-meminfo.node1.Slab
    948.33 ± 14%    +278.4%       3588 ± 13%  numa-vmstat.node0.nr_active_file
      7946 ± 40%     +61.3%      12814 ±  2%  numa-vmstat.node0.nr_mapped
     23354 ±  5%     -67.2%       7658 ±133%  numa-vmstat.node0.nr_page_table_pages
    955.17 ± 14%    +275.2%       3583 ± 13%  numa-vmstat.node0.nr_zone_active_file
      3255 ± 22%    +289.8%      12689 ±  3%  numa-vmstat.node1.nr_active_anon
    747.83 ± 20%    +423.4%       3914 ± 12%  numa-vmstat.node1.nr_active_file
    120249 ±  3%     +10.8%     133246 ±  3%  numa-vmstat.node1.nr_dirty
     21234 ± 46%     +98.4%      42135 ± 56%  numa-vmstat.node1.nr_inactive_anon
    210.00 ± 23%   +7572.6%      16112 ± 69%  numa-vmstat.node1.nr_page_table_pages
      5887 ± 31%    +297.9%      23429 ±  7%  numa-vmstat.node1.nr_shmem
      3255 ± 22%    +289.8%      12689 ±  3%  numa-vmstat.node1.nr_zone_active_anon
    754.67 ± 19%    +419.1%       3917 ± 12%  numa-vmstat.node1.nr_zone_active_file
     21234 ± 46%     +98.4%      42135 ± 56%  numa-vmstat.node1.nr_zone_inactive_anon
    120773 ±  3%      +9.8%     132625 ±  3%  numa-vmstat.node1.nr_zone_write_pending
      3920 ± 10%    +239.9%      13323 ±  3%  proc-vmstat.nr_active_anon
      1714 ±  8%    +345.9%       7645 ± 10%  proc-vmstat.nr_active_file
    240516 ±  3%      +9.0%     262057 ±  2%  proc-vmstat.nr_dirty
    847275            +4.6%     886517        proc-vmstat.nr_file_pages
     94529           +10.7%     104604 ±  2%  proc-vmstat.nr_inactive_anon
     11184           +92.2%      21494 ±  6%  proc-vmstat.nr_mapped
      9484 ±  3%    +186.6%      27179 ±  3%  proc-vmstat.nr_shmem
     37421            +6.9%      40004        proc-vmstat.nr_slab_reclaimable
      3920 ± 10%    +239.9%      13323 ±  3%  proc-vmstat.nr_zone_active_anon
      1714 ±  8%    +345.9%       7644 ± 10%  proc-vmstat.nr_zone_active_file
     94529           +10.7%     104604 ±  2%  proc-vmstat.nr_zone_inactive_anon
    241459 ±  3%      +8.0%     260729 ±  2%  proc-vmstat.nr_zone_write_pending
    401067            +7.7%     432079        proc-vmstat.pgfault
     12465            +9.0%      13586 ±  2%  proc-vmstat.pgreuse
      1573            +2.1%       1605        proc-vmstat.unevictable_pgs_culled
      5.65 ±  2%     +13.2%       6.39 ±  2%  perf-stat.i.MPKI
      0.65 ±  3%      -0.1        0.58 ±  3%  perf-stat.i.branch-miss-rate%
 1.293e+08 ±  3%     +16.5%  1.506e+08 ±  2%  perf-stat.i.cache-misses
 4.507e+08 ±  3%     +11.6%   5.03e+08 ±  2%  perf-stat.i.cache-references
      1.92 ±  5%     +45.6%       2.80 ±  2%  perf-stat.i.cpi
 5.438e+10 ±  4%    +177.4%  1.509e+11 ±  3%  perf-stat.i.cpu-cycles
      1286 ±  4%    +417.9%       6660 ±  3%  perf-stat.i.cpu-migrations
      0.01 ±  2%      -0.0        0.01 ±  2%  perf-stat.i.dTLB-load-miss-rate%
   1958804 ±  4%     -12.8%    1708670 ±  5%  perf-stat.i.dTLB-load-misses
    218781 ±  6%     -16.0%     183740 ±  4%  perf-stat.i.dTLB-store-misses
 1.059e+10 ±  4%     -14.7%  9.033e+09 ±  2%  perf-stat.i.dTLB-stores
      0.93 ±  3%     -56.0%       0.41        perf-stat.i.ipc
      0.43 ±  4%    +176.5%       1.18 ±  3%  perf-stat.i.metric.GHz
    683.67 ±  3%      +6.7%     729.59 ±  2%  perf-stat.i.metric.K/sec
     38.44 ±  4%     +16.0       54.48        perf-stat.i.node-load-miss-rate%
   5765381 ±  4%    +233.2%   19207678 ±  2%  perf-stat.i.node-load-misses
  38882013 ±  4%     -29.4%   27435575 ±  3%  perf-stat.i.node-loads
   3232868 ±  4%     +82.2%    5889275 ±  2%  perf-stat.i.node-store-misses
      6.77           +12.5%       7.61        perf-stat.overall.MPKI
      0.30            -0.0        0.30        perf-stat.overall.branch-miss-rate%
     28.70            +1.2       29.94        perf-stat.overall.cache-miss-rate%
      0.82          +178.5%       2.27        perf-stat.overall.cpi
    420.30          +137.4%     997.89 ±  2%  perf-stat.overall.cycles-between-cache-misses
      1.23           -64.1%       0.44        perf-stat.overall.ipc
     12.91           +28.2       41.07        perf-stat.overall.node-load-miss-rate%
      8.87            +5.5       14.39        perf-stat.overall.node-store-miss-rate%
  1.28e+10 ±  3%      +8.0%  1.383e+10 ±  2%  perf-stat.ps.branch-instructions
 1.273e+08 ±  3%     +21.7%   1.55e+08 ±  3%  perf-stat.ps.cache-misses
 4.435e+08 ±  3%     +16.7%  5.176e+08 ±  3%  perf-stat.ps.cache-references
 5.351e+10 ±  4%    +189.0%  1.546e+11 ±  3%  perf-stat.ps.cpu-cycles
      1265 ±  4%    +437.8%       6803 ±  3%  perf-stat.ps.cpu-migrations
    214181 ±  6%     -12.8%     186735 ±  5%  perf-stat.ps.dTLB-store-misses
 1.042e+10 ±  3%     -10.9%  9.287e+09 ±  2%  perf-stat.ps.dTLB-stores
   5677458 ±  4%    +247.6%   19734668 ±  3%  perf-stat.ps.node-load-misses
  38291599 ±  4%     -26.0%   28320179 ±  3%  perf-stat.ps.node-loads
   3183080 ±  4%     +90.3%    6058716 ±  3%  perf-stat.ps.node-store-misses
  32706767 ±  3%     +10.2%   36055755 ±  3%  perf-stat.ps.node-stores
 2.224e+12           +17.8%  2.621e+12        perf-stat.total.instructions
     69224 ±  4%     +10.0%      76158 ±  5%  interrupts.CPU0.LOC:Local_timer_interrupts
      2598 ± 23%    +222.8%       8389 ± 14%  interrupts.CPU0.NMI:Non-maskable_interrupts
      2598 ± 23%    +222.8%       8389 ± 14%  interrupts.CPU0.PMI:Performance_monitoring_interrupts
      4074 ±  4%     +33.6%       5443 ± 11%  interrupts.CPU0.RES:Rescheduling_interrupts
     69234 ±  4%     +10.1%      76193 ±  5%  interrupts.CPU1.LOC:Local_timer_interrupts
      2690 ± 22%    +227.1%       8799 ±  4%  interrupts.CPU1.NMI:Non-maskable_interrupts
      2690 ± 22%    +227.1%       8799 ±  4%  interrupts.CPU1.PMI:Performance_monitoring_interrupts
     69202 ±  4%     +10.1%      76197 ±  5%  interrupts.CPU10.LOC:Local_timer_interrupts
      2504 ± 21%    +214.5%       7877 ± 19%  interrupts.CPU10.NMI:Non-maskable_interrupts
      2504 ± 21%    +214.5%       7877 ± 19%  interrupts.CPU10.PMI:Performance_monitoring_interrupts
      4174 ± 12%     +32.3%       5522 ± 13%  interrupts.CPU10.RES:Rescheduling_interrupts
     69168 ±  4%     +11.1%      76836 ±  6%  interrupts.CPU100.LOC:Local_timer_interrupts
      2948 ± 12%    +169.3%       7939 ± 19%  interrupts.CPU100.NMI:Non-maskable_interrupts
      2948 ± 12%    +169.3%       7939 ± 19%  interrupts.CPU100.PMI:Performance_monitoring_interrupts
      3729 ±  5%     +34.6%       5020 ±  7%  interrupts.CPU100.RES:Rescheduling_interrupts
     69006 ±  4%     +10.6%      76312 ±  5%  interrupts.CPU101.LOC:Local_timer_interrupts
      2833 ± 14%    +178.8%       7899 ± 19%  interrupts.CPU101.NMI:Non-maskable_interrupts
      2833 ± 14%    +178.8%       7899 ± 19%  interrupts.CPU101.PMI:Performance_monitoring_interrupts
      3712 ±  5%     +28.2%       4760 ±  2%  interrupts.CPU101.RES:Rescheduling_interrupts
     69192 ±  4%     +10.4%      76383 ±  5%  interrupts.CPU102.LOC:Local_timer_interrupts
      2996 ± 14%    +163.6%       7900 ± 19%  interrupts.CPU102.NMI:Non-maskable_interrupts
      2996 ± 14%    +163.6%       7900 ± 19%  interrupts.CPU102.PMI:Performance_monitoring_interrupts
      3749 ±  2%     +27.9%       4797 ±  2%  interrupts.CPU102.RES:Rescheduling_interrupts
     69191 ±  4%     +10.4%      76360 ±  5%  interrupts.CPU103.LOC:Local_timer_interrupts
      2744 ± 18%    +205.1%       8371 ± 14%  interrupts.CPU103.NMI:Non-maskable_interrupts
      2744 ± 18%    +205.1%       8371 ± 14%  interrupts.CPU103.PMI:Performance_monitoring_interrupts
      3707 ±  3%     +26.7%       4697 ±  6%  interrupts.CPU103.RES:Rescheduling_interrupts
     69201 ±  4%     +10.3%      76355 ±  5%  interrupts.CPU104.LOC:Local_timer_interrupts
      2788 ± 17%    +210.3%       8653 ± 10%  interrupts.CPU104.NMI:Non-maskable_interrupts
      2788 ± 17%    +210.3%       8653 ± 10%  interrupts.CPU104.PMI:Performance_monitoring_interrupts
      3720 ±  3%     +33.7%       4975 ± 19%  interrupts.CPU104.RES:Rescheduling_interrupts
     69162 ±  4%     +10.3%      76280 ±  5%  interrupts.CPU105.LOC:Local_timer_interrupts
      2512 ± 18%    +234.2%       8397 ± 13%  interrupts.CPU105.NMI:Non-maskable_interrupts
      2512 ± 18%    +234.2%       8397 ± 13%  interrupts.CPU105.PMI:Performance_monitoring_interrupts
      3683 ±  3%     +25.0%       4602 ±  5%  interrupts.CPU105.RES:Rescheduling_interrupts
     69163 ±  4%      +9.9%      76032 ±  5%  interrupts.CPU106.LOC:Local_timer_interrupts
      2820 ± 16%    +196.1%       8352 ± 12%  interrupts.CPU106.NMI:Non-maskable_interrupts
      2820 ± 16%    +196.1%       8352 ± 12%  interrupts.CPU106.PMI:Performance_monitoring_interrupts
      3760 ±  4%     +29.7%       4879 ±  7%  interrupts.CPU106.RES:Rescheduling_interrupts
     69181 ±  4%     +10.3%      76306 ±  5%  interrupts.CPU107.LOC:Local_timer_interrupts
      2760 ± 19%    +201.5%       8320 ± 14%  interrupts.CPU107.NMI:Non-maskable_interrupts
      2760 ± 19%    +201.5%       8320 ± 14%  interrupts.CPU107.PMI:Performance_monitoring_interrupts
      3753           +33.5%       5011 ±  6%  interrupts.CPU107.RES:Rescheduling_interrupts
     69166 ±  4%     +10.3%      76316 ±  5%  interrupts.CPU108.LOC:Local_timer_interrupts
      2471 ± 22%    +241.0%       8429 ± 14%  interrupts.CPU108.NMI:Non-maskable_interrupts
      2471 ± 22%    +241.0%       8429 ± 14%  interrupts.CPU108.PMI:Performance_monitoring_interrupts
      3829 ±  3%     +31.1%       5021 ±  9%  interrupts.CPU108.RES:Rescheduling_interrupts
     69169 ±  4%     +10.3%      76309 ±  5%  interrupts.CPU109.LOC:Local_timer_interrupts
      2241 ± 13%    +277.0%       8450 ± 14%  interrupts.CPU109.NMI:Non-maskable_interrupts
      2241 ± 13%    +277.0%       8450 ± 14%  interrupts.CPU109.PMI:Performance_monitoring_interrupts
     69205 ±  4%     +12.0%      77543 ±  7%  interrupts.CPU11.LOC:Local_timer_interrupts
      2657 ± 20%    +207.6%       8173 ± 16%  interrupts.CPU11.NMI:Non-maskable_interrupts
      2657 ± 20%    +207.6%       8173 ± 16%  interrupts.CPU11.PMI:Performance_monitoring_interrupts
     69170 ±  4%     +10.2%      76230 ±  5%  interrupts.CPU110.LOC:Local_timer_interrupts
      2339 ± 22%    +262.1%       8469 ± 14%  interrupts.CPU110.NMI:Non-maskable_interrupts
      2339 ± 22%    +262.1%       8469 ± 14%  interrupts.CPU110.PMI:Performance_monitoring_interrupts
     69185 ±  4%     +10.3%      76300 ±  5%  interrupts.CPU111.LOC:Local_timer_interrupts
      2299 ± 15%    +290.8%       8986 ±  3%  interrupts.CPU111.NMI:Non-maskable_interrupts
      2299 ± 15%    +290.8%       8986 ±  3%  interrupts.CPU111.PMI:Performance_monitoring_interrupts
      3749 ±  2%     +34.2%       5030 ±  4%  interrupts.CPU111.RES:Rescheduling_interrupts
     69165 ±  4%     +10.4%      76328 ±  5%  interrupts.CPU112.LOC:Local_timer_interrupts
      2469 ± 19%    +260.4%       8899 ±  3%  interrupts.CPU112.NMI:Non-maskable_interrupts
      2469 ± 19%    +260.4%       8899 ±  3%  interrupts.CPU112.PMI:Performance_monitoring_interrupts
      3655 ±  3%     +26.9%       4637 ±  5%  interrupts.CPU112.RES:Rescheduling_interrupts
     69154 ±  4%     +10.4%      76365 ±  5%  interrupts.CPU113.LOC:Local_timer_interrupts
      2566 ± 19%    +226.2%       8371 ± 13%  interrupts.CPU113.NMI:Non-maskable_interrupts
      2566 ± 19%    +226.2%       8371 ± 13%  interrupts.CPU113.PMI:Performance_monitoring_interrupts
      3734 ±  4%     +35.9%       5074 ±  8%  interrupts.CPU113.RES:Rescheduling_interrupts
     69179 ±  4%     +10.3%      76280 ±  5%  interrupts.CPU114.LOC:Local_timer_interrupts
      2536 ± 17%    +231.8%       8416 ± 14%  interrupts.CPU114.NMI:Non-maskable_interrupts
      2536 ± 17%    +231.8%       8416 ± 14%  interrupts.CPU114.PMI:Performance_monitoring_interrupts
      3752 ±  2%     +38.4%       5192 ± 16%  interrupts.CPU114.RES:Rescheduling_interrupts
     69173 ±  4%     +10.5%      76468 ±  5%  interrupts.CPU115.LOC:Local_timer_interrupts
      2680 ± 19%    +198.4%       7999 ± 19%  interrupts.CPU115.NMI:Non-maskable_interrupts
      2680 ± 19%    +198.4%       7999 ± 19%  interrupts.CPU115.PMI:Performance_monitoring_interrupts
      3779 ±  3%     +27.9%       4834 ±  5%  interrupts.CPU115.RES:Rescheduling_interrupts
     69181 ±  4%     +10.3%      76305 ±  5%  interrupts.CPU116.LOC:Local_timer_interrupts
      2625 ± 15%    +220.5%       8416 ± 14%  interrupts.CPU116.NMI:Non-maskable_interrupts
      2625 ± 15%    +220.5%       8416 ± 14%  interrupts.CPU116.PMI:Performance_monitoring_interrupts
      3709 ±  4%     +28.4%       4761 ±  5%  interrupts.CPU116.RES:Rescheduling_interrupts
     69192 ±  4%     +10.2%      76275 ±  5%  interrupts.CPU117.LOC:Local_timer_interrupts
      2657 ± 18%    +196.2%       7872 ± 17%  interrupts.CPU117.NMI:Non-maskable_interrupts
      2657 ± 18%    +196.2%       7872 ± 17%  interrupts.CPU117.PMI:Performance_monitoring_interrupts
      3820 ±  4%     +30.4%       4980 ± 14%  interrupts.CPU117.RES:Rescheduling_interrupts
     69167 ±  4%     +10.4%      76334 ±  5%  interrupts.CPU118.LOC:Local_timer_interrupts
      2916 ± 19%    +168.8%       7841 ± 17%  interrupts.CPU118.NMI:Non-maskable_interrupts
      2916 ± 19%    +168.8%       7841 ± 17%  interrupts.CPU118.PMI:Performance_monitoring_interrupts
      3804 ±  3%     +28.6%       4891 ±  4%  interrupts.CPU118.RES:Rescheduling_interrupts
     69176 ±  4%     +10.3%      76303 ±  5%  interrupts.CPU119.LOC:Local_timer_interrupts
      2667 ± 19%    +195.1%       7874 ± 17%  interrupts.CPU119.NMI:Non-maskable_interrupts
      2667 ± 19%    +195.1%       7874 ± 17%  interrupts.CPU119.PMI:Performance_monitoring_interrupts
      3646 ±  2%     +34.6%       4907 ±  8%  interrupts.CPU119.RES:Rescheduling_interrupts
     69243 ±  4%     +10.9%      76824 ±  5%  interrupts.CPU12.LOC:Local_timer_interrupts
      2493 ± 22%    +213.9%       7828 ± 18%  interrupts.CPU12.NMI:Non-maskable_interrupts
      2493 ± 22%    +213.9%       7828 ± 18%  interrupts.CPU12.PMI:Performance_monitoring_interrupts
      3913 ±  2%     +27.6%       4994 ±  4%  interrupts.CPU12.RES:Rescheduling_interrupts
     69173 ±  4%     +10.2%      76255 ±  5%  interrupts.CPU120.LOC:Local_timer_interrupts
      2795 ± 16%    +180.8%       7848 ± 17%  interrupts.CPU120.NMI:Non-maskable_interrupts
      2795 ± 16%    +180.8%       7848 ± 17%  interrupts.CPU120.PMI:Performance_monitoring_interrupts
      3735 ±  4%     +26.2%       4714 ±  4%  interrupts.CPU120.RES:Rescheduling_interrupts
     69180 ±  4%     +10.3%      76326 ±  5%  interrupts.CPU121.LOC:Local_timer_interrupts
      2921 ± 16%    +174.0%       8004 ± 17%  interrupts.CPU121.NMI:Non-maskable_interrupts
      2921 ± 16%    +174.0%       8004 ± 17%  interrupts.CPU121.PMI:Performance_monitoring_interrupts
      3829 ±  3%     +42.8%       5467 ± 17%  interrupts.CPU121.RES:Rescheduling_interrupts
     69182 ±  4%     +10.3%      76301 ±  5%  interrupts.CPU122.LOC:Local_timer_interrupts
      2714 ± 15%    +192.0%       7925 ± 17%  interrupts.CPU122.NMI:Non-maskable_interrupts
      2714 ± 15%    +192.0%       7925 ± 17%  interrupts.CPU122.PMI:Performance_monitoring_interrupts
      3713 ±  3%     +31.4%       4877 ±  4%  interrupts.CPU122.RES:Rescheduling_interrupts
     69155 ±  4%     +10.4%      76361 ±  5%  interrupts.CPU123.LOC:Local_timer_interrupts
      2743 ± 16%    +206.0%       8394 ± 14%  interrupts.CPU123.NMI:Non-maskable_interrupts
      2743 ± 16%    +206.0%       8394 ± 14%  interrupts.CPU123.PMI:Performance_monitoring_interrupts
      3684 ±  3%     +31.3%       4839 ±  7%  interrupts.CPU123.RES:Rescheduling_interrupts
     69168 ±  4%     +10.3%      76282 ±  5%  interrupts.CPU124.LOC:Local_timer_interrupts
      2584 ± 18%    +225.5%       8411 ± 13%  interrupts.CPU124.NMI:Non-maskable_interrupts
      2584 ± 18%    +225.5%       8411 ± 13%  interrupts.CPU124.PMI:Performance_monitoring_interrupts
      3655 ±  3%     +32.2%       4832 ±  6%  interrupts.CPU124.RES:Rescheduling_interrupts
     69207 ±  4%     +10.4%      76422 ±  5%  interrupts.CPU125.LOC:Local_timer_interrupts
      2632 ± 17%    +220.2%       8429 ± 14%  interrupts.CPU125.NMI:Non-maskable_interrupts
      2632 ± 17%    +220.2%       8429 ± 14%  interrupts.CPU125.PMI:Performance_monitoring_interrupts
      3715 ±  4%     +40.3%       5211 ± 18%  interrupts.CPU125.RES:Rescheduling_interrupts
     69172 ±  4%     +10.4%      76364 ±  5%  interrupts.CPU126.LOC:Local_timer_interrupts
      2755 ± 18%    +189.0%       7963 ± 18%  interrupts.CPU126.NMI:Non-maskable_interrupts
      2755 ± 18%    +189.0%       7963 ± 18%  interrupts.CPU126.PMI:Performance_monitoring_interrupts
      3598 ±  5%     +33.9%       4816 ±  3%  interrupts.CPU126.RES:Rescheduling_interrupts
     69018 ±  4%     +11.1%      76646 ±  5%  interrupts.CPU127.LOC:Local_timer_interrupts
      2792 ± 19%    +169.4%       7521 ± 20%  interrupts.CPU127.NMI:Non-maskable_interrupts
      2792 ± 19%    +169.4%       7521 ± 20%  interrupts.CPU127.PMI:Performance_monitoring_interrupts
      3261 ±  4%     +31.2%       4280 ± 10%  interrupts.CPU127.RES:Rescheduling_interrupts
     69216 ±  4%     +10.8%      76658 ±  5%  interrupts.CPU13.LOC:Local_timer_interrupts
      2497 ± 20%    +215.9%       7890 ± 18%  interrupts.CPU13.NMI:Non-maskable_interrupts
      2497 ± 20%    +215.9%       7890 ± 18%  interrupts.CPU13.PMI:Performance_monitoring_interrupts
      4043 ±  2%     +39.9%       5658 ± 20%  interrupts.CPU13.RES:Rescheduling_interrupts
     69343 ±  4%     +10.0%      76295 ±  5%  interrupts.CPU14.LOC:Local_timer_interrupts
      2633 ± 20%    +198.8%       7868 ± 18%  interrupts.CPU14.NMI:Non-maskable_interrupts
      2633 ± 20%    +198.8%       7868 ± 18%  interrupts.CPU14.PMI:Performance_monitoring_interrupts
      2562 ± 18%    +209.0%       7917 ± 18%  interrupts.CPU15.NMI:Non-maskable_interrupts
      2562 ± 18%    +209.0%       7917 ± 18%  interrupts.CPU15.PMI:Performance_monitoring_interrupts
      4087 ± 10%     +29.9%       5307 ± 13%  interrupts.CPU15.RES:Rescheduling_interrupts
      2653 ± 21%    +178.4%       7386 ± 19%  interrupts.CPU16.NMI:Non-maskable_interrupts
      2653 ± 21%    +178.4%       7386 ± 19%  interrupts.CPU16.PMI:Performance_monitoring_interrupts
      3931 ±  3%     +28.1%       5035 ±  3%  interrupts.CPU16.RES:Rescheduling_interrupts
     69224 ±  4%     +10.1%      76228 ±  5%  interrupts.CPU17.LOC:Local_timer_interrupts
      2614 ± 17%    +199.6%       7833 ± 16%  interrupts.CPU17.NMI:Non-maskable_interrupts
      2614 ± 17%    +199.6%       7833 ± 16%  interrupts.CPU17.PMI:Performance_monitoring_interrupts
      2494 ± 18%    +256.4%       8890 ±  2%  interrupts.CPU18.NMI:Non-maskable_interrupts
      2494 ± 18%    +256.4%       8890 ±  2%  interrupts.CPU18.PMI:Performance_monitoring_interrupts
      3898 ±  5%     +29.9%       5063 ±  5%  interrupts.CPU18.RES:Rescheduling_interrupts
     69206 ±  4%     +10.3%      76316 ±  5%  interrupts.CPU19.LOC:Local_timer_interrupts
      2798 ± 15%    +179.3%       7815 ± 16%  interrupts.CPU19.NMI:Non-maskable_interrupts
      2798 ± 15%    +179.3%       7815 ± 16%  interrupts.CPU19.PMI:Performance_monitoring_interrupts
      3897 ±  3%     +33.6%       5205 ±  6%  interrupts.CPU19.RES:Rescheduling_interrupts
     69233 ±  4%     +10.2%      76318 ±  5%  interrupts.CPU2.LOC:Local_timer_interrupts
      2807 ± 21%    +197.3%       8345 ± 13%  interrupts.CPU2.NMI:Non-maskable_interrupts
      2807 ± 21%    +197.3%       8345 ± 13%  interrupts.CPU2.PMI:Performance_monitoring_interrupts
     69206 ±  4%     +10.1%      76207 ±  5%  interrupts.CPU20.LOC:Local_timer_interrupts
      2423 ± 19%    +244.6%       8350 ± 11%  interrupts.CPU20.NMI:Non-maskable_interrupts
      2423 ± 19%    +244.6%       8350 ± 11%  interrupts.CPU20.PMI:Performance_monitoring_interrupts
      3938 ±  4%     +33.3%       5250 ±  8%  interrupts.CPU20.RES:Rescheduling_interrupts
     69244 ±  4%     +10.2%      76278 ±  5%  interrupts.CPU21.LOC:Local_timer_interrupts
      2211 ± 16%    +277.4%       8345 ± 11%  interrupts.CPU21.NMI:Non-maskable_interrupts
      2211 ± 16%    +277.4%       8345 ± 11%  interrupts.CPU21.PMI:Performance_monitoring_interrupts
      3916 ±  4%     +32.1%       5173 ±  7%  interrupts.CPU21.RES:Rescheduling_interrupts
     69183 ±  4%     +10.2%      76243 ±  5%  interrupts.CPU22.LOC:Local_timer_interrupts
      2255 ± 22%    +266.4%       8264 ± 12%  interrupts.CPU22.NMI:Non-maskable_interrupts
      2255 ± 22%    +266.4%       8264 ± 12%  interrupts.CPU22.PMI:Performance_monitoring_interrupts
     69246 ±  4%     +10.2%      76293 ±  5%  interrupts.CPU23.LOC:Local_timer_interrupts
      2655 ± 21%    +213.5%       8324 ± 12%  interrupts.CPU23.NMI:Non-maskable_interrupts
      2655 ± 21%    +213.5%       8324 ± 12%  interrupts.CPU23.PMI:Performance_monitoring_interrupts
      3933 ±  2%     +37.4%       5406 ± 23%  interrupts.CPU23.RES:Rescheduling_interrupts
     69137 ±  4%     +10.3%      76286 ±  5%  interrupts.CPU24.LOC:Local_timer_interrupts
      2510 ± 23%    +230.7%       8303 ± 11%  interrupts.CPU24.NMI:Non-maskable_interrupts
      2510 ± 23%    +230.7%       8303 ± 11%  interrupts.CPU24.PMI:Performance_monitoring_interrupts
      3907 ±  4%     +34.1%       5238 ± 14%  interrupts.CPU24.RES:Rescheduling_interrupts
     69211 ±  4%     +15.3%      79784 ±  8%  interrupts.CPU25.LOC:Local_timer_interrupts
      2835 ± 19%    +213.0%       8875 ±  2%  interrupts.CPU25.NMI:Non-maskable_interrupts
      2835 ± 19%    +213.0%       8875 ±  2%  interrupts.CPU25.PMI:Performance_monitoring_interrupts
      3963 ±  3%     +26.9%       5028 ±  5%  interrupts.CPU25.RES:Rescheduling_interrupts
     69219 ±  4%     +10.0%      76170 ±  5%  interrupts.CPU26.LOC:Local_timer_interrupts
      2745 ± 17%    +225.8%       8942 ±  2%  interrupts.CPU26.NMI:Non-maskable_interrupts
      2745 ± 17%    +225.8%       8942 ±  2%  interrupts.CPU26.PMI:Performance_monitoring_interrupts
      3879 ±  3%     +35.6%       5259 ± 12%  interrupts.CPU26.RES:Rescheduling_interrupts
     69226 ±  4%     +10.2%      76273 ±  5%  interrupts.CPU27.LOC:Local_timer_interrupts
      2758 ± 16%    +222.4%       8892 ±  2%  interrupts.CPU27.NMI:Non-maskable_interrupts
      2758 ± 16%    +222.4%       8892 ±  2%  interrupts.CPU27.PMI:Performance_monitoring_interrupts
      2981 ± 13%    +198.9%       8909 ±  3%  interrupts.CPU28.NMI:Non-maskable_interrupts
      2981 ± 13%    +198.9%       8909 ±  3%  interrupts.CPU28.PMI:Performance_monitoring_interrupts
      3898 ±  4%     +28.2%       4996 ± 11%  interrupts.CPU28.RES:Rescheduling_interrupts
     69499 ±  5%      +9.5%      76123 ±  5%  interrupts.CPU29.LOC:Local_timer_interrupts
      2988 ± 15%    +196.8%       8869 ±  3%  interrupts.CPU29.NMI:Non-maskable_interrupts
      2988 ± 15%    +196.8%       8869 ±  3%  interrupts.CPU29.PMI:Performance_monitoring_interrupts
      3943 ±  3%     +24.4%       4904 ±  3%  interrupts.CPU29.RES:Rescheduling_interrupts
     69195 ±  4%     +10.3%      76353 ±  5%  interrupts.CPU3.LOC:Local_timer_interrupts
      2763 ± 18%    +217.4%       8772 ±  3%  interrupts.CPU3.NMI:Non-maskable_interrupts
      2763 ± 18%    +217.4%       8772 ±  3%  interrupts.CPU3.PMI:Performance_monitoring_interrupts
      4003 ±  4%     +38.9%       5558 ± 19%  interrupts.CPU3.RES:Rescheduling_interrupts
     69239 ±  4%     +10.1%      76262 ±  5%  interrupts.CPU30.LOC:Local_timer_interrupts
      3170 ±  2%    +179.8%       8870 ±  3%  interrupts.CPU30.NMI:Non-maskable_interrupts
      3170 ±  2%    +179.8%       8870 ±  3%  interrupts.CPU30.PMI:Performance_monitoring_interrupts
      3996 ±  5%     +29.0%       5153 ±  3%  interrupts.CPU30.RES:Rescheduling_interrupts
     69213 ±  4%     +10.1%      76198 ±  5%  interrupts.CPU31.LOC:Local_timer_interrupts
      3165 ±  4%    +178.9%       8829 ±  2%  interrupts.CPU31.NMI:Non-maskable_interrupts
      3165 ±  4%    +178.9%       8829 ±  2%  interrupts.CPU31.PMI:Performance_monitoring_interrupts
      3927 ±  3%     +28.6%       5051 ±  4%  interrupts.CPU31.RES:Rescheduling_interrupts
     69085 ±  4%     +13.4%      78358 ±  4%  interrupts.CPU32.LOC:Local_timer_interrupts
      3168 ±  5%    +179.5%       8857 ±  2%  interrupts.CPU32.NMI:Non-maskable_interrupts
      3168 ±  5%    +179.5%       8857 ±  2%  interrupts.CPU32.PMI:Performance_monitoring_interrupts
      3716 ±  2%     +30.3%       4842 ±  3%  interrupts.CPU32.RES:Rescheduling_interrupts
     69197 ±  4%     +16.2%      80403 ±  9%  interrupts.CPU33.LOC:Local_timer_interrupts
      3203 ±  4%    +168.6%       8604 ± 13%  interrupts.CPU33.NMI:Non-maskable_interrupts
      3203 ±  4%    +168.6%       8604 ± 13%  interrupts.CPU33.PMI:Performance_monitoring_interrupts
     69200 ±  4%     +10.4%      76370 ±  5%  interrupts.CPU34.LOC:Local_timer_interrupts
      3040 ±  7%    +172.4%       8284 ± 13%  interrupts.CPU34.NMI:Non-maskable_interrupts
      3040 ±  7%    +172.4%       8284 ± 13%  interrupts.CPU34.PMI:Performance_monitoring_interrupts
     69199 ±  4%     +10.3%      76325 ±  5%  interrupts.CPU35.LOC:Local_timer_interrupts
      3178 ±  6%    +164.6%       8412 ± 13%  interrupts.CPU35.NMI:Non-maskable_interrupts
      3178 ±  6%    +164.6%       8412 ± 13%  interrupts.CPU35.PMI:Performance_monitoring_interrupts
      3734 ±  4%     +35.5%       5061 ±  4%  interrupts.CPU35.RES:Rescheduling_interrupts
     69134 ±  4%     +10.6%      76432 ±  5%  interrupts.CPU36.LOC:Local_timer_interrupts
      3158 ±  4%    +150.1%       7899 ± 16%  interrupts.CPU36.NMI:Non-maskable_interrupts
      3158 ±  4%    +150.1%       7899 ± 16%  interrupts.CPU36.PMI:Performance_monitoring_interrupts
      3756 ±  2%     +39.7%       5246 ± 17%  interrupts.CPU36.RES:Rescheduling_interrupts
     69178 ±  4%     +10.4%      76358 ±  5%  interrupts.CPU37.LOC:Local_timer_interrupts
      3283 ±  5%    +140.3%       7890 ± 17%  interrupts.CPU37.NMI:Non-maskable_interrupts
      3283 ±  5%    +140.3%       7890 ± 17%  interrupts.CPU37.PMI:Performance_monitoring_interrupts
      3821 ±  2%     +35.9%       5193 ± 14%  interrupts.CPU37.RES:Rescheduling_interrupts
     69203 ±  4%     +10.4%      76417 ±  5%  interrupts.CPU38.LOC:Local_timer_interrupts
      3236          +158.5%       8364 ± 14%  interrupts.CPU38.NMI:Non-maskable_interrupts
      3236          +158.5%       8364 ± 14%  interrupts.CPU38.PMI:Performance_monitoring_interrupts
      3738 ±  2%     +44.5%       5399 ± 23%  interrupts.CPU38.RES:Rescheduling_interrupts
     69188 ±  4%     +10.3%      76336 ±  5%  interrupts.CPU39.LOC:Local_timer_interrupts
      3199 ±  4%    +163.6%       8435 ± 14%  interrupts.CPU39.NMI:Non-maskable_interrupts
      3199 ±  4%    +163.6%       8435 ± 14%  interrupts.CPU39.PMI:Performance_monitoring_interrupts
      3833 ±  4%     +32.8%       5089 ± 12%  interrupts.CPU39.RES:Rescheduling_interrupts
     69206 ±  4%     +10.3%      76337 ±  5%  interrupts.CPU4.LOC:Local_timer_interrupts
      2414 ± 20%    +265.6%       8827 ±  3%  interrupts.CPU4.NMI:Non-maskable_interrupts
      2414 ± 20%    +265.6%       8827 ±  3%  interrupts.CPU4.PMI:Performance_monitoring_interrupts
      3840 ±  5%     +32.0%       5070 ±  4%  interrupts.CPU4.RES:Rescheduling_interrupts
     69200 ±  4%     +10.3%      76322 ±  5%  interrupts.CPU40.LOC:Local_timer_interrupts
      3043 ±  6%    +174.3%       8347 ± 14%  interrupts.CPU40.NMI:Non-maskable_interrupts
      3043 ±  6%    +174.3%       8347 ± 14%  interrupts.CPU40.PMI:Performance_monitoring_interrupts
      3677 ±  2%     +30.5%       4797 ±  4%  interrupts.CPU40.RES:Rescheduling_interrupts
     69121 ±  4%     +10.3%      76258 ±  5%  interrupts.CPU41.LOC:Local_timer_interrupts
      3114 ±  3%    +170.6%       8426 ± 14%  interrupts.CPU41.NMI:Non-maskable_interrupts
      3114 ±  3%    +170.6%       8426 ± 14%  interrupts.CPU41.PMI:Performance_monitoring_interrupts
      3839 ±  5%     +41.4%       5429 ± 19%  interrupts.CPU41.RES:Rescheduling_interrupts
     69137 ±  4%     +10.4%      76323 ±  5%  interrupts.CPU42.LOC:Local_timer_interrupts
      3076 ±  3%    +176.5%       8506 ± 14%  interrupts.CPU42.NMI:Non-maskable_interrupts
      3076 ±  3%    +176.5%       8506 ± 14%  interrupts.CPU42.PMI:Performance_monitoring_interrupts
      3732 ±  3%     +43.4%       5354 ± 15%  interrupts.CPU42.RES:Rescheduling_interrupts
     69187 ±  4%     +10.3%      76324 ±  5%  interrupts.CPU43.LOC:Local_timer_interrupts
      3096          +174.2%       8491 ± 14%  interrupts.CPU43.NMI:Non-maskable_interrupts
      3096          +174.2%       8491 ± 14%  interrupts.CPU43.PMI:Performance_monitoring_interrupts
      3706 ±  2%     +36.6%       5062 ±  6%  interrupts.CPU43.RES:Rescheduling_interrupts
     69159 ±  4%     +10.4%      76318 ±  5%  interrupts.CPU44.LOC:Local_timer_interrupts
      3143 ±  3%    +168.1%       8428 ± 13%  interrupts.CPU44.NMI:Non-maskable_interrupts
      3143 ±  3%    +168.1%       8428 ± 13%  interrupts.CPU44.PMI:Performance_monitoring_interrupts
      3735 ±  3%     +32.7%       4955 ±  7%  interrupts.CPU44.RES:Rescheduling_interrupts
     69158 ±  4%     +10.3%      76315 ±  5%  interrupts.CPU45.LOC:Local_timer_interrupts
      3143 ±  5%    +168.1%       8428 ± 14%  interrupts.CPU45.NMI:Non-maskable_interrupts
      3143 ±  5%    +168.1%       8428 ± 14%  interrupts.CPU45.PMI:Performance_monitoring_interrupts
      3787 ±  2%     +28.7%       4874 ±  3%  interrupts.CPU45.RES:Rescheduling_interrupts
     69190 ±  4%     +10.4%      76360 ±  5%  interrupts.CPU46.LOC:Local_timer_interrupts
      3117 ±  6%    +170.6%       8434 ± 12%  interrupts.CPU46.NMI:Non-maskable_interrupts
      3117 ±  6%    +170.6%       8434 ± 12%  interrupts.CPU46.PMI:Performance_monitoring_interrupts
      3703 ±  3%     +31.7%       4877 ±  3%  interrupts.CPU46.RES:Rescheduling_interrupts
     69211 ±  4%     +10.2%      76296 ±  5%  interrupts.CPU47.LOC:Local_timer_interrupts
      3199 ±  5%    +146.0%       7870 ± 18%  interrupts.CPU47.NMI:Non-maskable_interrupts
      3199 ±  5%    +146.0%       7870 ± 18%  interrupts.CPU47.PMI:Performance_monitoring_interrupts
      3729 ±  4%     +37.6%       5132 ± 12%  interrupts.CPU47.RES:Rescheduling_interrupts
     69200 ±  4%     +10.3%      76348 ±  5%  interrupts.CPU48.LOC:Local_timer_interrupts
      3042 ± 13%    +164.9%       8059 ± 19%  interrupts.CPU48.NMI:Non-maskable_interrupts
      3042 ± 13%    +164.9%       8059 ± 19%  interrupts.CPU48.PMI:Performance_monitoring_interrupts
      3766 ±  3%     +25.0%       4707 ±  6%  interrupts.CPU48.RES:Rescheduling_interrupts
     69276 ±  4%     +10.0%      76189 ±  5%  interrupts.CPU49.LOC:Local_timer_interrupts
      2896 ± 14%    +174.2%       7943 ± 17%  interrupts.CPU49.NMI:Non-maskable_interrupts
      2896 ± 14%    +174.2%       7943 ± 17%  interrupts.CPU49.PMI:Performance_monitoring_interrupts
     69230 ±  4%     +10.3%      76344 ±  5%  interrupts.CPU5.LOC:Local_timer_interrupts
      2616 ± 20%    +241.4%       8930 ±  2%  interrupts.CPU5.NMI:Non-maskable_interrupts
      2616 ± 20%    +241.4%       8930 ±  2%  interrupts.CPU5.PMI:Performance_monitoring_interrupts
      3921 ±  3%     +33.1%       5217 ±  5%  interrupts.CPU5.RES:Rescheduling_interrupts
     69230 ±  4%     +10.2%      76322 ±  5%  interrupts.CPU50.LOC:Local_timer_interrupts
      2956 ± 13%    +166.5%       7877 ± 17%  interrupts.CPU50.NMI:Non-maskable_interrupts
      2956 ± 13%    +166.5%       7877 ± 17%  interrupts.CPU50.PMI:Performance_monitoring_interrupts
      3642 ±  4%     +41.3%       5146 ±  7%  interrupts.CPU50.RES:Rescheduling_interrupts
     69198 ±  4%     +10.3%      76333 ±  5%  interrupts.CPU51.LOC:Local_timer_interrupts
      2937 ± 15%    +184.7%       8362 ± 14%  interrupts.CPU51.NMI:Non-maskable_interrupts
      2937 ± 15%    +184.7%       8362 ± 14%  interrupts.CPU51.PMI:Performance_monitoring_interrupts
      3815 ±  5%     +29.1%       4925 ±  9%  interrupts.CPU51.RES:Rescheduling_interrupts
     69208 ±  4%     +10.3%      76360 ±  5%  interrupts.CPU52.LOC:Local_timer_interrupts
      3197 ±  4%    +162.3%       8386 ± 13%  interrupts.CPU52.NMI:Non-maskable_interrupts
      3197 ±  4%    +162.3%       8386 ± 13%  interrupts.CPU52.PMI:Performance_monitoring_interrupts
      3709 ±  3%     +75.1%       6493 ± 44%  interrupts.CPU52.RES:Rescheduling_interrupts
     69199 ±  4%     +10.3%      76338 ±  5%  interrupts.CPU53.LOC:Local_timer_interrupts
      3116 ±  5%    +153.8%       7907 ± 17%  interrupts.CPU53.NMI:Non-maskable_interrupts
      3116 ±  5%    +153.8%       7907 ± 17%  interrupts.CPU53.PMI:Performance_monitoring_interrupts
      3720 ±  3%     +47.7%       5496 ± 26%  interrupts.CPU53.RES:Rescheduling_interrupts
     69214 ±  4%     +10.2%      76277 ±  5%  interrupts.CPU54.LOC:Local_timer_interrupts
      3000 ± 14%    +170.5%       8114 ± 20%  interrupts.CPU54.NMI:Non-maskable_interrupts
      3000 ± 14%    +170.5%       8114 ± 20%  interrupts.CPU54.PMI:Performance_monitoring_interrupts
      3744 ±  2%     +37.1%       5132 ± 15%  interrupts.CPU54.RES:Rescheduling_interrupts
     69292 ±  4%     +10.2%      76333 ±  5%  interrupts.CPU55.LOC:Local_timer_interrupts
      2871 ± 13%    +177.5%       7968 ± 19%  interrupts.CPU55.NMI:Non-maskable_interrupts
      2871 ± 13%    +177.5%       7968 ± 19%  interrupts.CPU55.PMI:Performance_monitoring_interrupts
      3644 ±  2%     +29.5%       4721 ±  6%  interrupts.CPU55.RES:Rescheduling_interrupts
     69191 ±  4%     +10.3%      76323 ±  5%  interrupts.CPU56.LOC:Local_timer_interrupts
      2988 ± 12%    +189.7%       8658 ± 15%  interrupts.CPU56.NMI:Non-maskable_interrupts
      2988 ± 12%    +189.7%       8658 ± 15%  interrupts.CPU56.PMI:Performance_monitoring_interrupts
      3755 ±  3%     +28.8%       4837 ±  9%  interrupts.CPU56.RES:Rescheduling_interrupts
     69179 ±  4%     +10.3%      76322 ±  5%  interrupts.CPU57.LOC:Local_timer_interrupts
      2852 ± 14%    +195.9%       8439 ± 14%  interrupts.CPU57.NMI:Non-maskable_interrupts
      2852 ± 14%    +195.9%       8439 ± 14%  interrupts.CPU57.PMI:Performance_monitoring_interrupts
      3663 ±  2%     +36.2%       4990 ±  8%  interrupts.CPU57.RES:Rescheduling_interrupts
     69255 ±  4%     +10.1%      76241 ±  5%  interrupts.CPU58.LOC:Local_timer_interrupts
      2743 ± 18%    +225.7%       8937 ±  2%  interrupts.CPU58.NMI:Non-maskable_interrupts
      2743 ± 18%    +225.7%       8937 ±  2%  interrupts.CPU58.PMI:Performance_monitoring_interrupts
      3733 ±  4%     +62.0%       6049 ± 33%  interrupts.CPU58.RES:Rescheduling_interrupts
      3148 ±  4%    +182.9%       8906 ±  2%  interrupts.CPU59.NMI:Non-maskable_interrupts
      3148 ±  4%    +182.9%       8906 ±  2%  interrupts.CPU59.PMI:Performance_monitoring_interrupts
      3668 ±  4%     +33.3%       4888 ±  2%  interrupts.CPU59.RES:Rescheduling_interrupts
     69082 ±  4%     +10.4%      76278 ±  5%  interrupts.CPU6.LOC:Local_timer_interrupts
      2672 ± 23%    +213.2%       8370 ± 14%  interrupts.CPU6.NMI:Non-maskable_interrupts
      2672 ± 23%    +213.2%       8370 ± 14%  interrupts.CPU6.PMI:Performance_monitoring_interrupts
      3979 ±  3%     +28.1%       5098 ±  8%  interrupts.CPU6.RES:Rescheduling_interrupts
      2895 ± 13%    +206.0%       8861 ±  2%  interrupts.CPU60.NMI:Non-maskable_interrupts
      2895 ± 13%    +206.0%       8861 ±  2%  interrupts.CPU60.PMI:Performance_monitoring_interrupts
      3771 ±  3%     +37.4%       5181 ± 12%  interrupts.CPU60.RES:Rescheduling_interrupts
     69115 ±  4%     +10.4%      76320 ±  5%  interrupts.CPU61.LOC:Local_timer_interrupts
      2954 ± 13%    +202.9%       8947 ±  2%  interrupts.CPU61.NMI:Non-maskable_interrupts
      2954 ± 13%    +202.9%       8947 ±  2%  interrupts.CPU61.PMI:Performance_monitoring_interrupts
      3820 ±  4%     +46.2%       5587 ± 19%  interrupts.CPU61.RES:Rescheduling_interrupts
     69194 ±  4%     +10.4%      76357 ±  5%  interrupts.CPU62.LOC:Local_timer_interrupts
      2902 ± 13%    +208.3%       8947 ±  2%  interrupts.CPU62.NMI:Non-maskable_interrupts
      2902 ± 13%    +208.3%       8947 ±  2%  interrupts.CPU62.PMI:Performance_monitoring_interrupts
      3768 ±  3%     +52.4%       5744 ± 27%  interrupts.CPU62.RES:Rescheduling_interrupts
     69217 ±  4%     +10.4%      76402 ±  5%  interrupts.CPU63.LOC:Local_timer_interrupts
      3153 ±  3%    +180.7%       8850 ±  2%  interrupts.CPU63.NMI:Non-maskable_interrupts
      3153 ±  3%    +180.7%       8850 ±  2%  interrupts.CPU63.PMI:Performance_monitoring_interrupts
      3587 ±  3%     +40.1%       5025 ± 14%  interrupts.CPU63.RES:Rescheduling_interrupts
     69224 ±  4%     +10.0%      76175 ±  5%  interrupts.CPU64.LOC:Local_timer_interrupts
      3163 ±  4%    +179.2%       8832 ±  2%  interrupts.CPU64.NMI:Non-maskable_interrupts
      3163 ±  4%    +179.2%       8832 ±  2%  interrupts.CPU64.PMI:Performance_monitoring_interrupts
      3887 ±  4%     +28.6%       4999 ±  7%  interrupts.CPU64.RES:Rescheduling_interrupts
     69338 ±  4%     +10.0%      76260 ±  5%  interrupts.CPU65.LOC:Local_timer_interrupts
      3079 ± 16%    +198.0%       9177 ±  6%  interrupts.CPU65.NMI:Non-maskable_interrupts
      3079 ± 16%    +198.0%       9177 ±  6%  interrupts.CPU65.PMI:Performance_monitoring_interrupts
     69257 ±  4%     +10.1%      76249 ±  5%  interrupts.CPU66.LOC:Local_timer_interrupts
      3190 ±  6%    +175.6%       8793 ±  2%  interrupts.CPU66.NMI:Non-maskable_interrupts
      3190 ±  6%    +175.6%       8793 ±  2%  interrupts.CPU66.PMI:Performance_monitoring_interrupts
     69230 ±  4%     +10.0%      76171 ±  5%  interrupts.CPU67.LOC:Local_timer_interrupts
      3188 ±  2%    +180.7%       8948 ±  2%  interrupts.CPU67.NMI:Non-maskable_interrupts
      3188 ±  2%    +180.7%       8948 ±  2%  interrupts.CPU67.PMI:Performance_monitoring_interrupts
      3893 ±  3%     +29.3%       5034 ±  5%  interrupts.CPU67.RES:Rescheduling_interrupts
      3214 ±  4%    +180.4%       9013 ±  4%  interrupts.CPU68.NMI:Non-maskable_interrupts
      3214 ±  4%    +180.4%       9013 ±  4%  interrupts.CPU68.PMI:Performance_monitoring_interrupts
     69205 ±  4%     +10.2%      76291 ±  5%  interrupts.CPU69.LOC:Local_timer_interrupts
      3130 ±  7%    +182.3%       8839 ±  2%  interrupts.CPU69.NMI:Non-maskable_interrupts
      3130 ±  7%    +182.3%       8839 ±  2%  interrupts.CPU69.PMI:Performance_monitoring_interrupts
     69222 ±  4%     +10.2%      76297 ±  5%  interrupts.CPU7.LOC:Local_timer_interrupts
      2409 ± 17%    +273.0%       8985 ±  6%  interrupts.CPU7.NMI:Non-maskable_interrupts
      2409 ± 17%    +273.0%       8985 ±  6%  interrupts.CPU7.PMI:Performance_monitoring_interrupts
      4024 ±  2%     +27.4%       5127 ±  9%  interrupts.CPU7.RES:Rescheduling_interrupts
     69183 ±  4%     +10.2%      76229 ±  5%  interrupts.CPU70.LOC:Local_timer_interrupts
      2890 ± 16%    +204.9%       8813 ±  2%  interrupts.CPU70.NMI:Non-maskable_interrupts
      2890 ± 16%    +204.9%       8813 ±  2%  interrupts.CPU70.PMI:Performance_monitoring_interrupts
     69209 ±  4%     +13.1%      78247 ± 10%  interrupts.CPU71.LOC:Local_timer_interrupts
      3185 ±  4%    +178.3%       8864 ±  2%  interrupts.CPU71.NMI:Non-maskable_interrupts
      3185 ±  4%    +178.3%       8864 ±  2%  interrupts.CPU71.PMI:Performance_monitoring_interrupts
     69160 ±  4%     +11.2%      76913 ±  6%  interrupts.CPU72.LOC:Local_timer_interrupts
      3152 ±  3%    +166.1%       8388 ± 13%  interrupts.CPU72.NMI:Non-maskable_interrupts
      3152 ±  3%    +166.1%       8388 ± 13%  interrupts.CPU72.PMI:Performance_monitoring_interrupts
      3992 ±  5%     +30.3%       5202 ±  7%  interrupts.CPU72.RES:Rescheduling_interrupts
     69247 ±  4%     +10.1%      76212 ±  5%  interrupts.CPU73.LOC:Local_timer_interrupts
      3207 ±  4%    +144.2%       7832 ± 18%  interrupts.CPU73.NMI:Non-maskable_interrupts
      3207 ±  4%    +144.2%       7832 ± 18%  interrupts.CPU73.PMI:Performance_monitoring_interrupts
      4079 ±  5%     +26.0%       5137 ±  5%  interrupts.CPU73.RES:Rescheduling_interrupts
      3109 ±  6%    +184.4%       8841 ±  2%  interrupts.CPU74.NMI:Non-maskable_interrupts
      3109 ±  6%    +184.4%       8841 ±  2%  interrupts.CPU74.PMI:Performance_monitoring_interrupts
      4033 ±  5%     +23.2%       4969 ±  5%  interrupts.CPU74.RES:Rescheduling_interrupts
     69076 ±  3%     +10.5%      76347 ±  5%  interrupts.CPU75.LOC:Local_timer_interrupts
      2944 ± 15%    +198.1%       8779 ±  3%  interrupts.CPU75.NMI:Non-maskable_interrupts
      2944 ± 15%    +198.1%       8779 ±  3%  interrupts.CPU75.PMI:Performance_monitoring_interrupts
      4062 ±  7%     +25.4%       5092 ±  7%  interrupts.CPU75.RES:Rescheduling_interrupts
     69221 ±  4%     +10.2%      76316 ±  5%  interrupts.CPU76.LOC:Local_timer_interrupts
      2969 ± 13%    +197.4%       8830 ±  2%  interrupts.CPU76.NMI:Non-maskable_interrupts
      2969 ± 13%    +197.4%       8830 ±  2%  interrupts.CPU76.PMI:Performance_monitoring_interrupts
      4013 ±  5%     +27.9%       5134 ±  6%  interrupts.CPU76.RES:Rescheduling_interrupts
     69185 ±  4%     +10.3%      76324 ±  5%  interrupts.CPU77.LOC:Local_timer_interrupts
      2899 ± 13%    +212.6%       9063 ±  4%  interrupts.CPU77.NMI:Non-maskable_interrupts
      2899 ± 13%    +212.6%       9063 ±  4%  interrupts.CPU77.PMI:Performance_monitoring_interrupts
      3882 ±  3%     +24.5%       4832 ±  7%  interrupts.CPU77.RES:Rescheduling_interrupts
     69385 ±  4%      +9.8%      76212 ±  5%  interrupts.CPU78.LOC:Local_timer_interrupts
      2582 ± 19%    +241.4%       8816 ±  2%  interrupts.CPU78.NMI:Non-maskable_interrupts
      2582 ± 19%    +241.4%       8816 ±  2%  interrupts.CPU78.PMI:Performance_monitoring_interrupts
      3987 ±  4%     +27.4%       5080 ±  2%  interrupts.CPU78.RES:Rescheduling_interrupts
     69234 ±  4%     +10.2%      76277 ±  5%  interrupts.CPU79.LOC:Local_timer_interrupts
      2702 ± 16%    +225.1%       8784 ±  2%  interrupts.CPU79.NMI:Non-maskable_interrupts
      2702 ± 16%    +225.1%       8784 ±  2%  interrupts.CPU79.PMI:Performance_monitoring_interrupts
     69199 ±  4%     +10.2%      76241 ±  5%  interrupts.CPU8.LOC:Local_timer_interrupts
      2766 ± 20%    +205.9%       8460 ± 14%  interrupts.CPU8.NMI:Non-maskable_interrupts
      2766 ± 20%    +205.9%       8460 ± 14%  interrupts.CPU8.PMI:Performance_monitoring_interrupts
      4080 ±  3%     +27.8%       5215 ±  9%  interrupts.CPU8.RES:Rescheduling_interrupts
     69236 ±  4%     +10.2%      76318 ±  5%  interrupts.CPU80.LOC:Local_timer_interrupts
      2822 ± 17%    +211.0%       8775 ±  3%  interrupts.CPU80.NMI:Non-maskable_interrupts
      2822 ± 17%    +211.0%       8775 ±  3%  interrupts.CPU80.PMI:Performance_monitoring_interrupts
      4121 ± 12%     +35.5%       5584 ± 15%  interrupts.CPU80.RES:Rescheduling_interrupts
     68967 ±  4%     +12.4%      77537 ±  7%  interrupts.CPU81.LOC:Local_timer_interrupts
      2792 ± 14%    +202.6%       8450 ± 11%  interrupts.CPU81.NMI:Non-maskable_interrupts
      2792 ± 14%    +202.6%       8450 ± 11%  interrupts.CPU81.PMI:Performance_monitoring_interrupts
      4064 ±  3%     +26.1%       5124 ±  9%  interrupts.CPU81.RES:Rescheduling_interrupts
     69179 ±  4%     +15.9%      80160 ± 12%  interrupts.CPU82.LOC:Local_timer_interrupts
      3051 ± 11%    +189.3%       8829 ±  2%  interrupts.CPU82.NMI:Non-maskable_interrupts
      3051 ± 11%    +189.3%       8829 ±  2%  interrupts.CPU82.PMI:Performance_monitoring_interrupts
      3997           +26.8%       5069 ±  4%  interrupts.CPU82.RES:Rescheduling_interrupts
      3012 ± 14%    +193.1%       8831 ±  2%  interrupts.CPU83.NMI:Non-maskable_interrupts
      3012 ± 14%    +193.1%       8831 ±  2%  interrupts.CPU83.PMI:Performance_monitoring_interrupts
      4121 ±  3%     +26.1%       5194 ±  4%  interrupts.CPU83.RES:Rescheduling_interrupts
     69218 ±  4%     +10.1%      76239 ±  5%  interrupts.CPU84.LOC:Local_timer_interrupts
      2941 ± 12%    +203.1%       8914 ±  3%  interrupts.CPU84.NMI:Non-maskable_interrupts
      2941 ± 12%    +203.1%       8914 ±  3%  interrupts.CPU84.PMI:Performance_monitoring_interrupts
      3943 ±  2%     +23.6%       4873 ±  7%  interrupts.CPU84.RES:Rescheduling_interrupts
     69214 ±  4%     +10.2%      76243 ±  5%  interrupts.CPU85.LOC:Local_timer_interrupts
      3078 ± 13%    +186.4%       8816 ±  2%  interrupts.CPU85.NMI:Non-maskable_interrupts
      3078 ± 13%    +186.4%       8816 ±  2%  interrupts.CPU85.PMI:Performance_monitoring_interrupts
     69185 ±  4%     +10.3%      76304 ±  5%  interrupts.CPU86.LOC:Local_timer_interrupts
      2952 ± 12%    +204.3%       8982 ±  2%  interrupts.CPU86.NMI:Non-maskable_interrupts
      2952 ± 12%    +204.3%       8982 ±  2%  interrupts.CPU86.PMI:Performance_monitoring_interrupts
      3977 ±  6%     +24.7%       4959 ±  6%  interrupts.CPU86.RES:Rescheduling_interrupts
     69220 ±  4%     +10.2%      76282 ±  5%  interrupts.CPU87.LOC:Local_timer_interrupts
      2967 ± 13%    +200.0%       8901 ±  4%  interrupts.CPU87.NMI:Non-maskable_interrupts
      2967 ± 13%    +200.0%       8901 ±  4%  interrupts.CPU87.PMI:Performance_monitoring_interrupts
     69223 ±  4%     +10.2%      76267 ±  5%  interrupts.CPU88.LOC:Local_timer_interrupts
      3071 ± 14%    +194.1%       9034 ±  5%  interrupts.CPU88.NMI:Non-maskable_interrupts
      3071 ± 14%    +194.1%       9034 ±  5%  interrupts.CPU88.PMI:Performance_monitoring_interrupts
      4163 ±  3%     +29.5%       5390 ± 21%  interrupts.CPU88.RES:Rescheduling_interrupts
     69167 ±  4%     +10.3%      76296 ±  5%  interrupts.CPU89.LOC:Local_timer_interrupts
      2982 ± 16%    +196.1%       8830 ±  2%  interrupts.CPU89.NMI:Non-maskable_interrupts
      2982 ± 16%    +196.1%       8830 ±  2%  interrupts.CPU89.PMI:Performance_monitoring_interrupts
      3950 ±  4%     +42.1%       5615 ± 22%  interrupts.CPU89.RES:Rescheduling_interrupts
     69226 ±  4%     +10.4%      76392 ±  5%  interrupts.CPU9.LOC:Local_timer_interrupts
      2454 ± 18%    +241.2%       8375 ± 14%  interrupts.CPU9.NMI:Non-maskable_interrupts
      2454 ± 18%    +241.2%       8375 ± 14%  interrupts.CPU9.PMI:Performance_monitoring_interrupts
     69249 ±  4%     +10.2%      76298 ±  5%  interrupts.CPU90.LOC:Local_timer_interrupts
      2994 ± 14%    +179.3%       8365 ± 14%  interrupts.CPU90.NMI:Non-maskable_interrupts
      2994 ± 14%    +179.3%       8365 ± 14%  interrupts.CPU90.PMI:Performance_monitoring_interrupts
     69232 ±  4%     +10.2%      76290 ±  5%  interrupts.CPU91.LOC:Local_timer_interrupts
      3208 ±  4%    +144.0%       7828 ± 19%  interrupts.CPU91.NMI:Non-maskable_interrupts
      3208 ±  4%    +144.0%       7828 ± 19%  interrupts.CPU91.PMI:Performance_monitoring_interrupts
      4193 ±  4%     +20.1%       5036 ±  5%  interrupts.CPU91.RES:Rescheduling_interrupts
     69249 ±  4%     +10.2%      76303 ±  5%  interrupts.CPU92.LOC:Local_timer_interrupts
      2940 ± 16%    +169.6%       7926 ± 19%  interrupts.CPU92.NMI:Non-maskable_interrupts
      2940 ± 16%    +169.6%       7926 ± 19%  interrupts.CPU92.PMI:Performance_monitoring_interrupts
      2931 ± 12%    +184.1%       8328 ± 14%  interrupts.CPU93.NMI:Non-maskable_interrupts
      2931 ± 12%    +184.1%       8328 ± 14%  interrupts.CPU93.PMI:Performance_monitoring_interrupts
     69239 ±  4%     +10.1%      76234 ±  5%  interrupts.CPU94.LOC:Local_timer_interrupts
      2921 ± 12%    +170.7%       7909 ± 18%  interrupts.CPU94.NMI:Non-maskable_interrupts
      2921 ± 12%    +170.7%       7909 ± 18%  interrupts.CPU94.PMI:Performance_monitoring_interrupts
      4004 ±  2%     +26.8%       5076 ±  3%  interrupts.CPU94.RES:Rescheduling_interrupts
     69230 ±  4%     +10.2%      76268 ±  5%  interrupts.CPU95.LOC:Local_timer_interrupts
      3113 ± 13%    +154.8%       7933 ± 19%  interrupts.CPU95.NMI:Non-maskable_interrupts
      3113 ± 13%    +154.8%       7933 ± 19%  interrupts.CPU95.PMI:Performance_monitoring_interrupts
     69187 ±  4%     +10.4%      76350 ±  5%  interrupts.CPU96.LOC:Local_timer_interrupts
      2935 ± 11%    +172.5%       7998 ± 19%  interrupts.CPU96.NMI:Non-maskable_interrupts
      2935 ± 11%    +172.5%       7998 ± 19%  interrupts.CPU96.PMI:Performance_monitoring_interrupts
      3690 ±  3%     +55.7%       5746 ± 34%  interrupts.CPU96.RES:Rescheduling_interrupts
     69202 ±  4%     +10.4%      76412 ±  5%  interrupts.CPU97.LOC:Local_timer_interrupts
      2936 ± 12%    +171.5%       7973 ± 20%  interrupts.CPU97.NMI:Non-maskable_interrupts
      2936 ± 12%    +171.5%       7973 ± 20%  interrupts.CPU97.PMI:Performance_monitoring_interrupts
      3706 ±  3%     +42.0%       5261 ± 16%  interrupts.CPU97.RES:Rescheduling_interrupts
     69188 ±  4%     +10.3%      76311 ±  5%  interrupts.CPU98.LOC:Local_timer_interrupts
      3015 ± 13%    +166.5%       8036 ± 20%  interrupts.CPU98.NMI:Non-maskable_interrupts
      3015 ± 13%    +166.5%       8036 ± 20%  interrupts.CPU98.PMI:Performance_monitoring_interrupts
      3749 ±  2%     +29.5%       4855 ±  7%  interrupts.CPU98.RES:Rescheduling_interrupts
     69189 ±  4%     +10.4%      76359 ±  5%  interrupts.CPU99.LOC:Local_timer_interrupts
      2997 ± 12%    +164.2%       7917 ± 19%  interrupts.CPU99.NMI:Non-maskable_interrupts
      2997 ± 12%    +164.2%       7917 ± 19%  interrupts.CPU99.PMI:Performance_monitoring_interrupts
      3768 ±  2%     +30.6%       4922 ± 15%  interrupts.CPU99.RES:Rescheduling_interrupts
     28.67 ± 25%   +1177.3%     366.17 ±  5%  interrupts.IWI:IRQ_work_interrupts
   8876658 ±  4%     +10.2%    9785657 ±  5%  interrupts.LOC:Local_timer_interrupts
    365958 ±  2%    +194.6%    1077929 ±  6%  interrupts.NMI:Non-maskable_interrupts
    365958 ±  2%    +194.6%    1077929 ±  6%  interrupts.PMI:Performance_monitoring_interrupts
    503767           +29.9%     654211        interrupts.RES:Rescheduling_interrupts
     45.34           -14.5       30.83        perf-profile.calltrace.cycles-pp.write
     42.83           -12.5       30.29        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.write
     42.41           -12.2       30.16        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
     41.60           -11.7       29.90        perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
     40.59           -11.0       29.60        perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
     38.14            -9.3       28.82        perf-profile.calltrace.cycles-pp.new_sync_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37.09            -8.6       28.48        perf-profile.calltrace.cycles-pp.xfs_file_buffered_write.new_sync_write.vfs_write.ksys_write.do_syscall_64
      5.36 ±  2%      -5.4        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter
     32.10            -5.2       26.88        perf-profile.calltrace.cycles-pp.iomap_file_buffered_write.xfs_file_buffered_write.new_sync_write.vfs_write.ksys_write
     31.80            -5.0       26.79        perf-profile.calltrace.cycles-pp.iomap_apply.iomap_file_buffered_write.xfs_file_buffered_write.new_sync_write.vfs_write
      6.23            -4.1        2.13 ±  2%  perf-profile.calltrace.cycles-pp.copy_page_to_iter.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.new_sync_read
      5.31            -3.9        1.37 ±  2%  perf-profile.calltrace.cycles-pp.llseek
      4.68 ±  2%      -3.9        0.77 ±  7%  perf-profile.calltrace.cycles-pp.secondary_startup_64_no_verify
      4.64 ±  2%      -3.9        0.76 ±  7%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
      4.64 ±  2%      -3.9        0.76 ±  7%  perf-profile.calltrace.cycles-pp.start_secondary.secondary_startup_64_no_verify
      4.64 ±  2%      -3.9        0.76 ±  7%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
      6.16            -3.9        2.31 ±  2%  perf-profile.calltrace.cycles-pp.iomap_write_end.iomap_write_actor.iomap_apply.iomap_file_buffered_write.xfs_file_buffered_write
      4.18 ±  2%      -3.5        0.66 ±  8%  perf-profile.calltrace.cycles-pp.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary.secondary_startup_64_no_verify
      4.17 ±  2%      -3.5        0.65 ±  7%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry.start_secondary
      4.04 ±  2%      -3.4        0.63 ±  8%  perf-profile.calltrace.cycles-pp.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.do_idle.cpu_startup_entry
      4.98            -3.3        1.72 ±  2%  perf-profile.calltrace.cycles-pp.copyout.copy_page_to_iter.filemap_read.xfs_file_buffered_read.xfs_file_read_iter
      4.79            -3.1        1.66 ±  2%  perf-profile.calltrace.cycles-pp.copy_user_enhanced_fast_string.copyout.copy_page_to_iter.filemap_read.xfs_file_buffered_read
      4.00            -2.8        1.23 ±  3%  perf-profile.calltrace.cycles-pp.xfs_buffered_write_iomap_begin.iomap_apply.iomap_file_buffered_write.xfs_file_buffered_write.new_sync_write
      3.83            -2.6        1.24 ±  2%  perf-profile.calltrace.cycles-pp.filemap_get_pages.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.new_sync_read
      3.38            -2.4        0.97 ±  2%  perf-profile.calltrace.cycles-pp.iomap_set_range_uptodate.iomap_write_begin.iomap_write_actor.iomap_apply.iomap_file_buffered_write
      3.38            -2.3        1.09 ±  2%  perf-profile.calltrace.cycles-pp.filemap_get_read_batch.filemap_get_pages.filemap_read.xfs_file_buffered_read.xfs_file_read_iter
      3.24 ±  2%      -2.1        1.14 ±  3%  perf-profile.calltrace.cycles-pp.unlink
      3.20 ±  2%      -2.1        1.13 ±  3%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.unlink
      3.20 ±  2%      -2.1        1.13 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.unlink
      3.18 ±  2%      -2.1        1.12 ±  3%  perf-profile.calltrace.cycles-pp.do_unlinkat.do_syscall_64.entry_SYSCALL_64_after_hwframe.unlink
      2.96            -1.9        1.07 ±  2%  perf-profile.calltrace.cycles-pp.creat64
      2.94            -1.9        1.06 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.creat64
      2.94            -1.9        1.06 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.creat64
      2.92            -1.9        1.06 ±  2%  perf-profile.calltrace.cycles-pp.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe.creat64
      2.92            -1.9        1.06 ±  2%  perf-profile.calltrace.cycles-pp.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe.creat64
      2.88            -1.8        1.04 ±  2%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.88            -1.8        1.04 ±  2%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.do_sys_open.do_syscall_64
      2.73            -1.8        0.91 ±  2%  perf-profile.calltrace.cycles-pp.xfs_file_write_checks.xfs_file_buffered_write.new_sync_write.vfs_write.ksys_write
      2.67            -1.8        0.85 ±  2%  perf-profile.calltrace.cycles-pp.iomap_set_range_uptodate.iomap_write_end.iomap_write_actor.iomap_apply.iomap_file_buffered_write
      2.40            -1.7        0.70 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.llseek
      2.26            -1.5        0.74 ±  3%  perf-profile.calltrace.cycles-pp.copy_page_from_iter_atomic.iomap_write_actor.iomap_apply.iomap_file_buffered_write.xfs_file_buffered_write
      2.08            -1.5        0.60 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.llseek
      1.93            -1.4        0.56 ±  3%  perf-profile.calltrace.cycles-pp.touch_atime.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.new_sync_read
      2.11 ±  2%      -1.4        0.75 ±  4%  perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.do_unlinkat.do_syscall_64.entry_SYSCALL_64_after_hwframe.unlink
      2.48            -1.4        1.13 ±  3%  perf-profile.calltrace.cycles-pp.__set_page_dirty_nobuffers.iomap_write_end.iomap_write_actor.iomap_apply.iomap_file_buffered_write
      2.20 ±  2%      -1.2        1.02 ±  2%  perf-profile.calltrace.cycles-pp.workingset_activation.mark_page_accessed.filemap_read.xfs_file_buffered_read.xfs_file_read_iter
      1.61            -1.2        0.43 ± 44%  perf-profile.calltrace.cycles-pp.copyin.copy_page_from_iter_atomic.iomap_write_actor.iomap_apply.iomap_file_buffered_write
      2.37            -1.1        1.27 ±  2%  perf-profile.calltrace.cycles-pp.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.iomap_write_begin
      1.74 ±  3%      -1.0        0.79 ±  3%  perf-profile.calltrace.cycles-pp.workingset_age_nonresident.workingset_activation.mark_page_accessed.filemap_read.xfs_file_buffered_read
      1.22            -1.0        0.26 ±100%  perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.path_openat.do_filp_open.do_sys_openat2.do_sys_open
     25.71            -0.9       24.86        perf-profile.calltrace.cycles-pp.iomap_write_actor.iomap_apply.iomap_file_buffered_write.xfs_file_buffered_write.new_sync_write
      1.40            -0.7        0.73 ±  2%  perf-profile.calltrace.cycles-pp.__set_page_dirty.__set_page_dirty_nobuffers.iomap_write_end.iomap_write_actor.iomap_apply
      1.07            -0.5        0.54 ±  2%  perf-profile.calltrace.cycles-pp.truncate_cleanup_page.truncate_inode_pages_range.evict.__dentry_kill.dput
      1.05            -0.4        0.64 ±  3%  perf-profile.calltrace.cycles-pp.__activate_page.pagevec_lru_move_fn.mark_page_accessed.filemap_read.xfs_file_buffered_read
      0.72            -0.3        0.44 ± 44%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.__add_to_page_cache_locked.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin
      0.00            +0.7        0.70 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_add_drain_cpu.lru_add_drain
      0.00            +0.7        0.70 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_add_drain_cpu
      0.00            +0.7        0.70 ±  2%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_add_drain_cpu.lru_add_drain.__pagevec_release
      0.00            +0.7        0.71        perf-profile.calltrace.cycles-pp.__pagevec_lru_add.lru_add_drain_cpu.lru_add_drain.__pagevec_release.truncate_inode_pages_range
      0.00            +0.8        0.78 ±  7%  perf-profile.calltrace.cycles-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work
      0.00            +1.1        1.10 ±  7%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread
      0.00            +1.1        1.10 ±  7%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread
      0.00            +1.1        1.11 ±  7%  perf-profile.calltrace.cycles-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +1.1        1.12 ±  7%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +1.1        1.13 ±  7%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
      0.00            +1.1        1.14 ±  7%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      0.00            +1.1        1.15 ±  7%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00            +1.3        1.34        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.lru_add_drain_cpu.lru_add_drain
      0.00            +1.3        1.34        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.lru_add_drain_cpu
      0.00            +1.3        1.34        perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.pagevec_lru_move_fn.lru_add_drain_cpu.lru_add_drain.__pagevec_release
      0.00            +1.4        1.38        perf-profile.calltrace.cycles-pp.pagevec_lru_move_fn.lru_add_drain_cpu.lru_add_drain.__pagevec_release.truncate_inode_pages_range
      0.00            +2.1        2.09        perf-profile.calltrace.cycles-pp.lru_add_drain.__pagevec_release.truncate_inode_pages_range.evict.__dentry_kill
      0.00            +2.1        2.09        perf-profile.calltrace.cycles-pp.lru_add_drain_cpu.lru_add_drain.__pagevec_release.truncate_inode_pages_range.evict
     30.42            +2.5       32.89        perf-profile.calltrace.cycles-pp.read
     27.36            +4.8       32.16        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.read
     27.06            +5.0       32.06        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.read
     26.39            +5.4       31.83        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.read
     25.57            +6.0       31.58        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe.read
     14.38            +6.5       20.88        perf-profile.calltrace.cycles-pp.iomap_write_begin.iomap_write_actor.iomap_apply.iomap_file_buffered_write.xfs_file_buffered_write
     23.46            +7.4       30.89        perf-profile.calltrace.cycles-pp.new_sync_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.93            +7.8       30.72        perf-profile.calltrace.cycles-pp.xfs_file_read_iter.new_sync_read.vfs_read.ksys_read.do_syscall_64
     22.50            +8.0       30.56        perf-profile.calltrace.cycles-pp.xfs_file_buffered_read.xfs_file_read_iter.new_sync_read.vfs_read.ksys_read
     20.39            +9.5       29.89        perf-profile.calltrace.cycles-pp.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.new_sync_read.vfs_read
      9.43            +9.8       19.26        perf-profile.calltrace.cycles-pp.grab_cache_page_write_begin.iomap_write_begin.iomap_write_actor.iomap_apply.iomap_file_buffered_write
      9.13           +10.0       19.16        perf-profile.calltrace.cycles-pp.pagecache_get_page.grab_cache_page_write_begin.iomap_write_begin.iomap_write_actor.iomap_apply
      4.78           +13.0       17.82        perf-profile.calltrace.cycles-pp.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.iomap_write_begin.iomap_write_actor
      2.28           +14.2       16.51        perf-profile.calltrace.cycles-pp.lru_cache_add.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin.iomap_write_begin
      2.09 ±  2%     +14.3       16.44        perf-profile.calltrace.cycles-pp.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page.grab_cache_page_write_begin
      1.04 ±  3%     +14.8       15.85        perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru.pagecache_get_page
      1.03 ±  3%     +14.8       15.84        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.add_to_page_cache_lru
      0.97 ±  3%     +14.9       15.82        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add
      6.04           +19.2       25.24        perf-profile.calltrace.cycles-pp.mark_page_accessed.filemap_read.xfs_file_buffered_read.xfs_file_read_iter.new_sync_read
      2.78           +21.1       23.88        perf-profile.calltrace.cycles-pp.pagevec_lru_move_fn.mark_page_accessed.filemap_read.xfs_file_buffered_read.xfs_file_read_iter
      1.15 ±  4%     +21.7       22.88        perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.pagevec_lru_move_fn.mark_page_accessed.filemap_read.xfs_file_buffered_read
      1.12 ±  4%     +21.7       22.86        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.mark_page_accessed.filemap_read
      1.08 ±  4%     +21.8       22.84        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.pagevec_lru_move_fn.mark_page_accessed
      7.41           +22.5       29.90        perf-profile.calltrace.cycles-pp.__close
      7.38           +22.5       29.89        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__close
      7.38           +22.5       29.89        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__close
      7.35           +22.5       29.88        perf-profile.calltrace.cycles-pp.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.__close
      7.35           +22.5       29.88        perf-profile.calltrace.cycles-pp.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.__close
      7.34           +22.5       29.88        perf-profile.calltrace.cycles-pp.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.33           +22.5       29.88        perf-profile.calltrace.cycles-pp.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64
      7.14           +22.7       29.82        perf-profile.calltrace.cycles-pp.dput.__fput.task_work_run.exit_to_user_mode_prepare.syscall_exit_to_user_mode
      7.10           +22.7       29.81        perf-profile.calltrace.cycles-pp.__dentry_kill.dput.__fput.task_work_run.exit_to_user_mode_prepare
      3.04 ±  2%     +23.1       26.12        perf-profile.calltrace.cycles-pp.release_pages.__pagevec_release.truncate_inode_pages_range.evict.__dentry_kill
      5.99           +23.4       29.41        perf-profile.calltrace.cycles-pp.evict.__dentry_kill.dput.__fput.task_work_run
      5.95           +23.4       29.39        perf-profile.calltrace.cycles-pp.truncate_inode_pages_range.evict.__dentry_kill.dput.__fput
      1.27 ±  4%     +23.8       25.08        perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.release_pages.__pagevec_release.truncate_inode_pages_range.evict
      1.26 ±  4%     +23.8       25.06        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.release_pages.__pagevec_release.truncate_inode_pages_range
      1.20 ±  4%     +23.8       25.04        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.release_pages.__pagevec_release
      3.27 ±  2%     +25.0       28.23        perf-profile.calltrace.cycles-pp.__pagevec_release.truncate_inode_pages_range.evict.__dentry_kill.dput
     45.40           -14.3       31.08        perf-profile.children.cycles-pp.write
     41.68           -11.7       29.96        perf-profile.children.cycles-pp.ksys_write
     40.78           -11.1       29.69        perf-profile.children.cycles-pp.vfs_write
     38.23            -9.4       28.88        perf-profile.children.cycles-pp.new_sync_write
     37.19            -8.7       28.52        perf-profile.children.cycles-pp.xfs_file_buffered_write
     32.14            -5.2       26.90        perf-profile.children.cycles-pp.iomap_file_buffered_write
     31.88            -5.1       26.82        perf-profile.children.cycles-pp.iomap_apply
      6.50            -4.3        2.21 ±  2%  perf-profile.children.cycles-pp.copy_user_enhanced_fast_string
      6.08            -4.2        1.83 ±  2%  perf-profile.children.cycles-pp.iomap_set_range_uptodate
      6.37            -4.2        2.18 ±  2%  perf-profile.children.cycles-pp.copy_page_to_iter
      6.26            -3.9        2.34 ±  2%  perf-profile.children.cycles-pp.iomap_write_end
      4.68 ±  2%      -3.9        0.77 ±  7%  perf-profile.children.cycles-pp.secondary_startup_64_no_verify
      4.68 ±  2%      -3.9        0.77 ±  7%  perf-profile.children.cycles-pp.cpu_startup_entry
      4.68 ±  2%      -3.9        0.77 ±  7%  perf-profile.children.cycles-pp.do_idle
      4.64 ±  2%      -3.9        0.76 ±  7%  perf-profile.children.cycles-pp.start_secondary
      5.34            -3.7        1.62 ±  2%  perf-profile.children.cycles-pp.llseek
      4.21 ±  2%      -3.6        0.66 ±  8%  perf-profile.children.cycles-pp.cpuidle_enter
      4.20 ±  2%      -3.5        0.66 ±  7%  perf-profile.children.cycles-pp.cpuidle_enter_state
      4.08 ±  2%      -3.4        0.63 ±  7%  perf-profile.children.cycles-pp.acpi_idle_enter
      4.05 ±  2%      -3.4        0.63 ±  8%  perf-profile.children.cycles-pp.acpi_idle_do_entry
      5.02            -3.3        1.73 ±  2%  perf-profile.children.cycles-pp.copyout
      4.06 ±  2%      -3.2        0.90 ±  5%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      4.21            -2.9        1.30 ±  3%  perf-profile.children.cycles-pp.xfs_buffered_write_iomap_begin
      3.87            -2.6        1.25 ±  2%  perf-profile.children.cycles-pp.filemap_get_pages
      3.47            -2.4        1.12 ±  2%  perf-profile.children.cycles-pp.filemap_get_read_batch
      3.16            -2.2        0.96 ±  2%  perf-profile.children.cycles-pp.xfs_ilock
      3.14            -2.2        0.99 ±  2%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      3.25 ±  2%      -2.1        1.14 ±  3%  perf-profile.children.cycles-pp.unlink
      3.04            -2.1        0.96        perf-profile.children.cycles-pp.__entry_text_start
      3.34            -2.1        1.26 ±  3%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      3.18 ±  2%      -2.1        1.12 ±  3%  perf-profile.children.cycles-pp.do_unlinkat
      3.04            -1.9        1.10 ±  2%  perf-profile.children.cycles-pp.do_sys_open
      3.04            -1.9        1.10 ±  2%  perf-profile.children.cycles-pp.do_sys_openat2
      2.98            -1.9        1.07 ±  2%  perf-profile.children.cycles-pp.creat64
      2.97            -1.9        1.07 ±  2%  perf-profile.children.cycles-pp.do_filp_open
      2.97            -1.9        1.07 ±  2%  perf-profile.children.cycles-pp.path_openat
      2.83            -1.9        0.94        perf-profile.children.cycles-pp.xfs_file_write_checks
      2.30            -1.6        0.75 ±  3%  perf-profile.children.cycles-pp.copy_page_from_iter_atomic
      2.15 ±  2%      -1.5        0.64 ±  3%  perf-profile.children.cycles-pp.rwsem_spin_on_owner
      2.02            -1.4        0.61 ±  2%  perf-profile.children.cycles-pp.xfs_iunlock
      1.99            -1.4        0.58 ±  3%  perf-profile.children.cycles-pp.touch_atime
      1.98 ±  5%      -1.4        0.58 ±  3%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      2.56            -1.4        1.15 ±  3%  perf-profile.children.cycles-pp.__set_page_dirty_nobuffers
      1.89            -1.4        0.52 ±  2%  perf-profile.children.cycles-pp.__fdget_pos
      1.84            -1.3        0.54 ±  3%  perf-profile.children.cycles-pp.down_write
      1.79            -1.2        0.56 ±  3%  perf-profile.children.cycles-pp.security_file_permission
      2.21 ±  2%      -1.2        1.02 ±  2%  perf-profile.children.cycles-pp.workingset_activation
      1.58            -1.2        0.42 ±  2%  perf-profile.children.cycles-pp.__fget_light
      2.43            -1.1        1.29 ±  2%  perf-profile.children.cycles-pp.__add_to_page_cache_locked
      1.65            -1.1        0.53 ±  2%  perf-profile.children.cycles-pp.copyin
      1.60            -1.1        0.50 ±  2%  perf-profile.children.cycles-pp.___might_sleep
      1.58            -1.1        0.49 ±  2%  perf-profile.children.cycles-pp.xas_load
      1.58            -1.1        0.49 ±  4%  perf-profile.children.cycles-pp.__xfs_trans_commit
      1.55            -1.1        0.48 ±  4%  perf-profile.children.cycles-pp.xlog_cil_commit
      1.41            -1.0        0.39 ±  3%  perf-profile.children.cycles-pp.disk_rr
      1.47            -1.0        0.49 ±  2%  perf-profile.children.cycles-pp.__alloc_pages
     25.90            -1.0       24.93        perf-profile.children.cycles-pp.iomap_write_actor
      1.34            -1.0        0.37        perf-profile.children.cycles-pp.ksys_lseek
      1.75 ±  3%      -1.0        0.79 ±  2%  perf-profile.children.cycles-pp.workingset_age_nonresident
      1.38            -0.9        0.44 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
      1.30 ±  2%      -0.9        0.41 ±  3%  perf-profile.children.cycles-pp.common_file_perm
      1.19            -0.8        0.38 ±  3%  perf-profile.children.cycles-pp.xfs_generic_create
      1.17            -0.8        0.36 ±  2%  perf-profile.children.cycles-pp.__might_sleep
      1.18            -0.8        0.38 ±  3%  perf-profile.children.cycles-pp.iov_iter_fault_in_readable
      1.16 ±  2%      -0.8        0.37 ±  3%  perf-profile.children.cycles-pp.xfs_create
      1.21            -0.8        0.43 ±  2%  perf-profile.children.cycles-pp.file_update_time
      1.16            -0.8        0.40 ±  3%  perf-profile.children.cycles-pp.get_page_from_freelist
      1.07            -0.7        0.33 ±  2%  perf-profile.children.cycles-pp.xfs_ilock_iocb
      1.02 ±  2%      -0.7        0.29 ±  4%  perf-profile.children.cycles-pp.xfs_vn_update_time
      1.09 ±  6%      -0.7        0.39 ±  4%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      1.45            -0.7        0.75 ±  2%  perf-profile.children.cycles-pp.__set_page_dirty
      1.05            -0.7        0.35        perf-profile.children.cycles-pp.__fsnotify_parent
      1.08            -0.7        0.39 ±  3%  perf-profile.children.cycles-pp.destroy_inode
      0.98            -0.7        0.30 ±  6%  perf-profile.children.cycles-pp.xlog_cil_insert_items
      0.99            -0.7        0.32 ±  3%  perf-profile.children.cycles-pp.__cond_resched
      1.04            -0.7        0.38 ±  3%  perf-profile.children.cycles-pp.xfs_fs_destroy_inode
      1.03 ±  7%      -0.7        0.37 ±  5%  perf-profile.children.cycles-pp.hrtimer_interrupt
      1.04            -0.7        0.38 ±  3%  perf-profile.children.cycles-pp.xfs_inactive
      0.91 ±  2%      -0.6        0.26 ±  2%  perf-profile.children.cycles-pp.up_write
      0.89            -0.6        0.28 ±  3%  perf-profile.children.cycles-pp.__get_user_nocheck_1
      1.02            -0.6        0.42 ±  4%  perf-profile.children.cycles-pp.delete_from_page_cache_batch
      0.88            -0.6        0.27        perf-profile.children.cycles-pp.down_read
      0.89 ±  2%      -0.6        0.31 ±  3%  perf-profile.children.cycles-pp.vfs_unlink
      0.87 ±  3%      -0.6        0.30 ±  2%  perf-profile.children.cycles-pp.xfs_vn_unlink
      0.86 ±  3%      -0.6        0.30 ±  2%  perf-profile.children.cycles-pp.xfs_remove
      0.87            -0.6        0.32 ±  3%  perf-profile.children.cycles-pp.xfs_inactive_ifree
      0.80            -0.6        0.24 ±  3%  perf-profile.children.cycles-pp.xfs_break_layouts
      0.78 ±  2%      -0.6        0.24 ±  2%  perf-profile.children.cycles-pp.syscall_enter_from_user_mode
      1.09            -0.5        0.55 ±  2%  perf-profile.children.cycles-pp.truncate_cleanup_page
      0.80 ±  2%      -0.5        0.28 ±  4%  perf-profile.children.cycles-pp.current_time
      0.76            -0.5        0.26 ±  3%  perf-profile.children.cycles-pp.xas_store
      0.71 ±  2%      -0.5        0.22 ±  5%  perf-profile.children.cycles-pp.balance_dirty_pages_ratelimited
      0.82            -0.5        0.34 ±  2%  perf-profile.children.cycles-pp.__list_del_entry_valid
      0.78 ±  3%      -0.5        0.31 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock
      0.61            -0.5        0.14 ±  2%  perf-profile.children.cycles-pp.irq_exit_rcu
      1.14            -0.5        0.68 ±  2%  perf-profile.children.cycles-pp.__activate_page
      0.70 ±  2%      -0.5        0.25 ±  2%  perf-profile.children.cycles-pp.__mod_lruvec_state
      0.96 ±  5%      -0.4        0.52 ±  9%  perf-profile.children.cycles-pp.osq_lock
      0.66 ±  2%      -0.4        0.22 ±  5%  perf-profile.children.cycles-pp.xfs_check_agi_freecount
      0.90            -0.4        0.47 ±  2%  perf-profile.children.cycles-pp.__cancel_dirty_page
      0.66            -0.4        0.23 ±  4%  perf-profile.children.cycles-pp.rmqueue
      0.55            -0.4        0.13 ±  4%  perf-profile.children.cycles-pp.__softirqentry_text_start
      0.66            -0.4        0.24 ±  3%  perf-profile.children.cycles-pp.xfs_ifree
      0.61            -0.4        0.20 ±  4%  perf-profile.children.cycles-pp.aa_file_perm
      0.61            -0.4        0.22        perf-profile.children.cycles-pp.xfs_trans_read_buf_map
      0.54 ±  3%      -0.4        0.16 ±  4%  perf-profile.children.cycles-pp.unlock_page
      0.64 ±  2%      -0.4        0.28 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.52 ±  2%      -0.4        0.16 ±  2%  perf-profile.children.cycles-pp.map_id_range_down
      0.52            -0.4        0.16 ±  4%  perf-profile.children.cycles-pp.xas_start
      0.50 ±  2%      -0.4        0.14 ±  3%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.55 ±  2%      -0.4        0.20 ±  7%  perf-profile.children.cycles-pp.__mem_cgroup_uncharge_list
      0.39 ± 21%      -0.3        0.06 ± 11%  perf-profile.children.cycles-pp.ktime_get
      0.49 ±  2%      -0.3        0.16 ±  6%  perf-profile.children.cycles-pp.rcu_all_qs
      0.50            -0.3        0.17 ±  5%  perf-profile.children.cycles-pp.xfs_dialloc
      0.47            -0.3        0.15 ±  4%  perf-profile.children.cycles-pp.xfs_iext_lookup_extent
      0.50 ±  2%      -0.3        0.18 ±  2%  perf-profile.children.cycles-pp.__mod_node_page_state
      0.45 ±  2%      -0.3        0.14 ±  3%  perf-profile.children.cycles-pp.up_read
      0.58 ±  2%      -0.3        0.27 ±  2%  perf-profile.children.cycles-pp.free_unref_page_list
      0.45            -0.3        0.15 ±  2%  perf-profile.children.cycles-pp.rcu_read_unlock_strict
      0.43 ±  2%      -0.3        0.13 ±  3%  perf-profile.children.cycles-pp.xfs_break_leased_layouts
      0.44 ±  2%      -0.3        0.15 ±  4%  perf-profile.children.cycles-pp.xfs_difree
      0.41 ±  3%      -0.3        0.11 ±  4%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.43 ±  4%      -0.3        0.14 ±  6%  perf-profile.children.cycles-pp.xfs_file_write_iter
      0.43 ±  3%      -0.3        0.14        perf-profile.children.cycles-pp.xfs_buffered_write_iomap_end
      0.42 ±  3%      -0.3        0.13 ±  3%  perf-profile.children.cycles-pp.xfs_dir_removename
      0.43 ±  3%      -0.3        0.14 ±  2%  perf-profile.children.cycles-pp.uncharge_batch
      0.42            -0.3        0.13 ±  2%  perf-profile.children.cycles-pp.xfs_errortag_test
      0.43            -0.3        0.15 ±  3%  perf-profile.children.cycles-pp.find_lock_entries
      0.46 ±  4%      -0.3        0.18 ±  4%  perf-profile.children.cycles-pp.tick_sched_timer
      0.40 ±  3%      -0.3        0.12 ±  3%  perf-profile.children.cycles-pp.xfs_dir2_node_removename
      0.39 ±  2%      -0.3        0.12 ±  4%  perf-profile.children.cycles-pp.xfs_da3_node_lookup_int
      0.39 ±  2%      -0.3        0.12 ±  3%  perf-profile.children.cycles-pp.generic_write_checks
      0.65            -0.3        0.39 ±  2%  perf-profile.children.cycles-pp.account_page_cleaned
      1.50            -0.3        1.24 ±  2%  perf-profile.children.cycles-pp.__mod_lruvec_page_state
      0.42            -0.3        0.16 ±  2%  perf-profile.children.cycles-pp.xfs_buf_read_map
      0.37 ±  3%      -0.3        0.12 ±  4%  perf-profile.children.cycles-pp.xfs_trans_alloc
      0.42 ±  2%      -0.2        0.17 ±  4%  perf-profile.children.cycles-pp.tick_sched_handle
      0.34 ±  2%      -0.2        0.10 ±  4%  perf-profile.children.cycles-pp.try_charge_memcg
      0.34 ±  4%      -0.2        0.10 ±  3%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.40            -0.2        0.16 ±  3%  perf-profile.children.cycles-pp.xfs_buf_get_map
      0.35 ±  3%      -0.2        0.11 ±  6%  perf-profile.children.cycles-pp.xfs_difree_inobt
      0.35 ±  5%      -0.2        0.12 ±  8%  perf-profile.children.cycles-pp.xfs_inobt_get_rec
      0.40 ±  3%      -0.2        0.17 ±  3%  perf-profile.children.cycles-pp.update_process_times
      0.33 ±  3%      -0.2        0.10 ±  7%  perf-profile.children.cycles-pp.xfs_trans_reserve
      0.76            -0.2        0.53 ±  3%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.32 ±  3%      -0.2        0.09 ±  5%  perf-profile.children.cycles-pp.xfs_log_reserve
      0.32 ±  3%      -0.2        0.10 ±  3%  perf-profile.children.cycles-pp.make_kgid
      0.54            -0.2        0.32        perf-profile.children.cycles-pp.memset_erms
      0.33            -0.2        0.11 ±  3%  perf-profile.children.cycles-pp.node_dirty_ok
      0.28 ± 17%      -0.2        0.06 ± 13%  perf-profile.children.cycles-pp.clockevents_program_event
      0.37            -0.2        0.15        perf-profile.children.cycles-pp.xfs_buf_find
      0.30 ±  2%      -0.2        0.08 ±  8%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.31 ±  3%      -0.2        0.10        perf-profile.children.cycles-pp.make_kuid
      0.29            -0.2        0.08 ±  6%  perf-profile.children.cycles-pp.rcu_core
      0.31 ±  2%      -0.2        0.10 ±  3%  perf-profile.children.cycles-pp.__might_fault
      0.30 ±  4%      -0.2        0.09 ±  4%  perf-profile.children.cycles-pp.page_counter_cancel
      0.29 ±  3%      -0.2        0.08 ±  5%  perf-profile.children.cycles-pp.xfs_da_read_buf
      0.31 ±  5%      -0.2        0.10 ±  3%  perf-profile.children.cycles-pp.timestamp_truncate
      0.30 ±  4%      -0.2        0.09 ±  5%  perf-profile.children.cycles-pp.rw_verify_area
      0.30 ±  2%      -0.2        0.10 ±  4%  perf-profile.children.cycles-pp.xfs_bmbt_to_iomap
      0.29 ±  3%      -0.2        0.09 ±  5%  perf-profile.children.cycles-pp.xfs_iread_extents
      0.27 ±  4%      -0.2        0.07 ±  6%  perf-profile.children.cycles-pp.xfs_file_llseek
      0.27            -0.2        0.08 ±  5%  perf-profile.children.cycles-pp.page_mapping
      0.26 ±  3%      -0.2        0.08 ±  5%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode_prepare
      0.24 ± 12%      -0.2        0.07 ± 10%  perf-profile.children.cycles-pp.alloc_pages
      0.22 ±  3%      -0.2        0.06        perf-profile.children.cycles-pp.write@plt
      0.34 ±  2%      -0.2        0.18 ±  2%  perf-profile.children.cycles-pp.__schedule
      0.22 ±  2%      -0.2        0.07 ±  5%  perf-profile.children.cycles-pp.xfs_dir_createname
      0.22 ±  2%      -0.2        0.07        perf-profile.children.cycles-pp.iomap_page_create
      0.22 ±  3%      -0.2        0.07        perf-profile.children.cycles-pp.iov_iter_init
      0.21 ±  2%      -0.2        0.06 ±  6%  perf-profile.children.cycles-pp.xfs_dir2_node_addname
      0.22 ±  2%      -0.2        0.07 ±  6%  perf-profile.children.cycles-pp.__list_add_valid
      0.20 ±  3%      -0.1        0.06 ±  9%  perf-profile.children.cycles-pp.page_counter_try_charge
      0.26            -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.xfs_read_agi
      0.27 ±  3%      -0.1        0.13 ±  5%  perf-profile.children.cycles-pp.scheduler_tick
      0.21            -0.1        0.07 ±  6%  perf-profile.children.cycles-pp.__xa_set_mark
      0.22 ±  5%      -0.1        0.08 ±  7%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64
      0.21 ±  3%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.rcu_do_batch
      0.19 ±  5%      -0.1        0.05 ±  8%  perf-profile.children.cycles-pp.xfs_da3_node_read
      0.16 ±  4%      -0.1        0.02 ± 99%  perf-profile.children.cycles-pp.xfs_dir_lookup
      0.18 ±  6%      -0.1        0.05 ±  7%  perf-profile.children.cycles-pp.xa_get_order
      0.32 ±  2%      -0.1        0.19 ±  5%  perf-profile.children.cycles-pp.unaccount_page_cache_page
      0.19 ±  5%      -0.1        0.06        perf-profile.children.cycles-pp.xfs_bmapi_reserve_delalloc
      0.18 ±  3%      -0.1        0.06 ±  9%  perf-profile.children.cycles-pp.xfs_btree_lookup
      0.19 ±  5%      -0.1        0.06        perf-profile.children.cycles-pp.xfs_dir3_data_check
      0.16 ±  5%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.xfs_lookup
      0.18 ±  4%      -0.1        0.06        perf-profile.children.cycles-pp.__xfs_dir3_data_check
      0.19 ±  4%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.xfs_btree_check_sblock
      0.20 ±  3%      -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.xfs_buf_item_format
      0.16 ±  4%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.xfs_release
      0.28 ±  5%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.19 ±  3%      -0.1        0.07        perf-profile.children.cycles-pp.asm_sysvec_reschedule_ipi
      0.17 ±  4%      -0.1        0.05        perf-profile.children.cycles-pp.xfs_vn_lookup
      0.17 ±  2%      -0.1        0.05 ±  8%  perf-profile.children.cycles-pp.generic_write_check_limits
      0.20 ±  2%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.xfs_buf_item_format_segment
      0.15 ±  3%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.wait_for_stable_page
      0.18 ±  4%      -0.1        0.06 ±  9%  perf-profile.children.cycles-pp.xfs_btree_increment
      0.18 ±  2%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.xfs_btree_get_rec
      0.17 ±  2%      -0.1        0.05 ±  8%  perf-profile.children.cycles-pp.xfs_dir2_leafn_lookup_for_entry
      0.20 ±  2%      -0.1        0.09 ±  5%  perf-profile.children.cycles-pp.xfs_iunlink_remove
      0.14 ±  3%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.generic_file_llseek_size
      0.18 ±  4%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.kmem_cache_free
      0.24 ±  5%      -0.1        0.13 ±  9%  perf-profile.children.cycles-pp.lock_page_memcg
      0.16 ±  3%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.xfs_inactive_truncate
      0.18 ±  4%      -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.kmem_cache_alloc
      0.14 ±  4%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.xfs_dir2_leafn_remove
      0.16 ±  3%      -0.1        0.05 ±  7%  perf-profile.children.cycles-pp.xas_init_marks
      0.17 ±  3%      -0.1        0.07 ±  7%  perf-profile.children.cycles-pp.file_modified
      0.20 ±  3%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.mem_cgroup_update_lru_size
      0.14 ±  5%      -0.1        0.03 ± 70%  perf-profile.children.cycles-pp.__mod_zone_page_state
      0.16 ±  6%      -0.1        0.06 ±  8%  perf-profile.children.cycles-pp.memcpy_erms
      0.18 ±  5%      -0.1        0.09 ±  5%  perf-profile.children.cycles-pp.try_to_wake_up
      0.14 ± 16%      -0.1        0.05 ± 45%  perf-profile.children.cycles-pp.xfs_inode_item_format
      0.16 ±  6%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.rwsem_wake
      0.16 ±  5%      -0.1        0.06 ± 11%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      0.14 ±  3%      -0.1        0.05        perf-profile.children.cycles-pp.generic_file_read_iter
      0.54            -0.1        0.45 ±  4%  perf-profile.children.cycles-pp.charge_memcg
      0.14 ±  7%      -0.1        0.05        perf-profile.children.cycles-pp.xfs_itruncate_extents_flags
      0.14 ±  2%      -0.1        0.05        perf-profile.children.cycles-pp.open64
      0.14 ±  5%      -0.1        0.05        perf-profile.children.cycles-pp.xas_create
      0.17 ±  2%      -0.1        0.08 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.13 ±  5%      -0.1        0.05 ±  7%  perf-profile.children.cycles-pp.file_remove_privs
      0.10 ±  4%      -0.1        0.03 ±100%  perf-profile.children.cycles-pp.uncharge_page
      0.22 ±  2%      -0.1        0.15 ±  3%  perf-profile.children.cycles-pp.schedule
      0.13 ±  5%      -0.1        0.06        perf-profile.children.cycles-pp.update_load_avg
      0.14 ±  4%      -0.1        0.07 ±  6%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.14 ±  7%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.task_tick_fair
      0.14 ±  3%      -0.1        0.08        perf-profile.children.cycles-pp.xfs_buf_lock
      0.11 ±  8%      -0.1        0.05 ±  8%  perf-profile.children.cycles-pp.wake_up_q
      0.13 ±  3%      -0.1        0.08        perf-profile.children.cycles-pp.down
      0.13 ±  4%      -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.__down
      0.12 ±  5%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.__free_one_page
      0.10 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.12 ±  4%      -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.schedule_timeout
      0.07 ±  9%      -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.generic_file_write_iter
      0.16 ±  2%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.08 ±  4%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp._find_next_bit
      0.02 ± 99%      +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.newidle_balance
      0.00            +0.1        0.11 ±  6%  perf-profile.children.cycles-pp.queue_work_on
      0.11 ±  6%      +0.2        0.34 ±  4%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.07 ±  5%      +0.2        0.30 ±  4%  perf-profile.children.cycles-pp.mem_cgroup_charge_statistics
      0.59            +0.6        1.15 ±  2%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.00            +0.8        0.79 ±  7%  perf-profile.children.cycles-pp.mem_cgroup_css_rstat_flush
      0.23 ±  2%      +0.9        1.08 ±  3%  perf-profile.children.cycles-pp.cgroup_rstat_updated
      0.00            +1.1        1.10 ±  7%  perf-profile.children.cycles-pp.cgroup_rstat_flush_locked
      0.00            +1.1        1.10 ±  7%  perf-profile.children.cycles-pp.cgroup_rstat_flush_irqsafe
      0.00            +1.1        1.11 ±  7%  perf-profile.children.cycles-pp.mem_cgroup_flush_stats
      0.01 ±223%      +1.1        1.12 ±  7%  perf-profile.children.cycles-pp.process_one_work
      0.03 ±105%      +1.1        1.14 ±  7%  perf-profile.children.cycles-pp.kthread
      0.03 ±105%      +1.1        1.15 ±  7%  perf-profile.children.cycles-pp.ret_from_fork
      0.01 ±223%      +1.1        1.13 ±  7%  perf-profile.children.cycles-pp.worker_thread
      0.19 ±  3%      +1.9        2.10        perf-profile.children.cycles-pp.lru_add_drain
      0.19 ±  3%      +1.9        2.10        perf-profile.children.cycles-pp.lru_add_drain_cpu
     30.44            +2.7       33.13        perf-profile.children.cycles-pp.read
     26.45            +5.4       31.84        perf-profile.children.cycles-pp.ksys_read
     25.65            +6.0       31.61        perf-profile.children.cycles-pp.vfs_read
     14.48            +6.4       20.92        perf-profile.children.cycles-pp.iomap_write_begin
     23.55            +7.4       30.92        perf-profile.children.cycles-pp.new_sync_read
     22.98            +7.8       30.73        perf-profile.children.cycles-pp.xfs_file_read_iter
     22.60            +8.0       30.59        perf-profile.children.cycles-pp.xfs_file_buffered_read
     86.48            +8.9       95.40        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     20.59            +9.4       29.96        perf-profile.children.cycles-pp.filemap_read
     85.68            +9.5       95.14        perf-profile.children.cycles-pp.do_syscall_64
      9.54            +9.8       19.29        perf-profile.children.cycles-pp.grab_cache_page_write_begin
      9.28            +9.9       19.21        perf-profile.children.cycles-pp.pagecache_get_page
      4.80           +13.0       17.83        perf-profile.children.cycles-pp.add_to_page_cache_lru
      2.30           +14.2       16.53        perf-profile.children.cycles-pp.lru_cache_add
      2.20 ±  2%     +15.0       17.18        perf-profile.children.cycles-pp.__pagevec_lru_add
      6.09           +19.2       25.25        perf-profile.children.cycles-pp.mark_page_accessed
      8.44           +21.8       30.26        perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      7.85           +22.2       30.06        perf-profile.children.cycles-pp.exit_to_user_mode_prepare
      2.90           +22.4       25.27        perf-profile.children.cycles-pp.pagevec_lru_move_fn
      7.41           +22.5       29.90        perf-profile.children.cycles-pp.__close
      7.34           +22.5       29.88        perf-profile.children.cycles-pp.task_work_run
      7.33           +22.5       29.88        perf-profile.children.cycles-pp.__fput
      7.17           +22.7       29.82        perf-profile.children.cycles-pp.dput
      7.10           +22.7       29.81        perf-profile.children.cycles-pp.__dentry_kill
      3.40 ±  2%     +22.8       26.25        perf-profile.children.cycles-pp.release_pages
      5.99           +23.4       29.41        perf-profile.children.cycles-pp.evict
      5.96           +23.4       29.40        perf-profile.children.cycles-pp.truncate_inode_pages_range
      3.27 ±  2%     +25.0       28.23        perf-profile.children.cycles-pp.__pagevec_release
      3.86 ±  4%     +62.2       66.03        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      3.90 ±  3%     +62.2       66.11        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      3.58 ±  4%     +62.3       65.86        perf-profile.children.cycles-pp.lock_page_lruvec_irqsave
      6.41            -4.2        2.19 ±  2%  perf-profile.self.cycles-pp.copy_user_enhanced_fast_string
      6.02            -4.2        1.81 ±  2%  perf-profile.self.cycles-pp.iomap_set_range_uptodate
      3.13            -2.1        0.98 ±  2%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      2.32            -2.0        0.36 ±  7%  perf-profile.self.cycles-pp.acpi_idle_do_entry
      2.73            -1.8        0.88 ±  2%  perf-profile.self.cycles-pp.filemap_get_read_batch
      2.20            -1.5        0.67 ±  3%  perf-profile.self.cycles-pp.filemap_read
      2.12 ±  2%      -1.5        0.63 ±  4%  perf-profile.self.cycles-pp.rwsem_spin_on_owner
      1.70            -1.2        0.49 ±  2%  perf-profile.self.cycles-pp.pagecache_get_page
      1.51            -1.1        0.40        perf-profile.self.cycles-pp.__fget_light
      1.73 ±  3%      -1.0        0.78 ±  2%  perf-profile.self.cycles-pp.workingset_age_nonresident
      1.39            -1.0        0.44 ±  2%  perf-profile.self.cycles-pp.___might_sleep
      1.28            -0.9        0.34 ±  3%  perf-profile.self.cycles-pp.disk_rr
      1.38            -0.9        0.46 ±  2%  perf-profile.self.cycles-pp.iomap_apply
      1.07            -0.7        0.33 ±  2%  perf-profile.self.cycles-pp.xas_load
      1.02            -0.7        0.32 ±  4%  perf-profile.self.cycles-pp.mark_page_accessed
      0.97            -0.7        0.30 ±  2%  perf-profile.self.cycles-pp.__might_sleep
      0.95            -0.6        0.30 ±  4%  perf-profile.self.cycles-pp.xfs_buffered_write_iomap_begin
      0.96            -0.6        0.32 ±  2%  perf-profile.self.cycles-pp.__fsnotify_parent
      0.93            -0.6        0.29 ±  2%  perf-profile.self.cycles-pp.write
      0.91            -0.6        0.27 ±  2%  perf-profile.self.cycles-pp.down_write
      0.91            -0.6        0.28 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.86 ±  2%      -0.6        0.25 ±  2%  perf-profile.self.cycles-pp.up_write
      0.87            -0.6        0.26 ±  2%  perf-profile.self.cycles-pp.llseek
      0.86            -0.6        0.27 ±  4%  perf-profile.self.cycles-pp.__get_user_nocheck_1
      0.86 ±  3%      -0.6        0.29 ±  3%  perf-profile.self.cycles-pp.vfs_write
      0.84 ±  2%      -0.6        0.27 ±  3%  perf-profile.self.cycles-pp.read
      0.81            -0.5        0.26 ±  4%  perf-profile.self.cycles-pp.iomap_write_begin
      0.75            -0.5        0.24 ±  2%  perf-profile.self.cycles-pp.__entry_text_start
      0.71 ±  2%      -0.5        0.22 ±  4%  perf-profile.self.cycles-pp.common_file_perm
      0.69 ±  2%      -0.5        0.21 ±  3%  perf-profile.self.cycles-pp.syscall_enter_from_user_mode
      0.72 ±  2%      -0.5        0.24 ±  2%  perf-profile.self.cycles-pp.copy_page_to_iter
      0.79            -0.5        0.33 ±  2%  perf-profile.self.cycles-pp.__list_del_entry_valid
      0.64 ±  3%      -0.4        0.20 ±  4%  perf-profile.self.cycles-pp.xfs_file_buffered_write
      0.95 ±  4%      -0.4        0.52 ±  9%  perf-profile.self.cycles-pp.osq_lock
      0.64 ±  2%      -0.4        0.20 ±  2%  perf-profile.self.cycles-pp.do_syscall_64
      0.64            -0.4        0.21 ±  2%  perf-profile.self.cycles-pp.xfs_iunlock
      0.65            -0.4        0.22 ±  3%  perf-profile.self.cycles-pp.copy_page_from_iter_atomic
      0.66            -0.4        0.22 ±  2%  perf-profile.self.cycles-pp.iomap_write_actor
      0.61            -0.4        0.20 ±  4%  perf-profile.self.cycles-pp.iomap_write_end
      0.59 ±  3%      -0.4        0.18 ±  5%  perf-profile.self.cycles-pp.balance_dirty_pages_ratelimited
      0.68            -0.4        0.31 ±  3%  perf-profile.self.cycles-pp.release_pages
      0.53            -0.4        0.16        perf-profile.self.cycles-pp.down_read
      0.53            -0.4        0.17 ±  3%  perf-profile.self.cycles-pp.xfs_ilock
      0.50 ±  2%      -0.4        0.15 ±  4%  perf-profile.self.cycles-pp.unlock_page
      0.76            -0.3        0.42 ±  2%  perf-profile.self.cycles-pp.__mod_lruvec_page_state
      0.50 ±  3%      -0.3        0.15 ±  4%  perf-profile.self.cycles-pp.__set_page_dirty_nobuffers
      0.50            -0.3        0.16 ±  4%  perf-profile.self.cycles-pp.aa_file_perm
      0.49 ±  2%      -0.3        0.16 ±  3%  perf-profile.self.cycles-pp.__cond_resched
      0.49            -0.3        0.16        perf-profile.self.cycles-pp.new_sync_write
      0.57            -0.3        0.25 ±  3%  perf-profile.self.cycles-pp.__activate_page
      0.48            -0.3        0.16 ±  4%  perf-profile.self.cycles-pp.new_sync_read
      0.46 ±  2%      -0.3        0.14 ±  3%  perf-profile.self.cycles-pp.map_id_range_down
      0.46 ±  2%      -0.3        0.14 ±  5%  perf-profile.self.cycles-pp.xas_start
      0.54 ±  2%      -0.3        0.22 ±  4%  perf-profile.self.cycles-pp.__pagevec_lru_add
      0.52            -0.3        0.20 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.45            -0.3        0.14 ±  4%  perf-profile.self.cycles-pp.xfs_iext_lookup_extent
      0.43 ±  2%      -0.3        0.13 ±  3%  perf-profile.self.cycles-pp.up_read
      0.34 ± 26%      -0.3        0.03 ± 70%  perf-profile.self.cycles-pp.ktime_get
      0.45            -0.3        0.15 ±  3%  perf-profile.self.cycles-pp.vfs_read
      0.46 ±  2%      -0.3        0.17 ±  2%  perf-profile.self.cycles-pp.__mod_node_page_state
      0.41            -0.3        0.12 ±  4%  perf-profile.self.cycles-pp.security_file_permission
      0.42 ±  2%      -0.3        0.14 ±  3%  perf-profile.self.cycles-pp.exit_to_user_mode_prepare
      0.38 ±  2%      -0.3        0.11 ±  4%  perf-profile.self.cycles-pp.xfs_break_leased_layouts
      0.40 ±  4%      -0.3        0.13 ±  5%  perf-profile.self.cycles-pp.xfs_file_write_iter
      0.40 ±  3%      -0.3        0.13 ±  3%  perf-profile.self.cycles-pp.filemap_get_pages
      0.36 ±  2%      -0.3        0.10 ±  3%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.37 ±  3%      -0.3        0.12 ±  4%  perf-profile.self.cycles-pp.atime_needs_update
      0.36 ±  3%      -0.2        0.12 ±  4%  perf-profile.self.cycles-pp.xas_store
      0.39 ±  2%      -0.2        0.15 ±  5%  perf-profile.self.cycles-pp.xfs_file_read_iter
      0.34 ±  5%      -0.2        0.10 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.34 ±  2%      -0.2        0.11 ±  4%  perf-profile.self.cycles-pp.__add_to_page_cache_locked
      0.34 ±  3%      -0.2        0.11        perf-profile.self.cycles-pp.xfs_file_write_checks
      0.33 ±  2%      -0.2        0.11 ±  4%  perf-profile.self.cycles-pp.xfs_errortag_test
      0.34 ±  2%      -0.2        0.12 ±  4%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode
      0.45 ±  2%      -0.2        0.23 ±  3%  perf-profile.self.cycles-pp.workingset_activation
      0.32 ±  3%      -0.2        0.11 ±  7%  perf-profile.self.cycles-pp.rcu_all_qs
      0.53            -0.2        0.32        perf-profile.self.cycles-pp.memset_erms
      0.30 ±  4%      -0.2        0.09 ±  5%  perf-profile.self.cycles-pp.page_counter_cancel
      0.30 ±  4%      -0.2        0.09 ±  4%  perf-profile.self.cycles-pp.__fdget_pos
      0.33            -0.2        0.12 ±  3%  perf-profile.self.cycles-pp.find_lock_entries
      0.28 ±  2%      -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.ksys_lseek
      0.35            -0.2        0.16 ±  3%  perf-profile.self.cycles-pp.pagevec_lru_move_fn
      0.30 ±  3%      -0.2        0.10 ±  4%  perf-profile.self.cycles-pp.current_time
      0.30 ±  4%      -0.2        0.10        perf-profile.self.cycles-pp.file_update_time
      0.28 ±  4%      -0.2        0.09        perf-profile.self.cycles-pp.xfs_buffered_write_iomap_end
      0.27            -0.2        0.08 ±  5%  perf-profile.self.cycles-pp.ksys_write
      0.28 ±  2%      -0.2        0.10 ±  6%  perf-profile.self.cycles-pp.xfs_bmbt_to_iomap
      0.27 ±  5%      -0.2        0.09        perf-profile.self.cycles-pp.timestamp_truncate
      0.26 ±  4%      -0.2        0.08 ±  8%  perf-profile.self.cycles-pp.xfs_break_layouts
      0.28 ±  3%      -0.2        0.10 ±  3%  perf-profile.self.cycles-pp.iov_iter_fault_in_readable
      0.26 ±  2%      -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.xfs_iread_extents
      0.25 ±  4%      -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.rw_verify_area
      0.25            -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.page_mapping
      0.25 ±  4%      -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.iomap_file_buffered_write
      0.23 ±  5%      -0.2        0.06 ±  7%  perf-profile.self.cycles-pp.xfs_file_llseek
      0.23 ±  2%      -0.2        0.07 ±  5%  perf-profile.self.cycles-pp.rmqueue
      0.24 ±  2%      -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.node_dirty_ok
      0.23 ±  2%      -0.2        0.08 ±  4%  perf-profile.self.cycles-pp.ksys_read
      0.22 ±  2%      -0.2        0.06 ±  7%  perf-profile.self.cycles-pp.__set_page_dirty
      0.22 ±  3%      -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.generic_write_checks
      0.20 ±  3%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__alloc_pages
      0.20 ±  2%      -0.1        0.06 ±  7%  perf-profile.self.cycles-pp.xfs_file_buffered_read
      0.19 ±  2%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__list_add_valid
      0.17 ±  3%      -0.1        0.04 ± 44%  perf-profile.self.cycles-pp.page_counter_try_charge
      0.19 ±  2%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.rcu_read_unlock_strict
      0.19 ±  3%      -0.1        0.07 ±  7%  perf-profile.self.cycles-pp.syscall_exit_to_user_mode_prepare
      0.18            -0.1        0.06 ±  8%  perf-profile.self.cycles-pp.iomap_page_create
      0.20 ±  2%      -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.__mod_lruvec_state
      0.30 ±  3%      -0.1        0.18 ±  5%  perf-profile.self.cycles-pp._raw_spin_lock
      0.15 ±  2%      -0.1        0.03 ± 70%  perf-profile.self.cycles-pp.generic_write_check_limits
      0.17 ±  4%      -0.1        0.06 ±  9%  perf-profile.self.cycles-pp.touch_atime
      0.17 ±  4%      -0.1        0.06 ±  8%  perf-profile.self.cycles-pp.__cancel_dirty_page
      0.18 ±  7%      -0.1        0.07 ±  7%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64
      0.14 ±  6%      -0.1        0.03 ± 70%  perf-profile.self.cycles-pp.get_page_from_freelist
      0.13            -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.xlog_cil_commit
      0.14 ±  5%      -0.1        0.04 ± 44%  perf-profile.self.cycles-pp.account_page_cleaned
      0.14 ±  7%      -0.1        0.04 ± 44%  perf-profile.self.cycles-pp.delete_from_page_cache_batch
      0.16 ±  6%      -0.1        0.06 ±  8%  perf-profile.self.cycles-pp.memcpy_erms
      0.21 ±  3%      -0.1        0.12 ±  9%  perf-profile.self.cycles-pp.lock_page_memcg
      0.18 ±  5%      -0.1        0.09 ±  7%  perf-profile.self.cycles-pp.mem_cgroup_update_lru_size
      0.14 ±  6%      -0.1        0.05 ± 46%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.14            -0.1        0.05 ±  8%  perf-profile.self.cycles-pp.lru_cache_add
      0.13 ±  4%      -0.1        0.05 ±  8%  perf-profile.self.cycles-pp.truncate_cleanup_page
      0.15 ±  3%      -0.1        0.07 ±  5%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.10 ±  4%      -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.uncharge_page
      0.11 ±  6%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.__free_one_page
      0.29 ±  3%      -0.0        0.25 ±  4%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.00            +0.1        0.10 ±  4%  perf-profile.self.cycles-pp.queue_work_on
      0.00            +0.2        0.24 ±  7%  perf-profile.self.cycles-pp.cgroup_rstat_flush_locked
      0.18 ±  2%      +0.7        0.89 ±  3%  perf-profile.self.cycles-pp.cgroup_rstat_updated
      0.00            +0.7        0.75 ±  6%  perf-profile.self.cycles-pp.mem_cgroup_css_rstat_flush
      3.86 ±  4%     +62.2       66.03        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath


                                                                                
                                  aim7.jobs-per-min                             
                                                                                
  600000 +------------------------------------------------------------------+   
         |.++.+.++.  .+. +.+.++. .++.++. .++.+.++.++.+.++. .++.+. +.++.+.++.|   
  580000 |-+       ++   +       +       +                 +      +          |   
         |                                                                  |   
  560000 |-+                                                                |   
         |                                                                  |   
  540000 |-+                                                                |   
         |                                                                  |   
  520000 |-+                          O    O    O    O                      |   
         |                      O OO O  O O  O O  OO   OO O OO   OO O  O O  |   
  500000 |-+                                                   O     O    O |   
         |         O                                                        |   
  480000 |-OO O OO  O   OO O OO                                             |   
         |            O                                                     |   
  460000 +------------------------------------------------------------------+   
                                                                                
                                                                                                                                                                
                       aim7.time.involuntary_context_switches                   
                                                                                
  60000 +-------------------------------------------------------------------+   
        |           O                                                       |   
  50000 |-+          O        O                                             |   
        | OO O            O O                                               |   
        |      OO O    O O                                                  |   
  40000 |-+                                                                 |   
        |                                                      O         O  |   
  30000 |-+                      O  O    O  O O    O  O O OO O  O O OO O  O |   
        |                      O   O  O O       OO                          |   
  20000 |-+                                O         O                      |   
        |                                                                   |   
        |                                                                   |   
  10000 |-+                                                                 |   
        |.++.+.++.+.++.+.++.+.++.+.++.+.++.++.+.++.+.++.+.++.+.++.+.++.+.++.|   
      0 +-------------------------------------------------------------------+   
                                                                                
                                                                                
[*] bisect-good sample
[O] bisect-bad  sample

***************************************************************************************************
lkp-csl-2ap3: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/nr_task/rootfs/runtime/tbox_group/test/testcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/100%/debian-10.4-x86_64-20200603.cgz/300s/lkp-csl-2ap3/compute/reaim/0x5003006

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     25.60 ±  8%     +83.3%      46.92 ±  4%  reaim.child_systime
   1176255           -10.0%    1058318        reaim.jobs_per_min
      6126           -10.0%       5512        reaim.jobs_per_min_child
   1285748           -14.7%    1096175        reaim.max_jobs_per_min
      0.99           +11.0%       1.10        reaim.parent_time
      4.03 ±  5%     -19.9%       3.23        reaim.std_dev_percent
      0.04 ±  6%      -9.5%       0.03 ±  3%  reaim.std_dev_time
    467074           +46.9%     686171        reaim.time.involuntary_context_switches
     38758           +18.7%      46008        reaim.time.major_page_faults
  2.53e+08            -3.4%  2.445e+08        reaim.time.minor_page_faults
      5610            +7.8%       6048        reaim.time.percent_of_cpu_this_job_got
      2553 ±  8%     +77.1%       4523 ±  4%  reaim.time.system_time
     14377            -4.3%      13761        reaim.time.user_time
   1119923 ±  4%      -5.5%    1058841        reaim.time.voluntary_context_switches
   1913600            -3.3%    1849600        reaim.workload
     14282 ±  6%     +20.4%      17198        meminfo.PageTables
      0.05 ±  4%      +0.1        0.12 ±  2%  mpstat.cpu.all.soft%
      4.48 ±  8%      +3.5        8.00 ±  4%  mpstat.cpu.all.sys%
      4055 ± 65%    +102.0%       8192 ± 29%  numa-meminfo.node0.PageTables
    117359 ± 32%     +36.3%     159956 ± 18%  numa-meminfo.node0.SUnreclaim
    983.00 ± 69%    +107.9%       2043 ± 30%  numa-vmstat.node0.nr_page_table_pages
     29352 ± 32%     +36.2%      39986 ± 18%  numa-vmstat.node0.nr_slab_unreclaimable
     33318 ± 15%     +96.1%      65348 ± 18%  turbostat.C1
    122.82            +3.6%     127.24        turbostat.PkgWatt
     11566 ±  3%     +27.7%      14765        vmstat.system.cs
     64057            +8.2%      69320        vmstat.system.in
      3604 ±  9%     +19.7%       4315        proc-vmstat.nr_page_table_pages
     34371            +1.0%      34717        proc-vmstat.nr_slab_reclaimable
    102724            +7.0%     109923        proc-vmstat.nr_slab_unreclaimable
  2.45e+08            -3.1%  2.374e+08        proc-vmstat.numa_hit
 2.451e+08            -3.1%  2.375e+08        proc-vmstat.numa_local
     25844            +6.8%      27609        proc-vmstat.pgactivate
  2.45e+08            -3.1%  2.374e+08        proc-vmstat.pgalloc_normal
 2.543e+08            -3.3%  2.458e+08        proc-vmstat.pgfault
  2.45e+08            -3.1%  2.374e+08        proc-vmstat.pgfree
  10835833            -3.6%   10451119        proc-vmstat.pgreuse
     29866 ±  3%     +98.8%      59373        slabinfo.cred_jar.active_objs
    710.67 ±  3%     +99.0%       1414        slabinfo.cred_jar.active_slabs
     29866 ±  3%     +99.0%      59435        slabinfo.cred_jar.num_objs
    710.67 ±  3%     +99.0%       1414        slabinfo.cred_jar.num_slabs
     22187           +89.3%      41994        slabinfo.shmem_inode_cache.active_objs
    481.67           +89.8%     914.33        slabinfo.shmem_inode_cache.active_slabs
     22187           +89.7%      42079        slabinfo.shmem_inode_cache.num_objs
    481.67           +89.8%     914.33        slabinfo.shmem_inode_cache.num_slabs
     16286           +21.8%      19840        slabinfo.signal_cache.active_objs
    582.50           +22.9%     716.17        slabinfo.signal_cache.active_slabs
     16320           +23.0%      20067        slabinfo.signal_cache.num_objs
    582.50           +22.9%     716.17        slabinfo.signal_cache.num_slabs
      2496           +11.7%       2788        slabinfo.task_struct.active_objs
      2512           +11.6%       2802        slabinfo.task_struct.active_slabs
      2512           +11.6%       2802        slabinfo.task_struct.num_objs
      2512           +11.6%       2802        slabinfo.task_struct.num_slabs
     28705 ±  2%     -31.9%      19557 ±  3%  softirqs.CPU0.RCU
     26503 ±  6%     -35.8%      17007 ±  5%  softirqs.CPU1.RCU
     26293 ±  3%     -38.0%      16307 ±  5%  softirqs.CPU10.RCU
     25549 ±  3%     -39.1%      15555 ±  6%  softirqs.CPU100.RCU
     25992           -39.7%      15678 ±  7%  softirqs.CPU101.RCU
     26758 ±  2%     -41.1%      15769 ±  5%  softirqs.CPU102.RCU
     26260 ±  2%     -38.5%      16146 ±  5%  softirqs.CPU103.RCU
     26063 ±  3%     -38.6%      16011 ±  6%  softirqs.CPU104.RCU
     25852           -41.4%      15160 ±  3%  softirqs.CPU105.RCU
     25593           -40.2%      15309 ±  4%  softirqs.CPU106.RCU
     26124 ±  5%     -42.1%      15138 ±  6%  softirqs.CPU107.RCU
     25411 ±  2%     -39.3%      15432 ±  4%  softirqs.CPU108.RCU
     25997           -39.0%      15869 ±  6%  softirqs.CPU109.RCU
     26055           -37.3%      16325 ±  8%  softirqs.CPU11.RCU
     25724 ±  3%     -39.1%      15675 ±  2%  softirqs.CPU110.RCU
     25569           -37.1%      16088 ±  3%  softirqs.CPU111.RCU
     25813 ±  5%     -40.6%      15324 ±  4%  softirqs.CPU112.RCU
     25688 ±  4%     -38.6%      15777 ±  4%  softirqs.CPU113.RCU
     25243           -35.9%      16174 ±  9%  softirqs.CPU114.RCU
     25643 ±  3%     -38.6%      15733 ±  5%  softirqs.CPU115.RCU
     25577 ±  4%     -37.4%      16004 ±  8%  softirqs.CPU116.RCU
     26438 ±  3%     -41.1%      15564 ±  3%  softirqs.CPU117.RCU
     25536 ±  3%     -37.4%      15982 ±  4%  softirqs.CPU118.RCU
     26251 ±  4%     -40.5%      15622 ±  4%  softirqs.CPU119.RCU
     26239           -38.4%      16169 ±  6%  softirqs.CPU12.RCU
     25590 ±  4%     -41.0%      15089 ±  4%  softirqs.CPU120.RCU
     25913 ±  3%     -42.3%      14948 ±  2%  softirqs.CPU121.RCU
     25684 ±  4%     -42.1%      14883 ±  4%  softirqs.CPU122.RCU
     26928 ±  7%     -44.9%      14842 ±  2%  softirqs.CPU123.RCU
     26246 ±  4%     -42.1%      15193 ±  4%  softirqs.CPU124.RCU
     25326 ±  2%     -40.8%      15003 ±  2%  softirqs.CPU125.RCU
     25764 ±  4%     -43.0%      14677 ±  3%  softirqs.CPU126.RCU
     25684 ±  4%     -42.4%      14784 ±  3%  softirqs.CPU127.RCU
     25532 ±  4%     -40.0%      15325 ±  4%  softirqs.CPU128.RCU
     25928 ±  3%     -42.8%      14823 ±  3%  softirqs.CPU129.RCU
     27104 ±  7%     -38.2%      16755 ± 12%  softirqs.CPU13.RCU
     25824 ±  4%     -41.7%      15057 ±  3%  softirqs.CPU130.RCU
     26155 ±  5%     -42.5%      15037        softirqs.CPU131.RCU
     26055 ±  4%     -42.7%      14930 ±  3%  softirqs.CPU132.RCU
     25844 ±  3%     -41.5%      15108 ±  3%  softirqs.CPU133.RCU
     25750 ±  3%     -40.6%      15307 ±  4%  softirqs.CPU134.RCU
     26036 ±  5%     -41.2%      15318 ±  2%  softirqs.CPU135.RCU
     25685 ±  3%     -41.0%      15163 ±  6%  softirqs.CPU136.RCU
     25817 ±  3%     -41.1%      15198        softirqs.CPU137.RCU
     26283 ±  2%     -41.6%      15351 ±  7%  softirqs.CPU138.RCU
     10310 ±  6%     -13.6%       8911 ±  6%  softirqs.CPU139.NET_RX
     27107 ±  5%     -44.5%      15055 ±  2%  softirqs.CPU139.RCU
     25666 ±  3%     -39.0%      15654 ±  4%  softirqs.CPU14.RCU
     25522 ±  2%     -39.1%      15543        softirqs.CPU140.RCU
     25845 ±  2%     -42.4%      14897 ±  3%  softirqs.CPU141.RCU
     25868 ±  5%     -41.3%      15194 ±  4%  softirqs.CPU142.RCU
     25325 ±  5%     -39.5%      15318 ±  3%  softirqs.CPU143.RCU
     26221 ±  2%     -42.6%      15042 ±  2%  softirqs.CPU144.RCU
     26366 ±  3%     -42.4%      15197 ±  2%  softirqs.CPU145.RCU
     26355 ±  3%     -43.5%      14895 ±  2%  softirqs.CPU146.RCU
     25762           -40.8%      15259        softirqs.CPU147.RCU
     25694 ±  4%     -40.9%      15196        softirqs.CPU148.RCU
     26680 ±  2%     -42.5%      15334 ±  2%  softirqs.CPU149.RCU
     25883 ±  2%     -40.1%      15493 ±  2%  softirqs.CPU15.RCU
     26390 ±  3%     -44.0%      14778        softirqs.CPU150.RCU
     26695 ±  2%     -43.6%      15066 ±  3%  softirqs.CPU151.RCU
     26128 ±  2%     -42.0%      15152 ±  3%  softirqs.CPU152.RCU
     25897 ±  2%     -42.5%      14883 ±  2%  softirqs.CPU153.RCU
     26043 ±  4%     -42.7%      14915 ±  2%  softirqs.CPU154.RCU
     26324 ±  4%     -42.9%      15035        softirqs.CPU155.RCU
     26491 ±  4%     -44.0%      14845 ±  4%  softirqs.CPU156.RCU
     10361 ±  4%     -10.5%       9272        softirqs.CPU157.NET_RX
     26347 ±  4%     -43.1%      14986 ±  2%  softirqs.CPU157.RCU
     25523 ±  3%     -41.1%      15029 ±  2%  softirqs.CPU158.RCU
     26240 ±  2%     -44.4%      14588 ±  3%  softirqs.CPU159.RCU
     26715 ±  5%     -42.8%      15289 ±  3%  softirqs.CPU16.RCU
     26370 ±  4%     -44.3%      14695 ±  3%  softirqs.CPU160.RCU
     25738 ±  3%     -42.6%      14775        softirqs.CPU161.RCU
     10415 ±  2%      -9.8%       9396 ±  2%  softirqs.CPU162.NET_RX
     25942 ±  3%     -43.2%      14735 ±  3%  softirqs.CPU162.RCU
     25763 ±  2%     -43.3%      14601 ±  2%  softirqs.CPU163.RCU
     25994           -42.7%      14897 ±  2%  softirqs.CPU164.RCU
     25951 ±  2%     -42.3%      14980 ±  2%  softirqs.CPU165.RCU
     25484 ±  2%     -43.1%      14511        softirqs.CPU166.RCU
     26046 ±  3%     -42.6%      14960 ±  5%  softirqs.CPU167.RCU
     25492 ±  3%     -40.6%      15144 ±  4%  softirqs.CPU168.RCU
     25613 ±  4%     -40.8%      15151 ±  7%  softirqs.CPU169.RCU
     25717 ±  3%     -40.4%      15339 ±  4%  softirqs.CPU17.RCU
     25798 ±  4%     -42.5%      14846 ±  3%  softirqs.CPU170.RCU
     25003 ±  4%     -39.7%      15066        softirqs.CPU171.RCU
     25727 ±  5%     -41.9%      14939 ±  2%  softirqs.CPU172.RCU
     25738 ±  5%     -41.1%      15148        softirqs.CPU173.RCU
     24954 ±  3%     -38.5%      15335 ±  3%  softirqs.CPU174.RCU
     25876 ±  5%     -43.4%      14652        softirqs.CPU175.RCU
     26505 ±  9%     -41.6%      15491 ±  4%  softirqs.CPU176.RCU
     26006 ±  2%     -40.6%      15459 ±  4%  softirqs.CPU177.RCU
     26585 ±  2%     -42.6%      15250 ±  7%  softirqs.CPU178.RCU
     26239 ±  3%     -41.3%      15392 ±  7%  softirqs.CPU179.RCU
     26107 ±  3%     -42.0%      15146 ±  5%  softirqs.CPU18.RCU
     26320 ±  4%     -40.9%      15548 ±  7%  softirqs.CPU180.RCU
     26170 ±  7%     -42.3%      15093 ±  4%  softirqs.CPU181.RCU
      9958 ±  3%      -7.3%       9236 ±  5%  softirqs.CPU182.NET_RX
     25566 ±  4%     -41.5%      14965 ±  2%  softirqs.CPU182.RCU
     25797 ±  2%     -42.7%      14770 ±  2%  softirqs.CPU183.RCU
     26296 ±  5%     -42.8%      15047 ±  2%  softirqs.CPU184.RCU
     25473 ±  3%     -39.3%      15460 ±  5%  softirqs.CPU185.RCU
     26082 ±  2%     -39.2%      15858 ± 11%  softirqs.CPU186.RCU
     25806 ±  4%     -41.9%      15006 ±  3%  softirqs.CPU187.RCU
     25467 ±  3%     -39.9%      15310 ±  4%  softirqs.CPU188.RCU
     25282 ±  5%     -40.6%      15021 ±  6%  softirqs.CPU189.RCU
     25951 ±  3%     -39.7%      15658 ±  5%  softirqs.CPU19.RCU
     25224 ±  5%     -41.1%      14864 ±  3%  softirqs.CPU190.RCU
     25308 ±  3%     -41.2%      14874 ±  3%  softirqs.CPU191.RCU
     26403 ±  4%     -38.3%      16298 ±  4%  softirqs.CPU2.RCU
     26010           -41.3%      15265        softirqs.CPU20.RCU
     26947 ±  5%     -41.5%      15759 ±  3%  softirqs.CPU21.RCU
     26367 ±  2%     -40.2%      15764 ±  6%  softirqs.CPU22.RCU
     26134 ±  3%     -39.4%      15825 ±  7%  softirqs.CPU23.RCU
     26038 ±  4%     -42.8%      14890 ±  4%  softirqs.CPU24.RCU
     25746 ±  4%     -40.7%      15264 ±  2%  softirqs.CPU25.RCU
     25914 ±  5%     -42.4%      14936 ±  2%  softirqs.CPU26.RCU
     25438 ±  2%     -40.8%      15060 ±  3%  softirqs.CPU27.RCU
     25608 ±  3%     -41.2%      15046 ±  3%  softirqs.CPU28.RCU
     25883 ±  3%     -41.7%      15090        softirqs.CPU29.RCU
     25870 ±  5%     -37.6%      16149 ±  4%  softirqs.CPU3.RCU
     25723 ±  4%     -40.1%      15399 ±  3%  softirqs.CPU30.RCU
     25557 ±  5%     -41.8%      14864        softirqs.CPU31.RCU
     26293 ±  3%     -42.5%      15131        softirqs.CPU32.RCU
     10517 ±  4%      -8.9%       9576 ±  4%  softirqs.CPU33.NET_RX
     26060 ±  3%     -41.6%      15207 ±  2%  softirqs.CPU33.RCU
     25825 ±  4%     -42.7%      14785 ±  3%  softirqs.CPU34.RCU
     25484 ±  2%     -41.6%      14890        softirqs.CPU35.RCU
     25841 ±  2%     -41.3%      15176 ±  5%  softirqs.CPU36.RCU
     26009 ±  5%     -42.6%      14938 ±  3%  softirqs.CPU37.RCU
     25834 ±  3%     -40.2%      15441        softirqs.CPU38.RCU
     25732 ±  3%     -41.0%      15175 ±  2%  softirqs.CPU39.RCU
     25727 ±  2%     -34.8%      16773 ±  9%  softirqs.CPU4.RCU
     26054 ±  5%     -40.2%      15587 ±  3%  softirqs.CPU40.RCU
     26052 ±  2%     -40.9%      15384 ±  3%  softirqs.CPU41.RCU
     25749 ±  3%     -39.0%      15702 ±  3%  softirqs.CPU42.RCU
     26182 ±  4%     -39.9%      15729 ±  3%  softirqs.CPU43.RCU
     10068 ±  8%     -10.9%       8966 ±  4%  softirqs.CPU44.NET_RX
     26332 ±  3%     -41.7%      15352 ±  2%  softirqs.CPU44.RCU
     25297 ±  2%     -38.9%      15463 ±  2%  softirqs.CPU45.RCU
     26390 ±  4%     -39.7%      15909 ±  2%  softirqs.CPU46.RCU
     25802 ±  3%     -39.4%      15627 ±  3%  softirqs.CPU47.RCU
     26812           -42.2%      15510 ±  4%  softirqs.CPU48.RCU
     26393 ±  3%     -42.8%      15102 ±  3%  softirqs.CPU49.RCU
     25646 ±  4%     -36.6%      16271 ±  7%  softirqs.CPU5.RCU
     26722 ±  4%     -42.6%      15337 ±  2%  softirqs.CPU50.RCU
     26122 ±  4%     -41.7%      15238 ±  2%  softirqs.CPU51.RCU
     26093 ±  4%     -41.2%      15331 ±  2%  softirqs.CPU52.RCU
     25751 ±  3%     -40.8%      15249        softirqs.CPU53.RCU
     26451           -42.7%      15150 ±  4%  softirqs.CPU54.RCU
     26071 ±  2%     -41.7%      15197        softirqs.CPU55.RCU
     26390 ±  2%     -42.3%      15239        softirqs.CPU56.RCU
     26794           -43.7%      15077 ±  2%  softirqs.CPU57.RCU
     26905 ±  3%     -42.8%      15398        softirqs.CPU58.RCU
     26392 ±  4%     -42.7%      15120 ±  3%  softirqs.CPU59.RCU
     25879 ±  3%     -39.8%      15575 ±  3%  softirqs.CPU6.RCU
     26053 ±  2%     -41.9%      15149 ±  3%  softirqs.CPU60.RCU
     26082 ±  4%     -42.4%      15015 ±  2%  softirqs.CPU61.RCU
     26550 ±  3%     -42.1%      15382        softirqs.CPU62.RCU
     26624           -42.3%      15349        softirqs.CPU63.RCU
     26086           -42.3%      15061 ±  3%  softirqs.CPU64.RCU
     26408 ±  3%     -42.6%      15171 ±  2%  softirqs.CPU65.RCU
     26179 ±  4%     -42.4%      15086        softirqs.CPU66.RCU
     26630 ±  2%     -43.5%      15033 ±  4%  softirqs.CPU67.RCU
     26181 ±  3%     -42.6%      15028 ±  4%  softirqs.CPU68.RCU
     26618 ±  3%     -42.9%      15190 ±  2%  softirqs.CPU69.RCU
     25778 ±  5%     -38.3%      15895 ±  4%  softirqs.CPU7.RCU
     26753 ±  2%     -42.8%      15300 ±  2%  softirqs.CPU70.RCU
     26020 ±  2%     -42.3%      15003        softirqs.CPU71.RCU
     25989 ±  4%     -41.7%      15148 ±  4%  softirqs.CPU72.RCU
     25313 ±  4%     -34.9%      16485 ± 11%  softirqs.CPU73.RCU
     25311 ±  5%     -37.2%      15894 ±  3%  softirqs.CPU74.RCU
     25704 ±  3%     -38.2%      15893 ±  4%  softirqs.CPU75.RCU
     25640 ±  2%     -39.9%      15420 ±  4%  softirqs.CPU76.RCU
     26039 ±  5%     -39.9%      15652 ±  5%  softirqs.CPU77.RCU
     25951 ±  4%     -41.0%      15320 ±  6%  softirqs.CPU78.RCU
     26019 ±  5%     -41.7%      15178 ±  7%  softirqs.CPU79.RCU
     25532 ±  4%     -35.6%      16431 ±  8%  softirqs.CPU8.RCU
     25895 ±  3%     -41.2%      15213 ±  2%  softirqs.CPU80.RCU
     26200 ±  5%     -41.1%      15444 ±  3%  softirqs.CPU81.RCU
     25833 ±  2%     -39.3%      15684 ±  3%  softirqs.CPU82.RCU
     26218 ±  4%     -41.6%      15319 ±  2%  softirqs.CPU83.RCU
     25989 ±  2%     -41.7%      15159 ±  3%  softirqs.CPU84.RCU
     25784 ±  4%     -40.9%      15238 ±  2%  softirqs.CPU85.RCU
     26282 ±  3%     -42.4%      15129 ±  2%  softirqs.CPU86.RCU
     26422           -41.5%      15448 ±  3%  softirqs.CPU87.RCU
     26202 ±  4%     -42.0%      15208 ±  2%  softirqs.CPU88.RCU
     26070 ±  2%     -40.5%      15513 ±  4%  softirqs.CPU89.RCU
     26269 ±  2%     -39.7%      15845 ±  4%  softirqs.CPU9.RCU
     26156 ±  5%     -42.0%      15183 ±  3%  softirqs.CPU90.RCU
     26317 ±  2%     -41.7%      15344 ±  2%  softirqs.CPU91.RCU
     26401 ±  5%     -42.9%      15066 ±  2%  softirqs.CPU92.RCU
     26094 ±  5%     -41.0%      15388 ±  5%  softirqs.CPU93.RCU
     26356 ±  5%     -43.3%      14935 ±  3%  softirqs.CPU94.RCU
     26325 ±  5%     -40.0%      15793 ±  3%  softirqs.CPU95.RCU
     25429 ±  2%     -36.7%      16087 ±  6%  softirqs.CPU96.RCU
     25442 ±  3%     -36.1%      16257 ±  3%  softirqs.CPU97.RCU
     25858 ±  3%     -38.6%      15874 ±  6%  softirqs.CPU98.RCU
     25718 ±  3%     -40.1%      15413 ±  7%  softirqs.CPU99.RCU
   4994065 ±  2%     -40.9%    2949223        softirqs.RCU
    264791 ±  4%     +89.0%     500459        interrupts.CAL:Function_call_interrupts
      1890 ± 15%    +183.4%       5358 ± 25%  interrupts.CPU0.CAL:Function_call_interrupts
    457.00 ±  7%    +173.8%       1251 ± 28%  interrupts.CPU0.RES:Rescheduling_interrupts
      1623 ± 17%    +194.6%       4781 ± 31%  interrupts.CPU1.CAL:Function_call_interrupts
    102809 ±  3%     +11.5%     114605 ±  3%  interrupts.CPU1.LOC:Local_timer_interrupts
      1317 ±  5%    +248.9%       4596 ± 34%  interrupts.CPU10.CAL:Function_call_interrupts
    471.67 ±  8%    +176.7%       1305 ± 32%  interrupts.CPU10.RES:Rescheduling_interrupts
      1342 ±  8%    +259.1%       4820 ± 36%  interrupts.CPU100.CAL:Function_call_interrupts
      1279 ±  3%    +262.5%       4636 ± 31%  interrupts.CPU101.CAL:Function_call_interrupts
    469.33          +184.2%       1334 ± 27%  interrupts.CPU101.RES:Rescheduling_interrupts
      1501 ± 20%    +201.2%       4522 ± 36%  interrupts.CPU102.CAL:Function_call_interrupts
      1348 ±  5%    +243.0%       4623 ± 35%  interrupts.CPU103.CAL:Function_call_interrupts
      1433 ± 14%    +218.1%       4560 ± 33%  interrupts.CPU104.CAL:Function_call_interrupts
    487.83 ±  3%    +165.4%       1294 ± 29%  interrupts.CPU104.RES:Rescheduling_interrupts
      1382 ±  8%    +239.8%       4697 ± 33%  interrupts.CPU105.CAL:Function_call_interrupts
      1316 ±  4%    +236.8%       4433 ± 35%  interrupts.CPU106.CAL:Function_call_interrupts
      1317 ±  6%    +252.3%       4642 ± 32%  interrupts.CPU107.CAL:Function_call_interrupts
    480.83 ±  3%    +168.2%       1289 ± 28%  interrupts.CPU107.RES:Rescheduling_interrupts
      1293 ±  6%    +239.1%       4385 ± 30%  interrupts.CPU108.CAL:Function_call_interrupts
      1395 ±  8%    +249.5%       4876 ± 33%  interrupts.CPU109.CAL:Function_call_interrupts
      1394 ±  8%    +226.1%       4547 ± 32%  interrupts.CPU11.CAL:Function_call_interrupts
     99632           +11.7%     111261 ±  4%  interrupts.CPU11.LOC:Local_timer_interrupts
      1325 ±  8%    +213.4%       4154 ± 32%  interrupts.CPU110.CAL:Function_call_interrupts
    485.83 ±  6%    +151.7%       1222 ± 29%  interrupts.CPU110.RES:Rescheduling_interrupts
      1317 ±  6%    +254.2%       4667 ± 35%  interrupts.CPU111.CAL:Function_call_interrupts
      1319 ±  8%    +280.3%       5019 ± 33%  interrupts.CPU112.CAL:Function_call_interrupts
    480.50 ±  8%    +181.1%       1350 ± 31%  interrupts.CPU112.RES:Rescheduling_interrupts
      1332 ±  6%    +243.8%       4580 ± 31%  interrupts.CPU113.CAL:Function_call_interrupts
    489.00 ±  9%    +165.5%       1298 ± 29%  interrupts.CPU113.RES:Rescheduling_interrupts
      1280 ±  2%    +244.6%       4412 ± 35%  interrupts.CPU114.CAL:Function_call_interrupts
      1316 ±  6%    +238.8%       4458 ± 32%  interrupts.CPU115.CAL:Function_call_interrupts
    485.17 ±  5%    +158.5%       1254 ± 28%  interrupts.CPU115.RES:Rescheduling_interrupts
      1370 ±  7%    +272.7%       5107 ± 35%  interrupts.CPU116.CAL:Function_call_interrupts
      1382 ±  4%    +252.4%       4871 ± 32%  interrupts.CPU117.CAL:Function_call_interrupts
    100326 ±  3%      +9.2%     109570 ±  2%  interrupts.CPU117.LOC:Local_timer_interrupts
    477.17 ±  9%    +187.6%       1372 ± 30%  interrupts.CPU117.RES:Rescheduling_interrupts
      1321 ±  6%    +265.6%       4830 ± 32%  interrupts.CPU118.CAL:Function_call_interrupts
    100478 ±  2%     +10.1%     110598 ±  2%  interrupts.CPU118.LOC:Local_timer_interrupts
    490.67 ±  8%    +181.8%       1382 ± 29%  interrupts.CPU118.RES:Rescheduling_interrupts
      1375 ±  7%    +242.4%       4709 ± 33%  interrupts.CPU119.CAL:Function_call_interrupts
    100440 ±  2%      +9.5%     110014 ±  2%  interrupts.CPU119.LOC:Local_timer_interrupts
    499.67 ±  7%    +167.3%       1335 ± 29%  interrupts.CPU119.RES:Rescheduling_interrupts
      1314 ±  6%    +266.6%       4816 ± 34%  interrupts.CPU12.CAL:Function_call_interrupts
    469.50 ±  4%    +185.8%       1342 ± 31%  interrupts.CPU12.RES:Rescheduling_interrupts
      1380 ±  3%     +21.0%       1670 ±  6%  interrupts.CPU120.CAL:Function_call_interrupts
      1261 ±  7%     +26.7%       1598 ±  7%  interrupts.CPU123.CAL:Function_call_interrupts
    455.50 ±  5%     +11.6%     508.33 ±  5%  interrupts.CPU123.RES:Rescheduling_interrupts
      1334 ±  3%     +19.6%       1596 ±  5%  interrupts.CPU124.CAL:Function_call_interrupts
      1322 ±  5%     +22.2%       1615 ±  4%  interrupts.CPU125.CAL:Function_call_interrupts
      1325 ±  3%     +15.2%       1526 ±  3%  interrupts.CPU126.CAL:Function_call_interrupts
      1316           +21.9%       1604 ±  8%  interrupts.CPU127.CAL:Function_call_interrupts
      1327 ±  4%     +20.5%       1599 ±  5%  interrupts.CPU128.CAL:Function_call_interrupts
      1326 ±  5%     +18.7%       1573 ±  5%  interrupts.CPU129.CAL:Function_call_interrupts
      1393 ±  7%    +211.7%       4342 ± 34%  interrupts.CPU13.CAL:Function_call_interrupts
    503.50 ±  6%    +147.8%       1247 ± 31%  interrupts.CPU13.RES:Rescheduling_interrupts
      1335 ±  3%     +20.3%       1606 ±  5%  interrupts.CPU130.CAL:Function_call_interrupts
      1340 ±  5%     +18.5%       1588 ±  3%  interrupts.CPU131.CAL:Function_call_interrupts
      1345 ±  4%     +18.6%       1595 ±  6%  interrupts.CPU132.CAL:Function_call_interrupts
      1327 ±  5%     +19.4%       1584 ±  2%  interrupts.CPU133.CAL:Function_call_interrupts
      1305 ±  3%     +21.9%       1590 ±  4%  interrupts.CPU135.CAL:Function_call_interrupts
    461.50 ±  7%     +10.9%     511.67 ±  4%  interrupts.CPU136.RES:Rescheduling_interrupts
      1358 ±  8%     +18.3%       1606 ±  4%  interrupts.CPU137.CAL:Function_call_interrupts
      1333 ±  4%    +256.4%       4750 ± 33%  interrupts.CPU14.CAL:Function_call_interrupts
    429.50 ±  3%    +211.8%       1339 ± 30%  interrupts.CPU14.RES:Rescheduling_interrupts
    460.17 ±  6%     +16.8%     537.50 ±  3%  interrupts.CPU140.RES:Rescheduling_interrupts
    457.83 ±  6%     +11.0%     508.17 ±  6%  interrupts.CPU141.RES:Rescheduling_interrupts
      1330 ±  4%     +22.3%       1627 ±  4%  interrupts.CPU142.CAL:Function_call_interrupts
      1325 ±  3%     +22.0%       1617 ±  6%  interrupts.CPU143.CAL:Function_call_interrupts
    450.00 ±  5%     +17.2%     527.50 ±  5%  interrupts.CPU143.RES:Rescheduling_interrupts
      1349 ±  4%     +15.6%       1560 ±  5%  interrupts.CPU144.CAL:Function_call_interrupts
      1287 ±  3%     +39.0%       1789 ± 26%  interrupts.CPU145.CAL:Function_call_interrupts
      1324 ±  5%     +16.8%       1547 ±  4%  interrupts.CPU146.CAL:Function_call_interrupts
      1312 ±  8%     +19.8%       1571 ±  3%  interrupts.CPU147.CAL:Function_call_interrupts
    436.50 ±  9%     +22.4%     534.17 ±  4%  interrupts.CPU147.RES:Rescheduling_interrupts
    452.83 ±  7%     +20.9%     547.33 ±  9%  interrupts.CPU148.RES:Rescheduling_interrupts
      1369 ±  6%    +245.9%       4735 ± 35%  interrupts.CPU15.CAL:Function_call_interrupts
    469.17 ±  6%    +187.2%       1347 ± 33%  interrupts.CPU15.RES:Rescheduling_interrupts
      1307 ±  6%     +18.5%       1548 ±  3%  interrupts.CPU150.CAL:Function_call_interrupts
      1348 ±  9%     +21.7%       1640 ±  9%  interrupts.CPU151.CAL:Function_call_interrupts
      1315 ±  5%     +17.7%       1548 ±  4%  interrupts.CPU152.CAL:Function_call_interrupts
      1293 ±  5%     +23.5%       1597 ± 10%  interrupts.CPU154.CAL:Function_call_interrupts
      1295 ±  3%     +20.3%       1557 ± 11%  interrupts.CPU156.CAL:Function_call_interrupts
    462.50 ±  7%     +13.0%     522.67 ±  6%  interrupts.CPU156.RES:Rescheduling_interrupts
      1306 ±  6%     +21.3%       1584 ±  2%  interrupts.CPU157.CAL:Function_call_interrupts
      1281 ± 11%     +24.4%       1593 ±  5%  interrupts.CPU158.CAL:Function_call_interrupts
    434.17 ±  5%     +22.0%     529.50 ±  4%  interrupts.CPU158.RES:Rescheduling_interrupts
      1363 ±  7%     +13.4%       1546 ±  3%  interrupts.CPU159.CAL:Function_call_interrupts
      1396 ±  5%    +263.5%       5075 ± 37%  interrupts.CPU16.CAL:Function_call_interrupts
      1317 ±  4%     +17.9%       1553 ±  4%  interrupts.CPU160.CAL:Function_call_interrupts
    471.17 ±  6%     +11.5%     525.50 ±  7%  interrupts.CPU160.RES:Rescheduling_interrupts
      1320 ±  6%     +17.6%       1552 ±  4%  interrupts.CPU162.CAL:Function_call_interrupts
    445.50 ±  6%     +16.2%     517.83 ±  3%  interrupts.CPU162.RES:Rescheduling_interrupts
      1271 ±  3%     +24.3%       1580 ±  5%  interrupts.CPU163.CAL:Function_call_interrupts
      1326 ±  2%     +16.7%       1548 ±  3%  interrupts.CPU164.CAL:Function_call_interrupts
      1291 ±  4%     +19.8%       1546 ±  3%  interrupts.CPU165.CAL:Function_call_interrupts
      1287 ±  6%     +21.9%       1569 ±  5%  interrupts.CPU166.CAL:Function_call_interrupts
      1328 ±  4%     +16.4%       1546 ±  8%  interrupts.CPU167.CAL:Function_call_interrupts
      1350 ±  3%     +69.1%       2283 ± 49%  interrupts.CPU168.CAL:Function_call_interrupts
    482.00 ±  3%     +54.3%     743.67 ± 45%  interrupts.CPU168.RES:Rescheduling_interrupts
      1339 ±  8%    +259.1%       4808 ± 30%  interrupts.CPU17.CAL:Function_call_interrupts
    468.50 ±  7%    +190.8%       1362 ± 30%  interrupts.CPU17.RES:Rescheduling_interrupts
      1382 ±  5%     +90.5%       2633 ± 56%  interrupts.CPU170.CAL:Function_call_interrupts
      1330 ±  7%     +89.0%       2514 ± 57%  interrupts.CPU171.CAL:Function_call_interrupts
    452.33 ±  7%     +74.7%     790.17 ± 52%  interrupts.CPU171.RES:Rescheduling_interrupts
      1331 ±  5%     +94.3%       2587 ± 60%  interrupts.CPU172.CAL:Function_call_interrupts
      1390 ±  7%     +85.7%       2582 ± 59%  interrupts.CPU173.CAL:Function_call_interrupts
    459.00 ±  4%     +73.7%     797.33 ± 50%  interrupts.CPU173.RES:Rescheduling_interrupts
    461.83 ±  4%     +74.4%     805.33 ± 55%  interrupts.CPU174.RES:Rescheduling_interrupts
      1381 ± 10%     +81.3%       2505 ± 51%  interrupts.CPU175.CAL:Function_call_interrupts
      1328 ±  4%    +101.1%       2672 ± 50%  interrupts.CPU176.CAL:Function_call_interrupts
    446.33 ±  2%     +73.0%     772.17 ± 50%  interrupts.CPU176.RES:Rescheduling_interrupts
      1268 ± 10%     +90.7%       2418 ± 55%  interrupts.CPU177.CAL:Function_call_interrupts
    457.83 ±  6%     +67.1%     765.00 ± 52%  interrupts.CPU177.RES:Rescheduling_interrupts
      1386 ±  6%    +219.4%       4428 ± 34%  interrupts.CPU18.CAL:Function_call_interrupts
    477.50 ±  5%    +160.5%       1243 ± 31%  interrupts.CPU18.RES:Rescheduling_interrupts
      1427 ±  8%     +89.7%       2707 ± 62%  interrupts.CPU180.CAL:Function_call_interrupts
    462.50 ±  5%     +83.7%     849.83 ± 56%  interrupts.CPU180.RES:Rescheduling_interrupts
    460.67 ±  6%     +81.8%     837.33 ± 56%  interrupts.CPU181.RES:Rescheduling_interrupts
      1340 ±  3%     +87.9%       2519 ± 61%  interrupts.CPU182.CAL:Function_call_interrupts
    463.17 ±  6%     +74.3%     807.33 ± 57%  interrupts.CPU182.RES:Rescheduling_interrupts
      1374 ±  8%     +88.0%       2585 ± 62%  interrupts.CPU183.CAL:Function_call_interrupts
    455.17 ±  5%     +79.9%     819.00 ± 58%  interrupts.CPU183.RES:Rescheduling_interrupts
    481.00 ±  4%     +58.2%     760.83 ± 48%  interrupts.CPU184.RES:Rescheduling_interrupts
      1346 ±  5%     +85.6%       2499 ± 62%  interrupts.CPU185.CAL:Function_call_interrupts
    472.00 ±  7%     +65.0%     778.83 ± 53%  interrupts.CPU185.RES:Rescheduling_interrupts
    466.00 ±  8%     +88.7%     879.33 ± 63%  interrupts.CPU187.RES:Rescheduling_interrupts
      1379 ±  9%     +83.1%       2525 ± 62%  interrupts.CPU188.CAL:Function_call_interrupts
    466.17 ±  6%     +73.5%     808.67 ± 59%  interrupts.CPU188.RES:Rescheduling_interrupts
    432.83 ±  6%     +91.6%     829.17 ± 59%  interrupts.CPU189.RES:Rescheduling_interrupts
      1363 ±  5%    +244.7%       4698 ± 36%  interrupts.CPU19.CAL:Function_call_interrupts
      1329 ±  3%    +100.3%       2662 ± 71%  interrupts.CPU190.CAL:Function_call_interrupts
    442.17 ±  6%     +88.9%     835.17 ± 66%  interrupts.CPU190.RES:Rescheduling_interrupts
    455.50 ±  3%     +76.8%     805.33 ± 53%  interrupts.CPU191.RES:Rescheduling_interrupts
      1416 ±  6%    +211.1%       4405 ± 30%  interrupts.CPU2.CAL:Function_call_interrupts
    101413 ±  2%     +10.4%     111979 ±  2%  interrupts.CPU2.LOC:Local_timer_interrupts
    456.17 ±  7%    +164.0%       1204 ± 28%  interrupts.CPU2.RES:Rescheduling_interrupts
      1374 ±  4%    +230.9%       4548 ± 35%  interrupts.CPU20.CAL:Function_call_interrupts
    448.67 ±  6%    +193.8%       1318 ± 32%  interrupts.CPU20.RES:Rescheduling_interrupts
      1399 ±  7%    +249.4%       4889 ± 32%  interrupts.CPU21.CAL:Function_call_interrupts
    485.00 ±  8%    +177.9%       1347 ± 29%  interrupts.CPU21.RES:Rescheduling_interrupts
      1379 ±  4%    +236.7%       4645 ± 32%  interrupts.CPU22.CAL:Function_call_interrupts
    492.17 ±  3%    +169.5%       1326 ± 29%  interrupts.CPU22.RES:Rescheduling_interrupts
      1364 ±  9%    +234.6%       4565 ± 30%  interrupts.CPU23.CAL:Function_call_interrupts
     99689           +10.2%     109851 ±  2%  interrupts.CPU23.LOC:Local_timer_interrupts
    480.17 ±  5%    +171.3%       1302 ± 27%  interrupts.CPU23.RES:Rescheduling_interrupts
      1350 ±  5%     +22.8%       1658 ±  9%  interrupts.CPU24.CAL:Function_call_interrupts
      1337 ±  6%     +22.2%       1633 ±  4%  interrupts.CPU27.CAL:Function_call_interrupts
      1356 ±  3%     +18.4%       1606 ±  5%  interrupts.CPU28.CAL:Function_call_interrupts
      1377 ±  4%     +16.5%       1604 ±  2%  interrupts.CPU29.CAL:Function_call_interrupts
      1302 ±  9%    +247.1%       4522 ± 33%  interrupts.CPU3.CAL:Function_call_interrupts
    100628           +10.0%     110686 ±  2%  interrupts.CPU3.LOC:Local_timer_interrupts
    438.50 ±  6%    +183.9%       1245 ± 31%  interrupts.CPU3.RES:Rescheduling_interrupts
      1354 ±  4%     +17.4%       1590 ±  4%  interrupts.CPU31.CAL:Function_call_interrupts
      1379 ±  4%     +16.6%       1607 ±  5%  interrupts.CPU32.CAL:Function_call_interrupts
      1381 ±  2%     +14.4%       1581 ±  3%  interrupts.CPU33.CAL:Function_call_interrupts
      1348 ±  4%     +18.1%       1592 ±  3%  interrupts.CPU34.CAL:Function_call_interrupts
      1327 ±  6%     +18.4%       1571 ±  4%  interrupts.CPU35.CAL:Function_call_interrupts
      1340 ±  7%     +20.9%       1620        interrupts.CPU36.CAL:Function_call_interrupts
      1381 ±  6%     +13.6%       1569 ±  5%  interrupts.CPU37.CAL:Function_call_interrupts
      1337 ± 14%     +23.0%       1645 ±  2%  interrupts.CPU38.CAL:Function_call_interrupts
      1379 ±  6%     +16.4%       1605 ±  5%  interrupts.CPU39.CAL:Function_call_interrupts
      1457 ± 12%    +203.1%       4418 ± 29%  interrupts.CPU4.CAL:Function_call_interrupts
     99772            +9.7%     109413 ±  2%  interrupts.CPU4.LOC:Local_timer_interrupts
    452.83 ±  4%    +174.5%       1242 ± 27%  interrupts.CPU4.RES:Rescheduling_interrupts
      1369 ±  6%     +18.1%       1617 ±  5%  interrupts.CPU40.CAL:Function_call_interrupts
    455.83 ±  5%     +12.1%     510.83 ±  5%  interrupts.CPU40.RES:Rescheduling_interrupts
      1314 ±  3%     +24.7%       1638 ±  9%  interrupts.CPU42.CAL:Function_call_interrupts
    459.83 ±  3%     +17.0%     538.00 ± 10%  interrupts.CPU42.RES:Rescheduling_interrupts
      1375 ±  5%     +24.1%       1708 ±  4%  interrupts.CPU43.CAL:Function_call_interrupts
      1340 ±  5%     +24.9%       1674 ±  5%  interrupts.CPU46.CAL:Function_call_interrupts
      1372 ±  6%     +18.5%       1625 ±  2%  interrupts.CPU47.CAL:Function_call_interrupts
      1361 ±  5%     +19.3%       1623 ±  8%  interrupts.CPU49.CAL:Function_call_interrupts
      1377 ±  3%    +248.2%       4798 ± 32%  interrupts.CPU5.CAL:Function_call_interrupts
     99543            +9.8%     109308 ±  2%  interrupts.CPU5.LOC:Local_timer_interrupts
      1362 ±  6%     +14.8%       1563 ±  5%  interrupts.CPU50.CAL:Function_call_interrupts
      1323 ±  6%     +16.9%       1547 ±  3%  interrupts.CPU53.CAL:Function_call_interrupts
      1331 ±  7%     +20.7%       1607 ± 10%  interrupts.CPU54.CAL:Function_call_interrupts
      1391 ±  3%     +13.6%       1581 ±  5%  interrupts.CPU55.CAL:Function_call_interrupts
      1331 ±  5%     +18.1%       1573        interrupts.CPU56.CAL:Function_call_interrupts
      1378 ±  7%     +14.8%       1581 ±  5%  interrupts.CPU57.CAL:Function_call_interrupts
      1346 ±  6%     +17.9%       1588 ±  4%  interrupts.CPU58.CAL:Function_call_interrupts
      1319 ±  4%     +22.5%       1615 ±  6%  interrupts.CPU59.CAL:Function_call_interrupts
      1328 ± 16%    +241.7%       4538 ± 32%  interrupts.CPU6.CAL:Function_call_interrupts
     99442            +9.7%     109071 ±  2%  interrupts.CPU6.LOC:Local_timer_interrupts
      1367 ±  6%     +19.7%       1636 ±  7%  interrupts.CPU62.CAL:Function_call_interrupts
      1340 ±  4%     +18.8%       1591 ±  5%  interrupts.CPU63.CAL:Function_call_interrupts
      1352 ±  5%     +18.4%       1601 ±  5%  interrupts.CPU64.CAL:Function_call_interrupts
      1339 ±  5%     +16.3%       1557 ±  6%  interrupts.CPU68.CAL:Function_call_interrupts
      1363 ±  8%     +21.4%       1654 ±  9%  interrupts.CPU69.CAL:Function_call_interrupts
      1451 ± 13%    +222.2%       4677 ± 32%  interrupts.CPU7.CAL:Function_call_interrupts
      1341 ±  6%     +20.5%       1616 ±  6%  interrupts.CPU70.CAL:Function_call_interrupts
      1337 ±  6%     +16.8%       1562 ±  3%  interrupts.CPU71.CAL:Function_call_interrupts
    458.17 ±  5%     +59.8%     732.33 ± 51%  interrupts.CPU72.RES:Rescheduling_interrupts
    458.17 ±  7%     +75.6%     804.67 ± 60%  interrupts.CPU73.RES:Rescheduling_interrupts
      1387 ±  7%     +83.6%       2547 ± 58%  interrupts.CPU74.CAL:Function_call_interrupts
    450.50 ±  6%     +74.0%     783.83 ± 54%  interrupts.CPU74.RES:Rescheduling_interrupts
      1312 ± 12%     +94.1%       2547 ± 58%  interrupts.CPU75.CAL:Function_call_interrupts
    451.00 ±  2%     +71.7%     774.50 ± 50%  interrupts.CPU75.RES:Rescheduling_interrupts
      1356 ±  5%     +95.6%       2652 ± 60%  interrupts.CPU76.CAL:Function_call_interrupts
      1417 ±  6%     +86.7%       2645 ± 67%  interrupts.CPU77.CAL:Function_call_interrupts
      1403 ±  9%     +76.1%       2471 ± 56%  interrupts.CPU78.CAL:Function_call_interrupts
      1368 ±  7%     +90.9%       2611 ± 66%  interrupts.CPU79.CAL:Function_call_interrupts
      1331 ±  7%    +249.3%       4651 ± 36%  interrupts.CPU8.CAL:Function_call_interrupts
    478.67 ±  4%     +56.4%     748.50 ± 51%  interrupts.CPU80.RES:Rescheduling_interrupts
    447.33 ±  7%     +80.6%     807.67 ± 56%  interrupts.CPU82.RES:Rescheduling_interrupts
    469.00 ±  6%     +58.5%     743.17 ± 47%  interrupts.CPU83.RES:Rescheduling_interrupts
      1405 ±  7%     +73.9%       2443 ± 55%  interrupts.CPU84.CAL:Function_call_interrupts
      1389 ±  8%     +75.5%       2439 ± 55%  interrupts.CPU85.CAL:Function_call_interrupts
    459.67 ±  5%     +68.3%     773.67 ± 53%  interrupts.CPU85.RES:Rescheduling_interrupts
      1390 ±  6%     +77.9%       2474 ± 54%  interrupts.CPU86.CAL:Function_call_interrupts
      1441 ± 11%     +75.2%       2525 ± 51%  interrupts.CPU87.CAL:Function_call_interrupts
      1325 ±  6%     +89.6%       2513 ± 56%  interrupts.CPU88.CAL:Function_call_interrupts
      1341 ± 10%     +92.9%       2586 ± 61%  interrupts.CPU89.CAL:Function_call_interrupts
    444.50 ±  2%     +83.6%     816.00 ± 57%  interrupts.CPU89.RES:Rescheduling_interrupts
      1437 ±  8%    +214.2%       4516 ± 34%  interrupts.CPU9.CAL:Function_call_interrupts
    440.00 ±  6%     +78.7%     786.33 ± 54%  interrupts.CPU90.RES:Rescheduling_interrupts
    456.00 ±  8%     +67.7%     764.83 ± 50%  interrupts.CPU93.RES:Rescheduling_interrupts
      1385 ±  5%     +77.5%       2459 ± 59%  interrupts.CPU94.CAL:Function_call_interrupts
    461.33 ±  8%     +68.9%     779.17 ± 54%  interrupts.CPU94.RES:Rescheduling_interrupts
      1383 ±  6%    +248.1%       4814 ± 35%  interrupts.CPU96.CAL:Function_call_interrupts
    449.67 ±  7%    +204.6%       1369 ± 31%  interrupts.CPU96.RES:Rescheduling_interrupts
      1341 ±  5%    +257.2%       4792 ± 34%  interrupts.CPU97.CAL:Function_call_interrupts
    462.67 ±  8%    +187.0%       1327 ± 31%  interrupts.CPU97.RES:Rescheduling_interrupts
      1298 ±  5%    +290.5%       5069 ± 33%  interrupts.CPU98.CAL:Function_call_interrupts
     99241            +9.1%     108246 ±  2%  interrupts.CPU98.LOC:Local_timer_interrupts
    469.00 ±  6%    +198.9%       1402 ± 30%  interrupts.CPU98.RES:Rescheduling_interrupts
      1319 ±  9%    +248.3%       4594 ± 30%  interrupts.CPU99.CAL:Function_call_interrupts
     99835            +9.5%     109306 ±  2%  interrupts.CPU99.LOC:Local_timer_interrupts
    468.00 ±  7%    +177.7%       1299 ± 24%  interrupts.CPU99.RES:Rescheduling_interrupts
     90232           +65.4%     149244        interrupts.RES:Rescheduling_interrupts



***************************************************************************************************
lkp-skl-fpga01: 104 threads 2 sockets Skylake with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/process/100%/debian-10.4-x86_64-20200603.cgz/lkp-skl-fpga01/fallocate2/will-it-scale/0x2006a0a

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   2088046 ±  2%     -29.8%    1466118 ±  5%  will-it-scale.104.processes
     20076 ±  2%     -29.8%      14096 ±  5%  will-it-scale.per_process_ops
   2088046 ±  2%     -29.8%    1466118 ±  5%  will-it-scale.workload
     27085 ±  5%     +44.5%      39144 ±  4%  cpuidle..usage
      0.07 ±  2%      -0.0        0.04 ±  7%  mpstat.cpu.all.soft%
      0.80 ±  2%      -0.2        0.59 ±  4%  mpstat.cpu.all.usr%
      1936          +339.0%       8502        vmstat.system.cs
    103216            +3.2%     106490        vmstat.system.in
 3.057e+08 ±  5%     -33.1%  2.046e+08 ±  9%  numa-vmstat.node0.numa_hit
 3.062e+08 ±  5%     -33.1%  2.048e+08 ±  9%  numa-vmstat.node0.numa_local
 3.177e+08 ±  3%     -26.5%  2.334e+08 ±  5%  numa-vmstat.node1.numa_hit
  3.18e+08 ±  3%     -26.5%  2.336e+08 ±  5%  numa-vmstat.node1.numa_local
     70268 ±  2%     -15.6%      59296 ±  3%  slabinfo.radix_tree_node.active_objs
      1254 ±  2%     -15.6%       1058 ±  3%  slabinfo.radix_tree_node.active_slabs
     70268 ±  2%     -15.6%      59296 ±  3%  slabinfo.radix_tree_node.num_objs
      1254 ±  2%     -15.6%       1058 ±  3%  slabinfo.radix_tree_node.num_slabs
      1206 ±126%    +396.1%       5983 ± 25%  turbostat.C1
      3452 ±  8%     +88.7%       6512 ±  5%  turbostat.C1E
     17274 ±  6%     +15.4%      19928 ±  2%  turbostat.C6
    112.75            +3.3%     116.50        turbostat.RAMWatt
 6.174e+08 ±  5%     -33.2%  4.124e+08 ±  9%  numa-numastat.node0.local_node
 6.163e+08 ±  5%     -33.1%  4.121e+08 ±  9%  numa-numastat.node0.numa_hit
     43.83 ± 32%     -87.5%       5.50 ± 98%  numa-numastat.node0.other_node
 6.417e+08 ±  3%     -26.7%  4.705e+08 ±  5%  numa-numastat.node1.local_node
  6.41e+08 ±  3%     -26.7%  4.701e+08 ±  5%  numa-numastat.node1.numa_hit
    670.67            -8.9%     610.67        proc-vmstat.nr_active_anon
     18759            -2.5%      18281        proc-vmstat.nr_shmem
     32737            -4.8%      31179        proc-vmstat.nr_slab_reclaimable
    670.67            -8.9%     610.67        proc-vmstat.nr_zone_active_anon
 1.257e+09 ±  2%     -29.8%  8.822e+08 ±  5%  proc-vmstat.numa_hit
 1.259e+09 ±  2%     -29.9%   8.83e+08 ±  5%  proc-vmstat.numa_local
 1.256e+09 ±  2%     -29.8%  8.817e+08 ±  5%  proc-vmstat.pgalloc_normal
 1.256e+09 ±  2%     -29.8%  8.817e+08 ±  5%  proc-vmstat.pgfree
     44687 ±  3%   +1022.3%     501516 ±  4%  interrupts.CAL:Function_call_interrupts
    633.33           +35.2%     856.50 ± 12%  interrupts.CPU0.RES:Rescheduling_interrupts
     85.17 ± 61%    +256.9%     304.00 ± 33%  interrupts.CPU1.RES:Rescheduling_interrupts
    445.33 ± 20%     -36.7%     282.00 ±  3%  interrupts.CPU10.CAL:Function_call_interrupts
    381.17 ± 18%     -24.0%     289.67 ±  7%  interrupts.CPU101.CAL:Function_call_interrupts
    156.17 ± 84%     -90.5%      14.83 ±121%  interrupts.CPU101.RES:Rescheduling_interrupts
    426.83 ± 30%     -33.0%     285.83        interrupts.CPU11.CAL:Function_call_interrupts
     99.17 ± 71%    +328.4%     424.83 ± 36%  interrupts.CPU11.RES:Rescheduling_interrupts
     90.00 ± 47%    +329.3%     386.33 ± 31%  interrupts.CPU12.RES:Rescheduling_interrupts
    347.33 ± 12%     -19.0%     281.17 ±  3%  interrupts.CPU13.CAL:Function_call_interrupts
    101.17 ± 58%    +189.1%     292.50 ± 42%  interrupts.CPU13.RES:Rescheduling_interrupts
    532.50 ± 28%     -45.8%     288.50 ±  7%  interrupts.CPU14.CAL:Function_call_interrupts
     84.00 ± 69%    +307.7%     342.50 ± 32%  interrupts.CPU14.RES:Rescheduling_interrupts
    459.83 ± 47%     -39.8%     277.00 ±  3%  interrupts.CPU15.CAL:Function_call_interrupts
     51.83 ± 34%    +475.6%     298.33 ± 40%  interrupts.CPU15.RES:Rescheduling_interrupts
     89.33 ± 30%    +262.1%     323.50 ± 30%  interrupts.CPU16.RES:Rescheduling_interrupts
    435.33 ± 41%     -36.6%     276.17 ±  2%  interrupts.CPU18.CAL:Function_call_interrupts
     95.33 ± 84%    +211.4%     296.83 ± 32%  interrupts.CPU18.RES:Rescheduling_interrupts
     95.50 ± 40%    +196.9%     283.50 ± 26%  interrupts.CPU19.RES:Rescheduling_interrupts
     61.33 ± 27%    +387.2%     298.83 ± 26%  interrupts.CPU2.RES:Rescheduling_interrupts
     59.00 ± 45%    +320.3%     248.00 ± 22%  interrupts.CPU20.RES:Rescheduling_interrupts
    120.67 ± 86%    +210.9%     375.17 ± 25%  interrupts.CPU21.RES:Rescheduling_interrupts
    152.50 ± 77%    +151.7%     383.83 ± 27%  interrupts.CPU22.RES:Rescheduling_interrupts
     77.83 ± 65%    +394.2%     384.67 ± 11%  interrupts.CPU23.RES:Rescheduling_interrupts
     97.67 ± 91%    +232.4%     324.67 ± 27%  interrupts.CPU24.RES:Rescheduling_interrupts
     77.00 ± 64%    +298.5%     306.83 ± 38%  interrupts.CPU25.RES:Rescheduling_interrupts
     51.83 ± 76%     -84.6%       8.00 ± 61%  interrupts.CPU26.RES:Rescheduling_interrupts
     82.00 ± 28%    +316.3%     341.33 ± 31%  interrupts.CPU3.RES:Rescheduling_interrupts
    466.17 ± 28%     -38.3%     287.67 ±  4%  interrupts.CPU32.CAL:Function_call_interrupts
    426.33 ± 22%     -30.4%     296.83 ±  7%  interrupts.CPU33.CAL:Function_call_interrupts
    132.33 ±126%     -83.4%      22.00 ± 91%  interrupts.CPU36.RES:Rescheduling_interrupts
    506.50 ± 34%     -41.2%     297.67 ±  6%  interrupts.CPU37.CAL:Function_call_interrupts
    453.17 ± 55%     -37.0%     285.50 ±  6%  interrupts.CPU4.CAL:Function_call_interrupts
     77.67 ± 28%    +382.2%     374.50 ± 26%  interrupts.CPU4.RES:Rescheduling_interrupts
    118.33 ± 79%     -84.2%      18.67 ± 76%  interrupts.CPU42.RES:Rescheduling_interrupts
    414.83 ± 23%     -30.7%     287.67 ±  3%  interrupts.CPU45.CAL:Function_call_interrupts
    382.50 ± 13%     -27.1%     279.00 ±  4%  interrupts.CPU49.CAL:Function_call_interrupts
    124.00 ± 42%     -91.3%      10.83 ± 62%  interrupts.CPU49.RES:Rescheduling_interrupts
     94.50 ± 49%    +378.7%     452.33 ± 36%  interrupts.CPU52.RES:Rescheduling_interrupts
    328.33 ±  8%     -16.9%     272.83 ±  2%  interrupts.CPU53.CAL:Function_call_interrupts
     63.33 ± 17%    +401.3%     317.50 ± 28%  interrupts.CPU53.RES:Rescheduling_interrupts
    358.00 ± 10%     -20.4%     285.00 ±  3%  interrupts.CPU54.CAL:Function_call_interrupts
     99.67 ± 44%    +257.5%     356.33 ± 44%  interrupts.CPU54.RES:Rescheduling_interrupts
    336.00 ±  9%     -15.2%     285.00 ±  4%  interrupts.CPU55.CAL:Function_call_interrupts
     60.83 ± 27%    +474.8%     349.67 ± 22%  interrupts.CPU55.RES:Rescheduling_interrupts
    388.67 ± 18%     -27.1%     283.33 ±  7%  interrupts.CPU56.CAL:Function_call_interrupts
     85.33 ± 33%    +289.5%     332.33 ± 19%  interrupts.CPU56.RES:Rescheduling_interrupts
    114.83 ± 85%    +241.4%     392.00 ± 20%  interrupts.CPU57.RES:Rescheduling_interrupts
    474.67 ± 20%     -40.6%     282.17 ±  4%  interrupts.CPU58.CAL:Function_call_interrupts
    146.67 ± 39%    +136.2%     346.50 ± 34%  interrupts.CPU58.RES:Rescheduling_interrupts
    395.83 ± 18%     -22.9%     305.17 ±  8%  interrupts.CPU6.CAL:Function_call_interrupts
    112.67 ± 53%    +222.3%     363.17 ± 24%  interrupts.CPU6.RES:Rescheduling_interrupts
    401.50 ± 27%     -31.1%     276.83 ±  5%  interrupts.CPU60.CAL:Function_call_interrupts
     65.00 ± 25%    +379.5%     311.67 ± 45%  interrupts.CPU60.RES:Rescheduling_interrupts
    423.17 ± 18%     -30.3%     295.00 ± 11%  interrupts.CPU61.CAL:Function_call_interrupts
    177.83 ± 79%    +148.0%     441.00 ± 61%  interrupts.CPU61.RES:Rescheduling_interrupts
    458.83 ± 25%     -37.5%     286.67 ±  4%  interrupts.CPU62.CAL:Function_call_interrupts
    146.33 ± 65%    +138.7%     349.33 ± 29%  interrupts.CPU62.RES:Rescheduling_interrupts
     93.50 ± 17%    +323.7%     396.17 ± 27%  interrupts.CPU63.RES:Rescheduling_interrupts
    484.50 ± 21%     -40.8%     286.67 ±  4%  interrupts.CPU64.CAL:Function_call_interrupts
    113.17 ± 37%    +243.4%     388.67 ± 25%  interrupts.CPU64.RES:Rescheduling_interrupts
    377.50 ± 17%     -20.8%     298.83 ±  3%  interrupts.CPU65.CAL:Function_call_interrupts
     82.83 ± 37%    +493.4%     491.50 ± 32%  interrupts.CPU65.RES:Rescheduling_interrupts
    543.67 ± 32%     -49.5%     274.33        interrupts.CPU66.CAL:Function_call_interrupts
    481.83 ± 44%     -41.9%     280.17 ±  6%  interrupts.CPU67.CAL:Function_call_interrupts
     98.50 ± 68%    +234.7%     329.67 ± 33%  interrupts.CPU67.RES:Rescheduling_interrupts
    136.67 ± 51%    +212.7%     427.33 ± 39%  interrupts.CPU68.RES:Rescheduling_interrupts
    121.83 ± 27%    +297.7%     484.50 ± 37%  interrupts.CPU69.RES:Rescheduling_interrupts
    392.33 ± 21%     -27.3%     285.33 ±  5%  interrupts.CPU7.CAL:Function_call_interrupts
    393.67 ± 25%     -33.7%     260.83 ± 31%  interrupts.CPU70.CAL:Function_call_interrupts
    119.17 ± 63%    +232.0%     395.67 ± 23%  interrupts.CPU70.RES:Rescheduling_interrupts
     81.00 ± 34%    +401.0%     405.83 ± 48%  interrupts.CPU71.RES:Rescheduling_interrupts
     96.50 ± 32%    +295.2%     381.33 ± 45%  interrupts.CPU73.RES:Rescheduling_interrupts
    147.00 ± 60%    +183.7%     417.00 ± 33%  interrupts.CPU74.RES:Rescheduling_interrupts
     68.50 ± 19%    +375.9%     326.00 ± 38%  interrupts.CPU75.RES:Rescheduling_interrupts
     63.33 ± 29%    +582.1%     432.00 ± 36%  interrupts.CPU76.RES:Rescheduling_interrupts
     62.17 ± 46%    +540.5%     398.17 ± 63%  interrupts.CPU77.RES:Rescheduling_interrupts
    364.00 ±  7%     -22.2%     283.17 ±  5%  interrupts.CPU78.CAL:Function_call_interrupts
     71.83 ± 37%     -80.0%      14.33 ± 82%  interrupts.CPU78.RES:Rescheduling_interrupts
    188.50 ± 57%    +117.5%     410.00 ± 37%  interrupts.CPU8.RES:Rescheduling_interrupts
    484.50 ± 23%     -41.5%     283.50 ±  2%  interrupts.CPU84.CAL:Function_call_interrupts
    154.17 ±115%     -91.1%      13.67 ± 49%  interrupts.CPU84.RES:Rescheduling_interrupts
     95.50 ± 97%     -76.6%      22.33 ± 91%  interrupts.CPU85.RES:Rescheduling_interrupts
    507.83 ± 37%     -42.2%     293.50 ±  8%  interrupts.CPU88.CAL:Function_call_interrupts
    137.83 ± 58%     -74.8%      34.67 ±128%  interrupts.CPU88.RES:Rescheduling_interrupts
    463.83 ± 31%     -38.1%     287.17 ±  3%  interrupts.CPU89.CAL:Function_call_interrupts
    580.67 ± 40%     -49.7%     292.33 ±  7%  interrupts.CPU9.CAL:Function_call_interrupts
     91.50 ± 55%    +324.8%     388.67 ± 39%  interrupts.CPU9.RES:Rescheduling_interrupts
    467.83 ± 26%     -36.9%     295.17 ±  5%  interrupts.CPU91.CAL:Function_call_interrupts
    149.17 ± 49%     -84.0%      23.83 ± 75%  interrupts.CPU91.RES:Rescheduling_interrupts
    361.17 ± 10%     -19.5%     290.67 ±  6%  interrupts.CPU94.CAL:Function_call_interrupts
     94.17 ± 19%     -72.9%      25.50 ± 79%  interrupts.CPU94.RES:Rescheduling_interrupts
    502.67 ± 29%     -37.4%     314.83 ± 23%  interrupts.CPU97.CAL:Function_call_interrupts
     13860 ±  7%   +3974.9%     564808 ±  8%  interrupts.RES:Rescheduling_interrupts
     15188 ±  3%     -22.4%      11781 ±  4%  softirqs.CPU1.RCU
     14542 ±  3%     -24.0%      11052 ±  7%  softirqs.CPU10.RCU
     14615 ±  3%     -21.6%      11455 ±  4%  softirqs.CPU100.RCU
     14407 ±  2%     -18.1%      11798 ±  2%  softirqs.CPU101.RCU
     14286 ±  2%     -18.3%      11678 ±  5%  softirqs.CPU102.RCU
     14552 ±  3%     -19.2%      11760 ±  3%  softirqs.CPU103.RCU
     14871 ±  2%     -25.7%      11048 ±  5%  softirqs.CPU11.RCU
     14416 ±  3%     -22.7%      11140 ±  6%  softirqs.CPU12.RCU
     14662 ±  4%     -18.2%      11987 ± 10%  softirqs.CPU13.RCU
     14369 ±  3%     -22.3%      11163 ±  5%  softirqs.CPU15.RCU
     14480 ±  4%     -20.8%      11472 ±  5%  softirqs.CPU16.RCU
     14407 ±  4%     -23.4%      11037 ±  6%  softirqs.CPU17.RCU
     14188 ±  3%     -22.0%      11071 ±  6%  softirqs.CPU18.RCU
     14183 ±  4%     -22.4%      11000 ±  5%  softirqs.CPU19.RCU
     14938 ±  4%     -21.6%      11712 ±  7%  softirqs.CPU2.RCU
     14483 ±  2%     -23.5%      11076 ±  6%  softirqs.CPU20.RCU
     14372 ±  6%     -21.9%      11228 ±  7%  softirqs.CPU21.RCU
     14077 ±  4%     -20.5%      11185 ±  7%  softirqs.CPU22.RCU
     14268 ±  3%     -20.7%      11310 ±  7%  softirqs.CPU23.RCU
     14060 ±  4%     -20.0%      11245 ±  6%  softirqs.CPU24.RCU
     14346 ±  7%     -22.5%      11121 ±  6%  softirqs.CPU25.RCU
     14872 ±  2%     -27.8%      10732 ± 29%  softirqs.CPU26.RCU
     15425 ±  3%     -20.8%      12223 ±  4%  softirqs.CPU27.RCU
     15076 ±  3%     -20.1%      12043 ±  2%  softirqs.CPU28.RCU
     15135 ±  3%     -19.6%      12166        softirqs.CPU29.RCU
     14495 ±  3%     -21.1%      11433 ±  6%  softirqs.CPU3.RCU
     15070 ±  2%     -18.7%      12249 ±  4%  softirqs.CPU30.RCU
     14958 ±  4%     -20.4%      11908 ±  3%  softirqs.CPU31.RCU
     15297 ±  3%     -23.2%      11746 ±  2%  softirqs.CPU32.RCU
     15203 ±  5%     -20.0%      12168 ±  4%  softirqs.CPU33.RCU
     14952 ±  4%     -23.0%      11508 ±  3%  softirqs.CPU34.RCU
     14837 ±  2%     -21.6%      11628 ±  2%  softirqs.CPU35.RCU
     14769 ±  2%     -20.4%      11760 ±  4%  softirqs.CPU36.RCU
     15200 ±  7%     -22.7%      11747 ±  4%  softirqs.CPU37.RCU
     14682           -20.2%      11723 ±  5%  softirqs.CPU38.RCU
     14721 ±  3%     -20.1%      11764 ±  3%  softirqs.CPU39.RCU
     14563 ±  5%     -22.3%      11309 ±  5%  softirqs.CPU4.RCU
     14805 ±  3%     -21.2%      11672 ±  4%  softirqs.CPU40.RCU
     14981 ±  2%     -23.1%      11517 ±  3%  softirqs.CPU42.RCU
     14787 ±  4%     -22.1%      11515 ±  2%  softirqs.CPU43.RCU
     14971 ±  2%     -21.4%      11768 ±  4%  softirqs.CPU44.RCU
     14486 ±  2%     -29.1%      10267 ± 29%  softirqs.CPU45.RCU
     14452 ±  2%     -18.0%      11849 ±  8%  softirqs.CPU46.RCU
     14445 ±  2%     -16.9%      12002 ±  5%  softirqs.CPU47.RCU
     14444           -19.5%      11628 ±  2%  softirqs.CPU48.RCU
     14541 ±  2%     -36.3%       9259 ± 41%  softirqs.CPU49.RCU
     14591 ±  4%     -23.8%      11115 ±  5%  softirqs.CPU5.RCU
     14703           -21.5%      11538 ±  3%  softirqs.CPU50.RCU
     14641 ±  2%     -20.1%      11698 ±  3%  softirqs.CPU51.RCU
     14488 ±  4%     -22.6%      11218 ±  5%  softirqs.CPU52.RCU
     14401 ±  4%     -21.9%      11246 ±  5%  softirqs.CPU53.RCU
     14902 ±  6%     -26.1%      11012 ±  6%  softirqs.CPU54.RCU
     14624 ±  4%     -24.5%      11036 ±  7%  softirqs.CPU55.RCU
     14451 ±  4%     -24.3%      10932 ±  6%  softirqs.CPU56.RCU
     14637 ±  5%     -24.3%      11082 ±  7%  softirqs.CPU57.RCU
     14757 ±  3%     -23.6%      11272 ±  7%  softirqs.CPU58.RCU
     14685 ±  5%     -23.4%      11244 ±  5%  softirqs.CPU59.RCU
     14398 ±  4%     -20.6%      11431 ±  6%  softirqs.CPU6.RCU
     14508 ±  4%     -20.8%      11487 ±  7%  softirqs.CPU61.RCU
     15398 ± 13%     -25.8%      11430 ±  8%  softirqs.CPU62.RCU
     14973 ±  9%     -25.3%      11178 ±  7%  softirqs.CPU63.RCU
     14516 ±  4%     -23.4%      11121 ±  6%  softirqs.CPU64.RCU
     14323 ±  4%     -23.3%      10989 ±  6%  softirqs.CPU65.RCU
     14362 ±  4%     -22.1%      11189 ±  5%  softirqs.CPU66.RCU
     15049 ±  9%     -26.2%      11112 ±  5%  softirqs.CPU67.RCU
     14736 ±  6%     -25.5%      10985 ±  8%  softirqs.CPU68.RCU
     14975 ±  7%     -26.2%      11044 ±  7%  softirqs.CPU69.RCU
     14364 ±  4%     -20.5%      11419 ±  4%  softirqs.CPU7.RCU
     14456 ±  4%     -22.8%      11158 ±  6%  softirqs.CPU70.RCU
     14244 ±  3%     -23.1%      10956 ±  5%  softirqs.CPU71.RCU
     14245 ±  3%     -21.5%      11182 ±  6%  softirqs.CPU72.RCU
     14682 ±  4%     -24.4%      11102 ±  2%  softirqs.CPU73.RCU
     14350 ±  3%     -22.3%      11155 ±  3%  softirqs.CPU74.RCU
     14362 ±  3%     -24.0%      10908 ±  5%  softirqs.CPU75.RCU
     14362 ±  4%     -21.4%      11282 ±  6%  softirqs.CPU76.RCU
     14940 ± 11%     -24.2%      11328 ±  7%  softirqs.CPU77.RCU
     14848           -31.1%      10232 ± 28%  softirqs.CPU78.RCU
     14995 ±  3%     -21.6%      11752 ±  4%  softirqs.CPU79.RCU
     14442 ±  4%     -21.0%      11414 ±  8%  softirqs.CPU8.RCU
     15107 ±  2%     -22.0%      11780 ±  4%  softirqs.CPU80.RCU
     14991 ±  3%     -22.6%      11605 ±  5%  softirqs.CPU81.RCU
     15666 ± 10%     -26.0%      11596 ±  4%  softirqs.CPU82.RCU
     14982 ±  2%     -19.5%      12054 ±  4%  softirqs.CPU83.RCU
     14787 ±  2%     -21.0%      11687 ±  2%  softirqs.CPU84.RCU
     14755 ±  2%     -20.2%      11780        softirqs.CPU85.RCU
     14705 ±  2%     -29.1%      10430 ± 26%  softirqs.CPU86.RCU
     14787 ±  4%     -19.0%      11984 ±  2%  softirqs.CPU87.RCU
     15744 ±  8%     -23.9%      11977 ±  6%  softirqs.CPU89.RCU
     14812 ±  5%     -23.9%      11266 ±  9%  softirqs.CPU9.RCU
     14535 ±  3%     -19.8%      11653 ±  4%  softirqs.CPU90.RCU
     15089 ±  4%     -21.8%      11797 ±  4%  softirqs.CPU91.RCU
     14870 ±  2%     -22.1%      11588 ±  4%  softirqs.CPU92.RCU
     14644 ±  2%     -21.2%      11546 ±  4%  softirqs.CPU93.RCU
     14640 ±  2%     -18.2%      11981 ±  5%  softirqs.CPU94.RCU
     14905 ±  4%     -22.5%      11553 ±  3%  softirqs.CPU95.RCU
     14663           -20.7%      11625 ±  2%  softirqs.CPU96.RCU
     14527           -17.1%      12049 ±  5%  softirqs.CPU97.RCU
     14493           -20.1%      11574 ±  3%  softirqs.CPU98.RCU
      3771 ± 34%    +105.1%       7736 ± 73%  softirqs.NET_RX
   1529389           -21.9%    1194214 ±  3%  softirqs.RCU



***************************************************************************************************
lkp-csl-2sp6: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory
=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase/time_based/ucode:
  4k/gcc-9/performance/2pmem/xfs/mmap/x86_64-rhel-8.3/50%/debian-10.4-x86_64-20200603.cgz/200s/read/lkp-csl-2sp6/200G/fio-basic/tb/0x5003006

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.01            +0.0        0.04 ±  8%  fio.latency_1000us%
      0.02 ±  3%      -0.0        0.01        fio.latency_100us%
      2.33            +1.2        3.55 ±  2%  fio.latency_10us%
      0.43 ±  6%      +1.0        1.43 ± 13%  fio.latency_20us%
      0.68            -0.6        0.07 ± 13%  fio.latency_250us%
     11.97 ±  4%     -10.6        1.37 ± 12%  fio.latency_2us%
      4.66            -3.1        1.57 ±  9%  fio.latency_4us%
      0.76            +0.4        1.17 ±  2%  fio.latency_500us%
      0.03 ±  6%      +0.0        0.05 ± 18%  fio.latency_50us%
      0.09 ±  4%      +0.2        0.24 ± 13%  fio.latency_750us%
     18591           -20.5%      14775        fio.read_bw_MBps
      1669           -45.0%     918.67 ±  3%  fio.read_clat_90%_us
      3637           +67.7%       6101 ±  5%  fio.read_clat_95%_us
    238250           +62.5%     387072 ±  2%  fio.read_clat_99%_us
      9557           +25.1%      11957        fio.read_clat_mean_us
    215796           +12.5%     242714        fio.read_clat_stddev
   4759419           -20.5%    3782521        fio.read_iops
 7.616e+09           -20.5%  6.053e+09        fio.time.file_system_inputs
    682837           -21.8%     534027        fio.time.involuntary_context_switches
  14879662           -20.5%   11826133        fio.time.major_page_faults
  58692099           -20.5%   46676900        fio.time.minor_page_faults
      8631            +4.9%       9052        fio.time.system_time
    894.20           -44.7%     494.83 ±  2%  fio.time.user_time
  9.52e+08           -20.5%  7.566e+08        fio.workload
   1486581 ±  3%    +148.0%    3687424 ±  2%  cpuidle..usage
   3711818           -21.5%    2912747        meminfo.PageTables
     49.63            -1.9%      48.67        iostat.cpu.idle
     45.80            +6.5%      48.79        iostat.cpu.system
      4.57           -44.6%       2.53 ±  2%  iostat.cpu.user
      0.44            -0.1        0.33        mpstat.cpu.all.irq%
      0.06            -0.0        0.04        mpstat.cpu.all.soft%
      4.61            -2.1        2.55 ±  2%  mpstat.cpu.all.usr%
  18621814           -20.5%   14811749        vmstat.io.bi
      8895          +154.6%      22650        vmstat.system.cs
    439187           -13.5%     379872        vmstat.system.in
    503.17 ± 19%     +50.1%     755.33 ±  5%  slabinfo.biovec-max.active_objs
    504.17 ± 19%     +50.0%     756.00 ±  5%  slabinfo.biovec-max.num_objs
    275.50 ± 15%     +61.7%     445.50 ±  9%  slabinfo.kmalloc-cg-16.active_objs
    275.50 ± 15%     +61.7%     445.50 ±  9%  slabinfo.kmalloc-cg-16.num_objs
  17984086 ±  5%      +8.0%   19426910 ±  3%  numa-meminfo.node0.Inactive
  17767062 ±  5%      +8.0%   19193252 ±  3%  numa-meminfo.node0.Inactive(file)
  17679188 ±  5%      +8.0%   19100304 ±  3%  numa-meminfo.node0.Mapped
   1785742 ±  5%     -16.7%    1488053 ±  4%  numa-meminfo.node0.PageTables
   1931595 ±  4%     -25.5%    1439274 ±  3%  numa-meminfo.node1.PageTables
 4.423e+08 ±  3%     -17.9%  3.632e+08 ±  3%  numa-numastat.node0.local_node
  31920542 ± 37%     -54.7%   14445802 ± 37%  numa-numastat.node0.numa_foreign
  4.41e+08 ±  3%     -17.8%  3.624e+08 ±  3%  numa-numastat.node0.numa_hit
 4.669e+08           -22.7%  3.609e+08        numa-numastat.node1.local_node
 4.657e+08           -22.7%  3.602e+08        numa-numastat.node1.numa_hit
  31921822 ± 37%     -54.7%   14444762 ± 37%  numa-numastat.node1.numa_miss
  31928636 ± 37%     -54.7%   14460145 ± 37%  numa-numastat.node1.other_node
     27830 ±  5%    +296.1%     110241 ±  3%  turbostat.C1
      0.02            +0.0        0.07 ±  5%  turbostat.C1%
     54124         +1717.4%     983655 ±  6%  turbostat.C1E
      0.11 ±  4%      +0.6        0.68 ±  6%  turbostat.C1E%
   1372362 ±  4%     +86.2%    2554977        turbostat.C6
  1.75e+08           -15.4%  1.481e+08        turbostat.IRQ
    163.06            -4.9%     155.02        turbostat.RAMWatt
   4440379 ±  5%      +8.1%    4799488 ±  3%  numa-vmstat.node0.nr_inactive_file
   4414780 ±  5%      +8.2%    4776208 ±  3%  numa-vmstat.node0.nr_mapped
    446302 ±  5%     -16.6%     372111 ±  4%  numa-vmstat.node0.nr_page_table_pages
   4439497 ±  5%      +8.1%    4798972 ±  3%  numa-vmstat.node0.nr_zone_inactive_file
  19891167 ± 36%     -49.6%   10033181 ± 42%  numa-vmstat.node0.numa_foreign
  33407454 ±  6%     -20.9%   26410938 ±  5%  numa-vmstat.node0.workingset_refault_file
    248.33 ±  9%     -29.3%     175.50 ± 11%  numa-vmstat.node1.nr_isolated_file
    482761 ±  4%     -25.4%     359901 ±  3%  numa-vmstat.node1.nr_page_table_pages
 2.436e+08 ±  9%     -26.5%  1.792e+08        numa-vmstat.node1.numa_hit
 2.441e+08 ±  9%     -26.5%  1.795e+08        numa-vmstat.node1.numa_local
  19892370 ± 36%     -49.6%   10031888 ± 42%  numa-vmstat.node1.numa_miss
  19905321 ± 36%     -49.5%   10052308 ± 41%  numa-vmstat.node1.numa_other
  38105173 ±  3%     -28.7%   27160931 ±  3%  numa-vmstat.node1.workingset_refault_file
    380561           -21.7%     298026        proc-vmstat.allocstall_movable
     11702 ±  5%     -42.6%       6718 ±  4%  proc-vmstat.allocstall_normal
      9743 ±  2%     -26.2%       7192 ±  4%  proc-vmstat.compact_daemon_wake
     12423           -23.0%       9564        proc-vmstat.kswapd_low_wmark_hit_quickly
    946132            +2.1%     965912        proc-vmstat.nr_dirty_background_threshold
   1894578            +2.1%    1934188        proc-vmstat.nr_dirty_threshold
   9839407            +2.0%   10037760        proc-vmstat.nr_file_pages
   9240887            +2.1%    9439261        proc-vmstat.nr_inactive_file
    455.00 ±  4%     -20.9%     359.83 ±  7%  proc-vmstat.nr_isolated_file
   9183960            +2.0%    9365395        proc-vmstat.nr_mapped
    927261           -21.5%     727868        proc-vmstat.nr_page_table_pages
     54422            +1.6%      55292        proc-vmstat.nr_slab_unreclaimable
   9239985            +2.1%    9438430        proc-vmstat.nr_zone_inactive_file
  50193211 ±  2%     -25.0%   37634362 ±  4%  proc-vmstat.numa_foreign
 9.067e+08           -20.3%  7.226e+08        proc-vmstat.numa_hit
 9.092e+08           -20.4%  7.241e+08        proc-vmstat.numa_local
  50206301 ±  2%     -25.0%   37633961 ±  4%  proc-vmstat.numa_miss
  50211306 ±  2%     -25.0%   37654376 ±  4%  proc-vmstat.numa_other
     12426           -23.0%       9566        proc-vmstat.pageoutrun
  35353279           -20.2%   28222154        proc-vmstat.pgalloc_dma32
 9.192e+08           -20.5%  7.305e+08        proc-vmstat.pgalloc_normal
  89076596           -20.3%   70955687        proc-vmstat.pgfault
 9.466e+08           -20.7%  7.504e+08        proc-vmstat.pgfree
      2382 ± 16%     -43.3%       1351 ± 15%  proc-vmstat.pgmigrate_fail
 3.808e+09           -20.5%  3.027e+09        proc-vmstat.pgpgin
      1242 ± 12%     -87.1%     160.33 ± 25%  proc-vmstat.pgrotated
 8.992e+08           -20.6%  7.136e+08        proc-vmstat.pgscan_direct
 9.436e+08           -20.7%  7.478e+08        proc-vmstat.pgscan_file
  44448740 ±  2%     -22.9%   34259355 ±  5%  proc-vmstat.pgscan_kswapd
 8.992e+08           -20.6%  7.136e+08        proc-vmstat.pgsteal_direct
 9.436e+08           -20.7%  7.478e+08        proc-vmstat.pgsteal_file
  44447743 ±  2%     -22.9%   34258395 ±  5%  proc-vmstat.pgsteal_kswapd
    362245            -2.6%     352780        proc-vmstat.workingset_nodes
  71386315           -24.9%   53627661 ±  2%  proc-vmstat.workingset_refault_file
     30417 ± 14%    +103.2%      61818 ± 10%  softirqs.CPU0.SCHED
     13669 ± 25%    +173.4%      37373 ± 14%  softirqs.CPU1.SCHED
     10571 ±  7%     -35.3%       6842 ±  6%  softirqs.CPU10.RCU
      9944 ±  4%     -26.7%       7290 ±  8%  softirqs.CPU11.RCU
     10047 ±  2%     -30.0%       7028 ±  9%  softirqs.CPU12.RCU
     10530 ±  9%     -34.5%       6892 ±  7%  softirqs.CPU13.RCU
     10929 ± 11%     -36.1%       6989 ±  9%  softirqs.CPU14.RCU
     10842 ±  6%     -33.3%       7237 ± 14%  softirqs.CPU15.RCU
     10573 ±  7%     -26.3%       7791 ± 12%  softirqs.CPU16.RCU
     10791 ±  6%     -32.4%       7296 ±  6%  softirqs.CPU17.RCU
     10909 ±  5%     -34.1%       7190 ± 13%  softirqs.CPU18.RCU
     10548 ±  5%     -31.9%       7182 ±  9%  softirqs.CPU19.RCU
     10791 ± 18%    +126.0%      24389 ±  8%  softirqs.CPU2.SCHED
     10850 ±  4%     -37.3%       6802 ±  5%  softirqs.CPU20.RCU
     10989 ±  8%     -35.7%       7063 ± 10%  softirqs.CPU21.RCU
     10680 ±  4%     -39.5%       6460 ±  7%  softirqs.CPU22.RCU
     10584 ±  3%     -36.3%       6737 ±  5%  softirqs.CPU23.RCU
     10848 ± 15%     -39.4%       6579 ±  7%  softirqs.CPU24.RCU
     10717 ± 11%     -32.8%       7200 ± 10%  softirqs.CPU25.RCU
     10890 ±  6%     -39.8%       6552 ±  7%  softirqs.CPU26.RCU
     10144 ±  3%     -39.1%       6180 ±  7%  softirqs.CPU27.RCU
     10421 ± 12%     -39.5%       6309 ±  7%  softirqs.CPU28.RCU
     10541 ± 11%     -38.0%       6534 ±  7%  softirqs.CPU29.RCU
      6497 ±  6%    +136.4%      15362 ± 11%  softirqs.CPU3.SCHED
     10147 ±  7%     -37.1%       6381 ±  8%  softirqs.CPU30.RCU
     10066 ±  3%     -37.7%       6271 ±  6%  softirqs.CPU31.RCU
      9926 ±  4%     -31.8%       6774 ±  7%  softirqs.CPU32.RCU
     10128 ±  8%     -40.9%       5988 ±  6%  softirqs.CPU33.RCU
     10002           -36.5%       6356 ±  5%  softirqs.CPU34.RCU
      9831 ±  5%     -35.0%       6387 ±  7%  softirqs.CPU35.RCU
      9929 ±  5%     -36.7%       6284 ±  9%  softirqs.CPU36.RCU
      9625 ±  6%     -31.1%       6632 ±  9%  softirqs.CPU37.RCU
      9697 ±  2%     -35.9%       6219 ±  7%  softirqs.CPU38.RCU
      9785 ±  2%     -37.7%       6091 ±  8%  softirqs.CPU39.RCU
     10613 ±  6%     -22.0%       8280 ±  9%  softirqs.CPU4.RCU
      6906 ± 25%     +72.3%      11897 ± 20%  softirqs.CPU4.SCHED
      9591 ±  3%     -32.8%       6445 ±  5%  softirqs.CPU40.RCU
     10392 ±  6%     -42.4%       5988 ±  9%  softirqs.CPU41.RCU
      9357 ±  7%     -34.9%       6090 ±  7%  softirqs.CPU42.RCU
      9621 ±  4%     -37.3%       6029 ±  5%  softirqs.CPU43.RCU
      9479 ±  4%     -35.5%       6118 ±  3%  softirqs.CPU44.RCU
      9983 ± 11%     -40.6%       5925 ±  2%  softirqs.CPU45.RCU
      9386 ±  7%     -29.4%       6622 ± 16%  softirqs.CPU46.RCU
      9826 ±  5%     -35.8%       6307 ±  3%  softirqs.CPU47.RCU
      6035 ± 10%     +56.9%       9470 ± 14%  softirqs.CPU48.SCHED
      6265 ± 18%    +116.7%      13577 ± 20%  softirqs.CPU49.SCHED
     10356 ±  4%     -24.2%       7849 ±  8%  softirqs.CPU5.RCU
      6013 ± 13%    +153.5%      15246 ± 20%  softirqs.CPU50.SCHED
      5989 ± 26%    +116.7%      12978 ± 17%  softirqs.CPU51.SCHED
      4858 ± 19%     +80.7%       8777 ± 18%  softirqs.CPU54.SCHED
      5512 ± 22%     +68.5%       9289 ± 26%  softirqs.CPU57.SCHED
      5076 ± 22%     +93.0%       9800 ± 12%  softirqs.CPU58.SCHED
      5283 ± 14%     +84.6%       9753 ± 18%  softirqs.CPU59.SCHED
     10917 ±  5%     -32.0%       7423 ± 14%  softirqs.CPU6.RCU
      5427 ± 13%     +58.6%       8609 ± 23%  softirqs.CPU63.SCHED
     10294 ±  6%     -30.4%       7160 ±  5%  softirqs.CPU7.RCU
     10436 ±  4%     -30.2%       7283 ±  7%  softirqs.CPU8.RCU
     10199 ±  7%     -30.3%       7106 ±  7%  softirqs.CPU9.RCU
    657813           -26.5%     483765        softirqs.RCU
    507909           +42.1%     721610        softirqs.SCHED
  78650534           -16.6%   65615247        interrupts.CAL:Function_call_interrupts
    988858 ±  3%     -14.9%     841729 ±  6%  interrupts.CPU0.CAL:Function_call_interrupts
   1049528 ±  4%     -15.4%     887398 ±  6%  interrupts.CPU0.TLB:TLB_shootdowns
   1334049 ±  2%     -21.9%    1041359 ±  8%  interrupts.CPU1.CAL:Function_call_interrupts
    311.00 ±  7%     -21.6%     243.83 ± 10%  interrupts.CPU1.RES:Rescheduling_interrupts
   1432589 ±  2%     -22.8%    1105917 ±  8%  interrupts.CPU1.TLB:TLB_shootdowns
   1390885 ±  2%     -19.0%    1126751 ± 12%  interrupts.CPU10.CAL:Function_call_interrupts
   1499586 ±  2%     -19.5%    1206979 ± 12%  interrupts.CPU10.TLB:TLB_shootdowns
   1418858 ±  2%     -19.7%    1138727 ±  8%  interrupts.CPU11.CAL:Function_call_interrupts
    308.00 ±  6%     -32.5%     207.83 ± 16%  interrupts.CPU11.RES:Rescheduling_interrupts
   1529392 ±  2%     -20.3%    1218997 ±  9%  interrupts.CPU11.TLB:TLB_shootdowns
   1414243 ±  3%     -16.6%    1178945 ±  5%  interrupts.CPU12.CAL:Function_call_interrupts
    307.83 ±  8%     -38.8%     188.33 ±  4%  interrupts.CPU12.RES:Rescheduling_interrupts
   1527249 ±  3%     -17.4%    1261785 ±  5%  interrupts.CPU12.TLB:TLB_shootdowns
   1409129 ±  4%     -17.3%    1165829 ±  5%  interrupts.CPU13.CAL:Function_call_interrupts
    310.17 ±  6%     -38.7%     190.00 ±  6%  interrupts.CPU13.RES:Rescheduling_interrupts
   1521052 ±  4%     -18.0%    1247909 ±  5%  interrupts.CPU13.TLB:TLB_shootdowns
   1439233 ±  3%     -21.4%    1131648 ±  6%  interrupts.CPU14.CAL:Function_call_interrupts
    324.17 ±  8%     -42.9%     185.17 ±  8%  interrupts.CPU14.RES:Rescheduling_interrupts
   1555322 ±  4%     -22.1%    1211323 ±  6%  interrupts.CPU14.TLB:TLB_shootdowns
   1449053 ±  4%     -17.4%    1196752 ±  2%  interrupts.CPU15.CAL:Function_call_interrupts
   1566733 ±  3%     -18.1%    1282588 ±  2%  interrupts.CPU15.TLB:TLB_shootdowns
   1430567 ±  4%     -16.6%    1193802 ±  5%  interrupts.CPU16.CAL:Function_call_interrupts
    313.00 ±  6%     -37.4%     196.00 ± 14%  interrupts.CPU16.RES:Rescheduling_interrupts
   1546623 ±  4%     -17.3%    1279267 ±  5%  interrupts.CPU16.TLB:TLB_shootdowns
   1434433 ±  4%     -15.7%    1208905 ±  5%  interrupts.CPU17.CAL:Function_call_interrupts
    313.00 ±  8%     -41.0%     184.67 ±  7%  interrupts.CPU17.RES:Rescheduling_interrupts
   1551484 ±  4%     -16.5%    1296043 ±  5%  interrupts.CPU17.TLB:TLB_shootdowns
   1445252           -18.7%    1175666 ±  7%  interrupts.CPU18.CAL:Function_call_interrupts
    306.83 ±  6%     -38.1%     190.00 ±  5%  interrupts.CPU18.RES:Rescheduling_interrupts
   1564626           -19.4%    1261427 ±  7%  interrupts.CPU18.TLB:TLB_shootdowns
   1419537 ±  2%     -17.7%    1168024 ±  5%  interrupts.CPU19.CAL:Function_call_interrupts
    308.67 ±  7%     -38.6%     189.50 ±  7%  interrupts.CPU19.RES:Rescheduling_interrupts
   1536747 ±  2%     -18.6%    1250514 ±  5%  interrupts.CPU19.TLB:TLB_shootdowns
   1338470 ±  3%     -20.1%    1069965 ±  6%  interrupts.CPU2.CAL:Function_call_interrupts
   1439853 ±  3%     -20.9%    1139087 ±  6%  interrupts.CPU2.TLB:TLB_shootdowns
   1424763 ±  3%     -17.0%    1182036 ±  6%  interrupts.CPU20.CAL:Function_call_interrupts
    308.00 ±  8%     -37.5%     192.50 ±  4%  interrupts.CPU20.RES:Rescheduling_interrupts
   1541870 ±  3%     -17.8%    1267081 ±  6%  interrupts.CPU20.TLB:TLB_shootdowns
   1471426 ±  3%     -20.4%    1170980 ±  6%  interrupts.CPU21.CAL:Function_call_interrupts
    308.17 ± 10%     -35.8%     197.83 ±  9%  interrupts.CPU21.RES:Rescheduling_interrupts
   1594182 ±  3%     -21.1%    1257154 ±  6%  interrupts.CPU21.TLB:TLB_shootdowns
   1435799 ±  2%     -20.2%    1145135 ±  3%  interrupts.CPU22.CAL:Function_call_interrupts
    303.67 ±  7%     -40.6%     180.50 ±  7%  interrupts.CPU22.RES:Rescheduling_interrupts
   1555228 ±  2%     -21.0%    1228025 ±  3%  interrupts.CPU22.TLB:TLB_shootdowns
   1466708 ±  2%     -18.7%    1192024 ±  2%  interrupts.CPU23.CAL:Function_call_interrupts
    314.67 ±  7%     -40.5%     187.33 ±  4%  interrupts.CPU23.RES:Rescheduling_interrupts
   1589528 ±  2%     -19.5%    1279255 ±  2%  interrupts.CPU23.TLB:TLB_shootdowns
   1431127 ±  3%     -20.5%    1137256 ±  5%  interrupts.CPU24.CAL:Function_call_interrupts
    271.67 ±  3%     -35.7%     174.67 ± 11%  interrupts.CPU24.RES:Rescheduling_interrupts
   1553935 ±  3%     -21.2%    1224546 ±  5%  interrupts.CPU24.TLB:TLB_shootdowns
   1433507 ±  4%     -13.6%    1238841 ±  4%  interrupts.CPU25.CAL:Function_call_interrupts
    270.00 ±  4%     -39.6%     163.17 ± 13%  interrupts.CPU25.RES:Rescheduling_interrupts
   1555624 ±  4%     -14.2%    1334409 ±  4%  interrupts.CPU25.TLB:TLB_shootdowns
   1468743 ±  2%     -17.4%    1213301 ±  4%  interrupts.CPU26.CAL:Function_call_interrupts
    267.50 ±  4%     -37.3%     167.67 ±  6%  interrupts.CPU26.RES:Rescheduling_interrupts
   1592824 ±  2%     -17.9%    1307649 ±  4%  interrupts.CPU26.TLB:TLB_shootdowns
   1458323 ±  3%     -17.8%    1199225 ±  3%  interrupts.CPU27.CAL:Function_call_interrupts
    261.00 ±  3%     -39.8%     157.17 ±  9%  interrupts.CPU27.RES:Rescheduling_interrupts
   1582935 ±  3%     -18.4%    1292170 ±  3%  interrupts.CPU27.TLB:TLB_shootdowns
   1428512 ±  3%     -16.8%    1188963 ±  3%  interrupts.CPU28.CAL:Function_call_interrupts
    265.17 ±  5%     -37.3%     166.33 ±  5%  interrupts.CPU28.RES:Rescheduling_interrupts
   1550555 ±  3%     -17.6%    1278419 ±  3%  interrupts.CPU28.TLB:TLB_shootdowns
   1457355 ±  3%     -16.7%    1214406 ±  5%  interrupts.CPU29.CAL:Function_call_interrupts
    266.33 ±  3%     -39.2%     162.00 ±  7%  interrupts.CPU29.RES:Rescheduling_interrupts
   1582840 ±  4%     -17.4%    1307750 ±  6%  interrupts.CPU29.TLB:TLB_shootdowns
   1325204 ±  4%     -17.7%    1091164 ±  2%  interrupts.CPU3.CAL:Function_call_interrupts
    303.50 ±  5%     -34.0%     200.33 ±  7%  interrupts.CPU3.RES:Rescheduling_interrupts
   1424459 ±  4%     -18.2%    1164881 ±  2%  interrupts.CPU3.TLB:TLB_shootdowns
   1454064 ±  4%     -19.4%    1172155 ±  3%  interrupts.CPU30.CAL:Function_call_interrupts
    265.67 ±  4%     -35.6%     171.00 ±  8%  interrupts.CPU30.RES:Rescheduling_interrupts
   1579354 ±  4%     -20.1%    1261126 ±  3%  interrupts.CPU30.TLB:TLB_shootdowns
   1415837 ±  3%     -16.1%    1187663 ±  4%  interrupts.CPU31.CAL:Function_call_interrupts
    262.33 ±  5%     -39.3%     159.17 ±  6%  interrupts.CPU31.RES:Rescheduling_interrupts
   1535893 ±  4%     -16.9%    1276448 ±  5%  interrupts.CPU31.TLB:TLB_shootdowns
   1437703 ±  5%     -14.5%    1229555 ±  5%  interrupts.CPU32.CAL:Function_call_interrupts
    259.67 ±  3%     -31.3%     178.33 ±  8%  interrupts.CPU32.RES:Rescheduling_interrupts
   1560048 ±  5%     -15.1%    1324601 ±  5%  interrupts.CPU32.TLB:TLB_shootdowns
   1439956 ±  3%     -18.0%    1180837 ±  4%  interrupts.CPU33.CAL:Function_call_interrupts
    261.17 ±  6%     -34.3%     171.67 ±  8%  interrupts.CPU33.RES:Rescheduling_interrupts
   1564216 ±  3%     -18.7%    1271333 ±  4%  interrupts.CPU33.TLB:TLB_shootdowns
   1476314 ±  3%     -21.7%    1155912 ±  5%  interrupts.CPU34.CAL:Function_call_interrupts
    266.83 ±  5%     -37.4%     167.17 ± 10%  interrupts.CPU34.RES:Rescheduling_interrupts
   1603441 ±  2%     -22.5%    1243240 ±  5%  interrupts.CPU34.TLB:TLB_shootdowns
   1429134 ±  4%     -17.2%    1183314 ±  2%  interrupts.CPU35.CAL:Function_call_interrupts
    261.33 ±  3%     -38.6%     160.50 ±  4%  interrupts.CPU35.RES:Rescheduling_interrupts
   1551878 ±  4%     -18.1%    1271640 ±  2%  interrupts.CPU35.TLB:TLB_shootdowns
   1406381 ±  6%     -14.7%    1199533 ±  3%  interrupts.CPU36.CAL:Function_call_interrupts
    253.17 ±  6%     -32.8%     170.17 ±  7%  interrupts.CPU36.RES:Rescheduling_interrupts
   1525844 ±  5%     -15.4%    1290509 ±  4%  interrupts.CPU36.TLB:TLB_shootdowns
   1407224           -18.0%    1153322 ±  2%  interrupts.CPU37.CAL:Function_call_interrupts
    253.17 ±  5%     -33.4%     168.50 ± 10%  interrupts.CPU37.RES:Rescheduling_interrupts
   1527261           -18.8%    1239476 ±  2%  interrupts.CPU37.TLB:TLB_shootdowns
   1444605 ±  2%     -18.7%    1174607 ±  4%  interrupts.CPU38.CAL:Function_call_interrupts
    264.00 ±  6%     -39.6%     159.33 ±  7%  interrupts.CPU38.RES:Rescheduling_interrupts
   1570372 ±  2%     -19.5%    1263660 ±  4%  interrupts.CPU38.TLB:TLB_shootdowns
   1396988 ±  4%     -18.2%    1143157 ±  4%  interrupts.CPU39.CAL:Function_call_interrupts
    252.83 ±  7%     -36.1%     161.50 ±  7%  interrupts.CPU39.RES:Rescheduling_interrupts
   1516658 ±  3%     -19.2%    1226146 ±  4%  interrupts.CPU39.TLB:TLB_shootdowns
   1356025 ±  5%     -19.8%    1088038 ±  5%  interrupts.CPU4.CAL:Function_call_interrupts
    301.33 ±  7%     -30.0%     211.00 ± 12%  interrupts.CPU4.RES:Rescheduling_interrupts
   1460306 ±  5%     -20.5%    1161158 ±  5%  interrupts.CPU4.TLB:TLB_shootdowns
   1410219 ±  4%     -16.0%    1184073 ±  4%  interrupts.CPU40.CAL:Function_call_interrupts
    259.83 ±  8%     -39.1%     158.33 ±  3%  interrupts.CPU40.RES:Rescheduling_interrupts
   1533100 ±  4%     -16.9%    1273789 ±  4%  interrupts.CPU40.TLB:TLB_shootdowns
   1405516 ±  5%     -17.7%    1156352        interrupts.CPU41.CAL:Function_call_interrupts
    252.33 ±  9%     -35.9%     161.83 ± 11%  interrupts.CPU41.RES:Rescheduling_interrupts
   1527602 ±  5%     -18.7%    1241629        interrupts.CPU41.TLB:TLB_shootdowns
   1352056 ±  5%     -12.7%    1179830 ±  2%  interrupts.CPU42.CAL:Function_call_interrupts
    254.83 ±  8%     -34.3%     167.33 ±  7%  interrupts.CPU42.RES:Rescheduling_interrupts
   1468738 ±  5%     -13.7%    1267766 ±  2%  interrupts.CPU42.TLB:TLB_shootdowns
   1401031 ±  5%     -14.9%    1191900 ±  3%  interrupts.CPU43.CAL:Function_call_interrupts
    254.17 ±  7%     -37.9%     157.83 ±  9%  interrupts.CPU43.RES:Rescheduling_interrupts
   1520942 ±  5%     -15.7%    1282218 ±  3%  interrupts.CPU43.TLB:TLB_shootdowns
   1388453 ±  4%     -15.6%    1171886 ±  3%  interrupts.CPU44.CAL:Function_call_interrupts
    249.83 ±  8%     -35.3%     161.67 ±  6%  interrupts.CPU44.RES:Rescheduling_interrupts
   1508096 ±  4%     -16.4%    1260582 ±  3%  interrupts.CPU44.TLB:TLB_shootdowns
    253.50 ±  8%     -39.8%     152.67 ±  9%  interrupts.CPU45.RES:Rescheduling_interrupts
   1365517 ±  6%     -13.3%    1183501 ±  3%  interrupts.CPU46.CAL:Function_call_interrupts
    248.00 ±  8%     -36.9%     156.50 ±  6%  interrupts.CPU46.RES:Rescheduling_interrupts
   1483742 ±  6%     -14.3%    1271569 ±  3%  interrupts.CPU46.TLB:TLB_shootdowns
   1364673 ±  4%     -18.5%    1111981 ±  7%  interrupts.CPU47.CAL:Function_call_interrupts
   1483542 ±  4%     -19.5%    1194517 ±  7%  interrupts.CPU47.TLB:TLB_shootdowns
    662922 ± 12%     -24.0%     503833 ± 10%  interrupts.CPU48.CAL:Function_call_interrupts
    174.00 ± 13%     -22.2%     135.33 ± 15%  interrupts.CPU48.RES:Rescheduling_interrupts
    718349 ± 12%     -24.5%     542164 ± 10%  interrupts.CPU48.TLB:TLB_shootdowns
     71091 ± 12%     +35.7%      96498 ±  8%  interrupts.CPU49.LOC:Local_timer_interrupts
   1409966 ±  3%     -21.2%    1110773        interrupts.CPU5.CAL:Function_call_interrupts
    314.67 ±  6%     -40.3%     188.00 ±  9%  interrupts.CPU5.RES:Rescheduling_interrupts
   1517779 ±  3%     -21.9%    1185956        interrupts.CPU5.TLB:TLB_shootdowns
     69197 ± 15%     +33.7%      92518 ±  7%  interrupts.CPU50.LOC:Local_timer_interrupts
     68632 ± 12%     +28.6%      88287 ±  9%  interrupts.CPU51.LOC:Local_timer_interrupts
     59430 ± 12%     +48.6%      88319 ±  5%  interrupts.CPU52.LOC:Local_timer_interrupts
     51452 ± 13%     +63.5%      84137 ±  6%  interrupts.CPU53.LOC:Local_timer_interrupts
     51703 ± 11%     +62.5%      84010 ± 16%  interrupts.CPU54.LOC:Local_timer_interrupts
     63465 ± 10%     +28.4%      81460 ±  9%  interrupts.CPU55.LOC:Local_timer_interrupts
     56380 ± 23%     +55.2%      87501 ±  8%  interrupts.CPU56.LOC:Local_timer_interrupts
     57485 ± 22%     +36.1%      78226 ± 16%  interrupts.CPU57.LOC:Local_timer_interrupts
     56560 ± 12%     +48.5%      83990 ± 19%  interrupts.CPU58.LOC:Local_timer_interrupts
     56164 ± 13%     +56.2%      87712 ± 19%  interrupts.CPU59.LOC:Local_timer_interrupts
   1430835 ±  3%     -23.3%    1097317 ±  7%  interrupts.CPU6.CAL:Function_call_interrupts
    318.67 ±  7%     -37.8%     198.33 ± 15%  interrupts.CPU6.RES:Rescheduling_interrupts
   1542877 ±  3%     -24.0%    1172358 ±  8%  interrupts.CPU6.TLB:TLB_shootdowns
     55544 ± 16%     +43.1%      79503 ± 12%  interrupts.CPU60.LOC:Local_timer_interrupts
     54663 ± 13%     +42.1%      77655 ± 18%  interrupts.CPU61.LOC:Local_timer_interrupts
     45684 ± 32%     +66.6%      76094 ± 17%  interrupts.CPU62.LOC:Local_timer_interrupts
     55445 ± 19%     +24.1%      68823 ±  7%  interrupts.CPU63.LOC:Local_timer_interrupts
     46302 ± 26%     +56.7%      72570 ± 22%  interrupts.CPU64.LOC:Local_timer_interrupts
     42591 ± 20%     +60.0%      68132 ± 21%  interrupts.CPU66.LOC:Local_timer_interrupts
     43020 ± 15%     +56.4%      67302 ± 10%  interrupts.CPU67.LOC:Local_timer_interrupts
   1350753 ±  4%     -17.6%    1113032 ±  5%  interrupts.CPU7.CAL:Function_call_interrupts
    302.50 ±  6%     -37.4%     189.50 ± 13%  interrupts.CPU7.RES:Rescheduling_interrupts
   1454116 ±  4%     -18.3%    1188584 ±  5%  interrupts.CPU7.TLB:TLB_shootdowns
     48307 ± 27%     +40.5%      67894 ±  7%  interrupts.CPU70.LOC:Local_timer_interrupts
     56662 ± 11%     +33.2%      75478 ± 13%  interrupts.CPU72.LOC:Local_timer_interrupts
     53173 ± 15%     +33.7%      71082 ± 16%  interrupts.CPU74.LOC:Local_timer_interrupts
     62.83 ± 25%    +115.6%     135.50 ± 28%  interrupts.CPU74.RES:Rescheduling_interrupts
     47427 ± 20%     +52.0%      72088 ±  8%  interrupts.CPU75.LOC:Local_timer_interrupts
     63.17 ± 21%    +106.6%     130.50 ± 35%  interrupts.CPU75.RES:Rescheduling_interrupts
     51703 ± 11%     +53.3%      79238 ±  8%  interrupts.CPU76.LOC:Local_timer_interrupts
     58.50 ± 23%    +139.0%     139.83 ± 29%  interrupts.CPU76.RES:Rescheduling_interrupts
     48.17 ± 13%    +140.8%     116.00 ± 41%  interrupts.CPU77.RES:Rescheduling_interrupts
     64.00 ± 13%    +121.9%     142.00 ± 36%  interrupts.CPU79.RES:Rescheduling_interrupts
   1406043 ±  2%     -20.5%    1117455 ±  7%  interrupts.CPU8.CAL:Function_call_interrupts
    307.17 ±  7%     -34.8%     200.17 ±  8%  interrupts.CPU8.RES:Rescheduling_interrupts
   1516350 ±  2%     -21.2%    1195355 ±  7%  interrupts.CPU8.TLB:TLB_shootdowns
     50.50 ±  9%     +97.4%      99.67 ± 27%  interrupts.CPU81.RES:Rescheduling_interrupts
     45196 ± 10%     +30.2%      58849 ± 22%  interrupts.CPU89.LOC:Local_timer_interrupts
   1400891 ±  7%     -18.5%    1141448 ±  9%  interrupts.CPU9.CAL:Function_call_interrupts
    303.33 ±  7%     -31.8%     207.00 ±  6%  interrupts.CPU9.RES:Rescheduling_interrupts
   1510923 ±  7%     -19.1%    1222700 ±  9%  interrupts.CPU9.TLB:TLB_shootdowns
  85262776           -17.3%   70528541        interrupts.TLB:TLB_shootdowns



***************************************************************************************************
lkp-ivb-2ep1: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/process/50%/debian-10.4-x86_64-20200603.cgz/lkp-ivb-2ep1/page_fault3/will-it-scale/0x42e

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  20026054            -9.2%   18192748        will-it-scale.24.processes
     49.30            -4.4%      47.15        will-it-scale.24.processes_idle
    834418            -9.2%     758030        will-it-scale.per_process_ops
  20026054            -9.2%   18192748        will-it-scale.workload
      1643            +1.7%       1671        boot-time.idle
      1264 ±  3%   +2506.3%      32948        vmstat.system.cs
      0.04 ±  3%      -0.0        0.04 ±  3%  mpstat.cpu.all.soft%
     33.28            +3.4       36.73        mpstat.cpu.all.sys%
   6697099            -9.1%    6089215 ±  3%  numa-numastat.node0.local_node
   6729005            -9.1%    6117714 ±  3%  numa-numastat.node0.numa_hit
    100607 ±  5%   +7365.6%    7510975 ± 42%  turbostat.C1
      0.02            +2.6        2.64 ± 38%  turbostat.C1%
     23.26            +3.6%      24.10        turbostat.RAMWatt
     51483           +27.9%      65867 ± 18%  interrupts.CAL:Function_call_interrupts
    732.67 ± 12%    +128.3%       1672 ± 25%  interrupts.CPU0.CAL:Function_call_interrupts
    123.00 ± 35%     +85.9%     228.67 ± 27%  interrupts.CPU19.RES:Rescheduling_interrupts
    137.17 ± 38%     +65.5%     227.00 ± 20%  interrupts.CPU30.RES:Rescheduling_interrupts
    988.83 ±  8%     +50.6%       1489 ± 31%  interrupts.CPU34.CAL:Function_call_interrupts
     81.50 ± 65%    +175.9%     224.83 ± 49%  interrupts.CPU38.RES:Rescheduling_interrupts
    980.17 ±  5%     +27.8%       1252 ± 21%  interrupts.CPU43.CAL:Function_call_interrupts
    158.83 ± 41%    +211.1%     494.17 ± 74%  interrupts.CPU8.RES:Rescheduling_interrupts
     48.67 ± 20%    +126.7%     110.33 ±  7%  interrupts.IWI:IRQ_work_interrupts
      8584           +84.5%      15840 ±  7%  interrupts.RES:Rescheduling_interrupts
    422.67 ± 12%     +73.2%     732.00 ± 14%  interrupts.TLB:TLB_shootdowns
    794314            +2.5%     814404        proc-vmstat.nr_active_anon
   1438636            +1.5%    1459995        proc-vmstat.nr_file_pages
     65358            +2.3%      66843        proc-vmstat.nr_inactive_anon
    797612            +2.7%     818972        proc-vmstat.nr_shmem
    794314            +2.5%     814404        proc-vmstat.nr_zone_active_anon
     65358            +2.3%      66843        proc-vmstat.nr_zone_inactive_anon
  13454807            -7.9%   12398029        proc-vmstat.numa_hit
  13412580            -7.9%   12356302        proc-vmstat.numa_local
    810871            +3.7%     840819        proc-vmstat.pgactivate
  13458718            -7.8%   12403835        proc-vmstat.pgalloc_normal
 6.024e+09            -9.2%  5.472e+09        proc-vmstat.pgfault
  13470733            -8.1%   12383043        proc-vmstat.pgfree
     15908 ± 19%     -41.2%       9349 ± 12%  softirqs.CPU0.RCU
     19265 ± 21%     -55.8%       8522 ± 26%  softirqs.CPU1.RCU
     15999 ± 23%     -52.2%       7640 ± 20%  softirqs.CPU10.RCU
     19017 ± 18%     -59.4%       7717 ± 26%  softirqs.CPU11.RCU
     12663 ± 26%     -53.2%       5926 ± 13%  softirqs.CPU12.RCU
     14585 ± 27%     -59.3%       5939 ± 12%  softirqs.CPU13.RCU
     16228 ± 18%     -65.9%       5528 ±  9%  softirqs.CPU14.RCU
     15967 ± 22%     -63.7%       5788 ± 13%  softirqs.CPU15.RCU
     16060 ± 23%     -60.1%       6409 ± 17%  softirqs.CPU16.RCU
     15778 ± 18%     -55.7%       6995 ± 14%  softirqs.CPU17.RCU
     14621 ± 29%     -58.9%       6016 ± 17%  softirqs.CPU18.RCU
     13909 ± 23%     -54.1%       6380 ± 16%  softirqs.CPU19.RCU
     18169 ± 12%     -49.1%       9256 ± 28%  softirqs.CPU2.RCU
     16791 ± 41%     -61.3%       6496 ± 16%  softirqs.CPU20.RCU
     15333 ± 24%     -58.2%       6415 ±  9%  softirqs.CPU21.RCU
     17348 ± 25%     -62.3%       6536 ± 14%  softirqs.CPU22.RCU
     14493 ± 27%     -59.0%       5945 ± 13%  softirqs.CPU23.RCU
     19152 ± 25%     -60.3%       7595 ± 20%  softirqs.CPU24.RCU
     16181 ± 34%     -60.4%       6401 ± 19%  softirqs.CPU25.RCU
     18010 ± 25%     -56.9%       7760 ± 20%  softirqs.CPU26.RCU
     16607 ± 30%     -62.4%       6244 ± 10%  softirqs.CPU27.RCU
     16031 ± 28%     -57.8%       6757 ± 20%  softirqs.CPU28.RCU
     16062 ± 29%     -55.2%       7194 ± 31%  softirqs.CPU29.RCU
     18414 ± 12%     -55.8%       8134 ± 22%  softirqs.CPU3.RCU
     17072 ± 26%     -57.1%       7315 ± 24%  softirqs.CPU30.RCU
     17618 ± 28%     -62.2%       6668 ± 22%  softirqs.CPU31.RCU
     17362 ± 27%     -54.6%       7890 ± 32%  softirqs.CPU32.RCU
     15579 ± 16%     -58.0%       6535 ± 17%  softirqs.CPU33.RCU
     17030 ± 15%     -59.2%       6949 ± 19%  softirqs.CPU34.RCU
     14135 ± 28%     -51.2%       6901 ± 20%  softirqs.CPU35.RCU
     16851 ± 10%     -63.5%       6152 ± 15%  softirqs.CPU36.RCU
     16024 ± 31%     -64.5%       5683 ± 16%  softirqs.CPU37.RCU
     13188 ± 29%     -51.6%       6386 ± 14%  softirqs.CPU38.RCU
     14665 ± 29%     -58.7%       6056 ± 15%  softirqs.CPU39.RCU
     18800 ± 19%     -55.3%       8408 ± 23%  softirqs.CPU4.RCU
     15193 ± 24%     -60.7%       5964 ± 12%  softirqs.CPU40.RCU
     16115 ± 26%     -60.5%       6361 ± 12%  softirqs.CPU41.RCU
     16555 ± 24%     -60.8%       6495 ± 16%  softirqs.CPU42.RCU
     17772 ± 21%     -64.6%       6297 ±  8%  softirqs.CPU43.RCU
     15530 ± 15%     -61.0%       6055 ± 11%  softirqs.CPU44.RCU
     15596 ± 22%     -63.7%       5658 ± 10%  softirqs.CPU45.RCU
     14790 ± 27%     -59.6%       5974 ± 15%  softirqs.CPU46.RCU
     17855 ± 23%     -60.8%       6992 ±  9%  softirqs.CPU47.RCU
     20701 ±  9%     -54.3%       9458 ±  7%  softirqs.CPU5.RCU
     17855 ±  9%     -63.0%       6602 ± 27%  softirqs.CPU6.RCU
     17439 ± 19%     -52.8%       8224 ± 24%  softirqs.CPU7.RCU
     16394 ± 11%     -55.0%       7372 ± 23%  softirqs.CPU8.RCU
     17501 ± 18%     -57.8%       7388 ± 20%  softirqs.CPU9.RCU
    790243 ± 16%     -58.1%     330757 ± 12%  softirqs.RCU
     29941 ±  6%     +68.4%      50414        softirqs.TIMER
      0.02 ±  3%     -27.5%       0.01 ± 11%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.01 ±  5%     -17.4%       0.01 ±  7%  perf-sched.sch_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64
      0.01 ±  3%     -16.2%       0.01 ±  4%  perf-sched.sch_delay.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.01 ± 20%     -61.3%       0.00 ± 62%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 13%     -40.0%       0.01 ± 11%  perf-sched.sch_delay.avg.ms.preempt_schedule_common.__cond_resched.stop_one_cpu.sched_exec.bprm_execve
      0.01 ± 17%     -63.6%       0.00        perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      0.01 ±  4%     -15.7%       0.01 ±  9%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.05 ± 19%     -87.5%       0.01        perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork
      0.05 ± 13%     -54.7%       0.02 ± 61%  perf-sched.sch_delay.max.ms.preempt_schedule_common.__cond_resched.stop_one_cpu.sched_exec.bprm_execve
      0.01 ± 10%     -47.8%       0.01        perf-sched.total_sch_delay.average.ms
    192.65 ±  3%     -96.2%       7.38        perf-sched.total_wait_and_delay.average.ms
      6360 ±  3%   +2476.2%     163865        perf-sched.total_wait_and_delay.count.ms
    192.64 ±  3%     -96.2%       7.37        perf-sched.total_wait_time.average.ms
      1.29 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.03 ± 12%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.05 ±  9%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.04 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.05 ± 68%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
      0.08 ±128%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
      2.77 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.rcu_gp_kthread.kthread.ret_from_fork
    631.12 ± 14%     -57.5%     268.47 ±  6%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
     13.63 ± 18%     -65.2%       4.74 ±  8%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
    648.74           -99.6%       2.70 ±  2%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork
    245.67          -100.0%       0.00        perf-sched.wait_and_delay.count.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
    141.17 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
    105.50 ± 11%    -100.0%       0.00        perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
    197.17 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     86.83 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
     41.50 ± 10%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
     77.83 ± 19%    -100.0%       0.00        perf-sched.wait_and_delay.count.rcu_gp_kthread.kthread.ret_from_fork
     56.67 ± 16%    +132.9%     132.00 ±  6%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
    744.33 ± 19%    +184.8%       2119 ±  8%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
    675.67        +23083.3%     156641        perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork
     39.23 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.16 ± 73%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.29 ±109%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.50 ±138%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      1.17 ±196%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
      1.55 ±210%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
      4.84 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.rcu_gp_kthread.kthread.ret_from_fork
      7398           -30.7%       5131        perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
    365.83 ±  9%     -34.0%     241.47 ± 19%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      3541 ± 11%     +76.8%       6260 ± 14%  perf-sched.wait_and_delay.max.ms.worker_thread.kthread.ret_from_fork
      0.05 ± 68%    +275.7%       0.18 ±101%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
      2.76 ±  8%     -60.8%       1.08 ±  7%  perf-sched.wait_time.avg.ms.rcu_gp_kthread.kthread.ret_from_fork
    631.12 ± 14%     -57.5%     268.47 ±  6%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
     13.62 ± 18%     -65.2%       4.73 ±  8%  perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
    648.69           -99.6%       2.70 ±  2%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork
      0.16 ± 73%   +8911.6%      14.48 ±145%  perf-sched.wait_time.max.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      4.83 ±  7%     -51.1%       2.36 ± 39%  perf-sched.wait_time.max.ms.rcu_gp_kthread.kthread.ret_from_fork
      7398           -30.7%       5131        perf-sched.wait_time.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
    365.82 ±  9%     -34.0%     241.46 ± 19%  perf-sched.wait_time.max.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      3541 ± 11%     +76.8%       6260 ± 14%  perf-sched.wait_time.max.ms.worker_thread.kthread.ret_from_fork
      1.10           +83.4%       2.01 ±  2%  perf-stat.i.MPKI
      0.64            +0.0        0.65        perf-stat.i.branch-miss-rate%
  64941010            +3.1%   66926062        perf-stat.i.branch-misses
     46.92           -16.8       30.12        perf-stat.i.cache-miss-rate%
  26036960           +16.5%   30331430        perf-stat.i.cache-misses
  55509821           +81.5%  1.007e+08        perf-stat.i.cache-references
      1213 ±  3%   +2628.4%      33113        perf-stat.i.context-switches
      1.41            +5.3%       1.49        perf-stat.i.cpi
 7.264e+10            +3.2%  7.496e+10        perf-stat.i.cpu-cycles
     76.04           -10.1%      68.33 ±  3%  perf-stat.i.cpu-migrations
      2802           -11.5%       2479        perf-stat.i.cycles-between-cache-misses
 1.541e+10            -4.2%  1.476e+10        perf-stat.i.dTLB-loads
      1.01            -0.0        1.00        perf-stat.i.dTLB-store-miss-rate%
 1.008e+08            -8.7%   92003240        perf-stat.i.dTLB-store-misses
 9.838e+09            -7.8%  9.068e+09        perf-stat.i.dTLB-stores
  21115776            -8.6%   19293395        perf-stat.i.iTLB-load-misses
    148885 ±  9%     +66.6%     248054 ± 20%  perf-stat.i.iTLB-loads
 5.145e+10            -2.0%  5.041e+10        perf-stat.i.instructions
      2445            +7.3%       2624        perf-stat.i.instructions-per-iTLB-miss
      0.71            -5.0%       0.67        perf-stat.i.ipc
      1.51            +3.2%       1.56        perf-stat.i.metric.GHz
      1380            +8.9%       1502        perf-stat.i.metric.K/sec
    744.39            -3.8%     716.07        perf-stat.i.metric.M/sec
  19943108            -9.2%   18114354        perf-stat.i.minor-faults
      3.61 ± 14%     +26.8       30.36        perf-stat.i.node-load-miss-rate%
    168293 ± 15%   +2091.9%    3688828 ±  4%  perf-stat.i.node-load-misses
   4469410           +89.5%    8469082 ±  2%  perf-stat.i.node-loads
      1.39            +5.7        7.09 ±  7%  perf-stat.i.node-store-miss-rate%
    318192          +431.2%    1690225 ±  8%  perf-stat.i.node-store-misses
  21288502            +2.4%   21795925        perf-stat.i.node-stores
  19945726            -9.2%   18116966        perf-stat.i.page-faults
      1.08           +85.3%       2.00 ±  2%  perf-stat.overall.MPKI
      0.63            +0.0        0.65        perf-stat.overall.branch-miss-rate%
     46.91           -16.8       30.12        perf-stat.overall.cache-miss-rate%
      1.41            +5.3%       1.49        perf-stat.overall.cpi
      2789           -11.4%       2471        perf-stat.overall.cycles-between-cache-misses
      1.01            -0.0        1.00        perf-stat.overall.dTLB-store-miss-rate%
      2436            +7.2%       2613        perf-stat.overall.instructions-per-iTLB-miss
      0.71            -5.0%       0.67        perf-stat.overall.ipc
      3.63 ± 14%     +26.7       30.32        perf-stat.overall.node-load-miss-rate%
      1.47            +5.7        7.19 ±  7%  perf-stat.overall.node-store-miss-rate%
    774762            +7.8%     835446        perf-stat.overall.path-length
  64756183            +3.1%   66747524        perf-stat.ps.branch-misses
  25951585           +16.5%   30233592        perf-stat.ps.cache-misses
  55325148           +81.5%  1.004e+08        perf-stat.ps.cache-references
      1209 ±  3%   +2629.1%      33003        perf-stat.ps.context-switches
  7.24e+10            +3.2%  7.471e+10        perf-stat.ps.cpu-cycles
     75.82           -10.0%      68.24 ±  3%  perf-stat.ps.cpu-migrations
 1.536e+10            -4.2%  1.472e+10        perf-stat.ps.dTLB-loads
 1.004e+08            -8.7%   91697657        perf-stat.ps.dTLB-store-misses
 9.805e+09            -7.8%  9.038e+09        perf-stat.ps.dTLB-stores
  21045144            -8.6%   19229148        perf-stat.ps.iTLB-load-misses
    148374 ±  9%     +66.6%     247251 ± 20%  perf-stat.ps.iTLB-loads
 5.128e+10            -2.0%  5.025e+10        perf-stat.ps.instructions
  19876527            -9.2%   18053975        perf-stat.ps.minor-faults
    167937 ± 15%   +2089.4%    3676879 ±  4%  perf-stat.ps.node-load-misses
   4456602           +89.5%    8443950 ±  2%  perf-stat.ps.node-loads
    317050          +431.3%    1684598 ±  8%  perf-stat.ps.node-store-misses
  21217485            +2.4%   21723678        perf-stat.ps.node-stores
  19879129            -9.2%   18056577        perf-stat.ps.page-faults
 1.552e+13            -2.0%   1.52e+13        perf-stat.total.instructions
      0.00            +0.7        0.70 ± 10%  perf-profile.calltrace.cycles-pp.cgroup_rstat_updated.__mod_memcg_lruvec_state.__mod_lruvec_page_state.page_remove_rmap.zap_pte_range
      1.61 ± 13%      +0.9        2.52 ±  9%  perf-profile.calltrace.cycles-pp.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas.unmap_region
      0.00            +0.9        0.91 ± 11%  perf-profile.calltrace.cycles-pp.__mod_memcg_lruvec_state.__mod_lruvec_page_state.page_remove_rmap.zap_pte_range.unmap_page_range
      0.78 ± 12%      +1.0        1.74 ± 10%  perf-profile.calltrace.cycles-pp.__mod_lruvec_page_state.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas
      4.69 ± 12%      +1.0        5.70 ± 10%  perf-profile.calltrace.cycles-pp.zap_pte_range.unmap_page_range.unmap_vmas.unmap_region.__do_munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      4.70 ± 12%      +1.0        5.72 ± 10%  perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.__do_munmap.__vm_munmap.__x64_sys_munmap
      4.70 ± 12%      +1.0        5.72 ± 10%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.unmap_region.__do_munmap.__vm_munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      4.73 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.__munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.__do_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.calltrace.cycles-pp.unmap_region.__do_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.00            +1.1        1.08 ± 11%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.cgroup_rstat_updated.handle_mm_fault.do_user_addr_fault
      0.00            +1.2        1.17 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.cgroup_rstat_updated.handle_mm_fault.do_user_addr_fault.exc_page_fault
      0.00            +1.3        1.27 ± 14%  perf-profile.calltrace.cycles-pp.cgroup_rstat_updated.__mod_memcg_lruvec_state.__mod_lruvec_page_state.page_add_file_rmap.do_set_pte
      0.00            +1.6        1.58 ± 13%  perf-profile.calltrace.cycles-pp.__mod_memcg_lruvec_state.__mod_lruvec_page_state.page_add_file_rmap.do_set_pte.finish_fault
      0.65 ± 10%      +1.7        2.36 ± 12%  perf-profile.calltrace.cycles-pp.__mod_lruvec_page_state.page_add_file_rmap.do_set_pte.finish_fault.do_fault
      0.00            +1.7        1.73 ± 27%  perf-profile.calltrace.cycles-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work
      1.30 ± 11%      +1.7        3.02 ± 11%  perf-profile.calltrace.cycles-pp.page_add_file_rmap.do_set_pte.finish_fault.do_fault.__handle_mm_fault
      1.76 ± 12%      +1.8        3.51 ± 11%  perf-profile.calltrace.cycles-pp.do_set_pte.finish_fault.do_fault.__handle_mm_fault.handle_mm_fault
      2.92 ± 12%      +1.8        4.69 ± 10%  perf-profile.calltrace.cycles-pp.finish_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +2.5        2.53 ± 28%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread
      0.00            +2.5        2.54 ± 28%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread
      0.00            +2.6        2.57 ± 29%  perf-profile.calltrace.cycles-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +2.6        2.63 ± 28%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +2.6        2.65 ± 10%  perf-profile.calltrace.cycles-pp.cgroup_rstat_updated.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00            +2.8        2.83 ± 27%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
      0.00            +2.8        2.83 ± 27%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00            +2.8        2.83 ± 27%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
     15.88 ± 12%      +4.7       20.58 ± 10%  perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     19.89 ± 12%      +4.8       24.65 ± 10%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     19.18 ± 12%      +4.8       23.96 ± 10%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.02 ±142%      +0.1        0.07 ± 15%  perf-profile.children.cycles-pp.__get_user_nocheck_8
      0.02 ±142%      +0.1        0.08 ± 22%  perf-profile.children.cycles-pp.machines__deliver_event
      0.00            +0.1        0.08 ± 19%  perf-profile.children.cycles-pp.__orc_find
      0.07 ± 36%      +0.1        0.15 ± 22%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.01 ±223%      +0.1        0.09 ± 26%  perf-profile.children.cycles-pp.perf_output_sample
      0.06 ± 57%      +0.1        0.15 ± 21%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.05 ± 46%      +0.1        0.14 ± 25%  perf-profile.children.cycles-pp.__unwind_start
      0.00            +0.1        0.09 ± 50%  perf-profile.children.cycles-pp.schedule_idle
      0.04 ±102%      +0.1        0.15 ± 21%  perf-profile.children.cycles-pp.perf_session__process_user_event
      0.00            +0.1        0.13 ± 47%  perf-profile.children.cycles-pp.perf_trace_sched_switch
      0.37 ±  9%      +0.1        0.50 ± 10%  perf-profile.children.cycles-pp.unlock_page
      0.11 ±  9%      +0.1        0.24 ± 19%  perf-profile.children.cycles-pp.unwind_next_frame
      0.00            +0.1        0.13 ± 11%  perf-profile.children.cycles-pp.perf_trace_sched_wakeup_template
      0.01 ±223%      +0.1        0.15 ± 23%  perf-profile.children.cycles-pp.queue_event
      0.11 ± 14%      +0.1        0.26 ± 20%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.01 ±223%      +0.2        0.16 ± 25%  perf-profile.children.cycles-pp.ordered_events__queue
      0.20 ± 22%      +0.2        0.36 ± 18%  perf-profile.children.cycles-pp.__count_memcg_events
      0.15 ± 17%      +0.2        0.32 ± 19%  perf-profile.children.cycles-pp.perf_callchain_kernel
      0.00            +0.2        0.17 ± 25%  perf-profile.children.cycles-pp._find_next_bit
      0.00            +0.2        0.18 ± 10%  perf-profile.children.cycles-pp.try_to_wake_up
      0.00            +0.2        0.19 ± 48%  perf-profile.children.cycles-pp.schedule
      0.00            +0.2        0.20 ±  9%  perf-profile.children.cycles-pp.__queue_work
      0.20 ± 17%      +0.2        0.40 ± 17%  perf-profile.children.cycles-pp.get_perf_callchain
      0.20 ± 17%      +0.2        0.41 ± 17%  perf-profile.children.cycles-pp.perf_callchain
      0.10 ± 36%      +0.2        0.33 ± 22%  perf-profile.children.cycles-pp.process_simple
      0.22 ± 17%      +0.2        0.45 ± 18%  perf-profile.children.cycles-pp.perf_prepare_sample
      0.12 ± 36%      +0.2        0.36 ± 22%  perf-profile.children.cycles-pp.cmd_record
      0.12 ± 37%      +0.2        0.35 ± 22%  perf-profile.children.cycles-pp.record__finish_output
      0.12 ± 37%      +0.2        0.35 ± 22%  perf-profile.children.cycles-pp.perf_session__process_events
      0.80 ± 12%      +0.3        1.05 ±  7%  perf-profile.children.cycles-pp._raw_spin_lock
      0.00            +0.3        0.28 ± 48%  perf-profile.children.cycles-pp.__schedule
      0.27 ± 18%      +0.3        0.57 ± 19%  perf-profile.children.cycles-pp.perf_event_output_forward
      0.27 ± 17%      +0.3        0.58 ± 19%  perf-profile.children.cycles-pp.__perf_event_overflow
      0.28 ± 18%      +0.3        0.58 ± 19%  perf-profile.children.cycles-pp.perf_swevent_overflow
      0.28 ± 17%      +0.3        0.60 ± 19%  perf-profile.children.cycles-pp.perf_tp_event
      0.00            +0.5        0.52 ±  9%  perf-profile.children.cycles-pp.queue_work_on
      1.63 ± 13%      +0.9        2.54 ±  9%  perf-profile.children.cycles-pp.page_remove_rmap
      4.70 ± 12%      +1.0        5.72 ± 10%  perf-profile.children.cycles-pp.zap_pte_range
      4.71 ± 12%      +1.0        5.72 ± 10%  perf-profile.children.cycles-pp.unmap_vmas
      4.71 ± 12%      +1.0        5.72 ± 10%  perf-profile.children.cycles-pp.unmap_page_range
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.children.cycles-pp.__do_munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.children.cycles-pp.__x64_sys_munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.children.cycles-pp.__vm_munmap
      4.72 ± 12%      +1.0        5.74 ± 10%  perf-profile.children.cycles-pp.unmap_region
      4.73 ± 12%      +1.0        5.74 ± 10%  perf-profile.children.cycles-pp.__munmap
      4.90 ± 12%      +1.1        5.95 ±  9%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      4.90 ± 12%      +1.1        5.95 ±  9%  perf-profile.children.cycles-pp.do_syscall_64
      0.00            +1.5        1.51 ± 10%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +1.6        1.63 ± 10%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      1.30 ± 11%      +1.7        3.04 ± 11%  perf-profile.children.cycles-pp.page_add_file_rmap
      0.00            +1.7        1.75 ± 27%  perf-profile.children.cycles-pp.mem_cgroup_css_rstat_flush
      1.79 ± 12%      +1.8        3.55 ± 11%  perf-profile.children.cycles-pp.do_set_pte
      2.94 ± 12%      +1.8        4.71 ± 10%  perf-profile.children.cycles-pp.finish_fault
      0.46 ± 11%      +2.1        2.52 ± 12%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.00            +2.5        2.54 ± 28%  perf-profile.children.cycles-pp.cgroup_rstat_flush_locked
      0.00            +2.5        2.54 ± 28%  perf-profile.children.cycles-pp.cgroup_rstat_flush_irqsafe
      0.00            +2.6        2.57 ± 29%  perf-profile.children.cycles-pp.mem_cgroup_flush_stats
      0.05 ± 48%      +2.6        2.63 ± 28%  perf-profile.children.cycles-pp.process_one_work
      1.48 ± 11%      +2.7        4.15 ± 10%  perf-profile.children.cycles-pp.__mod_lruvec_page_state
      0.06 ± 50%      +2.8        2.83 ± 27%  perf-profile.children.cycles-pp.kthread
      0.06 ± 50%      +2.8        2.83 ± 26%  perf-profile.children.cycles-pp.ret_from_fork
      0.05 ± 50%      +2.8        2.83 ± 27%  perf-profile.children.cycles-pp.worker_thread
      0.26 ± 12%      +4.4        4.65 ± 10%  perf-profile.children.cycles-pp.cgroup_rstat_updated
     15.96 ± 12%      +4.7       20.66 ± 10%  perf-profile.children.cycles-pp.handle_mm_fault
     19.97 ± 12%      +4.8       24.74 ± 10%  perf-profile.children.cycles-pp.exc_page_fault
     19.31 ± 12%      +4.8       24.09 ± 10%  perf-profile.children.cycles-pp.do_user_addr_fault
      0.00            +0.1        0.08 ± 19%  perf-profile.self.cycles-pp.__orc_find
      0.20 ± 13%      +0.1        0.27 ± 10%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.01 ±223%      +0.1        0.10 ± 25%  perf-profile.self.cycles-pp.unwind_next_frame
      0.00            +0.1        0.12 ± 11%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.35 ±  9%      +0.1        0.48 ±  9%  perf-profile.self.cycles-pp.unlock_page
      0.00            +0.1        0.14 ± 25%  perf-profile.self.cycles-pp.queue_event
      0.19 ± 23%      +0.1        0.33 ± 20%  perf-profile.self.cycles-pp.__count_memcg_events
      0.11 ± 11%      +0.2        0.26 ± 20%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.00            +0.2        0.16 ± 23%  perf-profile.self.cycles-pp._find_next_bit
      0.77 ± 12%      +0.3        1.03 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.3        0.32 ± 11%  perf-profile.self.cycles-pp.queue_work_on
      0.00            +0.5        0.51 ± 31%  perf-profile.self.cycles-pp.cgroup_rstat_flush_locked
      0.00            +1.5        1.51 ± 10%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +1.6        1.59 ± 28%  perf-profile.self.cycles-pp.mem_cgroup_css_rstat_flush
      0.25 ± 13%      +2.8        3.01 ± 10%  perf-profile.self.cycles-pp.cgroup_rstat_updated



***************************************************************************************************
lkp-cpl-4sp1: 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H CPU @ 2.50GHz with 128G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/thread/100%/debian-10.4-x86_64-20200603.cgz/lkp-cpl-4sp1/tlb_flush1/will-it-scale/0x700001e

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    503768            -2.3%     492013        will-it-scale.144.threads
      1.68 ±  2%     +32.5%       2.22        will-it-scale.144.threads_idle
      3498            -2.3%       3416        will-it-scale.per_thread_ops
    503768            -2.3%     492013        will-it-scale.workload
      0.00 ±104%      +0.0        0.00 ± 47%  mpstat.cpu.all.iowait%
   1025379 ±  5%     +39.8%    1433265 ±  2%  turbostat.C1
 1.157e+09 ± 10%     +25.2%  1.449e+09 ±  5%  cpuidle..time
   5971337 ±  3%     +16.3%    6946868        cpuidle..usage
     45468 ± 78%     -58.0%      19095 ±  2%  numa-meminfo.node3.AnonHugePages
    131621 ± 49%     -50.0%      65813 ± 10%  numa-meminfo.node3.AnonPages.max
      2981 ±  5%     -12.7%       2602 ±  2%  slabinfo.fsnotify_mark_connector.active_objs
      2981 ±  5%     -12.7%       2602 ±  2%  slabinfo.fsnotify_mark_connector.num_objs
     10174           +84.1%      18735        vmstat.system.cs
   6897906            -2.7%    6712563        vmstat.system.in
    300488            +2.6%     308156        proc-vmstat.nr_inactive_anon
    300488            +2.6%     308156        proc-vmstat.nr_zone_inactive_anon
 1.598e+08            -2.3%  1.562e+08        proc-vmstat.numa_hit
 1.597e+08            -2.3%   1.56e+08        proc-vmstat.numa_local
    626526 ±  2%      -5.3%     593571        proc-vmstat.numa_pte_updates
 1.598e+08            -2.3%  1.562e+08        proc-vmstat.pgalloc_normal
 3.082e+08            -2.3%   3.01e+08        proc-vmstat.pgfault
 1.597e+08            -2.3%  1.561e+08        proc-vmstat.pgfree
     26.97            +3.5%      27.91        perf-stat.i.MPKI
 9.081e+09            +8.6%  9.864e+09        perf-stat.i.branch-instructions
      1.14            -0.1        1.07 ±  3%  perf-stat.i.branch-miss-rate%
     42.59            -2.2       40.37        perf-stat.i.cache-miss-rate%
 4.725e+08            +4.8%  4.953e+08 ±  2%  perf-stat.i.cache-misses
 1.107e+09           +10.1%  1.218e+09        perf-stat.i.cache-references
     10162           +85.8%      18879        perf-stat.i.context-switches
     11.26            -7.1%      10.45        perf-stat.i.cpi
    197.31           +11.9%     220.86        perf-stat.i.cpu-migrations
    985.33            -5.3%     933.47 ±  2%  perf-stat.i.cycles-between-cache-misses
 1.098e+10            +6.4%  1.169e+10        perf-stat.i.dTLB-loads
  27634210 ±  2%     -21.0%   21838549        perf-stat.i.iTLB-load-misses
    313874 ±  2%     +10.4%     346477        perf-stat.i.iTLB-loads
 4.076e+10            +7.0%   4.36e+10        perf-stat.i.instructions
      1513 ±  2%     +38.0%       2088        perf-stat.i.instructions-per-iTLB-miss
      0.09            +8.5%       0.10        perf-stat.i.ipc
    183.92            +5.6%     194.20        perf-stat.i.metric.M/sec
   1011833            -2.5%     986716        perf-stat.i.minor-faults
    126438           +38.5%     175078 ±  4%  perf-stat.i.node-stores
   1011835            -2.5%     986718        perf-stat.i.page-faults
     27.16            +2.9%      27.94        perf-stat.overall.MPKI
      1.14            -0.1        1.05        perf-stat.overall.branch-miss-rate%
     42.69            -2.0       40.66        perf-stat.overall.cache-miss-rate%
     11.33            -7.1%      10.53        perf-stat.overall.cpi
    978.00            -5.2%     927.43        perf-stat.overall.cycles-between-cache-misses
      1476 ±  2%     +35.2%       1996        perf-stat.overall.instructions-per-iTLB-miss
      0.09            +7.6%       0.09        perf-stat.overall.ipc
  24640644            +9.7%   27024500        perf-stat.overall.path-length
 9.055e+09            +8.6%   9.83e+09        perf-stat.ps.branch-instructions
 4.712e+08            +4.8%  4.936e+08 ±  2%  perf-stat.ps.cache-misses
 1.104e+09           +10.0%  1.214e+09        perf-stat.ps.cache-references
     10122           +83.8%      18606        perf-stat.ps.context-switches
    196.45           +11.8%     219.54        perf-stat.ps.cpu-migrations
 1.095e+10            +6.4%  1.165e+10        perf-stat.ps.dTLB-loads
 5.005e+09            -1.9%  4.913e+09        perf-stat.ps.dTLB-stores
  27547553 ±  2%     -21.0%   21768351        perf-stat.ps.iTLB-load-misses
    311081 ±  2%      +9.9%     341727        perf-stat.ps.iTLB-loads
 4.064e+10            +6.9%  4.344e+10        perf-stat.ps.instructions
   1008914            -2.6%     983136        perf-stat.ps.minor-faults
  31114584            -2.2%   30429953        perf-stat.ps.node-loads
    125870           +37.8%     173479 ±  4%  perf-stat.ps.node-stores
   1008917            -2.6%     983138        perf-stat.ps.page-faults
 1.241e+13            +7.1%   1.33e+13        perf-stat.total.instructions
      0.86 ±110%     -99.9%       0.00        perf-sched.sch_delay.avg.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
      0.02 ± 87%    +201.1%       0.05 ± 37%  perf-sched.sch_delay.avg.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      0.02 ±106%    +259.5%       0.09 ± 22%  perf-sched.sch_delay.avg.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00 ±  7%     -31.0%       0.00 ± 14%  perf-sched.sch_delay.avg.ms.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
      0.06 ±  4%     +55.8%       0.10 ± 28%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      1.54 ± 71%     -69.7%       0.47 ± 90%  perf-sched.sch_delay.avg.ms.schedule_timeout.wait_for_completion.__flush_work.lru_add_drain_all
      0.02 ± 59%    +1e+05%      15.13 ±109%  perf-sched.sch_delay.max.ms.preempt_schedule_common.__cond_resched.zap_page_range.do_madvise.part
      0.19 ± 11%    +369.3%       0.87 ±101%  perf-sched.sch_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      3.75 ± 23%    +531.7%      23.71 ± 47%  perf-sched.sch_delay.max.ms.worker_thread.kthread.ret_from_fork
     54.96 ±  3%     -47.8%      28.68 ±  2%  perf-sched.total_wait_and_delay.average.ms
     58198 ±  4%     +95.3%     113666 ±  2%  perf-sched.total_wait_and_delay.count.ms
     54.89 ±  3%     -47.9%      28.60 ±  2%  perf-sched.total_wait_time.average.ms
      7.45 ±  8%     -24.8%       5.61 ±  2%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      0.49 ±  6%     +40.7%       0.69 ±  3%  perf-sched.wait_and_delay.avg.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      0.51 ±  6%     +47.8%       0.75 ±  4%  perf-sched.wait_and_delay.avg.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      5.96 ± 15%     -21.1%       4.71 ±  4%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
    777.48           -94.1%      45.81        perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork
      3062 ±  3%    +367.5%      14318        perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      4427 ± 10%    +263.4%      16091 ±  3%  perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1710 ± 12%     +25.6%       2148 ±  4%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      1685         +1660.8%      29681        perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork
      3216 ± 30%     -68.9%       1001        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      3662 ± 31%     -45.7%       1990 ± 12%  perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      1027          +356.6%       4689 ± 54%  perf-sched.wait_and_delay.max.ms.worker_thread.kthread.ret_from_fork
      0.32 ± 68%     -61.9%       0.12 ± 49%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.down_read.do_madvise.part
      7.45 ±  8%     -24.8%       5.61 ±  2%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      0.24 ±  8%    +123.3%       0.53 ± 51%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.wp_page_copy.__handle_mm_fault.handle_mm_fault
      0.44 ± 61%     -54.0%       0.20 ± 27%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.zap_page_range.do_madvise.part
      0.11 ± 39%     -66.6%       0.04 ± 72%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
      0.47 ±  7%     +35.3%       0.64        perf-sched.wait_time.avg.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      0.48 ±  8%     +36.9%       0.66        perf-sched.wait_time.avg.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.12 ± 11%     -51.4%       0.06 ± 13%  perf-sched.wait_time.avg.ms.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
      5.90 ± 15%     -21.4%       4.63 ±  4%  perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
    777.41           -94.1%      45.74        perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork
      2.28 ±150%    +570.6%      15.28 ± 16%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.__alloc_pages.alloc_pages_vma.wp_page_copy
      0.83 ± 30%   +1448.6%      12.85 ± 45%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.unmap_page_range.zap_page_range.do_madvise
      3214 ± 30%     -68.9%       1001        perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      0.90 ± 46%   +2790.6%      26.15 ± 30%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.wp_page_copy.__handle_mm_fault.handle_mm_fault
      1.62 ± 32%    +735.1%      13.54 ± 49%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.zap_page_range
     24.31 ± 32%    +135.7%      57.31 ± 25%  perf-sched.wait_time.max.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      2.51 ± 13%     +74.2%       4.36 ±  6%  perf-sched.wait_time.max.ms.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
      1.25 ± 81%    +251.0%       4.39 ± 18%  perf-sched.wait_time.max.ms.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
      3662 ± 31%     -45.7%       1987 ± 12%  perf-sched.wait_time.max.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      1025          +357.1%       4689 ± 54%  perf-sched.wait_time.max.ms.worker_thread.kthread.ret_from_fork
     44.39            -1.2       43.14        perf-profile.calltrace.cycles-pp.ptep_clear_flush.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     44.03            -1.2       42.79        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.ptep_clear_flush.wp_page_copy.__handle_mm_fault.handle_mm_fault
     41.40            -1.1       40.27        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush.wp_page_copy.__handle_mm_fault
     41.20            -1.1       40.08        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush.wp_page_copy
     13.00 ±  6%      -1.0       12.04        perf-profile.calltrace.cycles-pp.flush_tlb_func.flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
     13.08 ±  5%      -0.9       12.17        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
     12.98 ±  5%      -0.9       12.08        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask
     12.96 ±  5%      -0.9       12.06        perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond
     49.64            -0.9       48.76        perf-profile.calltrace.cycles-pp.testcase
     49.38            -0.9       48.50        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
     49.31            -0.9       48.43        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
     49.29            -0.9       48.42        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     45.04            -0.9       44.18        perf-profile.calltrace.cycles-pp.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     44.48            -0.8       43.71        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_flush_mmu.tlb_finish_mmu.zap_page_range.do_madvise
     43.80            -0.8       43.04        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_flush_mmu.tlb_finish_mmu.zap_page_range
     46.39            -0.7       45.65        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     43.58            -0.7       42.84        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_flush_mmu.tlb_finish_mmu
     46.72            -0.6       46.12        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
     12.42            -0.5       11.89        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.llist_add_batch.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
     11.97            -0.5       11.47        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.llist_add_batch.smp_call_function_many_cond.on_each_cpu_cond_mask
     11.86            -0.5       11.35        perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.llist_add_batch
     11.88            -0.5       11.38        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.llist_add_batch.smp_call_function_many_cond
      6.53 ±  5%      -0.5        6.06        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush
      6.91 ±  5%      -0.5        6.46        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_flush_mmu
      9.88            -0.3        9.55        perf-profile.calltrace.cycles-pp.llist_reverse_order.flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      1.45 ±  6%      -0.2        1.25 ±  8%  perf-profile.calltrace.cycles-pp.down_read_trylock.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.57            -0.1        0.52        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.native_flush_tlb_multi.flush_tlb_mm_range.ptep_clear_flush.wp_page_copy
      0.55            -0.0        0.50        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.native_flush_tlb_multi.flush_tlb_mm_range
      0.56            -0.0        0.51        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.native_flush_tlb_multi.flush_tlb_mm_range.ptep_clear_flush
      0.55            -0.0        0.50        perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.native_flush_tlb_multi
      0.74            -0.0        0.71        perf-profile.calltrace.cycles-pp.default_send_IPI_mask_sequence_phys.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush
      0.61            +0.1        0.74        perf-profile.calltrace.cycles-pp.filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.66            +0.2        0.82        perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      1.27 ±  8%      +0.3        1.59 ±  8%  perf-profile.calltrace.cycles-pp.uncharge_batch.__mem_cgroup_uncharge_list.release_pages.tlb_flush_mmu.tlb_finish_mmu
      1.31 ±  8%      +0.4        1.69 ±  9%  perf-profile.calltrace.cycles-pp.__mem_cgroup_uncharge_list.release_pages.tlb_flush_mmu.tlb_finish_mmu.zap_page_range
      0.00            +0.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work
      0.00            +0.6        0.59        perf-profile.calltrace.cycles-pp.__pagevec_lru_add.lru_add_drain_cpu.lru_add_drain.zap_page_range.do_madvise
      0.00            +0.6        0.60        perf-profile.calltrace.cycles-pp.lru_add_drain_cpu.lru_add_drain.zap_page_range.do_madvise.__x64_sys_madvise
      0.00            +0.6        0.61        perf-profile.calltrace.cycles-pp.lru_add_drain.zap_page_range.do_madvise.__x64_sys_madvise.do_syscall_64
      0.00            +0.7        0.71 ±  3%  perf-profile.calltrace.cycles-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +0.7        0.71 ±  3%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread
      0.00            +0.7        0.71 ±  3%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread
      0.00            +0.7        0.72 ±  3%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +0.7        0.73 ±  3%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
      0.00            +0.7        0.73 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00            +0.7        0.73 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      1.57 ±  7%      +0.7        2.31 ±  6%  perf-profile.calltrace.cycles-pp.release_pages.tlb_flush_mmu.tlb_finish_mmu.zap_page_range.do_madvise
     88.54            -2.0       86.53        perf-profile.children.cycles-pp.flush_tlb_mm_range
     85.20            -1.9       83.33        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
     85.20            -1.9       83.32        perf-profile.children.cycles-pp.smp_call_function_many_cond
     31.52 ±  2%      -1.3       30.23        perf-profile.children.cycles-pp.asm_sysvec_call_function
     30.49 ±  2%      -1.3       29.23        perf-profile.children.cycles-pp.sysvec_call_function
     30.51 ±  2%      -1.3       29.26        perf-profile.children.cycles-pp.flush_smp_call_function_queue
     30.26 ±  2%      -1.3       29.01        perf-profile.children.cycles-pp.__sysvec_call_function
     44.40            -1.2       43.15        perf-profile.children.cycles-pp.ptep_clear_flush
     17.03 ±  5%      -0.9       16.11        perf-profile.children.cycles-pp.flush_tlb_func
     49.80            -0.9       48.92        perf-profile.children.cycles-pp.testcase
     49.37            -0.9       48.50        perf-profile.children.cycles-pp.exc_page_fault
     49.32            -0.9       48.45        perf-profile.children.cycles-pp.do_user_addr_fault
     49.55            -0.9       48.69        perf-profile.children.cycles-pp.asm_exc_page_fault
     45.04            -0.9       44.19        perf-profile.children.cycles-pp.wp_page_copy
     46.41            -0.7       45.66        perf-profile.children.cycles-pp.__handle_mm_fault
     46.74            -0.6       46.14        perf-profile.children.cycles-pp.handle_mm_fault
      1.46 ±  6%      -0.2        1.26 ±  8%  perf-profile.children.cycles-pp.down_read_trylock
      1.63            -0.1        1.58        perf-profile.children.cycles-pp.default_send_IPI_mask_sequence_phys
      0.11 ±  4%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.06 ±  6%      +0.0        0.07 ±  6%  perf-profile.children.cycles-pp.__vm_munmap
      0.06 ±  6%      +0.0        0.07 ±  6%  perf-profile.children.cycles-pp.__munmap
      0.06 ±  6%      +0.0        0.07 ±  6%  perf-profile.children.cycles-pp.__x64_sys_munmap
      0.06 ±  6%      +0.0        0.07 ±  6%  perf-profile.children.cycles-pp.__do_munmap
      0.05            +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.unmap_vmas
      0.05            +0.0        0.07        perf-profile.children.cycles-pp.unmap_region
      0.04 ± 72%      +0.0        0.09 ±  9%  perf-profile.children.cycles-pp.ordered_events__queue
      0.04 ± 72%      +0.0        0.09 ±  9%  perf-profile.children.cycles-pp.queue_event
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.free_unref_page_list
      0.06 ± 50%      +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.cmd_record
      0.78 ±  4%      +0.1        0.83 ±  3%  perf-profile.children.cycles-pp.unmap_page_range
      0.05 ± 72%      +0.1        0.10 ±  4%  perf-profile.children.cycles-pp.process_simple
      0.06 ± 48%      +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.record__finish_output
      0.06 ± 48%      +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.perf_session__process_events
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.perf_mux_hrtimer_handler
      0.06            +0.1        0.12        perf-profile.children.cycles-pp._raw_spin_lock
      0.05            +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.charge_memcg
      0.00            +0.1        0.07 ± 11%  perf-profile.children.cycles-pp.schedule
      0.46 ±  9%      +0.1        0.53        perf-profile.children.cycles-pp.scheduler_tick
      0.44 ±  8%      +0.1        0.51 ±  5%  perf-profile.children.cycles-pp.zap_pte_range
      0.10 ± 20%      +0.1        0.18 ±  6%  perf-profile.children.cycles-pp.__count_memcg_events
      0.51 ±  8%      +0.1        0.59 ±  2%  perf-profile.children.cycles-pp.tick_sched_handle
      0.00            +0.1        0.08 ± 11%  perf-profile.children.cycles-pp.__schedule
      0.52 ±  8%      +0.1        0.60 ±  2%  perf-profile.children.cycles-pp.tick_sched_timer
      0.50 ±  8%      +0.1        0.59 ±  2%  perf-profile.children.cycles-pp.update_process_times
      0.00            +0.1        0.10 ± 21%  perf-profile.children.cycles-pp.uncharge_page
      0.08 ± 11%      +0.1        0.20 ±  8%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.22 ± 18%      +0.1        0.34 ± 20%  perf-profile.children.cycles-pp.propagate_protected_usage
      0.61            +0.1        0.75        perf-profile.children.cycles-pp.filemap_map_pages
      0.09 ±  4%      +0.1        0.24 ±  5%  perf-profile.children.cycles-pp.page_remove_rmap
      0.55 ±  7%      +0.2        0.70        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.67            +0.2        0.82        perf-profile.children.cycles-pp.do_fault
      0.06            +0.2        0.21 ±  2%  perf-profile.children.cycles-pp.do_set_pte
      0.68 ±  7%      +0.2        0.85        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.64 ±  7%      +0.2        0.81        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.64 ±  7%      +0.2        0.82 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.72 ±  6%      +0.2        0.90        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.01 ±223%      +0.2        0.19 ±  2%  perf-profile.children.cycles-pp.page_add_file_rmap
      0.16 ±  3%      +0.2        0.37 ±  4%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.19 ±  7%      +0.2        0.40 ±  6%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +0.2        0.22 ±  4%  perf-profile.children.cycles-pp.page_add_new_anon_rmap
      0.17 ±  9%      +0.2        0.41 ±  4%  perf-profile.children.cycles-pp.lock_page_lruvec_irqsave
      0.00            +0.2        0.25 ± 16%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.37 ±  4%      +0.3        0.62        perf-profile.children.cycles-pp.lru_add_drain
      0.35 ±  4%      +0.3        0.60        perf-profile.children.cycles-pp.lru_add_drain_cpu
      0.34 ±  3%      +0.3        0.59        perf-profile.children.cycles-pp.__pagevec_lru_add
      0.16 ±  9%      +0.3        0.46 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      1.27 ±  8%      +0.3        1.59 ±  8%  perf-profile.children.cycles-pp.uncharge_batch
      1.31 ±  8%      +0.4        1.69 ±  9%  perf-profile.children.cycles-pp.__mem_cgroup_uncharge_list
      0.04 ± 71%      +0.4        0.47        perf-profile.children.cycles-pp.cgroup_rstat_updated
      0.07 ±  5%      +0.5        0.57 ±  4%  perf-profile.children.cycles-pp.__mod_lruvec_page_state
      0.00            +0.5        0.54 ±  4%  perf-profile.children.cycles-pp.mem_cgroup_css_rstat_flush
      0.02 ±141%      +0.6        0.63 ±  5%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.00            +0.7        0.71 ±  3%  perf-profile.children.cycles-pp.mem_cgroup_flush_stats
      0.00            +0.7        0.71 ±  3%  perf-profile.children.cycles-pp.cgroup_rstat_flush_irqsafe
      0.00            +0.7        0.71 ±  3%  perf-profile.children.cycles-pp.cgroup_rstat_flush_locked
      0.00            +0.7        0.72 ±  3%  perf-profile.children.cycles-pp.process_one_work
      0.00            +0.7        0.73 ±  3%  perf-profile.children.cycles-pp.worker_thread
      0.00            +0.7        0.73 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      0.00            +0.7        0.73 ±  2%  perf-profile.children.cycles-pp.kthread
      1.66 ±  6%      +0.7        2.40 ±  5%  perf-profile.children.cycles-pp.release_pages
     15.67 ±  5%      -0.9       14.82        perf-profile.self.cycles-pp.flush_tlb_func
      0.92 ±  7%      -0.1        0.79 ±  8%  perf-profile.self.cycles-pp.down_read_trylock
      2.31 ±  2%      -0.1        2.22        perf-profile.self.cycles-pp.flush_smp_call_function_queue
      1.20            -0.1        1.13        perf-profile.self.cycles-pp.native_flush_tlb_multi
      0.03 ±100%      +0.1        0.09 ±  9%  perf-profile.self.cycles-pp.queue_event
      0.08 ±  6%      +0.1        0.14 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.10 ± 20%      +0.1        0.18 ±  6%  perf-profile.self.cycles-pp.__count_memcg_events
      0.16 ± 19%      +0.1        0.25 ± 21%  perf-profile.self.cycles-pp.propagate_protected_usage
      0.00            +0.1        0.10        perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.1        0.12 ± 10%  perf-profile.self.cycles-pp.cgroup_rstat_flush_locked
      0.00            +0.2        0.18 ± 16%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.19 ±  7%      +0.2        0.40 ±  5%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.03 ±100%      +0.3        0.34        perf-profile.self.cycles-pp.cgroup_rstat_updated
      0.00            +0.5        0.51 ±  5%  perf-profile.self.cycles-pp.mem_cgroup_css_rstat_flush
     12787 ±  3%     -27.3%       9296 ±  2%  softirqs.CPU0.RCU
     11378 ±  6%     -36.4%       7237 ±  3%  softirqs.CPU10.RCU
     11407 ±  5%     -37.8%       7093 ±  3%  softirqs.CPU100.RCU
     11282 ±  3%     -35.7%       7249 ±  6%  softirqs.CPU101.RCU
     11276 ±  3%     -35.7%       7255 ±  2%  softirqs.CPU102.RCU
     11542 ±  3%     -36.0%       7388 ±  7%  softirqs.CPU103.RCU
     11336 ±  5%     -37.8%       7046 ±  2%  softirqs.CPU104.RCU
     11177 ±  4%     -37.1%       7031        softirqs.CPU105.RCU
     11463 ±  7%     -38.6%       7040        softirqs.CPU106.RCU
     11151 ±  3%     -36.6%       7066 ±  4%  softirqs.CPU107.RCU
     11539 ±  5%     -39.1%       7023 ±  4%  softirqs.CPU108.RCU
     10921 ±  6%     -36.2%       6965 ±  3%  softirqs.CPU109.RCU
     11575 ±  4%     -37.5%       7238 ±  3%  softirqs.CPU11.RCU
     10469 ±  4%     -37.1%       6583        softirqs.CPU110.RCU
     10173 ±  5%     -36.3%       6483 ±  2%  softirqs.CPU111.RCU
     11249 ±  4%     -36.6%       7131 ±  6%  softirqs.CPU112.RCU
     11449 ±  7%     -36.8%       7240 ±  6%  softirqs.CPU113.RCU
     11218 ±  4%     -37.8%       6974 ±  5%  softirqs.CPU114.RCU
     11249 ±  4%     -34.8%       7329 ±  9%  softirqs.CPU115.RCU
     11149 ±  3%     -33.1%       7461 ± 11%  softirqs.CPU116.RCU
     11185 ±  4%     -34.9%       7279 ±  7%  softirqs.CPU117.RCU
     11160 ±  4%     -36.9%       7046 ±  5%  softirqs.CPU118.RCU
     11085 ±  3%     -34.1%       7306 ±  7%  softirqs.CPU119.RCU
     11259 ±  3%     -33.9%       7446 ±  4%  softirqs.CPU12.RCU
     11110 ±  4%     -34.9%       7238 ±  9%  softirqs.CPU120.RCU
     11131 ±  3%     -39.0%       6793 ±  2%  softirqs.CPU121.RCU
     11127 ±  4%     -35.9%       7134 ±  6%  softirqs.CPU122.RCU
     11003 ±  4%     -38.2%       6804 ±  3%  softirqs.CPU123.RCU
     11916 ± 18%     -40.5%       7084 ±  7%  softirqs.CPU124.RCU
     10940 ±  4%     -36.4%       6955 ±  6%  softirqs.CPU125.RCU
      9287 ±  5%     -31.5%       6359 ±  8%  softirqs.CPU126.RCU
     10178 ±  9%     -34.8%       6631 ±  7%  softirqs.CPU128.RCU
      9897 ±  5%     -37.5%       6190 ±  4%  softirqs.CPU129.RCU
     12235 ± 16%     -40.9%       7233        softirqs.CPU13.RCU
      9866 ±  4%     -36.2%       6298 ±  5%  softirqs.CPU130.RCU
      9713 ±  4%     -36.2%       6193 ±  5%  softirqs.CPU131.RCU
      9772 ±  4%     -34.0%       6448 ± 10%  softirqs.CPU132.RCU
      9995 ±  6%     -37.7%       6225 ±  5%  softirqs.CPU133.RCU
      9886 ±  5%     -35.7%       6352 ±  8%  softirqs.CPU134.RCU
      9740 ±  3%     -35.4%       6290 ±  7%  softirqs.CPU135.RCU
      9745 ±  4%     -36.0%       6240 ±  5%  softirqs.CPU136.RCU
      9748 ±  5%     -30.3%       6798 ± 19%  softirqs.CPU137.RCU
      9685 ±  4%     -36.9%       6111 ±  6%  softirqs.CPU138.RCU
      9725 ±  4%     -27.2%       7077 ± 16%  softirqs.CPU139.RCU
     13759 ± 15%     -43.3%       7804 ± 12%  softirqs.CPU14.RCU
      9984 ± 13%     -41.9%       5800        softirqs.CPU140.RCU
      9817 ±  6%     -38.7%       6023 ±  4%  softirqs.CPU141.RCU
     10070 ±  8%     -37.7%       6277 ±  2%  softirqs.CPU143.RCU
     11747 ± 11%     -25.0%       8805 ± 16%  softirqs.CPU15.RCU
      9647 ±  5%     -33.8%       6385 ±  7%  softirqs.CPU16.RCU
      9637 ±  3%     -31.0%       6648 ±  8%  softirqs.CPU17.RCU
     12145 ±  7%     -32.7%       8175 ±  4%  softirqs.CPU18.RCU
     12091 ±  4%     -35.1%       7844        softirqs.CPU19.RCU
     11595 ±  6%     -32.4%       7839 ±  6%  softirqs.CPU2.RCU
     11665 ±  3%     -34.3%       7663 ±  3%  softirqs.CPU20.RCU
     11688 ±  2%     -31.8%       7966 ±  9%  softirqs.CPU21.RCU
     11576 ±  3%     -35.1%       7517 ±  2%  softirqs.CPU22.RCU
     11515 ±  3%     -36.4%       7322        softirqs.CPU23.RCU
     11730 ±  5%     -37.1%       7383 ±  3%  softirqs.CPU24.RCU
     11643 ±  5%     -35.9%       7462 ±  3%  softirqs.CPU25.RCU
     11635 ±  5%     -36.7%       7369 ±  2%  softirqs.CPU26.RCU
     11419 ±  4%     -33.9%       7552        softirqs.CPU27.RCU
     11615 ±  2%     -34.1%       7651 ±  4%  softirqs.CPU28.RCU
     11352 ±  3%     -35.5%       7317 ±  2%  softirqs.CPU29.RCU
     11486 ±  7%     -31.4%       7876 ±  5%  softirqs.CPU3.RCU
     11323 ±  3%     -32.8%       7607 ±  4%  softirqs.CPU30.RCU
     11376 ±  3%     -34.3%       7473 ±  3%  softirqs.CPU31.RCU
     10292 ±  4%     -37.1%       6479 ±  2%  softirqs.CPU32.RCU
     10329 ±  5%     -35.6%       6653 ±  2%  softirqs.CPU33.RCU
     10218 ±  4%     -36.2%       6516        softirqs.CPU34.RCU
     10085 ±  4%     -34.8%       6575 ±  3%  softirqs.CPU35.RCU
     12314 ±  4%     -31.3%       8456 ±  9%  softirqs.CPU36.RCU
     12226 ±  4%     -31.0%       8436 ± 10%  softirqs.CPU37.RCU
     12004 ±  3%     -32.1%       8146 ±  8%  softirqs.CPU38.RCU
     11834 ±  3%     -31.5%       8101 ±  8%  softirqs.CPU39.RCU
     11203 ±  5%     -30.4%       7793 ± 10%  softirqs.CPU4.RCU
     11811 ±  3%     -35.0%       7673 ±  4%  softirqs.CPU40.RCU
     11621 ±  3%     -32.2%       7878 ±  6%  softirqs.CPU41.RCU
     11669 ±  4%     -32.1%       7924 ±  9%  softirqs.CPU42.RCU
     11484 ±  4%     -33.8%       7602 ±  6%  softirqs.CPU43.RCU
     11672 ±  3%     -34.7%       7617 ±  6%  softirqs.CPU44.RCU
     11554 ±  4%     -35.2%       7491 ±  5%  softirqs.CPU45.RCU
     11408 ±  4%     -33.6%       7573 ±  7%  softirqs.CPU46.RCU
     11417 ±  3%     -35.8%       7328 ±  4%  softirqs.CPU47.RCU
     11122 ±  4%     -35.3%       7192 ±  5%  softirqs.CPU48.RCU
     11048 ±  3%     -31.5%       7569 ±  8%  softirqs.CPU49.RCU
     11541 ±  5%     -36.3%       7347 ±  5%  softirqs.CPU5.RCU
     10964 ±  4%     -35.0%       7128 ±  6%  softirqs.CPU50.RCU
     11108 ±  4%     -31.4%       7618 ± 11%  softirqs.CPU51.RCU
     11067 ±  4%     -37.2%       6949 ±  2%  softirqs.CPU52.RCU
     11083 ±  4%     -35.3%       7169 ±  5%  softirqs.CPU53.RCU
     11335 ±  5%     -34.2%       7463 ±  5%  softirqs.CPU54.RCU
     11980 ±  5%     -36.2%       7647        softirqs.CPU55.RCU
     11510 ±  5%     -32.7%       7750 ±  2%  softirqs.CPU56.RCU
     11074 ±  4%     -34.2%       7286        softirqs.CPU57.RCU
     11047 ±  4%     -33.3%       7366 ±  4%  softirqs.CPU58.RCU
     10880 ±  4%     -36.2%       6938        softirqs.CPU59.RCU
     11114 ±  5%     -33.3%       7415 ±  3%  softirqs.CPU6.RCU
     10997 ±  4%     -36.8%       6948 ±  2%  softirqs.CPU60.RCU
     10900 ±  4%     -36.1%       6970 ±  2%  softirqs.CPU61.RCU
     10723 ±  4%     -36.3%       6834 ±  2%  softirqs.CPU62.RCU
     10623 ±  4%     -36.6%       6735        softirqs.CPU63.RCU
     10506 ±  3%     -37.4%       6577        softirqs.CPU64.RCU
     10539 ±  4%     -36.7%       6671 ±  2%  softirqs.CPU65.RCU
     10682 ±  4%     -38.0%       6621 ±  2%  softirqs.CPU66.RCU
     10872 ±  6%     -37.9%       6754 ±  4%  softirqs.CPU67.RCU
     10555 ±  4%     -32.8%       7092 ±  4%  softirqs.CPU68.RCU
     10640 ±  3%     -36.6%       6744 ±  2%  softirqs.CPU69.RCU
     11279 ±  4%     -39.0%       6878 ±  6%  softirqs.CPU7.RCU
     10616 ±  5%     -38.4%       6534        softirqs.CPU70.RCU
     10665 ±  4%     -35.0%       6936 ±  7%  softirqs.CPU71.RCU
     11813 ±  4%     -36.8%       7471        softirqs.CPU72.RCU
     11967 ±  7%     -34.6%       7830 ± 10%  softirqs.CPU73.RCU
     12118 ±  6%     -27.4%       8801 ± 11%  softirqs.CPU74.RCU
     11935 ±  6%     -39.1%       7265        softirqs.CPU75.RCU
     11561 ±  3%     -37.1%       7269 ±  2%  softirqs.CPU76.RCU
     11894 ±  5%     -35.9%       7620 ±  9%  softirqs.CPU77.RCU
     11622 ±  5%     -34.4%       7627 ±  8%  softirqs.CPU78.RCU
     12385 ±  7%     -40.2%       7411 ±  4%  softirqs.CPU79.RCU
     11277 ±  7%     -36.7%       7142        softirqs.CPU8.RCU
     11593 ±  4%     -38.9%       7089 ±  3%  softirqs.CPU80.RCU
     11465 ± 11%     -39.3%       6958 ±  2%  softirqs.CPU81.RCU
     11890 ±  4%     -40.6%       7059        softirqs.CPU82.RCU
     11804 ±  4%     -31.2%       8125 ± 16%  softirqs.CPU83.RCU
     11726 ±  5%     -37.0%       7383        softirqs.CPU84.RCU
     12170 ± 10%     -39.6%       7344 ±  5%  softirqs.CPU85.RCU
     12384 ± 13%     -35.6%       7981 ± 14%  softirqs.CPU86.RCU
     12043 ±  8%     -32.6%       8117 ± 17%  softirqs.CPU87.RCU
     11942 ±  7%     -39.6%       7219 ±  6%  softirqs.CPU88.RCU
     11958 ±  6%     -38.3%       7372 ±  2%  softirqs.CPU89.RCU
     11212 ±  5%     -19.8%       8997 ± 12%  softirqs.CPU9.RCU
     11994 ±  7%     -34.3%       7875 ±  6%  softirqs.CPU90.RCU
     11071 ±  6%     -36.0%       7087 ±  2%  softirqs.CPU91.RCU
     10816 ±  4%     -36.3%       6889 ±  2%  softirqs.CPU92.RCU
     11010 ± 10%     -39.6%       6653        softirqs.CPU93.RCU
     10310 ±  7%     -28.4%       7384 ± 15%  softirqs.CPU94.RCU
     10546 ±  4%     -38.1%       6531 ±  2%  softirqs.CPU95.RCU
     11496 ±  3%     -36.4%       7316 ±  3%  softirqs.CPU96.RCU
     11414 ±  5%     -37.4%       7142        softirqs.CPU97.RCU
     11311 ±  4%     -37.2%       7101 ±  2%  softirqs.CPU98.RCU
     11231 ±  3%     -34.6%       7341 ±  3%  softirqs.CPU99.RCU
   1605973 ±  3%     -35.2%    1040028 ±  2%  softirqs.RCU
  2.03e+09            -2.5%  1.979e+09        interrupts.CAL:Function_call_interrupts
    379.83 ±  6%    +405.3%       1919 ± 30%  interrupts.CPU0.RES:Rescheduling_interrupts
    395.50 ±  4%    +169.1%       1064 ± 16%  interrupts.CPU1.RES:Rescheduling_interrupts
    382.50 ±  8%    +399.1%       1909 ± 29%  interrupts.CPU10.RES:Rescheduling_interrupts
    177.67 ± 25%    +576.9%       1202 ± 19%  interrupts.CPU100.RES:Rescheduling_interrupts
    153.50 ± 21%    +908.0%       1547 ± 14%  interrupts.CPU101.RES:Rescheduling_interrupts
    148.00 ± 22%    +609.5%       1050 ± 12%  interrupts.CPU102.RES:Rescheduling_interrupts
    129.33 ± 20%   +1100.0%       1552 ± 12%  interrupts.CPU103.RES:Rescheduling_interrupts
    119.50 ± 11%   +1196.2%       1549 ± 30%  interrupts.CPU104.RES:Rescheduling_interrupts
    116.50 ± 19%    +773.2%       1017 ± 23%  interrupts.CPU105.RES:Rescheduling_interrupts
    105.00 ± 16%    +958.1%       1111 ±  9%  interrupts.CPU106.RES:Rescheduling_interrupts
     99.17 ± 15%   +2345.0%       2424 ± 17%  interrupts.CPU107.RES:Rescheduling_interrupts
    130.83 ± 13%   +1243.7%       1758 ± 33%  interrupts.CPU108.RES:Rescheduling_interrupts
    126.83 ± 15%    +866.9%       1226 ± 14%  interrupts.CPU109.RES:Rescheduling_interrupts
      9188           -33.6%       6100 ± 35%  interrupts.CPU11.NMI:Non-maskable_interrupts
      9188           -33.6%       6100 ± 35%  interrupts.CPU11.PMI:Performance_monitoring_interrupts
    364.67 ±  3%    +282.6%       1395 ±  8%  interrupts.CPU11.RES:Rescheduling_interrupts
    124.50 ± 12%   +1229.3%       1655 ± 41%  interrupts.CPU110.RES:Rescheduling_interrupts
    111.50 ± 12%    +784.0%     985.67 ± 29%  interrupts.CPU111.RES:Rescheduling_interrupts
    111.50 ± 16%   +1000.4%       1227 ± 29%  interrupts.CPU112.RES:Rescheduling_interrupts
    112.67 ± 12%    +696.4%     897.33 ± 12%  interrupts.CPU113.RES:Rescheduling_interrupts
     98.33 ± 23%   +1228.1%       1306 ± 51%  interrupts.CPU114.RES:Rescheduling_interrupts
     97.00 ±  8%    +984.5%       1052 ± 10%  interrupts.CPU115.RES:Rescheduling_interrupts
     97.17 ± 36%   +1165.5%       1229 ± 14%  interrupts.CPU116.RES:Rescheduling_interrupts
     86.33 ± 12%   +1385.7%       1282 ± 26%  interrupts.CPU117.RES:Rescheduling_interrupts
     91.33 ±  4%    +710.9%     740.67 ± 18%  interrupts.CPU118.RES:Rescheduling_interrupts
    103.83 ± 17%   +1063.4%       1208 ±  5%  interrupts.CPU119.RES:Rescheduling_interrupts
    360.67 ±  3%    +300.5%       1444 ± 23%  interrupts.CPU12.RES:Rescheduling_interrupts
     87.50 ± 16%   +2097.0%       1922 ± 65%  interrupts.CPU120.RES:Rescheduling_interrupts
     97.33 ±  8%    +916.4%     989.33 ± 35%  interrupts.CPU121.RES:Rescheduling_interrupts
      8422 ± 20%     -27.5%       6105 ± 35%  interrupts.CPU122.NMI:Non-maskable_interrupts
      8422 ± 20%     -27.5%       6105 ± 35%  interrupts.CPU122.PMI:Performance_monitoring_interrupts
     89.17 ± 11%   +1131.8%       1098 ± 27%  interrupts.CPU122.RES:Rescheduling_interrupts
     98.50 ± 26%   +1359.9%       1438 ± 38%  interrupts.CPU123.RES:Rescheduling_interrupts
     89.67 ± 13%   +1127.5%       1100 ±  5%  interrupts.CPU124.RES:Rescheduling_interrupts
      8412 ± 20%     -27.4%       6107 ± 35%  interrupts.CPU125.NMI:Non-maskable_interrupts
      8412 ± 20%     -27.4%       6107 ± 35%  interrupts.CPU125.PMI:Performance_monitoring_interrupts
     89.50 ± 17%   +2383.4%       2222 ± 37%  interrupts.CPU125.RES:Rescheduling_interrupts
    123.83 ± 28%   +1028.1%       1397 ± 29%  interrupts.CPU126.RES:Rescheduling_interrupts
      7652 ± 28%     -40.2%       4578        interrupts.CPU127.NMI:Non-maskable_interrupts
      7652 ± 28%     -40.2%       4578        interrupts.CPU127.PMI:Performance_monitoring_interrupts
    109.50 ± 10%    +807.2%     993.33 ± 21%  interrupts.CPU127.RES:Rescheduling_interrupts
      8420 ± 20%     -45.7%       4573        interrupts.CPU128.NMI:Non-maskable_interrupts
      8420 ± 20%     -45.7%       4573        interrupts.CPU128.PMI:Performance_monitoring_interrupts
     95.33 ± 12%   +1019.2%       1067 ± 26%  interrupts.CPU128.RES:Rescheduling_interrupts
      8423 ± 20%     -27.4%       6114 ± 35%  interrupts.CPU129.NMI:Non-maskable_interrupts
      8423 ± 20%     -27.4%       6114 ± 35%  interrupts.CPU129.PMI:Performance_monitoring_interrupts
     90.50 ±  9%   +1170.3%       1149 ±  5%  interrupts.CPU129.RES:Rescheduling_interrupts
    376.50 ±  7%    +295.8%       1490 ± 16%  interrupts.CPU13.RES:Rescheduling_interrupts
    106.83 ± 15%   +1242.9%       1434 ± 21%  interrupts.CPU130.RES:Rescheduling_interrupts
     86.50 ±  3%    +959.0%     916.00 ± 34%  interrupts.CPU131.RES:Rescheduling_interrupts
      8417 ± 20%     -27.4%       6110 ± 35%  interrupts.CPU132.NMI:Non-maskable_interrupts
      8417 ± 20%     -27.4%       6110 ± 35%  interrupts.CPU132.PMI:Performance_monitoring_interrupts
     88.67 ± 20%   +1325.2%       1263 ± 13%  interrupts.CPU132.RES:Rescheduling_interrupts
      9182           -33.5%       6110 ± 35%  interrupts.CPU133.NMI:Non-maskable_interrupts
      9182           -33.5%       6110 ± 35%  interrupts.CPU133.PMI:Performance_monitoring_interrupts
     96.17 ± 14%    +751.3%     818.67 ± 32%  interrupts.CPU133.RES:Rescheduling_interrupts
      9182           -33.5%       6108 ± 35%  interrupts.CPU134.NMI:Non-maskable_interrupts
      9182           -33.5%       6108 ± 35%  interrupts.CPU134.PMI:Performance_monitoring_interrupts
    118.83 ± 42%    +858.5%       1139 ± 54%  interrupts.CPU134.RES:Rescheduling_interrupts
      9178           -33.5%       6107 ± 35%  interrupts.CPU135.NMI:Non-maskable_interrupts
      9178           -33.5%       6107 ± 35%  interrupts.CPU135.PMI:Performance_monitoring_interrupts
     83.33 ± 10%   +1072.4%     977.00 ± 42%  interrupts.CPU135.RES:Rescheduling_interrupts
     79.67 ± 11%    +929.7%     820.33 ± 30%  interrupts.CPU136.RES:Rescheduling_interrupts
     84.83 ±  9%   +1550.3%       1400 ± 35%  interrupts.CPU137.RES:Rescheduling_interrupts
     96.17 ± 19%    +708.3%     777.33 ± 32%  interrupts.CPU138.RES:Rescheduling_interrupts
     85.50 ± 10%   +1402.5%       1284 ± 31%  interrupts.CPU139.RES:Rescheduling_interrupts
    362.00 ±  3%    +328.3%       1550 ± 15%  interrupts.CPU14.RES:Rescheduling_interrupts
     77.67 ± 11%    +949.8%     815.33 ± 33%  interrupts.CPU140.RES:Rescheduling_interrupts
     82.33 ± 20%   +1217.0%       1084 ± 25%  interrupts.CPU141.RES:Rescheduling_interrupts
     95.00 ± 11%    +898.6%     948.67 ±  9%  interrupts.CPU142.RES:Rescheduling_interrupts
    151.83 ±  6%   +1154.7%       1905 ± 21%  interrupts.CPU143.RES:Rescheduling_interrupts
      9191           -33.4%       6122 ± 35%  interrupts.CPU15.NMI:Non-maskable_interrupts
      9191           -33.4%       6122 ± 35%  interrupts.CPU15.PMI:Performance_monitoring_interrupts
    384.83 ± 12%    +257.8%       1377 ± 19%  interrupts.CPU15.RES:Rescheduling_interrupts
    374.67 ±  9%    +324.4%       1590 ± 30%  interrupts.CPU16.RES:Rescheduling_interrupts
    374.67 ±  3%    +434.5%       2002 ± 27%  interrupts.CPU17.RES:Rescheduling_interrupts
    455.83 ±  4%    +830.1%       4239 ± 44%  interrupts.CPU18.RES:Rescheduling_interrupts
    427.00 ±  4%    +389.0%       2088 ± 19%  interrupts.CPU19.RES:Rescheduling_interrupts
    376.00          +192.9%       1101 ± 19%  interrupts.CPU2.RES:Rescheduling_interrupts
    403.33 ±  5%    +296.5%       1599 ±  9%  interrupts.CPU20.RES:Rescheduling_interrupts
    387.33 ±  3%    +373.1%       1832 ± 10%  interrupts.CPU21.RES:Rescheduling_interrupts
      9190           -33.5%       6110 ± 35%  interrupts.CPU22.NMI:Non-maskable_interrupts
      9190           -33.5%       6110 ± 35%  interrupts.CPU22.PMI:Performance_monitoring_interrupts
    371.67 ±  2%    +282.3%       1421 ± 18%  interrupts.CPU22.RES:Rescheduling_interrupts
    365.83 ±  3%    +325.1%       1555 ± 31%  interrupts.CPU23.RES:Rescheduling_interrupts
    364.67 ±  5%    +323.1%       1543 ±  4%  interrupts.CPU24.RES:Rescheduling_interrupts
    359.50 ±  3%    +246.0%       1244 ± 38%  interrupts.CPU25.RES:Rescheduling_interrupts
    360.50 ±  3%    +498.1%       2156 ± 49%  interrupts.CPU26.RES:Rescheduling_interrupts
    351.50 ±  2%    +235.8%       1180 ± 27%  interrupts.CPU27.RES:Rescheduling_interrupts
    352.67          +277.8%       1332 ±  8%  interrupts.CPU28.RES:Rescheduling_interrupts
    360.00 ±  2%    +244.5%       1240 ±  2%  interrupts.CPU29.RES:Rescheduling_interrupts
    389.67 ±  5%    +278.2%       1473 ± 14%  interrupts.CPU3.RES:Rescheduling_interrupts
    372.17 ±  8%    +424.0%       1950 ± 25%  interrupts.CPU30.RES:Rescheduling_interrupts
    360.67 ±  2%    +396.0%       1789 ± 28%  interrupts.CPU31.RES:Rescheduling_interrupts
    352.00          +363.6%       1632 ± 13%  interrupts.CPU32.RES:Rescheduling_interrupts
    351.83          +357.1%       1608 ± 20%  interrupts.CPU33.RES:Rescheduling_interrupts
    363.83 ±  5%    +259.6%       1308 ± 25%  interrupts.CPU34.RES:Rescheduling_interrupts
    350.17 ±  3%    +604.5%       2467 ± 15%  interrupts.CPU35.RES:Rescheduling_interrupts
    447.67 ±  3%    +568.7%       2993 ± 11%  interrupts.CPU36.RES:Rescheduling_interrupts
    458.67 ± 16%    +296.6%       1819 ± 22%  interrupts.CPU37.RES:Rescheduling_interrupts
    411.33          +175.1%       1131 ±  9%  interrupts.CPU38.RES:Rescheduling_interrupts
    392.67 ±  6%    +283.4%       1505 ± 14%  interrupts.CPU39.RES:Rescheduling_interrupts
    374.67 ±  4%    +286.3%       1447 ± 24%  interrupts.CPU4.RES:Rescheduling_interrupts
    387.17 ±  5%    +391.2%       1901 ± 35%  interrupts.CPU40.RES:Rescheduling_interrupts
    381.17 ±  2%    +252.1%       1342 ± 33%  interrupts.CPU41.RES:Rescheduling_interrupts
    362.83 ±  2%    +275.0%       1360 ± 39%  interrupts.CPU42.RES:Rescheduling_interrupts
    372.17 ±  2%    +341.4%       1642 ± 26%  interrupts.CPU43.RES:Rescheduling_interrupts
    363.67 ±  6%    +226.3%       1186 ± 18%  interrupts.CPU44.RES:Rescheduling_interrupts
    356.67 ±  3%    +335.8%       1554 ±  8%  interrupts.CPU45.RES:Rescheduling_interrupts
    354.00          +367.5%       1655 ±  9%  interrupts.CPU46.RES:Rescheduling_interrupts
    349.33 ±  3%    +264.0%       1271 ± 22%  interrupts.CPU47.RES:Rescheduling_interrupts
    357.33 ±  2%    +362.4%       1652 ± 28%  interrupts.CPU48.RES:Rescheduling_interrupts
    349.83 ±  2%    +543.0%       2249 ± 36%  interrupts.CPU49.RES:Rescheduling_interrupts
    374.00 ±  4%    +299.0%       1492 ± 19%  interrupts.CPU5.RES:Rescheduling_interrupts
    354.50 ±  2%    +327.7%       1516 ± 14%  interrupts.CPU50.RES:Rescheduling_interrupts
    357.67 ±  2%    +217.7%       1136 ± 13%  interrupts.CPU51.RES:Rescheduling_interrupts
    377.33 ±  4%    +218.6%       1202 ± 22%  interrupts.CPU52.RES:Rescheduling_interrupts
    430.33 ± 24%    +369.8%       2021 ± 10%  interrupts.CPU53.RES:Rescheduling_interrupts
    466.83 ±  7%    +292.1%       1830 ± 16%  interrupts.CPU54.RES:Rescheduling_interrupts
    408.67 ±  4%    +275.2%       1533 ± 18%  interrupts.CPU55.RES:Rescheduling_interrupts
    383.33 ±  4%    +184.2%       1089 ± 12%  interrupts.CPU56.RES:Rescheduling_interrupts
    394.17 ± 11%    +217.8%       1252 ± 19%  interrupts.CPU57.RES:Rescheduling_interrupts
    415.33 ± 12%    +211.0%       1291 ± 12%  interrupts.CPU58.RES:Rescheduling_interrupts
    369.33 ±  4%    +244.2%       1271 ± 12%  interrupts.CPU59.RES:Rescheduling_interrupts
    387.50 ±  6%    +177.3%       1074 ± 22%  interrupts.CPU6.RES:Rescheduling_interrupts
    376.33 ±  6%    +173.9%       1030 ±  9%  interrupts.CPU60.RES:Rescheduling_interrupts
    368.50 ±  3%    +256.7%       1314 ± 32%  interrupts.CPU61.RES:Rescheduling_interrupts
    387.00 ±  8%    +398.4%       1929 ± 54%  interrupts.CPU62.RES:Rescheduling_interrupts
    357.33 ±  3%    +309.8%       1464 ± 24%  interrupts.CPU63.RES:Rescheduling_interrupts
    358.83 ±  2%    +261.6%       1297 ± 25%  interrupts.CPU64.RES:Rescheduling_interrupts
    369.17 ±  3%    +309.3%       1511 ± 16%  interrupts.CPU65.RES:Rescheduling_interrupts
    363.67 ±  3%    +225.8%       1184 ±  8%  interrupts.CPU66.RES:Rescheduling_interrupts
    357.50 ±  3%    +693.9%       2838 ± 88%  interrupts.CPU67.RES:Rescheduling_interrupts
    356.83 ±  3%    +462.9%       2008 ± 83%  interrupts.CPU68.RES:Rescheduling_interrupts
    351.33 ±  4%    +334.3%       1525 ± 25%  interrupts.CPU69.RES:Rescheduling_interrupts
    378.83 ±  9%    +346.5%       1691 ± 27%  interrupts.CPU7.RES:Rescheduling_interrupts
    346.00          +248.7%       1206 ± 29%  interrupts.CPU70.RES:Rescheduling_interrupts
      1413 ±  8%     +65.9%       2344 ±  4%  interrupts.CPU71.RES:Rescheduling_interrupts
    442.33 ± 10%    +257.4%       1581 ± 25%  interrupts.CPU72.RES:Rescheduling_interrupts
    404.50 ±  3%    +280.0%       1537 ± 34%  interrupts.CPU73.RES:Rescheduling_interrupts
    396.83 ±  5%    +341.6%       1752 ± 33%  interrupts.CPU74.RES:Rescheduling_interrupts
    384.17 ±  4%    +248.4%       1338 ± 32%  interrupts.CPU75.RES:Rescheduling_interrupts
    371.33 ±  4%    +220.2%       1189 ± 12%  interrupts.CPU76.RES:Rescheduling_interrupts
    386.67 ±  7%    +338.4%       1695 ± 36%  interrupts.CPU77.RES:Rescheduling_interrupts
    362.67          +319.7%       1522 ± 33%  interrupts.CPU78.RES:Rescheduling_interrupts
    360.67 ±  3%    +264.7%       1315 ± 12%  interrupts.CPU79.RES:Rescheduling_interrupts
    371.67 ±  7%    +236.4%       1250 ± 11%  interrupts.CPU8.RES:Rescheduling_interrupts
    357.50 ±  2%    +262.4%       1295 ± 22%  interrupts.CPU80.RES:Rescheduling_interrupts
    371.67 ±  5%    +258.8%       1333 ± 22%  interrupts.CPU81.RES:Rescheduling_interrupts
    362.67 ±  4%    +458.8%       2026 ± 17%  interrupts.CPU82.RES:Rescheduling_interrupts
    379.50 ± 11%    +207.4%       1166 ± 12%  interrupts.CPU83.RES:Rescheduling_interrupts
    362.83 ±  4%    +341.3%       1601 ± 47%  interrupts.CPU84.RES:Rescheduling_interrupts
    358.33 ±  4%    +311.5%       1474 ± 38%  interrupts.CPU85.RES:Rescheduling_interrupts
    374.83 ±  7%    +204.0%       1139 ± 21%  interrupts.CPU86.RES:Rescheduling_interrupts
    398.33 ± 16%    +146.8%     983.00 ± 28%  interrupts.CPU87.RES:Rescheduling_interrupts
    345.83 ±  5%    +451.9%       1908 ± 15%  interrupts.CPU88.RES:Rescheduling_interrupts
    351.00 ±  6%    +379.1%       1681 ± 17%  interrupts.CPU89.RES:Rescheduling_interrupts
    374.83 ±  3%    +404.0%       1889 ± 32%  interrupts.CPU9.RES:Rescheduling_interrupts
    366.00 ± 10%    +689.7%       2890 ± 14%  interrupts.CPU90.RES:Rescheduling_interrupts
    349.50 ± 11%    +400.0%       1747 ± 12%  interrupts.CPU91.RES:Rescheduling_interrupts
    337.00 ± 11%    +403.0%       1695 ± 29%  interrupts.CPU92.RES:Rescheduling_interrupts
    289.17 ± 14%    +719.3%       2369 ± 30%  interrupts.CPU93.RES:Rescheduling_interrupts
    277.50 ± 15%    +442.9%       1506 ± 37%  interrupts.CPU94.RES:Rescheduling_interrupts
    259.50 ± 16%    +606.9%       1834 ± 30%  interrupts.CPU95.RES:Rescheduling_interrupts
    239.67 ± 17%    +377.5%       1144 ± 35%  interrupts.CPU96.RES:Rescheduling_interrupts
    214.17 ± 22%    +870.6%       2078 ± 22%  interrupts.CPU97.RES:Rescheduling_interrupts
    202.00 ± 17%    +336.8%     882.33 ± 16%  interrupts.CPU98.RES:Rescheduling_interrupts
    189.83 ± 20%    +390.4%     931.00 ± 52%  interrupts.CPU99.RES:Rescheduling_interrupts
     42341          +407.8%     215020        interrupts.RES:Rescheduling_interrupts



***************************************************************************************************
lkp-cpl-4sp1: 144 threads 4 sockets Intel(R) Xeon(R) Gold 5318H CPU @ 2.50GHz with 128G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/thread/16/debian-10.4-x86_64-20200603.cgz/lkp-cpl-4sp1/tlb_flush1/will-it-scale/0x700001e

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    881519            -8.9%     802893        will-it-scale.16.threads
     55094            -8.9%      50180        will-it-scale.per_thread_ops
    881519            -8.9%     802893        will-it-scale.workload
  78295432           +18.6%   92878961 ±  8%  cpuidle..usage
      8.45            +0.9        9.32        mpstat.cpu.all.sys%
      3763         +1722.9%      68607 ±  3%  vmstat.system.cs
   6292179            -4.7%    5999045        vmstat.system.in
     60233 ±  4%    +278.2%     227817 ±  4%  numa-meminfo.node3.Active
     60233 ±  4%    +278.2%     227817 ±  4%  numa-meminfo.node3.Active(anon)
     79033 ± 43%    +230.6%     261305 ± 20%  numa-meminfo.node3.FilePages
     63708 ±  9%    +275.3%     239107 ±  3%  numa-meminfo.node3.Shmem
     15044 ±  4%    +278.5%      56935 ±  4%  numa-vmstat.node3.nr_active_anon
     19763 ± 43%    +230.6%      65338 ± 20%  numa-vmstat.node3.nr_file_pages
     15931 ±  9%    +275.3%      59789 ±  3%  numa-vmstat.node3.nr_shmem
     15044 ±  4%    +278.5%      56935 ±  4%  numa-vmstat.node3.nr_zone_active_anon
     67214 ± 10%     +14.6%      77043 ±  7%  slabinfo.anon_vma_chain.active_objs
      1054 ± 10%     +14.6%       1208 ±  7%  slabinfo.anon_vma_chain.active_slabs
     67487 ± 10%     +14.6%      77365 ±  7%  slabinfo.anon_vma_chain.num_objs
      1054 ± 10%     +14.6%       1208 ±  7%  slabinfo.anon_vma_chain.num_slabs
    532831            +8.0%     575345        proc-vmstat.nr_active_anon
   1180621            +3.8%    1224980        proc-vmstat.nr_file_pages
     75483            +2.6%      77450        proc-vmstat.nr_inactive_anon
    539700            +8.2%     583812        proc-vmstat.nr_shmem
    532831            +8.0%     575345        proc-vmstat.nr_zone_active_anon
     75483            +2.6%      77450        proc-vmstat.nr_zone_inactive_anon
 2.679e+08            -8.9%  2.442e+08        proc-vmstat.numa_hit
  2.68e+08            -8.9%  2.442e+08        proc-vmstat.numa_local
    546779           +11.7%     610647        proc-vmstat.pgactivate
 2.677e+08            -8.9%   2.44e+08        proc-vmstat.pgalloc_normal
 5.319e+08            -8.9%  4.844e+08        proc-vmstat.pgfault
 2.677e+08            -8.9%  2.439e+08        proc-vmstat.pgfree
     57.00 ± 95%   +5483.3%       3182 ±197%  softirqs.CPU103.TIMER
     34363 ± 22%     +22.8%      42201 ±  3%  softirqs.CPU109.SCHED
     24001 ±  4%      +8.2%      25980 ± 10%  softirqs.CPU11.SCHED
     26220 ±  8%     -11.5%      23206 ±  8%  softirqs.CPU12.SCHED
     37634 ± 12%     +13.1%      42580 ±  3%  softirqs.CPU120.SCHED
     36873 ± 16%     +17.1%      43180        softirqs.CPU125.SCHED
      6832 ±  9%     +25.2%       8555 ± 18%  softirqs.CPU16.RCU
     40797 ±  2%     -18.2%      33367        softirqs.CPU16.SCHED
     40659 ±  2%     -22.1%      31690 ±  5%  softirqs.CPU17.SCHED
     39914 ±  4%      +8.7%      43395 ±  3%  softirqs.CPU49.SCHED
     36889 ± 16%     +26.3%      46576 ± 20%  softirqs.CPU53.SCHED
     12351 ±  5%     -10.9%      11002 ±  7%  softirqs.CPU8.RCU
     37338 ± 17%     +13.6%      42426 ±  2%  softirqs.CPU93.SCHED
     37391 ± 17%     +13.7%      42516 ±  2%  softirqs.CPU95.SCHED
 1.831e+09            -5.0%   1.74e+09        interrupts.CAL:Function_call_interrupts
 2.867e+08 ±  9%     -20.9%  2.268e+08 ± 16%  interrupts.CPU11.TLB:TLB_shootdowns
     68.83 ± 36%   +4923.2%       3457 ± 41%  interrupts.CPU16.NMI:Non-maskable_interrupts
     68.83 ± 36%   +4923.2%       3457 ± 41%  interrupts.CPU16.PMI:Performance_monitoring_interrupts
     31.33 ±161%  +12292.6%       3883 ± 22%  interrupts.CPU16.RES:Rescheduling_interrupts
     84.50 ± 19%   +3919.5%       3396 ± 39%  interrupts.CPU17.NMI:Non-maskable_interrupts
     84.50 ± 19%   +3919.5%       3396 ± 39%  interrupts.CPU17.PMI:Performance_monitoring_interrupts
     17.50 ±109%  +22560.0%       3965 ± 27%  interrupts.CPU17.RES:Rescheduling_interrupts
 2.768e+08 ±  5%     -18.3%   2.26e+08 ± 14%  interrupts.CPU72.TLB:TLB_shootdowns
 2.973e+08 ± 11%     -25.1%  2.226e+08 ± 23%  interrupts.CPU8.TLB:TLB_shootdowns
     72.33 ± 26%   +4111.8%       3046 ± 65%  interrupts.CPU88.NMI:Non-maskable_interrupts
     72.33 ± 26%   +4111.8%       3046 ± 65%  interrupts.CPU88.PMI:Performance_monitoring_interrupts
     22.50 ±167%  +13497.0%       3059 ± 22%  interrupts.CPU88.RES:Rescheduling_interrupts
     76.17 ± 36%   +2769.1%       2185 ± 63%  interrupts.CPU89.NMI:Non-maskable_interrupts
     76.17 ± 36%   +2769.1%       2185 ± 63%  interrupts.CPU89.PMI:Performance_monitoring_interrupts
      9.17 ±115%  +28389.1%       2611 ± 37%  interrupts.CPU89.RES:Rescheduling_interrupts
    648.33 ± 10%     +29.2%     837.50 ± 18%  interrupts.CPU9.RES:Rescheduling_interrupts
     52.50 ± 15%    +254.9%     186.33 ±  4%  interrupts.IWI:IRQ_work_interrupts
     19314 ±  2%    +100.0%      38621 ±  4%  interrupts.RES:Rescheduling_interrupts
      0.00 ± 35%     -66.7%       0.00 ± 31%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      0.01 ± 16%     -77.8%       0.00        perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork
      3.51 ±  4%    +300.8%      14.06 ± 52%  perf-sched.sch_delay.max.ms.worker_thread.kthread.ret_from_fork
    111.09 ±  2%     -94.5%       6.14 ±  7%  perf-sched.total_wait_and_delay.average.ms
     19107         +1693.5%     342694 ±  6%  perf-sched.total_wait_and_delay.count.ms
    111.08 ±  2%     -94.5%       6.14 ±  7%  perf-sched.total_wait_time.average.ms
      0.63 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.05 ± 17%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.08 ± 87%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.73 ±  8%     -84.5%       0.89 ±223%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      0.09 ±  5%     +70.9%       0.15 ± 20%  perf-sched.wait_and_delay.avg.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      0.09 ±  6%     +72.2%       0.15 ± 14%  perf-sched.wait_and_delay.avg.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.05 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
      0.01 ± 15%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
    497.61 ±  8%     -65.2%     173.18 ±  5%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
    495.72 ±  4%     -99.8%       1.19 ±  9%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork
    304.00          -100.0%       0.00        perf-sched.wait_and_delay.count.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
    137.33 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
    135.67 ± 11%    -100.0%       0.00        perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2743           -13.4%       2375        perf-sched.wait_and_delay.count.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      4819           -12.1%       4234        perf-sched.wait_and_delay.count.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
    791.83 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
    671.83 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.count.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
     73.00 ± 11%    +181.7%     205.67 ±  4%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
    778.17 ±  2%  +41662.6%     324982 ±  6%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork
     16.56          -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.43 ±152%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      4.67 ±217%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1213 ± 39%     -86.3%     166.83 ±223%  perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.wait_for_completion.affine_move_task.__set_cpus_allowed_ptr
      1.96 ±  6%     +88.1%       3.70 ± 19%  perf-sched.wait_and_delay.max.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      2.17 ± 19%    +106.0%       4.48 ± 42%  perf-sched.wait_and_delay.max.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      1.93 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
      0.71 ±134%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
      5763           -39.8%       3470        perf-sched.wait_and_delay.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      1059          +183.9%       3006 ± 45%  perf-sched.wait_and_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork
      0.63 ±  3%     +19.5%       0.75 ±  6%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.05 ± 13%     +27.3%       0.06 ±  6%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.04 ± 17%     +34.5%       0.06 ± 18%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.unmap_page_range.zap_page_range.do_madvise
      0.04 ±  9%     +32.9%       0.06 ±  6%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.wp_page_copy.__handle_mm_fault.handle_mm_fault
      0.05 ± 14%     +74.7%       0.09 ± 37%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.zap_page_range.do_madvise.part
      0.08 ±  5%     +73.0%       0.15 ± 21%  perf-sched.wait_time.avg.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      0.08 ±  6%     +75.2%       0.15 ± 15%  perf-sched.wait_time.avg.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.05 ±  9%     +45.8%       0.07 ± 26%  perf-sched.wait_time.avg.ms.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
    497.60 ±  8%     -65.2%     173.18 ±  5%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
    495.70 ±  4%     -99.8%       1.18 ±  9%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork
      0.06 ± 17%     +57.0%       0.10 ± 25%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.unmap_page_range.zap_page_range.do_madvise
      0.08 ± 17%     +54.0%       0.12 ± 10%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.wp_page_copy.__handle_mm_fault.handle_mm_fault
      0.19 ±103%    +644.7%       1.40 ± 88%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.zap_page_range.do_madvise.part
      1.96 ±  6%     +88.2%       3.69 ± 19%  perf-sched.wait_time.max.ms.rwsem_down_read_slowpath.do_madvise.part.0.__x64_sys_madvise
      1.96 ±  6%    +128.1%       4.48 ± 42%  perf-sched.wait_time.max.ms.rwsem_down_read_slowpath.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      1.93 ±  7%     +73.6%       3.34 ±  9%  perf-sched.wait_time.max.ms.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
      5763           -39.8%       3470        perf-sched.wait_time.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      1059          +183.9%       3006 ± 45%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork
 4.315e+09           +31.8%  5.687e+09        perf-stat.i.branch-instructions
     14.41 ±  6%      -3.2       11.18 ±  3%  perf-stat.i.cache-miss-rate%
  60050687            -5.1%   56968208 ±  2%  perf-stat.i.cache-misses
 4.181e+08 ±  6%     +22.0%    5.1e+08 ±  5%  perf-stat.i.cache-references
      3682         +1769.2%      68827 ±  3%  perf-stat.i.context-switches
      2.75           -13.6%       2.38        perf-stat.i.cpi
   5.6e+10            +7.7%  6.032e+10        perf-stat.i.cpu-cycles
    148.56            +2.7%     152.55        perf-stat.i.cpu-migrations
    936.30           +13.4%       1061        perf-stat.i.cycles-between-cache-misses
      0.15 ± 11%      -0.0        0.12 ± 11%  perf-stat.i.dTLB-load-miss-rate%
 5.528e+09           +22.7%  6.783e+09        perf-stat.i.dTLB-loads
      0.21            -0.0        0.20 ±  2%  perf-stat.i.dTLB-store-miss-rate%
   6087357            -7.0%    5663595 ±  2%  perf-stat.i.dTLB-store-misses
 2.895e+09            -2.5%  2.823e+09        perf-stat.i.dTLB-stores
  19456084           -10.2%   17474512        perf-stat.i.iTLB-load-misses
 2.034e+10           +24.7%  2.537e+10        perf-stat.i.instructions
      1067 ±  2%     +37.5%       1468        perf-stat.i.instructions-per-iTLB-miss
      0.36           +15.7%       0.42        perf-stat.i.ipc
      0.39            +7.7%       0.42        perf-stat.i.metric.GHz
    386.28            -6.8%     359.94        perf-stat.i.metric.K/sec
     91.35           +20.1%     109.72        perf-stat.i.metric.M/sec
   1761542            -8.9%    1604821        perf-stat.i.minor-faults
      0.75 ±  6%      +0.4        1.11 ±  4%  perf-stat.i.node-load-miss-rate%
    223203 ±  9%     +53.4%     342504 ±  5%  perf-stat.i.node-load-misses
  43049558            -9.0%   39190464        perf-stat.i.node-loads
     72.15 ±  6%     +13.5       85.67        perf-stat.i.node-store-miss-rate%
     76575 ±  5%    +797.1%     686936 ±  7%  perf-stat.i.node-store-misses
     36453 ± 12%    +229.8%     120214 ±  6%  perf-stat.i.node-stores
   1761543            -8.9%    1604822        perf-stat.i.page-faults
     14.42 ±  6%      -3.2       11.19 ±  3%  perf-stat.overall.cache-miss-rate%
      2.75           -13.6%       2.38        perf-stat.overall.cpi
    932.62           +13.6%       1059        perf-stat.overall.cycles-between-cache-misses
      0.15 ± 11%      -0.0        0.12 ± 11%  perf-stat.overall.dTLB-load-miss-rate%
      0.21            -0.0        0.20 ±  2%  perf-stat.overall.dTLB-store-miss-rate%
      1045           +38.8%       1450        perf-stat.overall.instructions-per-iTLB-miss
      0.36           +15.8%       0.42        perf-stat.overall.ipc
      0.52 ±  9%      +0.4        0.87 ±  5%  perf-stat.overall.node-load-miss-rate%
     67.86 ±  5%     +17.2       85.07        perf-stat.overall.node-store-miss-rate%
   6961497           +36.8%    9523188        perf-stat.overall.path-length
   4.3e+09           +31.8%  5.667e+09        perf-stat.ps.branch-instructions
  59848727            -5.1%   56771113 ±  2%  perf-stat.ps.cache-misses
 4.167e+08 ±  6%     +22.0%  5.082e+08 ±  5%  perf-stat.ps.cache-references
      3668         +1769.9%      68588 ±  3%  perf-stat.ps.context-switches
 5.581e+10            +7.7%  6.011e+10        perf-stat.ps.cpu-cycles
    148.06            +2.7%     152.00        perf-stat.ps.cpu-migrations
 5.509e+09           +22.7%   6.76e+09        perf-stat.ps.dTLB-loads
   6066825            -7.0%    5644008 ±  2%  perf-stat.ps.dTLB-store-misses
 2.885e+09            -2.5%  2.813e+09        perf-stat.ps.dTLB-stores
  19396258 ±  2%     -10.2%   17424044        perf-stat.ps.iTLB-load-misses
 2.027e+10           +24.7%  2.528e+10        perf-stat.ps.instructions
   1755603            -8.9%    1599280        perf-stat.ps.minor-faults
    222251 ±  9%     +53.4%     340934 ±  5%  perf-stat.ps.node-load-misses
  42905931            -9.0%   39056903        perf-stat.ps.node-loads
     76261 ±  5%    +797.2%     684245 ±  7%  perf-stat.ps.node-store-misses
     36159 ± 13%    +230.6%     119551 ±  6%  perf-stat.ps.node-stores
   1755604            -8.9%    1599281        perf-stat.ps.page-faults
 6.137e+12           +24.6%  7.646e+12        perf-stat.total.instructions
      5.85 ± 10%      -1.0        4.88 ± 10%  perf-profile.calltrace.cycles-pp.llist_add_batch.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.ptep_clear_flush
      3.40 ± 11%      -0.7        2.67 ±  9%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.llist_add_batch.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
      2.64 ± 11%      -0.6        2.06 ±  9%  perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.llist_add_batch.smp_call_function_many_cond.on_each_cpu_cond_mask
      2.45 ± 11%      -0.5        1.92 ±  9%  perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.llist_add_batch.smp_call_function_many_cond
      2.44 ± 11%      -0.5        1.90 ±  9%  perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.llist_add_batch
      0.63 ± 12%      -0.4        0.26 ±100%  perf-profile.calltrace.cycles-pp.release_pages.__pagevec_lru_add.lru_add_drain_cpu.lru_add_drain.zap_page_range
      1.58 ± 10%      -0.3        1.28 ±  9%  perf-profile.calltrace.cycles-pp.next_uptodate_page.filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault
      0.68 ± 11%      -0.3        0.38 ± 70%  perf-profile.calltrace.cycles-pp.up_read.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      1.46 ± 10%      -0.3        1.18 ± 10%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.default_send_IPI_mask_sequence_phys.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
      1.61 ± 10%      -0.3        1.32 ± 10%  perf-profile.calltrace.cycles-pp.copy_page.wp_page_copy.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.52 ± 10%      -0.3        1.26 ±  9%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault.__madvise
      0.86 ± 13%      -0.2        0.66 ± 10%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.78 ± 10%      -0.2        0.60 ± 10%  perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.copy_page.wp_page_copy.__handle_mm_fault.handle_mm_fault
      0.78 ± 12%      -0.2        0.62 ± 11%  perf-profile.calltrace.cycles-pp.down_read_trylock.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.71 ± 13%      +0.2        0.86 ±  6%  perf-profile.calltrace.cycles-pp.zap_pte_range.unmap_page_range.zap_page_range.do_madvise.__x64_sys_madvise
      1.22 ± 10%      +0.3        1.51 ±  6%  perf-profile.calltrace.cycles-pp.uncharge_batch.__mem_cgroup_uncharge_list.release_pages.tlb_flush_mmu.tlb_finish_mmu
      0.00            +0.6        0.59 ± 10%  perf-profile.calltrace.cycles-pp.__mod_lruvec_page_state.page_add_file_rmap.do_set_pte.filemap_map_pages.do_fault
      0.00            +0.7        0.69 ±  9%  perf-profile.calltrace.cycles-pp.page_add_file_rmap.do_set_pte.filemap_map_pages.do_fault.__handle_mm_fault
      0.00            +0.8        0.75 ±  9%  perf-profile.calltrace.cycles-pp.do_set_pte.filemap_map_pages.do_fault.__handle_mm_fault.handle_mm_fault
      0.00            +2.3        2.33 ± 21%  perf-profile.calltrace.cycles-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work
      0.00            +3.5        3.51 ± 21%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread
      0.00            +3.5        3.52 ± 21%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread
      0.00            +3.5        3.54 ± 21%  perf-profile.calltrace.cycles-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +3.6        3.59 ± 21%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +3.9        3.86 ± 20%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
      0.00            +3.9        3.88 ± 20%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00            +3.9        3.88 ± 20%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
     12.58 ± 10%      -2.1       10.52 ± 10%  perf-profile.children.cycles-pp.llist_add_batch
      2.11 ± 10%      -0.4        1.72 ±  9%  perf-profile.children.cycles-pp.copy_page
      1.68 ± 10%      -0.3        1.36 ±  9%  perf-profile.children.cycles-pp.next_uptodate_page
      0.83 ± 12%      -0.2        0.66 ± 11%  perf-profile.children.cycles-pp.down_read_trylock
      0.83 ± 11%      -0.2        0.68 ± 10%  perf-profile.children.cycles-pp.up_read
      0.76 ±  9%      -0.1        0.63 ±  9%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.23 ± 13%      -0.1        0.12 ± 12%  perf-profile.children.cycles-pp.mem_cgroup_update_lru_size
      0.52 ± 12%      -0.1        0.42 ±  9%  perf-profile.children.cycles-pp.down_read
      0.27 ± 15%      -0.1        0.17 ± 10%  perf-profile.children.cycles-pp.sync_mm_rss
      0.34 ± 16%      -0.1        0.27 ±  9%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.21 ±  9%      -0.1        0.15 ±  7%  perf-profile.children.cycles-pp.__list_add_valid
      0.30 ± 12%      -0.1        0.25 ±  7%  perf-profile.children.cycles-pp.__perf_sw_event
      0.17 ± 12%      -0.0        0.14 ± 12%  perf-profile.children.cycles-pp.free_unref_page_list
      0.08 ±  9%      -0.0        0.05 ± 46%  perf-profile.children.cycles-pp.syscall_enter_from_user_mode
      0.08 ± 17%      +0.0        0.13 ± 10%  perf-profile.children.cycles-pp.propagate_protected_usage
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.shmem_getpage_gfp
      0.02 ± 99%      +0.1        0.10 ± 25%  perf-profile.children.cycles-pp.lru_cache_add
      0.00            +0.1        0.08 ± 12%  perf-profile.children.cycles-pp.__get_user_nocheck_8
      0.00            +0.1        0.08 ±  9%  perf-profile.children.cycles-pp.perf_callchain_user
      0.00            +0.1        0.09 ± 12%  perf-profile.children.cycles-pp.generic_perform_write
      0.19 ±  5%      +0.1        0.28 ± 13%  perf-profile.children.cycles-pp.perf_trace_sched_stat_runtime
      0.00            +0.1        0.09 ± 14%  perf-profile.children.cycles-pp.generic_file_write_iter
      0.00            +0.1        0.09 ± 14%  perf-profile.children.cycles-pp.__generic_file_write_iter
      0.00            +0.1        0.09 ± 21%  perf-profile.children.cycles-pp.perf_output_sample
      0.00            +0.1        0.09 ± 14%  perf-profile.children.cycles-pp.__libc_write
      0.20 ±  5%      +0.1        0.30 ± 13%  perf-profile.children.cycles-pp.update_curr
      0.00            +0.1        0.10 ± 13%  perf-profile.children.cycles-pp.ksys_write
      0.00            +0.1        0.10 ± 13%  perf-profile.children.cycles-pp.vfs_write
      0.00            +0.1        0.10 ± 13%  perf-profile.children.cycles-pp.new_sync_write
      0.01 ±223%      +0.1        0.12 ±  9%  perf-profile.children.cycles-pp.__orc_find
      0.02 ±141%      +0.1        0.13 ± 24%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.02 ±141%      +0.1        0.13 ± 23%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.01 ±223%      +0.1        0.13 ± 24%  perf-profile.children.cycles-pp.perf_session__process_user_event
      0.00            +0.1        0.13 ± 30%  perf-profile.children.cycles-pp.dequeue_entity
      0.00            +0.1        0.13 ± 30%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.00            +0.1        0.14 ± 11%  perf-profile.children.cycles-pp.mem_cgroup_charge_statistics
      0.03 ±100%      +0.1        0.17 ± 21%  perf-profile.children.cycles-pp.__unwind_start
      0.08 ± 55%      +0.2        0.23 ± 23%  perf-profile.children.cycles-pp.process_simple
      0.12 ± 31%      +0.2        0.29 ± 21%  perf-profile.children.cycles-pp.__libc_start_main
      0.12 ± 31%      +0.2        0.29 ± 21%  perf-profile.children.cycles-pp.main
      0.12 ± 31%      +0.2        0.29 ± 21%  perf-profile.children.cycles-pp.run_builtin
      0.11 ± 36%      +0.2        0.28 ± 22%  perf-profile.children.cycles-pp.cmd_record
      0.11 ± 36%      +0.2        0.28 ± 22%  perf-profile.children.cycles-pp.cmd_sched
      0.09 ± 53%      +0.2        0.26 ± 22%  perf-profile.children.cycles-pp.record__finish_output
      0.09 ± 53%      +0.2        0.26 ± 22%  perf-profile.children.cycles-pp.perf_session__process_events
      0.00            +0.2        0.18 ± 26%  perf-profile.children.cycles-pp.schedule_idle
      0.15 ± 10%      +0.2        0.34 ± 11%  perf-profile.children.cycles-pp.charge_memcg
      0.00            +0.2        0.21 ± 31%  perf-profile.children.cycles-pp.perf_trace_sched_switch
      0.00            +0.2        0.21 ± 11%  perf-profile.children.cycles-pp.perf_trace_sched_wakeup_template
      0.11 ±  6%      +0.2        0.32 ± 16%  perf-profile.children.cycles-pp.unwind_next_frame
      0.23 ± 19%      +0.2        0.45 ±  7%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.00            +0.2        0.23 ± 23%  perf-profile.children.cycles-pp.__count_memcg_events
      0.14 ±  9%      +0.3        0.39 ± 17%  perf-profile.children.cycles-pp.perf_callchain_kernel
      0.03 ±100%      +0.3        0.29 ± 23%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.00            +0.3        0.28 ± 30%  perf-profile.children.cycles-pp.schedule
      0.18 ±  7%      +0.3        0.48 ± 15%  perf-profile.children.cycles-pp.get_perf_callchain
      1.23 ± 10%      +0.3        1.54 ±  6%  perf-profile.children.cycles-pp.uncharge_batch
      0.18 ±  7%      +0.3        0.49 ± 15%  perf-profile.children.cycles-pp.perf_callchain
      0.00            +0.3        0.32 ± 10%  perf-profile.children.cycles-pp.try_to_wake_up
      0.00            +0.3        0.33 ± 10%  perf-profile.children.cycles-pp.__queue_work
      0.18 ±  8%      +0.3        0.52 ± 15%  perf-profile.children.cycles-pp.perf_prepare_sample
      0.04 ± 71%      +0.4        0.45 ± 28%  perf-profile.children.cycles-pp.__schedule
      0.20 ±  6%      +0.4        0.64 ± 17%  perf-profile.children.cycles-pp.perf_event_output_forward
      0.20 ±  6%      +0.4        0.65 ± 17%  perf-profile.children.cycles-pp.perf_swevent_overflow
      0.20 ±  6%      +0.4        0.65 ± 17%  perf-profile.children.cycles-pp.__perf_event_overflow
      0.21 ±  7%      +0.5        0.67 ± 17%  perf-profile.children.cycles-pp.perf_tp_event
      0.00            +0.5        0.47 ±  9%  perf-profile.children.cycles-pp.queue_work_on
      0.36 ± 11%      +0.5        0.83 ±  8%  perf-profile.children.cycles-pp.page_remove_rmap
      0.22 ± 15%      +0.5        0.70 ±  9%  perf-profile.children.cycles-pp.page_add_file_rmap
      0.30 ± 14%      +0.5        0.80 ±  9%  perf-profile.children.cycles-pp.do_set_pte
      0.08 ± 13%      +0.5        0.61 ± 10%  perf-profile.children.cycles-pp.page_add_new_anon_rmap
      0.21 ± 10%      +0.7        0.94 ± 17%  perf-profile.children.cycles-pp._raw_spin_lock
      4.75 ±  8%      +1.3        6.09 ± 10%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      3.86 ±  8%      +1.4        5.24 ± 10%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.18 ± 11%      +1.4        1.62 ± 10%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.08 ± 11%      +1.5        1.58 ±  9%  perf-profile.children.cycles-pp.cgroup_rstat_updated
      0.34 ± 11%      +1.5        1.86 ±  9%  perf-profile.children.cycles-pp.__mod_lruvec_page_state
      0.00            +2.3        2.34 ± 21%  perf-profile.children.cycles-pp.mem_cgroup_css_rstat_flush
      0.00            +3.5        3.52 ± 21%  perf-profile.children.cycles-pp.cgroup_rstat_flush_locked
      0.00            +3.5        3.52 ± 21%  perf-profile.children.cycles-pp.cgroup_rstat_flush_irqsafe
      0.00            +3.5        3.54 ± 21%  perf-profile.children.cycles-pp.mem_cgroup_flush_stats
      0.00            +3.6        3.59 ± 21%  perf-profile.children.cycles-pp.process_one_work
      0.00            +3.9        3.86 ± 20%  perf-profile.children.cycles-pp.worker_thread
      0.01 ±223%      +3.9        3.88 ± 20%  perf-profile.children.cycles-pp.ret_from_fork
      0.01 ±223%      +3.9        3.88 ± 20%  perf-profile.children.cycles-pp.kthread
      1.57 ± 10%      -0.3        1.32 ±  9%  perf-profile.self.cycles-pp.copy_page
      0.53 ± 12%      -0.1        0.41 ± 11%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.23 ± 13%      -0.1        0.12 ± 13%  perf-profile.self.cycles-pp.mem_cgroup_update_lru_size
      0.64 ± 11%      -0.1        0.54 ± 11%  perf-profile.self.cycles-pp.up_read
      0.26 ± 11%      -0.1        0.19 ± 18%  perf-profile.self.cycles-pp.ptep_clear_flush
      0.20 ± 16%      -0.1        0.13 ± 11%  perf-profile.self.cycles-pp.sync_mm_rss
      0.30 ± 12%      -0.1        0.23 ± 12%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.21 ± 10%      -0.1        0.15 ±  9%  perf-profile.self.cycles-pp.__list_add_valid
      0.26 ± 12%      -0.0        0.22 ±  9%  perf-profile.self.cycles-pp.native_flush_tlb_multi
      0.14 ± 14%      -0.0        0.11 ± 14%  perf-profile.self.cycles-pp.sysvec_call_function
      0.06 ± 13%      +0.0        0.08 ±  9%  perf-profile.self.cycles-pp.__mod_node_page_state
      0.06 ± 51%      +0.1        0.11 ± 12%  perf-profile.self.cycles-pp.propagate_protected_usage
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.queue_work_on
      0.02 ±141%      +0.1        0.09 ± 31%  perf-profile.self.cycles-pp.uncharge_batch
      0.00            +0.1        0.07 ± 25%  perf-profile.self.cycles-pp.lru_cache_add
      0.07 ± 18%      +0.1        0.15 ± 27%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.00            +0.1        0.08 ± 17%  perf-profile.self.cycles-pp.lock_page_lruvec_irqsave
      0.01 ±223%      +0.1        0.12 ± 12%  perf-profile.self.cycles-pp.__orc_find
      0.01 ±223%      +0.1        0.12 ± 20%  perf-profile.self.cycles-pp.unwind_next_frame
      0.07 ± 11%      +0.2        0.22 ± 11%  perf-profile.self.cycles-pp.__mod_lruvec_page_state
      0.00            +0.2        0.23 ± 23%  perf-profile.self.cycles-pp.__count_memcg_events
      0.00            +0.2        0.24 ± 24%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.00            +0.5        0.48 ± 20%  perf-profile.self.cycles-pp.cgroup_rstat_flush_locked
      0.07 ±  9%      +0.6        0.68 ± 10%  perf-profile.self.cycles-pp.cgroup_rstat_updated
      0.17 ± 12%      +0.7        0.89 ± 18%  perf-profile.self.cycles-pp._raw_spin_lock
      3.86 ±  8%      +1.4        5.24 ± 10%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.00            +2.2        2.20 ± 21%  perf-profile.self.cycles-pp.mem_cgroup_css_rstat_flush



***************************************************************************************************
lkp-ivb-2ep1: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase/ucode:
  gcc-9/performance/x86_64-rhel-8.3/process/50%/debian-10.4-x86_64-20200603.cgz/lkp-ivb-2ep1/page_fault2/will-it-scale/0x42e

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   5022212            -6.4%    4701021        will-it-scale.24.processes
     49.04            -4.3%      46.93        will-it-scale.24.processes_idle
    209258            -6.4%     195875        will-it-scale.per_process_ops
   5022212            -6.4%    4701021        will-it-scale.workload
  14913009           +21.8%   18167762        cpuidle..usage
      0.09 ±  4%      -0.0        0.08 ±  6%  mpstat.cpu.all.soft%
      1428         +1830.4%      27581 ±  2%  vmstat.system.cs
     39.38            +2.9%      40.51        boot-time.boot
     16.68            +3.3%      17.23        boot-time.dhcp
      1632            +2.6%       1675        boot-time.idle
     75613 ±  3%     +88.9%     142839        meminfo.Active
     75613 ±  3%     +88.9%     142839        meminfo.Active(anon)
     37828           +11.0%      42007        meminfo.Mapped
     17475 ±  9%    +101.4%      35193        numa-vmstat.node1.nr_active_anon
    391.67 ±  4%    +192.1%       1144 ±  9%  numa-vmstat.node1.nr_mapped
     17475 ±  9%    +101.4%      35193        numa-vmstat.node1.nr_zone_active_anon
     93865 ±  6%   +3971.5%    3821722 ±  5%  turbostat.C1
      0.02 ± 28%      +1.5        1.52 ±  3%  turbostat.C1%
  11872222 ± 28%     -29.1%    8418210 ± 31%  turbostat.C6
     91914 ± 47%     +81.1%     166435 ±  9%  numa-meminfo.node0.AnonHugePages
     69904 ±  9%    +101.4%     140786        numa-meminfo.node1.Active
     69904 ±  9%    +101.4%     140786        numa-meminfo.node1.Active(anon)
     82883 ± 52%     -90.2%       8160 ±206%  numa-meminfo.node1.AnonHugePages
      1562 ±  4%    +192.9%       4575 ±  9%  numa-meminfo.node1.Mapped
     18903 ±  3%     +88.9%      35709        proc-vmstat.nr_active_anon
   1437395            +1.3%    1456557        proc-vmstat.nr_file_pages
      9456           +11.1%      10501        proc-vmstat.nr_mapped
    796324            +2.4%     815534        proc-vmstat.nr_shmem
     18903 ±  3%     +88.9%      35709        proc-vmstat.nr_zone_active_anon
      5074 ±  2%     -41.5%       2968 ± 20%  proc-vmstat.numa_hint_faults
 1.521e+09            -6.4%  1.424e+09        proc-vmstat.numa_hit
 1.527e+09            -6.5%  1.428e+09        proc-vmstat.numa_local
     27403 ±  2%     +91.8%      52558        proc-vmstat.pgactivate
 1.519e+09            -6.4%  1.421e+09        proc-vmstat.pgalloc_normal
 1.514e+09            -6.4%  1.417e+09        proc-vmstat.pgfault
 1.519e+09            -6.4%  1.421e+09        proc-vmstat.pgfree
     12599 ±  4%     -27.9%       9079 ±  4%  softirqs.CPU0.RCU
     12490 ± 10%     -34.7%       8150 ± 14%  softirqs.CPU1.RCU
     10055 ± 18%     -31.3%       6907 ± 15%  softirqs.CPU10.RCU
      9178 ± 11%     -24.1%       6966 ± 17%  softirqs.CPU11.RCU
      9027 ±  8%     -38.4%       5558 ±  5%  softirqs.CPU16.RCU
      9393 ±  6%     -40.7%       5568 ±  3%  softirqs.CPU17.RCU
      9337 ±  7%     -39.8%       5621 ±  2%  softirqs.CPU18.RCU
     10797 ± 15%     -33.2%       7213 ±  9%  softirqs.CPU2.RCU
      8835 ±  8%     -38.7%       5414 ±  3%  softirqs.CPU23.RCU
      9496 ± 15%     -34.3%       6238 ±  8%  softirqs.CPU25.RCU
     10199 ± 11%     -31.3%       7005 ± 14%  softirqs.CPU27.RCU
      9196 ± 10%     -28.1%       6615 ±  3%  softirqs.CPU28.RCU
      9372 ±  8%     -21.1%       7392 ±  8%  softirqs.CPU29.RCU
     10367 ±  5%     -28.8%       7383 ±  6%  softirqs.CPU3.RCU
      9716 ±  7%     -26.7%       7118 ± 11%  softirqs.CPU30.RCU
      9264 ±  9%     -26.7%       6791 ±  6%  softirqs.CPU31.RCU
      9461 ±  4%     -40.1%       5667 ±  6%  softirqs.CPU36.RCU
      9581 ±  4%     -39.7%       5776 ±  3%  softirqs.CPU37.RCU
      9639 ±  4%     -38.4%       5936 ±  4%  softirqs.CPU38.RCU
      9476 ±  6%     -37.6%       5909 ±  4%  softirqs.CPU39.RCU
      8905 ± 14%     -35.2%       5769 ±  4%  softirqs.CPU40.RCU
      9316 ±  5%     -38.2%       5755 ±  4%  softirqs.CPU41.RCU
      9538 ±  7%     -40.7%       5654 ±  5%  softirqs.CPU43.RCU
      9040 ±  9%     -38.0%       5602 ±  4%  softirqs.CPU44.RCU
      9497 ±  5%     -39.5%       5744 ±  2%  softirqs.CPU45.RCU
      9791 ±  5%     -39.6%       5913 ±  3%  softirqs.CPU47.RCU
     10535 ± 13%     -28.2%       7567 ± 17%  softirqs.CPU5.RCU
      9718 ± 16%     -29.8%       6823 ±  9%  softirqs.CPU6.RCU
      9877 ±  6%     -28.8%       7031 ± 16%  softirqs.CPU7.RCU
      9856 ± 10%     -32.7%       6635 ±  6%  softirqs.CPU8.RCU
      9757 ±  5%     -29.5%       6878 ±  8%  softirqs.CPU9.RCU
    455819 ±  4%     -32.9%     305892        softirqs.RCU
     44534 ±  2%     +13.7%      50650        softirqs.TIMER
      0.04 ±  6%     -40.7%       0.02 ±  4%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.04 ±  5%     -41.1%       0.02 ± 10%  perf-sched.sch_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64
      0.02 ±  8%     -16.5%       0.02 ±  8%  perf-sched.sch_delay.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.02 ± 18%     -72.9%       0.01 ± 38%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ±  7%     -43.3%       0.01 ± 11%  perf-sched.sch_delay.avg.ms.rcu_gp_kthread.kthread.ret_from_fork
      0.01 ± 24%     -66.0%       0.00 ± 17%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      0.03 ±  5%     -36.4%       0.02 ±  5%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.03 ±  3%     -42.7%       0.02 ± 11%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      0.16 ± 25%     -94.5%       0.01        perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork
      0.05 ±  7%     -34.1%       0.04 ± 18%  perf-sched.sch_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.06 ± 15%     -27.3%       0.04 ± 12%  perf-sched.sch_delay.max.ms.do_nanosleep.hrtimer_nanosleep.__x64_sys_nanosleep.do_syscall_64
      0.07 ± 26%     -36.7%       0.04 ± 25%  perf-sched.sch_delay.max.ms.do_syslog.part.0.kmsg_read.vfs_read
      0.05 ±  9%     -36.7%       0.03 ± 20%  perf-sched.sch_delay.max.ms.rcu_gp_kthread.kthread.ret_from_fork
      0.05 ±  9%     -23.2%       0.04 ± 17%  perf-sched.sch_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.03 ± 11%     -72.1%       0.01 ±  4%  perf-sched.total_sch_delay.average.ms
    173.07 ±  4%     -94.8%       8.94 ±  2%  perf-sched.total_wait_and_delay.average.ms
      7046 ±  4%   +1891.3%     140324 ±  2%  perf-sched.total_wait_and_delay.count.ms
    173.03 ±  4%     -94.8%       8.93 ±  2%  perf-sched.total_wait_time.average.ms
      1.69 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.06 ± 16%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
     31.46 ±223%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.06 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
      0.07 ± 12%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
    397.65 ± 13%     -36.2%     253.86 ±  4%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      5.98 ±  8%     -18.7%       4.86 ±  6%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      0.02 ± 22%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
    615.28           -99.5%       3.38 ±  2%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork
    244.67          -100.0%       0.00        perf-sched.wait_and_delay.count.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
    304.83 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.count.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
     38.83 ±  9%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
    142.17 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
     74.50 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
     77.17 ±  7%     +77.5%     137.00 ±  3%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      1660 ±  8%     +23.7%       2053 ±  6%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
     71.83          -100.0%       0.00        perf-sched.wait_and_delay.count.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
    704.00        +18807.4%     133108 ±  2%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork
     32.94 ± 40%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_wait.kernel_wait4.__do_sys_wait4.do_syscall_64
      0.82 ±120%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      1099 ±223%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.62 ± 66%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.pagecache_get_page.shmem_getpage_gfp.shmem_fault
      0.39 ± 38%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_common.__cond_resched.zap_pte_range.unmap_page_range.unmap_vmas
    417.46 ± 10%     -45.6%     226.95 ± 36%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
      0.35 ± 76%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.wait_for_partner.fifo_open.do_dentry_open.do_open.isra
      0.03 ±188%    +599.4%       0.21 ± 73%  perf-sched.wait_time.avg.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.00 ±223%  +6.1e+05%      11.21 ±222%  perf-sched.wait_time.avg.ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
     24.34 ±223%    +656.2%     184.03 ± 88%  perf-sched.wait_time.avg.ms.preempt_schedule_common.__cond_resched.process_one_work.worker_thread.kthread
      2.63 ±  7%     -49.3%       1.34 ± 25%  perf-sched.wait_time.avg.ms.rcu_gp_kthread.kthread.ret_from_fork
    397.65 ± 13%     -36.2%     253.86 ±  4%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_sys_poll
      5.95 ±  8%     -18.6%       4.85 ±  6%  perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
    615.11           -99.5%       3.37 ±  2%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork
      0.08 ±204%   +1983.0%       1.57 ± 67%  perf-sched.wait_time.max.ms.exit_to_user_mode_prepare.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.01 ±223%  +3.1e+06%     167.26 ±222%  perf-sched.wait_time.max.ms.exit_to_user_mode_prepare.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe
     24.34 ±223%  +11427.3%       2805 ± 99%  perf-sched.wait_time.max.ms.preempt_schedule_common.__cond_resched.process_one_work.worker_thread.kthread
    417.44 ± 10%     -45.6%     226.94 ± 36%  perf-sched.wait_time.max.ms.schedule_timeout.rcu_gp_kthread.kthread.ret_from_fork
     24.89            -2.2%      24.36        perf-stat.i.MPKI
 4.891e+09            +9.3%  5.345e+09        perf-stat.i.branch-instructions
  17202487           +33.3%   22935882        perf-stat.i.branch-misses
     66.86            -4.4       62.43        perf-stat.i.cache-miss-rate%
 4.162e+08            -3.2%  4.029e+08        perf-stat.i.cache-misses
  6.21e+08            +3.8%  6.443e+08        perf-stat.i.cache-references
      1381         +1906.4%      27718 ±  2%  perf-stat.i.context-switches
      2.90            -1.8%       2.85        perf-stat.i.cpi
 7.227e+10            +4.0%  7.518e+10        perf-stat.i.cpu-cycles
    174.81            +7.4%     187.68        perf-stat.i.cycles-between-cache-misses
 8.369e+09            +3.0%  8.623e+09        perf-stat.i.dTLB-loads
  36902358            -6.3%   34593711        perf-stat.i.dTLB-store-misses
 5.358e+09            -4.2%  5.132e+09        perf-stat.i.dTLB-stores
     96.35            -1.0       95.34        perf-stat.i.iTLB-load-miss-rate%
   5776230            -3.3%    5585855        perf-stat.i.iTLB-load-misses
    217681           +24.8%     271664        perf-stat.i.iTLB-loads
 2.514e+10            +5.5%  2.651e+10        perf-stat.i.instructions
      4344            +9.2%       4744        perf-stat.i.instructions-per-iTLB-miss
      0.35            +1.5%       0.35        perf-stat.i.ipc
      1.51            +4.0%       1.57        perf-stat.i.metric.GHz
      1327           +12.0%       1486        perf-stat.i.metric.K/sec
    412.80            +2.4%     422.86        perf-stat.i.metric.M/sec
   4991686            -6.3%    4674888        perf-stat.i.minor-faults
      4.29 ±  4%      +1.8        6.10 ±  3%  perf-stat.i.node-load-miss-rate%
  11608578           +43.0%   16601356        perf-stat.i.node-load-misses
 2.726e+08            -3.3%  2.635e+08        perf-stat.i.node-loads
      1.64 ±  6%      +1.9        3.54 ±  3%  perf-stat.i.node-store-miss-rate%
   4725769          +119.0%   10351554        perf-stat.i.node-store-misses
 3.059e+08            -4.7%  2.916e+08        perf-stat.i.node-stores
   4991695            -6.3%    4674897        perf-stat.i.page-faults
     24.70            -1.6%      24.30        perf-stat.overall.MPKI
      0.35            +0.1        0.43        perf-stat.overall.branch-miss-rate%
     67.02            -4.5       62.52        perf-stat.overall.cache-miss-rate%
      2.87            -1.4%       2.84        perf-stat.overall.cpi
    173.65            +7.5%     186.63        perf-stat.overall.cycles-between-cache-misses
     96.37            -1.0       95.36        perf-stat.overall.iTLB-load-miss-rate%
      4352            +9.1%       4747        perf-stat.overall.instructions-per-iTLB-miss
      0.35            +1.4%       0.35        perf-stat.overall.ipc
      4.09            +1.8        5.93 ±  2%  perf-stat.overall.node-load-miss-rate%
      1.52            +1.9        3.43 ±  2%  perf-stat.overall.node-store-miss-rate%
   1518332           +12.6%    1709474        perf-stat.overall.path-length
 4.874e+09            +9.3%  5.328e+09        perf-stat.ps.branch-instructions
  17158593           +33.5%   22902070        perf-stat.ps.branch-misses
 4.148e+08            -3.2%  4.015e+08        perf-stat.ps.cache-misses
 6.189e+08            +3.8%  6.422e+08        perf-stat.ps.cache-references
      1376         +1907.0%      27627 ±  2%  perf-stat.ps.context-switches
 7.203e+10            +4.0%  7.494e+10        perf-stat.ps.cpu-cycles
 8.341e+09            +3.0%  8.595e+09        perf-stat.ps.dTLB-loads
  36778785            -6.3%   34480016        perf-stat.ps.dTLB-store-misses
  5.34e+09            -4.2%  5.115e+09        perf-stat.ps.dTLB-stores
   5757055            -3.3%    5567467        perf-stat.ps.iTLB-load-misses
    216945           +24.8%     270761        perf-stat.ps.iTLB-loads
 2.506e+10            +5.5%  2.643e+10        perf-stat.ps.instructions
   4975218            -6.3%    4659572        perf-stat.ps.minor-faults
  11571489           +43.0%   16547464        perf-stat.ps.node-load-misses
 2.717e+08            -3.3%  2.626e+08        perf-stat.ps.node-loads
   4710117          +119.0%   10316937        perf-stat.ps.node-store-misses
 3.049e+08            -4.7%  2.907e+08        perf-stat.ps.node-stores
   4975226            -6.3%    4659581        perf-stat.ps.page-faults
 7.625e+12            +5.4%  8.036e+12        perf-stat.total.instructions
    188.00 ±  9%    +145.1%     460.83 ± 60%  interrupts.40:PCI-MSI.2621446-edge.eth0-TxRx-5
     50741           +28.9%      65395        interrupts.CAL:Function_call_interrupts
    724.83 ± 14%    +123.7%       1621 ± 28%  interrupts.CPU0.CAL:Function_call_interrupts
    105.17 ± 15%    +557.4%     691.33 ± 51%  interrupts.CPU0.RES:Rescheduling_interrupts
    206.67 ± 22%    +195.1%     609.83 ± 33%  interrupts.CPU1.RES:Rescheduling_interrupts
    982.83 ±  5%     +53.1%       1504 ± 31%  interrupts.CPU10.CAL:Function_call_interrupts
      6323 ± 11%     -35.7%       4068 ± 16%  interrupts.CPU10.NMI:Non-maskable_interrupts
      6323 ± 11%     -35.7%       4068 ± 16%  interrupts.CPU10.PMI:Performance_monitoring_interrupts
    170.00 ± 18%    +213.4%     532.83 ± 47%  interrupts.CPU11.RES:Rescheduling_interrupts
    184.00 ±  7%    +122.7%     409.83 ± 28%  interrupts.CPU12.RES:Rescheduling_interrupts
    185.00 ± 12%    +143.5%     450.50 ± 38%  interrupts.CPU13.RES:Rescheduling_interrupts
    172.33 ± 11%    +123.4%     385.00 ± 37%  interrupts.CPU14.RES:Rescheduling_interrupts
      1086 ±  5%     +47.7%       1604 ± 14%  interrupts.CPU15.CAL:Function_call_interrupts
    187.50 ± 11%    +305.9%     761.00 ± 28%  interrupts.CPU15.RES:Rescheduling_interrupts
    162.33 ±  8%    +175.2%     446.67 ± 64%  interrupts.CPU16.RES:Rescheduling_interrupts
    171.17 ± 11%    +131.7%     396.67 ± 29%  interrupts.CPU17.RES:Rescheduling_interrupts
    993.50 ±  7%     +42.8%       1418 ±  8%  interrupts.CPU18.CAL:Function_call_interrupts
    174.67 ± 21%    +170.6%     472.67 ± 39%  interrupts.CPU18.RES:Rescheduling_interrupts
    164.50 ± 18%    +105.3%     337.67 ± 28%  interrupts.CPU19.RES:Rescheduling_interrupts
      1018 ±  6%     +58.9%       1618 ± 26%  interrupts.CPU2.CAL:Function_call_interrupts
    216.67 ± 20%    +171.7%     588.67 ± 36%  interrupts.CPU2.RES:Rescheduling_interrupts
    992.33 ±  6%     +27.1%       1261 ± 14%  interrupts.CPU20.CAL:Function_call_interrupts
      1046 ± 12%     +26.6%       1324 ± 10%  interrupts.CPU21.CAL:Function_call_interrupts
    180.17 ±  8%    +126.6%     408.33 ± 43%  interrupts.CPU21.RES:Rescheduling_interrupts
      1014 ±  5%     +80.3%       1828 ± 54%  interrupts.CPU22.CAL:Function_call_interrupts
    175.00 ± 17%    +450.8%     963.83 ±120%  interrupts.CPU22.RES:Rescheduling_interrupts
    941.83           +25.7%       1183 ±  9%  interrupts.CPU24.CAL:Function_call_interrupts
    260.50 ±  5%     +62.5%     423.33 ± 14%  interrupts.CPU24.RES:Rescheduling_interrupts
    204.83 ± 15%    +138.5%     488.50 ± 39%  interrupts.CPU25.RES:Rescheduling_interrupts
    170.00 ± 28%     +75.9%     299.00 ± 23%  interrupts.CPU26.RES:Rescheduling_interrupts
    199.17 ± 14%     +91.3%     381.00 ± 31%  interrupts.CPU27.RES:Rescheduling_interrupts
    991.83 ±  8%     +70.6%       1692 ± 31%  interrupts.CPU28.CAL:Function_call_interrupts
    158.50 ± 34%    +431.0%     841.67 ± 66%  interrupts.CPU28.RES:Rescheduling_interrupts
    154.33 ± 34%    +226.9%     504.50 ± 42%  interrupts.CPU29.RES:Rescheduling_interrupts
    172.83 ± 20%    +159.3%     448.17 ± 33%  interrupts.CPU3.RES:Rescheduling_interrupts
    173.50 ± 27%    +280.0%     659.33 ± 54%  interrupts.CPU30.RES:Rescheduling_interrupts
    188.00 ±  9%    +145.1%     460.83 ± 60%  interrupts.CPU31.40:PCI-MSI.2621446-edge.eth0-TxRx-5
    162.50 ± 33%    +298.4%     647.33 ± 44%  interrupts.CPU31.RES:Rescheduling_interrupts
    989.33 ±  6%     +29.4%       1279 ± 16%  interrupts.CPU32.CAL:Function_call_interrupts
    169.67 ± 12%    +192.4%     496.17 ± 47%  interrupts.CPU32.RES:Rescheduling_interrupts
    182.33 ± 20%    +243.1%     625.67 ± 24%  interrupts.CPU33.RES:Rescheduling_interrupts
    189.83 ± 10%    +105.8%     390.67 ± 29%  interrupts.CPU34.RES:Rescheduling_interrupts
    992.00 ±  6%     +43.2%       1420 ± 36%  interrupts.CPU35.CAL:Function_call_interrupts
      5183 ± 32%     +50.9%       7819 ±  6%  interrupts.CPU35.NMI:Non-maskable_interrupts
      5183 ± 32%     +50.9%       7819 ±  6%  interrupts.CPU35.PMI:Performance_monitoring_interrupts
    195.50 ± 17%    +133.9%     457.33 ± 30%  interrupts.CPU35.RES:Rescheduling_interrupts
    174.67 ±  8%    +121.3%     386.50 ± 46%  interrupts.CPU36.RES:Rescheduling_interrupts
    184.17 ± 12%    +177.9%     511.83 ± 42%  interrupts.CPU37.RES:Rescheduling_interrupts
    198.67 ± 11%    +171.0%     538.33 ± 49%  interrupts.CPU38.RES:Rescheduling_interrupts
    173.50 ± 14%    +148.2%     430.67 ± 30%  interrupts.CPU39.RES:Rescheduling_interrupts
    213.00 ± 20%    +101.6%     429.50 ± 31%  interrupts.CPU4.RES:Rescheduling_interrupts
    961.50           +31.0%       1259 ± 15%  interrupts.CPU41.CAL:Function_call_interrupts
    177.33 ± 20%    +145.3%     435.00 ± 40%  interrupts.CPU42.RES:Rescheduling_interrupts
    971.33           +43.4%       1392 ± 18%  interrupts.CPU44.CAL:Function_call_interrupts
    186.00 ± 12%    +124.8%     418.17 ± 34%  interrupts.CPU44.RES:Rescheduling_interrupts
      1007 ±  4%     +13.9%       1147 ± 12%  interrupts.CPU45.CAL:Function_call_interrupts
      1051 ± 11%     +22.6%       1288 ± 12%  interrupts.CPU46.CAL:Function_call_interrupts
    166.50 ± 14%    +159.5%     432.00 ± 27%  interrupts.CPU46.RES:Rescheduling_interrupts
    941.83 ±  8%     +36.2%       1283 ± 11%  interrupts.CPU47.CAL:Function_call_interrupts
    219.00 ±  5%    +124.0%     490.67 ± 25%  interrupts.CPU47.RES:Rescheduling_interrupts
    990.83 ±  4%     +43.8%       1424 ± 22%  interrupts.CPU5.CAL:Function_call_interrupts
    223.50 ± 17%    +170.2%     604.00 ± 54%  interrupts.CPU5.RES:Rescheduling_interrupts
    989.33 ± 19%     +42.0%       1405 ± 16%  interrupts.CPU6.CAL:Function_call_interrupts
    204.50 ± 19%    +166.3%     544.67 ± 41%  interrupts.CPU6.RES:Rescheduling_interrupts
    205.67 ± 25%    +101.6%     414.67 ± 13%  interrupts.CPU7.RES:Rescheduling_interrupts
    196.33 ±  9%    +142.6%     476.33 ± 39%  interrupts.CPU8.RES:Rescheduling_interrupts
      8829          +168.2%      23681 ±  8%  interrupts.RES:Rescheduling_interrupts
    330.83 ± 11%    +132.7%     770.00 ±  8%  interrupts.TLB:TLB_shootdowns
     10.83 ± 10%      -2.1        8.69 ± 13%  perf-profile.calltrace.cycles-pp.alloc_pages_vma.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     10.31 ± 10%      -2.1        8.18 ± 13%  perf-profile.calltrace.cycles-pp.__alloc_pages.alloc_pages_vma.do_fault.__handle_mm_fault.handle_mm_fault
     10.04 ± 10%      -2.1        7.92 ± 13%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages.alloc_pages_vma.do_fault.__handle_mm_fault
      9.79 ± 10%      -2.1        7.68 ± 13%  perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_pages.alloc_pages_vma.do_fault
      9.07 ± 10%      -2.1        6.98 ± 13%  perf-profile.calltrace.cycles-pp.rmqueue_bulk.rmqueue.get_page_from_freelist.__alloc_pages.alloc_pages_vma
      2.46 ± 35%      -1.8        0.68 ± 71%  perf-profile.calltrace.cycles-pp._raw_spin_lock.free_pcppages_bulk.free_unref_page_list.release_pages.tlb_flush_mmu
      2.45 ± 35%      -1.8        0.68 ± 71%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.free_pcppages_bulk.free_unref_page_list.release_pages
      4.22 ± 18%      -1.7        2.56 ± 13%  perf-profile.calltrace.cycles-pp.free_pcppages_bulk.free_unref_page_list.release_pages.tlb_flush_mmu.zap_pte_range
      4.56 ± 18%      -1.6        2.91 ± 13%  perf-profile.calltrace.cycles-pp.free_unref_page_list.release_pages.tlb_flush_mmu.zap_pte_range.unmap_page_range
      6.60 ± 13%      -1.4        5.14 ± 15%  perf-profile.calltrace.cycles-pp._raw_spin_lock.rmqueue_bulk.rmqueue.get_page_from_freelist.__alloc_pages
      6.58 ± 13%      -1.4        5.14 ± 15%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.rmqueue_bulk.rmqueue.get_page_from_freelist
      2.30 ± 13%      -0.6        1.66 ± 16%  perf-profile.calltrace.cycles-pp.__list_del_entry_valid.rmqueue_bulk.rmqueue.get_page_from_freelist.__alloc_pages
      0.71 ± 15%      +0.6        1.28 ± 14%  perf-profile.calltrace.cycles-pp.charge_memcg.__mem_cgroup_charge.do_fault.__handle_mm_fault.handle_mm_fault
      0.90 ± 15%      +0.7        1.62 ± 14%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.8        0.84 ± 14%  perf-profile.calltrace.cycles-pp.__mod_lruvec_page_state.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas
      0.00            +0.9        0.94 ± 13%  perf-profile.calltrace.cycles-pp.cgroup_rstat_updated.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00            +1.1        1.08 ± 13%  perf-profile.calltrace.cycles-pp.page_remove_rmap.zap_pte_range.unmap_page_range.unmap_vmas.unmap_region
      0.00            +1.3        1.33 ± 11%  perf-profile.calltrace.cycles-pp.cgroup_rstat_updated.__mod_memcg_lruvec_state.__mod_lruvec_page_state.page_add_new_anon_rmap.do_set_pte
      0.00            +1.4        1.44 ± 21%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.release_pages.tlb_flush_mmu
      0.00            +1.5        1.46 ± 20%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.release_pages.tlb_flush_mmu.zap_pte_range
      0.00            +1.5        1.47 ± 20%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.release_pages.tlb_flush_mmu.zap_pte_range.unmap_page_range
      0.50 ± 46%      +1.5        1.98 ± 14%  perf-profile.calltrace.cycles-pp.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.do_set_pte.finish_fault
      0.49 ± 46%      +1.5        1.97 ± 14%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add.do_set_pte
      0.28 ±101%      +1.6        1.92 ± 14%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.lock_page_lruvec_irqsave.__pagevec_lru_add.lru_cache_add
      0.00            +1.7        1.68 ± 11%  perf-profile.calltrace.cycles-pp.__mod_memcg_lruvec_state.__mod_lruvec_page_state.page_add_new_anon_rmap.do_set_pte.finish_fault
      1.83 ± 11%      +2.1        3.90 ± 12%  perf-profile.calltrace.cycles-pp.__pagevec_lru_add.lru_cache_add.do_set_pte.finish_fault.do_fault
      0.12 ±223%      +2.1        2.22 ± 11%  perf-profile.calltrace.cycles-pp.__mod_lruvec_page_state.page_add_new_anon_rmap.do_set_pte.finish_fault.do_fault
      0.12 ±223%      +2.1        2.27 ± 11%  perf-profile.calltrace.cycles-pp.page_add_new_anon_rmap.do_set_pte.finish_fault.do_fault.__handle_mm_fault
      0.00            +2.2        2.17 ± 13%  perf-profile.calltrace.cycles-pp.mem_cgroup_css_rstat_flush.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work
      1.99 ± 10%      +2.2        4.18 ± 12%  perf-profile.calltrace.cycles-pp.lru_cache_add.do_set_pte.finish_fault.do_fault.__handle_mm_fault
      0.00            +3.0        3.02 ± 14%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_locked.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread
      0.00            +3.0        3.03 ± 14%  perf-profile.calltrace.cycles-pp.cgroup_rstat_flush_irqsafe.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread
      0.00            +3.1        3.06 ± 14%  perf-profile.calltrace.cycles-pp.mem_cgroup_flush_stats.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +3.1        3.14 ± 14%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +3.4        3.38 ± 13%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork
      0.00            +3.4        3.40 ± 14%  perf-profile.calltrace.cycles-pp.ret_from_fork
      0.00            +3.4        3.40 ± 14%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork
      5.95 ± 11%      +3.5        9.49 ± 11%  perf-profile.calltrace.cycles-pp.finish_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      2.57 ± 14%      +4.0        6.58 ± 12%  perf-profile.calltrace.cycles-pp.do_set_pte.finish_fault.do_fault.__handle_mm_fault.handle_mm_fault
     12.59 ± 10%      -3.5        9.11 ± 12%  perf-profile.children.cycles-pp._raw_spin_lock
     10.86 ± 10%      -2.1        8.73 ± 13%  perf-profile.children.cycles-pp.alloc_pages_vma
     10.12 ± 10%      -2.1        8.00 ± 13%  perf-profile.children.cycles-pp.get_page_from_freelist
     10.40 ± 10%      -2.1        8.29 ± 13%  perf-profile.children.cycles-pp.__alloc_pages
      9.84 ± 10%      -2.1        7.73 ± 13%  perf-profile.children.cycles-pp.rmqueue
      9.09 ± 10%      -2.1        7.00 ± 13%  perf-profile.children.cycles-pp.rmqueue_bulk
      4.69 ± 19%      -1.8        2.85 ± 13%  perf-profile.children.cycles-pp.free_pcppages_bulk
      5.08 ± 18%      -1.8        3.25 ± 13%  perf-profile.children.cycles-pp.free_unref_page_list
      0.02 ±142%      +0.0        0.07 ± 18%  perf-profile.children.cycles-pp.__get_user_nocheck_8
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.orc_find
      0.02 ±141%      +0.1        0.08 ± 30%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
      0.00            +0.1        0.06 ± 14%  perf-profile.children.cycles-pp.memcpy_erms
      0.08 ± 20%      +0.1        0.15 ± 15%  perf-profile.children.cycles-pp.mem_cgroup_update_lru_size
      0.01 ±223%      +0.1        0.09 ± 14%  perf-profile.children.cycles-pp.__orc_find
      0.00            +0.1        0.08 ± 17%  perf-profile.children.cycles-pp.perf_output_copy
      0.06            +0.1        0.15 ± 15%  perf-profile.children.cycles-pp.__unwind_start
      0.02 ±141%      +0.1        0.12 ±  9%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      0.33 ± 11%      +0.1        0.43 ± 11%  perf-profile.children.cycles-pp.perf_trace_sched_stat_runtime
      0.00            +0.1        0.10 ± 17%  perf-profile.children.cycles-pp.dequeue_entity
      0.00            +0.1        0.11 ± 13%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.35 ± 11%      +0.1        0.46 ± 11%  perf-profile.children.cycles-pp.update_curr
      0.13 ± 21%      +0.1        0.26 ± 19%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      0.00            +0.1        0.13 ± 14%  perf-profile.children.cycles-pp.perf_output_sample
      0.00            +0.1        0.13 ± 17%  perf-profile.children.cycles-pp._find_next_bit
      0.12 ±  8%      +0.1        0.26 ± 12%  perf-profile.children.cycles-pp.unwind_next_frame
      0.00            +0.1        0.14 ± 14%  perf-profile.children.cycles-pp.schedule_idle
      0.00            +0.2        0.15 ± 16%  perf-profile.children.cycles-pp.perf_trace_sched_wakeup_template
      0.00            +0.2        0.16 ± 19%  perf-profile.children.cycles-pp.perf_trace_sched_switch
      0.17 ±  9%      +0.2        0.34 ± 12%  perf-profile.children.cycles-pp.perf_callchain_kernel
      0.11 ± 33%      +0.2        0.28 ± 15%  perf-profile.children.cycles-pp.__count_memcg_events
      0.00            +0.2        0.19 ± 14%  perf-profile.children.cycles-pp.try_to_wake_up
      0.00            +0.2        0.20 ± 15%  perf-profile.children.cycles-pp.__queue_work
      0.22 ± 12%      +0.2        0.43 ± 13%  perf-profile.children.cycles-pp.get_perf_callchain
      0.23 ± 11%      +0.2        0.44 ± 13%  perf-profile.children.cycles-pp.perf_callchain
      0.00            +0.2        0.23 ± 17%  perf-profile.children.cycles-pp.schedule
      0.26 ± 11%      +0.2        0.50 ± 13%  perf-profile.children.cycles-pp.perf_prepare_sample
      0.17 ± 30%      +0.3        0.44 ± 15%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.31 ± 10%      +0.4        0.66 ± 12%  perf-profile.children.cycles-pp.perf_event_output_forward
      0.31 ±  9%      +0.4        0.67 ± 12%  perf-profile.children.cycles-pp.perf_swevent_overflow
      0.31 ±  9%      +0.4        0.66 ± 12%  perf-profile.children.cycles-pp.__perf_event_overflow
      0.00            +0.4        0.37 ± 14%  perf-profile.children.cycles-pp.__schedule
      0.32 ± 10%      +0.4        0.71 ± 13%  perf-profile.children.cycles-pp.perf_tp_event
      0.00            +0.4        0.42 ± 13%  perf-profile.children.cycles-pp.queue_work_on
      0.72 ± 15%      +0.6        1.29 ± 14%  perf-profile.children.cycles-pp.charge_memcg
      0.04 ± 71%      +0.6        0.62 ± 16%  perf-profile.children.cycles-pp.mem_cgroup_charge_statistics
      0.41 ± 13%      +0.7        1.08 ± 13%  perf-profile.children.cycles-pp.page_remove_rmap
      0.90 ± 15%      +0.7        1.63 ± 14%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.46 ± 31%      +1.8        2.27 ± 11%  perf-profile.children.cycles-pp.page_add_new_anon_rmap
      1.84 ± 10%      +2.1        3.92 ± 12%  perf-profile.children.cycles-pp.__pagevec_lru_add
      0.00            +2.2        2.18 ± 13%  perf-profile.children.cycles-pp.mem_cgroup_css_rstat_flush
      1.99 ± 10%      +2.2        4.19 ± 12%  perf-profile.children.cycles-pp.lru_cache_add
      0.62 ± 27%      +2.5        3.09 ± 12%  perf-profile.children.cycles-pp.__mod_lruvec_page_state
      0.38 ± 20%      +2.6        3.01 ± 11%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.94 ± 12%      +2.7        3.64 ± 10%  perf-profile.children.cycles-pp.lock_page_lruvec_irqsave
      0.00            +3.0        3.03 ± 14%  perf-profile.children.cycles-pp.cgroup_rstat_flush_irqsafe
      0.00            +3.0        3.03 ± 14%  perf-profile.children.cycles-pp.cgroup_rstat_flush_locked
      0.00            +3.1        3.06 ± 14%  perf-profile.children.cycles-pp.mem_cgroup_flush_stats
      0.04 ± 73%      +3.1        3.14 ± 14%  perf-profile.children.cycles-pp.process_one_work
      0.04 ± 74%      +3.3        3.38 ± 13%  perf-profile.children.cycles-pp.worker_thread
      0.06 ± 53%      +3.3        3.40 ± 14%  perf-profile.children.cycles-pp.ret_from_fork
      0.06 ± 52%      +3.3        3.40 ± 14%  perf-profile.children.cycles-pp.kthread
      5.96 ± 11%      +3.5        9.49 ± 11%  perf-profile.children.cycles-pp.finish_fault
      0.14 ±  9%      +3.6        3.74 ± 12%  perf-profile.children.cycles-pp.cgroup_rstat_updated
      0.92 ± 11%      +3.9        4.82 ±  9%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      2.58 ± 14%      +4.0        6.59 ± 12%  perf-profile.children.cycles-pp.do_set_pte
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.orc_find
      0.02 ±141%      +0.1        0.07 ± 18%  perf-profile.self.cycles-pp.__mem_cgroup_charge
      0.01 ±223%      +0.1        0.07 ± 32%  perf-profile.self.cycles-pp.__x86_indirect_thunk_rax
      0.00            +0.1        0.06 ± 14%  perf-profile.self.cycles-pp.memcpy_erms
      0.08 ± 17%      +0.1        0.15 ± 14%  perf-profile.self.cycles-pp.mem_cgroup_update_lru_size
      0.01 ±223%      +0.1        0.09 ± 14%  perf-profile.self.cycles-pp.__orc_find
      0.01 ±223%      +0.1        0.09 ± 14%  perf-profile.self.cycles-pp.unwind_next_frame
      0.07 ± 10%      +0.1        0.17 ± 14%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.16 ± 29%      +0.1        0.28 ± 21%  perf-profile.self.cycles-pp.shmem_getpage_gfp
      0.12 ± 24%      +0.1        0.24 ± 19%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.12 ± 11%      +0.1        0.24 ± 15%  perf-profile.self.cycles-pp.lru_cache_add
      0.00            +0.1        0.12 ± 20%  perf-profile.self.cycles-pp._find_next_bit
      0.12 ± 17%      +0.2        0.28 ± 17%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.10 ± 34%      +0.2        0.27 ± 15%  perf-profile.self.cycles-pp.__count_memcg_events
      0.66 ± 11%      +0.2        0.83 ± 13%  perf-profile.self.cycles-pp.__pagevec_lru_add
      0.00            +0.2        0.21 ± 15%  perf-profile.self.cycles-pp.queue_work_on
      0.17 ± 44%      +0.2        0.38 ± 12%  perf-profile.self.cycles-pp.__mod_lruvec_page_state
      0.16 ± 30%      +0.3        0.43 ± 15%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.00            +0.6        0.55 ± 17%  perf-profile.self.cycles-pp.cgroup_rstat_flush_locked
      0.00            +2.1        2.06 ± 13%  perf-profile.self.cycles-pp.mem_cgroup_css_rstat_flush
      0.14 ±  9%      +2.4        2.54 ± 14%  perf-profile.self.cycles-pp.cgroup_rstat_updated



***************************************************************************************************
lkp-csl-2ap4: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz with 192G memory
=========================================================================================
cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/tbox_group/test/testcase/ucode:
  cs-localhost/gcc-9/performance/ipv4/x86_64-rhel-8.3/200%/debian-10.4-x86_64-20200603.cgz/900s/lkp-csl-2ap4/TCP_MAERTS/netperf/0x5003006

commit: 
  3c28c7680e ("memcg: switch lruvec stats to rstat")
  45208c9105 ("memcg: infrastructure to flush memcg stats")

3c28c7680e1c39b9 45208c9105bd96015b98cdf31fb 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      2574 ± 24%     +89.8%       4885 ± 11%  netperf.Throughput_Mbps
    988640 ± 24%     +89.8%    1876064 ± 11%  netperf.Throughput_total_Mbps
  25981439 ± 10%     -37.0%   16381040 ± 28%  netperf.time.involuntary_context_switches
      8753 ±  6%     -20.3%       6979 ±  7%  netperf.time.percent_of_cpu_this_job_got
     78523 ±  6%     -21.5%      61657 ±  8%  netperf.time.system_time
      1362 ± 15%     +43.9%       1960 ±  8%  netperf.time.user_time
 2.858e+09 ± 44%    +162.1%  7.492e+09 ± 16%  netperf.time.voluntary_context_switches
 6.788e+09 ± 24%     +89.8%  1.288e+10 ± 11%  netperf.workload
   7064175 ± 14%     -22.7%    5464112 ±  7%  meminfo.Memused
   6329937 ± 43%    +159.8%   16447499 ± 16%  vmstat.system.cs
      3090            -4.2%       2961        turbostat.Bzy_MHz
    329.05            +4.2%     342.72        turbostat.PkgWatt
      1.74 ± 45%      -0.8        0.89 ± 12%  mpstat.cpu.all.irq%
      9.90 ± 17%      +5.8       15.68 ± 11%  mpstat.cpu.all.soft%
      1.75 ± 12%      +0.7        2.40 ±  7%  mpstat.cpu.all.usr%
      9676 ± 11%     -22.2%       7531 ± 10%  numa-meminfo.node2.KernelStack
   1172908 ± 14%     -39.2%     713309 ± 34%  numa-meminfo.node2.MemUsed
    113939 ±  9%     -19.0%      92278 ±  8%  numa-meminfo.node2.SUnreclaim
    137128 ± 16%     -21.0%     108351 ± 14%  numa-meminfo.node2.Slab
 2.688e+09 ± 19%     +70.4%   4.58e+09 ±  9%  proc-vmstat.numa_hit
 2.689e+09 ± 19%     +70.5%  4.584e+09 ±  9%  proc-vmstat.numa_local
 2.687e+09 ± 19%     +70.4%  4.577e+09 ±  9%  proc-vmstat.pgalloc_normal
 2.687e+09 ± 19%     +70.4%  4.577e+09 ±  9%  proc-vmstat.pgfree
     40702 ±  6%     -21.1%      32117 ±  8%  slabinfo.kmalloc-1k.active_objs
      1282 ±  6%     -21.0%       1013 ±  8%  slabinfo.kmalloc-1k.active_slabs
     41061 ±  6%     -21.0%      32443 ±  8%  slabinfo.kmalloc-1k.num_objs
      1282 ±  6%     -21.0%       1013 ±  8%  slabinfo.kmalloc-1k.num_slabs
 6.707e+08 ± 18%     +60.2%  1.075e+09 ± 18%  numa-numastat.node1.local_node
 6.702e+08 ± 18%     +60.1%  1.073e+09 ± 18%  numa-numastat.node1.numa_hit
 6.588e+08 ± 22%     +80.8%  1.191e+09 ± 19%  numa-numastat.node2.local_node
 6.584e+08 ± 22%     +80.8%   1.19e+09 ± 19%  numa-numastat.node2.numa_hit
 6.088e+08 ± 18%    +104.8%  1.247e+09 ± 24%  numa-numastat.node3.local_node
 6.085e+08 ± 18%    +104.7%  1.246e+09 ± 24%  numa-numastat.node3.numa_hit
 3.151e+08 ± 10%     +46.5%  4.615e+08 ± 15%  numa-vmstat.node1.numa_hit
 3.152e+08 ± 10%     +46.5%  4.619e+08 ± 15%  numa-vmstat.node1.numa_local
      9675 ± 11%     -22.2%       7531 ± 10%  numa-vmstat.node2.nr_kernel_stack
     28479 ±  9%     -19.0%      23071 ±  8%  numa-vmstat.node2.nr_slab_unreclaimable
 3.059e+08 ± 15%     +75.1%  5.356e+08 ± 19%  numa-vmstat.node2.numa_hit
  3.06e+08 ± 15%     +75.2%   5.36e+08 ± 19%  numa-vmstat.node2.numa_local
  2.93e+08 ± 13%    +100.4%  5.873e+08 ± 27%  numa-vmstat.node3.numa_hit
 2.931e+08 ± 13%    +100.6%   5.88e+08 ± 27%  numa-vmstat.node3.numa_local
    900879 ± 16%    +123.8%    2016377 ± 34%  interrupts.CAL:Function_call_interrupts
      4684 ± 81%    +137.2%      11108 ± 52%  interrupts.CPU111.CAL:Function_call_interrupts
      8604 ± 88%    +555.0%      56360 ±102%  interrupts.CPU119.RES:Rescheduling_interrupts
      7399 ±108%    +442.6%      40147 ± 78%  interrupts.CPU120.RES:Rescheduling_interrupts
      4862 ± 59%    +702.4%      39017 ± 81%  interrupts.CPU121.RES:Rescheduling_interrupts
      6346 ± 88%    +414.4%      32643 ± 69%  interrupts.CPU122.RES:Rescheduling_interrupts
      5540 ± 88%    +441.9%      30028 ± 96%  interrupts.CPU125.RES:Rescheduling_interrupts
      2600 ± 38%   +1434.7%      39915 ± 89%  interrupts.CPU127.RES:Rescheduling_interrupts
      8383 ±121%    +498.5%      50175 ± 70%  interrupts.CPU128.RES:Rescheduling_interrupts
      6096 ±144%    +520.5%      37830 ± 45%  interrupts.CPU129.RES:Rescheduling_interrupts
      5734 ±116%    +496.5%      34206 ± 59%  interrupts.CPU132.RES:Rescheduling_interrupts
      5656 ±129%    +471.5%      32326 ±101%  interrupts.CPU133.RES:Rescheduling_interrupts
      3867 ± 43%    +914.6%      39241 ± 82%  interrupts.CPU134.RES:Rescheduling_interrupts
      6416 ± 81%    +384.1%      31059 ± 66%  interrupts.CPU135.RES:Rescheduling_interrupts
      3990 ± 81%    +657.2%      30213 ± 96%  interrupts.CPU137.RES:Rescheduling_interrupts
      4405 ± 77%    +444.2%      23977 ± 51%  interrupts.CPU140.RES:Rescheduling_interrupts
      4484 ± 86%    +609.1%      31800 ± 83%  interrupts.CPU141.RES:Rescheduling_interrupts
      4224 ± 99%    +727.7%      34966 ± 76%  interrupts.CPU142.RES:Rescheduling_interrupts
      3431 ± 18%    +784.3%      30341 ± 81%  interrupts.CPU145.RES:Rescheduling_interrupts
      2352 ± 38%   +1557.5%      38996 ± 84%  interrupts.CPU148.RES:Rescheduling_interrupts
      4951 ±116%    +794.3%      44284 ± 95%  interrupts.CPU154.RES:Rescheduling_interrupts
      3475 ± 51%    +885.8%      34261 ± 75%  interrupts.CPU155.RES:Rescheduling_interrupts
      5275 ± 96%    +459.9%      29536 ± 74%  interrupts.CPU156.RES:Rescheduling_interrupts
      3023 ± 39%   +1650.8%      52936 ± 82%  interrupts.CPU158.RES:Rescheduling_interrupts
      2403 ± 39%   +1303.5%      33729 ± 68%  interrupts.CPU159.RES:Rescheduling_interrupts
     13265 ± 76%    +282.4%      50733 ± 97%  interrupts.CPU16.RES:Rescheduling_interrupts
      2118 ± 41%    +389.6%      10374 ± 73%  interrupts.CPU160.CAL:Function_call_interrupts
      6751 ± 90%    +563.9%      44826 ± 89%  interrupts.CPU160.RES:Rescheduling_interrupts
      2847 ± 62%    +305.0%      11532 ± 58%  interrupts.CPU162.CAL:Function_call_interrupts
      4415 ± 87%    +600.5%      30928 ±114%  interrupts.CPU163.RES:Rescheduling_interrupts
      6583 ± 64%    +503.9%      39757 ± 62%  interrupts.CPU165.RES:Rescheduling_interrupts
      1768 ± 46%   +1899.3%      35354 ± 99%  interrupts.CPU166.RES:Rescheduling_interrupts
      5692 ± 52%   +1069.4%      66566 ± 88%  interrupts.CPU168.RES:Rescheduling_interrupts
      7636 ±134%    +921.2%      77987 ± 80%  interrupts.CPU169.RES:Rescheduling_interrupts
      5895 ± 54%   +1040.2%      67222 ± 91%  interrupts.CPU170.RES:Rescheduling_interrupts
      2143 ± 65%    +772.4%      18699 ± 84%  interrupts.CPU172.CAL:Function_call_interrupts
      2246 ± 22%   +3782.4%      87211 ± 80%  interrupts.CPU172.RES:Rescheduling_interrupts
      2725 ± 49%   +2580.0%      73044 ± 81%  interrupts.CPU173.RES:Rescheduling_interrupts
      6920 ± 57%   +1043.3%      79122 ± 67%  interrupts.CPU174.RES:Rescheduling_interrupts
      2433 ± 59%    +637.2%      17938 ±111%  interrupts.CPU175.CAL:Function_call_interrupts
      4825 ±124%   +1761.5%      89827 ± 69%  interrupts.CPU175.RES:Rescheduling_interrupts
      2183 ± 42%    +604.2%      15377 ± 95%  interrupts.CPU176.CAL:Function_call_interrupts
      2923 ± 91%    +493.4%      17347 ±120%  interrupts.CPU178.CAL:Function_call_interrupts
      6260 ± 87%   +1158.2%      78772 ± 99%  interrupts.CPU178.RES:Rescheduling_interrupts
      3955 ± 37%   +1554.9%      65457 ± 93%  interrupts.CPU179.RES:Rescheduling_interrupts
      7484 ± 60%    +766.8%      64871 ±101%  interrupts.CPU180.RES:Rescheduling_interrupts
      2718 ± 51%   +2359.8%      66861 ±111%  interrupts.CPU182.RES:Rescheduling_interrupts
      8077 ±115%    +692.1%      63984 ± 84%  interrupts.CPU183.RES:Rescheduling_interrupts
      5381 ± 93%    +992.5%      58789 ± 83%  interrupts.CPU184.RES:Rescheduling_interrupts
      5614 ± 95%   +1117.2%      68344 ± 85%  interrupts.CPU185.RES:Rescheduling_interrupts
      2586 ± 39%    +367.0%      12080 ± 91%  interrupts.CPU186.CAL:Function_call_interrupts
     11775 ± 84%    +423.6%      61655 ± 95%  interrupts.CPU186.RES:Rescheduling_interrupts
      5136 ± 60%   +1331.7%      73530 ± 95%  interrupts.CPU187.RES:Rescheduling_interrupts
     12116 ±154%    +702.9%      97280 ± 93%  interrupts.CPU189.RES:Rescheduling_interrupts
      3552 ± 35%   +2136.0%      79433 ± 92%  interrupts.CPU190.RES:Rescheduling_interrupts
      5876 ± 60%   +1271.1%      80565 ± 98%  interrupts.CPU191.RES:Rescheduling_interrupts
      9250 ±100%    +531.2%      58394 ±110%  interrupts.CPU23.RES:Rescheduling_interrupts
      4766 ± 67%    +501.7%      28678 ±124%  interrupts.CPU27.RES:Rescheduling_interrupts
      4668 ± 55%    +643.1%      34687 ± 87%  interrupts.CPU29.RES:Rescheduling_interrupts
      2709 ± 47%   +1409.8%      40911 ±100%  interrupts.CPU31.RES:Rescheduling_interrupts
      8442 ± 92%    +462.9%      47521 ± 76%  interrupts.CPU32.RES:Rescheduling_interrupts
      5793 ± 54%    +350.2%      26083 ± 75%  interrupts.CPU34.RES:Rescheduling_interrupts
      6938 ± 81%    +392.4%      34166 ± 51%  interrupts.CPU36.RES:Rescheduling_interrupts
      2737 ± 63%   +1293.5%      38146 ± 79%  interrupts.CPU38.RES:Rescheduling_interrupts
      5031 ± 81%    +531.8%      31791 ± 84%  interrupts.CPU42.RES:Rescheduling_interrupts
      4377 ± 38%    +654.6%      33031 ± 70%  interrupts.CPU45.RES:Rescheduling_interrupts
      6546 ± 15%    +599.8%      45814 ± 55%  interrupts.CPU48.RES:Rescheduling_interrupts
      2766 ± 55%    +167.5%       7399 ± 62%  interrupts.CPU52.CAL:Function_call_interrupts
      2564 ± 35%   +1464.7%      40133 ± 82%  interrupts.CPU52.RES:Rescheduling_interrupts
      5679 ±101%    +488.3%      33411 ± 86%  interrupts.CPU53.RES:Rescheduling_interrupts
      4120 ± 59%    +626.0%      29910 ± 73%  interrupts.CPU55.RES:Rescheduling_interrupts
      4747 ± 68%    +654.0%      35795 ± 76%  interrupts.CPU59.RES:Rescheduling_interrupts
      2226 ± 40%    +385.7%      10816 ± 61%  interrupts.CPU64.CAL:Function_call_interrupts
      7061 ± 79%    +457.0%      39332 ± 78%  interrupts.CPU64.RES:Rescheduling_interrupts
      3674 ± 89%    +178.1%      10218 ± 66%  interrupts.CPU67.CAL:Function_call_interrupts
      5487 ±113%    +533.0%      34735 ± 88%  interrupts.CPU67.RES:Rescheduling_interrupts
     11021 ±108%    +161.3%      28800 ± 66%  interrupts.CPU68.RES:Rescheduling_interrupts
      3486 ± 76%    +916.4%      35438 ± 89%  interrupts.CPU70.RES:Rescheduling_interrupts
      6585 ±121%    +515.9%      40563 ± 97%  interrupts.CPU71.RES:Rescheduling_interrupts
      5839 ± 56%    +831.1%      54364 ± 99%  interrupts.CPU72.RES:Rescheduling_interrupts
      3691 ± 59%    +376.1%      17572 ± 59%  interrupts.CPU73.CAL:Function_call_interrupts
      9657 ± 83%    +619.5%      69488 ± 78%  interrupts.CPU73.RES:Rescheduling_interrupts
      7255 ± 64%    +803.7%      65564 ± 91%  interrupts.CPU74.RES:Rescheduling_interrupts
      4226 ± 55%   +1920.2%      85372 ± 77%  interrupts.CPU76.RES:Rescheduling_interrupts
      4259 ± 24%   +1661.7%      75047 ± 77%  interrupts.CPU77.RES:Rescheduling_interrupts
      1750 ± 54%   +1091.9%      20859 ±106%  interrupts.CPU79.CAL:Function_call_interrupts
      4579 ± 89%   +2046.8%      98302 ± 59%  interrupts.CPU79.RES:Rescheduling_interrupts
      3420 ± 62%    +247.6%      11889 ± 69%  interrupts.CPU8.CAL:Function_call_interrupts
      4484 ± 57%   +1629.9%      77581 ± 85%  interrupts.CPU80.RES:Rescheduling_interrupts
      7969 ± 52%    +871.1%      77389 ± 88%  interrupts.CPU81.RES:Rescheduling_interrupts
      3367 ± 59%    +377.9%      16092 ±108%  interrupts.CPU82.CAL:Function_call_interrupts
      6865 ± 91%   +1049.3%      78911 ± 97%  interrupts.CPU82.RES:Rescheduling_interrupts
      6283 ± 64%   +1005.2%      69447 ± 92%  interrupts.CPU83.RES:Rescheduling_interrupts
      4150 ± 50%   +1692.5%      74395 ± 98%  interrupts.CPU86.RES:Rescheduling_interrupts
      7421 ± 80%    +912.5%      75142 ± 77%  interrupts.CPU89.RES:Rescheduling_interrupts
      9035 ± 86%    +651.1%      67865 ± 87%  interrupts.CPU90.RES:Rescheduling_interrupts
      3631 ± 44%   +2094.1%      79666 ± 99%  interrupts.CPU91.RES:Rescheduling_interrupts
     10978 ±149%    +734.7%      91630 ± 96%  interrupts.CPU93.RES:Rescheduling_interrupts
      5030 ± 65%   +1457.5%      78348 ± 69%  interrupts.CPU94.RES:Rescheduling_interrupts
   1616844 ± 88%    +491.5%    9563110 ± 29%  interrupts.RES:Rescheduling_interrupts
  14234744 ± 62%    +111.7%   30137685 ± 50%  softirqs.CPU103.NET_RX
  15166105 ± 68%    +110.4%   31916351 ± 46%  softirqs.CPU116.NET_RX
  13989220 ± 71%    +135.1%   32885769 ± 31%  softirqs.CPU121.NET_RX
  11649887 ± 68%    +176.8%   32245171 ± 25%  softirqs.CPU122.NET_RX
     99225 ±  4%     +10.0%     109151 ±  4%  softirqs.CPU122.TIMER
  12580771 ± 39%    +153.4%   31876377 ± 29%  softirqs.CPU123.NET_RX
   9819456 ± 62%    +212.5%   30688551 ± 27%  softirqs.CPU124.NET_RX
     98889 ±  2%     +10.6%     109323 ±  3%  softirqs.CPU124.TIMER
  11477315 ± 58%    +184.8%   32684945 ± 27%  softirqs.CPU125.NET_RX
  11277834 ± 55%    +149.3%   28118688 ± 36%  softirqs.CPU127.NET_RX
     99637 ±  2%      +9.1%     108741 ±  3%  softirqs.CPU127.TIMER
  11765824 ± 62%    +187.4%   33814408 ± 29%  softirqs.CPU129.NET_RX
     99421 ±  3%      +8.1%     107434 ±  2%  softirqs.CPU130.TIMER
  13104876 ± 58%    +138.9%   31301537 ± 22%  softirqs.CPU132.NET_RX
  10163277 ± 50%    +203.0%   30798080 ± 31%  softirqs.CPU134.NET_RX
  10830918 ± 81%    +192.5%   31681622 ± 25%  softirqs.CPU135.NET_RX
  11701606 ± 44%    +149.4%   29186636 ± 35%  softirqs.CPU136.NET_RX
  12543121 ± 55%    +160.4%   32657321 ± 28%  softirqs.CPU139.NET_RX
  14157200 ± 53%    +114.7%   30401897 ± 28%  softirqs.CPU140.NET_RX
  14720881 ± 41%    +157.3%   37874607 ± 21%  softirqs.CPU144.NET_RX
  10361303 ± 47%    +248.9%   36154051 ± 18%  softirqs.CPU145.NET_RX
  12781741 ± 60%    +166.0%   33998254 ± 33%  softirqs.CPU146.NET_RX
     99930 ±  5%      +9.6%     109558 ±  5%  softirqs.CPU146.TIMER
   8735463 ± 66%    +294.0%   34414443 ± 28%  softirqs.CPU148.NET_RX
     98948 ±  4%      +9.7%     108510 ±  3%  softirqs.CPU148.TIMER
  15215465 ± 60%    +147.8%   37700459 ± 31%  softirqs.CPU150.NET_RX
    100989 ±  5%     +10.9%     112038 ±  7%  softirqs.CPU150.TIMER
   8823584 ± 98%    +325.3%   37526933 ± 33%  softirqs.CPU151.NET_RX
   9410354 ± 80%    +276.2%   35397794 ± 34%  softirqs.CPU154.NET_RX
     98458 ±  5%     +10.8%     109109 ±  4%  softirqs.CPU154.TIMER
  11427331 ± 37%    +218.6%   36408545 ± 32%  softirqs.CPU155.NET_RX
  11774083 ± 77%    +196.1%   34867757 ± 26%  softirqs.CPU156.NET_RX
     99426 ±  4%     +10.9%     110296 ±  4%  softirqs.CPU156.TIMER
  12384525 ± 50%    +214.9%   38994131 ± 25%  softirqs.CPU157.NET_RX
     99359 ±  4%     +13.1%     112340 ±  8%  softirqs.CPU158.TIMER
   9539416 ± 78%    +270.8%   35370056 ± 36%  softirqs.CPU159.NET_RX
     98112 ±  3%     +10.7%     108565 ±  4%  softirqs.CPU159.TIMER
  14024257 ± 63%    +141.1%   33810731 ± 28%  softirqs.CPU160.NET_RX
  11911677 ± 39%    +207.5%   36631132 ± 30%  softirqs.CPU161.NET_RX
  14490899 ± 82%    +160.6%   37761237 ± 24%  softirqs.CPU163.NET_RX
  15385492 ± 41%    +150.8%   38589823 ± 19%  softirqs.CPU165.NET_RX
  10070218 ± 71%    +249.8%   35228287 ± 31%  softirqs.CPU166.NET_RX
     99062 ±  5%     +10.5%     109429 ±  5%  softirqs.CPU166.TIMER
  11244119 ± 31%    +244.3%   38718603 ± 31%  softirqs.CPU168.NET_RX
  11842159 ± 40%    +258.0%   42396595 ± 24%  softirqs.CPU169.NET_RX
  15092199 ± 26%    +157.7%   38889141 ± 26%  softirqs.CPU170.NET_RX
   8781209 ± 73%    +346.5%   39208115 ± 36%  softirqs.CPU172.NET_RX
   9944219 ± 37%    +323.3%   42095180 ± 27%  softirqs.CPU173.NET_RX
  14360085 ± 28%    +183.3%   40676347 ± 30%  softirqs.CPU174.NET_RX
  12544488 ± 48%    +214.0%   39393746 ± 34%  softirqs.CPU175.NET_RX
  12793260 ± 60%    +212.5%   39977499 ± 30%  softirqs.CPU176.NET_RX
  13027065 ± 40%    +196.2%   38591070 ± 32%  softirqs.CPU178.NET_RX
  13239284 ± 49%    +225.1%   43040902 ± 17%  softirqs.CPU179.NET_RX
  13435769 ± 32%    +190.7%   39062923 ± 36%  softirqs.CPU180.NET_RX
  14923921 ± 35%    +152.7%   37711888 ± 34%  softirqs.CPU181.NET_RX
  13534665 ± 39%    +201.6%   40815880 ± 34%  softirqs.CPU183.NET_RX
  10043983 ± 47%    +283.0%   38467933 ± 32%  softirqs.CPU184.NET_RX
  10350988 ± 42%    +284.7%   39822487 ± 29%  softirqs.CPU185.NET_RX
  12696988 ± 50%    +217.1%   40266259 ± 24%  softirqs.CPU186.NET_RX
  14434520 ± 27%    +180.5%   40493160 ± 31%  softirqs.CPU187.NET_RX
  11710254 ± 55%    +268.7%   43173863 ± 26%  softirqs.CPU189.NET_RX
  13111257 ± 39%    +219.9%   41937691 ± 29%  softirqs.CPU190.NET_RX
  14449787 ± 34%    +186.9%   41449605 ± 25%  softirqs.CPU191.NET_RX
  16833022 ± 50%     +90.1%   31997301 ± 51%  softirqs.CPU21.NET_RX
  13823903 ± 71%    +129.7%   31750030 ± 37%  softirqs.CPU25.NET_RX
  13905255 ± 54%    +139.3%   33275334 ± 26%  softirqs.CPU26.NET_RX
     99993 ±  3%      +9.2%     109186 ±  3%  softirqs.CPU26.TIMER
  14406440 ± 53%    +128.8%   32959318 ± 25%  softirqs.CPU27.NET_RX
  12272454 ± 50%    +155.1%   31308890 ± 28%  softirqs.CPU28.NET_RX
  11468614 ± 67%    +173.4%   31360670 ± 36%  softirqs.CPU29.NET_RX
     98799 ±  3%      +8.8%     107534 ±  2%  softirqs.CPU29.TIMER
  13233831 ± 65%    +140.8%   31865015 ± 18%  softirqs.CPU36.NET_RX
  11385376 ± 45%    +157.4%   29309523 ± 30%  softirqs.CPU38.NET_RX
  12660613 ± 57%    +146.4%   31196260 ± 21%  softirqs.CPU39.NET_RX
  11930635 ± 47%    +155.8%   30523635 ± 29%  softirqs.CPU40.NET_RX
     99592 ±  3%      +9.5%     109072 ±  3%  softirqs.CPU43.TIMER
  13546747 ± 58%    +121.9%   30061759 ± 26%  softirqs.CPU44.NET_RX
  12405619 ± 32%    +159.9%   32236355 ± 31%  softirqs.CPU46.NET_RX
  13907807 ± 43%    +174.0%   38107265 ± 23%  softirqs.CPU48.NET_RX
  13517535 ± 39%    +178.1%   37593718 ± 23%  softirqs.CPU49.NET_RX
     99083 ±  4%      +9.6%     108583 ±  5%  softirqs.CPU50.TIMER
  10960038 ± 91%    +246.3%   37953056 ± 34%  softirqs.CPU51.NET_RX
  11448489 ± 54%    +218.8%   36501698 ± 31%  softirqs.CPU52.NET_RX
     98950 ±  4%      +9.8%     108658 ±  4%  softirqs.CPU52.TIMER
     99658 ±  3%      +9.0%     108626 ±  5%  softirqs.CPU53.TIMER
  15615465 ± 42%    +138.3%   37218121 ± 31%  softirqs.CPU54.NET_RX
    100687 ±  4%      +8.7%     109406 ±  5%  softirqs.CPU54.TIMER
     99797 ±  4%      +7.9%     107722 ±  3%  softirqs.CPU56.TIMER
     99478 ±  4%      +8.6%     108015 ±  5%  softirqs.CPU57.TIMER
  10003149 ± 64%    +259.3%   35937916 ± 34%  softirqs.CPU58.NET_RX
     98347 ±  4%     +10.4%     108554 ±  5%  softirqs.CPU58.TIMER
  11687808 ± 64%    +214.2%   36723266 ± 33%  softirqs.CPU59.NET_RX
  12937071 ± 37%    +197.7%   38514140 ± 26%  softirqs.CPU61.NET_RX
  11560384 ± 65%    +225.3%   37605949 ± 31%  softirqs.CPU63.NET_RX
     98687 ±  3%     +10.3%     108813 ±  3%  softirqs.CPU63.TIMER
  11794318 ± 52%    +214.6%   37100264 ± 30%  softirqs.CPU66.NET_RX
  14877710 ± 72%    +151.5%   37417593 ± 22%  softirqs.CPU67.NET_RX
  14150863 ± 33%    +162.9%   37202456 ± 21%  softirqs.CPU69.NET_RX
  14321644 ± 57%    +108.3%   29828349 ± 52%  softirqs.CPU7.NET_RX
  11452178 ± 68%    +202.9%   34687130 ± 32%  softirqs.CPU70.NET_RX
  12029261 ± 30%    +215.5%   37954566 ± 33%  softirqs.CPU72.NET_RX
  11239817 ± 48%    +264.1%   40920975 ± 27%  softirqs.CPU73.NET_RX
  13666767 ± 29%    +191.9%   39890837 ± 28%  softirqs.CPU74.NET_RX
   9796799 ± 40%    +310.8%   40242249 ± 34%  softirqs.CPU76.NET_RX
  11740789 ± 27%    +230.9%   38845528 ± 30%  softirqs.CPU77.NET_RX
  13118354 ± 32%    +214.7%   41279654 ± 29%  softirqs.CPU78.NET_RX
  11061289 ± 50%    +266.3%   40516111 ± 34%  softirqs.CPU79.NET_RX
  11877887 ± 62%    +235.4%   39837159 ± 32%  softirqs.CPU80.NET_RX
  13440016 ± 28%    +188.1%   38719673 ± 32%  softirqs.CPU81.NET_RX
  12345155 ± 44%    +235.2%   41385385 ± 27%  softirqs.CPU82.NET_RX
  14200361 ± 41%    +203.4%   43084415 ± 23%  softirqs.CPU83.NET_RX
  12686489 ± 41%    +209.5%   39268561 ± 38%  softirqs.CPU84.NET_RX
  14108969 ± 55%    +165.0%   37383069 ± 37%  softirqs.CPU85.NET_RX
  13552239 ± 30%    +191.6%   39524993 ± 32%  softirqs.CPU86.NET_RX
  12962401 ± 46%    +212.1%   40451805 ± 31%  softirqs.CPU87.NET_RX
  10270197 ± 32%    +285.9%   39632034 ± 29%  softirqs.CPU88.NET_RX
  11593540 ± 45%    +243.0%   39768872 ± 29%  softirqs.CPU89.NET_RX
  11140063 ± 41%    +262.2%   40348290 ± 25%  softirqs.CPU90.NET_RX
  14856740 ± 17%    +167.4%   39730583 ± 27%  softirqs.CPU91.NET_RX
  10432532 ± 43%    +291.3%   40817874 ± 33%  softirqs.CPU92.NET_RX
  14312525 ± 31%    +194.3%   42124840 ± 33%  softirqs.CPU93.NET_RX
  13930045 ± 43%    +186.5%   39904212 ± 30%  softirqs.CPU94.NET_RX
  14797777 ± 34%    +174.9%   40679378 ± 27%  softirqs.CPU95.NET_RX
  15780036 ± 49%    +104.6%   32282485 ± 45%  softirqs.CPU97.NET_RX
  11545653 ± 56%    +177.9%   32085242 ± 43%  softirqs.CPU98.NET_RX
 2.643e+09 ± 41%    +152.1%  6.661e+09 ± 16%  softirqs.NET_RX





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


---
0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation

Thanks,
Oliver Sang


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.14.0-00097-g45208c9105bd"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.14.0 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-22) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23502
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23502
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_TIME_KUNIT_TEST=m

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
# CONFIG_X86_CPU_RESCTRL is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
# CONFIG_X86_SGX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_PRMT=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_KVM_MMU_AUDIT=y
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_FC_APPID is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=19
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_SECRETMEM=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_MPTCP_KUNIT_TEST=m
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
# CONFIG_TIPC_MEDIA_IB is not set
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_GATE is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_PM_QOS_KUNIT_TEST=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_DRIVER_PE_KUNIT_TEST=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_NET_VRF is not set
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_MICROSOFT_MANA is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
# CONFIG_MT7921E is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_BCM63XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_MOCKUP is not set
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_SHARP_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX208 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_MXL692=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
CONFIG_DVB_MN88443X=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
CONFIG_DVB_HELENE=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN_FRONTEND is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_HYPERV is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_PLAYSTATION is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_STUSB160X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
CONFIG_X86_PLATFORM_DRIVERS_INTEL=y
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_HID_EVENT=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_VBTN=m
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_INTEL_PMC_CORE=m
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Clock driver for ARM Reference designs
#
# CONFIG_ICST is not set
# CONFIG_CLK_SP810 is not set
# end of Clock driver for ARM Reference designs

# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_DTPM is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_EXT4_KUNIT_TESTS=m
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=m
# CONFIG_NETFS_STATS is not set
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_FREE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
CONFIG_SECURITY_APPARMOR_KUNIT_TEST=y
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
# CONFIG_IMA_DISABLE_HTABLE is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
CONFIG_LINEAR_RANGES=m
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_PERNUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
CONFIG_KUNIT=y
CONFIG_KUNIT_DEBUGFS=y
# CONFIG_KUNIT_TEST is not set
# CONFIG_KUNIT_EXAMPLE_TEST is not set
CONFIG_KUNIT_ALL_TESTS=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAULT_INJECTION_USERCOPY is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
CONFIG_TEST_BPF=m
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
CONFIG_BITFIELD_KUNIT=m
CONFIG_RESOURCE_KUNIT_TEST=m
CONFIG_SYSCTL_KUNIT_TEST=m
CONFIG_LIST_KUNIT_TEST=m
CONFIG_LINEAR_RANGES_TEST=m
CONFIG_CMDLINE_KUNIT_TEST=m
CONFIG_BITS_TEST=m
CONFIG_SLUB_KUNIT_TEST=m
CONFIG_RATIONAL_KUNIT_TEST=m
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_LIVEPATCH is not set
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_HMM is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='aim7'
	export testcase='aim7'
	export category='benchmark'
	export job_origin='aim7-fs-1brd.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-icl-2sp2'
	export tbox_group='lkp-icl-2sp2'
	export kconfig='x86_64-rhel-8.3'
	export submit_id='6132ef85c929c9d8821180b8'
	export job_file='/lkp/jobs/scheduled/lkp-icl-2sp2/aim7-performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280-debian-10.4-x86_64-20200603.cgz-45208c9105bd96015b98cdf31fbd6a3bcff23-20210904-55426-3wbb66-3.yaml'
	export id='a93d2a05ecd3cf93be448efecda27d9b2cc40aa2'
	export queuer_version='/lkp-src'
	export model='Ice Lake'
	export nr_node=2
	export nr_cpu=128
	export memory='256G'
	export nr_ssd_partitions=2
	export ssd_partitions='/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF7414019F4P0IGN-part2
/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF7414019F4P0IGN-part3'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF7414019F4P0IGN-part1'
	export brand='Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz'
	export commit='45208c9105bd96015b98cdf31fbd6a3bcff234b6'
	export netconsole_port=6680
	export ucode='0xd000280'
	export bisect_dmesg=true
	export need_kconfig='{"BLK_DEV_RAM"=>"m"}
{"BLK_DEV"=>"y"}
{"BLOCK"=>"y"}
XFS_FS'
	export enqueue_time='2021-09-04 12:01:10 +0800'
	export _id='6132ef85c929c9d8821180b8'
	export _rt='/result/aim7/performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280/lkp-icl-2sp2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6'
	export user='lkp'
	export compiler='gcc-9'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='c692932a82cebc6d4e5192c4d51fdca49db6d037'
	export base_commit='7d2a07b769330c34b4deabeed939325c77a7ec2f'
	export branch='linux-review/Andrew-Morton/ia64-fix-typo-in-a-comment/20210903-065028'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/aim7/performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280/lkp-icl-2sp2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/3'
	export scheduler_version='/lkp/lkp/.src-20210903-234613'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-icl-2sp2/aim7-performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280-debian-10.4-x86_64-20200603.cgz-45208c9105bd96015b98cdf31fbd6a3bcff23-20210904-55426-3wbb66-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3
branch=linux-review/Andrew-Morton/ia64-fix-typo-in-a-comment/20210903-065028
commit=45208c9105bd96015b98cdf31fbd6a3bcff234b6
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/vmlinuz-5.14.0-00097-g45208c9105bd
max_uptime=2100
RESULT_ROOT=/result/aim7/performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280/lkp-icl-2sp2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/3
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/modules.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20210707.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20210621.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-3f5ad13cb012-1_20210828.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/fs_20200714.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/aim7-x86_64-1-1_20210903.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/turbostat_20200721.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/turbostat-x86_64-3.7-4_20200721.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.14.0-00519-g230bda0873a6'
	export repeat_to=6
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/vmlinuz-5.14.0-00097-g45208c9105bd'
	export dequeue_time='2021-09-04 12:02:57 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-icl-2sp2/aim7-performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280-debian-10.4-x86_64-20200603.cgz-45208c9105bd96015b98cdf31fbd6a3bcff23-20210904-55426-3wbb66-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_setup nr_brd=1 ramdisk_size=51539607552 $LKP_SRC/setup/disk

	run_setup fs='xfs' $LKP_SRC/setup/fs

	run_setup $LKP_SRC/setup/cpufreq_governor 'performance'

	run_monitor delay=15 $LKP_SRC/monitors/no-stdout/wrapper perf-profile
	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper uptime
	run_monitor $LKP_SRC/monitors/wrapper iostat
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-numastat
	run_monitor $LKP_SRC/monitors/wrapper numa-vmstat
	run_monitor $LKP_SRC/monitors/wrapper numa-meminfo
	run_monitor $LKP_SRC/monitors/wrapper proc-vmstat
	run_monitor $LKP_SRC/monitors/wrapper proc-stat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper slabinfo
	run_monitor $LKP_SRC/monitors/wrapper interrupts
	run_monitor $LKP_SRC/monitors/wrapper lock_stat
	run_monitor lite_mode=1 $LKP_SRC/monitors/wrapper perf-sched
	run_monitor $LKP_SRC/monitors/wrapper softirqs
	run_monitor $LKP_SRC/monitors/one-shot/wrapper bdi_dev_mapping
	run_monitor $LKP_SRC/monitors/wrapper diskstats
	run_monitor $LKP_SRC/monitors/wrapper nfsstat
	run_monitor $LKP_SRC/monitors/wrapper cpuidle
	run_monitor $LKP_SRC/monitors/wrapper cpufreq-stats
	run_monitor $LKP_SRC/monitors/wrapper turbostat
	run_monitor $LKP_SRC/monitors/wrapper sched_debug
	run_monitor $LKP_SRC/monitors/wrapper perf-stat
	run_monitor $LKP_SRC/monitors/wrapper mpstat
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test test='disk_rr' load=3000 $LKP_SRC/tests/wrapper aim7
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env delay=15 $LKP_SRC/stats/wrapper perf-profile
	env test='disk_rr' load=3000 $LKP_SRC/stats/wrapper aim7
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper uptime
	$LKP_SRC/stats/wrapper iostat
	$LKP_SRC/stats/wrapper vmstat
	$LKP_SRC/stats/wrapper numa-numastat
	$LKP_SRC/stats/wrapper numa-vmstat
	$LKP_SRC/stats/wrapper numa-meminfo
	$LKP_SRC/stats/wrapper proc-vmstat
	$LKP_SRC/stats/wrapper meminfo
	$LKP_SRC/stats/wrapper slabinfo
	$LKP_SRC/stats/wrapper interrupts
	$LKP_SRC/stats/wrapper lock_stat
	env lite_mode=1 $LKP_SRC/stats/wrapper perf-sched
	$LKP_SRC/stats/wrapper softirqs
	$LKP_SRC/stats/wrapper diskstats
	$LKP_SRC/stats/wrapper nfsstat
	$LKP_SRC/stats/wrapper cpuidle
	$LKP_SRC/stats/wrapper turbostat
	$LKP_SRC/stats/wrapper sched_debug
	$LKP_SRC/stats/wrapper perf-stat
	$LKP_SRC/stats/wrapper mpstat

	$LKP_SRC/stats/wrapper time aim7.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
:#! jobs/aim7-fs-1brd.yaml:
suite: aim7
testcase: aim7
category: benchmark
perf-profile:
  delay: 15
disk: 1BRD_48G
fs: xfs
aim7:
  test: disk_rr
  load: 3000
job_origin: aim7-fs-1brd.yaml
:#! queue options:
queue_cmdline_keys:
- branch
- commit
- queue_at_least_once
queue: bisect
testbox: lkp-icl-2sp2
tbox_group: lkp-icl-2sp2
kconfig: x86_64-rhel-8.3
submit_id: 6132d256c929c9cdf7ac4025
job_file: "/lkp/jobs/scheduled/lkp-icl-2sp2/aim7-performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280-debian-10.4-x86_64-20200603.cgz-45208c9105bd96015b98cdf31fbd6a3bcff23-20210904-52727-1d6mbxl-0.yaml"
id: 61aa5066decfea0e1d878ae7121cfe0a08babe0e
queuer_version: "/lkp-src"
:#! hosts/lkp-icl-2sp2:
model: Ice Lake
nr_node: 2
nr_cpu: 128
memory: 256G
nr_ssd_partitions: 2
ssd_partitions:
- "/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF7414019F4P0IGN-part2"
- "/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF7414019F4P0IGN-part3"
swap_partitions:
rootfs_partition: "/dev/disk/by-id/nvme-INTEL_SSDPE2KX040T7_PHLF7414019F4P0IGN-part1"
brand: Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
:#! include/category/benchmark:
kmsg:
boot-time:
uptime:
iostat:
heartbeat:
vmstat:
numa-numastat:
numa-vmstat:
numa-meminfo:
proc-vmstat:
proc-stat:
meminfo:
slabinfo:
interrupts:
lock_stat:
perf-sched:
  lite_mode: 1
softirqs:
bdi_dev_mapping:
diskstats:
nfsstat:
cpuidle:
cpufreq-stats:
turbostat:
sched_debug:
perf-stat:
mpstat:
:#! include/category/ALL:
cpufreq_governor: performance
:#! include/queue/cyclic:
commit: 45208c9105bd96015b98cdf31fbd6a3bcff234b6
:#! include/testbox/lkp-icl-2sp2:
netconsole_port: 6680
ucode: '0xd000280'
bisect_dmesg: true
:#! include/disk/nr_brd:
need_kconfig:
- BLK_DEV_RAM: m
- BLK_DEV: y
- BLOCK: y
- XFS_FS
:#! include/fs/OTHERS:
enqueue_time: 2021-09-04 09:56:38.330634184 +08:00
_id: 6132d256c929c9cdf7ac4025
_rt: "/result/aim7/performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280/lkp-icl-2sp2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6"
:#! schedule options:
user: lkp
compiler: gcc-9
LKP_SERVER: internal-lkp-server
head_commit: c692932a82cebc6d4e5192c4d51fdca49db6d037
base_commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
branch: linux-devel/devel-hourly-20210903-090430
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/aim7/performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280/lkp-icl-2sp2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/0"
scheduler_version: "/lkp/lkp/.src-20210903-234613"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-icl-2sp2/aim7-performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280-debian-10.4-x86_64-20200603.cgz-45208c9105bd96015b98cdf31fbd6a3bcff23-20210904-52727-1d6mbxl-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3
- branch=linux-devel/devel-hourly-20210903-090430
- commit=45208c9105bd96015b98cdf31fbd6a3bcff234b6
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/vmlinuz-5.14.0-00097-g45208c9105bd
- max_uptime=2100
- RESULT_ROOT=/result/aim7/performance-1BRD_48G-xfs-3000-disk_rr-ucode=0xd000280/lkp-icl-2sp2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/0
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/modules.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20210707.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/perf_20210621.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/perf-x86_64-3f5ad13cb012-1_20210828.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/fs_20200714.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/aim7-x86_64-1-1_20210903.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/mpstat_20200714.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/turbostat_20200721.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/turbostat-x86_64-3.7-4_20200721.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/sar-x86_64-34c92ae-1_20200702.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn
:#! /lkp/lkp/.src-20210902-191959/include/site/inn:
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
:#! runtime status:
last_kernel: 5.14.0-rc4
repeat_to: 3
:#! user overrides:
queue_at_least_once: 0
kernel: "/pkg/linux/x86_64-rhel-8.3/gcc-9/45208c9105bd96015b98cdf31fbd6a3bcff234b6/vmlinuz-5.14.0-00097-g45208c9105bd"
dequeue_time: 2021-09-04 10:38:29.024455360 +08:00
:#! /lkp/lkp/.src-20210903-234613/include/site/inn:
job_state: finished
loadavg: 620.10 194.92 67.74 1/1117 10283
start_time: '1630723219'
end_time: '1630723255'
version: "/lkp/lkp/.src-20210903-234710:9cfae862:2d6eafa30"

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

 "modprobe" "-r" "brd"
 "modprobe" "brd" "rd_nr=1" "rd_size=50331648"
dmsetup remove_all
wipefs -a --force /dev/ram0
mkfs -t xfs -f /dev/ram0
mkdir -p /fs/ram0
mount -t xfs -o inode64 /dev/ram0 /fs/ram0

for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*
do
	online_file="$cpu_dir"/online
	[ -f "$online_file" ] && [ "$(cat "$online_file")" -eq 0 ] && continue

	file="$cpu_dir"/cpufreq/scaling_governor
	[ -f "$file" ] && echo "performance" > "$file"
done

echo "500 32000 128 512" > /proc/sys/kernel/sem
cat > workfile <<EOF
FILESIZE: 1M
POOLSIZE: 10M
10 disk_rr
EOF
echo "/fs/ram0" > config

	(
		echo lkp-icl-2sp2
		echo disk_rr

		echo 1
		echo 3000
		echo 2
		echo 3000
		echo 1
	) | ./multitask -t &

--gKMricLos+KVdGMg--
