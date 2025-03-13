Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5F41F03C7
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741906529; cv=none; b=XJXwHn3SMg8K0HknPl20zZ03w8v8rBQ9qPAU0UH5tBpxuJ67hvrWoN0LhI3BQhvMYDtGkDege7jlg8FspvpcvC1OKPXrsVvnp4n3mw/87L6/g/5b4qVypV/Wf+mU5R0Kji5f2Xg8Ta5/Q0760sUXohnz3xrfMT4wkMLafwzEk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741906529; c=relaxed/simple;
	bh=2MnqOPd/g9CRtxO1HWcgJE6eLmiBfxThV96/31tIdkw=;
	h=Date:To:From:Subject:Message-Id; b=n/0yvbLXliMr3RKgInrp41WQ0/ypLWt7IihV100PxumnqjzOX2uc0ItD5G3EMnLEfnv9VF+gVuv3vaeX8Oh2GWB94sfzyJzopZbHxFyWnVmGy/p8FLwNJrUnKYwo83rN+B+8eIGKslB6/gQQonLRRgE9xs+H4yQ9guuhfHe/4A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uRUI1f78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uRUI1f78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76160C4CEDD;
	Thu, 13 Mar 2025 22:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741906528;
	bh=2MnqOPd/g9CRtxO1HWcgJE6eLmiBfxThV96/31tIdkw=;
	h=Date:To:From:Subject:From;
	b=uRUI1f78tTE3VEcz4cPqvvNNmZSelS/HOfVCtz5vz+uYbkv634qcm6gye/KQR4kfl
	 PYn+s+5Rgq2BNCsdVio8dQmOdkn4MeMrJA9FHmwvNj5yj7P4hm0ujcAfkEIqy8BtER
	 2yFsy69QxiwHsrx//zvQbhb5X3JrcBt6/XjVBYnE=
Date: Thu, 13 Mar 2025 15:55:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pedro.falcato@gmail.com,oliver.sang@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree.patch removed from -mm tree
Message-Id: <20250313225528.76160C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vma: skip anonymous vma when inserting vma to file rmap tree
has been removed from the -mm tree.  Its filename was
     mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: vma: skip anonymous vma when inserting vma to file rmap tree
Date: Thu, 6 Mar 2025 13:49:48 -0800

LKP reported 800% performance improvement for small-allocs benchmark from
vm-scalability [1] with patch ("/dev/zero: make private mapping full
anonymous mapping") [2], but the patch was nack'ed since it changes the
output of smaps somewhat.

The profiling shows one of the major sources of the performance
improvement is the less contention to i_mmap_rwsem.

The small-allocs benchmark creates a lot of 40K size memory maps by
mmap'ing private /dev/zero then triggers page fault on the mappings.  When
creating private mapping for /dev/zero, the anonymous VMA is created, but
it has valid vm_file.  Kernel basically assumes anonymous VMAs should have
NULL vm_file, for example, mmap inserts VMA to the file rmap tree if
vm_file is not NULL.  So the private /dev/zero mapping will be inserted to
the file rmap tree, this resulted in the contention to i_mmap_rwsem.  But
it is actually anonymous VMA, so it is pointless to insert it to file rmap
tree.

Skip anonymous VMA for this case.  Over 400% performance improvement was
reported [3].

It is not on par with the 800% improvement from the original patch.  It is
because page fault handler needs to access some members of struct file if
vm_file is not NULL, for example, f_mode and f_mapping.  They are in the
same cacheline with file refcount.  When mmap'ing a file the file refcount
is inc'ed and dec'ed, this caused bad cache false sharing problem.  The
further debug showed checking whether the VMA is anonymous or not can
alleviate the problem.  But I'm not sure whether it is the best way to
handle it, maybe we should consider shuffle the layout of struct file.

However it sounds rare that real life applications would create that many
maps with mmap'ing private /dev/zero and share the same struct file, so
the cache false sharing problem may be not that bad.  But i_mmap_rwsem
contention problem seems more real since all /dev/zero private mappings
even from different applications share the same struct address_space so
the same i_mmap_rwsem.

[1] https://lore.kernel.org/linux-mm/202501281038.617c6b60-lkp@intel.com/
[2] https://lore.kernel.org/linux-mm/20250113223033.4054534-1-yang@os.amperecomputing.com/
[3] https://lore.kernel.org/linux-mm/Z6RshwXCWhAGoMOK@xsang-OptiPlex-9020/#t

Link: https://lkml.kernel.org/r/20250306214948.2939043-1-yang@os.amperecomputing.com
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree
+++ a/mm/vma.c
@@ -1652,6 +1652,9 @@ static void unlink_file_vma_batch_proces
 void unlink_file_vma_batch_add(struct unlink_vma_file_batch *vb,
 			       struct vm_area_struct *vma)
 {
+	if (vma_is_anonymous(vma))
+		return;
+
 	if (vma->vm_file == NULL)
 		return;
 
@@ -1675,8 +1678,12 @@ void unlink_file_vma_batch_final(struct
  */
 void unlink_file_vma(struct vm_area_struct *vma)
 {
-	struct file *file = vma->vm_file;
+	struct file *file;
+
+	if (vma_is_anonymous(vma))
+		return;
 
+	file = vma->vm_file;
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
 
@@ -1688,9 +1695,13 @@ void unlink_file_vma(struct vm_area_stru
 
 void vma_link_file(struct vm_area_struct *vma)
 {
-	struct file *file = vma->vm_file;
+	struct file *file;
 	struct address_space *mapping;
 
+	if (vma_is_anonymous(vma))
+		return;
+
+	file = vma->vm_file;
 	if (file) {
 		mapping = file->f_mapping;
 		i_mmap_lock_write(mapping);
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are


