Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F43C6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A9E221EB
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgLBX3V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgLBX3U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:29:20 -0500
Date:   Wed, 02 Dec 2020 15:28:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606951719;
        bh=mYwG6T8JmOYH7cDvmSDm35ZgWwVidMFjOeThLtgYupk=;
        h=From:To:Subject:From;
        b=Jd9h1OiNVvwfW0dzDE3pHzSBq/jeec45/5C7QHNwDLN8rSBIMfev6W2BTkvsrT+dD
         by/wv7bVDJCslmZ8ckoQLMaBCImINqNnA+OvDDj8SGfLVS23KyDN0DacIL3UNMjP2W
         4AGH662mcMnbCKNJ78uucnh8h99IkqoSGVAaebuw=
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        guangye.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com
Subject:  +
 kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch added to -mm
 tree
Message-ID: <20201202232838.Pr40kMRCl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix object remaining in offline per-cpu quarantine
has been added to the -mm tree.  Its filename is
     kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/1606895585-17382-2-git-send-email-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Guangye Yang <guangye.yang@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

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
@@ -188,6 +190,11 @@ void quarantine_put(struct kasan_free_me
 	local_irq_save(flags);
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	if (q->offline) {
+		qlink_free(&info->quarantine_link, cache);
+		local_irq_restore(flags);
+		return;
+	}
 	qlist_put(q, &info->quarantine_link, cache->size);
 	if (unlikely(q->bytes > QUARANTINE_PERCPU_SIZE)) {
 		qlist_move_all(q, &temp);
@@ -328,3 +335,36 @@ void quarantine_remove_cache(struct kmem
 
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

kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch

