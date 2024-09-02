Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138D81D12FA;
	Mon,  2 Sep 2024 00:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238789; cv=none; b=HuLzcloblH5BF41iBF79pXrSml8XgHoUUm5E2Cf7VgekX/1dhcd9vLPo/P48OAeLd//maKsWWny31TIOHhTZ5kS6vteCirGqaxoslbdpwIiq6LBsYF4841m+BU+m4W8Yv4ilkRTiE4WS0gCgkPM7PMTTaLM7W0fJkn/io2iIOLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238789; c=relaxed/simple;
	bh=3jABO3yEBMI4VoDb7kP9xeAVVAJGkkNCtZATznIZIj8=;
	h=Date:To:From:Subject:Message-Id; b=kbCuOEQXBgd/Ti7A2BylIXswfp/5eCGdTg3jXAYetVJVXcsDgKdXa1UssJuzf39kCtYm/ozjvq9khfvWlx+GhsjzrZ4MXhFc+b2Ze9BmV3n0xlsbNxWJ8a0ZDcGBJpFqprtGtIp0HCCpDel0UKLXw3+1ArD3fENIRk1r7tOQDkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EaGu9LFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EaGu9LFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD270C4CEC3;
	Mon,  2 Sep 2024 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238789;
	bh=3jABO3yEBMI4VoDb7kP9xeAVVAJGkkNCtZATznIZIj8=;
	h=Date:To:From:Subject:From;
	b=EaGu9LFL/+Yu1WINg16cXtD43EE1faqZFs1eXbVhNrgc2VeiL6VaEIHuDLJA8anNs
	 7w1sfoHtyfSHj8bRcKJug+5GRM1vzXcrYGF0aQ9xzgwxat4b7QFAAuFvjpJ9o92MYG
	 dkDxR1vAP/kaqAU+wcDNhTGxAsOFg3HEIZjVBbkM=
Date: Sun, 01 Sep 2024 17:59:48 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,hch@infradead.org,ahuang12@lenovo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-optimize-vmap_lazy_nr-arithmetic-when-purging-each-vmap_area.patch removed from -mm tree
Message-Id: <20240902005948.DD270C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: optimize vmap_lazy_nr arithmetic when purging each vmap_area
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-optimize-vmap_lazy_nr-arithmetic-when-purging-each-vmap_area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Adrian Huang <ahuang12@lenovo.com>
Subject: mm: vmalloc: optimize vmap_lazy_nr arithmetic when purging each vmap_area
Date: Thu, 29 Aug 2024 21:06:33 +0800

When running the vmalloc stress on a 448-core system, observe the average
latency of purge_vmap_node() is about 2 seconds by using the eBPF/bcc
'funclatency.py' tool [1].

  # /your-git-repo/bcc/tools/funclatency.py -u purge_vmap_node & pid1=$! && sleep 8 && modprobe test_vmalloc nr_threads=$(nproc) run_test_mask=0x7; kill -SIGINT $pid1

     usecs             : count    distribution
        0 -> 1         : 0       |                                        |
        2 -> 3         : 29      |                                        |
        4 -> 7         : 19      |                                        |
        8 -> 15        : 56      |                                        |
       16 -> 31        : 483     |****                                    |
       32 -> 63        : 1548    |************                            |
       64 -> 127       : 2634    |*********************                   |
      128 -> 255       : 2535    |*********************                   |
      256 -> 511       : 1776    |**************                          |
      512 -> 1023      : 1015    |********                                |
     1024 -> 2047      : 573     |****                                    |
     2048 -> 4095      : 488     |****                                    |
     4096 -> 8191      : 1091    |*********                               |
     8192 -> 16383     : 3078    |*************************               |
    16384 -> 32767     : 4821    |****************************************|
    32768 -> 65535     : 3318    |***************************             |
    65536 -> 131071    : 1718    |**************                          |
   131072 -> 262143    : 2220    |******************                      |
   262144 -> 524287    : 1147    |*********                               |
   524288 -> 1048575   : 1179    |*********                               |
  1048576 -> 2097151   : 822     |******                                  |
  2097152 -> 4194303   : 906     |*******                                 |
  4194304 -> 8388607   : 2148    |*****************                       |
  8388608 -> 16777215  : 4497    |*************************************   |
 16777216 -> 33554431  : 289     |**                                      |

  avg = 2041714 usecs, total: 78381401772 usecs, count: 38390

  The worst case is over 16-33 seconds, so soft lockup is triggered [2].

[Root Cause]
1) Each purge_list has the long list. The following shows the number of
   vmap_area is purged.

   crash> p vmap_nodes
   vmap_nodes = $27 = (struct vmap_node *) 0xff2de5a900100000
   crash> vmap_node 0xff2de5a900100000 128 | grep nr_purged
     nr_purged = 663070
     ...
     nr_purged = 821670
     nr_purged = 692214
     nr_purged = 726808
     ...

2) atomic_long_sub() employs the 'lock' prefix to ensure the atomic
   operation when purging each vmap_area. However, the iteration is over
   600000 vmap_area (See 'nr_purged' above).

   Here is objdump output:

     $ objdump -D vmlinux
     ffffffff813e8c80 <purge_vmap_node>:
     ...
     ffffffff813e8d70:  f0 48 29 2d 68 0c bb  lock sub %rbp,0x2bb0c68(%rip)
     ...

   Quote from "Instruction tables" pdf file [3]:
     Instructions with a LOCK prefix have a long latency that depends on
     cache organization and possibly RAM speed. If there are multiple
     processors or cores or direct memory access (DMA) devices, then all
     locked instructions will lock a cache line for exclusive access,
     which may involve RAM access. A LOCK prefix typically costs more
     than a hundred clock cycles, even on single-processor systems.

   That's why the latency of purge_vmap_node() dramatically increases
   on a many-core system: One core is busy on purging each vmap_area of
   the *long* purge_list and executing atomic_long_sub() for each
   vmap_area, while other cores free vmalloc allocations and execute
   atomic_long_add_return() in free_vmap_area_noflush().

[Solution]
Employ a local variable to record the total purged pages, and execute
atomic_long_sub() after the traversal of the purge_list is done. The
experiment result shows the latency improvement is 99%.

[Experiment Result]
1) System Configuration: Three servers (with HT-enabled) are tested.
     * 72-core server: 3rd Gen Intel Xeon Scalable Processor*1
     * 192-core server: 5th Gen Intel Xeon Scalable Processor*2
     * 448-core server: AMD Zen 4 Processor*2

2) Kernel Config
     * CONFIG_KASAN is disabled

3) The data in column "w/o patch" and "w/ patch"
     * Unit: micro seconds (us)
     * Each data is the average of 3-time measurements

         System        w/o patch (us)   w/ patch (us)    Improvement (%)
     ---------------   --------------   -------------    -------------
     72-core server          2194              14            99.36%
     192-core server       143799            1139            99.21%
     448-core server      1992122            6883            99.65%

[1] https://github.com/iovisor/bcc/blob/master/tools/funclatency.py
[2] https://gist.github.com/AdrianHuang/37c15f67b45407b83c2d32f918656c12
[3] https://www.agner.org/optimize/instruction_tables.pdf

Link: https://lkml.kernel.org/r/20240829130633.2184-1-ahuang12@lenovo.com
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-optimize-vmap_lazy_nr-arithmetic-when-purging-each-vmap_area
+++ a/mm/vmalloc.c
@@ -2191,6 +2191,7 @@ static void purge_vmap_node(struct work_
 {
 	struct vmap_node *vn = container_of(work,
 		struct vmap_node, purge_work);
+	unsigned long nr_purged_pages = 0;
 	struct vmap_area *va, *n_va;
 	LIST_HEAD(local_list);
 
@@ -2208,7 +2209,7 @@ static void purge_vmap_node(struct work_
 			kasan_release_vmalloc(orig_start, orig_end,
 					      va->va_start, va->va_end);
 
-		atomic_long_sub(nr, &vmap_lazy_nr);
+		nr_purged_pages += nr;
 		vn->nr_purged++;
 
 		if (is_vn_id_valid(vn_id) && !vn->skip_populate)
@@ -2219,6 +2220,8 @@ static void purge_vmap_node(struct work_
 		list_add(&va->list, &local_list);
 	}
 
+	atomic_long_sub(nr_purged_pages, &vmap_lazy_nr);
+
 	reclaim_list_global(&local_list);
 }
 
_

Patches currently in -mm which might be from ahuang12@lenovo.com are

mm-vmalloc-combine-all-tlb-flush-operations-of-kasan-shadow-virtual-address-into-one-operation.patch

