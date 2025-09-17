Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE7621B9DA;
	Wed, 17 Sep 2025 02:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758075666; cv=none; b=jGNByDeH5vbNqmhoXZA8xVnxMJj3XyzpihCqPEEWLF+J39SfUR6e1aeOgrBdrEfaEr2gqMpEZnXNKMinc5nQ1/CW/Dvt78p9YrMbAMUFD/RCerafOzjM/tNfsck2QTddVSC+TKdak9e0/UDY9ry0OGDOAcId2L0PSjIrC/7jSOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758075666; c=relaxed/simple;
	bh=C2RDa7LVGkOFfFMC5KfVWN3DNLs8O2uGWIPTW99YuPs=;
	h=Date:To:From:Subject:Message-Id; b=YhORL1F/pXEP+wXlFPX4/RoZscbrZdv8EFdedjOBvfja6VaN1qGEix/DaXxnGv1pqeOrA2yuaGQ9WLjRQv5pDIlez+4OYHkTPQU9m5EpckQJzpLf8DtOswuOy4O94x+mM7ezNqdakYc2+UurCOfuQMfCuWS7vJLMUGfix+a1R9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loOYuA6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loOYuA6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637CBC4CEEB;
	Wed, 17 Sep 2025 02:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758075665;
	bh=C2RDa7LVGkOFfFMC5KfVWN3DNLs8O2uGWIPTW99YuPs=;
	h=Date:To:From:Subject:From;
	b=loOYuA6dYcmWetgNsZtHIqQQCM8HbHGzah66e6zi923Aeg6M6QvqQKPNrwUIsr8J+
	 gb66KhZsnBQQWrWZXHRAHBo9ajmNF3bGhMAc+8PmBFMHluk1/2ZBhL7RwMfGDdsuaE
	 G9jqjtL6L7wCiqWK5RG+bvYfhrU5pTZyIRzVTdEs=
Date: Tue, 16 Sep 2025 19:21:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,minchan@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-off-by-one-error-in-vma-count-limit-checks.patch removed from -mm tree
Message-Id: <20250917022105.637CBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix off-by-one error in VMA count limit checks
has been removed from the -mm tree.  Its filename was
     mm-fix-off-by-one-error-in-vma-count-limit-checks.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: fix off-by-one error in VMA count limit checks
Date: Mon, 15 Sep 2025 09:36:32 -0700

The VMA count limit check in do_mmap() and do_brk_flags() uses a strict
inequality (>), which allows a process's VMA count to exceed the
configured sysctl_max_map_count limit by one.

A process with mm->map_count == sysctl_max_map_count will incorrectly pass
this check and then exceed the limit upon allocation of a new VMA when its
map_count is incremented.

Other VMA allocation paths, such as split_vma(), already use the correct,
inclusive (>=) comparison.

Fix this bug by changing the comparison to be inclusive in do_mmap() and
do_brk_flags(), bringing them in line with the correct behavior of other
allocation paths.

Link: https://lkml.kernel.org/r/20250915163838.631445-2-kaleshsingh@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 mm/vma.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-fix-off-by-one-error-in-vma-count-limit-checks
+++ a/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	/*
--- a/mm/vma.c~mm-fix-off-by-one-error-in-vma-count-limit-checks
+++ a/mm/vma.c
@@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vm
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
_

Patches currently in -mm which might be from kaleshsingh@google.com are


