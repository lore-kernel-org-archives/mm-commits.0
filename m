Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F4D370AE1
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027673; cv=none; b=NG06DrNvRLsFexb3eimAW7qJncC34YlAwJwE8Xjo3byRWUXs6Y0rFqbKuCBjjmYv0tDPPHldIbLyJ+qDfprc5XLAXmBXFH7uZHhssqpjoDhCQZc9HePJjkDOKjNaN46VXJE6FFiFssFV654iaOpN/IyrRjK3JdvgKU7f1ryJQHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027673; c=relaxed/simple;
	bh=xQNXW57r8Aj5VF0nhX9nnjxkXB2J6biR8umxbqRqFhg=;
	h=Date:To:From:Subject:Message-Id; b=jhRkMSwOtjfL4ie7td/k6VNgNIFkjW7xzx0XXZ845c5It/cOm7MaZ59woUsKCDJ9AFFYokUWAXSDB2jcj3CCX3m68J28uve4t6LQ9eiyj+R/syv8k7Qd+33zFxmDfOd5DII7bwLk0OBDtRwTx25hJqwiLSWQHcGgNXQ/DZHWpi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q5eiCtaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5eiCtaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BDD1F00898;
	Fri, 29 May 2026 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027671;
	bh=nouc1iWMqxAsFhtYqbp1n+kV070uOuvL3LBwAzaGCfk=;
	h=Date:To:From:Subject;
	b=q5eiCtaZcH2ONqP10K72XyJOaSN/UlHlcIr+YhVlxiX+6pGxU8w36UxQFJYRU6bsm
	 7ZOHi6ovlaEUYCT477YpIoc4mB6xvX3kKr37aK1DyQ5yWfpqnH7A7BVnJIx9BwO+bX
	 S+Gk85/N50DdwlZ2FBx1TC2i6UoWrDdMxmWdLg0U=
Date: Thu, 28 May 2026 21:07:51 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,bsegall@google.com,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch removed from -mm tree
Message-Id: <20260529040751.C0BDD1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: skip HW tagging for all kernel thread stacks
has been removed from the -mm tree.  Its filename was
     kasan-skip-hw-tagging-for-all-kernel-thread-stacks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Segall <bsegall@google.com>
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


