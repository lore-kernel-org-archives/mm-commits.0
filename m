Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F5DC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A9CF610CA
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhJ0VsK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhJ0VsK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFFDB610A6;
        Wed, 27 Oct 2021 21:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635371144;
        bh=VX2BSQk1y8AIVXycK+SwWvz+3BdvTHkfWfnAwozD1Q0=;
        h=Date:From:To:Subject:From;
        b=EGw8q+myT52qo1pexlaTtB6Un8RvufPscX7EE3WtNLbmof3/CihWLOsZCT068sDxN
         HuUEBofQoRSc9FtGkPgyJEueDcbQhC9597Ju2N6G8UdxOpAxQ2UKCaeIdd0rKjI44s
         DMOgvw+O07y/v/7MWea/49ypEHWftdbpOARKWytI=
Date:   Wed, 27 Oct 2021 14:45:43 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        songyuanzheng@huawei.com, willy@infradead.org
Subject:  +
 mm-vmpressure-fix-data-race-with-memcg-socket_pressure.patch added to -mm
 tree
Message-ID: <20211027214543.HTqOeebpa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmpressure: fix data-race with memcg->socket_pressure
has been added to the -mm tree.  Its filename is
     mm-vmpressure-fix-data-race-with-memcg-socket_pressure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmpressure-fix-data-race-with-memcg-socket_pressure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmpressure-fix-data-race-with-memcg-socket_pressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from songyuanzheng@huawei.com are

mm-vmpressure-fix-data-race-with-memcg-socket_pressure.patch

