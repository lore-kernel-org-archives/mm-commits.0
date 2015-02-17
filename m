From: akpm@linux-foundation.org
Subject: + zram-use-proper-type-to-update-max_used_pages.patch added to
 -mm tree
Date: Tue, 17 Feb 2015 14:08:45 -0800
Message-ID: <54e3bbed.tEquGTKN2HPwsmPl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbBQWIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 17:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use proper type to update max_used_pages
has been added to the -mm tree.  Its filename is
     zram-use-proper-type-to-update-max_used_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-proper-type-to-update-max_used_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-proper-type-to-update-max_used_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: zram: use proper type to update max_used_pages

max_used_pages is defined as atomic_long_t so we need to use unsigned long
to keep temporary value for it rather than int which is smaller than
unsigned long in a 64 bit system.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-proper-type-to-update-max_used_pages drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-proper-type-to-update-max_used_pages
+++ a/drivers/block/zram/zram_drv.c
@@ -528,7 +528,7 @@ out_cleanup:
 static inline void update_used_max(struct zram *zram,
 					const unsigned long pages)
 {
-	int old_max, cur_max;
+	unsigned long old_max, cur_max;
 
 	old_max = atomic_long_read(&zram->stats.max_used_pages);
 
_

Patches currently in -mm which might be from js1304@gmail.com are

zram-use-proper-type-to-update-max_used_pages.patch

