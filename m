Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA645C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 03:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B64E16113E
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 03:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhINDK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237372AbhINDK4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 23:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F5560E90;
        Tue, 14 Sep 2021 03:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631588979;
        bh=rx9A4LgD63Pla7ojcpShPPVVGv2oDLyPe1QNbn1c+3U=;
        h=Date:From:To:Subject:From;
        b=e1hABST+qjseDclKMkk6Dl2RdUOQO6bR7lyU/vrhOKVoPojnaPSjp+G9nHyd37Y9E
         QC3Wh8uq33R8u7dRdyLfKXJV63PCUIKI50EWIZTp4Zkana8y3P36/w2ValJ5s0n/e7
         jN6JGsEwmPJvXrRwDrumLonlOm/Vv/Oq0kAqDpqE=
Date:   Mon, 13 Sep 2021 20:09:39 -0700
From:   akpm@linux-foundation.org
To:     liupeng256@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-mmapc-fix-a-data-race-of-mm-total_vm.patch added to
 -mm tree
Message-ID: <20210914030939.1Uafb4-OV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix a data race of mm->total_vm
has been added to the -mm tree.  Its filename is
     mm-mmapc-fix-a-data-race-of-mm-total_vm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-fix-a-data-race-of-mm-total_vm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-fix-a-data-race-of-mm-total_vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from liupeng256@huawei.com are

mm-mmapc-fix-a-data-race-of-mm-total_vm.patch

