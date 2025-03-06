Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054C19E98B;
	Thu,  6 Mar 2025 05:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239462; cv=none; b=Owmi50FW14X6w8HSCJU6TER1yGGLRT3Yy7QHEry18F4kD7sd8PnVtQp4ApxtLSRCMqlf0wo1ji7qcMrGtHcsWPVPfxM/g9s7Eyx1cwdYEPRWhCBMHKBjxaL0gqxE+xySreHt8272GZaXTNz4FbgXySVWTPu1IhSUeUVQAO5kB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239462; c=relaxed/simple;
	bh=CqAcfbVB7djTF4k+7w5s73aQeBbMhtUch9f/4LbuoBE=;
	h=Date:To:From:Subject:Message-Id; b=acDrMpllDePrqoLa1RTIzhPT7SjnF/E3loDpi8JZPVsCYjfIeee8HfNwG4pzuLxHLAged77xSMKASsTOB/gt9KOCjnLkQ4GfJm8qNve49wDmtNY+vp6peGtWPjDRf0CZtk7VSToXaFW/1Q6DLXCQOT3bjX8cN3BwZOMo7tX5HkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s01lFzh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s01lFzh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F4FC4CEE4;
	Thu,  6 Mar 2025 05:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239462;
	bh=CqAcfbVB7djTF4k+7w5s73aQeBbMhtUch9f/4LbuoBE=;
	h=Date:To:From:Subject:From;
	b=s01lFzh92Aawfnh56C9/7GQt0zxwG1fw9oVO8AOH3EOgvRIIc0BJgaytv+6gn8vJB
	 jznRDNaqweMUphJGE1YSNj35va1SenMpYYOZKyKkm4MXZYPrwjX72qCSZnc8yznMJg
	 QV/wKZZtvkn0J60EGq91hxI2+llXisWrKVpgYXNw=
Date: Wed, 05 Mar 2025 21:37:41 -0800
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache.patch removed from -mm tree
Message-Id: <20250306053742.36F4FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix kernel BUG when userfaultfd_move encounters swapcache
has been removed from the -mm tree.  Its filename was
     mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix kernel BUG when userfaultfd_move encounters swapcache
Date: Wed, 26 Feb 2025 13:14:00 +1300

userfaultfd_move() checks whether the PTE entry is present or a
swap entry.

- If the PTE entry is present, move_present_pte() handles folio
  migration by setting:

  src_folio->index = linear_page_index(dst_vma, dst_addr);

- If the PTE entry is a swap entry, move_swap_pte() simply copies
  the PTE to the new dst_addr.

This approach is incorrect because, even if the PTE is a swap entry,
it can still reference a folio that remains in the swap cache.

This creates a race window between steps 2 and 4.
 1. add_to_swap: The folio is added to the swapcache.
 2. try_to_unmap: PTEs are converted to swap entries.
 3. pageout: The folio is written back.
 4. Swapcache is cleared.
If userfaultfd_move() occurs in the window between steps 2 and 4,
after the swap PTE has been moved to the destination, accessing the
destination triggers do_swap_page(), which may locate the folio in
the swapcache. However, since the folio's index has not been updated
to match the destination VMA, do_swap_page() will detect a mismatch.

This can result in two critical issues depending on the system
configuration.

If KSM is disabled, both small and large folios can trigger a BUG
during the add_rmap operation due to:

 page_pgoff(folio, page) != linear_page_index(vma, address)

[   13.336953] page: refcount:6 mapcount:1 mapping:00000000f43db19c index:0xffffaf150 pfn:0x4667c
[   13.337520] head: order:2 mapcount:1 entire_mapcount:0 nr_pages_mapped:1 pincount:0
[   13.337716] memcg:ffff00000405f000
[   13.337849] anon flags: 0x3fffc0000020459(locked|uptodate|dirty|owner_priv_1|head|swapbacked|node=0|zone=0|lastcpupid=0xffff)
[   13.338630] raw: 03fffc0000020459 ffff80008507b538 ffff80008507b538 ffff000006260361
[   13.338831] raw: 0000000ffffaf150 0000000000004000 0000000600000000 ffff00000405f000
[   13.339031] head: 03fffc0000020459 ffff80008507b538 ffff80008507b538 ffff000006260361
[   13.339204] head: 0000000ffffaf150 0000000000004000 0000000600000000 ffff00000405f000
[   13.339375] head: 03fffc0000000202 fffffdffc0199f01 ffffffff00000000 0000000000000001
[   13.339546] head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
[   13.339736] page dumped because: VM_BUG_ON_PAGE(page_pgoff(folio, page) != linear_page_index(vma, address))
[   13.340190] ------------[ cut here ]------------
[   13.340316] kernel BUG at mm/rmap.c:1380!
[   13.340683] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[   13.340969] Modules linked in:
[   13.341257] CPU: 1 UID: 0 PID: 107 Comm: a.out Not tainted 6.14.0-rc3-gcf42737e247a-dirty #299
[   13.341470] Hardware name: linux,dummy-virt (DT)
[   13.341671] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   13.341815] pc : __page_check_anon_rmap+0xa0/0xb0
[   13.341920] lr : __page_check_anon_rmap+0xa0/0xb0
[   13.342018] sp : ffff80008752bb20
[   13.342093] x29: ffff80008752bb20 x28: fffffdffc0199f00 x27: 0000000000000001
[   13.342404] x26: 0000000000000000 x25: 0000000000000001 x24: 0000000000000001
[   13.342575] x23: 0000ffffaf0d0000 x22: 0000ffffaf0d0000 x21: fffffdffc0199f00
[   13.342731] x20: fffffdffc0199f00 x19: ffff000006210700 x18: 00000000ffffffff
[   13.342881] x17: 6c203d2120296567 x16: 6170202c6f696c6f x15: 662866666f67705f
[   13.343033] x14: 6567617028454741 x13: 2929737365726464 x12: ffff800083728ab0
[   13.343183] x11: ffff800082996bf8 x10: 0000000000000fd7 x9 : ffff80008011bc40
[   13.343351] x8 : 0000000000017fe8 x7 : 00000000fffff000 x6 : ffff8000829eebf8
[   13.343498] x5 : c0000000fffff000 x4 : 0000000000000000 x3 : 0000000000000000
[   13.343645] x2 : 0000000000000000 x1 : ffff0000062db980 x0 : 000000000000005f
[   13.343876] Call trace:
[   13.344045]  __page_check_anon_rmap+0xa0/0xb0 (P)
[   13.344234]  folio_add_anon_rmap_ptes+0x22c/0x320
[   13.344333]  do_swap_page+0x1060/0x1400
[   13.344417]  __handle_mm_fault+0x61c/0xbc8
[   13.344504]  handle_mm_fault+0xd8/0x2e8
[   13.344586]  do_page_fault+0x20c/0x770
[   13.344673]  do_translation_fault+0xb4/0xf0
[   13.344759]  do_mem_abort+0x48/0xa0
[   13.344842]  el0_da+0x58/0x130
[   13.344914]  el0t_64_sync_handler+0xc4/0x138
[   13.345002]  el0t_64_sync+0x1ac/0x1b0
[   13.345208] Code: aa1503e0 f000f801 910f6021 97ff5779 (d4210000)
[   13.345504] ---[ end trace 0000000000000000 ]---
[   13.345715] note: a.out[107] exited with irqs disabled
[   13.345954] note: a.out[107] exited with preempt_count 2

If KSM is enabled, Peter Xu also discovered that do_swap_page() may
trigger an unexpected CoW operation for small folios because
ksm_might_need_to_copy() allocates a new folio when the folio index
does not match linear_page_index(vma, addr).

This patch also checks the swapcache when handling swap entries. If a
match is found in the swapcache, it processes it similarly to a present
PTE.
However, there are some differences. For example, the folio is no longer
exclusive because folio_try_share_anon_rmap_pte() is performed during
unmapping.
Furthermore, in the case of swapcache, the folio has already been
unmapped, eliminating the risk of concurrent rmap walks and removing the
need to acquire src_folio's anon_vma or lock.

Note that for large folios, in the swapcache handling path, we directly
return -EBUSY since split_folio() will return -EBUSY regardless if
the folio is under writeback or unmapped. This is not an urgent issue,
so a follow-up patch may address it separately.

[v-songbaohua@oppo.com: minor cleanup according to Peter Xu]
  Link: https://lkml.kernel.org/r/20250226024411.47092-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20250226001400.9129-1-21cnbao@gmail.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   74 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache
+++ a/mm/userfaultfd.c
@@ -18,6 +18,7 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
+#include "swap.h"
 
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
@@ -1076,16 +1077,14 @@ out:
 	return err;
 }
 
-static int move_swap_pte(struct mm_struct *mm,
+static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 			 unsigned long dst_addr, unsigned long src_addr,
 			 pte_t *dst_pte, pte_t *src_pte,
 			 pte_t orig_dst_pte, pte_t orig_src_pte,
 			 pmd_t *dst_pmd, pmd_t dst_pmdval,
-			 spinlock_t *dst_ptl, spinlock_t *src_ptl)
+			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
+			 struct folio *src_folio)
 {
-	if (!pte_swp_exclusive(orig_src_pte))
-		return -EBUSY;
-
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1094,6 +1093,16 @@ static int move_swap_pte(struct mm_struc
 		return -EAGAIN;
 	}
 
+	/*
+	 * The src_folio resides in the swapcache, requiring an update to its
+	 * index and mapping to align with the dst_vma, where a swap-in may
+	 * occur and hit the swapcache after moving the PTE.
+	 */
+	if (src_folio) {
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
+	}
+
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
@@ -1141,6 +1150,7 @@ static int move_pages_pte(struct mm_stru
 			  __u64 mode)
 {
 	swp_entry_t entry;
+	struct swap_info_struct *si = NULL;
 	pte_t orig_src_pte, orig_dst_pte;
 	pte_t src_folio_pte;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -1322,6 +1332,8 @@ retry:
 				       orig_dst_pte, orig_src_pte, dst_pmd,
 				       dst_pmdval, dst_ptl, src_ptl, src_folio);
 	} else {
+		struct folio *folio = NULL;
+
 		entry = pte_to_swp_entry(orig_src_pte);
 		if (non_swap_entry(entry)) {
 			if (is_migration_entry(entry)) {
@@ -1335,9 +1347,53 @@ retry:
 			goto out;
 		}
 
-		err = move_swap_pte(mm, dst_addr, src_addr, dst_pte, src_pte,
-				    orig_dst_pte, orig_src_pte, dst_pmd,
-				    dst_pmdval, dst_ptl, src_ptl);
+		if (!pte_swp_exclusive(orig_src_pte)) {
+			err = -EBUSY;
+			goto out;
+		}
+
+		si = get_swap_device(entry);
+		if (unlikely(!si)) {
+			err = -EAGAIN;
+			goto out;
+		}
+		/*
+		 * Verify the existence of the swapcache. If present, the folio's
+		 * index and mapping must be updated even when the PTE is a swap
+		 * entry. The anon_vma lock is not taken during this process since
+		 * the folio has already been unmapped, and the swap entry is
+		 * exclusive, preventing rmap walks.
+		 *
+		 * For large folios, return -EBUSY immediately, as split_folio()
+		 * also returns -EBUSY when attempting to split unmapped large
+		 * folios in the swapcache. This issue needs to be resolved
+		 * separately to allow proper handling.
+		 */
+		if (!src_folio)
+			folio = filemap_get_folio(swap_address_space(entry),
+					swap_cache_index(entry));
+		if (!IS_ERR_OR_NULL(folio)) {
+			if (folio_test_large(folio)) {
+				err = -EBUSY;
+				folio_put(folio);
+				goto out;
+			}
+			src_folio = folio;
+			src_folio_pte = orig_src_pte;
+			if (!folio_trylock(src_folio)) {
+				pte_unmap(&orig_src_pte);
+				pte_unmap(&orig_dst_pte);
+				src_pte = dst_pte = NULL;
+				put_swap_device(si);
+				si = NULL;
+				/* now we can block and wait */
+				folio_lock(src_folio);
+				goto retry;
+			}
+		}
+		err = move_swap_pte(mm, dst_vma, dst_addr, src_addr, dst_pte, src_pte,
+				orig_dst_pte, orig_src_pte, dst_pmd, dst_pmdval,
+				dst_ptl, src_ptl, src_folio);
 	}
 
 out:
@@ -1354,6 +1410,8 @@ out:
 	if (src_pte)
 		pte_unmap(src_pte);
 	mmu_notifier_invalidate_range_end(&range);
+	if (si)
+		put_swap_device(si);
 
 	return err;
 }
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

