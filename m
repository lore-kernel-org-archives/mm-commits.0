Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EF93E95B4;
	Tue, 31 Mar 2026 22:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994837; cv=none; b=WejDuip6P/WpEjGTs751ELmnULmwLHvvbuHy540sYmzjgsWA6oZoDBlsGDfdTSGwAJEbtnCSGBLEHgu1JAMLWPJawh5vwqCIcWjzWjJDpQmJtD+wTVO1riv8vRRSryexYKlPqTOdVCNvc557zoTt+ra+Pjdco7x9P2bBGUqvNQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994837; c=relaxed/simple;
	bh=qyC9ZyMjs20Ve/U3RcH0RJfR/gYwTY1hzp0vIiSU0+g=;
	h=Date:To:From:Subject:Message-Id; b=t4jkh1f8SW6zJMPeU1oQKm2zLmcFvVy3TJu1G1SSs+BYDh1iN8ouly+LwWE0h4oh5Jj/IJ5c8un9pvgthqq1qV9LIzW4tXdSGdZ+1pxbudyl0gw21OIKabeMcuGQ4Jp/9n1dCnGmotDxWWnx5bb6TFQjFOer2MUORgc7m7c98KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MDzsc3M3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MDzsc3M3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D82EC19423;
	Tue, 31 Mar 2026 22:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774994837;
	bh=qyC9ZyMjs20Ve/U3RcH0RJfR/gYwTY1hzp0vIiSU0+g=;
	h=Date:To:From:Subject:From;
	b=MDzsc3M3R12I7+IaCDB+H68pidSgn37YfZyGUQC4sz29jxe69n5gVlf4XFQvVBOGC
	 1+E2e6xIz26RwahQ2ix30Wv4iViKKzzTp/1N0gk0eKFri2uPl94BbiWOu1N6uk5qHr
	 6NMUU4bPHMVU9r+PI9tPtJSyoxF/tgL4sb1mhGEw=
Date: Tue, 31 Mar 2026 15:07:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,rhkrqnwk98@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-fix-memory-leak-in-__mmap_region.patch added to mm-hotfixes-unstable branch
Message-Id: <20260331220717.2D82EC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: fix memory leak in __mmap_region()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-fix-memory-leak-in-__mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-fix-memory-leak-in-__mmap_region.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sechang Lim <rhkrqnwk98@gmail.com>
Subject: mm/vma: fix memory leak in __mmap_region()
Date: Tue, 31 Mar 2026 18:08:11 +0000

commit 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare
swaps the file") handled the success path by skipping get_file() via
file_doesnt_need_get, but missed the error path.

When /dev/zero is mmap'd with MAP_SHARED, mmap_zero_prepare() calls
shmem_zero_setup_desc() which allocates a new shmem file to back the
mapping. If __mmap_new_vma() subsequently fails, this replacement
file is never fput()'d - the original is released by
ksys_mmap_pgoff(), but nobody releases the new one.

Add fput() for the swapped file in the error path.

Reproducible with fault injection.

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 2 UID: 0 PID: 366 Comm: syz.7.14 Not tainted 7.0.0-rc6 #2 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x164/0x1f0
 should_fail_ex+0x525/0x650
 should_failslab+0xdf/0x140
 kmem_cache_alloc_noprof+0x78/0x630
 vm_area_alloc+0x24/0x160
 __mmap_region+0xf6b/0x2660
 mmap_region+0x2eb/0x3a0
 do_mmap+0xc79/0x1240
 vm_mmap_pgoff+0x252/0x4c0
 ksys_mmap_pgoff+0xf8/0x120
 __x64_sys_mmap+0x12a/0x190
 do_syscall_64+0xa9/0x580
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
BUG: memory leak
unreferenced object 0xffff8881118aca80 (size 360):
  comm "syz.7.14", pid 366, jiffies 4294913255
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff c0 28 4d ae ff ff ff ff  .........(M.....
  backtrace (crc db0f53bc):
    kmem_cache_alloc_noprof+0x3ab/0x630
    alloc_empty_file+0x5a/0x1e0
    alloc_file_pseudo+0x135/0x220
    __shmem_file_setup+0x274/0x420
    shmem_zero_setup_desc+0x9c/0x170
    mmap_zero_prepare+0x123/0x140
    __mmap_region+0xdda/0x2660
    mmap_region+0x2eb/0x3a0
    do_mmap+0xc79/0x1240
    vm_mmap_pgoff+0x252/0x4c0
    ksys_mmap_pgoff+0xf8/0x120
    __x64_sys_mmap+0x12a/0x190
    do_syscall_64+0xa9/0x580
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Found by syzkaller.

Link: https://lkml.kernel.org/r/20260331180811.1333348-1-rhkrqnwk98@gmail.com
Fixes: 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare swaps the file")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/vma.c~mm-vma-fix-memory-leak-in-__mmap_region
+++ a/mm/vma.c
@@ -2781,6 +2781,13 @@ unacct_error:
 	if (map.charged)
 		vm_unacct_memory(map.charged);
 abort_munmap:
+	/*
+	 * This indicates that .mmap_prepare has set a new file, differing from
+	 * desc->vm_file. But since we're aborting the operation, only the
+	 * original file will be cleaned up. Ensure we clean up both.
+	 */
+	if (map.file_doesnt_need_get)
+		fput(map.file);
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
_

Patches currently in -mm which might be from rhkrqnwk98@gmail.com are

mm-vma-fix-memory-leak-in-__mmap_region.patch

