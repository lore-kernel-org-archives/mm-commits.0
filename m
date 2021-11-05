Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C744C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE6261263
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhKEUkx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhKEUkx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F238D611C4;
        Fri,  5 Nov 2021 20:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144693;
        bh=FgwI/W7sBWzuvMF+2tMW3dFamQwob5KnsnD+Bqc9pgg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=18AlemLY2u6wkSB3c/k0j5tRcNYC9RolUQxHIWAZ/nwb7AEgLzNEYk+2mlrN0Y0eO
         Rkz3hajjhriKXuOVm9BYkHvS2IZlhnLRjRo5DQiIb1NmllKThu5PgxnOQ5IUyDPJmY
         AkE9R+FYPCgVb9QAvsJVWWL249YLj/0vV3u19utQ=
Date:   Fri, 05 Nov 2021 13:38:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liupeng256@huawei.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 068/262] mm/mmap.c: fix a data race of
 mm->total_vm
Message-ID: <20211105203812.6Y1n-n47F%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peng Liu <liupeng256@huawei.com>
Subject: mm/mmap.c: fix a data race of mm->total_vm

Variable mm->total_vm could be accessed concurrently during mmaping and
system accounting as noticed by KCSAN,

BUG: KCSAN: data-race in __acct_update_integrals / mmap_region

read-write to 0xffffa40267bd14c8 of 8 bytes by task 15609 on cpu 3:
 mmap_region+0x6dc/0x1400
 do_mmap+0x794/0xca0
 vm_mmap_pgoff+0xdf/0x150
 ksys_mmap_pgoff+0xe1/0x380
 do_syscall_64+0x37/0x50
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffffa40267bd14c8 of 8 bytes by interrupt on cpu 2:
 __acct_update_integrals+0x187/0x1d0
 acct_account_cputime+0x3c/0x40
 update_process_times+0x5c/0x150
 tick_sched_timer+0x184/0x210
 __run_hrtimer+0x119/0x3b0
 hrtimer_interrupt+0x350/0xaa0
 __sysvec_apic_timer_interrupt+0x7b/0x220
 asm_call_irq_on_stack+0x12/0x20
 sysvec_apic_timer_interrupt+0x4d/0x80
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 smp_call_function_single+0x192/0x2b0
 perf_install_in_context+0x29b/0x4a0
 __se_sys_perf_event_open+0x1a98/0x2550
 __x64_sys_perf_event_open+0x63/0x70
 do_syscall_64+0x37/0x50
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 2 PID: 15610 Comm: syz-executor.3 Not tainted 5.10.0+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014

In vm_stat_account which called by mmap_region, increase total_vm, and
__acct_update_integrals may read total_vm at the same time.  This will
cause a data race which lead to undefined behaviour.  To avoid potential
bad read/write, volatile property and barrier are both used to avoid
undefined behaviour.

Link: https://lkml.kernel.org/r/20210913105550.1569419-1-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    2 +-
 mm/mmap.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/tsacct.c~mm-mmapc-fix-a-data-race-of-mm-total_vm
+++ a/kernel/tsacct.c
@@ -137,7 +137,7 @@ static void __acct_update_integrals(stru
 	 * the rest of the math is done in xacct_add_tsk.
 	 */
 	tsk->acct_rss_mem1 += delta * get_mm_rss(tsk->mm) >> 10;
-	tsk->acct_vm_mem1 += delta * tsk->mm->total_vm >> 10;
+	tsk->acct_vm_mem1 += delta * READ_ONCE(tsk->mm->total_vm) >> 10;
 }
 
 /**
--- a/mm/mmap.c~mm-mmapc-fix-a-data-race-of-mm-total_vm
+++ a/mm/mmap.c
@@ -3332,7 +3332,7 @@ bool may_expand_vm(struct mm_struct *mm,
 
 void vm_stat_account(struct mm_struct *mm, vm_flags_t flags, long npages)
 {
-	mm->total_vm += npages;
+	WRITE_ONCE(mm->total_vm, READ_ONCE(mm->total_vm)+npages);
 
 	if (is_exec_mapping(flags))
 		mm->exec_vm += npages;
_
