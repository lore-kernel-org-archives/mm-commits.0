Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969C5C433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C2AF2087C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262526;
	bh=5J24vZgmX2Qucvi66AsKFDhnN3yV2/8YWbJqP+vWcDM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dciG2J0j4N9KKtTjeYRzwtn85C8zfpyXrCeeYMZxjrbrYLoi03bDDg4YdQDPDGZk9
	 WyclwQSe0YB8rhoKBQOOTPaIEwQBbr2Z4k/TLvbNWFKuHVwJWmY0xZl5zTFcGZwuPd
	 HUG1rZH4TwzIpeZBvPc0N5aWDvQK7ONjkJKdAt8E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgIDXf0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C07372078E;
        Fri,  4 Sep 2020 23:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262525;
        bh=5J24vZgmX2Qucvi66AsKFDhnN3yV2/8YWbJqP+vWcDM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IJfdnRJGJh9wULiiE8I0K5NLEk4DZ1Vk4QOoDeWvDR4/zxWCten0jJM5NMizqBc9z
         XvswGCOl+l1JZN4o/AnPw1zOGDYqfU73th6Xt0iC8st38gN5NYw+q5OlE5qBl1ytUz
         zangQ9HMELFtLm+DvZEZOBE2s5eabgxTADKHSSlE=
Date:   Fri, 04 Sep 2020 16:35:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 01/19] memcg: fix use-after-free in uncharge_batch
Message-ID: <20200904233524.TtCdVpI8y%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
