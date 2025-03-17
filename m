Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258DE215F7E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188335; cv=none; b=RhZ6H2oswGjBt4gVRxNxVN/UC+jyoqSl8jIEYykFSmvbwxN80n+RlgrqGwQOiayhxdzRvPs9Xe0kCFuq1cWcsAYpr9ZtluPIWUw8vVXgP+d1GWj1cl/xF9wrNA7VDXSeaVeXfx6Qa86WQtGxUIFnj7nY/NnZohpG6C3oe99P87s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188335; c=relaxed/simple;
	bh=a/uBM+2bKorsInBuw6079MzPt59xSd7hB3p0JHAuO8s=;
	h=Date:To:From:Subject:Message-Id; b=OzjAKKx6pM48XhgTdOCcCYY9wUf5OUQX81hZ9GuwQ2+wk0i+Dakbqvtd6A9X+/h8US06Q+SzY7V2M/LHNolUXlQREUI2CWwffP7fDXTJcQC0+Kis6c1P4yFSvTMDVTUI+rAia0b2bD93YAB/fTArAf9NU27OQQHmLD7WcZKILu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zl9Z+XcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zl9Z+XcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7003C4CEEC;
	Mon, 17 Mar 2025 05:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188335;
	bh=a/uBM+2bKorsInBuw6079MzPt59xSd7hB3p0JHAuO8s=;
	h=Date:To:From:Subject:From;
	b=zl9Z+XcNlYGJ/VtuOmq0Mo1XU/gkYjQdC6hvRE4O1YjlSCJwMAIetm5cdfLHGLRtA
	 SwMC8xrf2/qCA3Wp019QuAdPzkmwzDaymC1tFwcXjzLcR/xxEgLPXD25e7rKfdbW7o
	 rXcQKWTwwY1F27PafdOO0tKfg372UMoDIvo39MSA=
Date: Sun, 16 Mar 2025 22:12:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch removed from -mm tree
Message-Id: <20250317051214.E7003C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prepare lock_vma_under_rcu() for vma reuse possibility
has been removed from the -mm tree.  Its filename was
     mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: prepare lock_vma_under_rcu() for vma reuse possibility
Date: Thu, 13 Feb 2025 14:46:53 -0800

Once we make vma cache SLAB_TYPESAFE_BY_RCU, it will be possible for a vma
to be reused and attached to another mm after lock_vma_under_rcu() locks
the vma.  lock_vma_under_rcu() should ensure that vma_start_read() is
using the original mm and after locking the vma it should ensure that
vma->vm_mm has not changed from under us.

Link: https://lkml.kernel.org/r/20250213224655.1680278-17-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 include/linux/mm.h |   12 ++++++++----
 mm/memory.c        |    7 ++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility
+++ a/include/linux/mm.h
@@ -739,10 +739,13 @@ static inline void vma_refcount_put(stru
  * Try to read-lock a vma. The function is allowed to occasionally yield false
  * locked result to avoid performance overhead, in which case we fall back to
  * using mmap_lock. The function should never yield false unlocked result.
+ * False locked result is possible if mm_lock_seq overflows or if vma gets
+ * reused and attached to a different mm before we lock it.
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
  */
-static inline struct vm_area_struct *vma_start_read(struct vm_area_struct *vma)
+static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
+						    struct vm_area_struct *vma)
 {
 	int oldcnt;
 
@@ -753,7 +756,7 @@ static inline struct vm_area_struct *vma
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq.sequence))
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
 		return NULL;
 
 	/*
@@ -780,7 +783,7 @@ static inline struct vm_area_struct *vma
 	 * after it has been unlocked.
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&vma->vm_mm->mm_lock_seq))) {
+	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
 		vma_refcount_put(vma);
 		return NULL;
 	}
@@ -914,7 +917,8 @@ struct vm_area_struct *lock_vma_under_rc
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline struct vm_area_struct *vma_start_read(struct vm_area_struct *vma)
+static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
+						    struct vm_area_struct *vma)
 		{ return NULL; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
--- a/mm/memory.c~mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility
+++ a/mm/memory.c
@@ -6452,7 +6452,7 @@ retry:
 	if (!vma)
 		goto inval;
 
-	vma = vma_start_read(vma);
+	vma = vma_start_read(mm, vma);
 	if (IS_ERR_OR_NULL(vma)) {
 		/* Check if the VMA got isolated after we found it */
 		if (PTR_ERR(vma) == -EAGAIN) {
@@ -6471,8 +6471,9 @@ retry:
 	 * fields are accessible for RCU readers.
 	 */
 
-	/* Check since vm_start/vm_end might change before we lock the VMA */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+	/* Check if the vma we locked is the right one. */
+	if (unlikely(vma->vm_mm != mm ||
+		     address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();
_

Patches currently in -mm which might be from surenb@google.com are


