Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8067E27CCE9
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 23:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302002; cv=none; b=em2UGKoporyW5y0Cu35ALZTgYv3DN9YLLDPoLehJAjx8edDj13b8xu/CXCWJdGqzu5ibeyqCeIjdK5nqhLddYjtbaf/D33aSsUM7d0t8lhyz9j8t7T7rNJFo5Vxl71v3lLzwaOHCkbl0nDZF/aR8MZCtpQwFBw1yjrDURMkEdH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302002; c=relaxed/simple;
	bh=HJQrNsaHtxvPst2rcu1AfeJPexogwSN8egUPmaX9gS0=;
	h=Date:To:From:Subject:Message-Id; b=W/3JdqELpnviDucYzEUTU8AXRwvA63cXuJwMQwCrQXaFH35ACAjFK9NW8NAtLdaGaLVGs9Tg0Hgrp3Jw+U74koxU/W4GU/VWOyvhkxH0MdiH0KtwAa4CUwc3enSugKks6b6fUIYadicnkRaXYSaTCqkYdrrif0mpcIt3VB953CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hQ3dwEUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hQ3dwEUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F6C4CEE0;
	Thu,  6 Mar 2025 23:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741302001;
	bh=HJQrNsaHtxvPst2rcu1AfeJPexogwSN8egUPmaX9gS0=;
	h=Date:To:From:Subject:From;
	b=hQ3dwEUXu9tsBecxHpv/sjDDX4/QSQ2YDq3qeO3IWfUWecApqL59c5oczM/eNgnIE
	 9ZZm2bOfQIz8bgyDj9r7DTZIjxJJOWCQy/YYlnvZWWvv8/UJroZQUl1ZdE/Qsevp/S
	 NIhIZs0WuzulmgauYkBCSpeCJNlF9d/eXXBx1cnk=
Date: Thu, 06 Mar 2025 15:00:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree.patch added to mm-unstable branch
Message-Id: <20250306230001.C20F6C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vma: skip anonymous vma when inserting vma to file rmap tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree.patch

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
Cc: Jann Horn <jannh@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-vma-skip-anonymous-vma-when-inserting-vma-to-file-rmap-tree.patch

