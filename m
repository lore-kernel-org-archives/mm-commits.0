Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EC731619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486664; cv=none; b=B5C10AU1kI8epSaPysJ7x1E4PPN9zFnW8nLq6QZ2oqNayrNHonm0mEMw8rO13Ssdq1LcWxR0TQKYwWop3YV1X4Leg8j2J8qPhSl0YfPzR3KEqtduWZWB8LjZcFKGZafmQxDFt1clIjuJv1T/3XCaO8ldeW84/ke5Y+pgS2E0ZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486664; c=relaxed/simple;
	bh=0aUCoWZOu7KDj75T+To4U5x6zfXzlmTKJTrBh3IVu3I=;
	h=Date:To:From:Subject:Message-Id; b=o5QC7nnB5K7AltUkCw0Dl87XSPu8ifzprK+vvbH1/Ft7+r95fXLeWV7K8MKlulmYoW7GxyrYUlN5VkfBbgqYKgMiqY9Q8IVR6WiEwif7qYjVtGn0Rz2tWdROuQVmjNMD24Ntzn49VCtijsUp9bpKB6Pkm2swddDsDtSn7K3kQY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jAoO6cnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jAoO6cnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8D7C116D0;
	Tue, 27 Jan 2026 04:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486664;
	bh=0aUCoWZOu7KDj75T+To4U5x6zfXzlmTKJTrBh3IVu3I=;
	h=Date:To:From:Subject:From;
	b=jAoO6cnkUUf5haNSiqV9uV71ibb2vVzSDErC8Mcg10B5wV5h3jskvC9Fa1VeDMnUh
	 rCrwe6ZfGMRgPtuULc27kBBMBm+Y86VKEBuOP07CagvkP5+wlUgDRZVMrStVrdvC7a
	 YS+smzUotjnGGYh2m00J6I4W4cUaTBfSz6Y044IU=
Date: Mon, 26 Jan 2026 20:04:23 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap_lock-add-vma_is_attached-helper.patch removed from -mm tree
Message-Id: <20260127040424.7C8D7C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap_lock: add vma_is_attached() helper
has been removed from the -mm tree.  Its filename was
     mm-mmap_lock-add-vma_is_attached-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mmap_lock: add vma_is_attached() helper
Date: Sun, 18 Jan 2026 14:50:43 +0000

This makes it easy to explicitly check for VMA detachment, which is useful
for things like asserts.

Note that we intentionally do not allow this function to be available
should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
no correct state for vma_is_attached() to be in if this configuration
option is not specified.

Therefore users elsewhere must invoke this function only after checking
for CONFIG_PER_VMA_LOCK.

We rework the assert functions to utilise this.

Link: https://lkml.kernel.org/r/0172d3bf527ca54ba27d8bce8f8476095b241ac7.1768746221.git.lorenzo.stoakes@oracle.com
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

 include/linux/mmap_lock.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-mmap_lock-add-vma_is_attached-helper
+++ a/include/linux/mmap_lock.h
@@ -251,6 +251,11 @@ static inline void vma_assert_locked(str
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -258,12 +263,12 @@ static inline void vma_assert_locked(str
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
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

