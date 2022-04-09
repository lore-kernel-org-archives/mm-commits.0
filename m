Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA612C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  9 Apr 2022 03:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiDIDPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 23:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238391AbiDIDPV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 23:15:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E266639836
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 20:13:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E62BB82DFF
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 03:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583D3C385A4;
        Sat,  9 Apr 2022 03:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649473992;
        bh=M4m/D9JVGsjU2ss/gUY7VGHtm2ijyTf3er01k96ODpY=;
        h=Date:To:From:Subject:From;
        b=TsvghrBb4uMhh9s/2IyIsXCX+xvGmbO8JEFgpFR3mlOARcCrvVPCsOBqAo3WfEv21
         yJTAAEVXCOE96YuDJRSg7ahrgO0JtvooW4mT402jOaSsIWfuo65du0Bcx/Gku4dyOQ
         nII97KcimgoXtjEndfWkCBpBW4xNc/Y/c9gjLolM=
Date:   Fri, 08 Apr 2022 20:13:11 -0700
To:     mm-commits@vger.kernel.org, wang.yong12@zte.com.cn,
        sfr@canb.auug.org.au, ran.xiaokai@zte.com.cn,
        mike.kravetz@oracle.com, jiang.xuexin@zte.com.cn, david@redhat.com,
        corbet@lwn.net, bsingharora@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-track-delays-from-write-protect-copy.patch added to -mm tree
Message-Id: <20220409031312.583D3C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: track delays from write-protect copy
has been added to the -mm tree.  Its filename is
     delayacct-track-delays-from-write-protect-copy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/delayacct-track-delays-from-write-protect-copy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/delayacct-track-delays-from-write-protect-copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: delayacct: track delays from write-protect copy

Delay accounting does not track the delay of write-protect copy.  When
tasks trigger many write-protect copys(include COW and unsharing of
anonymous pages[1]), it may spend a amount of time waiting for them.  To
get the delay of tasks in write-protect copy, could help users to evaluate
the impact of using KSM or fork() or GUP.

Also update tools/accounting/getdelays.c:

    / # ./getdelays -dl -p 231
    print delayacct stats ON
    listen forever
    PID     231

    CPU             count     real total  virtual total    delay total  delay average
                     6247     1859000000     2154070021     1674255063          0.268ms
    IO              count    delay total  delay average
                        0              0              0ms
    SWAP            count    delay total  delay average
                        0              0              0ms
    RECLAIM         count    delay total  delay average
                        0              0              0ms
    THRASHING       count    delay total  delay average
                        0              0              0ms
    COMPACT         count    delay total  delay average
                        3          72758              0ms
    WPCOPY          count    delay total  delay average
                     3635      271567604              0ms

[1] commit 31cc5bc4af70("mm: support GUP-triggered unsharing of anonymous pages")

Link: https://lkml.kernel.org/r/20220409014342.2505532-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jiang Xuexin <jiang.xuexin@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: wangyong <wang.yong12@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |    5 ++
 include/linux/delayacct.h                     |   28 ++++++++++++++++
 include/uapi/linux/taskstats.h                |    6 ++-
 kernel/delayacct.c                            |   16 +++++++++
 mm/hugetlb.c                                  |    8 ++++
 mm/memory.c                                   |    8 ++++
 tools/accounting/getdelays.c                  |    8 ++++
 7 files changed, 76 insertions(+), 3 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~delayacct-track-delays-from-write-protect-copy
+++ a/Documentation/accounting/delay-accounting.rst
@@ -15,6 +15,7 @@ c) swapping in pages
 d) memory reclaim
 e) thrashing page cache
 f) direct compact
+g) write-protect copy
 
 and makes these statistics available to userspace through
 the taskstats interface.
@@ -48,7 +49,7 @@ this structure. See
 for a description of the fields pertaining to delay accounting.
 It will generally be in the form of counters returning the cumulative
 delay seen for cpu, sync block I/O, swapin, memory reclaim, thrash page
-cache, direct compact etc.
+cache, direct compact, write-protect copy etc.
 
 Taking the difference of two successive readings of a given
 counter (say cpu_delay_total) for a task will give the delay
