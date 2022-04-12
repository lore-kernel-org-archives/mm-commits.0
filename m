Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DF5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345680AbiDLEXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345887AbiDLEWu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAE52A73A
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39F236177F
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F1C385A1;
        Tue, 12 Apr 2022 04:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737223;
        bh=zcZzB9ymenuuu/lESMf/JurN8FRWgJW+j6VcY19/aOw=;
        h=Date:To:From:Subject:From;
        b=eFUvskd8lQnU+z7QCW96/9KKnjt6wvqeverP1B/SmyBfn++oXvSY9YWfiHJgQDrjW
         avFlcW+VZfgrCzvRbDLoQGXxGet9d/VdAI0iZXv22lCZuzQokKU1wR9Sbbypl8gJTN
         ClcAyebWo5AJzX4+VhBkf4k/u0ysVqABMYsfDCns=
Date:   Mon, 11 Apr 2022 21:20:23 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-admin-guide.patch added to -mm tree
Message-Id: <20220412042023.8F2F1C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: admin guide
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-admin-guide.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-admin-guide.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-admin-guide.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: admin guide

Add an admin guide.

Link: https://lkml.kernel.org/r/20220407031525.2368067-14-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -0,0 +1,152 @@
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
+``enable`` accepts different values to enable or disable the following
+components. Its default value depends on ``CONFIG_LRU_GEN_ENABLED``.
+All the components should be enabled unless some of them have
+unforeseen side effects. Writing to ``enable`` has no effect when a
+component is not supported by the hardware, and valid values will be
+accepted even when the main switch is off.
+
+====== ===============================================================
+Values Components
+====== ===============================================================
+0x0001 The main switch for the multi-gen LRU.
+0x0002 Clearing the accessed bit in leaf page table entries in large
+       batches, when MMU sets it (e.g., on x86). This behavior can
+       theoretically worsen lock contention (mmap_lock). If it is
+       disabled, the multi-gen LRU will suffer a minor performance
+       degradation.
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
+Working set estimation measures how much memory an application
+requires in a given time interval, and it is usually done with little
+impact on the performance of the application. E.g., data centers want
+to optimize job scheduling (bin packing) to improve memory
+utilizations. When a new job comes in, the job scheduler needs to find
+out whether each server it manages can allocate a certain amount of
+memory for this new job before it can pick a candidate. To do so, this
+job scheduler needs to estimate the working sets of the existing jobs.
+
+When it is read, ``lru_gen`` returns a histogram of numbers of pages
+accessed over different time intervals for each memcg and node.
+``MAX_NR_GENS`` decides the number of bins for each histogram.
+::
+
+    memcg  memcg_id  memcg_path
+       node  node_id
+           min_gen_nr  age_in_ms  nr_anon_pages  nr_file_pages
+           ...
+           max_gen_nr  age_in_ms  nr_anon_pages  nr_file_pages
+
+Each generation contains an estimated number of pages that have been
+accessed within ``age_in_ms`` non-cumulatively. E.g., ``min_gen_nr``
+contains the coldest pages and ``max_gen_nr`` contains the hottest
+pages, since ``age_in_ms`` of the former is the largest and that of
+the latter is the smallest.
+
+Users can write ``+ memcg_id node_id max_gen_nr
+[can_swap[full_scan]]`` to ``lru_gen`` to create a new generation
+``max_gen_nr+1``. ``can_swap`` defaults to the swap setting and, if it
+is set to ``1``, it forces the scan of anon pages when swap is off.
+``full_scan`` defaults to ``1`` and, if it is set to ``0``, it reduces
+the overhead as well as the coverage when scanning page tables.
+
+A typical use case is that a job scheduler writes to ``lru_gen`` at a
+certain time interval to create new generations, and it ranks the
+servers it manages based on the sizes of their cold memory defined by
+this time interval.
+
+Proactive reclaim
+-----------------
+Proactive reclaim induces memory reclaim when there is no memory
+pressure and usually targets cold memory only. E.g., when a new job
+comes in, the job scheduler wants to proactively reclaim memory on the
+server it has selected to improve the chance of successfully landing
+this new job.
+
+Users can write ``- memcg_id node_id min_gen_nr [swappiness
+[nr_to_reclaim]]`` to ``lru_gen`` to evict generations less than or
+equal to ``min_gen_nr``. Note that ``min_gen_nr`` should be less than
+``max_gen_nr-1`` as ``max_gen_nr`` and ``max_gen_nr-1`` are not fully
+aged and therefore cannot be evicted. ``swappiness`` overrides the
+default value in ``/proc/sys/vm/swappiness``. ``nr_to_reclaim`` limits
+the number of pages to evict.
+
+A typical use case is that a job scheduler writes to ``lru_gen``
+before it tries to land a new job on a server, and if it fails to
+materialize the cold memory without impacting the existing jobs on
+this server, it retries on the next server according to the ranking
+result obtained from the working set estimation step described
+earlier.
--- a/mm/Kconfig~mm-multi-gen-lru-admin-guide
+++ a/mm/Kconfig
@@ -933,7 +933,8 @@ config LRU_GEN
 	# the following options can use up the spare bits in page flags
 	depends on !MAXSMP && (64BIT || !SPARSEMEM || SPARSEMEM_VMEMMAP)
 	help
-	  A high performance LRU implementation to overcommit memory.
+	  A high performance LRU implementation to overcommit memory. See
+	  Documentation/admin-guide/mm/multigen_lru.rst for details.
 
 config LRU_GEN_ENABLED
 	bool "Enable by default"
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

