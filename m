From: akpm@linux-foundation.org
Subject: - uml-fix-lvm-crash.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:18 -0700
Message-ID: <200703292337.l2TNbI3C015088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945922AbXC2Xhf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lunz@falooley.org, agk@redhat.com, blaisorblade@yahoo.it, jdike@linux.intel.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix LVM crash
has been removed from the -mm tree.  Its filename was
     uml-fix-lvm-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix LVM crash
From: Jason Lunz <lunz@falooley.org>

Permit lvm to create logical volumes without crashing UML.

When device-mapper's DM_DEV_CREATE_CMD ioctl is called to create a new device,
dev_create()->dm_create()->alloc_dev()-> blk_queue_bounce_limit(md->queue,
BLK_BOUNCE_ANY) is called.

blk_queue_bounce_limit(BLK_BOUNCE_ANY) calls init_emergency_isa_pool() if
blk_max_pfn < blk_max_low_pfn.  This is the case on UML, but
init_emergency_isa_pool() hits BUG_ON(!isa_page_pool) because there doesn't
seem to be a dma zone on UML for mempool_create() to allocate from.

Most architectures seem to have max_low_pfn == max_pfn, but UML doesn't
because of the uml_reserved chunk it keeps for itself.  From what I can see,
max_pfn and max_low_pfn don't get much use after the bootmem-allocator stops
being used anyway, except that they initialize the block layer's
blk_max_low_pfn/blk_max_pfn.

This ensures init_emergency_isa_pool() doesn't crash uml in this situation by
setting max_low_pfn == max_pfn in mem_init().

Signed-off-by: Jason Lunz <lunz@falooley.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-fix-lvm-crash arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-fix-lvm-crash
+++ a/arch/um/kernel/mem.c
@@ -64,8 +64,6 @@ static void setup_highmem(unsigned long 
 
 void mem_init(void)
 {
-	max_low_pfn = (high_physmem - uml_physmem) >> PAGE_SHIFT;
-
 	/* clear the zero-page */
 	memset((void *) empty_zero_page, 0, PAGE_SIZE);
 
@@ -80,6 +78,7 @@ void mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	totalram_pages = free_all_bootmem();
+	max_low_pfn = totalram_pages;
 #ifdef CONFIG_HIGHMEM
 	totalhigh_pages = highmem >> PAGE_SHIFT;
 	totalram_pages += totalhigh_pages;
_

Patches currently in -mm which might be from lunz@falooley.org are

origin.patch
git-wireless.patch
