Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F421A5A2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644517; cv=none; b=M7RjS/HDs+iUvsykZUitiqQWUQ5PslIZIciGt0jJiPIsGhJdNrR2ASWw4WRZiT6B+FkdHhElvJxw0edqM0dMOfkzFe9UIvfhkJVi2b7lMnIgBmQKWb7lXCoJo7ZGU1bylG3PdRyGHLSeN6nFPvBUdrmegaIRK1MYlJ6P72q+kG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644517; c=relaxed/simple;
	bh=jeZxyVJmNmPZOGy2ts4G+tqF2kwOWIPVWD3ZLcpRV6A=;
	h=Date:To:From:Subject:Message-Id; b=s7Mt/IlXeePaC03Cwaz9J7LZpwbUh93KLbDLaYjoza+HH8WoqeO/WE2LVGGBlzM/HxLdu0gg5dUs1sNG+KELLN4kRvgR4xqJ+ib9WysbI/Mr/VYIWvaoEvIWHs5yb5lA/mnPP7ytPWjlc1JQo3/s7NEm18bR5wvA3xUxKEBPueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GnCCDwu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GnCCDwu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1D6C433B2;
	Thu, 22 Feb 2024 23:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644517;
	bh=jeZxyVJmNmPZOGy2ts4G+tqF2kwOWIPVWD3ZLcpRV6A=;
	h=Date:To:From:Subject:From;
	b=GnCCDwu8OetbT1S55HSdlF0qzZ+nKpbMICbOd14Q3738k8AYpVUTkIjs5Jt/dwcEj
	 8RRHsoLaksYWQ3EhugDG+sX6nv7r2vTkSluLowef2nu3UKmimSRJVz9sc1WV6htMBO
	 alkuvrLyB5QQtYoMLyWajgikGbcnrbDduUBaV4RM=
Date: Thu, 22 Feb 2024 15:28:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,timmurray@google.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-vma_assert_locked-for-config_per_vma_lock.patch removed from -mm tree
Message-Id: <20240222232837.8B1D6C433B2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add vma_assert_locked() for !CONFIG_PER_VMA_LOCK
has been removed from the -mm tree.  Its filename was
     mm-add-vma_assert_locked-for-config_per_vma_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: mm: add vma_assert_locked() for !CONFIG_PER_VMA_LOCK
Date: Thu, 15 Feb 2024 10:27:55 -0800

vma_assert_locked() is needed to replace mmap_assert_locked() once we
start using per-vma locks in userfaultfd operations.

In !CONFIG_PER_VMA_LOCK case when mm is locked, it implies that the given
VMA is locked.

Link: https://lkml.kernel.org/r/20240215182756.3448972-4-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mm.h~mm-add-vma_assert_locked-for-config_per_vma_lock
+++ a/include/linux/mm.h
@@ -781,6 +781,11 @@ static inline struct vm_area_struct *loc
 	return NULL;
 }
 
+static inline void vma_assert_locked(struct vm_area_struct *vma)
+{
+	mmap_assert_locked(vma->vm_mm);
+}
+
 static inline void release_fault_lock(struct vm_fault *vmf)
 {
 	mmap_read_unlock(vmf->vma->vm_mm);
_

Patches currently in -mm which might be from lokeshgidra@google.com are


