From: akpm@linux-foundation.org
Subject: + slub-use-non-atomic-bit-unlock.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:31:25 -0700
Message-ID: <200710231931.l9NJVPoe002887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbXJWTbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, clameter@sgi.com, npiggin@suse.de


The patch titled
     slub: use non-atomic bit unlock
has been added to the -mm tree.  Its filename is
     slub-use-non-atomic-bit-unlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: use non-atomic bit unlock
From: Nick Piggin <nickpiggin@yahoo.com.au>

Slub can use the non-atomic version to unlock because other flags will not
get modified with the lock held.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-use-non-atomic-bit-unlock mm/slub.c
--- a/mm/slub.c~slub-use-non-atomic-bit-unlock
+++ a/mm/slub.c
@@ -1183,7 +1183,7 @@ static __always_inline void slab_lock(st
 
 static __always_inline void slab_unlock(struct page *page)
 {
-	bit_spin_unlock(PG_locked, &page->flags);
+	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
 static __always_inline int slab_trylock(struct page *page)
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
git-mtd.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-use-non-atomic-bit-unlock.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
