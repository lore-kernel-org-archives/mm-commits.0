From: akpm@linux-foundation.org
Subject: [merged] zram-use-size_t-instead-of-u16.patch removed from -mm
 tree
Date: Thu, 07 Aug 2014 13:06:51 -0700
Message-ID: <53e3dc5b.EZUrDOBnKSI8Je3x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35869 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaHGUGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:52 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so841543obc.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use size_t instead of u16
has been removed from the -mm tree.  Its filename was
     zram-use-size_t-instead-of-u16.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: use size_t instead of u16

Some architectures (eg, hexagon and PowerPC) could use PAGE_SHIFT of 16 or
more.  In these cases u16 is not sufficiently large to represent a
compressed page's size so use size_t.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-size_t-instead-of-u16 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-size_t-instead-of-u16
+++ a/drivers/block/zram/zram_drv.c
@@ -337,7 +337,7 @@ static int zram_decompress_page(struct z
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
-	u16 size;
+	size_t size;
 
 	read_lock(&meta->tb_lock);
 	handle = meta->table[index].handle;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

