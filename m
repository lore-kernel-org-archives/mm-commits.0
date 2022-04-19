Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545AEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 00:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbiDSA2p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 20:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiDSA2o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 20:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B8237DA
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 17:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0B79B81136
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 00:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359F4C385A1;
        Tue, 19 Apr 2022 00:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327961;
        bh=ZD5zCMu5Og3SIbLIjleOFgWp8hUOICzKds0Kw42O1MA=;
        h=Date:To:From:Subject:From;
        b=uEGOLGD9tbDPrN+BxF3bdBchoNE3WLYL7g8R0fdnkKQyc1lLumC/slgAoz9c7836+
         +oh4d2Lx6Yk0W7U0eGJIE81WcbM3T1nyFYOzKww5bwaoSRruA/FLsfY2WBPuyGdMk4
         VY2JT9tCBvVAjukUgaT0+mbXO2lEOpfqPCXMJKXY=
Date:   Mon, 18 Apr 2022 17:26:00 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        qiang1.zhang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] irq_work-use-kasan_record_aux_stack_noalloc-record-callstack.patch removed from -mm tree
Message-Id: <20220419002601.359F4C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: irq_work: use kasan_record_aux_stack_noalloc() record callstack
has been removed from the -mm tree.  Its filename was
     irq_work-use-kasan_record_aux_stack_noalloc-record-callstack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zqiang <qiang1.zhang@intel.com>
Subject: irq_work: use kasan_record_aux_stack_noalloc() record callstack

[    4.113128] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
[    4.113132] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 239, name: bootlogd
[    4.113149] Preemption disabled at:
[    4.113149] [<ffffffffbab1a531>] rt_mutex_slowunlock+0xa1/0x4e0
[    4.113154] CPU: 3 PID: 239 Comm: bootlogd Tainted: G        W
5.17.1-rt17-yocto-preempt-rt+ #105
[    4.113157] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[    4.113159] Call Trace:
[    4.113160]  <TASK>
[    4.113161]  dump_stack_lvl+0x60/0x8c
[    4.113165]  dump_stack+0x10/0x12
[    4.113167]  __might_resched.cold+0x13b/0x173
[    4.113172]  rt_spin_lock+0x5b/0xf0
[    4.113179]  get_page_from_freelist+0x20c/0x1610
[    4.113208]  __alloc_pages+0x25e/0x5e0
[    4.113222]  __stack_depot_save+0x3c0/0x4a0
[    4.113228]  kasan_save_stack+0x3a/0x50
[    4.113322]  __kasan_record_aux_stack+0xb6/0xc0
[    4.113326]  kasan_record_aux_stack+0xe/0x10
[    4.113329]  irq_work_queue_on+0x6a/0x1c0
[    4.113333]  pull_rt_task+0x631/0x6b0
[    4.113343]  do_balance_callbacks+0x56/0x80
[    4.113346]  __balance_callbacks+0x63/0x90
[    4.113350]  rt_mutex_setprio+0x349/0x880
[    4.113366]  rt_mutex_slowunlock+0x22a/0x4e0
[    4.113377]  rt_spin_unlock+0x49/0x80
[    4.113380]  uart_write+0x186/0x2b0
[    4.113385]  do_output_char+0x2e9/0x3a0
[    4.113389]  n_tty_write+0x306/0x800
[    4.113413]  file_tty_write.isra.0+0x2af/0x450
[    4.113422]  tty_write+0x22/0x30
[    4.113425]  new_sync_write+0x27c/0x3a0
[    4.113446]  vfs_write+0x3f7/0x5d0
[    4.113451]  ksys_write+0xd9/0x180
[    4.113463]  __x64_sys_write+0x43/0x50
[    4.113466]  do_syscall_64+0x44/0x90
[    4.113469]  entry_SYSCALL_64_after_hwframe+0x44/0xae

On PREEMPT_RT kernel and KASAN is enabled.  the kasan_record_aux_stack()
may call alloc_pages(), and the rt-spinlock will be acquired, if currently
in atomic context, will trigger warning.  fix it by use
kasan_record_aux_stack_noalloc() to avoid call alloc_pages().

Link: https://lkml.kernel.org/r/20220402142555.2699582-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq_work.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq_work.c~irq_work-use-kasan_record_aux_stack_noalloc-record-callstack
+++ a/kernel/irq_work.c
@@ -137,7 +137,7 @@ bool irq_work_queue_on(struct irq_work *
 	if (!irq_work_claim(work))
 		return false;
 
-	kasan_record_aux_stack(work);
+	kasan_record_aux_stack_noalloc(work);
 
 	preempt_disable();
 	if (cpu != smp_processor_id()) {
_

Patches currently in -mm which might be from qiang1.zhang@intel.com are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