@@ -117,6 +118,8 @@ Get sum of delays, since system boot, fo
 	                    0              0              0ms
 	COMPACT         count    delay total  delay average
 	                    0              0              0ms
+        WPCOPY          count    delay total  delay average
+                            0              0              0ms
 
 Get IO accounting for pid 1, it works only with -p::
 
--- a/include/linux/delayacct.h~delayacct-track-delays-from-write-protect-copy
+++ a/include/linux/delayacct.h
@@ -45,9 +45,13 @@ struct task_delay_info {
 	u64 compact_start;
 	u64 compact_delay;	/* wait for memory compact */
 
+	u64 wpcopy_start;
+	u64 wpcopy_delay;	/* wait for write-protect copy */
+
 	u32 freepages_count;	/* total count of memory reclaim */
 	u32 thrashing_count;	/* total count of thrash waits */
 	u32 compact_count;	/* total count of memory compact */
+	u32 wpcopy_count;	/* total count of write-protect copy */
 };
 #endif
 
@@ -78,6 +82,8 @@ extern void __delayacct_swapin_start(voi
 extern void __delayacct_swapin_end(void);
 extern void __delayacct_compact_start(void);
 extern void __delayacct_compact_end(void);
+extern void __delayacct_wpcopy_start(void);
+extern void __delayacct_wpcopy_end(void);
 
 static inline void delayacct_tsk_init(struct task_struct *tsk)
 {
@@ -194,6 +200,24 @@ static inline void delayacct_compact_end
 		__delayacct_compact_end();
 }
 
+static inline void delayacct_wpcopy_start(void)
+{
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
+	if (current->delays)
+		__delayacct_wpcopy_start();
+}
+
+static inline void delayacct_wpcopy_end(void)
+{
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
+	if (current->delays)
+		__delayacct_wpcopy_end();
+}
+
 #else
 static inline void delayacct_init(void)
 {}
@@ -228,6 +252,10 @@ static inline void delayacct_compact_sta
 {}
 static inline void delayacct_compact_end(void)
 {}
+static inline void delayacct_wpcopy_start(void)
+{}
+static inline void delayacct_wpcopy_end(void)
+{}
 
 #endif /* CONFIG_TASK_DELAY_ACCT */
 
--- a/include/uapi/linux/taskstats.h~delayacct-track-delays-from-write-protect-copy
+++ a/include/uapi/linux/taskstats.h
@@ -34,7 +34,7 @@
  */
 
 
-#define TASKSTATS_VERSION	12
+#define TASKSTATS_VERSION	13
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -194,6 +194,10 @@ struct taskstats {
 	__u64   ac_exe_dev;     /* program binary device ID */
 	__u64   ac_exe_inode;   /* program binary inode number */
 	/* v12 end */
+
+	/* v13: Delay waiting for write-protect copy */
+	__u64    wpcopy_count;
+	__u64    wpcopy_delay_total;
 };
 
 
--- a/kernel/delayacct.c~delayacct-track-delays-from-write-protect-copy
+++ a/kernel/delayacct.c
@@ -157,11 +157,14 @@ int delayacct_add_tsk(struct taskstats *
 	d->thrashing_delay_total = (tmp < d->thrashing_delay_total) ? 0 : tmp;
 	tmp = d->compact_delay_total + tsk->delays->compact_delay;
 	d->compact_delay_total = (tmp < d->compact_delay_total) ? 0 : tmp;
+	tmp = d->wpcopy_delay_total + tsk->delays->wpcopy_delay;
+	d->wpcopy_delay_total = (tmp < d->wpcopy_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
 	d->freepages_count += tsk->delays->freepages_count;
 	d->thrashing_count += tsk->delays->thrashing_count;
 	d->compact_count += tsk->delays->compact_count;
+	d->wpcopy_count += tsk->delays->wpcopy_count;
 	raw_spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 	return 0;
@@ -229,3 +232,16 @@ void __delayacct_compact_end(void)
 		      &current->delays->compact_delay,
 		      &current->delays->compact_count);
 }
+
+void __delayacct_wpcopy_start(void)
+{
+	current->delays->wpcopy_start = local_clock();
+}
+
+void __delayacct_wpcopy_end(void)
+{
+	delayacct_end(&current->delays->lock,
+		      &current->delays->wpcopy_start,
+		      &current->delays->wpcopy_delay,
+		      &current->delays->wpcopy_count);
+}
--- a/mm/hugetlb.c~delayacct-track-delays-from-write-protect-copy
+++ a/mm/hugetlb.c
@@ -32,6 +32,7 @@
 #include <linux/cma.h>
 #include <linux/migrate.h>
 #include <linux/nospec.h>
+#include <linux/delayacct.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -5204,6 +5205,8 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
+	delayacct_wpcopy_start();
+
 retry_avoidcopy:
 	/*
 	 * If no-one else is actually using this page, we're the exclusive
@@ -5214,6 +5217,8 @@ retry_avoidcopy:
 			page_move_anon_rmap(old_page, vma);
 		if (likely(!unshare))
 			set_huge_ptep_writable(vma, haddr, ptep);
+
+		delayacct_wpcopy_end();
 		return 0;
 	}
 	VM_BUG_ON_PAGE(PageAnon(old_page) && PageAnonExclusive(old_page),
@@ -5283,6 +5288,7 @@ retry_avoidcopy:
 			 * race occurs while re-acquiring page table
 			 * lock, and our job is done.
 			 */
+			delayacct_wpcopy_end();
 			return 0;
 		}
 
