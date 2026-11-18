Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794964023;
	b=HkVL6SWsj+mzvgxpNgAw0IiW7Fy/0Rhj86jjwzFQa6PUFlWnUfc5BQMePTiqnIRHDnXQ
	 +QCpCb/INH5fDEZ5W4WMBvZVIv6nyyTV7TYSO5kd5PUh7SddK2MDY6geTSHeLeLdB/PWf
	 gr1cLncF7PlLOsKyQdRdewCckNfir9BTNM/W9gjexZ64fWYdXVIn2jSUak7AXOEeCFO/v
	 J+fy/tvZ4rUhULFA7wAMFRWY+MgfgMQ6FlqStSOiaODUjZfv7IW/MdwXVsuXi+Rzys/yQ
	 dtYBc9r3Ijrx4qSiWVFiTG9dfD9jDWCnhQD/H+JJ864qXXrIX5lgbk1GeW2DOOGJF4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794964023;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zQj0XyPzWkHBbC2Xz4mwvUaVvjf+WEp4UkWLajwFjaM=;
	b=OEaYJyBJIpIH7c86d8/LAxaZxVl9nLZjyUcWI1p6z/TxKCV4zqGiSWvudB5u4285S+5F
	 88eeibLgx3TKSKOqxrQlv8W0r/J2cFu3Tl9Sj8sm8fHy2FRO8omWjPCBqoHpUdcQlNSC/
	 cDYTpUDQMhLZ+93yxYrpXOn5cjKVdKZbAGDbYKRnVhD0K9c9YmYQCtrp9Evc5/HKn6gai
	 xoI11fXWBn/P9L51srYxZlnhn7zsQOQxSvs5ZsPcXU0cJpqeXS9euRU0iBb6ZSm0a59y8
	 pR3pNqIUiIg6iT9MXZBLglYYBnaZ2o40YGa/r6XXupd+xstunCjwe3SGDYqPQAB7oIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sdLWMaJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C686B606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 01:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sdLWMaJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD46A1F000C4;
	Wed, 18 Nov 2026 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794964023;
	bh=zQj0XyPzWkHBbC2Xz4mwvUaVvjf+WEp4UkWLajwFjaM=;
	h=Date:To:From:Subject;
	b=sdLWMaJq3W0CnB9yPPBiG58fbKdl7A2nUTFrZbzUsUD/FQMIG37bJPM8Fr7canEPs
	 TTf64wK8mTq+1XWBxVC4KfWYNMHlQf+erW5YqNJ91XxH6vcijC7Bo9r2NIb3QwWtWy
	 2LTTG/wIVwCxXbuV4bLuKEmorLGgDfOAzJD99STY=
Date: Tue, 17 Nov 2026 17:07:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,skhan@linuxfoundation.org,
	ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,
	rdunlap@infradead.org,pfalcato@suse.de,peterx@redhat.com,
	nico.pache@linux.dev,mhocko@suse.com,mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,jannh@google.com,dev.jain@arm.com,
	corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-prevent-poison-marker-loss.patch added to mm-new branch
Message-Id: <20261118010702.CD46A1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/userfaultfd: prevent poison marker loss
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-prevent-poison-marker-loss.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-prevent-poison-marker-loss.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/userfaultfd: prevent poison marker loss
Date: Mon, 16 Nov 2026 16:17:17 +0100

Unregistering userfaultfd leaves poison markers in the page tables.
However, once unregistered, hugetlb PMD tables can be shared again.

Further, shmem page-table retraction can discard poison markers even
while registered in missing mode, and fork() can skip copying page
tables containing poison markers.

To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
markers. Preserve it across unregistration, splits, merges and fork(),
just like we do with guard markers.

Use the new atomic VMA flag to disable PMD sharing and page-table
retraction, and to force page-table copying during fork().

Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
Expose the flag as "up" in smaps.

Losing poison markers, while unpleasant, is not really fatal, and the
use case is rather a niche thing. In addition, we rely on the atomic
VMA flags infrastructure ... so let's not CC stable.

Link: https://lore.kernel.org/20261116-b4-uffd_marker_loss-v2-1-0fe9c5d1b43a@kernel.org
Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>

 Documentation/filesystems/proc.rst |    1 
 fs/proc/task_mmu.c                 |    3 ++
 include/linux/mm.h                 |   40 ++++++++++++++++-----------
 include/linux/userfaultfd_k.h      |    9 ++++--
 include/trace/events/mmflags.h     |    9 +++++-
 mm/Kconfig                         |    1 
 mm/khugepaged.c                    |    9 +++---
 mm/userfaultfd.c                   |    3 ++
 tools/testing/vma/include/dup.h    |   20 ++++++++++---
 9 files changed, 67 insertions(+), 28 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-userfaultfd-prevent-poison-marker-loss
