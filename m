From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-do-not-vm_bug_on_page-for-temporary-on-stack-pages.patch removed
 from -mm tree
Date: Thu, 30 Jan 2014 12:05:18 -0800
Message-ID: <52eab07e.tMU0LZf8rihooMIV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaA3UFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, penberg@kernel.org, kirill@shutemov.name, dave.hansen@linux.intel.com

Subject: [merged] mm-slub-do-not-vm_bug_on_page-for-temporary-on-stack-pages.patch removed from -mm tree
To: dave.hansen@linux.intel.com,kirill@shutemov.name,penberg@kernel.org,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:18 -0800


The patch titled
     Subject: mm/slub.c: do not VM_BUG_ON_PAGE() for temporary on-stack pages
has been removed from the -mm tree.  Its filename was
     mm-slub-do-not-vm_bug_on_page-for-temporary-on-stack-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/slub.c: do not VM_BUG_ON_PAGE() for temporary on-stack pages

This patch:

	commit 309381feaee564281c3d9e90fbca8963bb7428ad
	Author: Sasha Levin <sasha.levin@oracle.com>
	Date:   Thu Jan 23 15:52:54 2014 -0800
	Subject: mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE

added a bunch of VM_BUG_ON_PAGE() calls.  But, most of the ones in the
slub code are for _temporary_ 'struct page's which are declared on the
stack and likely have lots of gunk in them.  Dumping their contents out
will just confuse folks looking at bad_page() output.  Plus, if we try to
page_to_pfn() on them or soemthing, we'll probably oops anyway.

Turn them back in to VM_BUG_ON()s.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~mm-slub-do-not-vm_bug_on_page-for-temporary-on-stack-pages mm/slub.c
--- a/mm/slub.c~mm-slub-do-not-vm_bug_on_page-for-temporary-on-stack-pages
+++ a/mm/slub.c
@@ -1559,7 +1559,7 @@ static inline void *acquire_slab(struct
 		new.freelist = freelist;
 	}
 
-	VM_BUG_ON_PAGE(new.frozen, &new);
+	VM_BUG_ON(new.frozen);
 	new.frozen = 1;
 
 	if (!__cmpxchg_double_slab(s, page,
@@ -1812,7 +1812,7 @@ static void deactivate_slab(struct kmem_
 			set_freepointer(s, freelist, prior);
 			new.counters = counters;
 			new.inuse--;
-			VM_BUG_ON_PAGE(!new.frozen, &new);
+			VM_BUG_ON(!new.frozen);
 
 		} while (!__cmpxchg_double_slab(s, page,
 			prior, counters,
@@ -1840,7 +1840,7 @@ redo:
 
 	old.freelist = page->freelist;
 	old.counters = page->counters;
-	VM_BUG_ON_PAGE(!old.frozen, &old);
+	VM_BUG_ON(!old.frozen);
 
 	/* Determine target state of the slab */
 	new.counters = old.counters;
@@ -1952,7 +1952,7 @@ static void unfreeze_partials(struct kme
 
 			old.freelist = page->freelist;
 			old.counters = page->counters;
-			VM_BUG_ON_PAGE(!old.frozen, &old);
+			VM_BUG_ON(!old.frozen);
 
 			new.counters = old.counters;
 			new.freelist = old.freelist;
@@ -2225,7 +2225,7 @@ static inline void *get_freelist(struct
 		counters = page->counters;
 
 		new.counters = counters;
-		VM_BUG_ON_PAGE(!new.frozen, &new);
+		VM_BUG_ON(!new.frozen);
 
 		new.inuse = page->objects;
 		new.frozen = freelist != NULL;
@@ -2319,7 +2319,7 @@ load_freelist:
 	 * page is pointing to the page from which the objects are obtained.
 	 * That page must be frozen for per cpu allocations to work.
 	 */
-	VM_BUG_ON_PAGE(!c->page->frozen, c->page);
+	VM_BUG_ON(!c->page->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
 	local_irq_restore(flags);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-slubc-fix-page-_count-corruption-again.patch
mm-slb-fix-misleading-comments.patch
linux-next.patch

