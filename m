From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-remove-vm_vpages.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:24 -0800
Message-ID: <569973b4.GsiL5c6Ay3U5BmXM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbcAOWdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: remove VM_VPAGES
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-vm_vpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, vmalloc: remove VM_VPAGES

VM_VPAGES is unnecessary, it's easier to check is_vmalloc_addr() when
reading /proc/vmallocinfo.

[akpm@linux-foundation.org: remove VM_VPAGES reference via kvfree()]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 -
 mm/vmalloc.c            |    8 ++------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-remove-vm_vpages include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-remove-vm_vpages
+++ a/include/linux/vmalloc.h
@@ -14,7 +14,6 @@ struct vm_area_struct;		/* vma defining
 #define VM_ALLOC		0x00000002	/* vmalloc() */
 #define VM_MAP			0x00000004	/* vmap()ed pages */
 #define VM_USERMAP		0x00000008	/* suitable for remap_vmalloc_range */
-#define VM_VPAGES		0x00000010	/* buffer for pages was vmalloc'ed */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
diff -puN mm/vmalloc.c~mm-vmalloc-remove-vm_vpages mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-vm_vpages
+++ a/mm/vmalloc.c
@@ -1479,10 +1479,7 @@ static void __vunmap(const void *addr, i
 			__free_kmem_pages(page, 0);
 		}
 
-		if (area->flags & VM_VPAGES)
-			vfree(area->pages);
-		else
-			kfree(area->pages);
+		kvfree(area->pages);
 	}
 
 	kfree(area);
@@ -1592,7 +1589,6 @@ static void *__vmalloc_area_node(struct
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
 				PAGE_KERNEL, node, area->caller);
-		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
@@ -2650,7 +2646,7 @@ static int s_show(struct seq_file *m, vo
 	if (v->flags & VM_USERMAP)
 		seq_puts(m, " user");
 
-	if (v->flags & VM_VPAGES)
+	if (is_vmalloc_addr(v->pages))
 		seq_puts(m, " vpages");
 
 	show_numa_info(m, v);
_

Patches currently in -mm which might be from rientjes@google.com are


