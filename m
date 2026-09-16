Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6184DE711;
	Wed, 16 Sep 2026 21:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789592460; cv=none; b=pSu7yvhizT3Ou6NQU/5p839WXkhYpK1iTw9z2g/ZEIxiDiIyrVPDBDYCA3JPDTBlfyHItDhdWBzDMQwSq77hVD0Jh345FUZOa6uyJWUDuUIW63i3QIS9eHfr2hvLf9E3GmPMnx7I3+IgSdEkxP3/aUBZAcm44ciwF8xJx4VTk78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789592460; c=relaxed/simple;
	bh=b5WN33PtXh9VODYR7n75cY+cLSfnBLLpfh7SMLGMwVM=;
	h=Date:To:From:Subject:Message-Id; b=jEF0ibH8M3mG+BSV0Hmj9VLXufc2YND2uEQUIXOuX5XwH87UGyWzZMjn3WXyBpFoO6kBWHat6XxZU8xL5aDlvvB3m0xIJ+u3PnXbsiFLziOiPibpx1vDoSwHBzh8Xb23ivq1YoFQ543hheMWNzzMYfKE9JbzmMeQLNaox8pFs8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANFW8T+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANFW8T+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BFD1F000FF;
	Wed, 16 Sep 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789592427;
	bh=PW1POS5g4lrxvT3HIAfzYac0aVp5dJ/oy7vxsJwdV8Q=;
	h=Date:To:From:Subject;
	b=ANFW8T+nbXA2cIfC+dPUb/XtiZ7idU5PVM47MU2g2IrCjxgiXxAspqkpD5NHXsqnT
	 L3TKwbJzfw4F/ZcsxdgQM9X/cnsRds/R1y3JQhJ5tBeuyqoY2RkCiY1xY03+bAtn7A
	 pQ5Q3vW6isd9Au1OZ6VrtZkfGo9yjFYYOp+4HKEg=
Date: Wed, 16 Sep 2026 14:00:26 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincenzo.frascino@arm.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,glider@google.com,dvyukov@google.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,andreyknvl@gmail.com,huangshaobo3@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree.patch removed from -mm tree
Message-Id: <20260916210027.11BFD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: reset pointer tag of vmapped thread stack before vfree
has been removed from the -mm tree.  Its filename was
     fork-reset-pointer-tag-of-vmapped-thread-stack-before-vfree.patch

This patch was dropped because an alternative patch was or shall be merged

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


