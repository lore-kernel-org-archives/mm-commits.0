Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E12C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 18:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885C620738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598292244;
	bh=N/uWFnJRJibmyo1L/2OHxFHcLfiH5trBTe7rIsqb7P4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=M/9qywVgxChz/JW2ZgUop09SxAdQt3DNGU7l8JlyQL/3WBlUoK4zRFn8XILqY8FCD
	 vNA/0cvsDpMNaeUMJeALnA7+RLSZg9wXgYpKi8188+trX8crbLjroCULP8khgNikCF
	 fRMowHApdzisSxjd8m1DFsaAO8ZgvNcrB/gFHofA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHXSEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 14:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgHXSED (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 14:04:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA66C20702;
        Mon, 24 Aug 2020 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598292243;
        bh=N/uWFnJRJibmyo1L/2OHxFHcLfiH5trBTe7rIsqb7P4=;
        h=Date:From:To:Subject:From;
        b=pXW0/TloaL74YKdj9TFe0nCNTmSJrAu4iC6hi64oK/i5POzWQEekkxy3cEs1RZAlb
         LvhkpTmRUFSg6icJZAERXig6+cWBGZpxsHRWMRNLNQCeLhLXVJfZmYNhoxhjMTznNL
         nT1y0vFByAC5L1dcCiiLweh+XOs2maznI1Fm7eYs=
Date:   Mon, 24 Aug 2020 11:04:02 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + memcg-fix-use-after-free-in-uncharge_batch.patch added
 to -mm tree
Message-ID: <20200824180402._8AonwlyY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix use-after-free in uncharge_batch
has been added to the -mm tree.  Its filename is
     memcg-fix-use-after-free-in-uncharge_batch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-use-after-free-in-uncharge_batch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-use-after-free-in-uncharge_batch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: fix use-after-free in uncharge_batch

syzbot has reported an use-after-free in the uncharge_batch path

BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic64_sub_return include/asm-generic/atomic-instrumented.h:970 [inline]
BUG: KASAN: use-after-free in atomic_long_sub_return include/asm-generic/atomic-long.h:113 [inline]
BUG: KASAN: use-after-free in page_counter_cancel mm/page_counter.c:54 [inline]
BUG: KASAN: use-after-free in page_counter_uncharge+0x3d/0xc0 mm/page_counter.c:155
Write of size 8 at addr ffff8880371c0148 by task syz-executor.0/9304

CPU: 0 PID: 9304 Comm: syz-executor.0 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:183 [inline]
 check_memory_region+0x2b5/0x2f0 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic64_sub_return include/asm-generic/atomic-instrumented.h:970 [inline]
 atomic_long_sub_return include/asm-generic/atomic-long.h:113 [inline]
 page_counter_cancel mm/page_counter.c:54 [inline]
 page_counter_uncharge+0x3d/0xc0 mm/page_counter.c:155
 uncharge_batch+0x6c/0x350 mm/memcontrol.c:6764
 uncharge_page+0x115/0x430 mm/memcontrol.c:6796
 uncharge_list mm/memcontrol.c:6835 [inline]
 mem_cgroup_uncharge_list+0x70/0xe0 mm/memcontrol.c:6877
 release_pages+0x13a2/0x1550 mm/swap.c:911
 tlb_batch_pages_flush mm/mmu_gather.c:49 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:242 [inline]
 tlb_flush_mmu+0x780/0x910 mm/mmu_gather.c:249
 tlb_finish_mmu+0xcb/0x200 mm/mmu_gather.c:328
 exit_mmap+0x296/0x550 mm/mmap.c:3185
 __mmput+0x113/0x370 kernel/fork.c:1076
 exit_mm+0x4cd/0x550 kernel/exit.c:483
 do_exit+0x576/0x1f20 kernel/exit.c:793
 do_group_exit+0x161/0x2d0 kernel/exit.c:903
 get_signal+0x139b/0x1d30 kernel/signal.c:2743
 arch_do_signal+0x33/0x610 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x8d/0x1b0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

1a3e1f40962c ("mm: memcontrol: decouple reference counting from page
accounting") has reworked the memcg lifetime to be bound the the struct
page rather than charges.  It has also removed the css_put_many from
uncharge_batch and that is causing the above splat.  uncharge_batch is
supposed to uncharge accumulated charges for all pages freed from the same
memcg.  The queuing is done by uncharge_page which however drops the memcg
reference after it adds charges to the batch.  If the current page happens
to be the last one holding the reference for its memcg then the memcg is
OK to go and the next page to be freed will trigger batched uncharge which
needs to access the memcg which is gone already.

Fix the issue by taking a reference for the memcg in the current batch.

Link: https://lkml.kernel.org/r/20200820090341.GC5033@dhcp22.suse.cz
Fixes: 1a3e1f40962c ("mm: memcontrol: decouple reference counting from page accounting")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: syzbot+b305848212deec86eabe@syzkaller.appspotmail.com
Reported-by: syzbot+b5ea6fb6f139c8b9482b@syzkaller.appspotmail.com
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~memcg-fix-use-after-free-in-uncharge_batch
+++ a/mm/memcontrol.c
@@ -6774,6 +6774,9 @@ static void uncharge_batch(const struct
 	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
+
+	/* drop reference from uncharge_page */
+	css_put(&ug->memcg->css);
 }
 
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
@@ -6797,6 +6800,9 @@ static void uncharge_page(struct page *p
 			uncharge_gather_clear(ug);
 		}
 		ug->memcg = page->mem_cgroup;
+
+		/* pairs with css_put in uncharge_batch */
+		css_get(&ug->memcg->css);
 	}
 
 	nr_pages = compound_nr(page);
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-fix-use-after-free-in-uncharge_batch.patch

