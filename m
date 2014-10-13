From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:45 -0700
Message-ID: <543c17fd.JslxbuEyJ7lLchp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbaJMSUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: Make paranoid check in move_freepages a VM_BUG_ON
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: Make paranoid check in move_freepages a VM_BUG_ON

Since 2.6.24 there has been a paranoid check in move_freepages that looks
up the zone of two pages.  This is a very slow path and the only time I've
seen this bug trigger recently is when memory initialisation was broken
during patch development.  Despite the fact it's a slow path, this patch
converts the check to a VM_BUG_ON anyway as it has served its purpose by
now.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on
+++ a/mm/page_alloc.c
@@ -1015,7 +1015,7 @@ int move_freepages(struct zone *zone,
 	 * Remove at a later date when no bug reports exist related to
 	 * grouping pages by mobility
 	 */
-	BUG_ON(page_zone(start_page) != page_zone(end_page));
+	VM_BUG_ON(page_zone(start_page) != page_zone(end_page));
 #endif
 
 	for (page = start_page; page <= end_page;) {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch

