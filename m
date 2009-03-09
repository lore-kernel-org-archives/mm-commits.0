From: akpm@linux-foundation.org
Subject: + hiddev-fix-incorrect-free.patch added to -mm tree
Date: Mon, 09 Mar 2009 15:59:44 -0700
Message-ID: <200903092259.n29MxiMR017181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbZCIXAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 19:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, jkosina@suse.cz, oliver@neukum.name


The patch titled
     hiddev: fix incorrect free
has been added to the -mm tree.  Its filename is
     hiddev-fix-incorrect-free.patch

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
Subject: hiddev: fix incorrect free
From: Johannes Weiner <hannes@cmpxchg.org>

If hiddev_open() fails, it wrongly frees the shared hiddev structure
kept in hiddev_table instead of the hiddev_list structure allocated
for the opened file descriptor.  Existing references to this structure
will then accessed free memory.

This was introduced by 079034073 "HID: hiddev cleanup -- handle all
error conditions properly".

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oliver Neukum <oliver@neukum.name>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hiddev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/usbhid/hiddev.c~hiddev-fix-incorrect-free drivers/hid/usbhid/hiddev.c
--- a/drivers/hid/usbhid/hiddev.c~hiddev-fix-incorrect-free
+++ a/drivers/hid/usbhid/hiddev.c
@@ -316,7 +316,7 @@ static int hiddev_open(struct inode *ino
 	return 0;
 bail:
 	file->private_data = NULL;
-	kfree(list->hiddev);
+	kfree(list);
 	return res;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
hiddev-fix-incorrect-free.patch
hiddev-fix-waitqueue-usage.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

