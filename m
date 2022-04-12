Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF14C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiDLEWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiDLEWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34CE25599
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52CB36177C
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5B4C385A6;
        Tue, 12 Apr 2022 04:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737184;
        bh=grqtRvMdfwNCFa0ocEpQKgByAZC9MCWfRD1zJu+tn9I=;
        h=Date:To:From:Subject:From;
        b=U6o1ae1yUnOHgOiwIWe7/oTCLJKIGBmq0DZXLcclBny6iAkfsbeEork885U0nrn0P
         9+hoUoSgFe07kJBL8PbTJ4ajvg6dVGRJUsXrFevqvF0WbXA+QBog36uP6u0qWOgbXe
         LCCV1mmkkTpriqg3N1oD4Af7ZLJALv1UqstjFshA=
Date:   Mon, 11 Apr 2022 21:19:43 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-arm64-add-arch_has_hw_pte_young.patch added to -mm tree
Message-Id: <20220412041944.9E5B4C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: x86, arm64: add arch_has_hw_pte_young()
has been added to the -mm tree.  Its filename is
     mm-x86-arm64-add-arch_has_hw_pte_young.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-x86-arm64-add-arch_has_hw_pte_young.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-arm64-add-arch_has_hw_pte_young.patch

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
Subject: mm: x86, arm64: add arch_has_hw_pte_young()

Patch series "Multi-Gen LRU Framework", v10.

TLDR
====
The current page reclaim is too expensive in terms of CPU usage and it
often makes poor choices about what to evict. This patchset offers an
alternative solution that is performant, versatile and
straightforward.

Patchset overview
=================
The design and implementation overview is in patch 14:
https://lore.kernel.org/r/20220407031525.2368067-15-yuzhao@google.com/

01. mm: x86, arm64: add arch_has_hw_pte_young()
02. mm: x86: add CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
Take advantage of hardware features when trying to clear the accessed
bit in many PTEs.

03. mm/vmscan.c: refactor shrink_node()
04. Revert "include/linux/mm_inline.h: fold __update_lru_size() into
    its sole caller"
Minor refactors to improve readability for the following patches.

05. mm: multi-gen LRU: groundwork
Adds the basic data structure and the functions that insert pages to
and remove pages from the multi-gen LRU (MGLRU) lists.

06. mm: multi-gen LRU: minimal implementation
A minimal implementation without optimizations.

07. mm: multi-gen LRU: exploit locality in rmap
Exploits spatial locality to improve efficiency when using the rmap.

08. mm: multi-gen LRU: support page table walks
Further exploits spatial locality by optionally scanning page tables.

09. mm: multi-gen LRU: optimize multiple memcgs
Optimizes the overall performance for multiple memcgs running mixed
types of workloads.

10. mm: multi-gen LRU: kill switch
Adds a kill switch to enable or disable MGLRU at runtime.

11. mm: multi-gen LRU: thrashing prevention
12. mm: multi-gen LRU: debugfs interface
Provide userspace with features like thrashing prevention, working set
estimation and proactive reclaim.

13. mm: multi-gen LRU: admin guide
14. mm: multi-gen LRU: design doc
Add an admin guide and a design doc.

Benchmark results
=================
Independent lab results
-----------------------
Based on the popularity of searches [01] and the memory usage in
Google's public cloud, the most popular open-source memory-hungry
applications, in alphabetical order, are:
      Apache Cassandra      Memcached
      Apache Hadoop         MongoDB
      Apache Spark          PostgreSQL
      MariaDB (MySQL)       Redis

An independent lab evaluated MGLRU with the most widely used benchmark
suites for the above applications. They posted 960 data points along
with kernel metrics and perf profiles collected over more than 500
hours of total benchmark time. Their final reports show that, with 95%
confidence intervals (CIs), the above applications all performed
significantly better for at least part of their benchmark matrices.

On 5.14:
1. Apache Spark [02] took 95% CIs [9.28, 11.19]% and [12.20, 14.93]%
   less wall time to sort three billion random integers, respectively,
   under the medium- and the high-concurrency conditions, when
   overcommitting memory. There were no statistically significant
   changes in wall time for the rest of the benchmark matrix.
