From: akpm@linux-foundation.org
Subject: - use-warn-in-mm-vmallocc.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:16 -0700
Message-ID: <200807262116.m6QLGGpR019815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbYGZVQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in mm/vmalloc.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-mm-vmallocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in mm/vmalloc.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~use-warn-in-mm-vmallocc mm/vmalloc.c
--- a/mm/vmalloc.c~use-warn-in-mm-vmallocc
+++ a/mm/vmalloc.c
@@ -381,16 +381,14 @@ static void __vunmap(const void *addr, i
 		return;
 
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
-		printk(KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
 		return;
 	}
 
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
-		printk(KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
+		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);
-		WARN_ON(1);
 		return;
 	}
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch

