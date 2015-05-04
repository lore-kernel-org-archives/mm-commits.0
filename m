From: akpm@linux-foundation.org
Subject: + zram-trivial-correct-flag-operations-comment.patch added to -mm tree
Date: Mon, 04 May 2015 15:57:07 -0700
Message-ID: <5547f943.muFXHqU7SrzksTcx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbEDW5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 18:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: trivial: correct flag operations comment
has been added to the -mm tree.  Its filename is
     zram-trivial-correct-flag-operations-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-trivial-correct-flag-operations-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-trivial-correct-flag-operations-comment.patch

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
Subject: zram: trivial: correct flag operations comment

We don't have meta->tb_lock anymore and use meta table entry bit_spin_lock
instead. update corresponding comment.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-trivial-correct-flag-operations-comment drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-trivial-correct-flag-operations-comment
+++ a/drivers/block/zram/zram_drv.c
@@ -70,7 +70,7 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-/* flag operations needs meta->tb_lock */
+/* flag operations require table entry bit_spin_lock() being held */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-add-compact-sysfs-entry-to-documentation.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

