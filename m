From: akpm@linux-foundation.org
Subject: + slab-fix-crash-during-slab-init.patch added to -mm tree
Date: Wed, 08 May 2013 15:00:33 -0700
Message-ID: <20130508220033.77A535A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:40730 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3EHWAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 18:00:34 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so255334qab.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 15:00:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clmason@fusionio.com, chris.mason@fusionio.com, cl@linux.com, tony@atomide.com


The patch titled
     Subject: slab: fix crash during slab init
has been added to the -mm tree.  Its filename is
     slab-fix-crash-during-slab-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slab-fix-crash-during-slab-init.patch

