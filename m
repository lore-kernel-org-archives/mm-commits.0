Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B1CC433FE
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3868323139
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbgLMGGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Dec 2020 01:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbgLMGGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Dec 2020 01:06:31 -0500
Date:   Sat, 12 Dec 2020 22:05:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607839525;
        bh=d+zjL2s4X1zKyG7T8Ad0BJ4gGZMsyyhNd2VjQzhnfHY=;
        h=From:To:Subject:From;
        b=OudchXLvkAZjn/Hx25cDcXVVCJHYosxtASfwqMrc9Nb6fjeViyNtKd7eHq2krgctC
         0xlAgXZViYKWEc5K0JtHIHDaimW4u1KjLvgojqkRzYkFQRFNzZqiIr0iEcjEWbHn2n
         DzrjldxwdIZccofg+9qM/FRSb4HESBDIMjbotPOs=
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        guangye.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com,
        qcai@redhat.com, qiang.zhang@windriver.com, sfr@canb.auug.org.au
Subject:  [merged]
 kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch removed from
 -mm tree
Message-ID: <20201213060524.pmMPPz32b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix object remaining in offline per-cpu quarantine
has been removed from the -mm tree.  Its filename was
     kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan: fix object remaining in offline per-cpu quarantine

We hit this issue in our internal test.  When enabling generic kasan, a
kfree()'d object is put into per-cpu quarantine first.  If the cpu goes
offline, object still remains in the per-cpu quarantine.  If we call
kmem_cache_destroy() now, slub will report "Objects remaining" error.

[   74.982625] =============================================================================
[   74.983380] BUG test_module_slab (Not tainted): Objects remaining in test_module_slab on __kmem_cache_shutdown()
[   74.984145] -----------------------------------------------------------------------------
[   74.984145]
[   74.984883] Disabling lock debugging due to kernel taint
[   74.985561] INFO: Slab 0x(____ptrval____) objects=34 used=1 fp=0x(____ptrval____) flags=0x2ffff00000010200
[   74.986638] CPU: 3 PID: 176 Comm: cat Tainted: G    B             5.10.0-rc1-00007-g4525c8781ec0-dirty #10
[   74.987262] Hardware name: linux,dummy-virt (DT)
[   74.987606] Call trace:
[   74.987924]  dump_backtrace+0x0/0x2b0
[   74.988296]  show_stack+0x18/0x68
[   74.988698]  dump_stack+0xfc/0x168
[   74.989030]  slab_err+0xac/0xd4
[   74.989346]  __kmem_cache_shutdown+0x1e4/0x3c8
[   74.989779]  kmem_cache_destroy+0x68/0x130
[   74.990176]  test_version_show+0x84/0xf0
[   74.990679]  module_attr_show+0x40/0x60
[   74.991218]  sysfs_kf_seq_show+0x128/0x1c0
[   74.991656]  kernfs_seq_show+0xa0/0xb8
[   74.992059]  seq_read+0x1f0/0x7e8
[   74.992415]  kernfs_fop_read+0x70/0x338
[   74.993051]  vfs_read+0xe4/0x250
[   74.993498]  ksys_read+0xc8/0x180
[   74.993825]  __arm64_sys_read+0x44/0x58
[   74.994203]  el0_svc_common.constprop.0+0xac/0x228
[   74.994708]  do_el0_svc+0x38/0xa0
[   74.995088]  el0_sync_handler+0x170/0x178
[   74.995497]  el0_sync+0x174/0x180
[   74.996050] INFO: Object 0x(____ptrval____) @offset=15848
[   74.996752] INFO: Allocated in test_version_show+0x98/0xf0 age=8188 cpu=6 pid=172
[   75.000802]  stack_trace_save+0x9c/0xd0
[   75.002420]  set_track+0x64/0xf0
[   75.002770]  alloc_debug_processing+0x104/0x1a0
[   75.003171]  ___slab_alloc+0x628/0x648
[   75.004213]  __slab_alloc.isra.0+0x2c/0x58
[   75.004757]  kmem_cache_alloc+0x560/0x588
[   75.005376]  test_version_show+0x98/0xf0
[   75.005756]  module_attr_show+0x40/0x60
[   75.007035]  sysfs_kf_seq_show+0x128/0x1c0
[   75.007433]  kernfs_seq_show+0xa0/0xb8
[   75.007800]  seq_read+0x1f0/0x7e8
[   75.008128]  kernfs_fop_read+0x70/0x338
[   75.008507]  vfs_read+0xe4/0x250
[   75.008990]  ksys_read+0xc8/0x180
[   75.009462]  __arm64_sys_read+0x44/0x58
[   75.010085]  el0_svc_common.constprop.0+0xac/0x228
[   75.011006] kmem_cache_destroy test_module_slab: Slab cache still has objects

Register a cpu hotplug function to remove all objects in the offline
per-cpu quarantine when cpu is going offline.  Set a per-cpu variable to
indicate this cpu is offline.

[qiang.zhang@windriver.com: fix slab double free when cpu-hotplug]
  Link: https://lkml.kernel.org/r/20201204102206.20237-1-qiang.zhang@windriver.com
Link: https://lkml.kernel.org/r/1606895585-17382-2-git-send-email-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Guangye Yang <guangye.yang@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Miles Chen <miles.chen@mediatek.com>
Cc: Qian Cai <qcai@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/kasan/quarantine.c~kasan-fix-object-remain-in-offline-per-cpu-quarantine
+++ a/mm/kasan/quarantine.c
@@ -29,6 +29,7 @@
 #include <linux/srcu.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/cpuhotplug.h>
 
 #include "../slab.h"
 #include "kasan.h"
@@ -43,6 +44,7 @@ struct qlist_head {
 	struct qlist_node *head;
 	struct qlist_node *tail;
 	size_t bytes;
+	bool offline;
 };
 
 #define QLIST_INIT { NULL, NULL, 0 }
@@ -188,6 +190,10 @@ void quarantine_put(struct kasan_free_me
 	local_irq_save(flags);
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	if (q->offline) {
+		local_irq_restore(flags);
+		return;
+	}
 	qlist_put(q, &info->quarantine_link, cache->size);
 	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE)) {
 		qlist_move_all(q, &temp);
@@ -328,3 +334,36 @@ void quarantine_remove_cache(struct kmem
 
 	synchronize_srcu(&remove_cache_srcu);
 }
+
+static int kasan_cpu_online(unsigned int cpu)
+{
+	this_cpu_ptr(&cpu_quarantine)->offline = false;
+	return 0;
+}
+
+static int kasan_cpu_offline(unsigned int cpu)
+{
+	struct qlist_head *q;
+
+	q = this_cpu_ptr(&cpu_quarantine);
+	/* Ensure the ordering between the writing to q->offline and
+	 * qlist_free_all. Otherwise, cpu_quarantine may be corrupted
+	 * by interrupt.
+	 */
+	WRITE_ONCE(q->offline, true);
+	barrier();
+	qlist_free_all(q, NULL);
+	return 0;
+}
+
+static int __init kasan_cpu_quarantine_init(void)
+{
+	int ret = 0;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "mm/kasan:online",
+				kasan_cpu_online, kasan_cpu_offline);
+	if (ret < 0)
+		pr_err("kasan cpu quarantine register failed [%d]\n", ret);
+	return ret;
+}
+late_initcall(kasan_cpu_quarantine_init);
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