2. MariaDB [03] achieved 95% CIs [5.24, 10.71]% and [20.22, 25.97]%
   more transactions per minute (TPM), respectively, under the medium-
   and the high-concurrency conditions, when overcommitting memory.
   There were no statistically significant changes in TPM for the rest
   of the benchmark matrix.
3. Memcached [04] achieved 95% CIs [23.54, 32.25]%, [20.76, 41.61]%
   and [21.59, 30.02]% more operations per second (OPS), respectively,
   for sequential access, random access and Gaussian (distribution)
   access, when THP=always; 95% CIs [13.85, 15.97]% and
   [23.94, 29.92]% more OPS, respectively, for random access and
   Gaussian access, when THP=never. There were no statistically
   significant changes in OPS for the rest of the benchmark matrix.
4. MongoDB [05] achieved 95% CIs [2.23, 3.44]%, [6.97, 9.73]% and
   [2.16, 3.55]% more operations per second (OPS), respectively, for
   exponential (distribution) access, random access and Zipfian
   (distribution) access, when underutilizing memory; 95% CIs
   [8.83, 10.03]%, [21.12, 23.14]% and [5.53, 6.46]% more OPS,
   respectively, for exponential access, random access and Zipfian
   access, when overcommitting memory.

On 5.15:
5. Apache Cassandra [06] achieved 95% CIs [1.06, 4.10]%, [1.94, 5.43]%
   and [4.11, 7.50]% more operations per second (OPS), respectively,
   for exponential (distribution) access, random access and Zipfian
   (distribution) access, when swap was off; 95% CIs [0.50, 2.60]%,
   [6.51, 8.77]% and [3.29, 6.75]% more OPS, respectively, for
   exponential access, random access and Zipfian access, when swap was
   on.
6. Apache Hadoop [07] took 95% CIs [5.31, 9.69]% and [2.02, 7.86]%
   less average wall time to finish twelve parallel TeraSort jobs,
   respectively, under the medium- and the high-concurrency
   conditions, when swap was on. There were no statistically
   significant changes in average wall time for the rest of the
   benchmark matrix.
7. PostgreSQL [08] achieved 95% CI [1.75, 6.42]% more transactions per
   minute (TPM) under the high-concurrency condition, when swap was
   off; 95% CIs [12.82, 18.69]% and [22.70, 46.86]% more TPM,
   respectively, under the medium- and the high-concurrency
   conditions, when swap was on. There were no statistically
   significant changes in TPM for the rest of the benchmark matrix.
8. Redis [09] achieved 95% CIs [0.58, 5.94]%, [6.55, 14.58]% and
   [11.47, 19.36]% more total operations per second (OPS),
   respectively, for sequential access, random access and Gaussian
   (distribution) access, when THP=always; 95% CIs [1.27, 3.54]%,
   [10.11, 14.81]% and [8.75, 13.64]% more total OPS, respectively,
   for sequential access, random access and Gaussian access, when
   THP=never.

Our lab results
---------------
To supplement the above results, we ran the following benchmark suites
on 5.16-rc7 and found no regressions [10]. (These synthetic benchmarks
are popular among MM developers, but we prefer large-scale A/B
experiments to validate improvements.)
      fs_fio_bench_hdd_mq      pft
      fs_lmbench               pgsql-hammerdb
      fs_parallelio            redis
      fs_postmark              stream
      hackbench                sysbenchthread
      kernbench                tpcc_spark
      memcached                unixbench
      multichase               vm-scalability
      mutilate                 will-it-scale
      nginx

[01] https://trends.google.com
[02] https://lore.kernel.org/r/20211102002002.92051-1-bot@edi.works/
[03] https://lore.kernel.org/r/20211009054315.47073-1-bot@edi.works/
[04] https://lore.kernel.org/r/20211021194103.65648-1-bot@edi.works/
[05] https://lore.kernel.org/r/20211109021346.50266-1-bot@edi.works/
[06] https://lore.kernel.org/r/20211202062806.80365-1-bot@edi.works/
[07] https://lore.kernel.org/r/20211209072416.33606-1-bot@edi.works/
[08] https://lore.kernel.org/r/20211218071041.24077-1-bot@edi.works/
[09] https://lore.kernel.org/r/20211122053248.57311-1-bot@edi.works/
[10] https://lore.kernel.org/r/20220104202247.2903702-1-yuzhao@google.com/

