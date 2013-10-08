From: akpm@linux-foundation.org
Subject: [nacked]
 memstick-fix-memory-leak-in-memstick_check-error-path.patch removed from
 -mm tree
Date: Tue, 08 Oct 2013 15:01:52 -0700
Message-ID: <525480d0.YC1qiA8ibze0jJoi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3JHWBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 18:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oakad@yahoo.com, kay.sievers@vrfy.org, gregkh@linuxfoundation.org, catalin.marinas@arm.com, Larry.Finger@lwfinger.net

Subject: [nacked] memstick-fix-memory-leak-in-memstick_check-error-path.patch removed from -mm tree
To: Larry.Finger@lwfinger.net,catalin.marinas@arm.com,gregkh@linuxfoundation.org,kay.sievers@vrfy.org,oakad@yahoo.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 15:01:52 -0700


The patch titled
     Subject: memstick: fix memory leak in memstick_check() error path
has been removed from the -mm tree.  Its filename was
     memstick-fix-memory-leak-in-memstick_check-error-path.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: memstick: fix memory leak in memstick_check() error path

With kernel 3.12-rc3, kmemleak reports the following leak:

> unreferenced object 0xffff8800ae85c190 (size 16):
>   comm "kworker/u4:3", pid 685, jiffies 4294916336 (age 2831.760s)
>   hex dump (first 16 bytes):
>     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
>   backtrace:
>     [<ffffffff8146a0d1>] kmemleak_alloc+0x21/0x50
>     [<ffffffff81160720>] __kmalloc_track_caller+0x160/0x2f0
>     [<ffffffff81237b9b>] kvasprintf+0x5b/0x90
>     [<ffffffff8122c0c1>] kobject_set_name_vargs+0x21/0x60
>     [<ffffffff812e7f5c>] dev_set_name+0x3c/0x40
>     [<ffffffffa02bf918>] memstick_check+0xb8/0x340 [memstick]
>     [<ffffffff81069862>] process_one_work+0x1d2/0x670
>     [<ffffffff8106a88a>] worker_thread+0x11a/0x370
>     [<ffffffff81072ea6>] kthread+0xd6/0xe0
>     [<ffffffff81478bbc>] ret_from_fork+0x7c/0xb0

This problem was introduced by commit 0252c3b "memstick: struct device -
replace bus_id with dev_name(), dev_set_name()" where the name is not freed
in the error path. The name is also leaked in memstick_free_card().

Thanks to Catalin Marinas for suggesting the fix.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/memstick/core/memstick.c~memstick-fix-memory-leak-in-memstick_check-error-path drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-fix-memory-leak-in-memstick_check-error-path
+++ a/drivers/memstick/core/memstick.c
@@ -195,6 +195,7 @@ static void memstick_free_card(struct de
 {
 	struct memstick_dev *card = container_of(dev, struct memstick_dev,
 						 dev);
+	kfree(card->dev.kobj.name);
 	kfree(card);
 }
 
@@ -415,6 +416,7 @@ static struct memstick_dev *memstick_all
 	return card;
 err_out:
 	host->card = old_card;
+	kfree(card->dev.kobj.name);
 	kfree(card);
 	return NULL;
 }
_

Patches currently in -mm which might be from Larry.Finger@lwfinger.net are

linux-next.patch

