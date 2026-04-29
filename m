Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6FE347515
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777466462; cv=none; b=J3v052Fbx4igaztvah5GeBdpaujI/YH6wHEpGsbBjUlppRtor7Fa37wMpxz0TWzeWOocJNWnwANkFf5b+E4sR5Z4nWBO8Olr8XxJFoJpqVhnJKsqFYcHmGEKnRcr5JkEozKNzJM6E+lPD/MS6vIWnGtekA39cJbVTHRJOcppOuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777466462; c=relaxed/simple;
	bh=DatUAEWE/Z4cdEsbOilqD4Z4lShDpJT5NB7tYTNZi5I=;
	h=Date:To:From:Subject:Message-Id; b=nz7AdfwV8IM1NNStjxmgvht6IYwgtg37XgGXcsacTW46q3kaPMuBD4rifKMjWG6UErAmTkhY5Wbc5AK/Nd8HvnsDowiK1CB0TawbpC+SXeKKCML1MTEdOV/PSk+MWhYoo7Gdto3m8QS0ZgKB3ijoM1ND0dzs/jQOz6UUjIeYrFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ra0qboth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ra0qboth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F51CC2BCC4;
	Wed, 29 Apr 2026 12:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777466462;
	bh=DatUAEWE/Z4cdEsbOilqD4Z4lShDpJT5NB7tYTNZi5I=;
	h=Date:To:From:Subject:From;
	b=ra0qbothe9rZuWzZQqtnFYPSSP0Wrbs32dbK9gBjHL63YYTiMARC9u5Z/ey46GQoq
	 lhHTK6zH64KDf89h2gGbf9MasBPpw5WbpoPxcNj/rDQgg6w6g3QINsHTunl0dsh4Ry
	 dpx8vJWO0WjmhfpYbbv9Jpw1tXDBgsKzQGHZ9GCA=
Date: Wed, 29 Apr 2026 05:41:01 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,bsegall@google.com,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch added to mm-new branch
Message-Id: <20260429124102.1F51CC2BCC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: skip HW tagging for all kernel thread stacks
has been added to the -mm mm-new branch.  Its filename is
     kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: kasan: skip HW tagging for all kernel thread stacks
Date: Wed, 29 Apr 2026 15:57:03 +0530

HW-tag KASAN never checks kernel stacks because stack pointers carry the
match-all tag, so setting/poisoning tags is pure overhead.

- Add __GFP_SKIP_KASAN to THREADINFO_GFP so every stack allocator that
  uses it skips tagging (fork path plus arch users)
- Add __GFP_SKIP_KASAN to GFP_VMAP_STACK for the fork-specific vmap
  stacks.
- When reusing cached vmap stacks, skip kasan_unpoison_range() if HW tags
  are enabled.

Software KASAN is unchanged; this only affects tag-based KASAN.

Link: https://lore.kernel.org/20260429102704.680174-3-dev.jain@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Segall <bsegall@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    2 +-
 kernel/fork.c               |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/thread_info.h~kasan-skip-hw-tagging-for-all-kernel-thread-stacks
+++ a/include/linux/thread_info.h
@@ -92,7 +92,7 @@ static inline long set_restart_fn(struct
 #define THREAD_ALIGN	THREAD_SIZE
 #endif
 
-#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
+#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 /*
  * flag set/clear/test wrappers
--- a/kernel/fork.c~kasan-skip-hw-tagging-for-all-kernel-thread-stacks
+++ a/kernel/fork.c
@@ -204,7 +204,7 @@ static DEFINE_PER_CPU(struct vm_struct *
  * accounting is performed by the code assigning/releasing stacks to tasks.
  * We need a zeroed memory without __GFP_ACCOUNT.
  */
-#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
+#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 struct vm_stack {
 	struct rcu_head rcu;
@@ -342,7 +342,8 @@ static int alloc_thread_stack_node(struc
 		}
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
+		if (!kasan_hw_tags_enabled())
+			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
 		stack = kasan_reset_tag(vm_area->addr);
 
_

Patches currently in -mm which might be from usama.anjum@arm.com are

mm-page_alloc-optimize-__free_contig_frozen_range.patch
vmalloc-add-__gfp_skip_kasan-support.patch
kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch
mm-skip-kasan-tagging-for-page-allocated-page-tables.patch

