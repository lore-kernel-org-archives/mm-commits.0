Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832538;
	b=y8+r3m7tzw9XSZ7vnl3tWvacXkCZ2qe+LPboUBff4LLZAhFDlao+XEFmmQp6b+4yKon+
	 TrHJinYeRIgaNA2jYFNl1jw5t0LDYx8190pd33ZNJguXAwebMA08I1t4c5sWBlfPPqA8o
	 ek0hrp7za74aMe3kLitRY+VLbxwLJFuavPex0LLZJBKzllxD2KaZ4hIaAl+pyAKpt/0xU
	 wtfAUTL6zDIrZLEH48kBRm7yxc45mi7gPAupTi/Hoqxz6AkR2hoLf0dCBdnsidn5eefQq
	 mbf6SuTh/Ucg0G3bcDdqOLaV+4odEK8aw391Dg2Oaj5Orbdy9rirE/N6aUz54WHNGlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832538;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gAsP5gtCLYqP7yWzios0wBdxc68jHD/QOc1Ds0GWkZk=;
	b=dz2nn/d1ptEKr4b370iw6E9LBNB3KlNBsKg45p8/lUCjgHcmOzCjHuo3aaF2LlU8BMVI
	 aAFoS4j/FlOcLf+GrvNMrSFKU5TRIdtNJo9swuRS4QZboHNLsUiYRTVkcOkBRAW0GpwUd
	 b0CeBILLZa3pz8A2OY5MFtZqkezj05Y+aUimvB2uHD5aHYoMnIkbDryGxK44B9V/1UzPu
	 w15LAzUpKuwzrPPU3mNYl6RBwL2gBGtNBz3h6Tp7zFsAM1A0f1RBq4rlPR6Z2O6pWc5us
	 JxHbxKjk+jt/PL0a6RjUtzeSqBnYxt5ClcUwrwXTMYjI4i/igMZpJacgeQWuABKLy9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SXrdVcGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F5B606A31D;
	Sat, 24 Oct 2026 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SXrdVcGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC29A1F01825;
	Sat, 24 Oct 2026 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832537;
	bh=gAsP5gtCLYqP7yWzios0wBdxc68jHD/QOc1Ds0GWkZk=;
	h=Date:To:From:Subject;
	b=SXrdVcGd7xC0H4Qtenr9FWhu+tyVU/3KR8xyNc5HispnI65OqH7CbSniZXeYXWy4w
	 Xt9VjXw92XbU3ee01yUOrN2qhB3PtykSYuc45hX+JXrkWLAY7MufHkVic4tHs3dS0U
	 AFjt316Ka12o2LyLEFUDChWJvPqRgkJvgkEA5nN0=
Date: Sat, 24 Oct 2026 02:02:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,ngocquy0700@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch removed from -mm tree
Message-Id: <20261024090217.BC29A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ngoc Quy <ngocquy0700@gmail.com>
Subject: fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Date: Wed, 14 Oct 2026 16:55:40 +0700

The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
/proc/<pid>/pagemap without holding a reference to mm_users.

proc_mem_open() deliberately grabs only mm_count, so a consumer that
touches the address space has to call mmget_not_zero() first.  Every other
consumer in this file does -- m_start(), do_procmap_query(),
show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does not.

Without that reference the target can reach exit_mmap() concurrently, and
exit_mmap() calls unmap_vmas() while holding mmap_lock only for reading,
which does not exclude the scanner.  For ordinary VMAs this is harmless,
as free_pgtables() and remove_vma() run afterwards under mmap_write_lock. 
A shared hugetlb VMA is different: __hugetlb_zap_end() frees the VMA's
hugetlb_vma_lock inside the read-locked phase.

walk_hugetlb_range() can therefore load vma->vm_private_data, have the
lock freed underneath it, and then down_read() a freed rw_semaphore.  The
load happens before the freeing side clears the pointer, so this is a
use-after-free and not a NULL dereference.  Any unprivileged user can
reach it with no huge pages configured, as hugetlb_reserve_pages()
allocates the lock before the VM_NORESERVE early return.

Pin mm_users across the scan, the way the other consumers do.  mmput()
from the exiting task can then no longer reach exit_mmap() while a walk is
in progress.

[akpm@linux-foundation.org: remove unneeded & undesirable test for !mm]
Link: https://lore.kernel.org/20261014095540.3261469-1-ngocquy0700@gmail.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Ngoc Quy <ngocquy0700@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: <stable@vger.kernel.org>
---

 fs/proc/task_mmu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan
+++ a/fs/proc/task_mmu.c
@@ -3120,15 +3120,18 @@ static long do_pagemap_scan(struct mm_st
 	size_t n_ranges_out = 0;
 	int ret;
 
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
 	ret = pagemap_scan_get_args(&p.arg, uarg);
 	if (ret)
-		return ret;
+		goto out_mmput;
 
 	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
 			      p.arg.return_mask;
 	ret = pagemap_scan_init_bounce_buffer(&p);
 	if (ret)
-		return ret;
+		goto out_mmput;
 
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
@@ -3183,6 +3186,8 @@ static long do_pagemap_scan(struct mm_st
 		ret = -EFAULT;
 
 	kfree(p.vec_buf);
+out_mmput:
+	mmput(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from ngocquy0700@gmail.com are


