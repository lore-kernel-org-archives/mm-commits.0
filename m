Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15384C27C40
	for <mm-commits@archiver.kernel.org>; Wed, 22 Nov 2023 21:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344416AbjKVVri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbjKVVri (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Nov 2023 16:47:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF0CA9;
        Wed, 22 Nov 2023 13:47:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BADCC433C8;
        Wed, 22 Nov 2023 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700689654;
        bh=Bmjdv91puLAvFx9mmbLU/75H09mDUEUw9NSYD1epyT8=;
        h=Date:To:From:Subject:From;
        b=pqTJrY99pm6OxmtjY0QdbZDNyhwGJ7g5X8i+Hu3hk0LN3WWZ61veRfYfXxewWQS3W
         U67gv5UF71chLaQO/5r88HrLuDnH5g9G9Pj768OPsl+0LraSobQghM+fg8ZZkp1FGj
         Ak4QTBLKP1SqQsHey2Opdwsdip5IQF+fSBCXxlrw=
Date:   Wed, 22 Nov 2023 13:47:33 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, mhocko@suse.com, gaoxu2@hihonor.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmoom_reaper-avoid-run-queue_oom_reaper-if-task-is-not-oom.patch added to mm-hotfixes-unstable branch
Message-Id: <20231122214734.0BADCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,oom_reaper: avoid run queue_oom_reaper if task is not oom
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmoom_reaper-avoid-run-queue_oom_reaper-if-task-is-not-oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmoom_reaper-avoid-run-queue_oom_reaper-if-task-is-not-oom.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: gaoxu <gaoxu2@hihonor.com>
Subject: mm,oom_reaper: avoid run queue_oom_reaper if task is not oom
Date: Wed, 22 Nov 2023 12:46:44 +0000

queue_oom_reaper() tests and sets tsk->signal->oom_mm->flags.  However, it
is necessary to check if 'tsk' is an OOM victim before executing
'queue_oom_reaper' because the variable may be NULL.

We encountered such an issue, and the log is as follows:
[3701:11_see]Out of memory: Killed process 3154 (system_server)
total-vm:23662044kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB,
UID:1000 pgtables:4056kB oom_score_adj:-900
[3701:11_see][RB/E]rb_sreason_str_set: sreason_str set null_pointer
[3701:11_see][RB/E]rb_sreason_str_set: sreason_str set unknown_addr
[3701:11_see]Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000328
[3701:11_see]user pgtable: 4k pages, 39-bit VAs, pgdp=3D00000000821de000
[3701:11_see][0000000000000328] pgd=3D0000000000000000,
p4d=3D0000000000000000,pud=3D0000000000000000
[3701:11_see]tracing off
[3701:11_see]Internal error: Oops: 96000005 [#1] PREEMPT SMP
[3701:11_see]Call trace:
[3701:11_see] queue_oom_reaper+0x30/0x170
[3701:11_see] __oom_kill_process+0x590/0x860
[3701:11_see] oom_kill_process+0x140/0x274
[3701:11_see] out_of_memory+0x2f4/0x54c
[3701:11_see] __alloc_pages_slowpath+0x5d8/0xaac
[3701:11_see] __alloc_pages+0x774/0x800
[3701:11_see] wp_page_copy+0xc4/0x116c
[3701:11_see] do_wp_page+0x4bc/0x6fc
[3701:11_see] handle_pte_fault+0x98/0x2a8
[3701:11_see] __handle_mm_fault+0x368/0x700
[3701:11_see] do_handle_mm_fault+0x160/0x2cc
[3701:11_see] do_page_fault+0x3e0/0x818
[3701:11_see] do_mem_abort+0x68/0x17c
[3701:11_see] el0_da+0x3c/0xa0
[3701:11_see] el0t_64_sync_handler+0xc4/0xec
[3701:11_see] el0t_64_sync+0x1b4/0x1b8
[3701:11_see]tracing off

Link: https://lkml.kernel.org/r/400d13bddb524ef6af37cb2220808c75@hihonor.com
Signed-off-by: Gao Xu <gaoxu2@hihonor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mmoom_reaper-avoid-run-queue_oom_reaper-if-task-is-not-oom
+++ a/mm/oom_kill.c
@@ -984,7 +984,7 @@ static void __oom_kill_process(struct ta
 	}
 	rcu_read_unlock();
 
-	if (can_oom_reap)
+	if (can_oom_reap && tsk_is_oom_victim(victim))
 		queue_oom_reaper(victim);
 
 	mmdrop(mm);
_

Patches currently in -mm which might be from gaoxu2@hihonor.com are

mmoom_reaper-avoid-run-queue_oom_reaper-if-task-is-not-oom.patch

