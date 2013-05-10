From: akpm@linux-foundation.org
Subject: [merged] slab-fix-crash-during-slab-init.patch removed from -mm tree
Date: Fri, 10 May 2013 12:14:48 -0700
Message-ID: <20130510191448.5F4C031C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:40682 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3EJTOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 15:14:49 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so424981qec.1
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 12:14:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clmason@fusionio.com, akpm@linux-foundation.org, chris.mason@fusionio.com, cl@linux.com, penberg@kernel.org, penguin-kernel@i-love.sakura.ne.jp, soren.brinkmann@xilinx.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix crash during slab init
has been removed from the -mm tree.  Its filename was
     slab-fix-crash-during-slab-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Mason <clmason@fusionio.com>
Subject: slab: fix crash during slab init

Commit 8a965b3b ("mm, slab_common: Fix bootstrap creation of kmalloc
caches") introduced a regression that caused us to crash early during
boot.  The commit was introducing ordering of slab creation, making sure
two odd-sized slabs were created after specific powers of two sizes.

But, if any of the power of two slabs were created earlier during boot,
slabs at index 1 or 2 might not get created at all.  This patch makes sure
none of the slabs get skipped.

Tony Lindgren bisected this down to the offending commit, which really
helped because bisect kept bringing me to almost but not quite this one.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/slab_common.c~slab-fix-crash-during-slab-init mm/slab_common.c
--- a/mm/slab_common.c~slab-fix-crash-during-slab-init
+++ a/mm/slab_common.c
@@ -446,18 +446,18 @@ void __init create_kmalloc_caches(unsign
 		if (!kmalloc_caches[i]) {
 			kmalloc_caches[i] = create_kmalloc_cache(NULL,
 							1 << i, flags);
+		}
 
-			/*
-			 * Caches that are not of the two-to-the-power-of size.
-			 * These have to be created immediately after the
-			 * earlier power of two caches
-			 */
-			if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
-				kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
+		/*
+		 * Caches that are not of the two-to-the-power-of size.
+		 * These have to be created immediately after the
+		 * earlier power of two caches
+		 */
+		if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
+			kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
 
-			if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
-				kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
-		}
+		if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
+			kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
 	}
 
 	/* Kmalloc array is now usable */
_

Patches currently in -mm which might be from clmason@fusionio.com are

origin.patch

