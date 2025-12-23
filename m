Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754A5202C48;
	Tue, 23 Dec 2025 02:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766455291; cv=none; b=lP5Bx9r+Iphd6bHTig85Srjn8j9BH5gVwHK7S1qWJZqb8WK7SCAvu14uWsKSbDE4j1w2DSvOFsvxS7s385aNdNlIzyzVSl1vNemm7/EAvvOMic08WsrE9RX1xvfsy4poYE1aabR0IgZF6GqRLweSn359iyMceEYZPJ/Oam1kZz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766455291; c=relaxed/simple;
	bh=+kRSPTURYiA3TPBCEdUP1R47TaZ/HlTx8LIdT8o7Mdk=;
	h=Date:To:From:Subject:Message-Id; b=D3qyBVL0PKoYP1QxTCRxc3jODDFy3Dlep5lmD+mUQTt+itlnkYvSd299uJDXB2Dk6bWly3jwSUNcq6GeWQbQVIg0FUJVdwKhFChmHoj4LSX38NIfFrCz1vzh2aqp6BsfTO7HfzGQNDVODkbDgEfBKrOmTw4VVVvJXVhF8zSIAjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4LoHTkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4LoHTkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB50C4CEF1;
	Tue, 23 Dec 2025 02:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455291;
	bh=+kRSPTURYiA3TPBCEdUP1R47TaZ/HlTx8LIdT8o7Mdk=;
	h=Date:To:From:Subject:From;
	b=N4LoHTkX4DXq6bAKiVkYYGvRWHhp2G+4Gl+WL+35MjxaD9ffCqWKP07OWLTVC1R/3
	 /XLhViFyR0qZH/FrjEjnKTEIDqaaFLHhPZ8OPGLj0AUm/hl1CKn5dGll2l0X95IWQ8
	 3LFjsWSsuN7OEwBBWnwveN3Sspvvwfa5jOZxtDms=
Date: Mon, 22 Dec 2025 18:01:30 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,broonie@kernel.org,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch added to mm-new branch
Message-Id: <20251223020130.ECB50C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: take into account mm_cid size for mm_struct static definitions
has been added to the -mm mm-new branch.  Its filename is
     mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch

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
Subject: mm: take into account mm_cid size for mm_struct static definitions
Date: Sun, 21 Dec 2025 18:29:24 -0500

Both init_mm and efi_mm static definitions need to make room for the
2 mm_cid cpumasks.

This fixes possible out-of-bounds accesses to init_mm and efi_mm.

Link: https://lkml.kernel.org/r/20251221232926.450602-4-mathieu.desnoyers@efficios.com
Fixes: af7f588d8f73 ("sched: Introduce per-memory-map concurrency ID")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@kernel.org>
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
 
+/* Use NR_CPUS as worse case for static allocation. */
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

lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch
mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch
tsacct-skip-all-kernel-threads.patch