@@ -5341,6 +5347,8 @@ out_release_old:
 	put_page(old_page);
 
 	spin_lock(ptl); /* Caller expects lock to be held */
+
+	delayacct_wpcopy_end();
 	return ret;
 }
 
--- a/mm/memory.c~delayacct-track-delays-from-write-protect-copy
+++ a/mm/memory.c
@@ -3090,6 +3090,8 @@ static vm_fault_t wp_page_copy(struct vm
 	int page_copied = 0;
 	struct mmu_notifier_range range;
 
+	delayacct_wpcopy_start();
+
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
 
@@ -3114,6 +3116,8 @@ static vm_fault_t wp_page_copy(struct vm
 			put_page(new_page);
 			if (old_page)
 				put_page(old_page);
+
+			delayacct_wpcopy_end();
 			return 0;
 		}
 	}
@@ -3220,12 +3224,16 @@ static vm_fault_t wp_page_copy(struct vm
 			free_swap_cache(old_page);
 		put_page(old_page);
 	}
+
+	delayacct_wpcopy_end();
 	return page_copied && !unshare ? VM_FAULT_WRITE : 0;
 oom_free_new:
 	put_page(new_page);
 oom:
 	if (old_page)
 		put_page(old_page);
+
+	delayacct_wpcopy_end();
 	return VM_FAULT_OOM;
 }
 
--- a/tools/accounting/getdelays.c~delayacct-track-delays-from-write-protect-copy
+++ a/tools/accounting/getdelays.c
@@ -207,6 +207,8 @@ static void print_delayacct(struct tasks
 	       "THRASHING%12s%15s%15s\n"
 	       "      %15llu%15llu%15llums\n"
 	       "COMPACT  %12s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n"
+	       "WPCOPY   %12s%15s%15s\n"
 	       "      %15llu%15llu%15llums\n",
 	       "count", "real total", "virtual total",
 	       "delay total", "delay average",
@@ -234,7 +236,11 @@ static void print_delayacct(struct tasks
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->compact_count,
 	       (unsigned long long)t->compact_delay_total,
-	       average_ms(t->compact_delay_total, t->compact_count));
+	       average_ms(t->compact_delay_total, t->compact_count),
+	       "count", "delay total", "delay average",
+	       (unsigned long long)t->wpcopy_count,
+	       (unsigned long long)t->wpcopy_delay_total,
+	       average_ms(t->wpcopy_delay_total, t->wpcopy_count));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-vmstat-add-events-for-ksm-cow.patch
delayacct-track-delays-from-write-protect-copy.patch