Read-world applications
=======================
Third-party testimonials
------------------------
Konstantin reported [11]:
   I have Archlinux with 8G RAM + zswap + swap. While developing, I
   have lots of apps opened such as multiple LSP-servers for different
   langs, chats, two browsers, etc... Usually, my system gets quickly
   to a point of SWAP-storms, where I have to kill LSP-servers,
   restart browsers to free memory, etc, otherwise the system lags
   heavily and is barely usable.
   
   1.5 day ago I migrated from 5.11.15 kernel to 5.12 + the LRU
   patchset, and I started up by opening lots of apps to create memory
   pressure, and worked for a day like this. Till now I had not a
   single SWAP-storm, and mind you I got 3.4G in SWAP. I was never
   getting to the point of 3G in SWAP before without a single
   SWAP-storm.

Vaibhav from IBM reported [12]:
   In a synthetic MongoDB Benchmark, seeing an average of ~19%
   throughput improvement on POWER10(Radix MMU + 64K Page Size) with
   MGLRU patches on top of v5.16 kernel for MongoDB + YCSB across
   three different request distributions, namely, Exponential, Uniform
   and Zipfan.

Shuang from U of Rochester reported [13]:
   With the MGLRU, fio achieved 95% CIs [38.95, 40.26]%, [4.12, 6.64]%
   and [9.26, 10.36]% higher throughput, respectively, for random
   access, Zipfian (distribution) access and Gaussian (distribution)
   access, when the average number of jobs per CPU is 1; 95% CIs
   [42.32, 49.15]%, [9.44, 9.89]% and [20.99, 22.86]% higher
   throughput, respectively, for random access, Zipfian access and
   Gaussian access, when the average number of jobs per CPU is 2.

Daniel from Michigan Tech reported [14]:
   With Memcached allocating ~100GB of byte-addressable Optante,
   performance improvement in terms of throughput (measured as queries
   per second) was about 10% for a series of workloads.

Large-scale deployments
-----------------------
The downstream kernels that have been using MGLRU include:
1. Android ARCVM [15]
2. Arch Linux Zen [16]
3. Chrome OS [17]
4. Liquorix [18]
5. post-factum [19]
6. XanMod [20]

We've rolled out MGLRU to tens of millions of Chrome OS users and
about a million Android users. Google's fleetwide profiling [21] shows
an overall 40% decrease in kswapd CPU usage, in addition to
improvements in other UX metrics, e.g., an 85% decrease in the number
of low-memory kills at the 75th percentile and an 18% decrease in
app launch time at the 50th percentile.

[11] https://lore.kernel.org/r/140226722f2032c86301fbd326d91baefe3d7d23.camel@yandex.ru/
[12] https://lore.kernel.org/r/87czj3mux0.fsf@vajain21.in.ibm.com/
[13] https://lore.kernel.org/r/20220105024423.26409-1-szhai2@cs.rochester.edu/
[14] https://lore.kernel.org/r/CA+4-3vksGvKd18FgRinxhqHetBS1hQekJE2gwco8Ja-bJWKtFw@mail.gmail.com/
[15] https://chromium.googlesource.com/chromiumos/third_party/kernel/
[16] https://archlinux.org
[17] https://chromium.org
[18] https://liquorix.net
[19] https://gitlab.com/post-factum/pf-kernel/
[20] https://xanmod.org
[21] https://research.google/pubs/pub44271/

Summery
=======
The facts are:
1. The independent lab results and the real-world applications
   indicate substantial improvements; there are no known regressions.
2. Thrashing prevention, working set estimation and proactive reclaim
   work out of the box; there are no equivalent solutions.
3. There is a lot of new code; nobody has demonstrated smaller changes
   with similar effects.

Our options, accordingly, are:
1. Given the amount of evidence, the reported improvements will likely
   materialize for a wide range of workloads.
2. Gauging the interest from the past discussions [22][23][24], the
   new features will likely be put to use for both personal computers
   and data centers.
3. Based on Google's track record, the new code will likely be well
   maintained in the long term. It'd be more difficult if not
   impossible to achieve similar effects on top of the current
   active/inactive LRU.

[22] https://lore.kernel.org/r/20201005081313.732745-1-andrea.righi@canonical.com/
[23] https://lore.kernel.org/r/20210716081449.22187-1-sj38.park@gmail.com/
[24] https://lore.kernel.org/r/20211130201652.2218636d@mail.inbox.lv/


