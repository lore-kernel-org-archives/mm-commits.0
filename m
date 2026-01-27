Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCB731619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486663; cv=none; b=Oxv8Q/l8GKccCVDb0H9mJOlzLA1oCL8+3hCcDEkeNY1u6tQfOoigg3O9lH+GocpRK/9whyyv8kKc1RYA8EPXnriLIYB/2TrlG745YrSGRCavWAJSD7uHBxplj1I4zT7yFQszZ/YZLhVMPaUL+ny9o56CVJqpWTz+asvRa/yXvDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486663; c=relaxed/simple;
	bh=ptiviejfuDDYCzdcfiHKb6ly6O2tC6xA95n/Ctt3v2g=;
	h=Date:To:From:Subject:Message-Id; b=dfLej+0XZ4/bXZWKe/Akh1NWg+6zuAYFf/WViX0241nzRgD/MS2ORYZIPos83d392/OMQvsa2EaI2wEb8M8qS91doB4QFvQDQsy8xrSKKPlQAV960sROMxG+aWtKiRdQjZkH1bC5seFilllpXuOZUKdZSIeiEwV3E8WSnHGAISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MxtdVfAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MxtdVfAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F80C116C6;
	Tue, 27 Jan 2026 04:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486662;
	bh=ptiviejfuDDYCzdcfiHKb6ly6O2tC6xA95n/Ctt3v2g=;
	h=Date:To:From:Subject:From;
	b=MxtdVfAIBtFZxVyml3D3iMsv3slOrNcEbhFwlp2zbMZ+JZ05OuWcAmvs8rjdKGE9b
	 voZt0NdK89hNMNSXWkwTbe49MQWO7Ohv4XlRjmji+gi2WnGjryFYYPYa5psbx1eJ/i
	 A1iBQ7y9jvTNml4uLwMrh3itSRHGZBIsAtavaE1s=
Date: Mon, 26 Jan 2026 20:04:22 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-make-anon_vma-functions-internal.patch removed from -mm tree
Message-Id: <20260127040422.C0F80C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: make anon_vma functions internal
has been removed from the -mm tree.  Its filename was
     mm-rmap-make-anon_vma-functions-internal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: make anon_vma functions internal
Date: Sun, 18 Jan 2026 14:50:42 +0000

The bulk of the anon_vma operations are only used by mm, so formalise this
by putting the function prototypes and inlines in mm/internal.h.  This
allows us to make changes without having to worry about the rest of the
kernel.

Link: https://lkml.kernel.org/r/79ec933c3a9c8bf1f64dab253bbfdae8a01cb921.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
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

selftests-mm-remove-virtual_address_range-test.patch
mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
mm-vma-clean-up-__vma_enter-exit_locked.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-vma-improve-and-document-__is_vma_write_locked.patch
mm-vma-improve-and-document-__is_vma_write_locked-fix.patch
mm-vma-update-vma_assert_locked-to-use-lockdep.patch
mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
mm-vma-add-and-use-vma_assert_stabilised.patch
mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

