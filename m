Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CED4ACC74;
	Tue, 15 Sep 2026 23:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514603; cv=none; b=HuUd/RJUv27I1Kn4bHuvyjKa3bbMOexsqJc1GwIuk/M+7CbODq5wBK9gLeH4lntqzRwsjNzmB5YM8HIHfSHab5oBVn44t2tgcwftqM6OTwNdbb7sjYuY2k0fdK8QQg9QvaNEVevEOiMImIL4zRKHTVWQof76q7Q8bLuBDcVuts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514603; c=relaxed/simple;
	bh=lJn14TKtFaPel9ILnOOEgYYszwZ2dyMnSntaunP61Pc=;
	h=Date:To:From:Subject:Message-Id; b=Vye6tOjliZgUBgZB4nt6xCOrp+qxxLOkWASyMwMDku/QZtM/EA96GJw95TTTLG3x4K/7DviDumTSFd8hNNeLzE5H0ZqHAqNR0kcoiryeIEAdBz6bHmDiVcUOXeFPY3H0Q+SpplNnlBHHaAL7vRR5gGJlyZyfXqgZ38UskhiAmf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+aRH24p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+aRH24p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876B71F000FF;
	Tue, 15 Sep 2026 23:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789514601;
	bh=lvoRibTBbn6rTgKwf3Y0/fL2PNuRey6x1ijoZVeQAKc=;
	h=Date:To:From:Subject;
	b=h+aRH24pWu/sdP6kdX3cI+Xy9FoeENMzYEyy5SzNxHnVwAHmbHA9xoSiaM3mLVviR
	 du+yDmB/qBzG5HXn2dYrUdAoJ0FA3C9xzWJe1bxdN3DphiC9wutPMfLE7ama/12tAH
	 ZRNF4kKFFM8jzE/16Z5btuDic3+GqRYTp2jOnXJ4=
Date: Tue, 15 Sep 2026 16:23:21 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincenzo.frascino@arm.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,glider@google.com,dvyukov@google.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,andreyknvl@gmail.com,huangshaobo3@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree.patch added to mm-nonmm-unstable branch
Message-Id: <20260915232321.876B71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: reset pointer tag of vmapped thread stack before vfree
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shaobo Huang <huangshaobo3@xiaomi.com>
Subject: fork: reset pointer tag of vmapped thread stack before vfree
Date: Mon, 14 Sep 2026 17:33:00 +0800

thread_stack_free_rcu() frees the vmalloc'd thread stack via
vfree(vm_area->addr).  In RCU callback context, vfree() routes to
vfree_atomic(), which calls llist_add((struct llist_node *)addr, ...) and
writes 8 bytes to the base of the region being freed.

With KASAN_SW_TAGS, vm_area->addr carries a random tag.  If
kasan_unpoison_task_stack_below() has rewritten the shadow covering [base,
sp] to KASAN_TAG_KERNEL (0xff) -- which it does on every CPU resume for
the current task's stack -- the llist_add store checks shadow[base] (0xff)
against the pointer tag (random) and reports an invalid-access, although
writing to the base of a stack queued for deferred free is legitimate.

Reset the pointer tag to KASAN_TAG_KERNEL before vfree() so that
kasan_check_range() short-circuits the check, the same way the task
accesses its own stack at runtime via sp.  The vmalloc lookup is safe:
__find_vmap_area() resets the tag before comparing against va_start.

Link: https://lore.kernel.org/20260914093300.100495-1-huangshaobo3@xiaomi.com
Fixes: 9f7d416c3612 ("kprobes: Unpoison stack in jprobe_return() for KASAN")
Assisted-by: zhipuai:glm-5.2
Signed-off-by: Shaobo Huang <huangshaobo3@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree
+++ a/kernel/fork.c
@@ -280,7 +280,7 @@ static void thread_stack_free_rcu(struct
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_area->addr);
+	vfree(kasan_reset_tag(vm_area->addr));
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
_

Patches currently in -mm which might be from huangshaobo3@xiaomi.com are

fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree.patch