This patch (of 14):

Some architectures automatically set the accessed bit in PTEs, e.g., x86
and arm64 v8.2.  On architectures that do not have this capability,
clearing the accessed bit in a PTE usually triggers a page fault following
the TLB miss of this PTE (to emulate the accessed bit).

Being aware of this capability can help make better decisions, e.g.,
whether to spread the work out over a period of time to reduce bursty page
faults when trying to clear the accessed bit in many PTEs.

Note that theoretically this capability can be unreliable, e.g.,
hotplugged CPUs might be different from builtin ones.  Therefore it should
not be used in architecture-independent code that involves correctness,
e.g., to determine whether TLB flushes are required (in combination with
the accessed bit).

Link: https://lkml.kernel.org/r/20220407031525.2368067-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20220407031525.2368067-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm64/include/asm/pgtable.h~mm-x86-arm64-add-arch_has_hw_pte_young
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1016,23 +1016,13 @@ static inline void update_mmu_cache(stru
  * page after fork() + CoW for pfn mappings. We don't always have a
  * hardware-managed access flag on arm64.
  */
-static inline bool arch_faults_on_old_pte(void)
-{
-	WARN_ON(preemptible());
-
-	return !cpu_has_hw_af();
-}
-#define arch_faults_on_old_pte		arch_faults_on_old_pte
+#define arch_has_hw_pte_young		cpu_has_hw_af
 
 /*
  * Experimentally, it's cheap to set the access flag in hardware and we
  * benefit from prefaulting mappings as 'old' to start with.
  */
-static inline bool arch_wants_old_prefaulted_pte(void)
-{
-	return !arch_faults_on_old_pte();
-}
-#define arch_wants_old_prefaulted_pte	arch_wants_old_prefaulted_pte
+#define arch_wants_old_prefaulted_pte	cpu_has_hw_af
 
 static inline bool pud_sect_supported(void)
 {
--- a/arch/x86/include/asm/pgtable.h~mm-x86-arm64-add-arch_has_hw_pte_young
+++ a/arch/x86/include/asm/pgtable.h
@@ -1440,10 +1440,10 @@ static inline bool arch_has_pfn_modify_c
 	return boot_cpu_has_bug(X86_BUG_L1TF);
 }
 
-#define arch_faults_on_old_pte arch_faults_on_old_pte
-static inline bool arch_faults_on_old_pte(void)
+#define arch_has_hw_pte_young arch_has_hw_pte_young
+static inline bool arch_has_hw_pte_young(void)
 {
-	return false;
+	return true;
 }
 
 #endif	/* __ASSEMBLY__ */
--- a/include/linux/pgtable.h~mm-x86-arm64-add-arch_has_hw_pte_young
+++ a/include/linux/pgtable.h
@@ -259,6 +259,19 @@ static inline int pmdp_clear_flush_young
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef arch_has_hw_pte_young
+/*
+ * Return whether the accessed bit is supported on the local CPU.
+ *
+ * This stub assumes accessing through an old PTE triggers a page fault.
+ * Architectures that automatically set the access bit should overwrite it.
+ */
+static inline bool arch_has_hw_pte_young(void)
+{
+	return false;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_CLEAR
 static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
--- a/mm/memory.c~mm-x86-arm64-add-arch_has_hw_pte_young
+++ a/mm/memory.c
@@ -126,18 +126,6 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
-#ifndef arch_faults_on_old_pte
-static inline bool arch_faults_on_old_pte(void)
-{
-	/*
-	 * Those arches which don't have hw access flag feature need to
-	 * implement their own helper. By default, "true" means pagefault
-	 * will be hit on old pte.
-	 */
-	return true;
-}
-#endif
-
 #ifndef arch_wants_old_prefaulted_pte
 static inline bool arch_wants_old_prefaulted_pte(void)
 {
@@ -2862,7 +2850,7 @@ static inline bool __wp_page_copy_user(s
 	 * On architectures with software "accessed" bits, we would
 	 * take a double page fault, so mark it accessed here.
 	 */
-	if (arch_faults_on_old_pte() && !pte_young(vmf->orig_pte)) {
+	if (!arch_has_hw_pte_young() && !pte_young(vmf->orig_pte)) {
 		pte_t entry;
 
 		vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
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

