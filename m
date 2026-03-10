Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C669825D1E9;
	Tue, 10 Mar 2026 23:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773183753; cv=none; b=pAClz5o4ohTxB3NHnOak4gqk0vb5CtejBp5VD4x1i8xFBxBKpbNCeCKcuC40DYMstGn/7Fr6Z2m0EfWrrAfZnWwTzfGwibNlI7Dzu19amEuqsyShLDzmiIkb0m9LoiiPx9AdyWDNivKpOhkOtZFO7S9URd/OPbVfEIIRuHSTH7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773183753; c=relaxed/simple;
	bh=AwyUTp2LcQwvAHPr3pzyiSQTQqQZQjVTQuSI3OtEi1I=;
	h=Date:To:From:Subject:Message-Id; b=a5/APsCEvHbX1Atas/YbMdxvDzv6Y3f5idbozwsXl//3hPqS948ZWMxkBaTkTzqYsSShSrCafDWSLQnGcnO0srvj4xAzqV13xSgs4ILC/cBBv2+mexmM3WDu5nsMzhs4GHo/aakSRRk29b4rJmTHX9MC4qfxHwDBppa4hjevLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJ2Twkfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJ2Twkfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F674C19423;
	Tue, 10 Mar 2026 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773183753;
	bh=AwyUTp2LcQwvAHPr3pzyiSQTQqQZQjVTQuSI3OtEi1I=;
	h=Date:To:From:Subject:From;
	b=FJ2TwkfrEkR5a98KYrQpPunh9QVXjoQPxzoiiVN+gd0ibWrQ+tDpPd0zYZ5xMSHnH
	 JROruAkYmvBG2flOMMplyyBLRWcdv1LTvcUzM4HT+r02erOkqMNzDjtaVbDtJboEmW
	 GAyxxWXetFVrbeAPGnq9eB92BrsFspthb1Mbjf0o=
Date: Tue, 10 Mar 2026 16:02:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-rmap-fix-incorrect-pte-restoration-for-lazyfree-folios.patch removed from -mm tree
Message-Id: <20260310230233.7F674C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix incorrect pte restoration for lazyfree folios
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-incorrect-pte-restoration-for-lazyfree-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: fix incorrect pte restoration for lazyfree folios
Date: Tue, 3 Mar 2026 11:45:28 +0530

We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.  If the
batch has a mix of writable and non-writable bits, we may end up setting
the entire batch writable.  Fix this by respecting writable bit during
batching.

Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
lost, preserve it on pte restoration by respecting the bit during
batching, to make the fix consistent w.r.t both writable bit and
soft-dirty bit.

I was able to write the below reproducer and crash the kernel. 
Explanation of reproducer (set 64K mTHP to always):

Fault in a 64K large folio.  Split the VMA at mid-point with
MADV_DONTFORK.  fork() - parent points to the folio with 8 writable ptes
and 8 non-writable ptes.  Merge the VMAs with MADV_DOFORK so that
folio_unmap_pte_batch() can determine all the 16 ptes as a batch.  Do
MADV_FREE on the range to mark the folio as lazyfree.  Write to the memory
to dirty the pte, eventually rmap will dirty the folio.  Then trigger
reclaim, we will hit the pte restoration path, and the kernel will crash
with the trace given below.

The BUG happens at:

	BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);

The code path is asking for anonymous page to be mapped writable into the
pagetable.  The BUG_ON() firing implies that such a writable page has been
mapped into the pagetables of more than one process, which breaks
anonymous memory/CoW semantics.

[   21.134473] kernel BUG at mm/page_table_check.c:118!
[   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   21.135917] Modules linked in:
[   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
[   21.136858] Hardware name: linux,dummy-virt (DT)
[   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   21.137308] pc : page_table_check_set+0x28c/0x2a8
[   21.137607] lr : page_table_check_set+0x134/0x2a8
[   21.137885] sp : ffff80008a3b3340
[   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
[   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
[   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
[   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
[   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
[   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
[   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
[   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
[   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
[   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
[   21.141991] Call trace:
[   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
[   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
[   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
[   21.142766]  contpte_set_ptes+0xe8/0x140
[   21.142907]  try_to_unmap_one+0x10c4/0x10d0
[   21.143177]  rmap_walk_anon+0x100/0x250
[   21.143315]  try_to_unmap+0xa0/0xc8
[   21.143441]  shrink_folio_list+0x59c/0x18a8
[   21.143759]  shrink_lruvec+0x664/0xbf0
[   21.144043]  shrink_node+0x218/0x878
[   21.144285]  __node_reclaim.constprop.0+0x98/0x338
[   21.144763]  user_proactive_reclaim+0x2a4/0x340
[   21.145056]  reclaim_store+0x3c/0x60
[   21.145216]  dev_attr_store+0x20/0x40
[   21.145585]  sysfs_kf_write+0x84/0xa8
[   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
[   21.145994]  vfs_write+0x2b8/0x368
[   21.146119]  ksys_write+0x70/0x110
[   21.146240]  __arm64_sys_write+0x24/0x38
[   21.146380]  invoke_syscall+0x50/0x120
[   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
[   21.146679]  do_el0_svc+0x28/0x40
[   21.146798]  el0_svc+0x34/0x110
[   21.146926]  el0t_64_sync_handler+0xa0/0xe8
[   21.147074]  el0t_64_sync+0x198/0x1a0
[   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
[   21.147440] ---[ end trace 0000000000000000 ]---

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/wait.h>
#include <sched.h>
#include <fcntl.h>

void write_to_reclaim() {
    const char *path = "/sys/devices/system/node/node0/reclaim";
    const char *value = "409600000000";
    int fd = open(path, O_WRONLY);
    if (fd == -1) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    if (write(fd, value, sizeof("409600000000") - 1) == -1) {
        perror("write");
        close(fd);
        exit(EXIT_FAILURE);
    }

    printf("Successfully wrote %s to %s\n", value, path);
    close(fd);
}

int main()
{
	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if ((unsigned long)ptr != (1UL << 30)) {
		perror("mmap");
		return 1;
	}

	/* a 64K folio gets faulted in */
	memset(ptr, 0, 1UL << 16);

	/* 32K half will not be shared into child */
	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
		perror("madvise madv dontfork");
		return 1;
	}

	pid_t pid = fork();

	if (pid < 0) {
		perror("fork");
		return 1;
	} else if (pid == 0) {
		sleep(15);
	} else {
		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
			perror("madvise madv fork");
			return 1;
		}
		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
			perror("madvise madv free");
			return 1;
		}

		/* dirty the large folio */
		(*ptr) += 10;

		write_to_reclaim();
		// sleep(10);
		waitpid(pid, NULL, 0);

	}
}

Link: https://lkml.kernel.org/r/20260303061528.2429162-1-dev.jain@arm.com
Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-incorrect-pte-restoration-for-lazyfree-folios
+++ a/mm/rmap.c
@@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_p
 	if (userfaultfd_wp(vma))
 		return 1;
 
-	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
+	/*
+	 * If unmap fails, we need to restore the ptes. To avoid accidentally
+	 * upgrading write permissions for ptes that were not originally
+	 * writable, and to avoid losing the soft-dirty bit, use the
+	 * appropriate FPB flags.
+	 */
+	return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
+				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
 /*
_

Patches currently in -mm which might be from dev.jain@arm.com are

khugepaged-remove-redundant-index-check-for-pmd-folios.patch

