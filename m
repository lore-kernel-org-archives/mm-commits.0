Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7671EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119350; cv=none; b=BesvT04usHw7+RWR8hzlvUpKDVo+jqH89E8QGPzDaJOLYL8DHTtirhHJOPWeireWsvzaMpfyDl0eWU/Ga2jCKna4ldQq9FuiyPBIs179LhX7cIbYuIQyHcvgcLkVXCGMNBZLI0QKftCDKBMws4QckER4zc6GmKZM4GQcF3UCBoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119350; c=relaxed/simple;
	bh=/5raE3HjM4PpdLT1dj1BmhgLTMczOWeLsDoDwN6s+RQ=;
	h=Date:To:From:Subject:Message-Id; b=Dez1AMry1gPG6x1YkgwOpU9cIXngido3K1kGgluAk8BKnXeJ6PIZolnspuABwE/vVUFX/4kXEqri1VCdFVv8htf7xf7Tp5rxHNM5t3UXegOzaaKyhh3zOhhEu8s6oH7pMe6JEtqMbPla8vEfCsbgat7FGoEDzXYgyQ+PHwZO1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=td9dUSaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="td9dUSaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DB6C4CEE4;
	Tue, 13 May 2025 06:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119349;
	bh=/5raE3HjM4PpdLT1dj1BmhgLTMczOWeLsDoDwN6s+RQ=;
	h=Date:To:From:Subject:From;
	b=td9dUSazaxjAZCbi12p9ggSisqCrQLM8ngagJSqFenTlrR9hUwMORuocH0t+MQpSd
	 pWugAfBn84pTPWY5u5I5L4gfuU1xmgkKXFayCRz0kepmZ+uFGqqMATTv1wgQ2gHQNo
	 1YKf9C2Ph28Six9jHEjz+cZ3E9zyA2NRBVWlC77k=
Date: Mon, 12 May 2025 23:55:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-convert-to-mmap_prepare-hook.patch removed from -mm tree
Message-Id: <20250513065549.C3DB6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: secretmem: convert to .mmap_prepare() hook
has been removed from the -mm tree.  Its filename was
     mm-secretmem-convert-to-mmap_prepare-hook.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: secretmem: convert to .mmap_prepare() hook
Date: Fri, 9 May 2025 13:13:35 +0100

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

Link: https://lkml.kernel.org/r/0f758474fa6a30197bdf25ba62f898a69d84eef3.1746792520.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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
+	const unsigned long len = desc->end - desc->start;
 
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

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch

