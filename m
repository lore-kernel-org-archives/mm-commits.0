Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE9AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A106142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhEHWyC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C669A610FA;
        Sat,  8 May 2021 22:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514380;
        bh=Nhv8zoKGx+JeONBLXt7uNPMcanXTtS0tANejpQO4Y08=;
        h=Date:From:To:Subject:From;
        b=mr3UTcM8Cu2fOk5HjDlDNVYTMgNu4UJ+CmUAn3iLn0Z+mzu1kePhSTD3WiF7XcaOk
         5XrtKaGbeBXKOO4dsi8cL8H1sMtRrKXdn0K6AbWt9bNt3oc17+nMqU3Hqy6xQL/sN0
         D52KuEZ4g83HY58qoYiOG0FmLjG9lOb261tCaLm4=
Date:   Sat, 08 May 2021 15:52:59 -0700
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, glider@google.com, gustavoars@kernel.org,
        mm-commits@vger.kernel.org, qiang.zhang@windriver.com,
        vinmenon@codeaurora.org, vjitta@codeaurora.org, ylal@codeaurora.org
Subject:  [merged]
 lib-stackdepot-turn-depot_lock-spinlock-to-raw_spinlock.patch removed from
 -mm tree
Message-ID: <20210508225259.kL9IPcBPS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: stackdepot: turn depot_lock spinlock to raw_spinlock
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-turn-depot_lock-spinlock-to-raw_spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zqiang <qiang.zhang@windriver.com>
Subject: lib: stackdepot: turn depot_lock spinlock to raw_spinlock

[    2.670635] BUG: sleeping function called from invalid context
at kernel/locking/rtmutex.c:951
[    2.670638] in_atomic(): 0, irqs_disabled(): 1, non_block: 0,
pid: 19, name: pgdatinit0
[    2.670768] Call Trace:
[    2.670800]  dump_stack+0x93/0xc2
[    2.670826]  ___might_sleep.cold+0x1b2/0x1f1
[    2.670838]  rt_spin_lock+0x3b/0xb0
[    2.670838]  stack_depot_save+0x1b9/0x440
[    2.670838]  kasan_save_stack+0x32/0x40
[    2.670838]  kasan_record_aux_stack+0xa5/0xb0
[    2.670838]  __call_rcu+0x117/0x880
[    2.670838]  __exit_signal+0xafb/0x1180
[    2.670838]  release_task+0x1d6/0x480
[    2.670838]  exit_notify+0x303/0x750
[    2.670838]  do_exit+0x678/0xcf0
[    2.670838]  kthread+0x364/0x4f0
[    2.670838]  ret_from_fork+0x22/0x30

In RT system, the spin_lock will be replaced by sleepable rt_mutex lock,
in __call_rcu(), disable interrupts before calling
kasan_record_aux_stack(), will trigger above calltrace, replace spinlock
with raw_spinlock.

Link: https://lkml.kernel.org/r/20210329084009.27013-1-qiang.zhang@windriver.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reported-by: Andrew Halaney <ahalaney@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-turn-depot_lock-spinlock-to-raw_spinlock
+++ a/lib/stackdepot.c
@@ -71,7 +71,7 @@ static void *stack_slabs[STACK_ALLOC_MAX
 static int depot_index;
 static int next_slab_inited;
 static size_t depot_offset;
-static DEFINE_SPINLOCK(depot_lock);
+static DEFINE_RAW_SPINLOCK(depot_lock);
 
 static bool init_stack_slab(void **prealloc)
 {
@@ -305,7 +305,7 @@ depot_stack_handle_t stack_depot_save(un
 			prealloc = page_address(page);
 	}
 
-	spin_lock_irqsave(&depot_lock, flags);
+	raw_spin_lock_irqsave(&depot_lock, flags);
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
@@ -329,7 +329,7 @@ depot_stack_handle_t stack_depot_save(un
 		WARN_ON(!init_stack_slab(&prealloc));
 	}
 
-	spin_unlock_irqrestore(&depot_lock, flags);
+	raw_spin_unlock_irqrestore(&depot_lock, flags);
 exit:
 	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are


