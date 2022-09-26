Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0BF4C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 17:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiIZRDW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiIZRC7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 13:02:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD97892598
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 09:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ED4BB80B1A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 16:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF46C433C1;
        Mon, 26 Sep 2022 16:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664208286;
        bh=gxgRWmgEnZ26mfW89PxSpTo5KNU7EzTwTdmzsd90ISo=;
        h=Date:To:From:Subject:From;
        b=A+Bnip8i2bYGRjR5q8q1rTT3pPWBxEHNUXmGRhkIeOgVEhsd7XdHqMxQBzV8cx+/O
         EerDvaKKjUIV50inEzePvyMT8EYryHSnHUGrf5gPqg0f8RtjafLR5f6+ku2VxYgX/C
         U99ED+jvGueUPJeDEqTxNM5+t2Sd/kh5aJYwaoCs=
Date:   Mon, 26 Sep 2022 09:04:44 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hughd@google.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch added to mm-unstable branch
Message-Id: <20220926160446.0EF46C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop dead CONFIG_MEMCG_SWAP config symbol
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop dead CONFIG_MEMCG_SWAP config symbol
Date: Mon, 26 Sep 2022 09:57:04 -0400

Since 2d1c498072de ("mm: memcontrol: make swap tracking an integral part
of memory control"), CONFIG_MEMCG_SWAP hasn't been a user-visible config
option anymore, it just means CONFIG_MEMCG && CONFIG_SWAP.

Update the sites accordingly and drop the symbol.

[ While touching the docs, remove two references to CONFIG_MEMCG_KMEM,
  which hasn't been a user-visible symbol for over half a decade. ]

Link: https://lkml.kernel.org/r/20220926135704.400818-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/mips/configs/db1xxx_defconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/arch/mips/configs/db1xxx_defconfig
@@ -9,7 +9,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_CGROUPS=y
 CONFIG_MEMCG=y
-CONFIG_MEMCG_SWAP=y
 CONFIG_BLK_CGROUP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_CFS_BANDWIDTH=y
--- a/arch/mips/configs/generic_defconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/arch/mips/configs/generic_defconfig
@@ -3,7 +3,6 @@ CONFIG_NO_HZ_IDLE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_MEMCG=y
-CONFIG_MEMCG_SWAP=y
 CONFIG_BLK_CGROUP=y
 CONFIG_CFS_BANDWIDTH=y
 CONFIG_RT_GROUP_SCHED=y
--- a/arch/powerpc/configs/powernv_defconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/arch/powerpc/configs/powernv_defconfig
@@ -17,7 +17,6 @@ CONFIG_LOG_CPU_MAX_BUF_SHIFT=13
 CONFIG_NUMA_BALANCING=y
 CONFIG_CGROUPS=y
 CONFIG_MEMCG=y
-CONFIG_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CPUSETS=y
--- a/arch/powerpc/configs/pseries_defconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -16,7 +16,6 @@ CONFIG_LOG_CPU_MAX_BUF_SHIFT=13
 CONFIG_NUMA_BALANCING=y
 CONFIG_CGROUPS=y
 CONFIG_MEMCG=y
-CONFIG_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CPUSETS=y
--- a/arch/sh/configs/sdk7786_defconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/arch/sh/configs/sdk7786_defconfig
@@ -16,7 +16,6 @@ CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_MEMCG=y
-CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_CGROUP=y
--- a/arch/sh/configs/urquell_defconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/arch/sh/configs/urquell_defconfig
@@ -14,7 +14,6 @@ CONFIG_CPUSETS=y
 # CONFIG_PROC_PID_CPUSET is not set
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_CGROUP_MEMCG=y
-CONFIG_CGROUP_MEMCG_SWAP=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_RT_GROUP_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -299,7 +299,7 @@ Per-node-per-memcgroup LRU (cgroup's pri
 lruvec->lru_lock; PG_lru bit of page->flags is cleared before
 isolating a page from its LRU under lruvec->lru_lock.
 
-2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
+2.7 Kernel Memory Extension
 -----------------------------------------------
 
 With the Kernel memory extension, the Memory Controller is able to limit
@@ -386,8 +386,6 @@ U != 0, K >= U:
 
 a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_MEMCG
-c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
-d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
 
 3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 -------------------------------------------------------------------
--- a/include/linux/swap_cgroup.h~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/include/linux/swap_cgroup.h
@@ -4,7 +4,7 @@
 
 #include <linux/swap.h>
 
-#ifdef CONFIG_MEMCG_SWAP
+#if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 
 extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new);
@@ -40,6 +40,6 @@ static inline void swap_cgroup_swapoff(i
 	return;
 }
 
-#endif /* CONFIG_MEMCG_SWAP */
+#endif
 
 #endif /* __LINUX_SWAP_CGROUP_H */
--- a/include/linux/swap.h~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/include/linux/swap.h
@@ -666,7 +666,7 @@ static inline void folio_throttle_swapra
 	cgroup_throttle_swaprate(&folio->page, gfp);
 }
 
-#ifdef CONFIG_MEMCG_SWAP
+#if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
 int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
--- a/init/Kconfig~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/init/Kconfig
@@ -958,11 +958,6 @@ config MEMCG
 	help
 	  Provides control over the memory footprint of tasks in a cgroup.
 
-config MEMCG_SWAP
-	bool
-	depends on MEMCG && SWAP
-	default y
-
 config MEMCG_KMEM
 	bool
 	depends on MEMCG && !SLOB
--- a/mm/Makefile~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/mm/Makefile
@@ -98,7 +98,9 @@ obj-$(CONFIG_DEVICE_MIGRATION) += migrat
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
-obj-$(CONFIG_MEMCG_SWAP) += swap_cgroup.o
+ifdef CONFIG_SWAP
+obj-$(CONFIG_MEMCG) += swap_cgroup.o
+endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
--- a/mm/memcontrol.c~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/mm/memcontrol.c
@@ -3423,7 +3423,7 @@ void split_page_memcg(struct page *head,
 		css_get_many(&memcg->css, nr - 1);
 }
 
-#ifdef CONFIG_MEMCG_SWAP
+#ifdef CONFIG_SWAP
 /**
  * mem_cgroup_move_swap_account - move swap charge and swap_cgroup's record.
  * @entry: swap entry to be moved
@@ -7296,7 +7296,7 @@ static int __init mem_cgroup_init(void)
 }
 subsys_initcall(mem_cgroup_init);
 
-#ifdef CONFIG_MEMCG_SWAP
+#ifdef CONFIG_SWAP
 static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
 {
 	while (!refcount_inc_not_zero(&memcg->id.ref)) {
@@ -7788,4 +7788,4 @@ static int __init mem_cgroup_swap_init(v
 }
 subsys_initcall(mem_cgroup_swap_init);
 
-#endif /* CONFIG_MEMCG_SWAP */
+#endif /* CONFIG_SWAP */
--- a/tools/testing/selftests/cgroup/config~mm-memcontrol-drop-dead-config_memcg_swap-config-symbol
+++ a/tools/testing/selftests/cgroup/config
@@ -4,5 +4,4 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_MEMCG_KMEM=y
-CONFIG_MEMCG_SWAP=y
 CONFIG_PAGE_COUNTER=y
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch
mm-memcontrol-dont-allocate-cgroup-swap-arrays-when-memcg-is-disabled.patch
mm-memcontrol-deprecate-swapaccounting=0-mode.patch
mm-memcontrol-use-do_memsw_account-in-a-few-more-places.patch
mm-memcontrol-drop-dead-config_memcg_swap-config-symbol.patch

