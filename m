Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC5BC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 21:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiKRV2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 16:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiKRV2L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 16:28:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EA9A28AE
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 13:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34806276C
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 21:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC21C433C1;
        Fri, 18 Nov 2022 21:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668806890;
        bh=Z/llqddSrxZOFYM3pLd07S0eO9OmzpB/PggpMCMlzjY=;
        h=Date:To:From:Subject:From;
        b=XcawYzLpizoMoYbBwmCpxn1VSKq67Csm96P+JIfg/PeZ7LLs/pLnEoZhd26d0qAi+
         EEWEXsguiOGR05zOdl9dnp8C0d134VDAq3tRN+p36ms0T1u4yD49hOqQo3NnGcU+zo
         7CbFq23xMhSsqPRZOvf3PZhGC9ToS1JEZVkXqzEs=
Date:   Fri, 18 Nov 2022 13:28:09 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        xialonglong1@huawei.com, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, hugh@veritas.com, chenwandun@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swapfile-fix-soft-lockup-in-scan_swap_map_slots.patch added to mm-hotfixes-unstable branch
Message-Id: <20221118212809.EEC21C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: fix soft lockup in scan_swap_map_slots
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     swapfile-fix-soft-lockup-in-scan_swap_map_slots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swapfile-fix-soft-lockup-in-scan_swap_map_slots.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Chen Wandun <chenwandun@huawei.com>
Subject: swapfile: fix soft lockup in scan_swap_map_slots
Date: Fri, 18 Nov 2022 21:38:50 +0800

A softlockup occurs in scan free swap slot under huge memory pressure. 
The test scenario is: 64 CPU cores, 64GB memory, and 28 zram devices, the
disksize of each zram device is 50MB.

LATENCY_LIMIT is used to prevent softlockups in scan_swap_map_slots(), but
the real loop number would more than LATENCY_LIMIT because of "goto checks
and goto scan" repeatly without decreasing latency limit.

In order to fix it, decrease latency_ration in advance.

There is also a suspicious place that will cause softlockups in
get_swap_pages().  In this function, the "goto start_over" may result in
continuous scanning of the swap partition.  If there is no cond_sched in
scan_swap_map_slots(), it would cause a softlockup (I am not sure about
this).

WARN: soft lockup - CPU#11 stuck for 11s! [kswapd0:466]
CPU: 11 PID: 466 Comm: kswapd@ Kdump: loaded Tainted: G
dump backtrace+0x0/0x1le4
show stack+0x20/@x2c
dump_stack+0xd8/0x140
watchdog print_info+0x48/0x54
watchdog_process_before_softlockup+0x98/0xa0
watchdog_timer_fn+0xlac/0x2d0
hrtimer_rum_queues+0xb0/0x130
hrtimer_interrupt+0x13c/0x3c0
arch_timer_handler_virt+0x3c/0x50
handLe_percpu_devid_irq+0x90/0x1f4
handle domain irq+0x84/0x100
gic_handle_irq+0x88/0x2b0
e11 ira+0xhB/Bx140
scan_swap_map_slots+0x678/0x890
get_swap_pages+0x29c/0x440
get_swap_page+0x120/0x2e0
add_to_swap+UX2U/0XyC
shrink_page_list+0x5d0/0x152c
shrink_inactive_list+0xl6c/Bx500
shrink_lruvec+0x270/0x304

WARN: soft lockup - CPU#32 stuck for 11s! [stress-ng:309915]
watchdog_timer_fn+0x1ac/0x2d0
__run_hrtimer+0x98/0x2a0
__hrtimer_run_queues+0xb0/0x130
hrtimer_interrupt+0x13c/0x3c0
arch_timer_handler_virt+0x3c/0x50
handle_percpu_devid_irq+0x90/0x1f4
__handle_domain_irq+0x84/0x100
gic_handle_irq+0x88/0x2b0
el1_irq+0xb8/0x140
get_swap_pages+0x1e8/0x440
get_swap_page+0x1c8/0x2e0
add_to_swap+0x20/0x9c
shrink_page_list+0x5d0/0x152c
reclaim_pages+0x160/0x310
madvise_cold_or_pageout_pte_range+0x7bc/0xe3c
walk_pmd_range.isra.0+0xac/0x22c
walk_pud_range+0xfc/0x1c0
walk_pgd_range+0x158/0x1b0
__walk_page_range+0x64/0x100
walk_page_range+0x104/0x150

Link: https://lkml.kernel.org/r/20221118133850.3360369-1-chenwandun@huawei.com
Fixes: 048c27fd7281 ("[PATCH] swap: scan_swap_map latency breaks")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: <xialonglong1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~swapfile-fix-soft-lockup-in-scan_swap_map_slots
+++ a/mm/swapfile.c
@@ -973,23 +973,23 @@ done:
 scan:
 	spin_unlock(&si->lock);
 	while (++offset <= READ_ONCE(si->highest_bit)) {
-		if (swap_offset_available_and_locked(si, offset))
-			goto checks;
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
 			scanned_many = true;
 		}
+		if (swap_offset_available_and_locked(si, offset))
+			goto checks;
 	}
 	offset = si->lowest_bit;
 	while (offset < scan_base) {
-		if (swap_offset_available_and_locked(si, offset))
-			goto checks;
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
 			scanned_many = true;
 		}
+		if (swap_offset_available_and_locked(si, offset))
+			goto checks;
 		offset++;
 	}
 	spin_lock(&si->lock);
_

Patches currently in -mm which might be from chenwandun@huawei.com are

swapfile-fix-soft-lockup-in-scan_swap_map_slots.patch

