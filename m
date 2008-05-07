From: akpm@linux-foundation.org
Subject: + slub-fix-atomic-usage-in-any_slab_objects.patch added to -mm tree
Date: Tue, 06 May 2008 18:10:10 -0700
Message-ID: <200805070110.m471AAH4004198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYEGBKV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 21:10:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     slub: fix atomic usage in any_slab_objects()
has been added to the -mm tree.  Its filename is
     slub-fix-atomic-usage-in-any_slab_objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: fix atomic usage in any_slab_objects()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

any_slab_objects() does an atomic_read on an atomic_long_t, this
fixes it to use atomic_long_read instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-atomic-usage-in-any_slab_objects mm/slub.c
--- a/mm/slub.c~slub-fix-atomic-usage-in-any_slab_objects
+++ a/mm/slub.c
@@ -3775,7 +3775,7 @@ static int any_slab_objects(struct kmem_
 		if (!n)
 			continue;
 
-		if (atomic_read(&n->total_objects))
+		if (atomic_long_read(&n->total_objects))
 			return 1;
 	}
 	return 0;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

slub-fix-atomic-usage-in-any_slab_objects.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
macintosh-therm_pm72-driver_lock-semaphore-to-mutex.patch
macintosh-qindfarm_smu_sat-semaphore-to-mutex.patch
machintosh-adb-driver-adb_handler_sem-semaphore-to-mutex.patch
devres-add-devm_ioremap_prot.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch

