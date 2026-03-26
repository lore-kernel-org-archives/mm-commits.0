Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423D434A78D
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774544827; cv=none; b=NfzkA4hOZ1TwX81bc5XAl9O3+ibh3gkwjBbmhLi8G8JeWgt5KVhgtpuZh1hsje8nnbAcK6DcEdAHxKVzrmK1Em4zyq8VRtKF7oalXhP8OQdtwcHH/HNbzrpy5oI/ClTO+uH/bS5/UY1subRngZe5hUBM9s/qAonkbbmbUWOI7t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774544827; c=relaxed/simple;
	bh=GoJ5MGHvcJ5Lgl6kU2UvUD7wLOQ0XqcmZp+3zOX5d/g=;
	h=Date:To:From:Subject:Message-Id; b=FVHVMvSyfchd+FxVAkDiU4zjLBfKEX6XFUdJVh7QuApe+QYXHibn0QGtc/Wnxj+uyF9DRtSYdw4echo+hOSVdOpsKJpSbeeUwxaBakjINyQy9Cf3qFgiEwM5Xh9JAhsiX+ZsPBBXfNymNQoZ7KodKo7l/qC0tz+DBbLvlP/XJT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXAC0MSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXAC0MSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAC1C116C6;
	Thu, 26 Mar 2026 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774544826;
	bh=GoJ5MGHvcJ5Lgl6kU2UvUD7wLOQ0XqcmZp+3zOX5d/g=;
	h=Date:To:From:Subject:From;
	b=lXAC0MSCuskGYeyAM1bwb28eUoe2tBgaPovnXaLtCKl1m/qDbjXdGl1EcqZfGjkTN
	 5EQPp2cKa5CYeiN2yIGF9VLnRMrrwpag7BjM6GQNpXKJmRZE0roHz6OecoTTn8cBNr
	 X/2IS6S8opOUCWFvxT06TcnH41ebVZCXLDQDMhZw=
Date: Thu, 26 Mar 2026 10:07:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-introduce-vm_uffd_ops-fix.patch removed from -mm tree
Message-Id: <20260326170706.CDAC1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: allow registration of WP_ASYNC for any VMA
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-vm_uffd_ops-fix.patch

This patch was dropped because it was folded into userfaultfd-introduce-vm_uffd_ops.patch

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: allow registration of WP_ASYNC for any VMA
Date: Wed, 11 Mar 2026 20:21:38 +0200

Registration of a VMA with WP_ASYNC userfaulfd context in write-protect
mode does not require any VMA-specific resolution of user faults and these
faults are completely handled by the generic page fault handler.

This functionality existed since the introduction of WP_ASYNC mode and it
allows tracking writes to SysV shared memory mappings (shmget(2) and
shmat(2)).

Move the check for WP mode before checking for presence of ->uffd_ops in a
VMA to restore the original behaviour.

Link: https://lkml.kernel.org/r/abG5HFV8yoEHOFkh@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-vm_uffd_ops-fix
+++ a/mm/userfaultfd.c
@@ -2042,22 +2042,22 @@ bool vma_can_userfault(struct vm_area_st
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	/* only VMAs that implement vm_uffd_ops are supported */
-	if (!ops)
-		return false;
-
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
 	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * If WP is the only mode enabled and context is wp async, allow any
 	 * memory type.
 	 */
 	if (wp_async && (vm_flags == VM_UFFD_WP))
 		return true;
 
+	/* For any other mode reject VMAs that don't implement vm_uffd_ops */
+	if (!ops)
+		return false;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then only anonymous memory is supported
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch
selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

