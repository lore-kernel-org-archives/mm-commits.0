Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792458305;
	b=OYGOYDPVad0IEA+NgAZMR7yy0wIj3LB7cPyXTqI3mqZDeoG3dxKYUnS5PUODsos1W3Kq
	 PdlBnmSWuB53QUg/Er4wCbEUO54PVvjcGclVmpoVzkDmfIqJcDo95LC4Wxu5mUDPcEkKT
	 H9St1AEwLNZ4vr/nyEGvWNgxd0rMa5TNXCwlDxJfZAjMDdjJCs8Rx8g63XbBuYddcEkVC
	 rAz6V0VDW7xxU11supDJEzBme6r3hJgUDpeLGEXyToYWq8qLjgFQUBA6OAuvy2fVNpQSk
	 iMnIF2Fi9KqcyKjYCkPPtE2Xi43ib1FvI9pb+GhhboKpS5dNE0ZZbY9osE/gQKqI2ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792458305;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2Cp761GZx7EN8uZcWBFhe53Fn0HcZV08pSFIe6ffJa8=;
	b=KXiOOv6PRm+pETfYLlwT1+D85QIhb4WrfJ2yDYglpJ8tQPo+842Uu/amiTjFdjFJHOCB
	 MHparluWmgYc8GY/txw9Wzv5sxTE+ivR2seJbcOi2LHoJdGIJuQWL8Mj8a5sPnavyxT7J
	 f+Ke760pILntLGt3wuaHsrEAanuIYyY/XAfAYZoJe5ZDU/xGaU3ukp97dk23sE4QxPQHs
	 Gkxg30lkxoehQeFQ22uMlhfsr8mBhvMf0zC8GX/oz8EWALcXP21SQ7ET0PJ0e+NEqZHWS
	 eoBEV12wsPUIGnRS1MfQP+62IzMfhiTRSYRzYLS6hkwDJVeYdPovWLt0FXqNEtC5sug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mGvf29vk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A606B606A321;
	Tue, 20 Oct 2026 01:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mGvf29vk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DBD1F000C4;
	Tue, 20 Oct 2026 01:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792458304;
	bh=2Cp761GZx7EN8uZcWBFhe53Fn0HcZV08pSFIe6ffJa8=;
	h=Date:To:From:Subject;
	b=mGvf29vk8uMxWvIySpsapNsJM/xznDiMhXcYgSk/qyv88rAZ8R1XTK2Cwe1sZD2PF
	 tuU4s8TxH6AUeN/iV+VNQLZUkDrEIyUpknhXWbJiJUQAn/K5OitAMlMH/BTsdOD0S1
	 4E4DeBPrUREYO5Z4Eri4HXNXj+yM6vSM6wVblwBE=
Date: Mon, 19 Oct 2026 18:05:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,ngocquy0700@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch added to mm-unstable branch
Message-Id: <20261020010504.23DBD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch

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
@@ -3125,15 +3125,18 @@ static long do_pagemap_scan(struct mm_st
 	size_t n_ranges_out = 0;
 	int ret;
 
+	if (!mm || !mmget_not_zero(mm))
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
@@ -3188,6 +3191,8 @@ static long do_pagemap_scan(struct mm_st
 		ret = -EFAULT;
 
 	kfree(p.vec_buf);
+out_mmput:
+	mmput(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from ngocquy0700@gmail.com are

fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan.patch

