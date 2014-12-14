From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-share-the-i_mmap_rwsem.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:06:44 -0800
Message-ID: <548d0cd4.PIoYPl9xOIRarKXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaLNEGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: share the i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     mm-memoryc-share-the-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/memory.c: share the i_mmap_rwsem

The unmap_mapping_range family of functions do the unmapping of user pages
(ultimately via zap_page_range_single) without touching the actual
interval tree, thus share the lock.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-share-the-i_mmap_rwsem mm/memory.c
--- a/mm/memory.c~mm-memoryc-share-the-i_mmap_rwsem
+++ a/mm/memory.c
@@ -2377,12 +2377,12 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

