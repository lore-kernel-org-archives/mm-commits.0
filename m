Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B393219FF
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736660786; cv=none; b=e0Cl+tUjjGUtvOakPH/eNNqcmtdSmvbw81rbfWv3v/f0Am56O5+RmSy+4bk+G6/HzPNwJLP8ynpBvqJ4rqlzY6oqSAsvLGiMjgTDisr/K31vfHpjF2Lz1JB5hz/Xk9gHb/zDzAIJ0unRXxl4otRfvr+0Z/4CDdlNJ/89qd6wOaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736660786; c=relaxed/simple;
	bh=9nLpqe10X8EShSmSP8RnseMsnrlmbxZaZ0sVKt2qiDo=;
	h=Date:To:From:Subject:Message-Id; b=lNZL7dF/sslKn5ujSZ27y3/GcKfDWzknXVnNcwnA2gfcvDEgaYd+pPExakzsQnQ2Timkchi08ssoMnvOapF5EQWmsxy2+vrSNHRgv7PxxjqrYb/I9zUuvKkSrufa+3B+F5fqKWJJKPPZZ8OGGm3QlwsHHy0RGfUED0RnYy4rm5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nWBlR//h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWBlR//h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6C1C4CEE0;
	Sun, 12 Jan 2025 05:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736660785;
	bh=9nLpqe10X8EShSmSP8RnseMsnrlmbxZaZ0sVKt2qiDo=;
	h=Date:To:From:Subject:From;
	b=nWBlR//h62gbe450TiaaHDYWbrfCR5DZK51CWaeD10Glgh40BMaek4/QJoDhVdDwx
	 AoS3CfmZfDx6/DJu+d4TgqVsz9Gzk5KjQI4JnTP/Ou1Pf+zr+D3YdhRmqZXYe3SOyV
	 Q85GaRgmNLOxtV8qvu4cH4g1NAwzaWPXrXRYyETw=
Date: Sat, 11 Jan 2025 21:46:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch added to mm-unstable branch
Message-Id: <20250112054625.CA6C1C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce vma_iter_store_attached() to use with attached vmas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch

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
Subject: mm: introduce vma_iter_store_attached() to use with attached vmas
Date: Fri, 10 Jan 2025 20:25:51 -0800

vma_iter_store() functions can be used both when adding a new vma and when
updating an existing one.  However for existing ones we do not need to
mark them attached as they are already marked that way.  Introduce
vma_iter_store_attached() to be used with already attached vmas.

Link: https://lkml.kernel.org/r/20250111042604.3230628-5-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mattew Wilcox <willy@infradead.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++++++++
 mm/vma.c           |    8 ++++----
 mm/vma.h           |   11 +++++++++--
 3 files changed, 25 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/include/linux/mm.h
@@ -821,6 +821,16 @@ static inline void vma_assert_locked(str
 		vma_assert_write_locked(vma);
 }
 
+static inline void vma_assert_attached(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(vma->detached, vma);
+}
+
+static inline void vma_assert_detached(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma->detached, vma);
+}
+
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
 	vma->detached = false;
@@ -866,6 +876,8 @@ static inline void vma_end_read(struct v
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline void vma_assert_attached(struct vm_area_struct *vma) {}
+static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
 static inline void vma_mark_detached(struct vm_area_struct *vma) {}
 
--- a/mm/vma.c~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/mm/vma.c
@@ -660,14 +660,14 @@ static int commit_merge(struct vma_merge
 	vma_set_range(vmg->vma, vmg->start, vmg->end, vmg->pgoff);
 
 	if (expanded)
-		vma_iter_store(vmg->vmi, vmg->vma);
+		vma_iter_store_attached(vmg->vmi, vmg->vma);
 
 	if (adj_start) {
 		adjust->vm_start += adj_start;
 		adjust->vm_pgoff += PHYS_PFN(adj_start);
 		if (adj_start < 0) {
 			WARN_ON(expanded);
-			vma_iter_store(vmg->vmi, adjust);
+			vma_iter_store_attached(vmg->vmi, adjust);
 		}
 	}
 
@@ -2785,7 +2785,7 @@ int expand_upwards(struct vm_area_struct
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
+				vma_iter_store_attached(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
@@ -2865,7 +2865,7 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
-				vma_iter_store(&vmi, vma);
+				vma_iter_store_attached(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
--- a/mm/vma.h~mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas
+++ a/mm/vma.h
@@ -365,9 +365,10 @@ static inline struct vm_area_struct *vma
 }
 
 /* Store a VMA with preallocated memory */
-static inline void vma_iter_store(struct vma_iterator *vmi,
-				  struct vm_area_struct *vma)
+static inline void vma_iter_store_attached(struct vma_iterator *vmi,
+					   struct vm_area_struct *vma)
 {
+	vma_assert_attached(vma);
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	if (MAS_WARN_ON(&vmi->mas, vmi->mas.status != ma_start &&
@@ -390,7 +391,13 @@ static inline void vma_iter_store(struct
 
 	__mas_set_range(&vmi->mas, vma->vm_start, vma->vm_end - 1);
 	mas_store_prealloc(&vmi->mas, vma);
+}
+
+static inline void vma_iter_store(struct vma_iterator *vmi,
+				  struct vm_area_struct *vma)
+{
 	vma_mark_attached(vma);
+	vma_iter_store_attached(vmi, vma);
 }
 
 static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
tools-fix-atomic_set-definition-to-set-the-value-correctly.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