+++ a/Documentation/filesystems/proc.rst
@@ -614,6 +614,7 @@ encoded manner. The codes are the follow
     lf    lock on fault pages
     dp    always lazily freeable mapping
     gu    maybe contains guard regions (if not set, definitely doesn't)
+    up    maybe contains poison markers installed by userfaultfd
     ==    =============================================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
--- a/fs/proc/task_mmu.c~mm-userfaultfd-prevent-poison-marker-loss
+++ a/fs/proc/task_mmu.c
@@ -1111,6 +1111,7 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
 		[ilog2(VM_MAYBE_GUARD)]	= "gu",
+		[ilog2(VM_MAYBE_UFFD_POISON)]	= "up",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
@@ -1136,7 +1137,9 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_NOHUGEPAGE)]	= "nh",
 		[ilog2(VM_MERGEABLE)]	= "mg",
 		[ilog2(VM_UFFD_MISSING)]= "um",
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 		[ilog2(VM_UFFD_WP)]	= "uw",
+#endif
 #ifdef CONFIG_ARM64_MTE
 		[ilog2(VM_MTE)]		= "mt",
 		[ilog2(VM_MTE_ALLOWED)]	= "",
--- a/include/linux/mm.h~mm-userfaultfd-prevent-poison-marker-loss
+++ a/include/linux/mm.h
@@ -301,7 +301,7 @@ enum {
 	/* Page-ranges managed without "struct page", just pure PFN */
 	DECLARE_VMA_BIT(PFNMAP, 10),
 	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
-	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
+	DECLARE_VMA_BIT(MAYBE_UFFD_POISON, 12),
 	DECLARE_VMA_BIT(LOCKED, 13),
 	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
 	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
@@ -345,6 +345,7 @@ enum {
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
 	DECLARE_VMA_BIT(UFFD_RWP, 43),
+	DECLARE_VMA_BIT(UFFD_WP, 44),	/* wrprotect pages tracking */
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -405,7 +406,14 @@ enum {
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
+#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
+#define VMA_UFFD_WP	mk_vma_flags(VMA_UFFD_WP_BIT)
+#else
+#define VM_UFFD_WP	VM_NONE
+#define VMA_UFFD_WP	EMPTY_VMA_FLAGS
+#endif
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -507,7 +515,6 @@ enum {
  * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
-#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 #define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
 #else
@@ -601,7 +608,8 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+					    VMA_MAYBE_UFFD_POISON_BIT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
@@ -619,16 +627,16 @@ enum {
  *                       merged VMA should be considered soft-dirty also as it
  *                       operates at a VMA granularity.
  *
- * VMA_MAYBE_GUARD_BIT - If a VMA may have guard regions in place it implies
- *                       that mapped page tables may contain metadata not
- *                       described by the VMA and thus any merged VMA may also
- *                       contain this metadata, and thus we must make this flag
- *                       sticky.
+ * VMA_MAYBE_GUARD_BIT / VMA_MAYBE_UFFD_POISON_BIT - Page tables may contain guard
+ *                       or poison markers not described by the VMA. Any
+ *                       merged VMA may also contain this metadata, so these
+ *                       flags must be sticky.
  */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT, \
+				     VMA_MAYBE_UFFD_POISON_BIT)
 #else
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT, VMA_MAYBE_UFFD_POISON_BIT)
 #endif
 
 /*
@@ -666,13 +674,15 @@ enum {
  *                           retrieve from page cache, and skip copying
  *                           will lose those info.
  *
- *          VM_MAYBE_GUARD - Could contain page guard region markers which
- *                           by design are a property of the page tables
- *                           only and thus cannot be reconstructed on page
- *                           fault.
+ *          VM_MAYBE_GUARD - Could contain guard markers which cannot be
+ *                           reconstructed on page fault.
+ *
+ *   VM_MAYBE_UFFD_POISON - Could contain poison markers which cannot be
+ *                           reconstructed on page fault, including after
+ *                           userfaultfd unregister.
  */
 #define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
-			 VM_MAYBE_GUARD)
+			 VM_MAYBE_GUARD | VM_MAYBE_UFFD_POISON)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
--- a/include/linux/userfaultfd_k.h~mm-userfaultfd-prevent-poison-marker-loss
+++ a/include/linux/userfaultfd_k.h
@@ -167,11 +167,14 @@ static inline bool is_mergeable_vm_userf
 
 /*
  * Never enable huge pmd sharing on userfaultfd registered VMAs, because
- * userfaultfd state can be tracked per VMA or per page table entry.
+ * userfaultfd state can be tracked per VMA or per page table entry. Similarly,
+ * handle poison markers that stick around even after userfaultfd was
+ * unregistered.
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_userfaultfd_ctx.ctx;
+	return vma->vm_userfaultfd_ctx.ctx ||
+	       vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT);
 }
 
 /*
@@ -198,7 +201,7 @@ static inline bool userfaultfd_missing(s
 
 static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma, VMA_UFFD_WP);
+	return vma_test_single_mask(vma, VMA_UFFD_WP);
 }
 
 static inline bool userfaultfd_minor(struct vm_area_struct *vma)
--- a/include/trace/events/mmflags.h~mm-userfaultfd-prevent-poison-marker-loss
+++ a/include/trace/events/mmflags.h
@@ -184,6 +184,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define IF_HAVE_VM_SOFTDIRTY(flag,name)
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+# define IF_HAVE_UFFD_WP(flag, name) {flag, name},
+#else
+# define IF_HAVE_UFFD_WP(flag, name)
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 # define IF_HAVE_UFFD_MINOR(flag, name) {flag, name},
 #else
@@ -247,7 +253,8 @@ IF_HAVE_PG_ARCH_3(arch_3)
 IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
-	{VM_UFFD_WP,			"uffd_wp"	},		\
+	{VM_MAYBE_UFFD_POISON,		"maybe_uffd_poison"	},		\
+IF_HAVE_UFFD_WP(VM_UFFD_WP,		"uffd_wp")			\
 IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
--- a/mm/Kconfig~mm-userfaultfd-prevent-poison-marker-loss
+++ a/mm/Kconfig
@@ -1348,6 +1348,7 @@ config ANON_VMA_NAME
 
 config HAVE_ARCH_USERFAULTFD_WP
 	bool
+	depends on 64BIT
 	help
 	  Arch has userfaultfd write protection support
 
--- a/mm/khugepaged.c~mm-userfaultfd-prevent-poison-marker-loss
+++ a/mm/khugepaged.c
@@ -2103,16 +2103,17 @@ static bool file_backed_vma_is_retractab
 		return false;
 
 	/*
-	 * If the VMA contains guard regions then we can't collapse it.
+	 * Preserve guard and poison markers when retracting page tables.
 	 *
-	 * This is set atomically on guard marker installation under mmap/VMA
+	 * These flags are set atomically on marker installation under mmap/VMA
 	 * read lock, and here we may not hold any VMA or mmap lock at all.
 	 *
 	 * This is therefore serialised on the PTE page table lock, which is
-	 * obtained on guard region installation after the flag is set, so this
+	 * obtained on marker installation after the flag is set, so this
 	 * check being performed under this lock excludes races.
 	 */
-	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
+	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT) ||
+	    vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT))
 		return false;
 
 	return true;
--- a/mm/userfaultfd.c~mm-userfaultfd-prevent-poison-marker-loss
+++ a/mm/userfaultfd.c
@@ -967,6 +967,9 @@ static __always_inline ssize_t mfill_ato
 	if (err)
 		goto out;
 
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
+		vma_set_atomic_flag(state.vma, VMA_MAYBE_UFFD_POISON_BIT);
+
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
--- a/tools/testing/vma/include/dup.h~mm-userfaultfd-prevent-poison-marker-loss
+++ a/tools/testing/vma/include/dup.h
@@ -117,7 +117,7 @@ enum {
 	/* Page-ranges managed without "struct page", just pure PFN */
 	DECLARE_VMA_BIT(PFNMAP, 10),
 	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
-	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
+	DECLARE_VMA_BIT(MAYBE_UFFD_POISON, 12),
 	DECLARE_VMA_BIT(LOCKED, 13),
 	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
 	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
@@ -160,6 +160,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_WP, 44),	/* wrprotect pages tracking */
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -218,7 +219,12 @@ enum {
 #endif
 #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
 #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
+#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
+#else
+#define VM_UFFD_WP	VM_NONE
+#endif
 #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
 #define VM_IO		INIT_VM_FLAG(IO)
 #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
@@ -367,7 +373,8 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+					    VMA_MAYBE_UFFD_POISON_BIT)
 
 #define RLIMIT_STACK		3	/* max stack size */
 #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
@@ -375,14 +382,17 @@ enum {
 #define CAP_IPC_LOCK         14
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT, \
+				      VMA_MAYBE_UFFD_POISON_BIT)
 #else
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
+				      VMA_MAYBE_UFFD_POISON_BIT)
 #endif
 
 #define VMA_IGNORE_MERGE_FLAGS VMA_STICKY_FLAGS
 
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | \
+			 VM_MAYBE_GUARD | VM_MAYBE_UFFD_POISON)
 
 #define pgprot_val(x)		((x).pgprot)
 #define __pgprot(x)		((pgprot_t) { (x) } )
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
hugetlbfs-fix-integer-overflow-in-fallocate.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-fix-mremap-racing-with-page-migration.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch
mm-userfaultfd-prevent-poison-marker-loss.patch

