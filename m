Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E026EB7D
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580141; cv=none; b=WTfcNbQtVhE+Qu8GTiW5M3ODiCeql2IyJV2h/g/er/4PysOVUwbrMwktvJmWBR5yfIPzRNa19+1wtIDFFvooCk84hvJivDc9S3RyZdOlxegjnfQw+93pTEBnDJFESsGjRE6upqO6h9VAkuyOGJJip4sR959MzqzYFGBni+N/+TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580141; c=relaxed/simple;
	bh=O7V8lcjkKwUNH/nRhsBrkhgM9NQQdtKyl6OH6iecJnc=;
	h=Date:To:From:Subject:Message-Id; b=AVTs87p/pQf8pv9f7Gk7FV0GbqQOp0WncuD4wegD2DwuKwz5cbzh81y9HinRkNKhTuGe1eAciG4MvPbAxN4F2FhiuPBzZ2059hWJj2T5yC4gZnIrlTKZsX96KiJGWqAam5rUW40K0TlddiYWHhjiHldUpa+1SF+LISNMO1SAMfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yo4GVF+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yo4GVF+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81563C4CED1;
	Sat, 15 Feb 2025 00:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739580140;
	bh=O7V8lcjkKwUNH/nRhsBrkhgM9NQQdtKyl6OH6iecJnc=;
	h=Date:To:From:Subject:From;
	b=yo4GVF+SczRLFRpNcHA8sxhXPL6aN2LXWbTtyYnUlS5C/UGhttBfyePpkntcWHIIq
	 jO39twaMhFWs1B8CpxDv7zw9O7DXvI9UN7xC2MksIkCbSyvoi7vbxriqClWQt2WiCi
	 Ys0InYG7TKTnryfNASM4sWQVKKwIvSIAvNpX9SNE=
Date: Fri, 14 Feb 2025 16:42:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-mmap_init_lock-out-of-the-header-file.patch added to mm-unstable branch
Message-Id: <20250215004220.81563C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move mmap_init_lock() out of the header file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-mmap_init_lock-out-of-the-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-mmap_init_lock-out-of-the-header-file.patch

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
Subject: mm: move mmap_init_lock() out of the header file
Date: Thu, 13 Feb 2025 14:46:45 -0800

mmap_init_lock() is used only from mm_init() in fork.c, therefore it does
not have to reside in the header file.  This move lets us avoid including
additional headers in mmap_lock.h later, when mmap_init_lock() needs to
initialize rcuwait object.

Link: https://lkml.kernel.org/r/20250213224655.1680278-9-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    6 ------
 kernel/fork.c             |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mm-move-mmap_init_lock-out-of-the-header-file
+++ a/include/linux/mmap_lock.h
@@ -122,12 +122,6 @@ static inline bool mmap_lock_speculate_r
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
-static inline void mmap_init_lock(struct mm_struct *mm)
-{
-	init_rwsem(&mm->mmap_lock);
-	mm_lock_seqcount_init(mm);
-}
-
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
--- a/kernel/fork.c~mm-move-mmap_init_lock-out-of-the-header-file
+++ a/kernel/fork.c
@@ -1230,6 +1230,12 @@ static void mm_init_uprobes_state(struct
 #endif
 }
 
+static void mmap_init_lock(struct mm_struct *mm)
+{
+	init_rwsem(&mm->mmap_lock);
+	mm_lock_seqcount_init(mm);
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
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

