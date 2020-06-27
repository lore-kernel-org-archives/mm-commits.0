From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 openrisc-fix-boot-oops-when-debug_vm-is-enabled.patch removed from -mm tree
Date: Fri, 26 Jun 2020 20:32:58 -0700
Message-ID: <20200627033258.OLOhfdMp2%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0Dc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:32:59 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, jgg@ziepe.ca, jonas@southpole.se, mm-commits@vger.kernel.org, robin.murphy@arm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, steven.price@arm.com, thellstrom@vmware.com, vbabka@suse.cz, walken@google.com


The patch titled
     Subject: openrisc: fix boot oops when DEBUG_VM is enabled
has been removed from the -mm tree.  Its filename was
     openrisc-fix-boot-oops-when-debug_vm-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stafford Horne <shorne@gmail.com>
Subject: openrisc: fix boot oops when DEBUG_VM is enabled

Since v5.8-rc1 OpenRISC Linux fails to boot when DEBUG_VM is enabled. 
This has been bisected to commit 42fc541404f2 ("mmap locking API: add
mmap_assert_locked() and mmap_assert_write_locked()").

The added locking checks exposed the issue that OpenRISC was not taking
this mmap lock when during page walks for DMA operations.  This patch
locks and unlocks the mmap lock for page walking.

Link: http://lkml.kernel.org/r/20200617090247.1680188-1-shorne@gmail.com
Fixes: 42fc541404f2 ("mmap locking API: add mmap_assert_locked() and mmap_assert_write_locked()"
Signed-off-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Steven Price <steven.price@arm.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/dma.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/openrisc/kernel/dma.c~openrisc-fix-boot-oops-when-debug_vm-is-enabled
+++ a/arch/openrisc/kernel/dma.c
@@ -74,8 +74,11 @@ void *arch_dma_set_uncached(void *cpu_ad
 	 * We need to iterate through the pages, clearing the dcache for
 	 * them and setting the cache-inhibit bit.
 	 */
+	mmap_read_lock(&init_mm);
 	error = walk_page_range(&init_mm, va, va + size, &set_nocache_walk_ops,
 			NULL);
+	mmap_read_unlock(&init_mm);
+
 	if (error)
 		return ERR_PTR(error);
 	return cpu_addr;
@@ -85,9 +88,11 @@ void arch_dma_clear_uncached(void *cpu_a
 {
 	unsigned long va = (unsigned long)cpu_addr;
 
+	mmap_read_lock(&init_mm);
 	/* walk_page_range shouldn't be able to fail here */
 	WARN_ON(walk_page_range(&init_mm, va, va + size,
 			&clear_nocache_walk_ops, NULL));
+	mmap_read_unlock(&init_mm);
 }
 
 void arch_sync_dma_for_device(phys_addr_t addr, size_t size,
_

Patches currently in -mm which might be from shorne@gmail.com are
