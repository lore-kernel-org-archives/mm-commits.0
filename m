Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DA033E35D
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 17:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721030; cv=none; b=KcJS+g9TaYgdy60Xn9Q2iHrx4X2LkvV+DjXPm/xFewdI3RUXNSb5JSxISmsyAR2fzd1FUhD/B0l1Ua18EcDUMX8BQwKk8VKCvj18NmVQii/Xdk53knNKvl3ez2rrt2Pt6gCSY/b+o823nrWYn8SyyJGL84Cx2CUI+0Whqk3oU0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721030; c=relaxed/simple;
	bh=7Y9QhBcEKKG+halpsjibzflSbupwWeEDfUtiFuF+7hM=;
	h=Date:To:From:Subject:Message-Id; b=clbmbVE9/tkGobX1L0/HpjxlrbSYxW41SIJmu9J0DnEud5LBrwvRyVVkumNkjOZHjAu5VCqa8bJ43F1fGw2zy05vq9h5NEUSx3F6mJGhwAr5eqDWlZkr94HVDlyQwl0xuQ9HWNOOG9GtpaL7Czl/5ZyL4JZLePi1CmCDCBwI0mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aliy46YH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aliy46YH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2729C116C6;
	Tue,  6 Jan 2026 17:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767721028;
	bh=7Y9QhBcEKKG+halpsjibzflSbupwWeEDfUtiFuF+7hM=;
	h=Date:To:From:Subject:From;
	b=aliy46YHTR2psFQvmd7lgWaFCmL3ndHrXMTiOq9+VflE7nJVkzVgeNCiOIg2V8WQF
	 hWftkPOpH2zO4qWRZOo1ijmk2pgrOf/w+vbAITy+vU0L6x4euHlvU3TZ0EW0EqKkIA
	 H5n97K/5aHa9EkJ4j5ICHl0fob4I2/C7XYxEVktI=
Date: Tue, 06 Jan 2026 09:37:08 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-make-anon_vma-functions-internal.patch added to mm-new branch
Message-Id: <20260106173708.D2729C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: make anon_vma functions internal
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-make-anon_vma-functions-internal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-make-anon_vma-functions-internal.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: make anon_vma functions internal
Date: Tue, 6 Jan 2026 15:04:30 +0000

The bulk of the anon_vma operations are only used by mm, so formalise this
by putting the function prototypes and inlines in mm/internal.h.  This
allows us to make changes without having to worry about the rest of the
kernel.

Link: https://lkml.kernel.org/r/01fb330542cc1b9437c1a9d1f54432b0547a1582.1767711638.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   60 -----------------------------------------
 mm/internal.h        |   58 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 60 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-make-anon_vma-functions-internal
+++ a/include/linux/rmap.h
@@ -104,68 +104,8 @@ enum ttu_flags {
 };
 
 #ifdef CONFIG_MMU
-static inline void get_anon_vma(struct anon_vma *anon_vma)
-{
-	atomic_inc(&anon_vma->refcount);
-}
 
-void __put_anon_vma(struct anon_vma *anon_vma);
-
-static inline void put_anon_vma(struct anon_vma *anon_vma)
-{
-	if (atomic_dec_and_test(&anon_vma->refcount))
-		__put_anon_vma(anon_vma);
-}
-
-static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
-{
-	down_write(&anon_vma->root->rwsem);
-}
-
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
-{
-	up_write(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
-{
-	down_read(&anon_vma->root->rwsem);
-}
-
-static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
-{
-	return down_read_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
-{
-	up_read(&anon_vma->root->rwsem);
-}
-
-
-/*
- * anon_vma helper functions.
- */
 void anon_vma_init(void);	/* create anon_vma_cachep */
-int  __anon_vma_prepare(struct vm_area_struct *);
-void unlink_anon_vmas(struct vm_area_struct *);
-int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
-int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
-
-static inline int anon_vma_prepare(struct vm_area_struct *vma)
-{
-	if (likely(vma->anon_vma))
-		return 0;
-
-	return __anon_vma_prepare(vma);
-}
-
-struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
 static __always_inline void folio_lock_large_mapcount(struct folio *folio)
--- a/mm/internal.h~mm-rmap-make-anon_vma-functions-internal
+++ a/mm/internal.h
@@ -199,6 +199,64 @@ static inline void vma_close(struct vm_a
 
 #ifdef CONFIG_MMU
 
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	atomic_inc(&anon_vma->refcount);
+}
+
+void __put_anon_vma(struct anon_vma *anon_vma);
+
+static inline void put_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_test(&anon_vma->refcount))
+		__put_anon_vma(anon_vma);
+}
+
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
+{
+	down_write(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
+{
+	return down_write_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
+{
+	up_write(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
+{
+	down_read(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
+{
+	return down_read_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
+{
+	up_read(&anon_vma->root->rwsem);
+}
+
+struct anon_vma *folio_get_anon_vma(const struct folio *folio);
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
+int  __anon_vma_prepare(struct vm_area_struct *vma);
+void unlink_anon_vmas(struct vm_area_struct *vma);
+
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
+{
+	if (likely(vma->anon_vma))
+		return 0;
+
+	return __anon_vma_prepare(vma);
+}
+
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch
tools-testing-selftests-fix-gup_longterm-for-unknown-fs.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch

