From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:57 -0700
Message-ID: <20121009181458.533EA5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:61367 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2JISPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:01 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365372wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix mapped pages avoiding unevictable list on mlock
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: fix mapped pages avoiding unevictable list on mlock

When a transparent hugepage is mapped and it is included in an mlock()
range, follow_page() incorrectly avoids setting the page's mlock bit and
moving it to the unevictable lru.

This is evident if you try to mlock(), munlock(), and then mlock() a
range again.  Currently:

	#define MAP_SIZE	(4 << 30)	/* 4GB */

	void *ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
			 MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	mlock(ptr, MAP_SIZE);

		$ grep -E "Unevictable|Inactive\(anon" /proc/meminfo
		Inactive(anon):     6304 kB
		Unevictable:     4213924 kB

	munlock(ptr, MAP_SIZE);

		Inactive(anon):  4186252 kB
		Unevictable:       19652 kB

	mlock(ptr, MAP_SIZE);

		Inactive(anon):  4198556 kB
		Unevictable:       21684 kB

Notice that less than 2MB was added to the unevictable list; this is
because these pages in the range are not transparent hugepages since the
4GB range was allocated with mmap() and has no specific alignment.  If
posix_memalign() were used instead, unevictable would not have grown at
all on the second mlock().

The fix is to call mlock_vma_page() so that the mlock bit is set and the
page is added to the unevictable list.  With this patch:

	mlock(ptr, MAP_SIZE);

		Inactive(anon):     4056 kB
		Unevictable:     4213940 kB

	munlock(ptr, MAP_SIZE);

		Inactive(anon):  4198268 kB
		Unevictable:       19636 kB

	mlock(ptr, MAP_SIZE);

		Inactive(anon):     4008 kB
		Unevictable:     4213940 kB

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |   11 ++++++++++-
 mm/memory.c             |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock
+++ a/include/linux/huge_mm.h
@@ -11,7 +11,7 @@ extern int copy_huge_pmd(struct mm_struc
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
-extern struct page *follow_trans_huge_pmd(struct mm_struct *mm,
+extern struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 					  unsigned long addr,
 					  pmd_t *pmd,
 					  unsigned int flags);
diff -puN mm/huge_memory.c~mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock
+++ a/mm/huge_memory.c
@@ -971,11 +971,12 @@ out_unlock:
 	return ret;
 }
 
-struct page *follow_trans_huge_pmd(struct mm_struct *mm,
+struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 				   unsigned long addr,
 				   pmd_t *pmd,
 				   unsigned int flags)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
 
 	assert_spin_locked(&mm->page_table_lock);
@@ -998,6 +999,14 @@ struct page *follow_trans_huge_pmd(struc
 		_pmd = pmd_mkyoung(pmd_mkdirty(*pmd));
 		set_pmd_at(mm, addr & HPAGE_PMD_MASK, pmd, _pmd);
 	}
+	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
+		if (page->mapping && trylock_page(page)) {
+			lru_add_drain();
+			if (page->mapping)
+				mlock_vma_page(page);
+			unlock_page(page);
+		}
+	}
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON(!PageCompound(page));
 	if (flags & FOLL_GET)
diff -puN mm/memory.c~mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock mm/memory.c
--- a/mm/memory.c~mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock
+++ a/mm/memory.c
@@ -1528,7 +1528,7 @@ struct page *follow_page(struct vm_area_
 				spin_unlock(&mm->page_table_lock);
 				wait_split_huge_page(vma->anon_vma, pmd);
 			} else {
-				page = follow_trans_huge_pmd(mm, address,
+				page = follow_trans_huge_pmd(vma, address,
 							     pmd, flags);
 				spin_unlock(&mm->page_table_lock);
 				goto out;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

