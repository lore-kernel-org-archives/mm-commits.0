Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416CF84D02
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746665772; cv=none; b=ggVgUKU6+dl3eB4TeqB3cDBBIu7TL6IjOu3zNHugHa1BuqyoKzeki0uphGTbftBa/qZ2+rFN3UPXZxmFp0U4nyhfc3S4peDw1s+DEj4llF4TYI8ImVm14Mz08/vmXAkm7NPj0KtyhN2h5CLbnpspuqRGJ2Fe30wAhkQhAsK2IM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746665772; c=relaxed/simple;
	bh=Z818NFwBN2L9Bze42rZ+Xm+7nYKyw5+7R5yAbxf+a/U=;
	h=Date:To:From:Subject:Message-Id; b=kqIr1iXw20STPrGMTg5g6ahdguOc0xkWNeJjpFcyiFNbRsu0nETFKoiNI50aD7RFQaA8dFh2z7HOJGoV0Jf3zQdfs32ayWdy3Ke9lBy/kgYmACDg2tzlH+GT33SJor9Y4ypxnqluB92oLTs8hD/bQt7sJQzG0awvjGNwqLW+g2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h5TCUGjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h5TCUGjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2B3C4CEE2;
	Thu,  8 May 2025 00:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746665771;
	bh=Z818NFwBN2L9Bze42rZ+Xm+7nYKyw5+7R5yAbxf+a/U=;
	h=Date:To:From:Subject:From;
	b=h5TCUGjwcn9+ZvDrUU64pKoMvdebGLA79+Kxm3EkY20NNm3gQ5K5iMz7/otUHdWeX
	 pwu2e5ZlrKGFnZ6urHitqfzQf9a+w16/Az8aXEQEeJ9CclgHW/syKPznRYnOIdhLUq
	 CQisiQshAVlQCXQ3jQ51s4ReEEN3l7Z7xLt8qHaY=
Date: Wed, 07 May 2025 17:56:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-convert-to-mmap_prepare-hook.patch added to mm-unstable branch
Message-Id: <20250508005611.9C2B3C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: secretmem: convert to .mmap_prepare() hook
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-convert-to-mmap_prepare-hook.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-convert-to-mmap_prepare-hook.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: secretmem: convert to .mmap_prepare() hook
Date: Wed, 7 May 2025 12:03:35 +0100

Secretmem has a simple .mmap() hook which is easily converted to the new
.mmap_prepare() callback.

Importantly, it's a rare instance of an driver that manipulates a VMA
which is mergeable (that is, not a VM_SPECIAL mapping) while also
adjusting VMA flags which may adjust mergeability, meaning the retry merge
logic might impact whether or not the VMA is merged.

By using .mmap_prepare() there's no longer any need to retry the merge
later as we can simply set the correct flags from the start.

This change therefore allows us to remove the retry merge logic in a
subsequent commit.

Link: https://lkml.kernel.org/r/a196a08a52039ee159c8333d0c6547e78112acb7.1746615512.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/secretmem.c~mm-secretmem-convert-to-mmap_prepare-hook
+++ a/mm/secretmem.c
@@ -120,18 +120,18 @@ static int secretmem_release(struct inod
 	return 0;
 }
 
-static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
+static int secretmem_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned long len = vma->vm_end - vma->vm_start;
+	unsigned long len = desc->end - desc->start;
 
-	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
+	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
 
-	if (!mlock_future_ok(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
+	if (!mlock_future_ok(desc->mm, desc->vm_flags | VM_LOCKED, len))
 		return -EAGAIN;
 
-	vm_flags_set(vma, VM_LOCKED | VM_DONTDUMP);
-	vma->vm_ops = &secretmem_vm_ops;
+	desc->vm_flags |= VM_LOCKED | VM_DONTDUMP;
+	desc->vm_ops = &secretmem_vm_ops;
 
 	return 0;
 }
@@ -143,7 +143,7 @@ bool vma_is_secretmem(struct vm_area_str
 
 static const struct file_operations secretmem_fops = {
 	.release	= secretmem_release,
-	.mmap		= secretmem_mmap,
+	.mmap_prepare	= secretmem_mmap_prepare,
 };
 
 static int secretmem_migrate_folio(struct address_space *mapping,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch
maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

