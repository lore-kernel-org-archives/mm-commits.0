From: akpm@linux-foundation.org
Subject: + mm-add-swap-slot-free-callback-to-block_device_operations-fix.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:50:38 -0800
Message-ID: <201001142350.o0ENoceI007181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787Ab0ANXun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:50:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ngupta@vflare.org, hugh.dickins@tiscali.co.uk


The patch titled
     mm-add-swap-slot-free-callback-to-block_device_operations-fix
has been added to the -mm tree.  Its filename is
     mm-add-swap-slot-free-callback-to-block_device_operations-fix.patch

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
Subject: mm-add-swap-slot-free-callback-to-block_device_operations-fix
From: Nitin Gupta <ngupta@vflare.org>

A block device makes swap_slot_free_notify() callback when the last
reference to a swap slot is dropped.

This callback is made under swap_lock and sometimes page table lock.  This
is a note of warning for registered callback function which must meet
these constraints.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations-fix include/linux/blkdev.h
--- a/include/linux/blkdev.h~mm-add-swap-slot-free-callback-to-block_device_operations-fix
+++ a/include/linux/blkdev.h
@@ -1294,6 +1294,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
_

Patches currently in -mm which might be from ngupta@vflare.org are

mm-add-swap-slot-free-callback-to-block_device_operations.patch
mm-add-swap-slot-free-callback-to-block_device_operations-fix.patch
ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch

