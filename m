Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73EE34AB03;
	Fri, 10 Jul 2026 21:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718040; cv=none; b=VHsefMswJqHDT29I4b2oAZkDCZann64xI4GTS5wgVKvUKEHXso0RBUL4OFdluqx6moqIC+TGoRo0juuPJ0cLlfvsh3GUPM+8R0YwUlPAcrPoElGq8xmFXkzsjAKMGWTbKBEnRey9umYYy1xoszON5nRwwZoMvnbGVt+6EficTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718040; c=relaxed/simple;
	bh=2jNkSeGHmKz74qHwutetfraRgjGQ6xmhRvxb/i9MEnc=;
	h=Date:To:From:Subject:Message-Id; b=W+GXgpRepVZQRWv1ZfnaaJlZwrGIMWRU5nghyBf6+dj2KP2OgG1fhG5oxE4KnV2wqZazGs2DsRYI42Lm5k50YLXE+/y5JLs7mlzMeb4C91Y7vKLKcbKhVo7yY4s9qbCtPinNIhGfMVgoqN/8QKzh+zpRSJPyrnSgfZU8asCgcHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DGGXHLp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DGGXHLp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF61F000E9;
	Fri, 10 Jul 2026 21:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783718038;
	bh=x7tH793k9Jsv5uRtN86SydGoCVis2tauwfZGqIqnKtA=;
	h=Date:To:From:Subject;
	b=DGGXHLp91qyD8REcyph08bxP6SOYI25rXNzPGTN0z8yKuG23kwBi0diEx5aw/s06v
	 SCvGwryeBiGZJ5uGY/RkaVK+G7On9mg4hwtn5hs40jPfzV/gIDwaNM/yNs+NiZAiUS
	 ukYC0OtarIistJWsOo2+EGbD0/Hr/fNA3uy56Pgw=
Date: Fri, 10 Jul 2026 14:13:58 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,urezki@gmail.com,toshi.kani@hpe.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,liam@infradead.org,devnexen@gmail.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch added to mm-new branch
Message-Id: <20260710211358.70AF61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: acquire init_mm read lock on huge vmap promotion
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vmalloc: acquire init_mm read lock on huge vmap promotion
Date: Fri, 10 Jul 2026 11:49:18 +0100

Patch series "mm: fix UAF caused by race between ptdump and vmap".

Kernel page table walkers fall into two broad categories - those ranges
where no exclusion is required via walk_kernel_page_table_range_lockless()
and those where exclusion is required via walk_kernel_page_table_range()
or walk_page_range_debug().

The former category is used only by arm64 arch code operating on ranges it
both wholly owns and does not concurrently write.

The latter category consists of kernel page table walkers operating on
ranges that are wholly owned (but which need exclusion against concurrent
writers).

The lock used for exclusion is the mmap lock, and for kernel ranges this
the mmap lock on init_mm.

ptdump is a special case being both the only user of
walk_page_range_debug(), and the only case in which it walks ranges it
does not own.

This presents a problem, as page tables may be freed under ptdump.  And
indeed there is a use-after-free bug in the kernel as a result, which this
series addresses.

vmap promotes page tables to huge leaf entries where possible, freeing the
lower leaf page table when it does.  It does this with no meaningful locks
held against concurrent ptdump walks.

As a result, use-after-free can currently occur.  This series addresses
the issue by having the vmap huge promotion logic acquire the mmap read
lock while both setting the huge page table entry and freeing the prior
leaf page table.

The ptdump code already acquires the mmap write lock, so by doing so we
ensure that the ptdump walker only ever observes either the huge page
table entry or the existing page table entry, and nothing is freed
underneath it.

A mitigation for this issue was already applied for arm64 in commit
fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series
has to deal with carefully.

This mitigation resolves the issue by acquiring the mmap read lock on
init_mm on vmap page table free if a ptdump is in progress.

However the fix in this series would cause a deadlock if we were to simply
apply it for arm64 without also reverting the change.

This is because vmap may acquire the read lock before ptdump attempts to
acquire the write lock, which then gets queued, and rwsem starvation rules
mean that the (unacknowledged) nested mmap read lock in the arm64 code
would also block, meaning the original read lock is never released and
thus deadlock.

This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
lock in vmap logic, then partially reverting commit a93b45fd397 ("arm64:
Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
support, and removing the ifdeffery with the partial revert patch.


This patch (of 2):

Currently there is a nasty race between ptdump and vmap when attempting to
map a huge P4D, PMD or PUD entry.

ptdump is invoked by arch code to walk kernel or EFI page tables, either
to output it for debugging purposes, or to assert that there are no W+X
(i.e.  executable writable pages) exposed in these ranges.

The feature is enabled generally via CONFIG_PTDUMP (whose implementation
is in mm/ptdump.c), and expose a debugfs interface for it if
CONFIG_PTDUMP_DEBUGFS is defined.

If CONFIG_PTDUMP is enabled, then /sys/kernel/debug/check_wx_pages is
enabled which checks kernel ranges to perform the W+X check.  If
CONFIG_DEBUG_WX is enabled, this is done on boot.

(Note that arm32 implements its own page table walker and uses
CONFIG_ARM_DEBUG_WX and CONFIG_ARM_PTDUMP_DEBUGFS for this.)

The EFI implementations vary by architecture, but are not relevant to the
bug, as the issue is when kernel page ranges are walked.

ptdump_walk_pgd() holds both the mem hotplug lock and the mmap write lock
before invoking walk_page_range_debug(), however this runs into an issue
with vmalloc ranges.

When vmap maps a P4D, PUD or a PMD sized range and encounters an existing
P4d/PUD/PMD entry pointing to a PUD/PMD/PTE page table, it invokes
vmap_try_huge_[p4d,pud,pmd]() to try to convert it to a huge page table
mapping if possible.

However, when it does this, it holds no meaningful locks against other
kernel page table walkers, invoking
[p4d,pud,pmd]_free_[pud,pmd,pte]_page() which calls pagetable_free() and
pagetable_free_kernel() in turn (pte_fragment_free() for powerpc).

This means that a use-after-free becomes possible if the ptdump page table
walker happens to be walking a PUD, PMD or PTE page table after it has
been freed.

Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
tables"), if CONFIG_ASYNC_KERNEL_PGTABLE_FREE is set,
pagetable_free_kernel() will batch the page table freeing operation,
otherwise it frees the page table directly.

While the KASAN report that syzbot highlighted indicated that the issue
arose in a workqueue introduced by this change, this is coincidental and
the commit did not alter the race which has existed for quite some time.

This patch resolves the issue by simply having
vmap_try_huge_[p4d,pud,pmd]() hold the mmap read lock on init_mm while
invoking [p4d,pud,pmd]_free_[pud,pmd,pte]_page() and
[p4d,pud,pmd]_set_huge().

This way, page table walkers either observe a newly promoted huge
P4D/PUD/PMD leaf entry or the prior PUD/PMD/PTE entry and never get passed
a dangling pointer, whether the page is freed asynchronously or not.

All other kernel page table walkers that touch vmalloc ranges either
exclusively own the memory walked or acquire the mmap lock, so this
correctly excludes those walkers.

We acquire the mmap read lock as a trylock, as this is an optimisation
that is permitted not to succeed, a race is very unlikely, and doing so
eliminates latency sleeping on the lock would have otherwise caused.

We also define a guard class for mmap_read_trylock() so we can use
cleanup.h to make the scope handling cleaner in the implementation.

One wrinkle here is commit fa93b45fd397 ("arm64: Enable vmalloc-huge with
ptdump"), which addresses the issue for arm64 only by explicitly acquiring
the mmap read lock on kernel page table freeing should a concurrent ptdump
be in progress.

This is problematic as vmap may acquire the mmap read lock prior to ptdump
attempting to acquire an mmap write lock, leading to a deadlock when the
mmap read lock is slept upon on page table freeing due to rwsem
anti-starvation.

We work around this by predicating the mmap lock being taken on
!CONFIG_ARM64 for the time being.

With this patch applied, a follow up will partially revert commit
fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump") and at that stage
remove the arm64 ifdeffery.

We also update walk_page_range_debug() to assert the mmap write lock
unconditionally and update the comment here to reflect this change.

The issue has existed as long as ptdump was available and vmap freed page
tables when promoting to a huge leaf entry, that is, since commit
b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
for huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
mappings") for huge vmalloc.

Since the former is the earlier of the two we choose that for our Fixes
tag.

This patch is based on work by David Carlier (linked), with gratitude!

Link: https://lore.kernel.org/20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org
Link: https://lore.kernel.org/20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org
Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: David CARLIER <devnexen@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    1 
 mm/pagewalk.c             |   22 ++++++++-------
 mm/vmalloc.c              |   50 +++++++++++++++++++++++++++++-------
 3 files changed, 54 insertions(+), 19 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion
+++ a/include/linux/mmap_lock.h
@@ -621,6 +621,7 @@ static inline void mmap_read_unlock(stru
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {
--- a/mm/pagewalk.c~mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion
+++ a/mm/pagewalk.c
@@ -678,6 +678,8 @@ int walk_kernel_page_table_range_lockles
  * will also not lock the PTEs for the pte_entry() callback.
  *
  * This is for debugging purposes ONLY.
+ *
+ * The mmap write lock must be held.
  */
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
@@ -691,6 +693,16 @@ int walk_page_range_debug(struct mm_stru
 		.no_vma		= true
 	};
 
+	/*
+	 * When walking userland page tables, an mmap write lock must be held to
+	 * account for munmap() downgrading to an mmap read lock when tearing
+	 * down page tables.
+	 *
+	 * When walking kernel page tables, an mmap write lock must also be held
+	 * to account for page table freeing on vmap huge page mapping.
+	 */
+	mmap_assert_write_locked(mm);
+
 	/* For convenience, we allow traversal of kernel mappings. */
 	if (mm == &init_mm)
 		return walk_kernel_page_table_range(start, end, ops,
@@ -700,16 +712,6 @@ int walk_page_range_debug(struct mm_stru
 	if (!check_ops_safe(ops))
 		return -EINVAL;
 
-	/*
-	 * The mmap lock protects the page walker from changes to the page
-	 * tables during the walk.  However a read lock is insufficient to
-	 * protect those areas which don't have a VMA as munmap() detaches
-	 * the VMAs before downgrading to a read lock and actually tearing
-	 * down PTEs/page tables. In which case, the mmap write lock should
-	 * be held.
-	 */
-	mmap_assert_write_locked(mm);
-
 	return walk_pgd_range(start, end, &walk);
 }
 
--- a/mm/vmalloc.c~mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion
+++ a/mm/vmalloc.c
@@ -43,6 +43,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 #include <linux/page_owner.h>
+#include <linux/cleanup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmalloc.h>
@@ -176,10 +177,25 @@ static int vmap_try_huge_pmd(pmd_t *pmd,
 	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
 		return 0;
 
-	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
-		return 0;
+	if (!pmd_present(*pmd))
+		return pmd_set_huge(pmd, phys_addr, prot);
 
-	return pmd_set_huge(pmd, phys_addr, prot);
+	/*
+	 * Kernel page table walkers either walk ranges they own exclusively
+	 * using the mmap lock for mutual exclusion, or hold the mmap write lock
+	 * on init_mm (ptdump being the motivating case).
+	 *
+	 * Therefore, acquire the mmap read lock to prevent use-after-free when
+	 * freeing page tables.
+	 */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!pmd_free_pte_page(pmd, addr))
+			return 0;
+		return pmd_set_huge(pmd, phys_addr, prot);
+	}
 }
 
 static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
@@ -228,10 +244,18 @@ static int vmap_try_huge_pud(pud_t *pud,
 	if (!IS_ALIGNED(phys_addr, PUD_SIZE))
 		return 0;
 
-	if (pud_present(*pud) && !pud_free_pmd_page(pud, addr))
-		return 0;
+	if (!pud_present(*pud))
+		return pud_set_huge(pud, phys_addr, prot);
 
-	return pud_set_huge(pud, phys_addr, prot);
+	/* See comment in vmap_try_huge_pmd(). */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!pud_free_pmd_page(pud, addr))
+			return 0;
+		return pud_set_huge(pud, phys_addr, prot);
+	}
 }
 
 static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
@@ -280,10 +304,18 @@ static int vmap_try_huge_p4d(p4d_t *p4d,
 	if (!IS_ALIGNED(phys_addr, P4D_SIZE))
 		return 0;
 
-	if (p4d_present(*p4d) && !p4d_free_pud_page(p4d, addr))
-		return 0;
+	if (!p4d_present(*p4d))
+		return p4d_set_huge(p4d, phys_addr, prot);
 
-	return p4d_set_huge(p4d, phys_addr, prot);
+	/* See comment in vmap_try_huge_pmd(). */
+#ifndef CONFIG_ARM64
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
+#endif
+	{
+		if (!p4d_free_pud_page(p4d, addr))
+			return 0;
+		return p4d_set_huge(p4d, phys_addr, prot);
+	}
 }
 
 static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch

