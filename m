From: akpm@linux-foundation.org
Subject: + mm-vmalloc-tweak-failure-printk.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:18:31 -0800
Message-ID: <200811130018.mAD0IVqW015618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbYKMATS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@redhat.com, npiggin@suse.de


The patch titled
     mm: vmalloc tweak failure printk
has been added to the -mm tree.  Its filename is
     mm-vmalloc-tweak-failure-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-vmalloc-search-restart-fix.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch

