Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6B56B7F;
	Tue, 20 Feb 2024 01:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708393512; cv=none; b=mtT635HC2PdaakQxncaoSS5x6boEaLY8GrGE+9s2/O6QQzEq0YMIwEiDodJOVjgHPzaNFPizcmA6i/OQvmGcYT3u9PsHANII7k7/1ID0awejfDG2E99TI+qn5QciW/DevuenASJgH9tU0WjENwq2p9lghAaI9kS9dd2RbnFFp4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708393512; c=relaxed/simple;
	bh=upQvG1PLe8QFkOaJJWw7J9DLsK4yZodZOICsIfmNJMw=;
	h=Date:To:From:Subject:Message-Id; b=U8JkamsLLVfYvGnqeMfp9TjqKUbzojXn/ELjDXb7aZ8j2JH20Gp4W94jB3oKmjJyzjJD5vW8D5HSmADT6hK0jOjCxLvERKBzz8b4+aDObCqSJqiLosrGlPQxN0iG/Om3S31vyFn+YCrrysk6NGsNuS14wMwhN+XjaShQbqMAKA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=logFz/wW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="logFz/wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B420DC433F1;
	Tue, 20 Feb 2024 01:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708393511;
	bh=upQvG1PLe8QFkOaJJWw7J9DLsK4yZodZOICsIfmNJMw=;
	h=Date:To:From:Subject:From;
	b=logFz/wWc3soTelqXVwwvkAjFgKJIAfJZX2hUUqcGmVL1kyPvh6dOHX9Wy19uEbfb
	 G76/hiYxrHJPF48SV8gyzZ344roWSmDVowt2oK2Uph2kosAKre1kMPem3iqONVOGm4
	 5H1PL/Y7AeD22nPKfHrZi4s8SEjd3XqwJxn3m1kY=
Date: Mon, 19 Feb 2024 17:45:11 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vschneid@redhat.com,vincent.guittot@linaro.org,stable@vger.kernel.org,rostedt@goodmis.org,peterz@infradead.org,pauld@redhat.com,osalvador@suse.de,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,bristot@redhat.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20240220014511.B420DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sched/numa, mm: do not try to migrate memory to memoryless nodes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch

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
From: Byungchul Park <byungchul@sk.com>
Subject: sched/numa, mm: do not try to migrate memory to memoryless nodes
Date: Mon, 19 Feb 2024 13:10:47 +0900

With numa balancing on, when a numa system is running where a numa node
doesn't have its local memory so it has no managed zones, the following
oops has been observed.  It's because wakeup_kswapd() is called with a
wrong zone index, -1.  Fixed it by checking the index before calling
wakeup_kswapd().

> BUG: unable to handle page fault for address: 00000000000033f3
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 2 PID: 895 Comm: masim Not tainted 6.6.0-dirty #255
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>    rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> RIP: 0010:wakeup_kswapd (./linux/mm/vmscan.c:7812)
> Code: (omitted)
> RSP: 0000:ffffc90004257d58 EFLAGS: 00010286
> RAX: ffffffffffffffff RBX: ffff88883fff0480 RCX: 0000000000000003
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88883fff0480
> RBP: ffffffffffffffff R08: ff0003ffffffffff R09: ffffffffffffffff
> R10: ffff888106c95540 R11: 0000000055555554 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88883fff0940
> FS:  00007fc4b8124740(0000) GS:ffff888827c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000033f3 CR3: 000000026cc08004 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
> ? __die
> ? page_fault_oops
> ? __pte_offset_map_lock
> ? exc_page_fault
> ? asm_exc_page_fault
> ? wakeup_kswapd
> migrate_misplaced_page
> __handle_mm_fault
> handle_mm_fault
> do_user_addr_fault
> exc_page_fault
> asm_exc_page_fault
> RIP: 0033:0x55b897ba0808
> Code: (omitted)
> RSP: 002b:00007ffeefa821a0 EFLAGS: 00010287
> RAX: 000055b89983acd0 RBX: 00007ffeefa823f8 RCX: 000055b89983acd0
> RDX: 00007fc2f8122010 RSI: 0000000000020000 RDI: 000055b89983acd0
> RBP: 00007ffeefa821a0 R08: 0000000000000037 R09: 0000000000000075
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 00007ffeefa82410 R14: 000055b897ba5dd8 R15: 00007fc4b8340000
>  </TASK>

Fix this by avoiding any attempt to migrate memory to memoryless nodes.

Link: https://lkml.kernel.org/r/20240219041920.1183-1-byungchul@sk.com
Link: https://lkml.kernel.org/r/20240216111502.79759-1-byungchul@sk.com
Fixes: c574bbe917036 ("NUMA balancing: optimize page placement for memory tiering system")
Signed-off-by: Byungchul Park <byungchul@sk.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Phil Auld <pauld@redhat.com>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/fair.c~sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes
+++ a/kernel/sched/fair.c
@@ -1831,6 +1831,12 @@ bool should_numa_migrate_memory(struct t
 	int last_cpupid, this_cpupid;
 
 	/*
+	 * Cannot migrate to memoryless nodes.
+	 */
+	if (!node_state(dst_nid, N_MEMORY))
+		return false;
+
+	/*
 	 * The pages in slow memory node should be migrated according
 	 * to hot/cold instead of private/shared.
 	 */
_

Patches currently in -mm which might be from byungchul@sk.com are

sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch
mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch

