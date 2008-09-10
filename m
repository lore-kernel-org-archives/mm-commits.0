From: akpm@linux-foundation.org
Subject: + mm-rewrite-vmap-layer-fix-fix-fix-fix.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:19:07 -0700
Message-ID: <200809102119.m8ALJ7cH026747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbYIJVTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:19:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickpiggin@yahoo.com.au, krzysztof.h1@wp.pl


The patch titled
     Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
has been added to the -mm tree.  Its filename is
     mm-rewrite-vmap-layer-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ramfs-and-ram-disk-pages-are-unevictable.patch
mm-rewrite-vmap-layer-fix-fix-fix-fix.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch

