From: akpm@linux-foundation.org
Subject: - mm-rewrite-vmap-layer-fix-fix-fix-fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 15:59:12 -0700
Message-ID: <200810182259.m9IMxCZS025996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYJRW7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 18:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
has been removed from the -mm tree.  Its filename was
     mm-rewrite-vmap-layer-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-rewrite-vmap-layer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
From: Nick Piggin <nickpiggin@yahoo.com.au>

The virtual address allocator is allowing an overlapping allocation after
a vm_unmap_aliases() call.  Unfortunately, my "random" test case happened
not to trigger that...  I should have paid more attention to edge cases
rather than just random testing.

Tested-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-rewrite-vmap-layer-fix-fix-fix-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-rewrite-vmap-layer-fix-fix-fix-fix
+++ a/mm/vmalloc.c
@@ -321,7 +321,7 @@ retry:
 			struct vmap_area *tmp;
 			tmp = rb_entry(n, struct vmap_area, rb_node);
 			if (tmp->va_end >= addr) {
-				if (!first && tmp->va_start <= addr)
+				if (!first && tmp->va_start < addr + size)
 					first = tmp;
 				n = n->rb_left;
 			} else {
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
mm-rewrite-vmap-layer.patch
mm-rewrite-vmap-layer-fix-fix-fix-fix.patch
mm-stop-returning-enoent-from-sys_move_pages-if-nothing-got-migrated.patch
mm-dont-vmalloc-a-huge-page_to_node-array-for-do_pages_stat.patch
mm-extract-do_pages_move-out-of-sys_move_pages.patch
mm-rework-do_pages_move-to-work-on-page_sized-chunks.patch
mm-move_pages-no-need-to-set-pp-page-to-zero_page0-by-default.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

