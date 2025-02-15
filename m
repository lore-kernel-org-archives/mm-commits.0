Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960074AEE0
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580149; cv=none; b=RtFVa6POIa8mGcEBxhfhR4S5bgUKUubOKyMawvvQFqdc9FzYP0+6p2tsv/+FkpRg4HyjRDRPMZoUzJYLLmSDqOPq4RQ3e5wMcfS3AtDKLEpjwoJFj7375JDBAQyiyKScvvBTGFOdyG/pF6fLOj/+eWbvPS+WyzxRGzqALGOP8Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580149; c=relaxed/simple;
	bh=JWbU+RLgTy4uMIUeGnaiEkwx1iAaPabvAm/hB4GL260=;
	h=Date:To:From:Subject:Message-Id; b=jCcQfGogkXdUMxkBPfawcPpp0GChJ3o9bblgPwkparUXcoWDMGmM1EncoriYty0UJF0Ollb6CWeTFabTZQpiSp/HwbOTCgB2Y+SlWk9nGSWaciRyFCWsnh420X0WSdIUCJll184AAhwtZz1A6CEEeScw2xC+lpp/CggVbbSctAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OEwCluzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OEwCluzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06674C4CED1;
	Sat, 15 Feb 2025 00:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739580149;
	bh=JWbU+RLgTy4uMIUeGnaiEkwx1iAaPabvAm/hB4GL260=;
	h=Date:To:From:Subject:From;
	b=OEwCluzzbCh+54OFz4Mrb9ap/tWdqsp4Py4fl2atZke54Otu9riq788F/EqxwfHM1
	 0/0Ei6bgVxTaFgqo85kTxdMM/igXDR+CS/v9ijko3ZHfMF6PWiiaEPqTgQaudVoeEL
	 McJgqXz/myvtrUMSWUmpLHb1WGCyT42+4eKdz2Jc=
Date: Fri, 14 Feb 2025 16:42:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch added to mm-unstable branch
Message-Id: <20250215004229.06674C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move lesser used vma_area_struct members into the last cacheline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: move lesser used vma_area_struct members into the last cacheline
Date: Thu, 13 Feb 2025 14:46:50 -0800

Move several vma_area_struct members which are rarely or never used during
page fault handling into the last cacheline to better pack vm_area_struct.
As a result vm_area_struct will fit into 3 as opposed to 4 cachelines. 
New typical vm_area_struct layout:

struct vm_area_struct {
    union {
        struct {
            long unsigned int vm_start;              /*     0     8 */
            long unsigned int vm_end;                /*     8     8 */
        };                                           /*     0    16 */
        freeptr_t          vm_freeptr;               /*     0     8 */
    };                                               /*     0    16 */
    struct mm_struct *         vm_mm;                /*    16     8 */
    pgprot_t                   vm_page_prot;         /*    24     8 */
    union {
        const vm_flags_t   vm_flags;                 /*    32     8 */
        vm_flags_t         __vm_flags;               /*    32     8 */
    };                                               /*    32     8 */
    unsigned int               vm_lock_seq;          /*    40     4 */

    /* XXX 4 bytes hole, try to pack */

    struct list_head           anon_vma_chain;       /*    48    16 */
    /* --- cacheline 1 boundary (64 bytes) --- */
    struct anon_vma *          anon_vma;             /*    64     8 */
    const struct vm_operations_struct  * vm_ops;     /*    72     8 */
    long unsigned int          vm_pgoff;             /*    80     8 */
    struct file *              vm_file;              /*    88     8 */
    void *                     vm_private_data;      /*    96     8 */
    atomic_long_t              swap_readahead_info;  /*   104     8 */
    struct mempolicy *         vm_policy;            /*   112     8 */
    struct vma_numab_state *   numab_state;          /*   120     8 */
    /* --- cacheline 2 boundary (128 bytes) --- */
    refcount_t          vm_refcnt (__aligned__(64)); /*   128     4 */

    /* XXX 4 bytes hole, try to pack */

    struct {
        struct rb_node     rb (__aligned__(8));      /*   136    24 */
        long unsigned int  rb_subtree_last;          /*   160     8 */
    } __attribute__((__aligned__(8))) shared;        /*   136    32 */
    struct anon_vma_name *     anon_name;            /*   168     8 */
    struct vm_userfaultfd_ctx  vm_userfaultfd_ctx;   /*   176     8 */

    /* size: 192, cachelines: 3, members: 18 */
    /* sum members: 176, holes: 2, sum holes: 8 */
    /* padding: 8 */
    /* forced alignments: 2, forced holes: 1, sum forced holes: 4 */
} __attribute__((__aligned__(64)));

Memory consumption per 1000 VMAs becomes 48 pages:

    slabinfo after vm_area_struct changes:
     <name>           ... <objsize> <objperslab> <pagesperslab> : ...
     vm_area_struct   ...    192   42    2 : ...

Link: https://lkml.kernel.org/r/20250213224655.1680278-14-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h         |   38 +++++++++++++----------------
 tools/testing/vma/vma_internal.h |   37 +++++++++++++---------------
 2 files changed, 36 insertions(+), 39 deletions(-)

--- a/include/linux/mm_types.h~mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline
+++ a/include/linux/mm_types.h
@@ -725,17 +725,6 @@ struct vm_area_struct {
 	 */
 	unsigned int vm_lock_seq;
 #endif
-
-	/*
-	 * For areas with an address space and backing store,
-	 * linkage into the address_space->i_mmap interval tree.
-	 *
-	 */
-	struct {
-		struct rb_node rb;
-		unsigned long rb_subtree_last;
-	} shared;
-
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
@@ -755,14 +744,6 @@ struct vm_area_struct {
 	struct file * vm_file;		/* File we map to (can be NULL). */
 	void * vm_private_data;		/* was vm_pte (shared mem) */
 
-#ifdef CONFIG_ANON_VMA_NAME
-	/*
-	 * For private and shared anonymous mappings, a pointer to a null
-	 * terminated string containing the name given to the vma, or NULL if
-	 * unnamed. Serialized by mmap_lock. Use anon_vma_name to access.
-	 */
-	struct anon_vma_name *anon_name;
-#endif
 #ifdef CONFIG_SWAP
 	atomic_long_t swap_readahead_info;
 #endif
@@ -775,7 +756,6 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
-	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 #ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt ____cacheline_aligned_in_smp;
@@ -783,6 +763,24 @@ struct vm_area_struct {
 	struct lockdep_map vmlock_dep_map;
 #endif
 #endif
+	/*
+	 * For areas with an address space and backing store,
+	 * linkage into the address_space->i_mmap interval tree.
+	 *
+	 */
+	struct {
+		struct rb_node rb;
+		unsigned long rb_subtree_last;
+	} shared;
+#ifdef CONFIG_ANON_VMA_NAME
+	/*
+	 * For private and shared anonymous mappings, a pointer to a null
+	 * terminated string containing the name given to the vma, or NULL if
+	 * unnamed. Serialized by mmap_lock. Use anon_vma_name to access.
+	 */
+	struct anon_vma_name *anon_name;
+#endif
+	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 } __randomize_layout;
 
 #ifdef CONFIG_NUMA
--- a/tools/testing/vma/vma_internal.h~mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline
+++ a/tools/testing/vma/vma_internal.h
@@ -280,16 +280,6 @@ struct vm_area_struct {
 #endif
 
 	/*
-	 * For areas with an address space and backing store,
-	 * linkage into the address_space->i_mmap interval tree.
-	 *
-	 */
-	struct {
-		struct rb_node rb;
-		unsigned long rb_subtree_last;
-	} shared;
-
-	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
 	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
 	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
@@ -308,14 +298,6 @@ struct vm_area_struct {
 	struct file * vm_file;		/* File we map to (can be NULL). */
 	void * vm_private_data;		/* was vm_pte (shared mem) */
 
-#ifdef CONFIG_ANON_VMA_NAME
-	/*
-	 * For private and shared anonymous mappings, a pointer to a null
-	 * terminated string containing the name given to the vma, or NULL if
-	 * unnamed. Serialized by mmap_lock. Use anon_vma_name to access.
-	 */
-	struct anon_vma_name *anon_name;
-#endif
 #ifdef CONFIG_SWAP
 	atomic_long_t swap_readahead_info;
 #endif
@@ -328,11 +310,28 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA_BALANCING
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
-	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 #ifdef CONFIG_PER_VMA_LOCK
 	/* Unstable RCU readers are allowed to read this. */
 	refcount_t vm_refcnt;
 #endif
+	/*
+	 * For areas with an address space and backing store,
+	 * linkage into the address_space->i_mmap interval tree.
+	 *
+	 */
+	struct {
+		struct rb_node rb;
+		unsigned long rb_subtree_last;
+	} shared;
+#ifdef CONFIG_ANON_VMA_NAME
+	/*
+	 * For private and shared anonymous mappings, a pointer to a null
+	 * terminated string containing the name given to the vma, or NULL if
+	 * unnamed. Serialized by mmap_lock. Use anon_vma_name to access.
+	 */
+	struct anon_vma_name *anon_name;
+#endif
+	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 } __randomize_layout;
 
 struct vm_fault {};
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch
mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch
refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

