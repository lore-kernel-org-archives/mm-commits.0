From: akpm@linux-foundation.org
Subject: - mm-vmalloc-search-restart-fix.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:59 -0800
Message-ID: <200811202042.mAKKgxv7007230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbYKTUo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@redhat.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc search restart fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-search-restart-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc search restart fix
From: Glauber Costa <glommer@redhat.com>

Current vmalloc restart search for a free area in case we can't find one. 
The reason is there are areas which are lazily freed, and could be
possibly freed now.  However, current implementation start searching the
tree from the last failing address, which is pretty much by definition at
the end of address space.  So, we fail.

The proposal of this patch is to restart the search from the beginning of
the requested vstart address.  This fixes the regression in running KVM
virtual machines for me, described in http://lkml.org/lkml/2008/10/28/349,
caused by commit db64fe02258f1507e13fe5212a989922323685ce.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-search-restart-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-search-restart-fix
+++ a/mm/vmalloc.c
@@ -324,14 +324,14 @@ static struct vmap_area *alloc_vmap_area
 
 	BUG_ON(size & ~PAGE_MASK);
 
-	addr = ALIGN(vstart, align);
