Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22569221DB9
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766455288; cv=none; b=oNrYgcW2abKcT8cWEIMpOhhxMrHMrA/DiO3BBz0e4WclQd5C+HfIvmFaInKfNNVHFew93vV85RU9CUETGsezK5p4HRmMb2AQNiPzw+BMA3AP7lFW82bc4UNTqH8n27MJFwaZvDVsRuWzrI+EIvjx8Obibt8mpyZh2Amcrhor9GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766455288; c=relaxed/simple;
	bh=bP7VlTvUks30bojgVJZheHvR/+EHzZvY/r8qZrLY6Ss=;
	h=Date:To:From:Subject:Message-Id; b=gt5Z2Ulgkp7BzbeWyUN/Ihii+v24kHlRHOwggOtjJszpls/Fz1xXBdj9FYupdxpcic5A9hUoXrkFtcypsxPG8D5u6vcKIhWrmr2XYHM2h4l6vDcD8bORI+Z5LcfMiTbaqFKomxRqPPHZtNHXjYTrCqETFblTr4tWWhX1/OjEL5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wu4Fl6+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wu4Fl6+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995FAC4CEF1;
	Tue, 23 Dec 2025 02:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455287;
	bh=bP7VlTvUks30bojgVJZheHvR/+EHzZvY/r8qZrLY6Ss=;
	h=Date:To:From:Subject:From;
	b=Wu4Fl6+kqRRR9FuUa8kJTFdnNxUDv29E3dGoujbX9z5FYNF9zpmnCjIDc38lZzuFr
	 GBdJj7sHpl3uZ8afk0cvBNPbCcgQ5aJ6h7exiaijb3ElIV7z7/becz6rKmAT0Wcrby
	 zs9wThWBu/Nla1mF9Tswyz96ZlJbqMuhaByM27Yo=
Date: Mon, 22 Dec 2025 18:01:27 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,broonie@kernel.org,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-cpu_bitmap-field-to-flexible_array.patch added to mm-new branch
Message-Id: <20251223020127.995FAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename cpu_bitmap field to flexible_array
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-cpu_bitmap-field-to-flexible_array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-cpu_bitmap-field-to-flexible_array.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: rename cpu_bitmap field to flexible_array
Date: Sun, 21 Dec 2025 18:29:23 -0500

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

Link: https://lkml.kernel.org/r/20251221232926.450602-3-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/efi.c |    2 +-
 include/linux/mm.h         |    2 +-
 include/linux/mm_types.h   |   13 +++++++++----
 mm/init-mm.c               |    2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/firmware/efi/efi.c~mm-rename-cpu_bitmap-field-to-flexible_array
+++ a/drivers/firmware/efi/efi.c
@@ -73,10 +73,10 @@ struct mm_struct efi_mm = {
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
-	.cpu_bitmap		= { [BITS_TO_LONGS(NR_CPUS)] = 0},
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock		= __RAW_SPIN_LOCK_UNLOCKED(efi_mm.mm_cid.lock),
 #endif
+	.flexible_array		= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 };
 
 struct workqueue_struct *efi_rts_wq;
--- a/include/linux/mm.h~mm-rename-cpu_bitmap-field-to-flexible_array
+++ a/include/linux/mm.h
@@ -2853,7 +2853,7 @@ static inline struct percpu_counter_tree
 {
 	unsigned long ptr = (unsigned long)mm;
 
-	ptr += offsetof(struct mm_struct, cpu_bitmap);
+	ptr += offsetof(struct mm_struct, flexible_array);
 	/* Skip cpu_bitmap */
 	ptr += cpumask_size();
 	/* Skip mm_cidmask */
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

lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch
mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch
tsacct-skip-all-kernel-threads.patch

