Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D77C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiI0Ctp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiI0Cso (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B70F9A6BB
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EC06155B
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6165C433C1;
        Tue, 27 Sep 2022 02:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246890;
        bh=u8rXlJ4AEvy2byEJi3M4f64zBaNdVd4sMvnDxwqJ7Ic=;
        h=Date:To:From:Subject:From;
        b=j4GlpRZjYAd3j1ndbaRHHor63Y0OD/S5dnLaQjT7JpgP+t8M2MJEsJED9etgkFDvE
         1V/+mL1k99gqCyIEXFjAbNElSGBLocxQpFGfZpsWlL35loxi+wh5AkD4KT1ceBmIt+
         gpv2U3rGrFnYWbFUDf7aJBRtlPr8f+982hXs4dcM=
Date:   Mon, 26 Sep 2022 19:48:10 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        vaibhav@linux.ibm.com, torvalds@linux-foundation.org,
        tj@kernel.org, szhai2@cs.rochester.edu, suleiman@google.com,
        steven@liquorix.net, sofia.trinh@edi.works, rppt@linux.ibm.com,
        rppt@kernel.org, peterz@infradead.org, oleksandr@natalenko.name,
        Michael@MichaelLarabel.com, mhocko@kernel.org, mgorman@suse.de,
        linmiaohe@huawei.com, holger@applied-asynchrony.com,
        Hi-Angel@yandex.ru, heftig@archlinux.org, hdanton@sina.com,
        hannes@cmpxchg.org, djbyrne@mtu.edu, d@chaos-reins.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bgeffon@google.com, baohua@kernel.org,
        axboe@kernel.dk, aneesh.kumar@linux.ibm.com, ak@linux.intel.com,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-admin-guide.patch removed from -mm tree
Message-Id: <20220927024810.B6165C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: admin guide
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-admin-guide.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: admin guide
Date: Sun, 18 Sep 2022 02:00:10 -0600

Add an admin guide.

Link: https://lkml.kernel.org/r/20220918080010.2920238-14-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/index.rst        |    1 
 Documentation/admin-guide/mm/multigen_lru.rst |  162 ++++++++++++++++
 mm/Kconfig                                    |    3 
 mm/vmscan.c                                   |    4 
 4 files changed, 169 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/index.rst~mm-multi-gen-lru-admin-guide
+++ a/Documentation/admin-guide/mm/index.rst
@@ -32,6 +32,7 @@ the Linux memory management.
    idle_page_tracking
    ksm
    memory-hotplug
+   multigen_lru
    nommu-mmap
    numa_memory_policy
    numaperf
--- /dev/null
+++ a/Documentation/admin-guide/mm/multigen_lru.rst
@@ -0,0 +1,162 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+Multi-Gen LRU
+=============
+The multi-gen LRU is an alternative LRU implementation that optimizes
+page reclaim and improves performance under memory pressure. Page
+reclaim decides the kernel's caching policy and ability to overcommit
+memory. It directly impacts the kswapd CPU usage and RAM efficiency.
+
+Quick start
+===========
+Build the kernel with the following configurations.
+
+* ``CONFIG_LRU_GEN=y``
+* ``CONFIG_LRU_GEN_ENABLED=y``
+
+All set!
+
+Runtime options
+===============
+``/sys/kernel/mm/lru_gen/`` contains stable ABIs described in the
+following subsections.
+
+Kill switch
+-----------
+``enabled`` accepts different values to enable or disable the
+following components. Its default value depends on
+``CONFIG_LRU_GEN_ENABLED``. All the components should be enabled
+unless some of them have unforeseen side effects. Writing to
+``enabled`` has no effect when a component is not supported by the
+hardware, and valid values will be accepted even when the main switch
+is off.
+
+====== ===============================================================
+Values Components
+====== ===============================================================
+0x0001 The main switch for the multi-gen LRU.
+0x0002 Clearing the accessed bit in leaf page table entries in large
+       batches, when MMU sets it (e.g., on x86). This behavior can
+       theoretically worsen lock contention (mmap_lock). If it is
+       disabled, the multi-gen LRU will suffer a minor performance
+       degradation for workloads that contiguously map hot pages,
+       whose accessed bits can be otherwise cleared by fewer larger
+       batches.
+0x0004 Clearing the accessed bit in non-leaf page table entries as
+       well, when MMU sets it (e.g., on x86). This behavior was not
+       verified on x86 varieties other than Intel and AMD. If it is
+       disabled, the multi-gen LRU will suffer a negligible
+       performance degradation.
+[yYnN] Apply to all the components above.
+====== ===============================================================
+
+E.g.,
+::
+
+    echo y >/sys/kernel/mm/lru_gen/enabled
+    cat /sys/kernel/mm/lru_gen/enabled
+    0x0007
+    echo 5 >/sys/kernel/mm/lru_gen/enabled
+    cat /sys/kernel/mm/lru_gen/enabled
+    0x0005
+
+Thrashing prevention
+--------------------
+Personal computers are more sensitive to thrashing because it can
+cause janks (lags when rendering UI) and negatively impact user
+experience. The multi-gen LRU offers thrashing prevention to the
+majority of laptop and desktop users who do not have ``oomd``.
+
+Users can write ``N`` to ``min_ttl_ms`` to prevent the working set of
+``N`` milliseconds from getting evicted. The OOM killer is triggered
+if this working set cannot be kept in memory. In other words, this
+option works as an adjustable pressure relief valve, and when open, it
+terminates applications that are hopefully not being used.
+
+Based on the average human detectable lag (~100ms), ``N=1000`` usually
+eliminates intolerable janks due to thrashing. Larger values like
+``N=3000`` make janks less noticeable at the risk of premature OOM
+kills.
+
+The default value ``0`` means disabled.
+
+Experimental features
+=====================
+``/sys/kernel/debug/lru_gen`` accepts commands described in the
+following subsections. Multiple command lines are supported, so does
+concatenation with delimiters ``,`` and ``;``.
+
+``/sys/kernel/debug/lru_gen_full`` provides additional stats for
+debugging. ``CONFIG_LRU_GEN_STATS=y`` keeps historical stats from
+evicted generations in this file.
+
+Working set estimation
+----------------------
+Working set estimation measures how much memory an application needs
+in a given time interval, and it is usually done with little impact on
+the performance of the application. E.g., data centers want to
+optimize job scheduling (bin packing) to improve memory utilizations.
+When a new job comes in, the job scheduler needs to find out whether
+each server it manages can allocate a certain amount of memory for
+this new job before it can pick a candidate. To do so, the job
+scheduler needs to estimate the working sets of the existing jobs.
+
+When it is read, ``lru_gen`` returns a histogram of numbers of pages
+accessed over different time intervals for each memcg and node.
+``MAX_NR_GENS`` decides the number of bins for each histogram. The
+histograms are noncumulative.
+::
+
+    memcg  memcg_id  memcg_path
+       node  node_id
+           min_gen_nr  age_in_ms  nr_anon_pages  nr_file_pages
+           ...
+           max_gen_nr  age_in_ms  nr_anon_pages  nr_file_pages
+
+Each bin contains an estimated number of pages that have been accessed
+within ``age_in_ms``. E.g., ``min_gen_nr`` contains the coldest pages
+and ``max_gen_nr`` contains the hottest pages, since ``age_in_ms`` of
+the former is the largest and that of the latter is the smallest.
+
+Users can write the following command to ``lru_gen`` to create a new
+generation ``max_gen_nr+1``:
+
+    ``+ memcg_id node_id max_gen_nr [can_swap [force_scan]]``
+
+``can_swap`` defaults to the swap setting and, if it is set to ``1``,
+it forces the scan of anon pages when swap is off, and vice versa.
+``force_scan`` defaults to ``1`` and, if it is set to ``0``, it
+employs heuristics to reduce the overhead, which is likely to reduce
+the coverage as well.
+
+A typical use case is that a job scheduler runs this command at a
+certain time interval to create new generations, and it ranks the
+servers it manages based on the sizes of their cold pages defined by
+this time interval.
+
+Proactive reclaim
+-----------------
+Proactive reclaim induces page reclaim when there is no memory
+pressure. It usually targets cold pages only. E.g., when a new job
+comes in, the job scheduler wants to proactively reclaim cold pages on
+the server it selected, to improve the chance of successfully landing
+this new job.
+
+Users can write the following command to ``lru_gen`` to evict
+generations less than or equal to ``min_gen_nr``.
+
+    ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]``
+
+``min_gen_nr`` should be less than ``max_gen_nr-1``, since
+``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivalent to
+the active list) and therefore cannot be evicted. ``swappiness``
+overrides the default value in ``/proc/sys/vm/swappiness``.
+``nr_to_reclaim`` limits the number of pages to evict.
+
+A typical use case is that a job scheduler runs this command before it
+tries to land a new job on a server. If it fails to materialize enough
+cold pages because of the overestimation, it retries on the next
+server according to the ranking result obtained from the working set
+estimation step. This less forceful approach limits the impacts on the
+existing jobs.
--- a/mm/Kconfig~mm-multi-gen-lru-admin-guide
+++ a/mm/Kconfig
@@ -1125,7 +1125,8 @@ config LRU_GEN
 	# make sure folio->flags has enough spare bits
 	depends on 64BIT || !SPARSEMEM || SPARSEMEM_VMEMMAP
 	help
