From: akpm@linux-foundation.org
Subject: + zram-use-notify_free-to-account-all-free-notifications.patch
 added to -mm tree
Date: Fri, 05 Sep 2014 12:43:22 -0700
Message-ID: <540a125a.QBaKFyd3hZ+zN8zr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIETnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 15:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, chao2.yu@samsung.com, ddstreet@ieee.org, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use notify_free to account all free notifications
has been added to the -mm tree.  Its filename is
     zram-use-notify_free-to-account-all-free-notifications.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-notify_free-to-account-all-free-notifications.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-notify_free-to-account-all-free-notifications.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use notify_free to account all free notifications

notify_free device attribute accounts the number of slot free
notifications and internally represents the number of zram_free_page()
calls.  Slot free notifications are sent only when device is used as a
swap device, hence notify_free is used only for swap devices.  Since
f4659d8e620d08 (zram: support REQ_DISCARD) ZRAM handles yet another one
free notification (also via zram_free_page() call) -- REQ_DISCARD
requests, which are sent by a filesystem, whenever some data blocks are
discarded.  However, there is no way to know the number of notifications
in the latter case.

Use notify_free to account the number of pages freed in zram_free_page(),
instead of accounting only swap_slot_free_notify() calls (each
zram_slot_free_notify() call frees one page).

This means that depending on usage scenario notify_free represents:
 a) the number of pages freed because of slot free notifications, which is
   equal to the number of swap_slot_free_notify() calls, so there is no
   behaviour change

 b) the number of pages freed because of REQ_DISCARD notifications

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Chao Yu <chao2.yu@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   13 ++++++++-----
 drivers/block/zram/zram_drv.c              |    2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-use-notify_free-to-account-all-free-notifications Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-use-notify_free-to-account-all-free-notifications
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -77,11 +77,14 @@ What:		/sys/block/zram<id>/notify_free
 Date:		August 2010
 Contact:	Nitin Gupta <ngupta@vflare.org>
 Description:
-		The notify_free file is read-only and specifies the number of
-		swap slot free notifications received by this device. These
-		notifications are sent to a swap block device when a swap slot
-		is freed. This statistic is applicable only when this disk is
-		being used as a swap disk.
+		The notify_free file is read-only. Depending on device usage
+		scenario it may account a) the number of pages freed because
+		of swap slot free notifications or b) the number of pages freed
+		because of REQ_DISCARD requests sent by bio. The former ones
+		are sent to a swap block device when a swap slot is freed, which
+		implies that this disk is being used as a swap disk. The latter
+		ones are sent by filesystem mounted with discard option,
+		whenever some data blocks are getting discarded.
 
 What:		/sys/block/zram<id>/zero_pages
 Date:		August 2010
diff -puN drivers/block/zram/zram_drv.c~zram-use-notify_free-to-account-all-free-notifications drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-notify_free-to-account-all-free-notifications
+++ a/drivers/block/zram/zram_drv.c
@@ -410,6 +410,7 @@ static void zram_free_page(struct zram *
 	atomic64_sub(zram_get_obj_size(meta, index),
 			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
+	atomic64_inc(&zram->stats.notify_free);
 
 	meta->table[index].handle = 0;
 	zram_set_obj_size(meta, index, 0);
@@ -938,7 +939,6 @@ static void zram_slot_free_notify(struct
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-	atomic64_inc(&zram->stats.notify_free);
 }
 
 static const struct block_device_operations zram_devops = {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-zram-memory-size-limitation-fix.patch
zram-report-maximum-used-memory.patch
zram-use-notify_free-to-account-all-free-notifications.patch

