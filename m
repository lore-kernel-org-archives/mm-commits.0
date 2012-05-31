From: akpm@linux-foundation.org
Subject: [merged] mm-fix-faulty-initialization-in-vmalloc_init.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:30 -0700
Message-ID: <20120531191630.5BB4AA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34772 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932955Ab2EaTQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:16:32 -0400
Received: by lagr15 with SMTP id r15so75709lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pullip.cho@samsung.com, ohaugan@codeaurora.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix faulty initialization in vmalloc_init()
has been removed from the -mm tree.  Its filename was
     mm-fix-faulty-initialization-in-vmalloc_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KyongHo <pullip.cho@samsung.com>
Subject: mm: fix faulty initialization in vmalloc_init()

The transfer of ->flags causes some of the static mapping virtual
addresses to be prematurely freed (before the mapping is removed) because
VM_LAZY_FREE gets "set" if tmp->flags has VM_IOREMAP set.  This might
cause subsequent vmalloc/ioremap calls to fail because it might allocate
one of the freed virtual address ranges that aren't unmapped.  

va->flags has different types of flags from tmp->flags.  If a region with
VM_IOREMAP set is registered with vm_area_add_early(), it will be removed
by __purge_vmap_area_lazy().

Fix vmalloc_init() to correctly initialize vmap_area for the given
vm_struct.

Also initialise va->vm.  If it is not set, find_vm_area() for the early
vm regions will always fail.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Cc: "Olav Haugan" <ohaugan@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-fix-faulty-initialization-in-vmalloc_init mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-faulty-initialization-in-vmalloc_init
+++ a/mm/vmalloc.c
@@ -1185,9 +1185,10 @@ void __init vmalloc_init(void)
 	/* Import existing vmlist entries. */
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
-		va->flags = tmp->flags | VM_VM_AREA;
+		va->flags = VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
+		va->vm = tmp;
 		__insert_vmap_area(va);
 	}
 
_

Patches currently in -mm which might be from pullip.cho@samsung.com are

origin.patch

