From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area.patch added
 to -mm tree
Date: Tue, 17 Nov 2015 13:44:23 -0800
Message-ID: <564b9fb7.03d3mw00IoAX7d9g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbbKQVoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:44:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, aryabinin@virtuozzo.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: don't remove inexistent guard hole in remove_vm_area()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: mm: vmalloc: don't remove inexistent guard hole in remove_vm_area()

Commit 71394fe50146 ("mm: vmalloc: add flag preventing guard hole
allocation") missed a spot.  Currently remove_vm_area() decreases vm->size
to "remove" the guard hole page, even when it isn't present.  All but one
users just free the vm_struct rigth away and never access vm->size anyway.

Don't touch the size in remove_vm_area() and have __vunmap() use the
proper get_vm_area_size() helper.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area
+++ a/mm/vmalloc.c
@@ -1443,7 +1443,6 @@ struct vm_struct *remove_vm_area(const v
 		vmap_debug_free_range(va->va_start, va->va_end);
 		kasan_free_shadow(vm);
 		free_unmap_vmap_area(va);
-		vm->size -= PAGE_SIZE;
 
 		return vm;
 	}
@@ -1468,8 +1467,8 @@ static void __vunmap(const void *addr, i
 		return;
 	}
 
-	debug_check_no_locks_freed(addr, area->size);
-	debug_check_no_obj_freed(addr, area->size);
+	debug_check_no_locks_freed(addr, get_vm_area_size(area));
+	debug_check_no_obj_freed(addr, get_vm_area_size(area));
 
 	if (deallocate_pages) {
 		int i;
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area.patch

