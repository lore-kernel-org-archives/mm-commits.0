Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C07AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8669861262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhKEUpd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhKEUpd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3CAA61058;
        Fri,  5 Nov 2021 20:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144973;
        bh=g1888CIvImU0pakxVSLIfwqeSvRyGlBTDwFLNnrr2w8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WjAHkCZGg/hkNv2b3F3CBtSRkTnjCT0S2QSJgYl0H24Tq35ct/KaXlIl84x2i4nM0
         3ZMxYJb32gOdPjMYX1UOqVgVcnQ3lnGvtepCGphEQOm/Z6j1Nrkqxj5f8Un7Lw4Rju
         PLPozgSxEKBDVg1HO9ktKzSQmmI9Od2gIKmGyY6M=
Date:   Fri, 05 Nov 2021 13:42:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        songyuanzheng@huawei.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 157/262] mm/vmpressure: fix data-race with
 memcg->socket_pressure
Message-ID: <20211105204252.CP8W1bmFQ%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yuanzheng Song <songyuanzheng@huawei.com>
Subject: mm/vmpressure: fix data-race with memcg->socket_pressure

BUG: KCSAN: data-race in __sk_mem_reduce_allocated / vmpressure

write to 0xffff8881286f4938 of 8 bytes by task 24550 on cpu 3:
 vmpressure+0x218/0x230 mm/vmpressure.c:307
 shrink_node_memcgs+0x2b9/0x410 mm/vmscan.c:2658
 shrink_node+0x9d2/0x11d0 mm/vmscan.c:2769
 shrink_zones+0x29f/0x470 mm/vmscan.c:2972
 do_try_to_free_pages+0x193/0x6e0 mm/vmscan.c:3027
 try_to_free_mem_cgroup_pages+0x1c0/0x3f0 mm/vmscan.c:3345
 reclaim_high mm/memcontrol.c:2440 [inline]
 mem_cgroup_handle_over_high+0x18b/0x4d0 mm/memcontrol.c:2624
 tracehook_notify_resume include/linux/tracehook.h:197 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0x110/0x170 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x16/0x30 kernel/entry/common.c:266
 ret_from_fork+0x15/0x30 arch/x86/entry/entry_64.S:289

read to 0xffff8881286f4938 of 8 bytes by interrupt on cpu 1:
 mem_cgroup_under_socket_pressure include/linux/memcontrol.h:1483 [inline]
 sk_under_memory_pressure include/net/sock.h:1314 [inline]
 __sk_mem_reduce_allocated+0x1d2/0x270 net/core/sock.c:2696
 __sk_mem_reclaim+0x44/0x50 net/core/sock.c:2711
 sk_mem_reclaim include/net/sock.h:1490 [inline]
 ......
 net_rx_action+0x17a/0x480 net/core/dev.c:6864
 __do_softirq+0x12c/0x2af kernel/softirq.c:298
 run_ksoftirqd+0x13/0x20 kernel/softirq.c:653
 smpboot_thread_fn+0x33f/0x510 kernel/smpboot.c:165
 kthread+0x1fc/0x220 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

When reading memcg->socket_pressure in mem_cgroup_under_socket_pressure()
and writing memcg->socket_pressure in vmpressure() at the same time,
the data-race occurs.

So fix it by using READ_ONCE() and WRITE_ONCE() to read and write
memcg->socket_pressure.

Link: https://lkml.kernel.org/r/20211025082843.671690-1-songyuanzheng@huawei.com
Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/vmpressure.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmpressure-fix-data-race-with-memcg-socket_pressure
+++ a/include/linux/memcontrol.h
@@ -1606,7 +1606,7 @@ static inline bool mem_cgroup_under_sock
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
 		return true;
 	do {
-		if (time_before(jiffies, memcg->socket_pressure))
+		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 	return false;
--- a/mm/vmpressure.c~mm-vmpressure-fix-data-race-with-memcg-socket_pressure
+++ a/mm/vmpressure.c
@@ -308,7 +308,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 			 * asserted for a second in which subsequent
 			 * pressure events can occur.
 			 */
-			memcg->socket_pressure = jiffies + HZ;
+			WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 		}
 	}
 }
_
