From: akpm@linux-foundation.org
Subject: [merged] uprobes-share-the-i_mmap_rwsem.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:06:32 -0800
Message-ID: <548d0cc8.KaPgrfa6xlxFLZxQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLNEGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uprobes: share the i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     uprobes-share-the-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: uprobes: share the i_mmap_rwsem

Both register and unregister call build_map_info() in order to create the
list of mappings before installing or removing breakpoints for every mm
which maps file backed memory.  As such, there is no reason to hold the
i_mmap_rwsem exclusively, so share it and allow concurrent readers to
build the mapping data.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/events/uprobes.c~uprobes-share-the-i_mmap_rwsem kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~uprobes-share-the-i_mmap_rwsem
+++ a/kernel/events/uprobes.c
@@ -724,7 +724,7 @@ build_map_info(struct address_space *map
 	int more = 0;
 
  again:
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
@@ -755,7 +755,7 @@ build_map_info(struct address_space *map
 		info->mm = vma->vm_mm;
 		info->vaddr = offset_to_vaddr(vma, offset);
 	}
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 
 	if (!more)
 		goto out;
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

