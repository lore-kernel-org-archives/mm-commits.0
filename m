Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E995D215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188330; cv=none; b=W+7iUKVaru+ytoafXNzYyo9+KT0CmEJj56z6cEh/7sSeNMS57BobPb6wzJL+BrKtsv1++Zl2qtBS/2pz/aofoBWTvJ/iWo9+jnqOtDgAhJUEDk6VF1UU37H3DQMCx89xUzLXOipFbt8/ha8i28rt3JmWCklSIAns6Fb4vpEjiYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188330; c=relaxed/simple;
	bh=Qngz/1RCGR9NKvfs+u38miLRWKV2ZNAEwkzBFYG4QZQ=;
	h=Date:To:From:Subject:Message-Id; b=G67Qc++UyNZu+d4IIeXM1WViDytnsecDDOKo91L3KsQqQKwJCqQOUK9GyGgQrEurHhChqqafoM7vHRLpMhi3Z89TD4JPL3bdRuIFB/yJZhGKdj5BcHuCII4hERfx/K56uzldvcy1T2rUpA9tYqjvX8v2DRtWltRFaVb2/Zz+BKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4qrsQQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4qrsQQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B5DC4CEEC;
	Mon, 17 Mar 2025 05:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188329;
	bh=Qngz/1RCGR9NKvfs+u38miLRWKV2ZNAEwkzBFYG4QZQ=;
	h=Date:To:From:Subject:From;
	b=V4qrsQQfruAqwnZlaZ6VbtoTwW+kKMOlbejjOnngtuFZSNoHRPxq33m6AFGhOycTF
	 fLyJGUklxkGsXM2cCmnB4cFWuVYcUjBfIpCjSA0uvVidtHbAHRN7HPsXgqft2N+6Kw
	 Ld5DZnJNZEPpG1xS1YaII8U9j+jCsy6bGtE3sBik=
Date: Sun, 16 Mar 2025 22:12:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch removed from -mm tree
Message-Id: <20250317051209.B5B5DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move lesser used vma_area_struct members into the last cacheline
has been removed from the -mm tree.  Its filename was
     mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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