-	  A high performance LRU implementation to overcommit memory.
+	  A high performance LRU implementation to overcommit memory. See
+	  Documentation/admin-guide/mm/multigen_lru.rst for details.
 
 config LRU_GEN_ENABLED
 	bool "Enable by default"
--- a/mm/vmscan.c~mm-multi-gen-lru-admin-guide
+++ a/mm/vmscan.c
@@ -5310,6 +5310,7 @@ static ssize_t show_min_ttl(struct kobje
 	return sprintf(buf, "%u\n", jiffies_to_msecs(READ_ONCE(lru_gen_min_ttl)));
 }
 
+/* see Documentation/admin-guide/mm/multigen_lru.rst for details */
 static ssize_t store_min_ttl(struct kobject *kobj, struct kobj_attribute *attr,
 			     const char *buf, size_t len)
 {
@@ -5343,6 +5344,7 @@ static ssize_t show_enabled(struct kobje
 	return snprintf(buf, PAGE_SIZE, "0x%04x\n", caps);
 }
 
+/* see Documentation/admin-guide/mm/multigen_lru.rst for details */
 static ssize_t store_enabled(struct kobject *kobj, struct kobj_attribute *attr,
 			     const char *buf, size_t len)
 {
@@ -5490,6 +5492,7 @@ static void lru_gen_seq_show_full(struct
 	seq_putc(m, '\n');
 }
 
+/* see Documentation/admin-guide/mm/multigen_lru.rst for details */
 static int lru_gen_seq_show(struct seq_file *m, void *v)
 {
 	unsigned long seq;
@@ -5648,6 +5651,7 @@ done:
 	return err;
 }
 
+/* see Documentation/admin-guide/mm/multigen_lru.rst for details */
 static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 				 size_t len, loff_t *pos)
 {
_

Patches currently in -mm which might be from yuzhao@google.com are


