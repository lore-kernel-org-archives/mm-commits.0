Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695831C862D
	for <mm-commits@vger.kernel.org>; Thu,  9 Apr 2026 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775755691; cv=none; b=AyD7gWIKeiqs2H7BaskP/uqoU89AgOTgjh7d0K5loJ1RgURPGe/icBpw3OTq0tpZJ7MaEBflm9J/oL1tXSg2weW9cvpjqIgJyW6ZIRgxVXlUv1vh2HzXPU5l/BxwyPQHNNhiaRZ2x/wlgECWREVirtXx14w9yxf4dL303HCmT9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775755691; c=relaxed/simple;
	bh=rgUreaQeRfgT2ANmxRoK+bQaMnZocOML+0H4VnDIcHk=;
	h=Date:To:From:Subject:Message-Id; b=PdgaG10wqzeO/D0I8YbwZVOuEVOkZw/+6n+LyBonA5RiiSZnpTn/mW/KQ1zseRYgVlRfLW/UngHMXeHYnx6l0ROy1OdUy6hLoaoRy+gW8EqHk3E4b2EXnmbuI7MqHNQlbbulLuzpb1qO0LuDQcZFhjb81/xLnm8zFYW1uy00EyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cc+ZTZzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cc+ZTZzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B29C19424;
	Thu,  9 Apr 2026 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775755691;
	bh=rgUreaQeRfgT2ANmxRoK+bQaMnZocOML+0H4VnDIcHk=;
	h=Date:To:From:Subject:From;
	b=cc+ZTZzhlVHyE6nD2y6xKQH9FKKjbuMzjKLRLe5yM77kz24yK5T4mzt1esAydt14N
	 y1og0i5p9cd/UOI0L72GKDZu0hGudSfre/Bapd3l1VCeaXJxVMG/1t9AnN48kWfynZ
	 BmZQBIuEp3wL6uchclIx5AG9XggulhELNbZhaF1o=
Date: Thu, 09 Apr 2026 10:28:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tz2294@columbia.edu,surenb@google.com,shuah@kernel.org,seanjc@google.com,peterx@redhat.com,pbonzini@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kalyazin@amazon.com,jthoughton@google.com,hughd@google.com,harry.yoo@oracle.com,harry@kernel.org,devnexen@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,avagin@google.com,aarcange@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-introduce-vm_uffd_ops-fix.patch added to mm-unstable branch
Message-Id: <20260409172810.D9B29C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-introduce-vm_uffd_ops-fix
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-introduce-vm_uffd_ops-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-introduce-vm_uffd_ops-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Mike Rapoport (Microsoft) <rppt@kernel.org>
Subject: userfaultfd-introduce-vm_uffd_ops-fix
Date: Thu, 9 Apr 2026 20:18:57 +0300

relocate VM_DROPPABLE test, per Tal

Link: https://lkml.kernel.org/r/adffgfM5ANxtPIEF@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
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

 mm/userfaultfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-introduce-vm_uffd_ops-fix
+++ a/mm/userfaultfd.c
@@ -2042,6 +2042,9 @@ bool vma_can_userfault(struct vm_area_st
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
 	vm_flags &= __VM_UFFD_FLAGS;
 
 	/*
@@ -2055,9 +2058,6 @@ bool vma_can_userfault(struct vm_area_st
 	if (!ops)
 		return false;
 
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
 	/*
 	 * If user requested uffd-wp but not enabled pte markers for
 	 * uffd-wp, then only anonymous memory is supported
_

Patches currently in -mm which might be from rppt@kernel.org are

tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch
userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_establish_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
userfaultfd-introduce-vm_uffd_ops-fix.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

