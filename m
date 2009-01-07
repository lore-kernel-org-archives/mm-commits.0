From: akpm@linux-foundation.org
Subject: - mm-vmalloc-tweak-failure-printk.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:58 -0800
Message-ID: <200901072211.n07MBwIC012232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbZAGWMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@redhat.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc tweak failure printk
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-tweak-failure-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc tweak failure printk
From: Glauber Costa <glommer@redhat.com>

If we can't service a vmalloc allocation, show size of the allocation that
actually failed.  Useful for debugging.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-tweak-failure-printk mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-tweak-failure-printk
+++ a/mm/vmalloc.c
@@ -381,8 +381,9 @@ found:
 			goto retry;
 		}
 		if (printk_ratelimit())
-			printk(KERN_WARNING "vmap allocation failed: "
-				 "use vmalloc=<size> to increase size.\n");
+			printk(KERN_WARNING
+				"vmap allocation for size %lu failed: "
+				"use vmalloc=<size> to increase size.\n", size);
 		return ERR_PTR(-EBUSY);
 	}
 
_

Patches currently in -mm which might be from glommer@redhat.com are

origin.patch
linux-next.patch

