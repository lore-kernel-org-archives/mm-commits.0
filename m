Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B1523FC54;
	Mon, 19 Jan 2026 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854643; cv=none; b=JXKdxSXk0oeUKEKfcuzmR7A4l1YSTFeY2NDiXoRYLHKk/LJ4Bi9eUlQTYrDDPn1VkVHq339TZ5ewHxlMFr1OCyr1AyE1xQSljMma1nUPFE32k0p7QtFKjBC214dSqL+i6K/MwxoY0fx2kDAeaKUj3m6uh9SwVA0/36/LxhXc5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854643; c=relaxed/simple;
	bh=J1Oa+Ynm5jTytbZ44fKIkXKPM9MNR6gNetNMbjr5FiI=;
	h=Date:To:From:Subject:Message-Id; b=oJyaiFDqwGL4Qc3HgmazJV5cxf0vK9SYCRrIAQbitEOFa56Ev6+gNfKTKIvB5jtjCe+ORfeEvzgTtOXXQfW9iQ06NfwoODncjY13/DTlMWfFo9a5W22EjQm5zF93g2Q936NMjazKJ9XRt8XnLIF1RkJV7VPHTHZl6a/LrAoxZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIyso9ik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIyso9ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4C1C116C6;
	Mon, 19 Jan 2026 20:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854643;
	bh=J1Oa+Ynm5jTytbZ44fKIkXKPM9MNR6gNetNMbjr5FiI=;
	h=Date:To:From:Subject:From;
	b=cIyso9ik2gYMHClV2+wzXLCylxI+lm6kL6ACFxXOEYO2sGgTMewok79W2mKtvNhOx
	 f8anVxRztl8jmseLdepxVd7Nc7/aYmClsV5GZpACleUI146tRHSt4mJEMvkKTXjk6B
	 MlhbUw2NHtGOYA59hsAdxUVDWWwMEsxivZMg322I=
Date: Mon, 19 Jan 2026 12:30:42 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@kernel.org,sweettea-kernel@dorminy.me,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rename-cpu_bitmap-field-to-flexible_array.patch removed from -mm tree
Message-Id: <20260119203043.4F4C1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename cpu_bitmap field to flexible_array
has been removed from the -mm tree.  Its filename was
     mm-rename-cpu_bitmap-field-to-flexible_array.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: rename cpu_bitmap field to flexible_array
Date: Wed, 24 Dec 2025 12:33:57 -0500

The cpu_bitmap flexible array now contains more than just the cpu_bitmap. 
In preparation for changing the static mm_struct definitions to cover for
the additional space required, change the cpu_bitmap type from "unsigned
long" to "char", require an unsigned long alignment of the flexible array,
and rename the field from "cpu_bitmap" to "flexible_array".

Introduce the MM_STRUCT_FLEXIBLE_ARRAY_INIT macro to statically initialize
the flexible array.  This covers the init_mm and efi_mm static
definitions.

This is a preparation step for fixing the missing mm_cid size for static
mm_struct definitions.

Link: https://lkml.kernel.org/r/20251224173358.647691-3-mathieu.desnoyers@efficios.com
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

 drivers/firmware/efi/efi.c |    2 +-
 include/linux/mm_types.h   |   13 +++++++++----
 mm/init-mm.c               |    2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/firmware/efi/efi.c~mm-rename-cpu_bitmap-field-to-flexible_array
+++ a/drivers/firmware/efi/efi.c
@@ -74,10 +74,10 @@ struct mm_struct efi_mm = {
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 	.user_ns		= &init_user_ns,
-	.cpu_bitmap		= { [BITS_TO_LONGS(NR_CPUS)] = 0},
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock		= __RAW_SPIN_LOCK_UNLOCKED(efi_mm.mm_cid.lock),
 #endif
+	.flexible_array		= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 };
 
 struct workqueue_struct *efi_rts_wq;
--- a/include/linux/mm_types.h~mm-rename-cpu_bitmap-field-to-flexible_array
+++ a/include/linux/mm_types.h
@@ -1329,7 +1329,7 @@ struct mm_struct {
 	 * The mm_cpumask needs to be at the end of mm_struct, because it
 	 * is dynamically sized based on nr_cpu_ids.
 	 */
-	unsigned long cpu_bitmap[];
+	char flexible_array[] __aligned(__alignof__(unsigned long));
 };
 
 /* Copy value to the first system word of mm flags, non-atomically. */
@@ -1366,19 +1366,24 @@ static inline void __mm_flags_set_mask_b
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
+{								\
+	[0 ... sizeof(cpumask_t)-1] = 0				\
+}
+
 /* Pointer magic because the dynamic array size confuses some compilers. */
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 	unsigned long cpu_bitmap = (unsigned long)mm;
 
-	cpu_bitmap += offsetof(struct mm_struct, cpu_bitmap);
+	cpu_bitmap += offsetof(struct mm_struct, flexible_array);
 	cpumask_clear((struct cpumask *)cpu_bitmap);
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
-	return (struct cpumask *)&mm->cpu_bitmap;
+	return (struct cpumask *)&mm->flexible_array;
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -1469,7 +1474,7 @@ static inline cpumask_t *mm_cpus_allowed
 {
 	unsigned long bitmap = (unsigned long)mm;
 
-	bitmap += offsetof(struct mm_struct, cpu_bitmap);
+	bitmap += offsetof(struct mm_struct, flexible_array);
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
--- a/mm/init-mm.c~mm-rename-cpu_bitmap-field-to-flexible_array
+++ a/mm/init-mm.c
@@ -47,7 +47,7 @@ struct mm_struct init_mm = {
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
 #endif
-	.cpu_bitmap	= CPU_BITS_NONE,
+	.flexible_array	= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 	INIT_MM_CONTEXT(init_mm)
 };
 
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

tsacct-skip-all-kernel-threads.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch

