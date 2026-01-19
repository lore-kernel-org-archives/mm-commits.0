Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCAC23FC54;
	Mon, 19 Jan 2026 20:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854645; cv=none; b=hRadJfCP54pvQHAL5jGpZLU5pEIRQTHgxkZ+zUipU0eTR9+36KgTXrkORoUvMRLn8GCGyopiPajElJwYq9TBvIU/TFcIgOXxFaSXelrbqM7+15dqgURQaG+hGQxKHNIz5hNTUTWFTFburSOCxWX8wcrxytxtDkJtYrcNmULKs2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854645; c=relaxed/simple;
	bh=zwfpeAnrB8BeNETMcYy39u+bPOQq+OAPZbzYLmTpIo8=;
	h=Date:To:From:Subject:Message-Id; b=QHrVUjW/CeTw/wFhFn7antELk65thn3WgwtrLJe1re9jrVJxzTTkpe28C6pOFeHtKbfhW6yS1R7qOE4wAyl1NdSgiXMmtEx2fN8mIgzM7imNXEXLvpu6so2lFtVQ6DZ46k8ubtrclJcyqhovY8z5gDhoXOcu6M0R5n6lxVxdebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gAb1IAgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gAb1IAgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4860DC116C6;
	Mon, 19 Jan 2026 20:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854645;
	bh=zwfpeAnrB8BeNETMcYy39u+bPOQq+OAPZbzYLmTpIo8=;
	h=Date:To:From:Subject:From;
	b=gAb1IAgOLPWEu4c5w3XdQVK3MZ5wSk05wh0d+2gUciJXOlRF8whniKZSQ2nGHVAt0
	 uc+gKI6QUoCsyuPNDyfAayR5/S7lJLfeS0oJO/LffGeOi+19RkQO2XTkL9QeaniP1q
	 lXOCIkkwVBceB6mqQdgSjNHK1EhKWA71ee2WFsKQ=
Date: Mon, 19 Jan 2026 12:30:44 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@kernel.org,sweettea-kernel@dorminy.me,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch removed from -mm tree
Message-Id: <20260119203045.4860DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: take into account mm_cid size for mm_struct static definitions
has been removed from the -mm tree.  Its filename was
     mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: take into account mm_cid size for mm_struct static definitions
Date: Wed, 24 Dec 2025 12:33:58 -0500

Both init_mm and efi_mm static definitions need to make room for the 2
mm_cid cpumasks.

This fixes possible out-of-bounds accesses to init_mm and efi_mm.

Add a space between # and define for the mm_alloc_cid() definition to make
it consistent with the coding style used in the rest of this header file.

Link: https://lkml.kernel.org/r/20251224173358.647691-4-mathieu.desnoyers@efficios.com
Fixes: af7f588d8f73 ("sched: Introduce per-memory-map concurrency ID")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions
+++ a/include/linux/mm_types.h
@@ -1368,7 +1368,7 @@ extern struct mm_struct init_mm;
 
 #define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
 {								\
-	[0 ... sizeof(cpumask_t)-1] = 0				\
+	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
 }
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
@@ -1500,7 +1500,7 @@ static inline int mm_alloc_cid_noprof(st
 	mm_init_cid(mm, p);
 	return 0;
 }
-#define mm_alloc_cid(...)	alloc_hooks(mm_alloc_cid_noprof(__VA_ARGS__))
+# define mm_alloc_cid(...)	alloc_hooks(mm_alloc_cid_noprof(__VA_ARGS__))
 
 static inline void mm_destroy_cid(struct mm_struct *mm)
 {
@@ -1514,6 +1514,8 @@ static inline unsigned int mm_cid_size(v
 	return cpumask_size() + bitmap_size(num_possible_cpus());
 }
 
+/* Use 2 * NR_CPUS as worse case for static allocation. */
+# define MM_CID_STATIC_SIZE	(2 * sizeof(cpumask_t))
 #else /* CONFIG_SCHED_MM_CID */
 static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p) { }
 static inline int mm_alloc_cid(struct mm_struct *mm, struct task_struct *p) { return 0; }
@@ -1522,6 +1524,7 @@ static inline unsigned int mm_cid_size(v
 {
 	return 0;
 }
+# define MM_CID_STATIC_SIZE	0
 #endif /* CONFIG_SCHED_MM_CID */
 
 struct mmu_gather;
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

tsacct-skip-all-kernel-threads.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch

