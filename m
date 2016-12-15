From: akpm@linux-foundation.org
Subject: [merged]
 kexec-add-cond_resched-into-kimage_alloc_crash_control_pages.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:45:15 -0800
Message-ID: <5852e4bb.K+W5DrPTP19n67/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754319AbcLOSpQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, xpang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add cond_resched into kimage_alloc_crash_control_pages
has been removed from the -mm tree.  Its filename was
     kexec-add-cond_resched-into-kimage_alloc_crash_control_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: kexec: add cond_resched into kimage_alloc_crash_control_pages

A soft lookup will occur when I run trinity in syscall kexec_load.  the
corresponding stack information is as follows.

[  237.235937] BUG: soft lockup - CPU#6 stuck for 22s! [trinity-c6:13859]
[  237.242699] Kernel panic - not syncing: softlockup: hung tasks
[  237.248573] CPU: 6 PID: 13859 Comm: trinity-c6 Tainted: G           O L ----V-------   3.10.0-327.28.3.35.zhongjiang.x86_64 #1
[  237.259984] Hardware name: Huawei Technologies Co., Ltd. Tecal BH622 V2/BC01SRSA0, BIOS RMIBV386 06/30/2014
[  237.269752]  ffffffff8187626b 0000000018cfde31 ffff88184c803e18 ffffffff81638f16
[  237.277471]  ffff88184c803e98 ffffffff8163278f 0000000000000008 ffff88184c803ea8
[  237.285190]  ffff88184c803e48 0000000018cfde31 ffff88184c803e67 0000000000000000
[  237.292909] Call Trace:
[  237.295404]  <IRQ>  [<ffffffff81638f16>] dump_stack+0x19/0x1b
[  237.301352]  [<ffffffff8163278f>] panic+0xd8/0x214
[  237.306196]  [<ffffffff8111d6fc>] watchdog_timer_fn+0x1cc/0x1e0
[  237.312157]  [<ffffffff8111d530>] ? watchdog_enable+0xc0/0xc0
[  237.317955]  [<ffffffff810aa182>] __hrtimer_run_queues+0xd2/0x260
[  237.324087]  [<ffffffff810aa720>] hrtimer_interrupt+0xb0/0x1e0
[  237.329963]  [<ffffffff8164ae5c>] ? call_softirq+0x1c/0x30
[  237.335500]  [<ffffffff81049a77>] local_apic_timer_interrupt+0x37/0x60
[  237.342228]  [<ffffffff8164bacf>] smp_apic_timer_interrupt+0x3f/0x60
[  237.348771]  [<ffffffff8164a11d>] apic_timer_interrupt+0x6d/0x80
[  237.354967]  <EOI>  [<ffffffff810f3a00>] ? kimage_alloc_control_pages+0x80/0x270
[  237.362875]  [<ffffffff811c3ebe>] ? kmem_cache_alloc_trace+0x1ce/0x1f0
[  237.369592]  [<ffffffff810f362f>] ? do_kimage_alloc_init+0x1f/0x90
[  237.375992]  [<ffffffff810f3d1a>] kimage_alloc_init+0x12a/0x180
[  237.382103]  [<ffffffff810f3f9a>] SyS_kexec_load+0x20a/0x260
[  237.387957]  [<ffffffff816494c9>] system_call_fastpath+0x16/0x1b

the first time allocation of control pages may take too much time because
crash_res.end can be set to a higher value.  we need to add cond_resched
to avoid the issue.

The patch have been tested and above issue is not appear.

Link: http://lkml.kernel.org/r/1481164674-42775-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Xunlei Pang <xpang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/kexec_core.c~kexec-add-cond_resched-into-kimage_alloc_crash_control_pages kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-cond_resched-into-kimage_alloc_crash_control_pages
+++ a/kernel/kexec_core.c
@@ -441,6 +441,8 @@ static struct page *kimage_alloc_crash_c
 	while (hole_end <= crashk_res.end) {
 		unsigned long i;
 
+		cond_resched();
+
 		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
 			break;
 		/* See if I overlap any of the segments */
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

z3fold-limit-first_num-to-the-actual-range-of-possible-buddy-indexes.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

