Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22D7484255
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865996; cv=none; b=LTSmNQPcwfKA/yie9rbvn/dM1nuzidT/dlEkHpVcygxHy+wtT4SecEZlCLmYPqXTzisGyYlOnMhecnJjLQ0KPQujz9g3gDRR9Y9E9McX2rGx402srHQtiWYVSHJ6S3benRoyaQZ1tay3hHR9Kxyqqv9JP+JGU2SJtLhfFG4I6tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865996; c=relaxed/simple;
	bh=nt6A7Z5zCGf1AuAXuKhD88/mRwnMEHh/oloSzo1MI4k=;
	h=Date:To:From:Subject:Message-Id; b=pjL8692F2bpMvrMJjs3s+LqMp054rxTrGN5zACEjYZ0WkfM9i2tndYzzJS7QACnc0I2IYBcPFXZj1Dj+jrT7l22DhK2/tTncfmRHD5Tgupkmhs4Pkp22p8HbKxf96KmGKxse0oWud38UeKWKR1662xcQTQ2m1Wa3YeT55/oK2HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EBpX7F0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EBpX7F0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DCB1F00898;
	Tue, 13 Oct 2026 04:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865993;
	bh=RO+HcrFbL6zgUWJRJTYRz9QvFT2Xf6WNlLophhn2vhQ=;
	h=Date:To:From:Subject;
	b=EBpX7F0eHmLIThTen2dGo/fp3HWqRV4dOiw9iRw5HY0rOxs7xdPgLZ0MP9ePJM810
	 1Lxyjob1Q/OCLGbt6bEbBSm1CGve9dS637HDaHXhVZi7H1nMYg4Gz6gg1K9fNmYE/Z
	 t5nog3t+l/sNGgkwbRPM9hqmh1TjaW7LYMHF7Usc=
Date: Mon, 12 Oct 2026 21:33:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,usama.arif@linux.dev,pfalcato@suse.de,paulmck@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch removed from -mm tree
Message-Id: <20261013043313.18DCB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
Date: Fri, 18 Sep 2026 08:33:14 -0700

smap_gather_stats() optimizes stats gathering by skipping the walk for
shmem mappings in certain conditions.  Update the comment to clarify these
conditions and use vma_is_cow_mapping() for CoW identification instead of
open-coding it.

No functional change intended.

Link: https://lore.kernel.org/20260918153318.758387-4-surenb@google.com
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 fs/proc/task_mmu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats
+++ a/fs/proc/task_mmu.c
@@ -1274,23 +1274,18 @@ static void smap_gather_stats(struct pro
 
 	if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
 		/*
-		 * For shared or readonly shmem mappings we know that all
-		 * swapped out pages belong to the shmem object, and we can
-		 * obtain the swap value much more efficiently. For private
-		 * writable mappings, we might have COW pages that are
-		 * not affected by the parent swapped out pages of the shmem
-		 * object, so we have to distinguish them during the page walk.
-		 * Unless we know that the shmem object (or the part mapped by
-		 * our VMA) has no swapped out pages at all.
+		 * CoW mappings might map anon folios that do not belong to
+		 * shmem. Perform a less efficient page table walk in this
+		 * situation, unless we know that the shmem object (or the
+		 * part mapped by our VMA) has no swapped out pages at all.
 		 */
-		unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const unsigned long shmem_swapped = shmem_swap_usage(vma);
+		const bool is_cow = vma_is_cow_mapping(vma);
 
-		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE))) {
-			mss->swap += shmem_swapped;
-		} else {
+		if (start || (shmem_swapped && is_cow))
 			ops = get_smaps_shmem_walk_ops(priv);
-		}
+		else
+			mss->swap += shmem_swapped;
 	}
 
 	if (!start)
_

Patches currently in -mm which might be from surenb@google.com are


